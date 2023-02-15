{pkgs, ...}: {
  # name = "project-name";
  #NOTE: need to chage flake.nix too!
  compiler-nix-name = "ghc8107"; # "ghc925"; # Version of GHC to use, 
  crossPlatforms = p: pkgs.lib.optionals pkgs.stdenv.hostPlatform.isx86_64 ([
    p.mingwW64
    p.ghcjs
  ] ++ pkgs.lib.optionals pkgs.stdenv.hostPlatform.isLinux [
    p.musl64
  ]);

  # Tools to include in the development shell
  shell.tools.cabal = "latest";
  # shell.tools.hlint = "latest";
  # shell.tools.haskell-language-server = "latest";
}
