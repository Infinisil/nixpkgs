{ stdenv, fetchFromGitHub, wrapGAppsHook
, autoconf, autoconf-archive, automake, gettext, intltool, libtool, pkgconfig
, libICE, libSM, libXScrnSaver, libXtst, cheetah
, gobject-introspection, glib, glibmm, gtkmm3, atk, pango, pangomm, cairo
, cairomm , dbus, dbus-glib, gdome2, gstreamer, gst-plugins-base
, gst-plugins-good, libsigcxx }:

stdenv.mkDerivation rec {
  name = "workrave-${version}";
  version = "1.10.31";

  src = let
  in fetchFromGitHub {
    sha256 = "0v2mx2idaxlsyv5w66b7pknlill9j9i2gqcs3vq54gak7ix9fj1p";
    rev = with stdenv.lib;
      "v" + concatStringsSep "_" (splitString "." version);
    repo = "workrave";
    owner = "rcaelers";
  };

  nativeBuildInputs = [
    autoconf autoconf-archive automake gettext intltool libtool pkgconfig wrapGAppsHook
  ];
  buildInputs = [
    libICE libSM libXScrnSaver libXtst cheetah
    gobject-introspection glib glibmm gtkmm3 atk pango pangomm cairo cairomm
    dbus dbus-glib gdome2 gstreamer gst-plugins-base gst-plugins-good libsigcxx
  ];

  preConfigure = "./autogen.sh";

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "A program to help prevent Repetitive Strain Injury";
    longDescription = ''
      Workrave is a program that assists in the recovery and prevention of
      Repetitive Strain Injury (RSI). The program frequently alerts you to
      take micro-pauses, rest breaks and restricts you to your daily limit.
    '';
    homepage = "http://www.workrave.org/";
    downloadPage = "https://github.com/rcaelers/workrave/releases";
    license = licenses.gpl3;
    maintainers = with maintainers; [ prikhi ];
    platforms = platforms.linux;
  };
}
