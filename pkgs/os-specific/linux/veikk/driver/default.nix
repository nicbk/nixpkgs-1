{ lib, stdenv, fetchFromGitHub, kernel }:

stdenv.mkDerivation rec {
  pname = "veikk-linux-driver";
  version = "v2.0";

  src = fetchFromGitHub {
    owner = "jlam55555";
    repo = pname;
    rev = version;
    sha256 = "11mg74ds58jwvdmi3i7c4chxs6v9g09r9ll22pc2kbxjdnrp8zrn";
  };

  nativeBuildInputs = kernel.moduleBuildDependencies;

  buildInputs = [ kernel ];

  buildPhase = ''
    make BUILD_DIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build
  '';

  installPhase = ''
    mkdir -p $out/lib/modules/${kernel.modDirVersion}/kernel/drivers/veikk
    install -Dm755 veikk.ko $out/lib/modules/${kernel.modDirVersion}/kernel/drivers/veikk
  '';

  meta = with lib; {
    description = "Linux driver for VEIKK-brand digitizers";
    homepage = "https://github.com/jlam55555/veikk-linux-driver/";
    license = licenses.unfree;
    platforms = platforms.linux;
    maintainers = with maintainers; [ nicbk ];
  };
}
