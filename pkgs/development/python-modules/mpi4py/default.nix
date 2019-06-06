{ stdenv, fetchPypi, fetchpatch, python, buildPythonPackage, mpi, openssh }:

buildPythonPackage rec {
  pname = "mpi4py";
  version = "3.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0ld8rjmsjr0dklvj2g1gr3ax32sdq0xjxyh0cspknc1i36waajb5";
  };

  passthru = {
    inherit mpi;
  };

  patches = [ ( fetchpatch {
    # Upstream patch to ensure compatibility with openmpi-4.0.1
    url = "https://github.com/mpi4py/mpi4py/commit/42f5e35a6a90454516c11131549a08cd766edbb0.patch";
    sha256 = "1dm0i3amwj1cddzz1m9ssd7qp655c8rv1wzjs9ww3kzd90fm4w72";
  })];

  postPatch = ''
    substituteInPlace test/test_spawn.py --replace \
                      "unittest.skipMPI('openmpi(<3.0.0)')" \
                      "unittest.skipMPI('openmpi')"
  '';

  configurePhase = "";

  installPhase = ''
    mkdir -p "$out/lib/${python.libPrefix}/site-packages"
    export PYTHONPATH="$out/lib/${python.libPrefix}/site-packages:$PYTHONPATH"

    ${python}/bin/${python.executable} setup.py install \
      --install-lib=$out/lib/${python.libPrefix}/site-packages \
      --prefix="$out"

    # --install-lib:
    # sometimes packages specify where files should be installed outside the usual
    # python lib prefix, we override that back so all infrastructure (setup hooks)
    # work as expected

    # Needed to run the tests reliably. See:
    # https://bitbucket.org/mpi4py/mpi4py/issues/87/multiple-test-errors-with-openmpi-30
    export OMPI_MCA_rmaps_base_oversubscribe=yes
  '';

  setupPyBuildFlags = ["--mpicc=${mpi}/bin/mpicc"];

  nativeBuildInputs = [ mpi openssh ];

  meta = {
    description =
      "Python bindings for the Message Passing Interface standard";
    homepage = "http://code.google.com/p/mpi4py/";
    license = stdenv.lib.licenses.bsd3;
  };
}
