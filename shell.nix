let
  pkgs = import <nixpkgs> {};
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
