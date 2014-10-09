let
  pkgs = import <nixpkgs> {};
  memoricidepkgs = import <memoricidepkgs> {};
  stdenv = pkgs.stdenv;
  elixir = import ./elixir.nix {};
in
{
  developmentEnv = stdenv.mkDerivation rec {
    name = "developmentEnv";
    version = "nightly";
    src = ./.;
    buildInputs = [
      pkgs.haskellPackages.wx
      pkgs.haskellPackages.ghc
      pkgs.haskellPackages.ConfigFile
      pkgs.haskellPackages.lens
    ];
  };
}
