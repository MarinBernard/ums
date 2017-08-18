function Remove-CachedDocument
{
    <#
    .SYNOPSIS
    Removes a specific document from the UMS document cache.
    
    .DESCRIPTION
    This command allows to selectively remove a specific document from the UMS document cache.

    .EXAMPLE
    Get-CachedDocument | Remove-CachedDocument
    Removes all cached documents from the UMS cache.
    #>

    [CmdletBinding(DefaultParametersetName='None')]
    Param(
        [Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true)]
        [ValidateNotNull()]
        [CachedDocument] $Document
    )

    Process
    {
        [DocumentCache]::RemoveCachedDocument($Document)
    }
}