{ inputs, ... }:
{
  
      perSystem =
        { system, pkgs, ... }:
        let
          nvimPackage =
            (inputs.nvf.lib.neovimConfiguration {
              inherit pkgs;
              modules = [ (inputs.import-tree ../conf) ];
            }).neovim;
        in
        {
          packages.default = nvimPackage;
          packages.nvim = nvimPackage;
          apps.default = {
            type = "app";
            program = "${nvimPackage}/bin/nvim";
          };
        };
}
