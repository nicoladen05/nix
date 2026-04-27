{ pkgs }:

{
  fetchFromModrinth = { slug, version, sha256 }: pkgs.stdenvNoCC.mkDerivation {
    pname = slug;
    version = version;

    dontUnpack = true;

    buildInputs = with pkgs; [
      curl
      jq
      cacert
    ];

    buildPhase = ''
      #!/usr/bin/env sh
      set -euo pipefail
      runHook preBuild

      api="https://api.modrinth.com/v2/project/${slug}/version/${version}"

      curl -fsSL "$api" \
        | jq -r '(([.files[] | select(.primary == true and (.filename | endswith(".jar")))] | .[0]) // ([.files[] | select(.filename | endswith(".jar"))] | .[0])) | [.url, .filename] | @tsv' \
        | while IFS="$(printf '\t')" read -r url name; do
            curl -fsLo "$name" "$url"
          done

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      cp *.jar $out

      runHook postInstall
    '';

    outputHashAlgo = "sha256";
    outputHashMode = "flat";
    outputHash = sha256;
  };
}
