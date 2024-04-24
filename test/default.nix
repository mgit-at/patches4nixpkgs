let
  flake = builtins.getFlake (builtins.toString ../.);
  patched = flake.patch <nixpkgs> [
    {
      patches4nixpkgs = [
        [true ./test.patch]
        [false ./test.patch]
      ];
    }
  ];
in
{
  out = builtins.pathExists "${patched}/test-file";
}
