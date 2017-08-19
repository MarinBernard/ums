function Get-UmsCachedEntity
{
    <#
    .SYNOPSIS
    Returns the list of all cached UMS entities.
    
    .DESCRIPTION
    Returns the list of all cached UMS entities.
    #>

    [CmdletBinding(DefaultParametersetName='None')]
    Param()

    Process
    {
        return [EntityCache]::Dump()
    }
}