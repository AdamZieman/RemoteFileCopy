@echo off
setlocal enabledelayedexpansion

REM Prompts the user to input the source device name, destination device name, and employee ID. 
REM Validates the input by checking the length and formatting of each entry. 
REM - For device names, it ensures the length is either 7 or 9 characters, and appends 'DE' if the length is 7.
REM - For employee IDs, it checks for specific length constraints (6, 7, or 9 characters) and validates the format (e.g., ends with 'a' for 7-character IDs, starts with 't2.' for 9-character IDs).
REM If any input is invalid, the user is prompted to re-enter the information.


:GetSourceDeviceName

set /p sourceDeviceName="Enter the source's device name: "
set length=0

for /l %%i in (0,1,9) do (
    if "!sourceDeviceName:~%%i,1!"=="" (
		goto :StopCountingSourceDeviceName
	)
	
    set /a length+=1
)

:StopCountingSourceDeviceName

if !length!==7 (	
    set sourceDeviceName=DE!sourceDeviceName!
) else if !length!==9 (
    if /i not "!sourceDeviceName:~0,2!"=="de" (
		echo Error: Invalid device name.
		goto :GetSourceDeviceName
    )
) else (
    echo Error: Invalid device name.
	echo.
    goto :GetSourceDeviceName
)

:GetDestinationDeviceName

set /p destinationDeviceName="Enter the destination device name: "
set length=0

for /l %%i in (0,1,9) do (
    if "!destinationDeviceName:~%%i,1!"=="" (
		goto :StopCountingDestinationDeviceName
	)
	
    set /a length+=1
)

:StopCountingDestinationDeviceName

if !length!==7 (	
    set destinationDeviceName=DE!destinationDeviceName!
) else if !length!==9 (
    if /i not "!destinationDeviceName:~0,2!"=="de" (
		echo Error: Invalid device name.
		goto :StopCountingDestinationDeviceName
    )
) else (
    echo Error: Invalid device name.
	echo.
    goto :StopCountingDestinationDeviceName
)

:GetEmployeeID

set /p employeeID="Enter the employee ID: "
set length=0

for /l %%i in (0,1,9) do (
    if "!employeeID:~%%i,1!"=="" (
		goto :StopCountingEmployeeID
	)
	
    set /a length+=1
)

:StopCountingEmployeeID

if not !length!==6 (
	if !length!==7 (
		if /i not "!employeeID:~-1!"=="a" (
			echo Error: Invalid employee ID.
			goto :GetEmployeeID
		)
	) else if !length!==9 (
		if /i not "!employeeID:~0,3!"=="t2." (
			echo Error: Invalid employee ID.
			goto :GetEmployeeID
		)
	) else (
		echo Error: Invalid employee ID.
		echo.
		goto :GetEmployeeID
	)
)



REM Checks if both the source and destination devices are accessible on the network and verifies the existence of the user profile on each device.
REM If either the device cannot be accessed remotely or the user's profile directory does not exist, an error message is displayed and the script exits.

echo.
echo Check whether the devices are recognized on the network and the user profile exists on both devices.
echo ... checking !sourceDeviceName!

set workingSourcePath=\\!sourceDeviceName!\C$\

if not exist "!workingSourcePath!" (
	echo Error: !sourceDeviceName! not found.
	goto :ExitOnError
)

set workingSourcePath=!workingSourcePath!Users\!employeeID!\

if not exist "!workingSourcePath!" (
	echo Error: !employeeID! does not exist on !sourceDeviceName!.
	goto :ExitOnError
)

echo ... checking !destinationDeviceName!

set workingDestinationPath=\\!destinationDeviceName!\C$\

if not exist "!workingDestinationPath!" (
	echo Error: !destinationDeviceName! not found.
	goto :ExitOnError
)

set workingDestinationPath=!workingDestinationPath!Users\!employeeID!\

if not exist "!workingDestinationPath!" (
	echo Error: !employeeID! does not exist on !destinationDeviceName!.
	goto :ExitOnError
)



REM Copies user directories from the source device to the destination device and excludes specified files and directories.

echo.
echo Copying files and sub-directories
robocopy !workingSourcePath! !workingDestinationPath! /E /J /NJH /NJS /XF NTUSER.DAT ntuser.dat.LOG1 ntuser.dat.LOG2 ^
    /XX /XD "Contacts" "Favorites" "Links" "Pictures" "Videos" "Searches" "Saved Games" "Music" ".cisco" ".ms-ad" ^
	"AppData" "Application Data" "Cookies" "Local Settings" "NetHood" "PrintHood" "SendTo" "Templates" "Recent" "Start Menu" ^
    "OneDrive" "OneDrive - Advocate Health"



REM Copies browser bookmarks from the source device to the destination device for Microsoft Edge and Google Chrome.

echo.
echo Copying browser bookmarks

set edgeFavoritesPath="AppData\Local\Microsoft\Edge\User Data\Default\Bookmarks"
set chromeBookmarksPath="AppData\Local\Google\Chrome\User Data\Default\Bookmarks"

if exist "!workingSourcePath!!edgeFavoritesPath!" (
    xcopy !workingSourcePath!!edgeFavoritesPath! !workingDestinationPath!!edgeFavoritesPath! /E /C /-I /Q /Y /J >nul
	echo Warning: If Microsoft Edge was open, user may need to re-launch application for changes to take affect.
	echo Warning: User will need to show favorites in Microsoft Edge.
) else (
    echo Warning: No Microsoft Edge favorites found on the source device.
)

if exist "!workingSourcePath!!chromeBookmarksPath!" (
    xcopy !workingSourcePath!!chromeBookmarksPath! !workingDestinationPath!!chromeBookmarksPath! /E /C /-I /Q /Y /J >nul
	echo Warning: If Google Chrome was open, user may need to re-launch application for changes to take affect.
) else (
    echo Warning: No Google Chorme bookmarks found on the source device.
)

goto :ExitOnSuccess



REM This section handles the script's completion by either confirming success or handling errors.
REM If the script completes successfully, it prints a success message and ends the local environment.
REM If an error occurs, it simply ends the local environment without further action.

:ExitOnSuccess
echo.
echo Remote copy is completed.
echo.
echo WARNING: Does the user need OneDrive set up on the destination computer?
echo WARNING: Does the user need to configure their Microsoft OneNote?
echo WARNING: Does the user need to map any networked printers?
endlocal

:ExitOnError
endlocal
