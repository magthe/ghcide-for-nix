{ pkgs ? (import <nixpkgs> {}) }:
with pkgs;
let
  hl = haskell.lib;
  t = lib.trivial;

  ghcver = builtins.replaceStrings ["-" "."] ["" ""] pkgs.ghc.name;

  dontStuff = (t.flip t.pipe)
    [hl.dontCheck
     hl.dontCoverage
     hl.dontHaddock
     hl.disableLibraryProfiling
     hl.disableExecutableProfiling
    ];

  myHaskellPackages = pkgs.haskell.packages.${ghcver}.override {
    overrides = self: super: rec {
      haskell-lsp-types = dontStuff (self.callHackageDirect {
        pkg = "haskell-lsp-types";
        ver = "0.18.0.0";
        sha256 = "sha256:1s3q3d280qyr2yn15zb25kv6f5xcizj3vl0ycb4xhl00kxrgvd5f";
      } {});
      haskell-lsp = dontStuff (self.callHackageDirect {
        pkg = "haskell-lsp";
        ver = "0.18.0.0";
        sha256 = "sha256:0pd7kxfp2limalksqb49ykg41vlb1a8ihg1bsqsnj1ygcxjikziz";
      } {});
      ghcide = dontStuff (self.callHackageDirect {
        pkg ="ghcide";
        ver = "0.0.5";
        sha256 = "sha256:0z2jhbxx2aykn7iqyjrmfa57bn6a0dp1nk01kkqanb7sfc4fq1cc";
      } {});
    };
  };

in {
  haskell-lsp_0_18_0_0 = myHaskellPackages.haskell-lsp;
  haskell-lsp-types_0_18_0_0 = myHaskellPackages.haskell-lsp-types;
  # lsp-test_0_8_0_0 = myHaskellPackages.lsp-test;
  ghcide_0_0_5 = myHaskellPackages.ghcide;
}
