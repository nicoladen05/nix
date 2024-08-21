{ lib, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;

    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      ls = "ls --color";
      ll = "ls -l --color";

      v = "nvim";

      rb = "sudo nixos-rebuild switch --flake ~/.config/nixos/#default";
      rt = "sudo nixos-rebuild test --flake ~/.config/nixos/#default";
    };
  };


  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };
}
