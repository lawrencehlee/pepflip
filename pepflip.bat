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

echo PEPFLIP v0.3
echo Authors: Kirk Wang, Lawrence Lee
echo.

if not exist ".\pepflipped" (
	echo Making pepflipped directory...
	mkdir pepflipped
)

REM For every pdf file in the current directory...
for %%i in (*) do (
	if "%%~xi" == ".pdf" (
		echo Processing %%i

		echo Creating upright tif...
		magick convert -density 600 -compress Group4 -crop 5100x3300+0 "%%i" "%%~ni.upright.tif"

		echo Creating flipped tif...
		magick convert -density 600 -compress Group4 -crop 5100x3300+0 -rotate 180 "%%i" "%%~ni.rotated.tif"

		echo Creating appended tif...
		magick convert -append "%%~ni.upright.tif" "%%~ni.rotated.tif" "%%~ni.appended.tif"

		echo Creating finalized pdf...
		magick convert -gravity Center -extent 5100x6600 "%%~ni.appended.tif" "%%~ni.extended.tif"
		magick convert "%%~ni.extended.tif" ".\pepflipped\%%~ni.pdf"

		del "%%~ni.upright.tif"
		del "%%~ni.rotated.tif"
		del "%%~ni.appended.tif"
		del "%%~ni.extended.tif"
		echo.
	)
)

echo Done
pause