# Create the .NET objects
$psi = New-Object System.Diagnostics.ProcessStartInfo
$newproc = New-Object System.Diagnostics.Process
# Basic stuff, process name and arguments
$psi.FileName = $args[0]
$psi.Arguments = $args[1]
# Hide any window it might try to create
$psi.CreateNoWindow = $true
$psi.WindowStyle = 'Hidden'
# Set up and start the process
$newproc.StartInfo = $psi
$newproc.Start()
# Return the process object to the caller
$newproc
