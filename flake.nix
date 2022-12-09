{
  description = "A Church Presentation Application";

  inputs = {
    cargo2nix.url = "github:cargo2nix/cargo2nix/release-0.11.0";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = inputs: with inputs;
    flake-utils.lib.eachDefaultSystem
      (system:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [cargo2nix.overlays.default];
          };
          src = ./.;
          rustPkgs = pkgs.rustBuilder.makePackageSet {
            rustVersion = "1.61.0";
            packageFun = import ./cargo.nix;
          };

        in rec
        {
          devShell = import ./shell.nix { inherit pkgs; };
          defaultPackage = pkgs.libsForQt5.callPackage ./default.nix {};
        }
      );
}
