call ../../RP2040_SDK/SetEnv.bat
@echo off

%RP2040_SDK%\bin\make.exe uf2
if %ERRORLEVEL% NEQ 0  (echo. Error make && pause && exit /b 1 )


SET BUILD_UF2=
for /r %%x in (*.uf2) do SET BUILD_UF2="%%x"
if NOT EXIST %BUILD_UF2% ( echo 	'build\*.uf2' file not found && pause && exit -1
)
rem %RP2040_SDK%\bin\picotool.exe reboot -f -u
rem timeout 2
rem %RP2040_SDK%\bin\picotool.exe load -x %BUILD_UF2%
rem pause