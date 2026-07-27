# Extracts every nvf option that this repository's `conf/` files define, along with
# its evaluated value, into a single JSON file.
#
# Values and defaults cross into the renderer as structured data, never as
# pre-rendered text: forms with no JSON equivalent (Lua snippets, derivations,
# functions) are tagged with a `__type` marker so the renderer can decide how to
# present them. `default` follows the same shape as `value`, with one addition: when
# the option carries a `defaultText` (Nix source text describing the default, e.g.
# `pkgs.lib.mkDefault true`), it is tagged `{"__type":"nixExpression","code":"..."}`
# rather than evaluated, since it is already meant to be read as Nix source. When an
# option has neither `defaultText` nor `default`, the field is `null`.
{
  lib,
  pkgs,
  # The `options` attrset from `nvf.lib.neovimConfiguration`.
  options,
  # Path to this repository's `conf/` directory, used to tell our own definitions
  # apart from the ones nvf's internal modules make.
  confDir,
}:
let
  confPrefix = toString confDir;

  isOption = v: (v._type or null) == "option";
  isLuaInline = v: (v._type or null) == "lua-inline";

  # Recursively convert an evaluated value into JSON-safe data.
  serialize =
    depth: v:
    # Clamp recursion depth: some evaluated values (e.g. a module's internal `config`
    # sharing structure with itself, or a plugin's setup options wrapping arbitrary
    # attrsets) can be very deep or self-referential, and without a limit this would
    # risk a stack overflow rather than a clean `{__type = "elided";}` marker.
    if depth > 12 then
      { __type = "elided"; }
    else if v == null || builtins.isBool v || builtins.isInt v || builtins.isFloat v then
      v
    else if builtins.isString v then
      v
    else if builtins.isPath v then
      # Hazard: `toString` on a path literal copies it into the Nix store and yields
      # `/nix/store/<hash>-source/...`. No option in `conf/` uses a path literal as a
      # value or default today, but the moment one does, that store hash would land
      # in committed MDX and make the drift check flap on completely unrelated
      # changes (anything that alters the store path's hash). Not fixed here — this
      # just records the hazard for whoever adds one.
      toString v
    else if builtins.isFunction v then
      { __type = "function"; }
    else if builtins.isList v then
      map (serialize (depth + 1)) v
    else if lib.isDerivation v then
      {
        __type = "derivation";
        name = v.name or "<unnamed>";
        path = toString (v.outPath or "");
      }
    else if builtins.isAttrs v then
      if isLuaInline v then
        {
          __type = "lua";
          code = v.expr or "";
        }
      else
        lib.mapAttrs (_: serialize (depth + 1)) v
    else
      { __type = "unknown"; };

  # `tryEval` only forces to weak head normal form, so deepSeq the result to make
  # failures anywhere inside the structure catchable.
  safeSerialize =
    v:
    let
      attempt = builtins.tryEval (
        let
          s = serialize 0 v;
        in
        builtins.deepSeq s s
      );
    in
    if attempt.success then attempt.value else { __type = "error"; };

  # Render a description, which may be a plain string or an attrset with `.text`.
  textOf =
    v:
    if v == null then
      null
    else if builtins.isString v then
      v
    else if builtins.isAttrs v && v ? text then
      v.text
    else
      null;

  ourDefinitions =
    opt:
    lib.filter (d: lib.hasPrefix (confPrefix + "/") (toString d.file)) (
      opt.definitionsWithLocations or [ ]
    );

  relativeFile = f: "conf/" + lib.removePrefix (confPrefix + "/") (toString f);

  mkEntry = path: opt: defs: {
    name = lib.concatStringsSep "." path;
    type = opt.type.description or null;
    description = textOf (opt.description or null);
    default =
      if opt ? defaultText then
        let
          t = textOf opt.defaultText;
        in
        if t == null then null else { __type = "nixExpression"; code = t; }
      else if opt ? default then
        safeSerialize opt.default
      else
        null;
    value = safeSerialize opt.value;
    sourceFiles = lib.sort (a: b: a < b) (lib.unique (map (d: relativeFile d.file) defs));
  };

  walk =
    path: attrs:
    lib.concatLists (
      lib.mapAttrsToList (
        name: v:
        let
          p = path ++ [ name ];
        in
        if isOption v then
          let
            defs = ourDefinitions v;
          in
          if defs != [ ] then [ (mkEntry p v defs) ] else [ ]
        else if builtins.isAttrs v && !(lib.isDerivation v) then
          walk p v
        else
          [ ]
      ) attrs
    );

  # `_module.*` is module-system plumbing, not configuration.
  entries = lib.sort (a: b: a.name < b.name) (walk [ ] (removeAttrs options [ "_module" ]));

  payload = builtins.toJSON {
    schemaVersion = 1;
    options = entries;
  };
in
pkgs.runCommand "options.json"
  {
    inherit payload;
    passAsFile = [ "payload" ];
    nativeBuildInputs = [ pkgs.jq ];
  }
  ''
    # Sort keys and pretty-print so the committed output diffs cleanly.
    jq -S . < "$payloadPath" > "$out"
  ''
