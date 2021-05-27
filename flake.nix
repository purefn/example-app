{
  description = "A very basic flake";

  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachSystem [ "x86_64-linux" ] (system:
      let
        overlays = [
          (final: prev: {
            terraform = prev.terraform_0_15;
          })
        ];
        pkgs = import nixpkgs { inherit system overlays; };
        deploy = pkgs.writeScript "deploy" ''
          echo ${pkgs.terraform}
          echo ${pkgs.aws-vault}
        '';
      in {
        packages.deploy = deploy;
        defaultPackage = deploy;
        devShell = pkgs.mkShell {
          buildInputs = with pkgs; [
            terraform
            aws-vault
          ];
        };
      }
    );
}
