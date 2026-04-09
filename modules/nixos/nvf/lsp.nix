{
  lib,
  config,
  pkgs,
  ...
}:

{
  config = lib.mkIf config.nvf.enable {
    programs.nvf.settings.vim = {
      lsp = {
        enable = true;
        formatOnSave = false;
        mappings = {
          goToDefinition = "gd";
          goToDeclaration = "gD";
          listReferences = "gr";
          hover = "K";
          openDiagnosticFloat = "gi";
        };

        servers = {
          python.cmd = [ "${pkgs.pyright}/bin/pyright" ];

          nix = {
            cmd = [ "${pkgs.nixd}/bin/nixd" ];
            options = {
              nixos = {
                expr = "(builtins.getFlake \"github:nicoladen05/nix\").nixosConfigurations.desktop.options";
              };
              nixos_vps = {
                expr = "(builtins.getFlake \"github:nicoladen05/nix\").nixosConfigurations.vps.options";
              };
            };
          };
        };
      };

      languages = {
        enableTreesitter = true;
        enableFormat = true;

        nix = {
          enable = true;
          lsp = {
            enable = true;
            servers = [ "nixd" ];
          };
          treesitter.enable = true;
          format.enable = false;
          format.type = [ "alejandra" ];
        };
        python = {
          enable = true;
          lsp.enable = true;
          lsp.servers = [ "pyright" ];
          format.enable = true;
          format.type = [
            "black"
            "isort"
          ];
        };
        csharp = {
          enable = true;
          lsp.enable = true;
        };

        typst = {
          enable = true;
          format.enable = true;
          extensions.typst-preview-nvim.enable = true;
        };

        markdown.enable = true;
        rust.enable = true;
        # markdown.extensions.render-markdown-nvim.enable = true;
      };
    };
  };
}
