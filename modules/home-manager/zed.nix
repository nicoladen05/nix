{
  lib,
  config,
  ...
}:

{
  options = {
    home-manager.zed.enable = lib.mkEnableOption "enable zed editor";
  };

  config = lib.mkIf config.home-manager.zed.enable {
    programs.zed-editor = {
      enable = true;

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
        disable_ai = false;
        agent = {
          default_profile = "ask";
          default_model = {
            provider = "google";
            model = "gemini-2.5-flash";
          };
          model_parameters = [ ];
        };

        debugger.dock = "right";
        terminal.dock = "right";

        scrollbar = {
          axes.horizontal = false;
          show = "auto";
        };

        relative_line_numbers = "enabled";
        buffer_line_height = "comfortable";
        project_panel = {
          file_icons = true;
          entry_spacing = "comfortable";
          dock = "right";
        };
        icon_theme = "Material Icon Theme";
        vim_mode = true;
        base_keymap = "JetBrains";

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
        {
          context = "Workspace";
          bindings = { };
        }
        {
          context = "Editor";
          bindings = {
            "alt-g c" = "git::Commit";
          };
        }
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
          context = "Editor && mode == full";
          bindings = {
            ctrl-p = "file_finder::Toggle";
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
