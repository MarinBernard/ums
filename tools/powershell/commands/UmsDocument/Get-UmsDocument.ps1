function Get-UmsDocument
{
    <#
    .SYNOPSIS
    Retrieves and returns a UMS document as an XML document.
    
    .DESCRIPTION
    Retrieves and returns a UMS document as an XML document. This command queries the UMS document cache to speed-up document retrieval.

    .EXAMPLE
    Get-UmsDocument -Uri "http://ums.olivarim.com/catalogs/standard/cities/AR.ums"
    #>

    [CmdletBinding(DefaultParametersetName='None')]
    Param(
        [Parameter(ParametersetName="ByItem",Position=0,Mandatory=$true,ValueFromPipeline=$true)]
        [ValidateNotNull()]
        [UmsItem] $Item,

        [Parameter(ParametersetName="ByUri",Position=0,Mandatory=$true,ValueFromPipeline=$true)]
        [ValidateNotNull()]
        [System.Uri] $Uri
    )

    Process
    {
        # Abstract parameters
        switch ($PsCmdlet.ParameterSetName)
        {
            "ByItem"
            {
                $_uri = $Item.Uri
            }
            "ByUri"
            {
                $_uri = $Uri
            }
        }

        return $global:UmsDocumentCache.GetDocument($_uri)
    }
}