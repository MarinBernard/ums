function Reset-UmsMetadataCache
{
    <#
    .SYNOPSIS
    Flushes the UMS metadata cache.
    
    .DESCRIPTION
    This command resets the content of the UMS metadata cache.
    #>

    Process
    {
        return [EntityFactory]::ResetCache()
    }
}