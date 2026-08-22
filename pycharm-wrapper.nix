# pycharm-wrapper.nix
{ pkgs, lib, ... }:

pkgs.jetbrains.pycharm.overrideAttrs (old: {
  nativeBuildInputs = (old.nativeBuildInputs or []) ++ [ pkgs.makeWrapper ];

  postFixup = (old.postFixup or "") + ''
    local_libs="${lib.makeLibraryPath [
      pkgs.libGL
      pkgs.libx11
      pkgs.libxrender
      pkgs.libxtst
      pkgs.fontconfig
      pkgs.stdenv.cc.cc.lib
      pkgs.nspr
      pkgs.nss
      pkgs.alsa-lib
    ]}"

    wrapProgram "$out/bin/pycharm" \
      --prefix LD_LIBRARY_PATH : "$local_libs"
  '';
})
