{ stdenv
, fetchPypi
, buildPythonPackage
, pkgconfig
, gtk3
, gobject-introspection
, pygtk
, pygobject3
, goocanvas2
, isPy3k
 }:

with stdenv.lib;

buildPythonPackage rec {
  pname = "GooCalendar";
  version = "0.7.1";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1ccvw1w7xinl574h16hqs6dh3fkpm5n1jrqwjqz3ignxvli5sr38";
  };

  nativeBuildInputs = [
    pkgconfig
    gobject-introspection
  ];

  requiredPythonModules = [
    pygobject3
  ];

  buildInputs = [
    gtk3
    goocanvas2
  ];

  # No upstream tests available
  doCheck = false;

  meta = with stdenv.lib; {
    description = "A calendar widget for GTK using PyGoocanvas.";
    homepage = "https://goocalendar.tryton.org/";
    license = licenses.gpl2;
    maintainers = [ maintainers.udono ];
  };
}
