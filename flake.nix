{
  description = "ItzEmoji's Neovim (nvf) – prebuilt, cached, nix run friendly";

  nixConfig = {
    substituters = [
      "https://cache.itzemoji.com/nix"
      "https://cache.nixos.org"
    ];

    trusted-public-keys = [
      "nix:U22mA6l/Br6W9STnaHWO2LPvUCNVuh1yTEIlTCtjtkg="
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    nvf.url = "github:notashelf/nvf";
    nvf.inputs.nixpkgs.follows = "nixpkgs";

    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs@{ self, nixpkgs, flake-parts, nvf, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {

      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      perSystem = { system, pkgs, ... }:
        let
          nvimPackage =
            (nvf.lib.neovimConfiguration {
              inherit pkgs;
              modules = [ ./nvf-configuration.nix ];
            }).neovim;
        in {
          packages.default = nvimPackage;

          apps.default = {
            type = "app";
            program = "${nvimPackage}/bin/nvim";
          };
        };
    };
}

