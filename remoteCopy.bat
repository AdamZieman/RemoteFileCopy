@echo off
setlocal enabledelayedexpansion


REM Instantiate the name for the source device.
set /p sourceDevice="Enter the source device name: "

:: get variable length (up to 10)
set length=0
for /l %%i in (0,1,9) do (
    if "!sourceDevice:~%%i,1!"=="" goto endSourceDeviceCount
    set /a length+=1
)
:endSourceDeviceCount

:: check variable length and format
if %length%==7 (	
    set sourceDevice=DE%sourceDevice%
) else if %length%==9 (
    if /i not "%sourceDevice:~0,2%"=="de" (
		echo Error: Invalid device name format.
		exit /b 1
    )
) else (
    echo Error: Invalid device name length.
    exit /b 1
)


REM Instantiate the name for the destination device.
set /p destinationDevice="Enter the destination device name: "

:: get variable length (up to 10)
set length=0
for /l %%i in (0,1,9) do (
    if "!destinationDevice:~%%i,1!"=="" goto endDestinationDeviceCount
    set /a length+=1
)
:endDestinationDeviceCount

:: check variable length and format
if %length%==7 (	
    set destinationDevice=DE%destinationDevice%
) else if %length%==9 (
    if /i not "%destinationDevice:~0,2%"=="de" (
		echo Error: Invalid device name format.
		exit /b 1
    )
) else (
    echo Error: Invalid device name length.
    exit /b 1
)


REM Instantiate the employee ID.
set /p employeeID="Enter the employee ID: "

:: get the variable length 
set length=0
for /l %%i in (0,1,9) do (
    if "!employeeID:~%%i,1!"=="" goto endEmployeeIDCount
    set /a length+=1
)
:endEmployeeIDCount

:: check the variable length and format
if not %length%==6 (
	if %length%==7 (
		if /i not "!employeeID:~-1!"=="a" (
			echo Error: Invalid employee ID length.
			exit /b 1
		)
	) else if %length%==9 (
		if /i not "!employeeID:~0,3!"=="t2." (
			echo Error: Invalid employee ID length.
			exit /b 1
		)
	) else (
		echo Error: Invalid employee ID length.
		exit /b 1
	)
)


REM Instantiate the path to the employee ID on the source device.
echo.
echo Connecting to %sourceDevice% ...

:: set the path to the source device
set sourceDevicePath="\\%sourceDevice%\C$\"
if not exist "%sourceDevicePath%" (
	echo Error: %sourceDevice% not found.
	exit /b 1
)

:: set the path to the employee ID on the source device
set sourceUserPath="%sourceDevicePath%Users\%employeeID%\"
if not exist "%sourceUserPath%" (
	echo Error: %employeeID% does not exist on %sourceDevice%.
	exit /b 1
)


REM Instantiate the path to the employee ID on the destination device.
echo Connecting to %destinationDevice% ...

:: set the path to the destination device
set destinationDevicePath="\\%destinationDevice%\C$\"
if not exist "%destinationDevicePath%" (
	echo Error: %destinationDevice% not found.
	exit /b 1
)

:: set the path to the employee ID on the destination device
set destinationUserPath="%destinationDevicePath%Users\%employeeID%\"
if not exist "%destinationUserPath%" (
	echo Error: %employeeID% does not exist on %destinationDevice%.
	exit /b 1
)


REM Copy Desktop files
echo Copying Desktop ...
:: xcopy zSource zDestination /s /c /i /q /r /k /y
:: xcopy zSource zDestination /s /c /i /q /r /k /y 2>>error.log
:: xcopy zSource zDestination /s /c /i /q /r /k /y >nul 2>>error.log





endlocal
exit /b 0