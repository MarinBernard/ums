function Invoke-XslTransformer
{
    Param(
        [Parameter(Mandatory=$true)]
        [ValidateNotNull()]
        [string] $Source,

        [Parameter(Mandatory=$true)]
        [ValidateNotNull()]
        [string] $Stylesheet,

        [Parameter(Mandatory=$false)]
        [ValidateNotNull()]
        [string] $Destination,

        [Parameter(Mandatory=$false)]
        [ValidateNotNull()]
        [hashtable] $Arguments
    )

    # Check source file existence
    $_sourcePath = (New-Object -Type System.Uri -ArgumentList $Source).LocalPath
    if (-not(Test-Path -LiteralPath $_sourcePath))
    {
        throw ($ModuleStrings.RunXslTransform.SourceFileNotFound -f $Source)
    }
    
    # Check stylesheet existence
    $_stylesheetPath = (New-Object -Type System.Uri -ArgumentList $Stylesheet).LocalPath
    if (-not(Test-Path -LiteralPath $_stylesheetPath))
    {
        throw ($ModuleStrings.RunXslTransform.StylesheetNotFound -f $Stylesheet)
    }    
    
    # Check whether the JRE is available
    $_jreBinPath = Get-UmsConfigurationItem -ShortName "JreBinPath"
    if (-not (Test-Path -Path $_jreBinPath))
    {
        throw $ModuleStrings.RunXslTransform.JreNotFound
    }
    
    # Check whether the Saxon PE Jar archive is available
    $_saxonJarPath = Get-UmsConfigurationItem -ShortName "SaxonJarPath"
    if (-not (Test-Path -Path $_saxonJarPath))
    {
        throw $ModuleStrings.RunXslTransform.SaxonNotFound
    }

    # Build Saxon argument list
    $_arguments = @(
        "-jar", "$_saxonJarPath",
        "-xsl:$Stylesheet",
        "-s:$Source",
        '-warnings:silent'
    )

    # If a destination is specified, let's add it to the argument list
    if ($Destination)
    {
        # $Destination is a path instead of an URI because Saxon is unable to handle
        # URIs with dots correctly.
        $_arguments += @('-o:"' + $Destination + '"')
    }

    # If arbitrary arguments are specified, let's add them to the argument list
    foreach ($_argumentName in $Arguments.Keys)
    {
        $_argumentValue = $Arguments[$_argumentName]
        $_arguments += "$_argumentName=$_argumentValue"
    }

    # Invoke Saxon PE
    Write-Verbose "Saxon invocation string:"
    Write-Verbose $($_jreBinPath + $_arguments )
    if([bool](Write-Verbose ([String]::Empty) 4>&1))
    {
        & $_jreBinPath $_arguments
    }
    else
    {
        & $_jreBinPath $_arguments *> $null
    }
    
    # Check exit code
    if ($LASTEXITCODE -ne 0)
    {
        throw $ModuleStrings.RunXslTransform.TransformFailure
    }  
}