function Get-UmsMetadata
{
    <#
    .SYNOPSIS
    Reads and returns UMS metadata from a UMS item.
    
    .DESCRIPTION
    This command parses the XML document of a UMS item, and creates a hierarchy of UMS entities from its content.
    
    .PARAMETER Path
    Path to one or several UMS documents.

    .PARAMETER Item
    One or several UmsItem instances as returned by the Get-UmsItem command.

    .PARAMETER Silent
    If specified, informational and warning message won't be displayed.

    .PARAMETER Raw
    If specified, the command will ignore any cached metadata. Metadata will be generated directly from the content of the file.
    
    .EXAMPLE
    Get-UmsMetadata -Path "D:\MyMusic\album.ums"
    #>

    [CmdletBinding(DefaultParametersetName='None')]
    Param(
        [Parameter(ParameterSetName='FileInfoInstance',Position=0,Mandatory=$true,ValueFromPipeline=$true)]  
        [ValidateNotNull()]
        [System.IO.FileInfo[]] $Path,

        [Parameter(ParameterSetName='ItemInstance',Position=0,Mandatory=$true,ValueFromPipeline=$true)]
        [ValidateNotNull()]
        [UmsItem[]] $Item,

        [switch] $Silent,

        [switch] $Raw
    )

    Process
    {
        # If a path is supplied, we need to create a UmsItem object.
        if ($Path)
        {
            $Item = New-Object -Type UmsItem -ArgumentList $Path
        }

        # If the Raw switch is present, we bypass cached versions completely.
        if ($Raw.IsPresent)
            { return [EntityFactory]::ParseDocument($Item.Uri, $Item.Name) }

        # Else, let's try to use a cached version.
        else
        {
            switch ($Item.CachedVersion)
            {
                "Current"
                {
                    return Import-Clixml -Path $Item.CacheFileFullName
                }

                "Expired"
                {
                    if (-not $Silent.IsPresent)
                    {
                        Write-Warning -Message $(
                            $ModuleStrings.Common.ExpiredCachedVersion)
                    }
                    # Use cached metadata, even expired
                    return Import-Clixml -Path $Item.CacheFileFullName
                }

                "Absent"
                {
                    if (-not $Silent.IsPresent)
                    {
                        Write-Warning -Message $(
                            $ModuleStrings.Common.MissingCachedVersion)
                    }
                    # Use direct file content
                    return [EntityFactory]::ParseDocument(
                        $Item.Uri, $Item.Name)
                }

                default
                {
                    # Use direct file content
                    return [EntityFactory]::ParseDocument(
                        $Item.Uri, $Item.Name)
                }
            }
        }
    }
}