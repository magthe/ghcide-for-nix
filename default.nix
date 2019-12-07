with (import <nixpkgs> {});

let
  ghc_ver = "ghc865";

  ghcide-0_0_4-src = builtins.fetchTarball {
    url = https://hackage.haskell.org/package/ghcide-0.0.4/ghcide-0.0.4.tar.gz;
  };

  haskell-lsp_0_17_0_0-src = builtins.fetchTarball {
    url = https://hackage.haskell.org/package/haskell-lsp-0.17.0.0/haskell-lsp-0.17.0.0.tar.gz;
  };

  haskell-lsp-types_0_17_0_0-src = builtins.fetchTarball {
    url = https://hackage.haskell.org/package/haskell-lsp-types-0.17.0.0/haskell-lsp-types-0.17.0.0.tar.gz;
  };

  lsp-test_0_8_0_0-src = builtins.fetchTarball {
    url = https://hackage.haskell.org/package/lsp-test-0.8.0.0/lsp-test-0.8.0.0.tar.gz;
  };

  myHaskellPackages = pkgs.haskell.packages.${ghc_ver}.override {
    overrides = self: super: rec {
      haskell-lsp = self.callCabal2nix "haskell-lsp" haskell-lsp_0_17_0_0-src {};
      haskell-lsp-types = self.callCabal2nix "haskell-lsp-types" haskell-lsp-types_0_17_0_0-src {};
      lsp-test = self.callCabal2nixWithOptions "lsp-test" lsp-test_0_8_0_0-src "--no-check" {};
      ghcide = self.callCabal2nixWithOptions "ghcide" ghcide-0_0_4-src "--no-check" {};
    };
  };

in {
  haskell-lsp_0_17_0_0 = myHaskellPackages.haskell-lsp;
  haskell-lsp-types_0_17_0_0 = myHaskellPackages.haskell-lsp-types;
  lsp-test_0_8_0_0 = myHaskellPackages.lsp-test;
  ghcide_0_0_4 = myHaskellPackages.ghcide;
}
