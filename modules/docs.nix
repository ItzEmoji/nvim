{ inputs, ... }:
{
  perSystem =
    { pkgs, ... }:
    let
      nvfConfig = inputs.nvf.lib.neovimConfiguration {
        inherit pkgs;
        modules = [ (inputs.import-tree ../conf) ];
      };
    in
    {
      packages.options-json = import ../nix/extract-options.nix {
        inherit pkgs;
        inherit (pkgs) lib;
        inherit (nvfConfig) options;
        confDir = ../conf;
      };
    };
}
