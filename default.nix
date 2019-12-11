{ pkgs ? (import <nixpkgs> {}) }:
with pkgs;
let
  hl = haskell.lib;

  ghcver = builtins.replaceStrings ["-" "."] ["" ""] pkgs.ghc.name;

  myHaskellPackages = pkgs.haskell.packages.${ghcver}.override {
    overrides = self: super: rec {
      haskell-lsp = self.callHackage "haskell-lsp" "0.17.0.0" {};
      haskell-lsp-types = self.callHackage "haskell-lsp-types" "0.17.0.0" {};
      lsp-test = hl.dontCheck (self.callHackage "lsp-test" "0.8.0.0" {});
      ghcide = hl.dontCheck (self.callHackage "ghcide" "0.0.4" {});
    };
  };

in {
  haskell-lsp_0_17_0_0 = myHaskellPackages.haskell-lsp;
  haskell-lsp-types_0_17_0_0 = myHaskellPackages.haskell-lsp-types;
  lsp-test_0_8_0_0 = myHaskellPackages.lsp-test;
  ghcide_0_0_4 = myHaskellPackages.ghcide;
}
