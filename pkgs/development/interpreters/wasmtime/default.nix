{ rustPlatform, fetchFromGitHub, lib, python, cmake, llvmPackages, clang }:

rustPlatform.buildRustPackage rec {
  name = "wasmtime-${version}";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "CraneStation";
    repo = "wasmtime";
    rev = "07a6ca8f4e1136ecd9f4af8d1f03a01aade60407";
    sha256 = "1cq6nz90kaf023mcyblca90bpvbzhq8xjq01laa28v7r50lagcn5";
    fetchSubmodules = true;
  };

  cargoSha256 = "0xy8vazb4nc4q1098ws92j1yfwp9w7q30z0yk2gindkn898603bc";

  cargoPatches = [ ./cargo-lock.patch ];

  nativeBuildInputs = [ python cmake clang ];
  buildInputs = [ llvmPackages.libclang ];

  LIBCLANG_PATH = "${llvmPackages.libclang}/lib";

  meta = with lib; {
    description = "Standalone JIT-style runtime for WebAsssembly, using Cranelift";
    homepage = "https://github.com/CraneStation/wasmtime";
    license = licenses.asl20;
    maintainers = [ maintainers.matthewbauer ];
    platforms = platforms.unix;
  };
}
