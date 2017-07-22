function Run-UmsXmlValidation
{
    Param(
        [Parameter(Mandatory=$true)]
        [ValidateNotNull()]
        [string] $Path
    )

    # Check source file existence
    if (-not(Test-Path -LiteralPath $Path))
    {
        throw ($ModuleStrings.RunUmsXmlValidation.SourceFileNotFound -f $Path)
    }

    # Extract schema URI from the file
    $_schemaUri = Read-XmlNamespaceUri -Path $Path
    
    # Get the name of the Relax NG schema to use
    $_schemaFileName = Get-UmsSchemaFileName -URI $_schemaUri

    # Check whether the schema is available
    if (-not (Test-Path -Path $_schemaFileName))
    {
        throw $($ModuleStrings.RunUmsXmlValidation.SchemaFileNotFound -f $_schemaFileName)
    }

    # Run XML validation and return the result
    return Run-XmlValidation -Source $Path -Schema $_schemaFileName
}