{ pkgs, ... }:

{
  packages = [ pkgs.elixir_1_14 ];

  enterShell = ''
    export MIX_HOME="$PWD/.mix/"
    just --list
  '';

  languages.nix.enable = true;
  languages.elixir.enable = true;

  pre-commit.hooks = {
    credo = {
      enable = true;
      name = "Credo";
      entry = "mix credo";
      pass_filenames = false;
    };
    mix-test = {
      enable = true;
      name = "Mix Test";
      entry = "mix test";
      pass_filenames = false;
    };
  };
}
