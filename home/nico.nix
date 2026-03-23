{ ... }:

{
  imports = [
    ../modules/home-manager/default.nix
    ../modules/nixos/nvf
  ];

  # For easy switching with nh
  home.sessionVariables = {
    NH_FLAKE = "~/dev/nix";
  };

  home-manager = {
    enable = true;
    zsh.enable = true;
    tmux.enable = true;
    direnv.enable = true;
    zathura.enable = true;
    opencode.enable = true;
  };

  # NVF
  nvf.enable = true;

  programs.nvf.settings.vim = {
    theme.enable = false;
    luaConfigRC."ayu-theme" = ''
      vim.cmd.colorscheme("ayu")
    '';
  };

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };
}
