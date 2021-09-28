let
  inherit (import ./.) pkgs backend;
in pkgs.linkFarm "ci" [
  {
    name = "ci-tools";
    path = pkgs.lib.symlinkJoin {
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
