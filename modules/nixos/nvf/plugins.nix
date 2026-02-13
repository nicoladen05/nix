{
  lib,
  config,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.nvf.enable {
    programs.nvf.settings.vim = {

      binds.whichKey = {
        enable = true;
        setupOpts = {
          preset = "classic";
          delay = 500;
          win.border = "single";
          padding = [
            2
            2
          ];
        };
      };

      visuals.nvim-web-devicons.enable = true;

      autocomplete.nvim-cmp = {
        enable = true;
        sourcePlugins = [
          "cmp-buffer"
          "cmp-path"
          "cmp-luasnip"
        ];
      };

      filetree.neo-tree = {
        enable = true;
        setupOpts = {
          window = {
            width = 40;

            mappings = {
              e = "";
              l = "focus_preview";
              i = "open";
            };
          };
        };
      };

      utility.surround = {
        enable = true;
        setupOpts = {
          keymaps = {
            change = "cs";
            change_line = "cS";
            delete = "ds";
            normal = "ys";
            normal_line = "yS";
          };
        };
      };

      # TODO: Make copilot not autocomplete in parenteses
      assistant = {
        copilot = {
          enable = true;
          cmp.enable = true;
        };
      };

      telescope.enable = true;
      autopairs.nvim-autopairs.enable = true;
      dashboard.alpha.enable = true;
      presence.neocord.enable = true;
      notify.nvim-notify.enable = true;
      projects.project-nvim.enable = true;
      terminal.toggleterm.enable = true;
      terminal.toggleterm.lazygit.enable = true;
      comments.comment-nvim.enable = true;
      notes.todo-comments.enable = true;
      # ui.noice.enable = true;
      ui.colorizer.enable = true;
      ui.colorizer.setupOpts.user_default_options.tailwind = true;
      utility.oil-nvim.enable = true;

      treesitter.autotagHtml = true;

      formatter.conform-nvim = {
        enable = true;
        setupOpts = {
          formatters_by_ft = {
            nix = [ "nixfmt" ];
            python = [
              "black"
              "isort"
            ];
            javascript = [ "prettierd" ];
            typescript = [ "prettierd" ];
            html = [ "prettierd" ];
          };
        };
      };

      navigation.harpoon = {
        enable = true;
        mappings = {
          file1 = "<C-n>";
          file2 = "<C-e>";
          file3 = "<C-i>";
          file4 = "<C-o>";
          listMarks = "<C-l>";
        };
      };

      extraPlugins = {
        neovim-ayu = {
          package = pkgs.vimPlugins.neovim-ayu;
          setup = ''
            require('ayu').setup({
              mirage = false, -- Set to `true` to use `mirage` variant instead of `dark` for dark background.
              terminal = true, -- Set to `false` to let terminal manage its own colors.
              overrides = {}, -- A dictionary of group names, each associated with a dictionary of parameters (`bg`, `fg`, `sp` and `style`) and colors in hex.
            })
          '';
        };
      };
    };
  };
}
