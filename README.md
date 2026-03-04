# homelab-functions
A functions module for PowerShell, specific to my homelab automation.

# manual import
Too lazy to setup full build/publish right now. Copy the source folder local and run the following:
```
$env:PSModulePath = "$($env:PSModulePath):$env:PWD/source"
Import-Module -Name homelab-functions -Verbose
```
