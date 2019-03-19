@ECHO OFF
chcp 65001 > NUL
FOR /F "delims=" %%i IN ('adb devices ^| findstr /R device$ ^| find /c "device"') DO SET device_count=%%i
IF %device_count% == 1 (
	GOTO :screencap
) ELSE (
	ECHO Android设备没找到或USB调试未开启
)

:screencap
SETLOCAL
adb shell screencap -p /sdcard/screencap.png > NUL
set mydate=%date:/=%
set mydate=%mydate:~3,11%
set mytime=%time::=%
set mytime=%mytime:.=%
set mytime=%mytime: =%
set mytimestamp=%mydate%_%mytime%
FOR /F %%i IN ('adb shell "settings get global device_name | sed 's/ /_/g'"') DO SET device_name=%%i
adb pull /sdcard/screencap.png "%USERPROFILE%\Desktop\%device_name%_%mytimestamp%.png"
adb shell rm /sdcard/screencap.png
ENDLOCAL