function Run-XmlValidation
{
    Param(
        [Parameter(Mandatory=$true)]
        [ValidateNotNull()]
        [string] $Source,

        [Parameter(Mandatory=$true)]
        [ValidateNotNull()]
        [string] $Schema
    )

    # Check source file existence
    if (-not(Test-Path -LiteralPath $Source))
    {
        throw ($ModuleStrings.RunXmlValidation.SourceFileNotFound -f $Source)
    }

    # Check schema file existence
    if (-not(Test-Path -LiteralPath $Schema))
    {
        throw ($ModuleStrings.RunXmlValidation.SchemaNotFound -f $Schema)
    }

    # Check whether the JRE is available
    if (-not (Test-Path -Path $ModuleConfig.Tools.Java))
    {
        throw $ModuleStrings.RunXmlValidation.JreNotFound
    }

    # Check whether the Jing Jar archive is available
    if (-not (Test-Path -Path $ModuleConfig.Tools.Jing))
    {
        throw $ModuleStrings.RunXmlValidation.JingNotFound
    }

    # Build Jing argument list
    $_arguments = @(
        "-jar", $ModuleConfig.Tools.Jing,
        $('"' + $Schema + '"'),
        $('"' + $Source + '"')
    )

    # Invoke Jing validator and return the result
    & $ModuleConfig.Tools.Java $_arguments    
    return $LASTEXITCODE
}