[![Codacy Badge](https://api.codacy.com/project/badge/Grade/ced3d7489b0441929563cacfbe5b8e47)](https://www.codacy.com/app/pegasus.ict/PBFL?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=pegasusict/PBFL&amp;utm_campaign=Badge_Grade)

# PBFL - PEGASUS' BASH FUNCTION LIBRARY
This is my attempt at building a better function library for BASH

Update nov 4th 2019: implemented a new autloloading system, inspired on PHP's autoloader
place your lib file in the "lib" directory, and a file in the autoload directory with the function loaders, see one of the existing ".load.bash" files for examples.
the "autoload" filenames aren't subject to a specific format (yet). the "lib" files are!!!

acknowledgements:
ini parser: Ruediger Meier (https://github.com/rudimeier/)
