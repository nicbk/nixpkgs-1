{ buildPythonPackage
, fetchPypi
, lib
, stdenv
, pythonOlder
, isPy27
, appdirs
, contextlib2
, distlib
, filelock
, importlib-metadata
, importlib-resources
, pathlib2
, setuptools_scm
, six
}:

buildPythonPackage rec {
  pname = "virtualenv";
  version = "20.0.35";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2a72c80fa2ad8f4e2985c06e6fc12c3d60d060e410572f553c90619b0f6efaf3";
  };

  nativeBuildInputs = [
    setuptools_scm
  ];

  requiredPythonModules = [
    appdirs
    distlib
    filelock
    six
  ] ++ lib.optionals isPy27 [
    contextlib2
  ] ++ lib.optionals (isPy27 && !stdenv.hostPlatform.isWindows) [
    pathlib2
  ] ++ lib.optionals (pythonOlder "3.7") [
    importlib-resources
  ] ++ lib.optionals (pythonOlder "3.8") [
    importlib-metadata
  ];

  patches = lib.optionals (isPy27) [
    ./0001-Check-base_prefix-and-base_exec_prefix-for-Python-2.patch
  ];

  meta = {
    description = "A tool to create isolated Python environments";
    homepage = "http://www.virtualenv.org";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ goibhniu ];
  };
}
