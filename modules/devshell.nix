{ inputs, ... }:
{
  perSystem =
    { pkgs, system, ... }:
    {
      devShells.default = pkgs.mkShell {
        packages = [
          pkgs.bun
          pkgs.nodejs_22
          pkgs.jq
          # Puts `ndg` on PATH so ndg.toml can be run without vendoring a
          # prebuilt, x86_64-only binary into the repository.
          inputs.ndg.packages.${system}.ndg
        ];
      };
    };
}
