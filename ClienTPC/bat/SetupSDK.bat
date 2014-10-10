:user_configuration

:: Path to Flex SDKs
::set FLEX_SDK=C:\Users\SONY\AppData\Local\FlashDevelop\Apps\flexairsdk\4.6.0+14.0.0
set FLEX_SDK=%LOCALAPPDATA%\FlashDevelop\Apps\flexairsdk\4.6.0+14.0.0


:validation
if not exist "%FLEX_SDK%" goto flexsdk
goto succeed

:flexsdk
echo.
echo ERROR: incorrect path to Flex SDK in 'bat\SetupSDK.bat'
echo.
echo %FLEX_SDK%
echo.
if %PAUSE_ERRORS%==1 pause
exit

:succeed
set PATH=%FLEX_SDK%\bin;%PATH%

