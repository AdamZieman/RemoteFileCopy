# Remote File Copy

## Overview
This script script facilitates copying user profile files and directories between two devices within an enterprise network. It includes validation for device names and employee IDs, ensures the user profiles exist on both devices, and transfers files while excluding those specified in a configuration file.

## Prerequisites
1. **Administrator Permissions:** The script must be run with administrative privileges to access and modify system files.
2. **Device Connectivity:** Both source and destination devices must be powered on and connected to the enterprise network.
3. **User Profile Presence:** The user profile corresponding to the specified employee ID must exist on both the source and destination devices.
4. **Exclusion File:** A file named `remoteFileCopy_excludeFiles.txt` must be present in the script directory if specific files or directories need to be excluded during the copy process.

## Script Functionality
1. **Input Validation:**
   - Validates the source and destination device names (7 or 9 characters long).
   - Automatically prefixes device names with `DE` if only 7 characters are provided.
   - Checks the employee ID for valid formats (6, 7, or 9 characters).

2. **Device and Profile Verification:**
   - Confirms the devices are accessible on the network.
   - Verifies the existence of the user profile on both devices.

3. **File Copying:**
   - Copies specific directories, such as `Desktop`, `Documents`, `Downloads`, and more, while preserving attributes and directory structure.
   - Excludes files listed in `remoteFileCopy_excludeFiles.txt`.

4. **Browser Bookmark Migration:**
   - Copies browser bookmarks for Microsoft Edge and Google Chrome, if they exist.

5. **Post-Copy Checks:**
   - Prompts the administrator to consider additional setup steps, such as:
     - Configuring OneDrive.
     - Setting up Microsoft OneNote.
     - Mapping networked printers.

## Usage
1. Ensure all prerequisites are met.
 
2. Run the script as an administrator.

3. Follow the on-screen prompts to:
   - Enter the source device name.
   - Enter the destination device name.
   - Enter the employee ID.

4. The script will validate your inputs and proceed to copy the required files and directories.

## Output
- Upon successful execution, the script displays a completion message and reminders for additional configurations.
- If an error occurs, the script provides detailed feedback and exits.

## Error Handling
- **Invalid Input:** The script validates device names and employee IDs. If any input is incorrect, an error message is displayed, and the user is prompted to re-enter the information.
- **Device or Profile Not Found:** If a device is unreachable or the user profile does not exist, the script halts with an error message.
- **File Copy Errors:** The script skips any inaccessible files and logs warnings when specific directories or bookmarks are missing.
- **General Errors:** Unexpected issues cause the script to exit with a generic error message and no changes are made.

## Dependencies
- Windows OS: Designed for Windows systems with standard directory structures.
- The `xcopy` command must be available on the system.

## Troubleshooting
- **Device Not Found:** Ensure both devices are powered on, connected to the network, and their names are entered correctly.
- **Profile Not Found:** Verify the employee ID matches the user profile directory on both devices.
- **Exclusion Issues:** Confirm the `remoteFileCopy_excludeFiles.txt` file is in the correct location and properly formatted.

## Notes
- This script is intended for enterprise use and assumes an Active Directory environment with consistent device and user profile naming conventions.
- It is recommended to test the script in a controlled environment before deploying it broadly.
