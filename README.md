# User Login Tracking and SQL Server Update Script for Ivanti ISM

## Overview

This PowerShell script is designed to track user logins on each local machine in a domain and update a remote SQL Server database with the user who logged in the most times for the day. This README provides instructions on how to set up and use the script.

## Requirements

- Windows-based domain environment
- PowerShell
- Access to a remote SQL Server database
- Administrative privileges to configure Group Policy

## Setup Instructions

1. **Clone or Download the Script**

   Clone this repository or download the PowerShell script (`your-script.ps1`) to a location on your domain controller or a network share accessible to all target machines.

2. **Edit the Script**

   Open the script in a text editor and replace the following placeholders with actual values:

   - `your-connection-string`: Replace with the connection string to your remote SQL Server.
   - `YourServer`: Replace with the SQL Server hostname.
   - `Ivanti_Prod`: Replace with the database name.
   - `YourUserID`: Replace with the SQL Server username.
   - `YourPassword`: Replace with the SQL Server password.

   Save the script with your changes.

3. **Configure Group Policy**

   - Open the Group Policy Management Console on a machine with administrative privileges (`gpmc.msc`).
   - Create a new Group Policy Object (GPO) or use an existing one for your domain.
   - Navigate to `Computer Configuration -> Policies -> Windows Settings -> Scripts (Startup/Shutdown)`.

4. **Add the PowerShell Script to Group Policy**

   - In the right pane, double-click "Startup" to open the "Startup Properties" window.
   - Click "Add" to add your modified PowerShell script (`your-script.ps1`).
   - If your script requires parameters, you can add them in the "Script Parameters" field.

5. **Save and Apply Group Policy**

   - Close the "Startup Properties" window, and close the GPO Editor.
   - Link the GPO to the appropriate Organizational Unit (OU) containing the target machines.

6. **Force Group Policy Update**

   - On the target machine(s), open an elevated command prompt or PowerShell.
   - Run the command `gpupdate /force` to force a Group Policy update.

## Usage

Upon user login, the script will log user logins locally and update the specified SQL Server database at the end of each day with the user who logged in the most times for that day.

## Disclaimer

This script is provided as-is and should be tested in a controlled environment before deploying it in a production domain. Ensure that the script behaves as expected and does not cause any issues.

## License

This script is released under the [MIT License](LICENSE).

## Author

- [Andrew Hatton](https://github.com/killer6oose)

For questions or assistance, feel free to open an issue or contact the author.
