function Test-UmsXmlValidation
{
    Param(
        [Parameter(Mandatory=$true)]
        [ValidateNotNull()]
        [string] $Path
    )

    # Extract source namespace from the file
    $_sourceNamespace = Read-XmlNamespace -Path $Path

    # Convert source path to Uri
    $_sourceUri = (New-Object -Type System.Uri -ArgumentList $Path).AbsoluteUri
    
    # Get the URI of the Relax NG schema to use
    $_schemaUri = (Get-UmsConfigurationItem -Type Schema | Where-Object { $_.Namespace -eq $_sourceNamespace }).Uri

    # Run XML validation and return the result
    return Invoke-XmlValidator -Source $_sourceUri -Schema $_schemaUri
}