function Measure-UmsEntityCache
{
    <#
    .SYNOPSIS
    Shows various statistics about the UMS entity cache.
    
    .DESCRIPTION
    Shows various statistics about the UMS entity cache.
    #>

    Process
    {
        return [EntityCache]::GetStatistics()
    }
}