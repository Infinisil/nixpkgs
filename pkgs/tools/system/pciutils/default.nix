{ stdenv, fetchurl, pkgconfig, zlib, kmod, which }:

stdenv.mkDerivation rec {
  name = "pciutils-3.6.2"; # with release-date database

  src = fetchurl {
    url = "mirror://kernel/software/utils/pciutils/${name}.tar.xz";
    sha256 = "1wwkpglvvr1sdj2gxz9khq507y02c4px48njy25divzdhv4jwifv";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ zlib kmod which ];

  makeFlags = [
    "SHARED=yes"
    "PREFIX=\${out}"
    "STRIP="
    "HOST=${stdenv.hostPlatform.system}"
    "CROSS_COMPILE=${stdenv.cc.targetPrefix}"
    "DNS=yes"
  ];

  installTargets = "install install-lib";

  # Get rid of update-pciids as it won't work.
  postInstall = "rm $out/sbin/update-pciids $out/man/man8/update-pciids.8";

  meta = with stdenv.lib; {
    homepage = "http://mj.ucw.cz/pciutils.html";
    description = "A collection of programs for inspecting and manipulating configuration of PCI devices";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = [ maintainers.vcunat ]; # not really, but someone should watch it
  };
}
