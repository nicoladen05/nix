{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.home-manager.opencode;
in
{
  options = {
    home-manager.opencode.enable = lib.mkEnableOption "enable opencode";
  };

  config = lib.mkIf cfg.enable {
    programs.opencode = {
      enable = true;
      enableMcpIntegration = true;

      commands = {
        teach = ''
          I want to learn how to do the thing that I'm asking of you - I want you to guide me into doing it but don't do it for me so I can learn.
          Be a helpful teacher, be an expert, be patient and socratic and guide me towards what I'm asking with the ultimate goal of me completing the task and learning it well.
        '';
      };

      skills =
        let
          frontend-design-skill = pkgs.fetchgit {
            url = "https://github.com/anthropics/claude-code";
            rev = "53a5f3ee0703c2ab1b6d1dd18d8ab65187f9b8ad";
            hash = "sha256-VyoDTDbiE/4Ky2/Kxuco6qeSreDZS4tluHjyTmJQvf4=";
            rootDir = "plugins/frontend-design/skills/frontend-design";
          };
        in
        {
          frontend-design = builtins.readFile "${frontend-design-skill}/SKILL.md";
        };
    };

    programs.mcp = {
      enable = true;
      servers = {
        context7 = {
          url = "https://mcp.context7.com/mcp";
        };

        ddg-search = {
          command = "${pkgs.uv}/bin/uvx";
          args = [ "duckduckgo-mcp-server" ];
        };
      };
    };
  };
}
