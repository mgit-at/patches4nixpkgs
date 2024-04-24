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

```
let
  patchedpkgs = patches4nixpkgs.patch nixpkgs [
    flake
    other-flake
    self
  ];
in
{
  ...
}
```
