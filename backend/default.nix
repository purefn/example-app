{ haskell-nix
, dockerTools
}:
let
  project = haskell-nix.project {
    src = haskell-nix.haskellLib.cleanGit {
      name = "example-app-backend";
      src = ./..;
      subDir = "backend";
    };
    compiler-nix-name = "ghc8107";

    modules = [
      {
        dontStrip = false;
        enableSeparateDataOutput = true;
      }
    ];
  };
in project // {
  docker-images = {
    example-app-server = dockerTools.buildLayeredImage {
      name = "example-app-server";
      tag = "latest";

      contents = [
        project.example-app-server.components.exes.example-app-server
      ];

      config = {
        Cmd = [ "${project.example-app-server.components.exes.example-app-server}/bin/example-app-server" ];
        ExposedPorts = {
          "8080/tcp" = {};
        };
      };
    };
  };
}

