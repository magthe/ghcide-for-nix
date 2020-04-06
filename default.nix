let
  nixpkgs = import (builtins.fetchTarball {
    name = "nixpkgs-unstable-2020-04-06";
    url = https://github.com/NixOS/nixpkgs-channels/archive/ae6bdcc53584aaf20211ce1814bea97ece08a248.tar.gz;
    sha256 = "sha256:0hjhznns1cxgl3hww2d5si6vhy36pnm53hms9h338v6r633dcy77";
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
              haskell-lsp-types = self.haskell-lsp-types_0_19_0_0;
              haskell-lsp = self.haskell-lsp_0_19_0_0;
              hie-bios = self.hie-bios_0_4_0;
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
            hie-bios_0_4_0 = dontAndDisable (self.callHackageDirect {
              pkg = "hie-bios";
              ver = "0.4.0";
              sha256 = "sha256:19lpg9ymd9656cy17vna8wr1hvzfal94gpm2d3xpnw1d5qr37z7x";
            } {});
          };
        };
      };
  };

in nixpkgs
