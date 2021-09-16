let
  sources = import ./nix/sources.nix {};
  haskellNix = import sources.haskellNix {};
  pkgs = import
    haskellNix.sources.nixpkgs
    (haskellNix.nixpkgsArgs // {
      overlays = haskellNix.nixpkgsArgs.overlays ++ [
        (final: prev: {
          terraform = prev.terraform_0_15;
        })
      ];
    });
  backend = pkgs.callPackage ./backend {};
in {
  inherit pkgs backend;

}
