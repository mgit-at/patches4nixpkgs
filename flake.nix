{
  description = "a small flake that allows adding patches to nixpkgs conditionally";

  outputs = { self }: {

    patch = nixpkgs: patchSources: let
      lib = if nixpkgs ? lib then nixpkgs.lib
        else import "${nixpkgs}/lib";
      origPkgs = import "${nixpkgs}" { system = "x86_64-linux"; };

      collectPatchesFromSource = source:
        builtins.map (el: lib.elemAt el 1)
          (lib.filter (el: lib.elemAt el 0) (source.patches4nixpkgs));

      collectPatches = sources:
        lib.concatMap (collectPatchesFromSource)
          (lib.filter (source: source ? "patches4nixpkgs") sources);

      patches = collectPatches patchSources;
    in origPkgs.stdenvNoCC.mkDerivation {
        name = "patched-nixpkgs";
        src = "${nixpkgs}";
        dontBuild = true;
        dontFixup = true;
        nativeBuildInputs = [ origPkgs.git ];
        installPhase = ''
          for p in ${origPkgs.lib.concatStringsSep " " patches}; do
            echo "applying patch $p"
            git apply -p1 "$p"
          done
          cp -r . $out
        '';
      };
  };
}
