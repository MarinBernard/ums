function Enable-ItemManagement
{
    <#
    .SYNOPSIS
    Enables UMS item management for the specified folder.
    
    .DESCRIPTION
    This function creates the local folder structure which is needed to manage UMS items.
    
    .PARAMETER Path
    A path to a valid folder. Default is the current folder.
    
    .EXAMPLE
    Enable-UmsItemManagement -Path "D:\MyMusic"
    #>

    [CmdletBinding()]
    Param(
        [Parameter(Position=0,ValueFromPipeline=$true)]
        [System.IO.DirectoryInfo] $Path
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
        if ($_managementIsEnabled)
        {
            Write-Warning -Message $Messages.ManagementEnabled
            return
        }

        # Enable UMS item management
        try
        {
            [ItemManager]::EnableManagement($Path)
        }
        catch [IMEnableManagementFailureException]
        {
            Write-Error -Message $Messages.EnableFailure
        }

        Write-Host $Messages.EnableSuccess
    }   
}