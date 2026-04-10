{
  appimageTools,
  fetchurl,
  lib,
  ...
}:

let
  pname = "t3-code";
  version = "0.0.15";
  src = fetchurl {
    url = "https://github.com/pingdotgg/t3code/releases/download/v${version}/T3-Code-${version}-x86_64.AppImage";
    hash = "sha256-Z8y7SWH55+ZC7cRpgo0cdG273rbDiFS3pXQt3up7sDg=";
  };
  extracted = appimageTools.extractType2 {
    inherit pname version src;
  };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraPkgs = pkgs: [ pkgs.codex ];

  extraInstallCommands = ''
    mkdir -p $out/share/applications
    mkdir -p $out/share/icons/hicolor/1024x1024/apps

    cp ${extracted}/t3-code-desktop.desktop $out/share/applications/
    cp ${extracted}/usr/share/icons/hicolor/1024x1024/apps/t3-code-desktop.png \
      $out/share/icons/hicolor/1024x1024/apps/

    substituteInPlace $out/share/applications/t3-code-desktop.desktop \
      --replace-fail 'Exec=AppRun --no-sandbox %U' 'Exec=t3-code --no-sandbox %U'
  '';

  meta = with lib; {
    description = "T3 Code desktop application";
    homepage = "https://github.com/pingdotgg/t3code";
    license = licenses.mit;
    platforms = [ "x86_64-linux" ];
  };
}
