{ lib
, stdenv
, fetchFromGitHub
, buildGoModule
}:

buildGoModule rec {
  pname = "spoofdpi";
  version = "v0.12.0-git";

  src = fetchFromGitHub {
    owner = "xvzc";
    repo = "SpoofDPI";
    rev = "a2993ac68d87a0525a93bc23984d21e341214199";
    hash = "sha256-+r3NosJejJu9M64kDnD05Gc6eYfaVdIdod/R2KMISKI=";
  };

  vendorHash = "sha256-47Gt5SI6VXq4+1T0LxFvQoYNk+JqTt3DonDXLfmFBzw=";
}
