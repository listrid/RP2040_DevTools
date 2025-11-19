@echo off

call %~d0\RP2040_SDK\SetEnv.bat
%RP2040_SDK%bin\make.exe clean
%RP2040_SDK%bin\make.exe clean debug

rmdir /s /q .\build >NUL