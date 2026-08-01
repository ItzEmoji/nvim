{ ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      devShells.default = pkgs.mkShell {
        packages = [
          pkgs.bun
          pkgs.nodejs_22
          pkgs.jq
        ];
      };
    };
}
