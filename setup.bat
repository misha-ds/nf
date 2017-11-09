@echo off
SET ipath=%~dp0
cd /d "%ipath%"






call path.bat
mkdir  %installDrive%:\%installPath%\tmp


mkdir  %installDrive%:\%installPath%\etc
7za.exe x etc.7z -o%installDrive%:\%installPath%\etc -y -petc

mkdir  %installDrive%:\%installPath%\lib
7za.exe x lib.7z -o%installDrive%:\%installPath%\lib -y -plib

cd /d %installDrive%:\%installPath%\lib\libusb

cd /d "%ipath%"



mkdir  %installDrive%:\%installPath%\git
7za.exe x git.7z -o%installDrive%:\%installPath%\git -y
set path=%installDrive%:\%installPath%\git\bin;%installDrive%:\%installPath%\git\usr\bin;%path%
cd /d %installDrive%:\%installPath%\git\
rem post-install.cmd
cd /d "%ipath%"


7za.exe x node.7z -o%installDrive%:\%installPath%\node -y -pnode
rem echo %installDrive%:\%installPath%\node\pm2.cmd %* > %installDrive%:\%installPath%\bin\pm2.cmd 
rem set PM2_HOME=%installDrive%:\%installPath%\node\service
rem setx PM2_HOME %installDrive%:\%installPath%\node\service -m
setx PATH %installDrive%:\%installPath%\node;%path%
setx PM2_HOME %installDrive%:\%installPath%\node\service

icacls "%installDrive%:\%installPath%\node\service" /grant Everyone:\(OI\)\(CI\)F
icacls "%installDrive%:\%installPath%\node\service" /grant Todos:\(OI\)\(CI\)F

mkdir  %installDrive%:\%installPath%\bin

7za.exe x zk.7z -o%installDrive%:\%installPath%\bin -y -pzk
cd /d %installDrive%:\%installPath%\bin
if /i "%PROCESSOR_IDENTIFIER:~0,3%"=="X86" (
	echo system is x86
	copy .\*.dll %windir%\system32\
	regsvr32 /s /c %windir%\system32\zkemkeeper.dll
	) else (
		echo system is x64
		copy .\*.dll %windir%\SysWOW64\
		regsvr32 /s /c %windir%\SysWOW64\zkemkeeper.dll
	)
	
	
cd /d "%ipath%"

	
7za.exe x net.7z -o%installDrive%:\%installPath%\bin -y -pnet
7za.exe x app.7z -o%installDrive%:\%installPath%\bin -y -papp

cd /d %installDrive%:\%installPath%\bin

setx path %installDrive%:\%installPath%\node;%path%
	
0_register.exe register
ren 0_register.exe 0_register.lic
rem call pm2-setup.bat


cd /d "%ipath%"
cmd /c Fingerprint_Reader_Driver.exe /SP_ /VERYSILENT /NORESTART
rem NDP452-KB2901907-x86-x64-AllOS-ENU /norestart /passive /showrmui

rem NDP462-KB3151800-x86-x64-AllOS-ENU /norestart /passive /showrmui













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
	bcdedit /set nointegritychecks OFF
)

start cmd /c ..\node\pm2 start 5_clientconn.exe
start cmd /c ..\node\pm2 start 7_clientcron.exe
rem rem start cmd /c ..\node\pm2 save

