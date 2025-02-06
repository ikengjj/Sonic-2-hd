@echo off
cd /d %~dp0

echo Sonic 2 Absolute Setup


if exist Data\Game\GameConfig.bin (goto :dataq) else (goto :data)



:dataq
	echo.
	echo There is already a data folder here.
	choice  /m "Do you want to overwrite it?"
	IF %ERRORLEVEL% EQU 1 rd /q /s Data
	IF %ERRORLEVEL% EQU 1 goto :data
goto :afterdata




:data	
	echo.
	if exist data.rsdk (goto :rsdkid)

	echo Extracting data from APK file...
	:: Extract the data from the app
	7za e *.apk Data.rsdk.xmf -r -aoa > nul

	:: Check that the extraction was successful
	if exist Data.rsdk.xmf (echo Extraction successful) else (goto :nodatarsdk)
	echo.
	echo Unpacking data file...


	:: remove the .xmf at the end of the data file
	ren Data.rsdk.xmf Data.rsdk

	::Get out retrun
	7za e absolute.data  Retrun\retrun.exe > nul

	7za e absolute.data  Retrun\RSDKv4FileList.txt > nul


	:: run the regular Sonic 1 unpack script
	retrun x Data.rsdk -3 -L=RSDKv4FileList.txt

	::finished with Data.rsdk, delete it
	del Data.rsdk

	
	::finished with Retrun, delete it
	rd /q /s ByteCode
	del retrun.exe
	del RSDKv4FileList.txt


	if exist Data\Game\GameConfig.bin (echo Data unpacked) else (goto :unpackfailed)
	echo.
	echo Patching data...
	
	7za x absolute.data Data\* -r -aoa > nul

	if exist Data\Stages\MainMenu\Act1.bin (echo Data patched) else (goto :patchfailed)

goto :afterdata



:afterdata
if exist Scripts\Players\PlayerObject.txt (goto :scriptsq) else (goto :scripts)



:scriptsq
echo.
echo There is already a scripts folder here.
choice  /m "Do you want to overwrite it?"
IF %ERRORLEVEL% EQU 1 rd /q /s Scripts
IF %ERRORLEVEL% EQU 1 goto :scripts
goto :afterscripts



:scripts
echo.
echo Unpacking Scripts...
7za x absolute.data Scripts\* -r > nul
if exist Scripts\Players\PlayerObject.txt (echo Scripts unpacked.) else (goto :scriptsfailed)
goto :afterscripts



:afterscripts
echo.
echo Unpacking game executable...
if exist SDL2.dll (del SDL2.dll)
7za e absolute.data SDL2.dll -r > nul
if exist glew32.dll (del glew32.dll)
::7za e absolute.data glew32.dll -r > nul
if exist msvcp140.dll (del msvcp140.dll)
7za e -t7z absolute.data msvcp140.dll -r > nul
if exist vcruntime140.dll (del vcruntime140.dll)
7za e -t7z absolute.data vcruntime140.dll -r > nul
if exist Sonic2Absolute.exe (del Sonic2Absolute.exe)
7za e absolute.data Sonic2Absolute.exe -r > nul
if not exist Mods\NUL (MD Mods)
echo Setup Complete!
PING localhost -n 3 >NUL
exit

:rsdkid
	echo Found data.rsdk file. Using data.rsdk for setup...

	echo.
	echo Unpacking data file...

	::Get out retrun
	7za e -t7z absolute.data  Retrun\retrun.exe > nul

	7za e -t7z absolute.data  Retrun\RSDKv4FileList.txt > nul

	:: run the regular Sonic 1 unpack script
	retrun x Data.rsdk -3 -L=RSDKv4FileList.txt

	::finished with Retrun, delete it
	rd /q /s ByteCode
	del retrun.exe
	del RSDKv4FileList.txt

	if exist Data\Game\GameConfig.bin (echo Data unpacked) else (goto :unpackfailed)
	echo.
	echo Patching data...
	
	7za x -t7z absolute.data Data\* -r -aoa > nul

	if exist Data\Stages\MainMenu\Act1.bin (echo Data patched) else (goto :patchfailed)

goto :afterdata




::Error Handling

:nodatarsdk
echo.
echo The data file could not be extracted.
echo Please make sure you have provided a copy of "Sonic the Hedgehog 2 Classic".
echo Press any key to exit.
Pause >nul
exit



:unpackfailed
echo.
echo The data file could not be unpacked. There may be an issue with your Sonic 2 Absolute download.
echo Press any key to exit.
Pause >nul
exit



:patchfailed
echo.
echo The data patch could not be applied. There may be an issue with your Sonic 2 Absolute download.
echo Press any key to exit.
Pause >nul
exit



:scriptsfailed
echo.
echo The game scripts could not be unpacked. There may be an issue with your Sonic 2 Absolute download.
echo Press any key to exit.
Pause >nul
exit