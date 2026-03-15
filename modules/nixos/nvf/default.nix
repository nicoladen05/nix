{
  lib,
  config,
  ...
}:

{
  imports = [
    ./lsp.nix
    ./lualine.nix
    ./plugins.nix
  ];

  options = {
    nvf.enable = lib.mkEnableOption "enable nvf";
  };

  config = lib.mkIf config.nvf.enable {
    programs.nvf = {
      enable = true;
      settings = {
        vim = {
          options = {
            undofile = true;
            undodir = "/tmp/nvim-undo";

            autoindent = true;
            expandtab = true;
            shiftwidth = 2;
            smartindent = true;
            tabstop = 2;

            clipboard = "unnamedplus";

            termguicolors = true;

            mouse = "a";

            cursorline = true;
            number = true;
            relativenumber = true;
            signcolumn = "yes";

            autoread = true;
            backup = false;
            compatible = false;
            errorbells = false;
            hidden = true;
            incsearch = true;
            # shell = "zsh";
            shortmess = "atI";
            showmode = false;
            smartcase = true;
            swapfile = false;
            ttimeoutlen = 5;
            wrap = false;
            writebackup = false;
            encoding = "UTF-8";
          };

          globals = {
            mapleader = " ";
            maplocalleader = " ";
          };

          keymaps = [
            # Colemak mappings
            {
              key = "n";
              mode = "n";
              action = "j";
            }
            {
              key = "e";
              mode = "n";
              action = "k";
            }
            {
              key = "i";
              mode = "n";
              action = "l";
            }
            {
              key = "k";
              mode = "n";
              action = "i";
            }
            {
              key = "j";
              mode = "n";
              action = "n";
            }
            {
              key = "l";
              mode = "n";
              action = "e";
            }

            {
              key = "n";
              mode = "v";
              action = "j";
            }
            {
              key = "e";
              mode = "v";
              action = "k";
            }
            {
              key = "i";
              mode = "v";
              action = "l";
            }
            {
              key = "k";
              mode = "v";
              action = "i";
            }
            {
              key = "<S-k>";
              mode = "v";
              action = "I";
            }
            {
              key = "j";
              mode = "v";
              action = "n";
            }
            {
              key = "<S-j>";
              mode = "v";
              action = "N";
            }
            {
              key = "l";
              mode = "v";
              action = "e";
            }
            {
              key = "<S-l>";
              mode = "v";
              action = "E";
            }
            # Better window navigation
            # {
            #   key = "<C-h>";
            #   mode = "n";
            #   action = "<C-w>h";
            # }
            # {
            #   key = "<C-n>";
            #   mode = "n";
            #   action = "<C-w>j";
            # }
            # {
            #   key = "<C-e>";
            #   mode = "n";
            #   action = "<C-w>k";
            # }
            # {
            #   key = "<C-i>";
            #   mode = "n";
            #   action = "<C-w>l";
            # }

            # Resize with arrows
            # {
            #   key = "<C-Up>";
            #   mode = "n";
            #   action = ":resize -2<CR>";
            # }
            # {
            #   key = "<C-Down>";
            #   mode = "n";
            #   action = ":resize +2<CR>";
            # }
            # {
            #   key = "<C-Left>";
            #   mode = "n";
            #   action = ":vertical resize -2<CR>";
            # }
            # {
            #   key = "<C-Right>";
            #   mode = "n";
            #   action = ":vertical resize +2<CR>";
            # }

            # Stay in visual mode
            {
              key = ">";
              mode = "v";
              action = ">gv";
            }
            {
              key = "<";
              mode = "v";
              action = "<gv";
            }

            # Neotree
            {
              key = "<leader>n";
              mode = "n";
              action = "<cmd>Neotree toggle<cr>";
            }
            {
              key = "<leader>tp";
              mode = "n";
              action = "<cmd>TypstPreview<cr>";
            }
            {
              key = "<leader>tP";
              mode = "n";
              action = "<cmd>TypstPreviewToggle<cr>";
            }
          ];
        };
      };
    };
  };
}
