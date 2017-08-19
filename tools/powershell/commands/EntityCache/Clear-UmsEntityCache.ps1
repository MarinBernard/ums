function Clear-UmsEntityCache
{
    <#
    .SYNOPSIS
    Removes all cached instances from the UMS entity cache.
    
    .DESCRIPTION
    This command will flush the UMS entity cache entirely.
    #>

    [CmdletBinding(DefaultParametersetName='None')]
    Param()

    Process
    {
        return [EntityCache]::Flush()
    }
}