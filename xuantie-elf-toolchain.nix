{ lib
, stdenv
, zlib
, libmpc
, mpfr
, gmp
}:
stdenv.mkDerivation {
  pname = "xuantie-elf-toolchain";
  version = "2023.03.21";
  system = "x86_64-linux";
  src = fetchTarball {
    url = "https://github.com/T-head-Semi/xuantie-gnu-toolchain/releases/download/2023.03.21/riscv64-elf-ubuntu-20.04-nightly-2023.03.21-nightly.tar.gz";
    sha256 = "0ci2wf11ap015rwm0yn68082i6rywk9a5956k7q5r4lqfz90c4zh";
  };

  installPhase = ''
    mkdir -p $out
    cp -r $src/* $out/
  '';

  postFixup = let
    rpath = lib.makeLibraryPath [
      zlib
      libmpc
      mpfr
      gmp
    ];
  in ''
    for file in $(find $out -type f \( -perm /0111 -o -name \*.so\* \) ); do
      patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" "$file" || true
      patchelf --set-rpath ${rpath} $file || true
    done
  '';
}
