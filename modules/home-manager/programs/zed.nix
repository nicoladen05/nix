{
  lib,
  config,
  pkgs,
  ...
}:

{
  options = {
    home-manager.zed.enable = lib.mkEnableOption "enable zed editor";
  };

  config = lib.mkIf config.home-manager.zed.enable {
    programs.zed-editor = {
      enable = true;

      extraPackages = [
        pkgs.jdt-language-server

        pkgs.nil
        pkgs.nixd
      ];

      mutableUserSettings = false;
      mutableUserKeymaps = false;
      mutableUserTasks = false;
      mutableUserDebug = false;

      userSettings = {
        tabs.file_icons = true;

        show_edit_predictions = true;
        edit_predictions = {
          enabled_in_text_threads = true;
          mode = "subtle";
        };

        terminal.dock = "right";

        relative_line_numbers = "enabled";
        buffer_line_height = "comfortable";

        vim_mode = true;
        base_keymap = "JetBrains";

        buffer_font_family = lib.mkForce config.stylix.fonts.monospace.name;
        ui_font_size = lib.mkForce 14;

        theme = lib.mkForce "Gruvbox Light Soft";

        lsp = {
          nixd.settings = {
            nixos.expr = "(builtins.getFlake (builtins.toString ./.)).nixosConfigurations.desktop.options";
            home-manager.expr = "(builtins.getFlake (builtins.toString ./.)).homeConfigurations.nico.options";
          };
          rust-analyzer.enable_lsp_tasks = true;
          basedpyright.settings.reportAny = false;
        };
      };

      userKeymaps = [
        # Vim mode remappings
        {
          context = "vim_mode == normal || vim_mode == visual";
          bindings = {
            n = "vim::Down";
            shift-n = "vim::JoinLines";
            e = "vim::Up";
            shift-e = "editor::Hover";
            i = "vim::Right";
            j = "vim::MoveToNextMatch";
            shift-j = "vim::MoveToPreviousMatch";
            l = "vim::NextWordEnd";
            shift-l = [
              "vim::NextWordEnd"
              { ignore_punctuation = true; }
            ];
            k = "vim::InsertBefore";
            shift-k = "vim::InsertFirstNonWhitespace";
          };
        }
        {
          context = "vim_mode == operator";
          bindings = {
            k = [
              "vim::PushObject"
              { around = false; }
            ];
          };
        }
        {
          context = "vim_mode == visual";
          bindings = {
            shift-s = "vim::PushAddSurrounds";
          };
        }

        {
          context = "Editor && !menu";
          bindings = {
            ctrl-p = "file_finder::Toggle";
            "ctrl-f" = "buffer_search::Deploy";
            "ctrl-c" = "editor::Copy";
            "ctrl-x" = "editor::Cut";
            "ctrl-a" = "editor::SelectAll";
            "ctrl-y" = "editor::Undo";
            "ctrl-t" = "project_symbols::Toggle";
            "ctrl-o" = "workspace::Open";
            "ctrl-s" = "workspace::Save";
            "ctrl-b" = "workspace::ToggleLeftDock";
            "ctrl-r" = "projects::OpenRecent";
          };
        }

      ];

      userTasks = [
        {
          label = "Run Bot (uv)";
          command = "uv";
          args = [
            "run"
            "-m"
            "src.bot"
          ];
        }
      ];

      userDebug = [
        {
          label = "Debug active Python file";
          adapter = "Debugpy";
          program = "$ZED_FILE";
          request = "launch";
          cwd = "$ZED_WORKTREE_ROOT";
        }
        {
          label = "Debug active JavaScript file";
          adapter = "JavaScript";
          program = "$ZED_FILE";
          request = "launch";
          cwd = "$ZED_WORKTREE_ROOT";
          type = "pwa-node";
        }
        {
          label = "JavaScript debug terminal";
          adapter = "JavaScript";
          request = "launch";
          cwd = "$ZED_WORKTREE_ROOT";
          console = "integratedTerminal";
          type = "pwa-node";
        }
      ];
    };
  };
}
