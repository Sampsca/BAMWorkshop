# BAMWorkshop

Description
-----------
A Black Isle Animation [BAM](https://gibberlings3.github.io/iesdp/file_formats/ie_formats/bam_v1.htm) Editor

Copyright
-----------
Copyright © 2001 [Gafware](http://www.gafware.com)

Written By Glenn Flansburg

Email: gafman (at) gafware (dot) com

Baldur's Gate © [Black Isle Studios](http://www.blackisle.com)

UNOFFICIAL PATCH notes
-----------

- 1.1.0.7->1.1.0.8 (Erephine)
	- Background and shadow colours are no longer reset on file load (preserving saved colours)
	- Editing of background and shadow colours enabled from palette editor
	- Offset edit boxes now correctly accept '-' signs typed into them
	- Ability to set shadow (second entry) colour when exporting to .gif (change via SetExportCol.exe)
	- Keyboard shortcuts added for frame/sequence navigation and common commands
	- About page updated to reflect current version

- 1.1.0.8->1.1.0.9 (Sam.)
	- Fixed small graphical glitch on About window
	- Included source code for SetExportCol.exe

- 1.1.0.9->1.1.1.0 (Sam.)
	- Changed the quick color selectors for the transparent/shadow colors from teal/pink to green/black
	- Created schnifty new BAMWconfig.exe program that can be used to set not only the shadow color when exporting to .gif (depreciating SetExportCol.exe) but also the quick color selectors used for the transparent and shadow colors.  [Run "BAMWconfig.exe -about" from the command line to view the legal and copyright info]