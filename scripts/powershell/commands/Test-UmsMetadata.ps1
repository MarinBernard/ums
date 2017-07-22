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
    $_umsFolderPath = Get-UmsMetadataFolderPath -Path $Path

    # Check whether the UMS folder exists
    if ( Test-Path -LiteralPath $_umsFolderPath -ErrorAction SilentlyContinue )
    {
        if ($Boolean.IsPresent)
        {
            return $true
        }
        else
        {
            Write-Host $ModuleStrings.TestUmsMetadata.Enabled
        }
    }
    else
    {
        if ($Boolean.IsPresent)
        {
            return $false
        }
        else
        {
            Write-Host $ModuleStrings.TestUmsMetadata.Disabled
        }
    }
}