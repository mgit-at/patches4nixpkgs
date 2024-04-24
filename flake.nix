{
  description = "small flake that allows adding patches to nixpkgs";

  outputs = { self }: {

    patch = nixpkgs: patchSources: let
      lib = nixpkgs.lib;
      origPkgs = import "${nixpkgs}" { system = "x86_64-linux"; };

      collectPatchesFromSource = source:
        lib.map (el: lib.elemAt 1 el)
          (lib.filter (el: lib.elemAt el 0) (source.patches4nixpkgs));

      collectPatches = sources:
        lib.concatLists
          (lib.map (collectPatchesFromSource)
            (lib.filter (source: source ? "patches4nixpkgs") sources));

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
