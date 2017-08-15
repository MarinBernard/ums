function Get-UmsCachedDocument
{
    <#
    .SYNOPSIS
    Retrieves and returns the list of all cached UMS documents.
    
    .DESCRIPTION
    Retrieves and returns the list of all cached UMS documents.

    .EXAMPLE
    Get-UmsDocument -Uri "http://ums.olivarim.com/catalogs/standard/cities/AR.ums"
    #>

    [CmdletBinding(DefaultParametersetName='None')]
    Param()

    Process
    {
        return $global:UmsDocumentCache.DumpCachedDocuments()
    }
}