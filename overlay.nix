final: prev:

{
  friday-kata = rec { nix = prev.callPackage ./nix { }; };
}

