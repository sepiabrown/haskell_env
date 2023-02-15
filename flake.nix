{
  # This is a template created by `hix init`
  inputs.haskellNix.url = "github:input-output-hk/haskell.nix/706554cce6ebf4bdffbf50a2f65744bbbc73f824";
  # haskellNix/hackage github:input-output-hk/hackage.nix/02de1352507ab1c40de1f87c9afd0c8fc6f60bad
  # haskellNix/stackage github:input-output-hk/stackage.nix/f9e7f4b96b26865e0a49ec29e03147fe65336248
  inputs.nixpkgs.follows = "haskellNix/nixpkgs-unstable";
  inputs.nixpkgs_unstable.url = "nixpkgs/nixos-unstable"; # 5a350a8f31bb7ef0c6e79aea3795a890cf7743d4
  inputs.flake-utils.url = "github:numtide/flake-utils";
  outputs = { self, nixpkgs, nixpkgs_unstable, flake-utils, haskellNix }:
    let
      supportedSystems = [
        "x86_64-linux"
        #"x86_64-darwin"
        #"aarch64-linux"
        #"aarch64-darwin"
      ];
      extension = "github.copilot-1.71.8269";
      #extension = "jnoortheen.nix-ide-0.2.1";
      #extension = "hoovercj.haskell-linter-0.0.6";
      #extension = "arrterian.nix-env-selector-1.0.9";
      #extension = "formulahendry.code-runner-0.12.0";
      #extension = "gattytto.phoityne-vscode-0.0.29";
      #extension = "quarto.quarto-1.61.0";
    in
      flake-utils.lib.eachSystem supportedSystems (system:
      let
        overlays = [ haskellNix.overlay
          (final: prev: {
            hixProject =
              final.haskell-nix.hix.project {
                src = ./.;
                #NOTE: need to change nix/hix.nix too!
                compiler-nix-name = "ghc8107"; # "ghc925";#

                #evalSystem = "x86_64-linux";
                #index-state = "2022-11-06T00:00:00Z"; #"2022-08-05T00:00:00Z";

                # This is used by `nix develop .` to open a shell for use with
                # `cabal`, `hlint` and `haskell-language-server`
                shell.tools = {
                  # cabal = ""; # seems to automatically install
                  hlint = "3.4"; # "latest"=="3.5"
                  haskell-language-server = "1.8.0.0"; # "latest"=="1.9.0.0"
                };
                # Non-Haskell shell tools go here
                shell.buildInputs = with pkgs; [
                  nixpkgs-fmt
                  pkgs_unstable.code-server
                  bashInteractive
                ];
                shell.shellHook = pkgs.lib.optionalString (! builtins.pathExists (/home/sepiabrown/.local/share/code-server/extensions + "/${extension}")) ''
                  ext="${extension}"
                  URL=`echo $ext | sed -rn 's/(.*)\.(.*)-(.*)/https:\/\/marketplace.visualstudio.com\/_apis\/public\/gallery\/publishers\/\1\/vsextensions\/\2\/\3\/vspackage/p'`
                  echo "Downloading $URL to $ext.vsix..."
                  temp_dir=$(mktemp -d)
                  curl --compressed -s $URL -o $temp_dir/temp.vsix
                  ${pkgs_unstable.code-server}/bin/code-server --install-extension $temp_dir/temp.vsix
                  echo $temp_dir
                  rm -rf $temp_dir
                '';
              };
          })
        ];
        pkgs = import nixpkgs { inherit system overlays; inherit (haskellNix) config; };
        pkgs_unstable = import nixpkgs_unstable { inherit system overlays; inherit (haskellNix) config; };
        flake = pkgs.hixProject.flake {};
      in flake // {
        legacyPackages = pkgs;
      });

  # --- Flake Local Nix Configuration ----------------------------
  nixConfig = {
    # This sets the flake to use the IOG nix cache.
    # Nix should ask for permission before using it,
    # but remove it here if you do not want it to.
    extra-substituters = ["https://cache.iog.io" "https://cache.zw3rk.com"];
    extra-trusted-public-keys = ["hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ=" "loony-tools:pr9m4BkM/5/eSTZlkQyRt57Jz7OMBxNSUiMC4FkcNfk="];
    allow-import-from-derivation = "true";
  };
}
