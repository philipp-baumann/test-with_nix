let
 pkgs = import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/63143ac2c9186be6d9da6035fa22620018c85932.tar.gz") {};
 rpkgs = builtins.attrValues {
  inherit (pkgs.rPackages) dplyr data_table;
};
   system_packages = builtins.attrValues {
  inherit (pkgs) R glibcLocalesUtf8;
};
  in
  pkgs.mkShell {
    LOCALE_ARCHIVE = if pkgs.system == "x86_64-linux" then  "${pkgs.glibcLocalesUtf8}/lib/locale/locale-archive" else "";
    LANG = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";

    buildInputs = [ rpkgs system_packages ];
      shellHook = "R --vanilla";
  }

