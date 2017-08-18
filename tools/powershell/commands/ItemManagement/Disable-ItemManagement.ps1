function Disable-ItemManagement
{
    <#
    .SYNOPSIS
    Disables UMS metadata management for the specified folder.
    
    .DESCRIPTION
    This command removes the hidden folder storing UMS metadata. As a consequence, any metadata related to any file in this folder will be destroyed.
    
    .PARAMETER Path
    A path to a valid, UMS-enabled folder. Default is the current folder.

    .PARAMETER Confirm
    If set to $true, the user is required to confirm metadata deletion. Default is $true.
    
    .EXAMPLE
    Disable-UmsItemManagement -Path "D:\MyMusic"
    #>

    [CmdletBinding()]
    Param(
        [Parameter(Position=0,ValueFromPipeline=$true)]
        [System.IO.DirectoryInfo] $Path,

        [bool] $Confirm = $true
    )

    Begin
    {
        # Shortcut to messages
        $Messages = $ModuleStrings.Commands.ItemManagement
    }

    Process
    {
        # Use local path if no path was specified
        if ($Path -eq $null) { $Path = Get-Item -Path "." }

        # Test management
        [bool] $_managementIsEnabled = $null
    
        # Test management state: catch any exception and abort.
        try
        {
            $_managementIsEnabled = [ItemManager]::TestManagement($Path)
        }
        catch
        {
            [EventLogger]::LogException($_.Exception)
            [EventLogger]::LogWarning($Messages.InconsistentState)
            [EventLogger]::LogWarning($Messages.TestAdvice)
            return
        }

        # We only disable management if it is enabled.
        if (-not $_managementIsEnabled)
        {
            [EventLogger]::LogWarning($Messages.ManagementDisabled)
            return
        }

        # Disable item management
        try
        {
            [ItemManager]::DisableManagement($Path, $Confirm)
        }
        catch [IMDisableManagementFailureException]
        {
            [EventLogger]::LogError($Messages.DisableFailure)
        }

        Write-Host $Messages.DisableSuccess
    }
}