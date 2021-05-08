{ python3, dmenu }:

python3.pkgs.buildPythonPackage {
  pname = "racmenu";
  version = "1";
  src = ./src;
  buildInputs = with python3.pkgs; [ setuptools_scm ];
  propagatedBuildInputs = with python3.pkgs; [ xdg dmenu ];
}