{ self, ... }:
{
  flake = {
    flakeModules.nvim = {
      perSystem = { pkgs, stdenv, ... }: {
        app.default = {
          program = "${self.packages.${stdenv.hostPlatform.system}.nvim}/bin/nvim";
        };
      };
    };
    nixosModules.nvim = { pkgs, ... }: {
      environment.systemPackages = [
        self.packages.${pkgs.system}.nvim 
      ]; 
    }; 
    homeManagerModules.nvim = { pkgs, ... }:  {
      home.packages = [
        self.packages.${pkgs.system}.nvim 
      ]; 
    };
  };
}
