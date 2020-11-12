@ECHO off

rem ======================================================================================================
rem USER CONFIGURATION
rem ======================================================================================================

SET "MODPACK_NAME=AllTheClan"
SET "MODPACK_URL=https://github.com/OOClan/AllTheClan/archive/data.zip"
SET "CORNSTONE_VERSION_URL=https://raw.githubusercontent.com/OOClan/AllTheClan/data/.cornstone"

SET "CORNSTONE_FILE=%CD%\%MODPACK_NAME%-cornstone.exe"
SET "LAUNCHER_DIR=%CD%\%MODPACK_NAME%-multimc"
SET "SERVER_DIR=%CD%\%MODPACK_NAME%-server"

rem ======================================================================================================

:MENU
CLS

ECHO.
ECHO ...............................................
ECHO  %MODPACK_NAME% Launcher
ECHO ...............................................
ECHO.
ECHO  1 - Install or update
ECHO  2 - Play
ECHO  3 - Reset
ECHO  4 - Install or update server
ECHO  5 - Exit
ECHO.

SET /P M=Type a number then press ENTER: 
CLS

IF %M%==1 GOTO :INSTALL
IF %M%==2 GOTO :PLAY
IF %M%==3 GOTO :RESET
IF %M%==4 GOTO :SERVER
IF %M%==5 GOTO :EXIT
IF %M%==9 GOTO :DEV
GOTO :MENU

:GET_CORNSTONE
ECHO Downloading cornstone...
FOR /F "usebackq delims=" %%v IN (`powershell -noprofile "(New-Object Net.WebClient).DownloadString('%CORNSTONE_VERSION_URL%')"`) DO SET "CORNSTONE_VERSION=%%v" || GOTO :ERROR
SET "CORNSTONE_URL=https://github.com/MinecraftMachina/cornstone/releases/download/v%CORNSTONE_VERSION%/cornstone_%CORNSTONE_VERSION%_windows_amd64.exe"
powershell -noprofile "(New-Object Net.WebClient).DownloadFile('%CORNSTONE_URL%', '%CORNSTONE_FILE%')" || GOTO :ERROR
GOTO :EOF

:INSTALL
CALL :GET_CORNSTONE || GOTO :ERROR
IF NOT EXIST "%LAUNCHER_DIR%" (
    "%CORNSTONE_FILE%" multimc -m "%LAUNCHER_DIR%" init || GOTO :ERROR
)
"%CORNSTONE_FILE%" multimc -m "%LAUNCHER_DIR%" install -n "%MODPACK_NAME%" -i "%MODPACK_URL%" || GOTO :ERROR
pause
GOTO :MENU

:PLAY
"%CORNSTONE_FILE%" multimc -m "%LAUNCHER_DIR%" run || GOTO :ERROR
GOTO :EXIT

:DEV
"%CORNSTONE_FILE%" multimc -m "%LAUNCHER_DIR%" dev || GOTO :ERROR
pause
GOTO :MENU

:RESET
ECHO.
ECHO WARNING: This will delete the modpack with all your data!
ECHO.
pause
rd /s /q "%LAUNCHER_DIR%" || GOTO :ERROR
GOTO :INSTALL

:SERVER
CALL :GET_CORNSTONE || GOTO :ERROR
"%CORNSTONE_FILE%" server -s "%SERVER_DIR%" install -i "%MODPACK_URL%" || GOTO :ERROR
pause
GOTO :MENU

:EXIT
exit

:ERROR
ECHO Failed with error %errorlevel%
pause
GOTO :EXIT
