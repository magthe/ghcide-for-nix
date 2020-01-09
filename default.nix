{ pkgs ? (import (builtins.fetchTarball {
                      name = "nixos-unstable-2020-01-09";
                      url = https://github.com/nixos/nixpkgs/archive/e1eedf29e5d22e6824e614d75449b75a2e3455d6.tar.gz;
                      sha256 = "1v237cgfkd8sb5f1r08sms1rxygjav8a1i1jjjxyqgiszzpiwdx7";
                  }) {}) }:
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
      ghcide = dontStuff (self.callHackageDirect {
        pkg ="ghcide";
        ver = "0.0.5";
        sha256 = "sha256:0z2jhbxx2aykn7iqyjrmfa57bn6a0dp1nk01kkqanb7sfc4fq1cc";
      } {});
      haskell-lsp = dontStuff (self.callHackageDirect {
        pkg = "haskell-lsp";
        ver = "0.18.0.0";
        sha256 = "sha256:0pd7kxfp2limalksqb49ykg41vlb1a8ihg1bsqsnj1ygcxjikziz";
      } {});
      haskell-lsp-types = dontStuff (self.callHackageDirect {
        pkg = "haskell-lsp-types";
        ver = "0.18.0.0";
        sha256 = "sha256:1s3q3d280qyr2yn15zb25kv6f5xcizj3vl0ycb4xhl00kxrgvd5f";
      } {});
      hie-bios = dontStuff (self.callHackageDirect {
        pkg = "hie-bios";
        ver = "0.2.1";
        sha256 = "sha256:0kc0iqrx3gcyf9f01mrns6jpx8qa6k3vn7kx4fa2j1s5vx7s9hp8";
      } {});
      shake = dontStuff (self.callHackageDirect {
        pkg = "shake";
        ver = "0.18.3";
        sha256 = "sha256:0fwcqnn2c97r7rmgq2hih3jbwbwp0smw1c9q8v6hh7p2jqkx2wsf";
      } {});
    };
  };

in {
  ghcide_0_0_5 = myHaskellPackages.ghcide;
  haskell-lsp_0_18_0_0 = myHaskellPackages.haskell-lsp;
  haskell-lsp-types_0_18_0_0 = myHaskellPackages.haskell-lsp-types;
  hie-bios_0_2_1 = myHaskellPackages.hie-bios;
  shake_0_18_3 = myHaskellPackages.shake;
}
