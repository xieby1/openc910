let
  # pin latest nixpkgs 23.11
  pkgs = import ( (import <nixpkgs> {}).fetchFromGitHub {
    owner = "NixOS";
    repo = "nixpkgs";
    rev = "46397778ef1f73414b03ed553a3368f0e7e33c2f";
    hash = "sha256-mzZDr00WUiUXVm1ujBVv6A0qRd8okaITyUp4ezYRgc4=";
  } ) {};
in pkgs.mkShell {
  packages = with pkgs; [
    verilator
  ];

  shellHook = let
    xuantie-elf-toolchain = pkgs.callPackage ./xuantie-elf-toolchain.nix {};
  in ''
    export CODE_BASE_PATH=$(realpath ./C910_RTL_FACTORY)
    export TOOL_EXTENSION=${xuantie-elf-toolchain}/bin
  '';
}
