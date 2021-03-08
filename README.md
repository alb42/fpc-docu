# fpc-docu
Freepascal Amiga Systems documentation

Contains XML description for library units for Amiga, AROS, MorphOS, AmigaOS4

## Create Documentation

To create HTML and CHM files for all four you need ''fpdoc'' util of Free Pascal start:

make clean all

it will checkout the library unit directories and create HTML and CHM.
the bare HTML pages are kept in ''*html'' folder and packed as archive ''*.tgz''

Daily created documentation can be found on the build server: https://build.alb42.de/fpcbin/docu/