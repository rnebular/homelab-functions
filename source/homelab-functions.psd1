@{
    # Script module or binary module file associated with this manifest
    RootModule        = 'homelab-functions.psd1'

    # Version number of this module
    ModuleVersion     = '1.0.0.0'

    # ID used to uniquely identify this module
    GUID              = 'd3a7f2b9-1c4e-4b6a-9f9a-2c8d4e5f6a7b'

    # Author and company information
    Author            = 'rnebular'
    CompanyName       = ''

    Copyright         = '(c) 2026 rnebular. All rights reserved.'

    # Description of the module
    Description       = 'Homelab helper functions.'

    # Minimum version of PowerShell required
    PowerShellVersion = '5.1'

    # Compatible PowerShell editions
    CompatiblePSEditions = @('Core', 'Desktop')

    # Modules required by this module
    RequiredModules   = @()

    # Assemblies to load
    RequiredAssemblies = @()

    # Scripts to run in the caller's session before importing module
    ScriptsToProcess  = @()

    # Files packaged with the module (optional - list files here if packaging)
    FileList          = @()

    # Export everything by default; adjust to explicit names if desired
    FunctionsToExport = @('*')
    CmdletsToExport   = @()
    VariablesToExport = @()
    AliasesToExport   = @('*')

    # Private nested modules
    NestedModules     = @()

    # Module version dependencies (name = version)
    ModuleList        = @()

    # Tags and metadata for PSGallery / search
    PrivateData       = @{
        PSData = @{
            Tags        = @('homelab','functions')
            ProjectUri  = ''
            LicenseUri  = ''
            ReleaseNotes= 'Initial release.'
        }
    }
}