@echo off
SET ipath=%~dp0
cd /d "%ipath%"






@echo off
setlocal EnableDelayedExpansion
for /f "tokens=4-7 delims=[.] " %%i in ('ver') do (
set vv=%%i
set vv=!vv:~1,3!
if !vv! == ers (set v=%%j) else (set v=%%i)
)

echo %v%

set PM2_HOME=%installDrive%:\%installPath%\node\service
if %v% == 5 (
echo "windows XP"
	start cmd /c %installDrive%:\%installPath%\bin\setx PM2_HOME %installDrive%:\%installPath%\node\service
	start cmd /c %installDrive%:\%installPath%\node\pm2-startup install
	start cmd /c vcredist08_x86 /q
	start cmd /c vcredist10_x86 /norestart /passive
	rem start cmd /c vcredist10_x86 /norestart /q
)
if %v% GEQ 6 (
    setx PM2_HOME %installDrive%:\%installPath%\node\service -m
	start cmd /c ..\node\pm2-service-install -n novafarma-terminal
	echo "windows vista o superior"
)

rem start cmd /c ..\node\pm2 start 5_clientconn.exe
rem start cmd /c ..\node\pm2 start 7_clientcron.exe
rem rem rem start cmd /c ..\node\pm2 save

