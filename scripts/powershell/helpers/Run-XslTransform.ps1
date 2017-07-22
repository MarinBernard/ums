function Run-XslTransform
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
    if (-not(Test-Path -LiteralPath $Source))
    {
        throw ($ModuleStrings.RunXslTransform.SourceFileNotFound -f $Source)
    }

    # Check stylesheet existence
    if (-not(Test-Path -LiteralPath $Stylesheet))
    {
        throw ($ModuleStrings.RunXslTransform.StylesheetFileNotFound -f $Stylesheet)
    }    

    # Check whether the JRE is available
    if (-not (Test-Path -Path $ModuleConfig.Tools.Java))
    {
        throw $ModuleStrings.RunXslTransform.JreNotFound
    }

    # Check whether the Saxon PE Jar archive is available
    if (-not (Test-Path -Path $ModuleConfig.Tools.SaxonPE))
    {
        throw $ModuleStrings.RunXslTransform.SaxonNotFound
    }

    # Build Saxon argument list
    $_arguments = @(
        "-jar", $ModuleConfig.Tools.SaxonPE,
        $('-xsl:"' + $Stylesheet + '"'),
        $('-s:"' + $Source + '"'),
        $('-warnings:silent')
    )

    # If a destination is specified, let's add it to the argument list
    if ($Destination)
    {
        $_arguments += $('-o:"' + $Destination + '"')
    }

    # If arbitrary arguments are specified, let's add them to the argument list
    foreach ($_argumentName in $Arguments.Keys)
    {
        $_argumentValue = $Arguments[$_argumentName]
        $_arguments += $($_argumentName + "=" + $_argumentValue + " ")
    }

    # Invoke Saxon PE
    & $ModuleConfig.Tools.Java $_arguments *> $null
    
    # Check exit code
    if ($LASTEXITCODE -ne 0)
    {
        throw $ModuleStrings.RunXslTransform.TransformFailure
    }  
}