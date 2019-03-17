@ECHO OFF
chcp 65001 > NUL

FOR /F "delims=" %%i IN ('adb devices ^| findstr /R device$ ^| find /c "device"') DO SET device_count=%%i
IF %device_count% == 1 (
	GOTO :screenrecord
) ELSE (
	ECHO Android Device not Found.
)

:screenrecord
SETLOCAL
adb shell settings put system show_touches 1
START /b adb shell screenrecord /sdcard/screenshot.mp4
PAUSE
for /f "tokens=2,*" %%i in ('tasklist ^| findstr adb.exe') do set pid=%%i
TASKKILL /F /PID %pid% > NUL
adb shell settings put system show_touches 0
SET mydate=%date:/=%
SET mydate=%mydate:~3,11%
SET mytime=%time::=%
SET mytime=%mytime:.=%
SET mytime=%mytime: =%
SET mytimestamp=%mydate%_%mytime%
FOR /F %%i IN ('adb shell settings get global device_name') DO SET device_name=%%i
adb pull /sdcard/screenshot.mp4 "%USERPROFILE%\Desktop\%device_name%_%mytimestamp%.mp4"
adb shell rm /sdcard/screenshot.mp4
ENDLOCAL