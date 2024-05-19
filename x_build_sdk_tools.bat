if not exist .\build\ mkdir .\build
cd .\build

call .\pico-sdk\SetEnv.bat
call "C:\Program Files\Microsoft Visual Studio\2022\Professional\VC\Auxiliary\Build\vcvarsall.bat" x64

mkdir .\build_tools
del /s /Q .\build_tools\*
cd .\build_tools

SET CMAKE_BUILD_TYPE=MinSizeRel

mkdir .\pioasm
cd pioasm
cmake -G Ninja ..\..\..\pico-sdk\tools\pioasm
Ninja
cd ..

mkdir .\elf2uf2
cd elf2uf2
cmake -G Ninja ..\..\..\pico-sdk\tools\elf2uf2
Ninja
cd ..

rem copy .\elf2uf2\elf2uf2.exe .\soft\bin\elf2uf2.exe
rem copy .\pioasm\pioasm.exe   .\soft\bin\pioasm.exe
pause
