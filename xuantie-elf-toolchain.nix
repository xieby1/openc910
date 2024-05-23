{ stdenv
, fetchFromGitHub

, bison
, flex
, texinfo
, gperf
, libtool
, patchutils
, bc
, expat

, zlib
, libmpc
, mpfr
, gmp
}: let
  folder_riscv    = "riscv";
  folder_gcc      = "gcc";
  folder_newlib   = "newlib";
  folder_gdb      = "gdb";
  folder_binutils = "binutils";
in stdenv.mkDerivation {
  name = "xuantie-elf-toolchain";

  nativeBuildInputs = [
    bison
    flex
    texinfo
    gperf
    libtool
    patchutils
    bc
    expat
  ];

  buildInputs = [
    zlib
    libmpc
    mpfr
    gmp
  ];

  srcs = [
    (fetchFromGitHub {
      name = folder_riscv;
      owner = "T-head-Semi";
      repo = "xuantie-gnu-toolchain";
      rev = "7238f2e2061f2d6f7585f9246b6378438f2fbe55";
      hash = "sha256-JogQQbticvjiAX8g8pUQ/XHQmi10GetKeeRXCms6ohU=";
    })
    (fetchFromGitHub {
      name = folder_gcc;
      owner = "T-head-Semi";
      repo = "gcc";
      rev = "436ad311c4815e086e5578346dafd6d7ae122d6b";
      hash = "sha256-0gjKGtC1EHMdCx/vrEOvVzgeireDMwHr5+xT3MaSksw=";
    })
    (fetchFromGitHub {
      name = folder_newlib;
      owner = "T-head-Semi";
      repo = "newlib";
      rev = "00a83b57fca908d8fe712d1f9d979ab9d6813ec3";
      hash = "sha256-OVs8utd7O4th2A9xdn/APfUPYyk++wCNmZI3RxYdfX4=";
    })
    (fetchFromGitHub {
      name = folder_gdb;
      owner = "T-head-Semi";
      repo = "binutils-gdb";
      rev = "9ffdea7e11cfc254be5cff44bcc3ee34958f1995";
      hash = "sha256-AWtAJsoH6TGwtrywJKslzP31Psxsi8eWmFHeBnG2AZ4=";
    })
  ];

  sourceRoot = folder_riscv;
  postUnpack = "cp -r ${folder_gdb} ${folder_binutils}";

  enableParallelBuilding = true;
  hardeningDisable = ["format"];
  preConfigure = ''
    sed -i 's/.*no file transfer utility found.*/echo miao/g' ./configure
    configureFlagsArray+=(
      --with-gcc-src=$(realpath ../${folder_gcc})
      --with-binutils-src=$(realpath ../${folder_binutils})
      --with-newlib-src=$(realpath ../${folder_newlib})
      --with-gdb-src=$(realpath ../${folder_gdb})
    )
  '';
}
