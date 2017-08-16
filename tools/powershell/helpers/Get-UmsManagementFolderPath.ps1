function Get-UmsManagementFolderPath
{
    Param(
        [Parameter(Mandatory=$true)]
        [ValidateNotNull()]
        [string] $Path,

        [ValidateSet("Cache", "Main", "Static")]
        [string] $Type = "Main"
    )

    switch ($Type)
    {
        # Path to the cache metadata folder
        "Cache"
        {
            $_folderName = ([ConfigurationStore]::GetSystemItem(
                "UmsFolderNameCache").Value)
            $_folderFullName = Join-Path (Get-UmsManagementFolderPath -Path $Path) -ChildPath $_folderName
        }

        # Path to the main metadata folder
        "Main"
        {
            $_folderName = ([ConfigurationStore]::GetSystemItem(
                "UmsFolderNameMain").Value)
            $_folderFullName = Join-Path -Path $Path -ChildPath $_folderName
        }

        # Path to the static metadata folder
        "Static"
        {
            $_folderName = ([ConfigurationStore]::GetSystemItem(
                "UmsFolderNameStatic").Value)
            $_folderFullName = Join-Path (Get-UmsManagementFolderPath -Path $Path) -ChildPath $_folderName
        }
    }

    # Return a fully qualified folder name
    return $_folderFullName
}