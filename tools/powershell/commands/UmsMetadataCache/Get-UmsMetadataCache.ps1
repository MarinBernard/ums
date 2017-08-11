function Get-UmsMetadataCache
{
    <#
    .SYNOPSIS
    Dumps the UMS metadata cache.
    
    .DESCRIPTION
    This command returns the content of the UMS metadata cache.
    #>

    Process
    {
        return [EntityFactory]::DumpCache()
    }
}