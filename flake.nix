{
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.poetry2nix.url = "github:nix-community/poetry2nix";

  outputs = { nixpkgs, flake-utils, poetry2nix, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ poetry2nix.overlay ];
        };
        poetryPackages = builtins.listToAttrs (
          builtins.map 
            (pkg: { name = pkg.pname; value = pkg; })
            (pkgs.poetry2nix.mkPoetryPackages {
              projectDir = ./.;
            }).poetryPackages
          );
      in
      {
        defaultPackage = poetryPackages.opencv-python;
      });
}
