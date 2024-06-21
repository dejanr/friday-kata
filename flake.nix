{
  description = "friday-kata";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    devshell.url = "github:numtide/devshell/main";
    nix-npm-buildpackage.url = "github:serokell/nix-npm-buildpackage";
  };

  outputs = { self, nixpkgs, flake-utils, devshell, nix-npm-buildpackage, treefmt-nix }:

    {
      overlays.default = import ./overlay.nix;
    }

    //

    (
      let
        overlays = [ ];

      in
      flake-utils.lib.eachDefaultSystem (system:

        let
          pkgs = import nixpkgs {
            inherit system;

            config = {
              allowBroken = false;
              permittedInsecurePackages = [
              ];
            };

            overlays = [
              devshell.overlays.default
              nix-npm-buildpackage.overlays.default
              self.overlays.default
            ];
          };
          format = treefmt-nix.lib.evalModule pkgs (pkgs: {
            projectRootFile = "flake.nix";
            settings.global.excludes = [ ];

            programs.nixpkgs-fmt.enable = true;
            programs.prettier.enable = true;
          });
        in
        {
          legacyPackages = pkgs.friday-kata;
          packages = flake-utils.lib.flattenTree pkgs.friday-kata;
          devShell = import ./devshell.nix { inherit pkgs; };
          formatter = format.config.build.wrapper;
          checks.formatting = format.config.build.check self;
        })
    );
}
