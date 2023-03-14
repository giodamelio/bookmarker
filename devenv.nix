{ pkgs, ... }:

{
  packages = [ pkgs.elixir_1_14 ];

  enterShell = ''
    export MIX_HOME="$PWD/.mix/"
    just --list
  '';

  languages.nix.enable = true;
  languages.elixir.enable = true;
}
