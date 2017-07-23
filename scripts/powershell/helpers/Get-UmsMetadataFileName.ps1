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
            $_fileName = Get-UmsConfigurationItem -ShortName "UmsMainFileName"
        }

        "Static"
        {
            $_fileName = Get-UmsConfigurationItem -ShortName "UmsStaticFileName"
        }        
    }

    return Join-Path -Path $_metadataFolderPath -ChildPath $_fileName
}