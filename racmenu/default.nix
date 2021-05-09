{ python3, dmenu }:

python3.pkgs.buildPythonPackage {
  pname = "racmenu";
  version = "1";
  src = ./src;
  buildInputs = with python3.pkgs; [ setuptools_scm ];
  propagatedBuildInputs = with python3.pkgs; [ xdg dmenu ];

  meta = with lib; {
    description = "A shitty dmenu wrapper for .desktop files";
    license = licenses.unfree;
    maintainers = with import ../maintainer-list.nix; [ raccoon ];
  };  
}