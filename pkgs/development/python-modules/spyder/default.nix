{ stdenv, buildPythonPackage, fetchPypi, isPy27, makeDesktopItem, intervaltree, jedi, pycodestyle,
  psutil, pyflakes, rope, numpy, scipy, matplotlib, pylint, keyring, numpydoc,
  qtconsole, qtawesome, nbconvert, mccabe, pyopengl, cloudpickle, pygments,
  spyder-kernels, qtpy, pyzmq, chardet, qdarkstyle, watchdog, python-language-server
, pyqtwebengine, atomicwrites, pyxdg, diff-match-patch
}:

buildPythonPackage rec {
  pname = "spyder";
  version = "4.1.5";

  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "d467f020b694193873a237ce6744ae36bd5a59f4d2b7ffbeb15dda68b03f5aa1";
  };

  nativeBuildInputs = [ pyqtwebengine.wrapQtAppsHook ];

  requiredPythonModules = [
    intervaltree jedi pycodestyle psutil pyflakes rope numpy scipy matplotlib pylint keyring
    numpydoc qtconsole qtawesome nbconvert mccabe pyopengl cloudpickle spyder-kernels
    pygments qtpy pyzmq chardet pyqtwebengine qdarkstyle watchdog python-language-server
    atomicwrites pyxdg diff-match-patch
  ];

  # There is no test for spyder
  doCheck = false;

  desktopItem = makeDesktopItem {
    name = "Spyder";
    exec = "spyder";
    icon = "spyder";
    comment = "Scientific Python Development Environment";
    desktopName = "Spyder";
    genericName = "Python IDE";
    categories = "Development;IDE;";
  };

  postPatch = ''
    # remove dependency on pyqtwebengine
    # this is still part of the pyqt 5.11 version we have in nixpkgs
    sed -i /pyqtwebengine/d setup.py
    substituteInPlace setup.py \
      --replace "pyqt5<5.13" "pyqt5" \
      --replace "parso==0.7.0" "parso" \
      --replace "jedi==0.17.1" "jedi"
  '';

  postInstall = ''
    # add Python libs to env so Spyder subprocesses
    # created to run compute kernels don't fail with ImportErrors
    wrapProgram $out/bin/spyder3 --prefix PYTHONPATH : "$PYTHONPATH"

    # Create desktop item
    mkdir -p $out/share/icons
    cp spyder/images/spyder.svg $out/share/icons
    cp -r $desktopItem/share/applications/ $out/share
  '';

  dontWrapQtApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${qtWrapperArgs[@]}")
  '';

  meta = with stdenv.lib; {
    description = "Scientific python development environment";
    longDescription = ''
      Spyder (previously known as Pydee) is a powerful interactive development
      environment for the Python language with advanced editing, interactive
      testing, debugging and introspection features.
    '';
    homepage = "https://www.spyder-ide.org/";
    downloadPage = "https://github.com/spyder-ide/spyder/releases";
    changelog = "https://github.com/spyder-ide/spyder/blob/master/CHANGELOG.md";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ gebner ];
  };
}
