# homelab-functions
A functions module for PowerShell, specific to my homelab automation.

# manual import
Too lazy to setup full build/publish right now. Copy the source folder local and run the following:
```

# download latest homelab functions from github and unzip to source folder
$dl_path = "https://github.com/rnebular/homelab-functions/archive/refs/heads/main.zip"
$extract_path = "source"
Invoke-WebRequest -Uri $dl_path -OutFile "homelab-functions.zip"
Expand-Archive -Path "homelab-functions.zip" -DestinationPath $extract_path
Remove-Item -Path "homelab-functions.zip"

$env:PSModulePath = "$($env:PSModulePath);$(Get-Location)\source"
Import-Module -Name "homelab-functions-main\source\homelab-functions.psd1" -Verbose
```
