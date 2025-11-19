@echo off

if not exist .\build\ mkdir .\build
cd .\build

call .\pico-sdk\SetEnv.bat

SET CMAKE_BUILD_TYPE=MinSizeRel

if exist .\debugprobe\ goto ok
git clone  --depth=1 --no-single-branch -b debugprobe-v2.0.1 https://github.com/raspberrypi/debugprobe
cd debugprobe
git submodule update --init --depth=1 --no-single-branch
cd ..
:ok

cd .\debugprobe
if not exist .\build\ mkdir build

del /s /Q .\build\*
cd .\build
cmake -DELF2UF2_FOUND=1 -DPioasm_FOUND=1 -DDEBUG_ON_PICO=ON -G Ninja ..\
Ninja
if %ERRORLEVEL% NEQ 0  (echo. Error Ninja build_flash && pause && exit /b 1 )
cd ..\..\
copy .\debugprobe\build\debugprobe_on_pico.uf2 .\
cd ..
pause
