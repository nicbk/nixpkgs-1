{ lib, stdenv, python3, openssl
, enableSystemd ? stdenv.isLinux, nixosTests
, enableRedis ? false
}:

with python3.pkgs;

let
  plugins = python3.pkgs.callPackage ./plugins { };
in
buildPythonApplication rec {
  pname = "matrix-synapse";
  version = "1.22.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1pbxdqpfa7wzdz61p6x58x7841vng1g65qayxgcw73bn1shl50jb";
  };

  patches = [
    # adds an entry point for the service
    ./homeserver-script.patch
  ];

  requiredPythonModules = [
    setuptools
    bcrypt
    bleach
    canonicaljson
    daemonize
    frozendict
    jinja2
    jsonschema
    lxml
    msgpack
    netaddr
    phonenumbers
    pillow
    prometheus_client
    psutil
    psycopg2
    pyasn1
    pymacaroons
    pynacl
    pyopenssl
    pysaml2
    pyyaml
    requests
    signedjson
    sortedcontainers
    treq
    twisted
    unpaddedbase64
    typing-extensions
    authlib
    pyjwt
  ] ++ lib.optional enableSystemd systemd
    ++ lib.optional enableRedis hiredis;

  checkInputs = [ mock parameterized openssl ];

  doCheck = !stdenv.isDarwin;

  checkPhase = ''
    ${lib.optionalString (!enableRedis) "rm -r tests/replication # these tests need the optional dependency 'hiredis'"}
    PYTHONPATH=".:$PYTHONPATH" ${python3.interpreter} -m twisted.trial tests
  '';

  passthru.tests = { inherit (nixosTests) matrix-synapse; };
  passthru.plugins = plugins;
  passthru.python = python3;

  meta = with stdenv.lib; {
    homepage = "https://matrix.org";
    description = "Matrix reference homeserver";
    license = licenses.asl20;
    maintainers = teams.matrix.members;
  };
}
