((haskell-mode
  . ((dante-repl-command-line
      . ("nix-shell" "-p" "zlib" "--run" "cabal new-configure && cabal new-repl --ghc-option -fobject-code --builddir=dist/dante")
      ))
  ))
