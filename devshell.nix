{ pkgs }:

with pkgs;

# Configure your development environment.
#
# Documentation: https://github.com/numtide/devshell
devshell.mkShell {
  name = "friday-kata-nix";

  motd = ''
    Welcome to the friday-kata playground.

    If you see this message, it means your are inside the Nix shell.

    Command available:
    - TODO: add typescript related commands
  '';

  commands = [
    { package = pkgs.dbmate; }
  ];

  bash = {
    extra = ''
      export LD_INCLUDE_PATH="$DEVSHELL_DIR/include"
      export LD_LIB_PATH="$DEVSHELL_DIR/lib"
    '';
    interactive = "";
  };

  env = [
    {
      name = "OPENSSL_DIR";
      value = "${openssl.bin}/bin";
    }

    {
      name = "OPENSSL_LIB_DIR";
      value = "${openssl.out}/lib";
    }
    {
      name = "OPENSSL_INCLUDE_DIR";
      value = "${openssl.out.dev}/include";
    }
  ];

  packages = [
    # Build Tools
    ## Others
    binutils
    pkg-config
    openssl
    openssl.dev
    gcc
    glibc
    gmp.dev
    nixpkgs-fmt

    ## Javascript / Typescript
    nodejs_20
    yarn
    yarn2nix
  ];
}
