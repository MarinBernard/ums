function Disable-UmsManagement
{
    <#
    .SYNOPSIS
    Disables UMS metadata management for the specified folder.
    
    .DESCRIPTION
    This function removes the ums hidden folder storing UMS metadata. As a consequence, all metadata related to files in this folder will be destroyed.
    
    .PARAMETER Path
    A path to a valid, UMS-enabled folder. Default is the current folder.

    .PARAMETER Confirm
    If set to $true, the user is required to confirm metadata deletion. Default is $true.
    
    .EXAMPLE
    Disable-UmsMetadata -Path "D:\MyMusic"
    #>

    [CmdletBinding()]
    Param(
        [ValidateNotNull()]
        [string] $Path = ".",

        [bool] $Confirm = $true
    )

    # Check whether UMS metadata management is enabled
    try
    {  
        if (-not (Test-UmsManagement -Boolean -Path $Path))
        {
            Write-Warning -Message $ModuleStrings.Common.UmsNotEnabled
            return
        }
    }
    catch
    {
        Write-Host $_.Exception.Message
        return
    }

    ### From now on, we assume UMS management is enabled and UMS items are available ###

    # Get path to the UMS folder
    $_umsFolderPath = Get-UmsSpecialFolderPath -Path $Path
    Write-Verbose -Message $( "Main UMS directory found at " + $_umsFolderPath)

    # Ask confirmation, if needed
    if ($Confirm -eq $true)
    {
        Write-Warning -Message $ModuleStrings.DisableUmsManagement.ConfirmDeletion
        if( (Wait-UserConfirmation) -eq $false ){ return }
    }

    # Remove the UMS directory
    Write-Verbose -Message $( "Removing main UMS directory at " + $_umsFolderPath)
    Remove-Item -Path $_umsFolderPath -Recurse -Force | Out-Null
}