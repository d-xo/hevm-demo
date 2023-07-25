{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    hevm.url = "github:ethereum/hevm";
    flake-utils.url = "github:numtide/flake-utils";
    foundry.url = "github:shazow/foundry.nix";
  };

  outputs = { self, nixpkgs, hevm, flake-utils, foundry, ... }:
    flake-utils.lib.eachDefaultSystem (system :
     let pkgs = nixpkgs.legacyPackages.${system}; in
       {
         devShell = pkgs.mkShell {
           buildInputs = [
             hevm.packages.${system}.default
             foundry.defaultPackage.${system}
           ];
         };
       });
}
