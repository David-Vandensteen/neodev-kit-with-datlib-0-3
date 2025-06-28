To configure the environment to your machine you will need to edit
2 batchfiles:

setmvs.bat (in the environment root directory)
----------
This file sets an environment variable to the root of the neo dev 
environment e.g. if you have unzipped this to d:\neodev then the
line should read
        set neodev=d:\neodev
It also puts the compiler binaries on the path, so again you need
to change the path to match where you have unzipped the dev
environment to plus \m68k\bin e.g. if you have unzipped this to
d:\neodev then the line should read
        path=d:\neodev\m68k\bin;%path%


makeroms.bat (in the m68k\bin directory)
------------
This batch file converts your compiled binaries to rom images
suitable for testing in MAME. It currently creates a Puzzle De Pon
romset (202-??.bin) and copies them to a puzzledp subdirectory
under your MAME installation. You will need to edit this batch
file to change the 'copy' statement to copy to your  
ROMS\PUZZLEDP directory under MAME.

------------

Finally, once you have done the above you can compile the 
libraries and samples. Under the 'src' directory there are two
batch files to make this easier. 'Build-Libs' and 'Build-Samples'
you must run 'Build-Libs' first as the samples demonstrate the
use of the library.

