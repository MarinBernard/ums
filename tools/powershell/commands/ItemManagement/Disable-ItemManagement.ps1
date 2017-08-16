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

    Process
    {
        # Use local path if no path was specified
        if ($Path -eq $null) { $Path = Get-Item -Path "." }

        # Shortcut to messages
        $Messages = $ModuleStrings.Commands.Management

         # Test management
        [bool] $_managementIsEnabled = $null
    
        try
        {
            $_managementIsEnabled = [ItemManager]::TestManagement($Path)
        }
    
        # Catch any exception and abort.
        catch
        {
            Write-Warning -Message $Messages.InconsistentState
            Write-Warning -Message $Messages.TestAdvice
            return
        }

        # We only disable management if it is enabled.
        if (-not $_managementIsEnabled)
        {
            Write-Warning -Message $Messages.ManagementDisabled
            return
        }

        # Disable item management
        try
        {
            [ItemManager]::DisableManagement($Path, $Confirm)
        }
        catch [IMDisableManagementFailureException]
        {
            Write-Error -Message $Messages.DisableFailure
        }

        Write-Host $Messages.DisableSuccess
    }
}