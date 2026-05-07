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

    home-manager.opencode.haMcpEnvFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = /run/secrets/rendered/homeassistant/ha_mcp_env;
      description = "Path to an env file containing Home Assistant MCP credentials.";
    };
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

          clean-code = ''
            ---
            name: clean-code
            description: Pragmatic coding standards: concise, direct, no over-engineering, no unnecessary comments.
            allowed-tools:
              - Read
              - Write
              - Edit
            version: "2.0"
            priority: CRITICAL
            ---

            # Clean Code - Pragmatic AI Coding Standards

            ## Priority

            **CRITICAL**

            Be concise, direct, and solution-focused.

            ## Core Principles

            | Principle | Rule |
            |---|---|
            | SRP | Single Responsibility: each function or class does one thing. |
            | DRY | Don't Repeat Yourself: extract duplicates and reuse logic. |
            | KISS | Keep It Simple: prefer the simplest solution that works. |
            | YAGNI | You Aren't Gonna Need It: don't build unused features. |
            | Boy Scout | Leave code cleaner than you found it. |

            ## Naming Rules

            | Element | Convention |
            |---|---|
            | Variables | Reveal intent: `userCount`, not `n`. |
            | Functions | Use verb + noun: `getUserById()`, not `user()`. |
            | Booleans | Use question form: `isActive`, `hasPermission`, `canEdit`. |
            | Constants | Use `SCREAMING_SNAKE_CASE`: `MAX_RETRY_COUNT`. |

            If a name needs a comment to explain it, rename it.

            ## Function Rules

            | Rule | Description |
            |---|---|
            | Small | Keep functions under 20 lines; ideally 5-10 lines. |
            | One Thing | Each function should do one thing well. |
            | One Level | Keep one level of abstraction per function. |
            | Few Arguments | Use at most 3 arguments; prefer 0-2. |
            | No Side Effects | Do not mutate inputs unexpectedly. |

            ## Code Structure

            | Pattern | Apply |
            |---|---|
            | Guard Clauses | Return early for edge cases. |
            | Flat > Nested | Avoid deep nesting; max 2 levels. |
            | Composition | Build behavior from small functions. |
            | Colocation | Keep related code close together. |
          '';
        in
        {
          frontend-design = builtins.readFile "${frontend-design-skill}/SKILL.md";
          inherit clean-code;
        };

      # MCPs that should be disabled by default
      settings.mcp.ha-mcp = {
        enabled = false;
        type = "local";

        command = [
          "${pkgs.bash}/bin/bash"
          "-lc"
          "source ${lib.escapeShellArg (toString cfg.haMcpEnvFile)} && ${pkgs.uv}/bin/uvx ha-mcp"
        ];
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
