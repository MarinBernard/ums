function Measure-UmsMetadataCache
{
    <#
    .SYNOPSIS
    Shows various statistics about the UMS metadata cache.
    
    .DESCRIPTION
    Shows various statistics about the UMS metadata cache.
    #>

    Process
    {
        return [EntityFactory]::MeasureCache()
    }
}