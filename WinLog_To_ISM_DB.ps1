# Define the path to the local log file
$LogFile = "C:\Path\To\Your\Log\File.txt"

# Define your SQL Server credentials
$SqlServerHostname = "YourServer"
$DatabaseName = "Ivanti_Prod"
$SqlUsername = "YourSQLUsername"
$SqlPassword = "YourSQLPassword"

# Function to log user logins
function Log-UserLogin {
    param (
        [string]$username
    )
    
    # Check if the log file exists, if not, create it
    if (-not (Test-Path -Path $LogFile)) {
        New-Item -Path $LogFile -ItemType File
    }
    
    # Append the username and timestamp to the log file
    "$username,$(Get-Date)" | Out-File -Append -FilePath $LogFile
}

# Hook into the user login event
$eventScriptblock = {
    $username = $env:USERNAME
    Log-UserLogin -username $username
}

Register-WmiEvent -Query "SELECT * FROM Win32_ComputerSession" -Action $eventScriptblock

# Schedule a daily task to update the remote SQL Server
$trigger = New-ScheduledTaskTrigger -Daily -At "12:00 AM"
$action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument {
    # Parse the log file and count user logins
    $logData = Get-Content -Path $LogFile
    $loginCounts = $logData | Group-Object | Sort-Object Count -Descending
    
    # Get the user with the most logins
    $mostLoginsUser = $loginCounts[0].Name
    
    # Update the SQL Server with the user who logged in the most (placeholder for actual update)
    $connectionString = "Server=$SqlServerHostname;Database=$DatabaseName;User Id=$SqlUsername;Password=$SqlPassword;"
    $query = "UPDATE CI.Computer SET Owner = '$mostLoginsUser'"
    $connection = New-Object System.Data.SqlClient.SqlConnection
    $connection.ConnectionString = $connectionString
    $connection.Open()
    $command = $connection.CreateCommand()
    $command.CommandText = $query
    $command.ExecuteNonQuery()
    $connection.Close()
}

Register-ScheduledTask -Action $action -Trigger $trigger -TaskName "UpdateIvantiOwnerTask"
