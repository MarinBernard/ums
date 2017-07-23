function Read-XmlNamespace
{
    Param(
        [Parameter(Mandatory=$true)]
        [ValidateNotNull()]
        [string] $Path
    )

    # Check file existence
    if (-not(Test-Path -LiteralPath $Path))
    {
        throw ($ModuleStrings.ReadXmlNamespaceUri.FileNotFound -f $Path)
    }

    # Read file content
    try
    {
        [xml] $_content = Get-Content -LiteralPath $Path
    }
    catch
    {
        throw ($ModuleStrings.ReadXmlNamespaceUri.BadXmlContent -f $Path)
    }

    # Find the first element node and return its namespace URI
    foreach ($node in $_content.ChildNodes)
    {
        if ($node.NodeType -eq "Element")
        {
            return $node.NamespaceURI
        }
    }

    # If no namespace was found
    throw ($ModuleStrings.ReadXmlNamespaceUri.NoNamespace -f $Path)
}