{
  lib,
  pkgs,
  config,
  ...
}:

let
  cfg = config.homelab.services.glance;
  immichCard = {
    type = "custom-api";
    title = "Immich Stats";
    cache = "1d";
    url = "https://immich.nicoladen.dev/api/server/statistics";
    headers = {
      x-api-key = {
        _secret = config.sops.secrets."glance/immich_api_key".path;
      };
      Accept = "application/json";
    };
    template = ''
      <div class="flex justify-between text-center">
        <div>
            <div class="color-highlight size-h3">{{ .JSON.Int "photos" | formatNumber }}</div>
            <div class="size-h6">PHOTOS</div>
        </div>
        <div>
            <div class="color-highlight size-h3">{{ .JSON.Int "videos" | formatNumber }}</div>
            <div class="size-h6">VIDEOS</div>
        </div>
        <div>
            <div class="color-highlight size-h3">{{ div (.JSON.Int "usage" | toFloat) 1073741824 | toInt | formatNumber }}GB</div>
            <div class="size-h6">USAGE</div>
        </div>
      </div>
    '';
  };
  minecraftCard = url: url2: {
    type = "custom-api";
    title = "Minecraft Servers";
    cache = "30s";
    url = "https://api.mcstatus.io/v2/status/java/${url}";
    subrequests = {
      mc2 = {
        url = "https://api.mcstatus.io/v2/status/java/${url2}";
      };
    };
    template = ''
      <div style="display:flex; align-items:center; gap:12px;">
        <div style="flex-grow:1; min-width:0;">
          <a class="size-h4 block text-truncate color-highlight">
            {{ .JSON.String "host" }}
            {{ if .JSON.Bool "online" }}
            <span
              style="width: 8px; height: 8px; border-radius: 50%; background-color: var(--color-positive); display: inline-block; vertical-align: middle;"
              data-popover-type="text"
              data-popover-text="Online"
            ></span>
            {{ else }}
            <span
              style="width: 8px; height: 8px; border-radius: 50%; background-color: var(--color-negative); display: inline-block; vertical-align: middle;"
              data-popover-type="text"
              data-popover-text="Offline"
            ></span>
            {{ end }}
          </a>

          <ul class="list-horizontal-text">
            <li>
              {{ if .JSON.Bool "online" }}
              <span>{{ .JSON.String "version.name_clean" }}</span>
              {{ else }}
              <span>Offline</span>
              {{ end }}
            </li>
            {{ if .JSON.Bool "online" }}
            <li data-popover-type="html">
              <div data-popover-html>
                {{ range .JSON.Array "players.list" }}{{ .String "name_clean" }}<br>{{ end }}
              </div>
              <p style="display:inline-flex;align-items:center;">
                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" class="size-6" style="height:1em;vertical-align:middle;margin-right:0.5em;">
                  <path fill-rule="evenodd" d="M7.5 6a4.5 4.5 0 1 1 9 0 4.5 4.5 0 0 1-9 0ZM3.751 20.105a8.25 8.25 0 0 1 16.498 0 .75.75 0 0 1-.437.695A18.683 18.683 0 0 1 12 22.5c-2.786 0-5.433-.608-7.812-1.7a.75.75 0 0 1-.437-.695Z" clip-rule="evenodd" />
                </svg>
                {{ .JSON.Int "players.online" | formatNumber }}/{{ .JSON.Int "players.max" | formatNumber }} players
              </p>
            </li>
            {{ else }}
            <li>
              <p style="display:inline-flex;align-items:center;">
                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" class="size-6" style="height:1em;vertical-align:middle;margin-right:0.5em;opacity:0.5;">
                  <path fill-rule="evenodd" d="M7.5 6a4.5 4.5 0 1 1 9 0 4.5 4.5 0 0 1-9 0ZM3.751 20.105a8.25 8.25 0 0 1 16.498 0 .75.75 0 0 1-.437.695A18.683 18.683 0 0 1 12 22.5c-2.786 0-5.433-.608-7.812-1.7a.75.75 0 0 1-.437-.695Z" clip-rule="evenodd" />
                </svg>
                0 players
              </p>
            </li>
            {{ end }}
          </ul>
        </div>
      </div>

      <div style="display:flex; align-items:center; gap:12px; margin-top: 1em; border-top: 1px solid var(--color-separator); padding-top: 1em">
        <div style="flex-grow:1; min-width:0;">
          <a class="size-h4 block text-truncate color-highlight">
            {{ (.Subrequest "mc2").JSON.String "host" }}
            {{ if (.Subrequest "mc2").JSON.Bool "online" }}
            <span
              style="width: 8px; height: 8px; border-radius: 50%; background-color: var(--color-positive); display: inline-block; vertical-align: middle;"
              data-popover-type="text"
              data-popover-text="Online"
            ></span>
            {{ else }}
            <span
              style="width: 8px; height: 8px; border-radius: 50%; background-color: var(--color-negative); display: inline-block; vertical-align: middle;"
              data-popover-type="text"
              data-popover-text="Offline"
            ></span>
            {{ end }}
          </a>

          <ul class="list-horizontal-text">
            <li>
              {{ if (.Subrequest "mc2").JSON.Bool "online" }}
              <span>{{ (.Subrequest "mc2").JSON.String "version.name_clean" }}</span>
              {{ else }}
              <span>Offline</span>
              {{ end }}
            </li>
            {{ if (.Subrequest "mc2").JSON.Bool "online" }}
            <li data-popover-type="html">
              <div data-popover-html>
                {{ range (.Subrequest "mc2").JSON.Array "players.list" }}{{ .String "name_clean" }}<br>{{ end }}
              </div>
              <p style="display:inline-flex;align-items:center;">
                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" class="size-6" style="height:1em;vertical-align:middle;margin-right:0.5em;">
                  <path fill-rule="evenodd" d="M7.5 6a4.5 4.5 0 1 1 9 0 4.5 4.5 0 0 1-9 0ZM3.751 20.105a8.25 8.25 0 0 1 16.498 0 .75.75 0 0 1-.437.695A18.683 18.683 0 0 1 12 22.5c-2.786 0-5.433-.608-7.812-1.7a.75.75 0 0 1-.437-.695Z" clip-rule="evenodd" />
                </svg>
                {{ (.Subrequest "mc2").JSON.Int "players.online" | formatNumber }}/{{ (.Subrequest "mc2").JSON.Int "players.max" | formatNumber }} players
              </p>
            </li>
            {{ else }}
            <li>
              <p style="display:inline-flex;align-items:center;">
                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" class="size-6" style="height:1em;vertical-align:middle;margin-right:0.5em;opacity:0.5;">
                  <path fill-rule="evenodd" d="M7.5 6a4.5 4.5 0 1 1 9 0 4.5 4.5 0 0 1-9 0ZM3.751 20.105a8.25 8.25 0 0 1 16.498 0 .75.75 0 0 1-.437.695A18.683 18.683 0 0 1 12 22.5c-2.786 0-5.433-.608-7.812-1.7a.75.75 0 0 1-.437-.695Z" clip-rule="evenodd" />
                </svg>
                0 players
              </p>
            </li>
            {{ end }}
          </ul>
        </div>
      </div>
    '';
  };

  klipperCard = title: url: {
    inherit title;
    type = "custom-api";
    cache = "30s";
    url = "http://${url}/printer/info";
    template = ''
      <div style="display:flex; align-items:center; gap:12px;">
        <div style="flex-grow:1; min-width:0;">
          <a class="size-h4 block text-truncate color-highlight">
            {{ if eq (.JSON.String "result.state") "ready" }}
            Ready
            <span
              style="width: 8px; height: 8px; border-radius: 50%; background-color: var(--color-positive); display: inline-block; vertical-align: middle;"
              data-popover-type="text"
              data-popover-text="Online"
            ></span>
            {{ else }}
            Off
            <span
              style="width: 8px; height: 8px; border-radius: 50%; background-color: var(--color-negative); display: inline-block; vertical-align: middle;"
              data-popover-type="text"
              data-popover-text="Offline"
            ></span>
            {{ end }}
          </a>
        </div>
      </div>
    '';
  };
in
{
  imports = [
    ./agent.nix
  ];

  options.homelab.services.glance = {
    enable = lib.mkEnableOption "Enable the Glance Dashboard";
  };

  config = lib.mkIf cfg.enable {
    services.glance = {
      enable = true;
      openFirewall = true;
      settings = {
        server.host = "0.0.0.0";

        pages = [
          {
            name = "Home";
            hide-desktop-navigation = true;
            columns = [
              # Left
              {
                size = "small";
                widgets = [
                  {
                    type = "dns-stats";
                    service = "pihole-v6";
                    url = "http://192.168.2.2:8081";
                    password = {
                      _secret = config.sops.secrets."glance/pihole_password".path;
                    };
                  }
                  immichCard
                  (minecraftCard "mc.nicoladen.dev" "mc2.nicoladen.dev")
                  {
                    type = "extension";
                    title = "Backups";
                    url = "http://127.0.0.1:8675/backups";
                    cache = "1h";
                    allow-potentially-dangerous-html = true;
                    parameters = {
                      hide-file-count = true;
                    };
                  }
                ];
              }

              # Center
              {
                size = "full";
                widgets = [
                  {
                    type = "search";
                    autofocus = true;
                    search-engine = "google";
                  }
                  {
                    type = "monitor";
                    cache = "1m";
                    title = "Services";
                    sites = [
                      {
                        title = "Homeassistant";
                        url = "https://home.nicoladen.dev";
                        icon = "sh:home-assistant";
                      }
                      {
                        title = "Immich";
                        url = "https://immich.nicoladen.dev";
                        icon = "sh:immich";
                      }
                      {
                        title = "OwnCloud";
                        url = "https://cloud.nicoladen.dev";
                        icon = "si:owncloud";
                      }
                      {
                        title = "Paperless-NGX";
                        url = "https://paperless.taube.party";
                        icon = "sh:paperless-ngx";
                      }
                      {
                        title = "Vaultwarden";
                        url = "https://vaultwarden.nicoladen.dev";
                        icon = "si:vaultwarden";
                      }
                      {
                        title = "n8n";
                        url = "https://n8n.nicoladen.dev";
                        icon = "sh:n8n";
                      }
                      {
                        title = "Pihole";
                        url = "https://pihole.taube.party/admin";
                        icon = "sh:pi-hole";
                      }
                      {
                        title = "Spoolman";
                        url = "https://spoolman.taube.party";
                        icon = "sh:spoolman";
                      }
                      {
                        title = "ESPHome";
                        url = "https://esphome.taube.party";
                        icon = "sh:esphome";
                      }
                    ];
                  }
                  {
                    type = "monitor";
                    cache = "1m";
                    title = "Media";
                    sites = [
                      {
                        title = "Jellyfin";
                        url = "https://jellyfin.taube.party";
                        icon = "sh:jellyfin";
                      }
                      {
                        title = "Audiobookshelf";
                        url = "https://audiobookshelf.taube.party";
                        icon = "sh:audiobookshelf";
                      }
                      {
                        title = "Shelfmark";
                        url = "https://shelfmark.taube.party";
                        icon = "sh:shelfmark";
                      }
                      {
                        title = "Sonarr";
                        url = "https://sonarr.taube.party";
                        icon = "sh:sonarr";
                      }
                      {
                        title = "Radarr";
                        url = "https://radarr.taube.party";
                        icon = "sh:radarr";
                      }
                      {
                        title = "Prowlarr";
                        url = "https://prowlarr.taube.party";
                        icon = "sh:prowlarr";
                      }
                      {
                        title = "Jellyseerr";
                        url = "https://jellyseerr.taube.party";
                        icon = "sh:jellyseerr";
                      }
                      {
                        title = "Sabnzbd";
                        url = "https://sabnzbd.taube.party";
                        icon = "sh:sabnzbd";
                      }
                    ];
                  }
                  {
                    type = "split-column";
                    widgets = [
                      {
                        type = "server-stats";
                        servers = [
                          {
                            type = "local";
                            name = "Server";
                          }
                          {
                            type = "remote";
                            name = "VPS";
                            url = "http://130.61.231.173:27973/";
                            token = {
                              _secret = config.sops.secrets."glance/vps_remote".path;
                            };
                          }
                          {
                            type = "remote";
                            name = "3D Printer";
                            url = "http://192.168.2.104:27973";
                            token = {
                              _secret = config.sops.secrets."glance/3d_printer_remote".path;
                            };
                          }
                        ];
                      }
                      # {
                      #   type = "group";
                      #   widgets = [
                      #     {
                      #       type = "extension";
                      #       title = "Core ONE";
                      #       url = "http://192.168.2.39:5000";
                      #       cache = "1s";
                      #       allow-potentially-dangerous-html = true;
                      #     }
                      #     (klipperCard "Anycubic i3" "192.168.2.104")
                      #   ];
                      # }
                    ];
                  }
                ];
              }

              # Right
              {
                size = "small";
                widgets = [
                  {
                    type = "weather";
                    units = "metric";
                    hour-format = "24h";
                    location = "Wolfsburg, Germany";
                  }
                  {
                    type = "to-do";
                  }
                ];
              }
            ];
          }
        ];
      };
    };

    # Restic
    virtualisation.oci-containers.containers."glance-restic" = {
      image = "ghcr.io/nicoladen05/restic-glance-extension:latest";
      autoStart = true;
      pull = "newer";
      ports = [
        "8675:8675"
      ];
      volumes = [
        "/home/nico/.ssh:/root/.ssh"
      ];
      environment = {
        RESTIC_REPOS = "backups";
        RESTIC_CACHE_INTERVAL = "3600";
      };
      environmentFiles = [
        config.sops.secrets."glance_restic/url".path
        config.sops.secrets."glance_restic/password".path
      ];
    };

    services.caddy.virtualHosts = {
      "${config.homelab.internalDomain}" = {
        extraConfig = ''
          import cloudflare_dns
          reverse_proxy 127.0.0.1:8080
        '';
      };
    };

  };
}
