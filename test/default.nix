let
  flake = builtins.getFlake (builtins.toString ../.);
  patched = flake.patch <nixpkgs> [
    {
      patches4nixpkgs = nixpkgs: [
        [true ./test.patch]
        [false ./test.patch]
      ];
    }
  ];

  nixpkgs = import <nixpkgs> {};
in
nixpkgs.stdenv.mkDerivation {
  name = "test-patches4nixpkgs";

  src = "${patched}";

  dontBuild = true;

  installPhase = ''
    cat test-file # file should be created by patch
    touch $out # fix derivation build
  '';
}
