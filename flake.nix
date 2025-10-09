{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nvf.url = "github:notashelf/nvf";
    nvf.inputs.nixpkgs.follows = "nixpkgs";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };
  outputs = { ... }@inputs:
  inputs.flake-parts.lib.mkFlake { inherit inputs; } {
    systems = [ "x86_64-linux" "x86_64-darwin" "aarch64-darwin" "aarch64-linux" ];
    perSystem = { pkgs, ... }: {
      packages.default = (inputs.nvf.lib.neovimConfiguration {
        inherit pkgs;
        modules = [ ./nvf-configuration.nix ];
      }).neovim;
    };
  };
}
