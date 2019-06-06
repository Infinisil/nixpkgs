{ stdenv, fetchurl, python3Packages, sqlite, which }:

python3Packages.buildPythonApplication rec {
  name = "${pname}-${version}";
  pname = "s3ql";
  version = "2.26";

  src = fetchurl {
    url = "https://bitbucket.org/nikratio/${pname}/downloads/${name}.tar.bz2";
    sha256 = "0xs1jbak51zwjrd6jmd96xl3a3jpw0p1s05f7sw5wipvvg0xnmfn";
  };

  buildInputs = [ which ]; # tests will fail without which
  propagatedBuildInputs = with python3Packages; [
    sqlite apsw pycrypto requests defusedxml dugong llfuse
    cython pytest pytest-catchlog
  ];

  preBuild = ''
    # https://bitbucket.org/nikratio/s3ql/issues/118/no-module-named-s3qldeltadump-running#comment-16951851
    ${python3Packages.python.interpreter} ./setup.py build_cython build_ext --inplace
  '';

  checkPhase = ''
    pytest tests
  '';

  meta = with stdenv.lib; {
    description = "A full-featured file system for online data storage";
    homepage = "https://bitbucket.org/nikratio/s3ql";
    license = licenses.gpl3;
    maintainers = with maintainers; [ rushmorem ];
    platforms = platforms.linux;
  };
}
