let
  nixpkgs = import (builtins.fetchTarball {
    name = "nixos-unstable-2020-01-09";
    url = https://github.com/NixOS/nixpkgs-channels/archive/441a181498a534256189b6494ddfc20c0755dfff.tar.gz;
    sha256 = "0bnfjy25yvydq5wxh9aypn876g5l1h4dsh512nz9dh8a0cb3bczc";
  }) { inherit config; };

  config = {
    allowUnfree = true;
    packageOverrides = pkgs:
      let
        ghcver = "ghc865";
        hl = pkgs.haskell.lib;
        t = pkgs.lib.trivial;

        dontAndDisable = (t.flip t.pipe)
          [hl.dontCheck
           hl.dontCoverage
           hl.dontHaddock
           hl.disableLibraryProfiling
           hl.disableExecutableProfiling
          ];
      in rec {
        ghcide = haskellPackages.ghcide;
        haskellPackages = pkgs.haskell.packages.${ghcver}.override {
          overrides = self: super: {
            ghcide = dontAndDisable (self.callHackageDirect {
              pkg ="ghcide";
              ver = "0.0.5";
              sha256 = "sha256:0z2jhbxx2aykn7iqyjrmfa57bn6a0dp1nk01kkqanb7sfc4fq1cc";
            } {});
            haskell-lsp = dontAndDisable (self.callHackageDirect {
              pkg = "haskell-lsp";
              ver = "0.18.0.0";
              sha256 = "sha256:0pd7kxfp2limalksqb49ykg41vlb1a8ihg1bsqsnj1ygcxjikziz";
            } {});
            haskell-lsp-types = dontAndDisable (self.callHackageDirect {
              pkg = "haskell-lsp-types";
              ver = "0.18.0.0";
              sha256 = "sha256:1s3q3d280qyr2yn15zb25kv6f5xcizj3vl0ycb4xhl00kxrgvd5f";
            } {});
            hie-bios = dontAndDisable (self.callHackageDirect {
              pkg = "hie-bios";
              ver = "0.2.1";
              sha256 = "sha256:0kc0iqrx3gcyf9f01mrns6jpx8qa6k3vn7kx4fa2j1s5vx7s9hp8";
            } {});
            shake = dontAndDisable (self.callHackageDirect {
              pkg = "shake";
              ver = "0.18.3";
              sha256 = "sha256:0fwcqnn2c97r7rmgq2hih3jbwbwp0smw1c9q8v6hh7p2jqkx2wsf";
            } {});
          };
        };
      };
  };

in nixpkgs
