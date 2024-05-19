@echo off
set IDE_DIR_NAME=!IDE

if not exist .\build\ mkdir .\build

curl -L "https://go.microsoft.com/fwlink/?Linkid=850641" --output .\build\VSCode.zip
if %ERRORLEVEL% NEQ 0  (echo. Error download VSCode.zip && pause && exit /b 1 )

"%~dp0data\python.exe" "%~dp0data/unzip.py" "%~dp0build\VSCode.zip" "%~dp0build\%IDE_DIR_NAME%"
if %ERRORLEVEL% NEQ 0  (echo. Error extract VSCode.zip && pause && exit /b 1 )

cd "%~dp0build\%IDE_DIR_NAME%\"

mkdir ".\data"
mkdir ".\data\user-data"
mkdir ".\data\user-data\User"
mkdir ".\data\user-data\User\globalStorage"
copy "%~dp0data\build_ide\settings.json" ".\data\user-data\User\"
copy "%~dp0data\build_ide\state.vscdb"   ".\data\user-data\User\globalStorage\"

setlocal
set VSCODE_DEV=
set ELECTRON_RUN_AS_NODE=1
".\Code.exe" ".\resources\app\out\cli.js" --install-extension ms-vscode.cpptools
if %ERRORLEVEL% NEQ 0  (echo. Error VSCode && pause && exit /b 1 )
".\Code.exe" ".\resources\app\out\cli.js" --install-extension ms-vscode.cpptools-extension-pack
".\Code.exe" ".\resources\app\out\cli.js" --install-extension ms-vscode.vscode-serial-monitor
".\Code.exe" ".\resources\app\out\cli.js" --install-extension marus25.cortex-debug
".\Code.exe" ".\resources\app\out\cli.js" --install-extension augustocdias.tasks-shell-input
".\Code.exe" ".\resources\app\out\cli.js" --install-extension spmeesseman.vscode-taskexplorer
".\Code.exe" ".\resources\app\out\cli.js" --install-extension pkief.material-icon-theme
".\Code.exe" ".\resources\app\out\cli.js" --install-extension %~dp0data\build_ide\pi2040_def_env.vsix

cd ..
echo call .\RP2040_SDK\SetEnv.bat> run_IDE.bat
echo start ./%IDE_DIR_NAME%/Code.exe>> run_IDE.bat
del VSCode.zip
echo "		|===============================|"
echo "		|      Build IDE completed      |"
echo "		|===============================|"
pause
