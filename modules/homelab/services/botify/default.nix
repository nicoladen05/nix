{
  lib,
  config,
  inputs,
  ...
}:

let
  cfg = config.homelab.services.botify;
in
{
  imports = [ inputs.botify.nixosModules.default ];

  options.homelab.services.botify = {
    enable = lib.mkEnableOption "Enable Botify Bot";
    tokenFile = lib.mkOption {
      type = lib.types.path;
      description = "A file containing the bots token, prefixed with BOT_TOKEN=";
    };
    openaiTokenFile = lib.mkOption {
      type = lib.types.path;
      description = "A file containing the OpenAI API key, prefixed with OPENAI_API_KEY=";
    };
  };

  config = lib.mkIf cfg.enable {
    nixpkgs.overlays = [
      (final: prev: {
        botify = inputs.botify.packages.${final.hostPlatform.system}.default;
      })
    ];

    sops.secrets."services/botify/token" = {
      owner = "botify";
      group = "botify";
    };
    sops.secrets."services/botify/openai_api_key" = {
      owner = "botify";
      group = "botify";
    };

    services.botify = {
      inherit (cfg) enable tokenFile openaiTokenFile;
    };
  };
}
