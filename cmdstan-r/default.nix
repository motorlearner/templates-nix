let
  rev  = "574d1eac1c200690e27b8eb4e24887f8df7ac27c";
  pkgs = import (builtins.fetchTarball("https://github.com/NixOS/nixpkgs/archive/${rev}.tar.gz")) {};


  which = builtins.attrValues {
        inherit (pkgs) which;
      };

  r = builtins.attrValues {
    inherit (pkgs) R;
    inherit (pkgs.rPackages) languageserver jsonlite;
    inherit (pkgs.rPackages) box dplyr tidyr ggplot2 reticulate;
  };

  cmdstan = builtins.attrValues {
    inherit (pkgs) cmdstan;
  };

  cmdstanr = [
    (pkgs.rPackages.buildRPackage {
      name = "cmdstanr";
      src = pkgs.fetchgit {
        url = "https://github.com/stan-dev/cmdstanr";
        rev = "02259ef";
        sha256 = "sha256-SNUJOqL18TIkPV/6hV7Ed/D/Z6iWrYzQhFpJIyXv9sk=";
      };
      propagatedBuildInputs = builtins.attrValues {
        inherit (pkgs.rPackages) 
          checkmate
          data_table
          jsonlite
          posterior
          processx
          R6
          withr
          rlang;
      };
    })
  ];

in
  pkgs.mkShell {

    buildInputs = [
      which
      r
      cmdstanr
      cmdstan
    ];

    shellHook = 
    ''
    echo shellHook running...
    export CMDSTAN=$(dirname $(dirname "$(which stan)"))/opt/cmdstan
    Rscript ./test-bernoulli/bernoulli.R
    Rscript ./test-normal/normal.R
    '';

  }