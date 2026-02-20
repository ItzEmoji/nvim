{ self, ... }:
{
  flake = {
    flakeModules.nvim = {
      perSystem = { pkgs, system, ... }: {
        app.default = {
          program = "${self.packages.${system}.nvim}/bin/nvim";
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
