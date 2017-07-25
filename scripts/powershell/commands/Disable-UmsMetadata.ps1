function Disable-UmsMetadata
{
    <#
    .SYNOPSIS
    Disables UMS metadata for the specified folder.
    
    .DESCRIPTION
    This function removes the .ums hidden folder storing UMS metadata. As a consequence, all metadata related to files in this folder will be destroyed.
    
    .PARAMETER Path
    A path to a valid, UMS-enabled folder. Default is the current folder.

    .PARAMETER Confirm
    If set to $true, the user is required to confirm metadata deletion. Default is $true.
    
    .EXAMPLE
    Disable-UmsMetadata -Path "D:\MyMusic"
    #>

    Param(
        [ValidateNotNull()]
        [string] $Path = ".",

        [bool] $Confirm = $true
    )

    # Check whether UMS metadata are enabled
    try
    {  
        if (-not (Test-UmsMetadata -Boolean -Path $Path))
        {
            Write-Warning -Message $ModulelStrings.Common.UmsNotEnabled
            return
        }
    }
    catch
    {
        Write-Host $_.Exception.Message
        return
    }

    ### From now on, we assume UMS is enabled and UMS items are available ###

    # Get path to the UMS folder
    $_umsFolderPath = Get-UmsSpecialFolderPath -Path $Path

    # Remove the UMS directory
    if ($Confirm -eq $true)
    {
        Write-Warning -Message $ModuleStrings.DisableUmsMetadata.ConfirmDeletion
        Remove-Item -Path $_umsFolderPath -Recurse -Force -Confirm | Out-Null
    }
    else
    {
        Remove-Item -Path $_umsFolderPath -Recurse -Force | Out-Null
    }
}