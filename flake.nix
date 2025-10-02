{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nvf.url = "github:notashelf/nvf";
    nvf.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = { self, nixpkgs, nvf, ...}: {
    packages."x86_64-linux".default = (nvf.lib.neovimConfiguration {
      pkgs = nixpkgs.legacyPackages."x86_64-linux";
      modules = [ ./nvf-configuration.nix ];
    }).neovim;
  };
}
