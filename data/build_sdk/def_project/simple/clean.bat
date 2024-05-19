@echo off
call ..\..\RP2040_SDK\SetEnv.bat

%RP2040_SDK%bin\make.exe clean
%RP2040_SDK%bin\make.exe clean debug
