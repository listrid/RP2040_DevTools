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
cmake -G Ninja ..\..\pico-sdk\tools\pioasm
Ninja
cd ..

mkdir .\elf2uf2
cd elf2uf2
cmake -G Ninja ..\..\pico-sdk\tools\elf2uf2
Ninja
cd ..
copy .\elf2uf2\elf2uf2.exe ..\RP2040_SDK\bin\elf2uf2.exe
copy .\pioasm\pioasm.exe   ..\RP2040_SDK\bin\pioasm.exe
pause
