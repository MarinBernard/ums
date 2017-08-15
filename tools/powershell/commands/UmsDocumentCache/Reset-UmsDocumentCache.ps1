function Reset-UmsDocumentCache
{
    <#
    .SYNOPSIS
    Resets the UMS document cache statistics.
    
    .DESCRIPTION
    This command will reset the UMS document cache statistics without flushing the cache.
    #>

    [CmdletBinding(DefaultParametersetName='None')]
    Param()

    Process
    {
        return $global:UmsDocumentCache.Reset()
    }
}