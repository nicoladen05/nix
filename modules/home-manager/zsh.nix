{ lib, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;

    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      ls = "eza --icons";
      ll = "eza -l --icons";

      v = "nvim";
      lg = "lazygit";

      rb = "sudo nixos-rebuild switch --flake ~/.config/nixos/#default";
      rt = "sudo nixos-rebuild test --flake ~/.config/nixos/#default";
    };
  };


  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };
}
