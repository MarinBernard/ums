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
    Test-UmsItemManagement -Path "D:\MyMusic"
    #>

    [CmdletBinding()]
    Param(
        [Parameter(Position=0,ValueFromPipeline=$true)]
        [System.IO.DirectoryInfo] $Path
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
    
        try
        {
            $_managementIsEnabled = [ItemManager]::TestManagement($Path)
        }
    
        # Catch missing static folder
        catch [IMMissingStaticFolderException]
        {
            [EventLogger]::LogException($_.Exception)
            [EventLogger]::LogWarning($Messages.MissingStaticFolder)
        }
    
        # Catch missing cache folder
        catch [IMMissingCacheFolderException]
        {
            [EventLogger]::LogException($_.Exception)
            [EventLogger]::LogWarning($Messages.MissingCacheFolder)
        }
    
        # Catch terminating exceptions
        catch [IMInconsistentStateException]
        {
            [EventLogger]::LogException($_.Exception)
            return
        }
        catch [UmsException]
        {
            [EventLogger]::LogException($_.Exception)
            return
        }
        catch
        {
            [EventLogger]::LogException($_.Exception)
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