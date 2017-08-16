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
            $_folderFullName = [ItemManager]::GetCacheFolderPath($Path)
        }

        # Path to the main metadata folder
        "Main"
        {
            $_folderFullName = [ItemManager]::GetManagementFolderPath($Path)
        }

        # Path to the static metadata folder
        "Static"
        {
            $_folderFullName = [ItemManager]::GetStaticFolderPath($Path)
        }
    }

    # Return a fully qualified folder name
    return $_folderFullName
}