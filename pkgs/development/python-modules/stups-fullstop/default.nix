{ lib
, fetchFromGitHub
, buildPythonPackage
, requests
, stups-cli-support
, stups-zign
, pytest
, pytestcov
, isPy3k
}:

buildPythonPackage rec {
  pname = "stups-fullstop";
  version = "1.1.31";
  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "zalando-stups";
    repo = "fullstop-cli";
    rev = version;
    sha256 = "1cpzz1b8g2mich7c1p74vfgw70vlxpgwi82a1ld82wv3srwqa0h3";
  };

  requiredPythonModules = [
    requests
    stups-cli-support
    stups-zign
  ];

  preCheck = "
    export HOME=$TEMPDIR
  ";

  checkInputs = [
    pytest
    pytestcov
  ];

  meta = with lib; {
    description = "Convenience command line tool for fullstop. audit reporting.";
    homepage = "https://github.com/zalando-stups/stups-fullstop-cli";
    license = licenses.asl20;
    maintainers = [ maintainers.mschuwalow ];
  };
}
