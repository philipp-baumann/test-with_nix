let
  pkgs = import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/976fa3369d722e76f37c77493d99829540d43845.tar.gz") {};
  system_packages = builtins.attrValues {
    inherit (pkgs) R glibcLocalesUtf8 nix;
  };
  rpkgs = builtins.attrValues {
    inherit (pkgs.rPackages) dplyr data_table;
  };
  rix_dev = [(pkgs.rPackages.buildRPackage {
  name = "rix";
  src = pkgs.fetchgit {
    url = "https://github.com/b-rodrigues/rix";
    branchName = "71-with-nix";
    rev = "963fd41f32b42a6960e39d62a8952e1adb0f17f1";
    sha256 = "sha256-/cHlcwdcMUcBFYizwsaUeBmcq3Uz8CRfmXOszxi2pWM=";
    };
    propagatedBuildInputs = builtins.attrValues {
      inherit (pkgs.rPackages) httr jsonlite sys codetools;
      };
  }) 
  ];
in
  pkgs.mkShell {
    LOCALE_ARCHIVE = if pkgs.system == "x86_64-linux" then  "${pkgs.glibcLocalesUtf8}/lib/locale/locale-archive" else "";
    LANG = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";

    buildInputs = [ system_packages rix_dev rpkgs];

    shellHook = "R --vanilla";
  }
