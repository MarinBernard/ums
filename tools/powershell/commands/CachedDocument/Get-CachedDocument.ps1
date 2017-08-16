function Get-CachedDocument
{
    <#
    .SYNOPSIS
    Retrieves and returns the list of all cached UMS documents.
    
    .DESCRIPTION
    Retrieves and returns the list of all cached UMS documents.
    #>

    [CmdletBinding(DefaultParametersetName='None')]
    Param()

    Process
    {
        return [DocumentCache]::DumpCachedDocuments()
    }
}