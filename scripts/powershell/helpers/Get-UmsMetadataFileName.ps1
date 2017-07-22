function Get-UmsMetadataFileName
{
    Param(
        [Parameter(Mandatory=$true)]
        [ValidateNotNull()]
        [string] $Path,

        [ValidateSet("Main", "Static")]
        [string] $Type = "Main"
    )

    # Get path to metadata folder
    $_metadataFolderPath = Get-UmsMetadataFolderPath -Path $Path

    switch ($Type)
    {
        "Main"
        {
            $_fileName = $($ModuleConfig.UMS.MetadataFiles.MainFileName + $ModuleConfig.UMS.MetadataFiles.Extension)
        }

        "Static"
        {
            $_fileName = $($ModuleConfig.UMS.MetadataFiles.StaticFileName + $ModuleConfig.UMS.MetadataFiles.Extension)
        }        
    }

    return Join-Path -Path $_metadataFolderPath -ChildPath $_fileName
}