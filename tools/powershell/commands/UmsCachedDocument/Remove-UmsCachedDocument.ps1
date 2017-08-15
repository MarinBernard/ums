function Remove-UmsCachedDocument
{
    <#
    .SYNOPSIS
    Removes a specific document from the UMS document cache.
    
    .DESCRIPTION
    This command allows to selectively remove a specific document from the UMS document cache.

    .EXAMPLE
    Get-UmsCachedDocument | Remove-UmsCachedDocument
    Removes all cached documents from the UMS cache.
    #>

    [CmdletBinding(DefaultParametersetName='None')]
    Param(
        [Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true)]
        [ValidateNotNull()]
        [UmsCachedDocument] $Document
    )

    Process
    {
        $global:UmsDocumentCache.RemoveCachedDocument($Document)
    }
}