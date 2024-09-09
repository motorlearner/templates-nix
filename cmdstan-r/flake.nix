{
  description = "for cmdstanr";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, ... }@inputs:
    let
      # for now hardcoded
      system = "aarch64-darwin"; # 64-bit ARM macOS
      # system = "aarch64-linux";  # 64-bit ARM Linux
      # system = "x86_64-linux";   # 64-bit Intel/AMD Linux
      # system = "x86_64-darwin";  # 64-bit Intel macOS

      pkgs = nixpkgs.legacyPackages.${system};

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
      {
        devShells.${system}.default = pkgs.mkShell {

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
          echo $CMDSTAN
          Rscript ./test-bernoulli/bernoulli.R
          Rscript ./test-normal/normal.R
          '';

        };
      };
}