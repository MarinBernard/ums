function Test-UmsManagement
{
    <#
    .SYNOPSIS
    Checks whether UMS metadata management is enabled for the specified folder.
    
    .DESCRIPTION
    Checks whether UMS metadata management is enabled for the specified folder.
    
    .PARAMETER Path
    A path to a valid folder. Default is the current folder.

    .PARAMETER Boolean
    If enabled, the command wll run in mute mode and return $true if UMS metadata are enabled, $false otherwise.
    
    .EXAMPLE
    Test-UmsManagement -Path "D:\MyMusic"
    #>

    Param(
        [ValidateNotNull()]
        [string] $Path = ".",

        [switch] $Boolean
    )

    # Test path
    if ( -not (Test-Path -LiteralPath $Path) )
    {
        throw $ModuleStrings.Common.AccessDenied
    }

    # Get path to the UMS folder
    $_umsFolderPath = Get-UmsSpecialFolderPath -Path $Path

    # Default status is valid
    $_valid = $true

    # Check whether the UMS folder exists
    if (-not (Test-Path -LiteralPath $_umsFolderPath))
    {
        $_valid = $false
        if (-not ($Boolean.IsPresent))
            { Write-Host $ModuleStrings.TestUmsManagement.Disabled }
    }
    else
    {
        # Check whether the cache folder exists
        $_umsCacheFolder = Get-UmsSpecialFolderPath -Type "Cache" -Path $Path
        if (-not (Test-Path -LiteralPath $_umsCacheFolder))
        {
            $_valid = $false
            if (-not ($Boolean.IsPresent))
                { Write-Host $ModuleStrings.TestUmsManagement.CacheFolderNotFound }
        }
        # All checks passed!
        else
        {
            if (-not ($Boolean.IsPresent))
                { Write-Host $ModuleStrings.TestUmsManagement.Enabled }
        }
    }
    
    # Result output
    if ($Boolean.IsPresent)
    { return $_valid }
}