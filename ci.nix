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
