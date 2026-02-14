{
  config,
  lib,
  pkgs,
  ...
}:
{
  options = {
    home-manager.zsh.enable = lib.mkEnableOption "Enable the zsh shell";
  };

  config = lib.mkIf config.home-manager.zsh.enable {
    home.packages = with pkgs; [
      eza
      lazygit
    ];

    programs.zsh = {
      enable = true;
      enableCompletion = true;
      defaultKeymap = "emacs";

      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      shellAliases = {
        ls = "eza --icons";
        ll = "eza -l --icons";

        v = "nvim";
        lg = "lazygit";
        y = "yazi";
        sp = "spotify_player";

        shell = "nix-shell --command zsh -p";
        "nix develop" = "nix develop -c zsh";

        rb = "sudo nixos-rebuild switch --flake ~/.config/nixos/#default";
        rt = "sudo nixos-rebuild test --flake ~/.config/nixos/#default";
      };

      initContent = ''
        bindkey -s ^f "tmux-sessionizer\n"
      '';
    };

    programs.zoxide = {
      enable = true;
      enableZshIntegration = true;
    };

    programs.starship = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        add_newline = false;
        format = "$directory$git_branch$git_status$nix_shell$hostname$character";

        directory = {
          fish_style_pwd_dir_length = 1;
          truncation_length = 0;
          read_only = " 󰌾";
        };

        git_branch = {
          symbol = " ";
          format = "[$symbol$branch]($style) ";
        };

        git_status = {
          format = "([$all_status$ahead_behind]($style) )";
        };

        nix_shell = {
          symbol = " ";
          format = "[$symbol]($style) ";
        };

        hostname = {
          ssh_only = true;
          ssh_symbol = " ";
          format = "[$ssh_symbol$hostname]($style) ";
        };

        aws.symbol = "  ";
        buf.symbol = " ";
        bun.symbol = " ";
        c.symbol = " ";
        cpp.symbol = " ";
        cmake.symbol = " ";
        conda.symbol = " ";
        crystal.symbol = " ";
        dart.symbol = " ";
        deno.symbol = " ";
        docker_context.symbol = " ";
        elixir.symbol = " ";
        elm.symbol = " ";
        fennel.symbol = " ";
        fossil_branch.symbol = " ";
        gcloud.symbol = "  ";
        git_commit.tag_symbol = "  ";
        golang.symbol = " ";
        guix_shell.symbol = " ";
        haskell.symbol = " ";
        haxe.symbol = " ";
        hg_branch.symbol = " ";
        java.symbol = " ";
        julia.symbol = " ";
        kotlin.symbol = " ";
        lua.symbol = " ";
        memory_usage.symbol = "󰍛 ";
        meson.symbol = "󰔷 ";
        nim.symbol = "󰆥 ";
        nodejs.symbol = " ";
        ocaml.symbol = " ";
        package.symbol = "󰏗 ";
        perl.symbol = " ";
        php.symbol = " ";
        pijul_channel.symbol = " ";
        pixi.symbol = "󰏗 ";
        python.symbol = " ";
        rlang.symbol = "󰟔 ";
        ruby.symbol = " ";
        rust.symbol = "󱘗 ";
        scala.symbol = " ";
        swift.symbol = " ";
        zig.symbol = " ";
        gradle.symbol = " ";
        os.symbols = {
          Alpaquita = " ";
          Alpine = " ";
          AlmaLinux = " ";
          Amazon = " ";
          Android = " ";
          Arch = " ";
          Artix = " ";
          CachyOS = " ";
          CentOS = " ";
          Debian = " ";
          DragonFly = " ";
          Emscripten = " ";
          EndeavourOS = " ";
          Fedora = " ";
          FreeBSD = " ";
          Garuda = "󰛓 ";
          Gentoo = " ";
          HardenedBSD = "󰞌 ";
          Illumos = "󰈸 ";
          Kali = " ";
          Linux = " ";
          Mabox = " ";
          Macos = " ";
          Manjaro = " ";
          Mariner = " ";
          MidnightBSD = " ";
          Mint = " ";
          NetBSD = " ";
          NixOS = " ";
          Nobara = " ";
          OpenBSD = "󰈺 ";
          openSUSE = " ";
          OracleLinux = "󰌷 ";
          Pop = " ";
          Raspbian = " ";
          Redhat = " ";
          RedHatEnterprise = " ";
          RockyLinux = " ";
          Redox = "󰀘 ";
          Solus = "󰠳 ";
          SUSE = " ";
          Ubuntu = " ";
          Unknown = " ";
          Void = " ";
          Windows = "󰍲 ";
        };
      };
    };
  };
}
