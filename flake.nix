{
  description = "A Church Presentation Application";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem
      (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          src = ./.;
        in rec
        {
          devShell = import ./shell.nix { inherit pkgs; };
          defaultPackage = import ./default.nix { inherit pkgs; };
        }
      );
}
