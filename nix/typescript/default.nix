{ pkgs }:

let
  inherit (pkgs) stdenv lib;

  package = lib.importJSON ../../typescript/package.json;
  yarnPkg = pkgs.mkYarnPackage rec {
    pname = package.name;
    version = package.version;
    src = null;
    dontUnpack = true;
    packageJSON = ../../typescript/package.json;
    yarnLock = ../../typescript/yarn.lock;

    preConfigure = ''
      mkdir ${package.name}
      cd ${package.name}
      ln -s ${packageJSON} ./package.json
      ln -s ${yarnLock} ./yarn.lock
    '';

    pkgConfig = { };
  };
in
stdenv.mkDerivation {
  name = "${package.name}-${package.version}";

  src = lib.cleanSourceWith {
    filter = name: type:
      !(lib.hasSuffix ".log" name) &&
      !(lib.hasSuffix ".nix" name) &&
      !(lib.hasSuffix "node_modules" name)
    ;
    src = ../../typescript;
  };

  buildInputs = [ pkgs.nodejs_20 yarnPkg pkgs.yarn pkgs.openssl pkgs.zlib pkgs.cacert ];

  patchPhase = ''
    echo ${yarnPkg}
    ln -s ${yarnPkg}/libexec/${package.name}/node_modules .
  '';

  buildPhase = ''
    # Yarn writes cache directories etc to $HOME.
    export HOME=$PWD/.yarn_home
    export PATH=$PWD/node_modules/.bin:$PATH

    yarn --enable-pnp --offline build
  '';

  installPhase = ''
    mkdir -p $out/public
    cp -r build/* $out/
  '';

  shellHook = ''
    rm -rf node_modules
    ln -sv ${yarnPkg}/libexec/${package.name}/node_modules .
    export PATH=$PWD/node_modules/.bin:$PATH
  '';
}
