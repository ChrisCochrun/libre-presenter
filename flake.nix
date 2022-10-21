{
  description = "A Church Presentation Application";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem
      (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          src = ./.;
        in 
        {
          devShell = import ./shell.nix { inherit pkgs; };
          defaultPackage = pkgs.libsForQt5.callPackage ./default.nix {};
        }
      );
}
