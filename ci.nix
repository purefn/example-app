let
  inherit (import ./.) pkgs backend;
in pkgs.linkFarm "ci" [
  {
    name = "docker-images";
    path = pkgs.linkFarm "docker-images"
      (pkgs.lib.mapAttrsToList
        (name: path: { inherit path; name = "${name}.tar.gz"; })
        backend.docker-images
      );
  }

  {
    name = "checks";
    path = pkgs.linkFarm "checks"
      (pkgs.lib.flatten
        (pkgs.lib.mapAttrsToList
          (pname: hsPkg:
            pkgs.lib.mapAttrsToList
              (tname: path: {
                inherit path;
                name = "${pname}/${tname}";
              })
              (pkgs.lib.filterAttrs (_: pkgs.lib.isDerivation) hsPkg.checks)
          )
          (pkgs.haskell-nix.haskellLib.selectProjectPackages backend)
        )
      );
  }

  {
    name = "ci-tools";
    path = pkgs.symlinkJoin {
      name = "ci-tools";
      paths = [
        (pkgs.writeShellScriptBin "push-app-spec" ''

        '')

        (pkgs.writeShellScriptBin "push-docker-images" ''

        '')
      ];
    };
  }
]
