function Get-UmsMetadataFolderPath
{
    Param(
        [Parameter(Mandatory=$true)]
        [ValidateNotNull()]
        [string] $Path
    )

    # Build metadata folder path
    $_umsFolderName = Get-UmsConfigurationItem -ShortName "UmsFolderName"
    if (Get-UmsConfigurationItem -ShortName "UmsHiddenFolders")
    {
        $_folderPath = Join-Path -Path $Path -ChildPath $('.' + $_umsFolderName)
    }
    else
    {
        $_folderPath = Join-Path -Path $Path -ChildPath $_umsFolderName
    }

    return $_folderPath
}