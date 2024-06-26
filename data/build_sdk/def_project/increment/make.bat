@echo off
call ..\..\RP2040_SDK\SetEnv.bat

%RP2040_SDK%bin\picotool.exe reboot -f -u

%RP2040_SDK%bin\make.exe uf2
if %ERRORLEVEL% NEQ 0  (echo. Error make && pause && exit /b 1 )

SET BUILD_UF2=
for /r %%x in (*.uf2) do SET BUILD_UF2="%%x"
if NOT EXIST %BUILD_UF2% ( echo 	'build\*.uf2' file not found && pause && exit -1 )

timeout 1
%RP2040_SDK%bin\picotool.exe load -x %BUILD_UF2%
if %ERRORLEVEL% NEQ 0  (echo. Error load && pause && exit /b 1 )
