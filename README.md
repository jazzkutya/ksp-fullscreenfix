#ksp-fullscreenfix v0.1

Changes Kerbal Space Program to run in exclusive fullscreen mode on windows,
when using default d3d9 renderer.

http://forum.kerbalspaceprogram.com/threads/114935-KSP-1-00-and-0-90-windows-true-exclusive-fullscreen-shadowplay-and-gsync-solution

Since 0.90 KSP on windows does not use true (exclusive) fullscreen mode
due to changes in unity. This causes screen tearing issues without aero
(win7) and some loss of performance.

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

