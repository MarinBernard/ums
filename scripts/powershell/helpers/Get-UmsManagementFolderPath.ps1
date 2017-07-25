function Get-UmsManagementFolderPath
{
    Param(
        [Parameter(Mandatory=$true)]
        [ValidateNotNull()]
        [string] $Path,

        [ValidateSet("Cache", "Main")]
        [string] $Type = "Main"
    )

    switch ($Type)
    {
        # Path to the cache metadata folder
        "Cache"
        {
            $_folderName = Get-UmsConfigurationItem -ShortName "UmsCacheFolderName"
            $_folderFullName = Join-Path (Get-UmsManagementFolderPath -Path $Path) -ChildPath $_folderName
        } 

        # Path to the main metadata folder
        "Main"
        {
            $_folderName = Get-UmsConfigurationItem -ShortName "UmsFolderName"
            $_folderFullName = Join-Path -Path $Path -ChildPath $_folderName
        }
    }

    # Return a fully qualified folder name
    return $_folderFullName
}