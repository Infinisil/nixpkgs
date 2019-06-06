{ stdenv, fetchFromGitHub, makeWrapper, phonon, phonon-backend-vlc, qtbase, qmake
, qtdeclarative, qttools

# "Free" key generated by nckx <github@tobias.gr>. I no longer have a Google
# account. You'll need to generate (and please share :-) a new one if it breaks.
, withAPIKey ? "AIzaSyBtFgbln3bu1swQC-naMxMtKh384D3xJZE" }:

stdenv.mkDerivation rec {
  name = "minitube-${version}";
  version = "2.9";

  src = fetchFromGitHub {
    sha256 = "11zkmwqadlgrrghs3rxq0h0fllfnyd3g09d7gdd6vd9r1a1yz73f";
    rev = version;
    repo = "minitube";
    owner = "flaviotordini";
  };

  buildInputs = [ phonon phonon-backend-vlc qtbase qtdeclarative qttools ];
  nativeBuildInputs = [ makeWrapper qmake ];

  qmakeFlags = [ "DEFINES+=APP_GOOGLE_API_KEY=${withAPIKey}" ];

  enableParallelBuilding = true;

  postInstall = ''
    wrapProgram $out/bin/minitube \
      --prefix QT_PLUGIN_PATH : "${phonon-backend-vlc}/lib/qt-5.${stdenv.lib.versions.minor qtbase.version}/plugins"
  '';

  meta = with stdenv.lib; {
    description = "Stand-alone YouTube video player";
    longDescription = ''
      Watch YouTube videos in a new way: you type a keyword, Minitube gives
      you an endless video stream. Minitube is not about cloning the YouTube
      website, it aims to create a new TV-like experience.
    '';
    homepage = "https://flavio.tordini.org/minitube";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ma27 ];
  };
}
