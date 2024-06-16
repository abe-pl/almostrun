set RadiantPath="D:\Games\netradiant-custom-20240309"
set EnginePath="D:\Games\wolfcamql12.6"
set ZipPath="C:\Program Files\7-zip"
set SteamCmdPath="D:\Games\steamcmd"
set SteamVdfPath="D:\Games\Quake Live\almostrun"

@echo off
if "%1" == "" goto usage
if "%1" == "clean" goto clean
if "%1" == "build" goto build
if "%1" == "pack" goto pack
if "%1" == "upload" goto upload
goto end

:usage
echo requirements:
echo - [https://github.com/Garux/netradiant-custom] 
echo - [https://7-zip.org]
echo - [https://github.com/brugal/wolfcamql]
echo - [pak00.pk3 from Quakelive\baseq3 to wolfcamql\baseq3]
echo - [zz-q3netpack.pk3 from netradiant-custom\gamepacks\Q3.game to wolfcamql\baseq3]
echo - [https://developer.valvesoftware.com/wiki/SteamCMD] only for upload to steam workshop
echo edit make.bat
echo set RadiantPath and EnginePath
echo make.bat build
echo make.bat pack
echo "gl&hf"
goto end

:clean
del src\maps\almostrun.bsp
del src\maps\almostrun.srf
del src\maps\almostrun.aas
del bspc.log
goto end

:build
%RadiantPath%\q3map2.exe -game quakelive -fs_basepath %EnginePath% -fs_game baseq3 -meta src\maps\almostrun.map
%RadiantPath%\q3map2.exe -game quakelive -fs_basepath %EnginePath% -fs_game baseq3 -vis src\maps\almostrun.map
%RadiantPath%\q3map2.exe -game quakelive -fs_basepath %EnginePath% -fs_game baseq3 -light -bounce 8 -fastbounce -dark -dirtdepth 32 -dirtscale 3 -dirty -patchshadows -samples 3 -scale 1.2 -shade -cpma src\maps\almostrun.map
%RadiantPath%\mbspc.exe -forcesidesvisible -optimize -bsp2aas src\maps\almostrun.bsp
goto end

:pack
if not exist src\maps\almostrun.bsp (
	echo Build map first: make.bat build
	goto end
)
rd /s /q content
mkdir content
%ZipPath%\7z.exe a -tzip content\almostrun.pk3 .\src\* -xr!*.map -xr!*.srf -xr!*.log -xr!*.bak
goto end

:upload
if "%SteamUser%"=="" (
	echo set SteamUser=your_steam_login
	goto end
)
if "%SteamPass%"=="" (
	echo set SteamPass=your_steam_password
	goto end
)
%SteamCmdPath%\steamcmd.exe +login %SteamUser% %SteamPass% +workshop_build_item %SteamVdfPath%\almostrun.vdf +quit
goto end

:end