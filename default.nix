let
  nixpkgs = import (builtins.fetchTarball {
    name = "nixpkgs-unstable-2020-01-26";
    url = https://github.com/NixOS/nixpkgs-channels/archive/62d86db572901a960838d4d5acadc039b207cfef.tar.gz;
    sha256 = "sha256:07xdzv1wn1mnswn0xx6mz0ldbjqmdhylzpvhhk3kpq8zm4j7xymh";
  }) { inherit config; };

  config = {
    allowUnfree = true;
    packageOverrides = pkgs:
      let
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
        haskellPackages = pkgs.haskellPackages.override {
          overrides = self: super: {
            ghcide = dontAndDisable (self.callHackageDirect {
              pkg ="ghcide";
              ver = "0.0.6";
              sha256 = "sha256:0wa1z5pig00i32hpy34dzbrw224sz5jika83ixbm76s6iz8ai7zc";
            } {
              haskell-lsp-types = self.haskell-lsp-types_0_19_0_0;
              haskell-lsp = self.haskell-lsp_0_19_0_0;
              regex-tdfa = self.regex-tdfa_1_3_1_0;
            });
            haskell-lsp_0_19_0_0 = dontAndDisable (self.callHackageDirect {
              pkg = "haskell-lsp";
              ver = "0.19.0.0";
              sha256 = "sha256:1v0r57g2dhradnjnvp40jmv5swawg9k3d735kj50dca1gbx66y0c";
            } {
              haskell-lsp-types = self.haskell-lsp-types_0_19_0_0;
            });
            haskell-lsp-types_0_19_0_0 = dontAndDisable (self.callHackageDirect {
              pkg = "haskell-lsp-types";
              ver = "0.19.0.0";
              sha256 = "sha256:1z0c9c2zjb4ad3ffzng9njyn9ci874xd8mmqwnvnm3hyncf1430g";
            } {});
            hie-bios = dontAndDisable (self.callHackageDirect {
              pkg = "hie-bios";
              ver = "0.3.2";
              sha256 = "sha256:08b3z2k5il72ccj2h0c10flsmz4akjs6ak9j167i8cah34ymygk6";
            } {});
            regex-tdfa_1_3_1_0 = dontAndDisable (self.callHackageDirect {
              pkg = "regex-tdfa";
              ver = "1.3.1.0";
              sha256 = "sha256:1a0l7kdjzp98smfp969mgkwrz60ph24xy0kh2dajnymnr8vd7b8g";
            } {
              regex-base = self.regex-base_0_94_0_0;
            });
            regex-base_0_94_0_0 = dontAndDisable (self.callHackageDirect {
              pkg = "regex-base";
              ver = "0.94.0.0";
              sha256 = "sha256:0x2ip8kn3sv599r7yc9dmdx7hgh5x632m45ga99ib5rnbn6kvn8x";
            } {});
          };
        };
      };
  };

in nixpkgs
