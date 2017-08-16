function Get-CachedDocument
{
    <#
    .SYNOPSIS
    Returns the list of all cached UMS documents.
    
    .DESCRIPTION
    Returns the list of all cached UMS documents.
    #>

    [CmdletBinding(DefaultParametersetName='None')]
    Param()

    Process
    {
        return [DocumentCache]::Dump()
    }
}