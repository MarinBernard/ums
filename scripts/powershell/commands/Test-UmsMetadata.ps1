function Test-UmsMetadata
{
    <#
    .SYNOPSIS
    Checks whether UMS metadata are enabled with the specified folder.
    
    .DESCRIPTION
    Checks whether UMS metadata are enabled with the specified folder.
    
    .PARAMETER Path
    A path to a valid folder. Default is the current folder.

    .PARAMETER Boolean
    If enabled, the command wll run in mute mode and return $true if UMS metadata are enabled, $false otherwise.
    
    .EXAMPLE
    Test-UmsMetadata -Path "D:\MyMusic"
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
            { Write-Host $ModuleStrings.TestUmsMetadata.Disabled }
    }
    else
    {
        # Check whether the cache folder exists
        $_umsCacheFolder = Get-UmsSpecialFolderPath -Type "Cache" -Path $Path
        if (-not (Test-Path -LiteralPath $_umsCacheFolder))
        {
            $_valid = $false
            if (-not ($Boolean.IsPresent))
                { Write-Host $ModuleStrings.TestUmsMetadata.CacheFolderNotFound }
        }
        # All checks passed!
        else
        {
            if (-not ($Boolean.IsPresent))
                { Write-Host $ModuleStrings.TestUmsMetadata.Enabled }
        }
    }
    
    # Result output
    if ($Boolean.IsPresent)
    { return $_valid }
}