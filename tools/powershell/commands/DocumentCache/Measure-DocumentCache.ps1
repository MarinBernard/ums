function Measure-DocumentCache
{
    <#
    .SYNOPSIS
    Returns statistical data about the UMS document cache.
    
    .DESCRIPTION
    This command returns statistical data about the UMS document cache such as the number of cache hits, cache misses, or the cache hit ratio.
    #>

    [CmdletBinding(DefaultParametersetName='None')]
    Param()

    Process
    {
        return [DocumentCache]::GetStatistics()
    }
}