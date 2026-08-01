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
      packages.keymaps-json = import ../nix/extract-keymaps.nix {
        inherit pkgs;
        inherit (pkgs) lib;
        inherit (nvfConfig) config;
      };
    };
}
