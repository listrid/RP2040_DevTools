@echo off

if not exist .\build\ mkdir .\build
cd .\build

if exist .\pico-sdk\ goto ok_sdk
git clone --depth=1 --no-single-branch --shallow-submodules -b master https://github.com/raspberrypi/pico-sdk.git
cd pico-sdk
git submodule update --init --depth=1 --no-single-branch
del /S /Q /F .\.git >NUL
rmdir /s /q .\.git >NUL
del /S /Q /F .\.github >NUL
rmdir /s /q .\.github >NUL
cd ..
mkdir .\pico-sdk\soft
"%~dp0data\python.exe" "%~dp0data/unzip.py" "%~dp0data/build_sdk/portable_bin.zip" "%~dp0build/pico-sdk"
:ok_sdk

if exist .\pico-examples\ goto ok_examples
git clone --depth=1 --no-single-branch -b master https://github.com/raspberrypi/pico-examples.git
cd pico-examples
del /S /Q /F .\.git >NUL
rmdir /s /q .\.git >NUL
del /S /Q /F .\.github >NUL
rmdir /s /q .\.github >NUL
cd ..
:ok_examples

call .\pico-sdk\SetEnv.bat

if not exist .\RP2040_SDK     mkdir .\RP2040_SDK
if not exist .\RP2040_SDK\tmp mkdir .\RP2040_SDK\tmp
copy "%~dp0data\build_sdk\CMakeLists.txt" .\RP2040_SDK\tmp
copy "%~dp0data\build_sdk\create_lib.py"  .\RP2040_SDK\tmp
copy "%~dp0data\build_sdk\SetEnv.bat"     .\RP2040_SDK
copy "%~dp0data\build_sdk\debugprobe_on_pico.uf2" .\RP2040_SDK
cd .\RP2040_SDK\tmp

SET STDOUT_UART=0
SET STDOUT_USB=1
SET STDOUT_SEMIHOSTING=0

cmake -G Ninja -B . -D pico-sdk-tools_DIR:PATH=%PICO_SDK_TOOLS_PATH%  -S .
if %ERRORLEVEL% NEQ 0  (echo. Error cmake build_flash && pause && exit /b 1 )

Ninja
if %ERRORLEVEL% NEQ 0  (echo. Error Ninja build_flash && pause && exit /b 1 )

xcopy /q /e /Y "%~dp0build\pico-sdk\soft\" "%~dp0build\RP2040_SDK\"

"%~dp0data\python.exe" create_lib.py
if %ERRORLEVEL% NEQ 0  (echo. Error python create_lib && pause && exit /b 1 )

cd ..\lib
%PICO_TOOLCHAIN_PATH%\bin\arm-none-eabi-ar.exe x libpico.a reset_interface.c.obj
%PICO_TOOLCHAIN_PATH%\bin\arm-none-eabi-ar.exe d libpico.a reset_interface.c.obj
cd ..
del /S /Q /F .\tmp >NUL
rmdir /s /q .\tmp >NUL
cd ..

if not exist .\Projects\ mkdir .\Projects
if not exist .\Projects\!def_project\ mkdir .\Projects\!def_project

xcopy /q /E /Y "%~dp0data\build_sdk\def_project" .\Projects\!def_project
echo "		|================================|"
echo "		|     Build PI2040 completed     |"
echo "		|================================|"

pause
