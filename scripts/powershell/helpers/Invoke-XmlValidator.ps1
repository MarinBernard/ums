function Invoke-XmlValidator
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
    $_sourcePath = (New-object -Type System.Uri -ArgumentList $Source).LocalPath
    if (-not(Test-Path -LiteralPath $_sourcePath))
    {
        throw ($ModuleStrings.RunXmlValidation.SourceFileNotFound -f $Source)
    }

    # Check schema file existence
    $_schemaPath = (New-object -Type System.Uri -ArgumentList $Schema).LocalPath
    if (-not(Test-Path -LiteralPath $_schemaPath))
    {
        throw ($ModuleStrings.RunXmlValidation.SchemaNotFound -f $Schema)
    }

    # Check whether the JRE is available
    $_jreBinPath = Get-UmsConfigurationItem -ShortName "JreBinPath"
    if (-not (Test-Path -Path $_jreBinPath))
    {
        throw $ModuleStrings.RunXmlValidation.JreNotFound
    }

    # Check whether the Jing Jar archive is available
    $_jingJarPath = Get-UmsConfigurationItem -ShortName "JingJarPath"
    if (-not (Test-Path -Path $_jingJarPath))
    {
        throw $ModuleStrings.RunXmlValidation.JingNotFound
    }

    # Build Jing argument list
    $_arguments = @(
        "-jar", $_jingJarPath,
        $Schema,
        $Source
    )

    # Invoke Jing validator and return the result
    Write-Verbose -Message $("Jing invocation string: " + $_jreBinPath + " " + $_arguments)
    & $_jreBinPath $_arguments    
    return $LASTEXITCODE
}