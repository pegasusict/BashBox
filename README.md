[![Codacy Badge](https://api.codacy.com/project/badge/Grade/ced3d7489b0441929563cacfbe5b8e47)](https://www.codacy.com/app/pegasus.ict/PBFL?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=pegasusict/PBFL&amp;utm_campaign=Badge_Grade)

# BashBox - A BASH FrameWork
This is my attempt at building a framework for BASH.

### Update july 2nd 2020: A complete overhaul has begun
I've decided to change my function library into a framework due to added benefits.
### (planned) functionality:
 -[x] dynamic loading of modules
 -[ ] automagic installing/updating of framework/modules
 -[x] logging
 -[x] ini parsing
 -[x] apt-get functionality
 -[ ] git functionality
 -[x] exit code handling
 -[x] date/time functions
 -[x] file generation/modification
 -[ ] templating
 -[x] filesystem operations
 -[ ] temporary files
 -[ ] mutex functionality
 -[ ] RSA functionality
 *edit in progress...*

### Update nov 4th 2019: implemented a new autloloading system, inspired on PHP's autoloader.
Place your lib file in the "lib" directory and a file in the autoload directory. See one of the existing ".load.bash" files for examples.

--
Acknowledgements:
ini parser: Ruediger Meier (https://github.com/rudimeier/)
