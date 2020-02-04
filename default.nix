let
  nixpkgs = import (builtins.fetchTarball {
    name = "nixpkgs-unstable-2020-01-26";
    url = https://github.com/NixOS/nixpkgs-channels/archive/0c960262d159d3a884dadc3d4e4b131557dad116.tar.gz;
    sha256 = "sha256:0d7ms4dxbxvd6f8zrgymr6njvka54fppph1mrjjlcan7y0dhi5rb";
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
              ver = "0.1.0";
              sha256 = "sha256:0vwaaqb74dzsvx5xdfkzbi8zzvbd5w9l1wdhl3rhvi8ibnrchgfs";
            } {
              haddock-library = self.haddock-library_1_8_0;
              haskell-lsp-types = self.haskell-lsp-types_0_19_0_0;
              haskell-lsp = self.haskell-lsp_0_19_0_0;
              hie-bios = self.hie-bios_0_4_0;
              regex-tdfa = self.regex-tdfa_1_3_1_0;
            });
            haddock-library_1_8_0 = dontAndDisable (self.callHackageDirect {
              pkg = "haddock-library";
              ver = "1.8.0";
              sha256 = "sha256:1hmfrfygazdkyxxgh2n2a0ff38c8p4bnlxpk9gia90jn0c5im2n5";
            } {});
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
            hie-bios_0_4_0 = dontAndDisable (self.callHackageDirect {
              pkg = "hie-bios";
              ver = "0.4.0";
              sha256 = "sha256:19lpg9ymd9656cy17vna8wr1hvzfal94gpm2d3xpnw1d5qr37z7x";
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
