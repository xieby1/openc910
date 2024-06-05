let
  # pin latest nixpkgs 23.11
  name = "openc910";
  pkgs = import ( (import <nixpkgs> {}).fetchFromGitHub {
    owner = "NixOS";
    repo = "nixpkgs";
    rev = "46397778ef1f73414b03ed553a3368f0e7e33c2f";
    hash = "sha256-mzZDr00WUiUXVm1ujBVv6A0qRd8okaITyUp4ezYRgc4=";
  } ) {};
  h_content = builtins.toFile "h_content" ''
    # ${pkgs.lib.toUpper "xieby1's ${name} usage tips"}

    Branch `micro_translator` is the active main branch of transutor project.

    * Show this help: `h`
    * Build c910: ❶ `cd smart_run`
      * help: ❷ `make help`
      * coremark ❷ `make runcase CASE=coremark SIM=verilator THREADS=8 -j`
    * Run: ❶ `cd smart_run/work` ❷ `./obj_dir/Vtop`
  '';
  _h_ = pkgs.writeShellScriptBin "h" ''
    ${pkgs.glow}/bin/glow ${h_content}
  '';
in pkgs.mkShell {
  packages = with pkgs; [
    _h_
    verilator
    zlib
  ];

  shellHook = let
    xuantie-elf-toolchain = pkgs.callPackage ./xuantie-elf-toolchain.nix {};
  in ''
    export CODE_BASE_PATH=$(realpath ./C910_RTL_FACTORY)
    export TOOL_EXTENSION=${xuantie-elf-toolchain}/bin

    # push xuantie-elf-toolchain to cachix
    cachix_dhall=/home/xieby1/Gist/Config/cachix.dhall
    if [[ -f $cachix_dhall ]]; then
      file=./.direnv/xuantie-elf-toolchain
      if [[ -f $file && "$(cat $file)" == "${xuantie-elf-toolchain}" ]]; then
        echo cachix already pushed
      else
        ${pkgs.cachix}/bin/cachix -c $cachix_dhall push xieby1 ${xuantie-elf-toolchain}
        echo ${xuantie-elf-toolchain} > $file
      fi
    fi

    h
  '';
}
