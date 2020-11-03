{ stdenv, python3Packages, mopidy }:

python3Packages.buildPythonApplication rec {
  pname = "Mopidy-Iris";
  version = "3.50.0";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "04miwf0dqb8jir9g7xkfnn3l62bdn74ap03kqzz2v3byg64f1p0g";
  };

  requiredPythonModules = [
    mopidy
  ] ++ (with python3Packages; [
    configobj
    requests
    tornado
  ]);

  # no tests implemented
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = "https://github.com/jaedb/Iris";
    description = "A fully-functional Mopidy web client encompassing Spotify and many other backends";
    license = licenses.asl20;
    maintainers = [ maintainers.rvolosatovs ];
  };
}
