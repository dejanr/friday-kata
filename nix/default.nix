{ pkgs }:
{
  typescript = pkgs.callPackage ./typescript { inherit pkgs; };
}
