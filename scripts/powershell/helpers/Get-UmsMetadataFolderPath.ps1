function Get-UmsMetadataFolderPath
{
    Param(
        [Parameter(Mandatory=$true)]
        [ValidateNotNull()]
        [string] $Path
    )

    # Build metadata folder path
    if ($ModuleConfig.UMS.MetadataStorage.HiddenFolders)
    {
        $_folderPath = Join-Path -Path $Path -ChildPath $('.' + $ModuleConfig.UMS.MetadataStorage.FolderName)
    }
    else
    {
        $_folderPath = Join-Path -Path $Path -ChildPath $ModuleConfig.UMS.MetadataStorage.FolderName
    }

    return $_folderPath
}