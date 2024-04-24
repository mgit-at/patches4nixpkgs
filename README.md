# patches4nixpkgs

a small flake that allows adding patches to nixpkgs conditionally

Usage:

Add this to each flake

```nix
{
  patches4nixpkgs = nixpkgs: [
    [(condition) ./patch-file.patch]
  ];
}
```

e.g.:

```
{
  patches4nixpkgs = nixpkgs: [
    [(! builtins.pathExists "${nixpkgs}/my-file") ./add-my-file.patch]
  ];
}
```

Then patch nixpkgs

```nix
{
  inputs.nixpkgs...

  outputs = { self, flake, other-flake, ... }@inputs: {

  let
    patchPkgs = patches4nixpkgs.patch inputs.nixpkgs [
      flake
      other-flake
      self
    ];
    nixpkgs = patches4nixpkgs.eval patchPkgs; # evaluate flake.nix like it wasn't patched
  in
  {
    ...
  };
}
```
