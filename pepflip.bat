@echo off

::: __    __   ______    ______   _______         _______                       __                                  __ 
:::|  \  |  \ /      \  /      \ |       \       |       \                     |  \                                |  \
:::| $$  | $$|  $$$$$$\|  $$$$$$\| $$$$$$$\      | $$$$$$$\  ______    ______  | $$____    ______   _______    ____| $$
:::| $$  | $$| $$   \$$| $$___\$$| $$  | $$      | $$__/ $$ /      \  /      \ | $$    \  |      \ |       \  /      $$
:::| $$  | $$| $$       \$$    \ | $$  | $$      | $$    $$|  $$$$$$\|  $$$$$$\| $$$$$$$\  \$$$$$$\| $$$$$$$\|  $$$$$$$
:::| $$  | $$| $$   __  _\$$$$$$\| $$  | $$      | $$$$$$$ | $$    $$| $$  | $$| $$  | $$ /      $$| $$  | $$| $$  | $$
:::| $$__/ $$| $$__/  \|  \__| $$| $$__/ $$      | $$      | $$$$$$$$| $$__/ $$| $$__/ $$|  $$$$$$$| $$  | $$| $$__| $$
::: \$$    $$ \$$    $$ \$$    $$| $$    $$      | $$       \$$     \| $$    $$| $$    $$ \$$    $$| $$  | $$ \$$    $$
:::  \$$$$$$   \$$$$$$   \$$$$$$  \$$$$$$$        \$$        \$$$$$$$| $$$$$$$  \$$$$$$$   \$$$$$$$ \$$   \$$  \$$$$$$$
:::                                                                  | $$                                              
:::                                                                  | $$                                              
:::                                                                   \$$                                              
for /f "delims=: tokens=*" %%A in ('findstr /b ::: "%~f0"') do @echo(%%A

echo PEPFLIP v0.4
echo Authors: Kirk Wang, Lawrence Lee
echo.

if not exist ".\pepflipped" (
	echo Making pepflipped directory...
	mkdir pepflipped
)

if not exist ".\.tmp" (
	mkdir .tmp
)

REM For every pdf file in the current directory...
for %%i in (*) do (
	if "%%~xi" == ".pdf" (
		echo Processing %%i

		echo Creating tif...
		magick convert -density 600 -compress Group4 -crop 5100x3300+0 "%%i" ".\.tmp\%%~ni.tif"

		echo Pepflipping...
		magick convert ".\.tmp\%%~ni.tif" -rotate 180 ".\.tmp\%%~ni.rotated.tif"
		magick convert ".\.tmp\%%~ni.tif" ".\.tmp\%%~ni.rotated.tif" -append -extent 5100x6600 -gravity Center ".\.tmp\%%~ni.tif"

		echo Creating finalized pdf...
		magick convert ".\.tmp\%%~ni.tif" ".\pepflipped\%%~ni.pdf"

		echo.
	)
)

echo Cleaning up...
rmdir /S /Q .\.tmp

echo Done - output is in the pepflipped directory.
pause