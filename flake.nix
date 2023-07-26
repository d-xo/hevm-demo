{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    hevm.url = "github:ethereum/hevm/default-to-no-ds-test";
    act.url = "github:ethereum/act";
    flake-utils.url = "github:numtide/flake-utils";
    foundry.url = "github:shazow/foundry.nix";
  };

  outputs = { self, nixpkgs, hevm, flake-utils, foundry, act, ... }:
    flake-utils.lib.eachDefaultSystem (system :
     let pkgs = nixpkgs.legacyPackages.${system}; in
       {
         devShell = pkgs.mkShell {
           buildInputs = [
             act.packages.${system}.default
             hevm.packages.${system}.default
             foundry.defaultPackage.${system}
             pkgs.solc
             pkgs.coq
           ];
         };
       });
}
