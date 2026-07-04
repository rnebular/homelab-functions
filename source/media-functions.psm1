# functions to be used in media related operations

function Get-MediaFileList {
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    param (
        [Parameter(Mandatory = $false)]
        [string]$sourceFolder,

        [Parameter(ParameterSetName = 'Output')]
        [switch]$outputFile,

        [Parameter(ParameterSetName = 'Output', Mandatory = $false)]
        [string]$FileName = "MediaFileList.txt"
    )

    if (!$sourceFolder) {
        #Write-Host "No source folder specified. Using current directory as source folder."
        $sourceFolder = Get-Location
    }

    $mediaFolder = Resolve-Path $sourceFolder

    $shell = New-Object -ComObject Shell.Application

    $results = foreach ($file in Get-ChildItem -Path $mediaFolder -Recurse -File) {

        $folder = $shell.Namespace($file.Directory.FullName)
        $item = $folder.ParseName($file.Name)

        # Windows Explorer "Length" column
        $length = $folder.GetDetailsOf($item, 27)

        [PSCustomObject]@{
            Title    = [System.IO.Path]::GetFileNameWithoutExtension($file.Name)
            Length   = $length
            FilePath = $file.FullName
        }
    }

    if ($outputFile) {
        $results |
            Sort-Object Title |
            ForEach-Object {
                "{0} | {1} | {2}" -f $_.Title, $_.Length, $_.FilePath
            } |
            Set-Content -Path $FileName
    }
    else {
        return $results | Sort-Object Title
    }

}