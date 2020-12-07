#Requires -Version 5.1

# np address
$Address = ""

# Usage
if (!$args[1] -and ($Address -eq "") -or !$args[0]) {
	Write-Output ("Usage: npst [url | file] [address]")
	exit
}
if ($Address -eq "") {
	$Address = $args[1]
}

try {
	$Address = New-Object System.Uri $Address
}
catch {
	Write-Error "Invalid address format"
	exit
}

# Get url
try {
	$Url = New-Object System.Uri $args[0]
}
catch {
	if (!(Test-Path $args[0])) {
		Write-Error "Invalid url format or file is not exist"
		exit
	}
	$Url = New-Object System.Uri (Resolve-Path $args[0])
}

# Upload
if ($Url.IsFile) {
	$Form = @{ file = (Get-Item $Url.LocalPath.ToString()) }
}
else {
	$Form = @{ shorten = ($Url.ToString()) }
}
Write-Progress -Activity "Request invoked" -Status "Working..." -PercentComplete -1
try {
	Invoke-RestMethod -Method Post -Form $Form -Uri $Address
}
catch {
	Write-Error "Something went wrong"
	exit
}