final: prev: rec {
  caddy = prev.caddy.overrideAttrs (
    _: previousAttrs: {
      go = final.go_1_26;
      nativeBuildInputs = builtins.filter (input: input != prev.go) previousAttrs.nativeBuildInputs ++ [
        final.go_1_26
      ];
    }
  );

  t3-code = prev.callPackage ../packages/t3-code.nix { };

  python313 = prev.python313.override {
    packageOverrides = pythonFinal: pythonPrev: {
      pycord = prev.callPackage ../packages/pycord.nix { };
      wavelink = prev.callPackage ../packages/wavelink.nix { };
    };
  };

  python313Packages = python313.pkgs;
}
