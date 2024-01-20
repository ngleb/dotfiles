{ stdenv, fetchurl, pkg-config, deadbeef, gtk3, autoconf, automake, libtool, glib }:
stdenv.mkDerivation rec {
  pname = "deadbeef-fb";
  version = "git";
  src = fetchurl {
    url = "https://gitlab.com/zykure/deadbeef-fb/-/archive/master/deadbeef-fb-master.tar.gz";
    sha256 = "05a4c5468cbe1465f5277ead182f5f1ea6e46a93e8fdfad0dafc6be9de4407fa";
  };

  nativeBuildInputs = [ autoconf automake libtool pkg-config ];
  buildInputs = [ deadbeef glib gtk3 ];

  preConfigure = ''
    ./autogen.sh
  '';

  configureFlags = [ "--prefix=$(out)" "--disable-gtk2" ];
}
