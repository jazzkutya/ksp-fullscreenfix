#ksp-fullscreenfix v0.1131

Changes Kerbal Space Program to run in exclusive fullscreen mode on windows,
when using default d3d9 renderer.

http://forum.kerbalspaceprogram.com/index.php?/topic/103537-ksp-11x-10x-090-windows-true-exclusive-fullscreen-shadowplay-and-gsync-solution/

Since 0.90 KSP on windows does not use true (exclusive) fullscreen mode
due to changes in unity. This causes screen tearing issues without aero
(win7) and some loss of performance.

**NEW** KSP versions above 1.1.0.1183 have both 32bit and 64bit mode.
This patcher modifies only the 64bit version for those KSP versions.

**WARNING** since the public release of KSP 1.1 I can not alt-tab back into the game on Win7.
Test this first on KSP main menu to know ahead if you will have any problems
alt-tabbing out of KSP in the middle of a high-stake mission :)
seems to be working again since 1.1.1.

This program modifies one file in Kerbal Space Program (KSP_Data\mainData)
to make it use good old real fullscreen mode (exclusive fullscreen mode).

NOTE This means KSP will not run in the background.

 USAGE
 
Copy ksp-fullscreenfix.exe (or ksp-fullscreenfix.pl from this repo's Source
folder if you have strawberry perl installed) to the top folder of your Kerbal
Space Program Installation (where KSP.exe and GameData folder is. Do not put
it into GameData).

Run it from there and read what it says in a console window.

You can delete ksp-fullscreenfix.pl from your KSP install folder after it
made the modification.

It will make a backup file in KSP_Data: mainData-ksp-fullscreenfix-backup

NOTE KSP will not run in the background after the modification
but you can restore KSP_Data\mainData from the backup anytime, or verify
integrity of game cache in steam to restore the original file.

----------------------------------------------------------------------

The exe file was created from the source with 32bit strawberry perl 5.20.2
on windows 7, using Par::Packer (http://search.cpan.org/~rschupp/PAR-Packer-1.025/)

command line:
pp -o ksp-fullscreenfix.exe ksp-fullscreenfix.pl
