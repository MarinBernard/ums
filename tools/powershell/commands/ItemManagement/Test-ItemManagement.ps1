function Test-ItemManagement
{
    <#
    .SYNOPSIS
    Checks whether UMS management is enabled for the specified folder.
    
    .DESCRIPTION
    Checks whether UMS management is enabled for the specified folder.
    
    .PARAMETER Path
    A path to a valid folder. Default is the current folder.
    
    .EXAMPLE
    Test-Management -Path "D:\MyMusic"
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
    
        # Catch missing static folder
        catch [IMMissingStaticFolderException]
        {
            Write-Warning -Message $Messages.MissingStaticFolder
        }
    
        # Catch missing cache folder
        catch [IMMissingCacheFolderException]
        {
            Write-Warning -Message $Messages.MissingCacheFolder
        }
    
        # Catch terminating exceptions
        catch [IMInconsistentStateException]
        {
            Write-Error -Message $Messages.InconsistentState
            return
        }
        catch [UmsException]
        {
            Write-Error -Message $_.Exception.MainMessage
            return
        }
        catch
        {
            Write-Error -Exception $_.Exception
            return
        }
    
        # Output the result
        if ($_managementIsEnabled)
        {
            Write-Host $Messages.ManagementEnabled
        }
        else
        {
            Write-Host $Messages.ManagementDisabled
        }
    }
}