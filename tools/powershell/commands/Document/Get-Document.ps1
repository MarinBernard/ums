function Get-Document
{
    <#
    .SYNOPSIS
    Retrieves and returns a UMS document as an XML document.
    
    .DESCRIPTION
    Retrieves and returns a UMS document as an XML document. This command queries the UMS document cache to speed-up document retrieval.

    .EXAMPLE
    Get-UmsDocument -Uri "http://ums.olivarim.com/catalogs/standard/cities/AR.ums"
    #>

    [CmdletBinding(DefaultParametersetName='ByUri')]
    Param(
        [Parameter(ParametersetName="ByItem",Position=0,Mandatory=$true,ValueFromPipeline=$true)]
        [ValidateNotNull()]
        [UmsFile] $File,

        [Parameter(ParametersetName="ByUri",Position=0,Mandatory=$true,ValueFromPipeline=$true)]
        [ValidateNotNullOrEmpty()]
        [System.Uri] $Uri
    )

    Process
    {
        # Abstract parameters
        switch ($PsCmdlet.ParameterSetName)
        {
            "ByItem"
            {
                $_uri = $File.Uri
            }
            "ByUri"
            {
                $_uri = $Uri
            }
        }

        return [DocumentCache]::GetDocument($_uri)
    }
}