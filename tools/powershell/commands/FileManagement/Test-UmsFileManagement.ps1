function Test-UmsFileManagement
{
    <#
    .SYNOPSIS
    Checks whether UMS file management is enabled for the specified folder.
    
    .DESCRIPTION
    Checks whether UMS file management is enabled for the specified folder.
    
    .PARAMETER Path
    A path to a valid folder. Default is the current folder.
    
    .EXAMPLE
    Test-UmsFileManagement -Path "D:\MyMusic"
    #>

    [CmdletBinding()]
    Param(
        [Parameter(Position=0,ValueFromPipeline=$true)]
        [System.IO.DirectoryInfo] $Path
    )

    Begin
    {
        # Shortcut to messages
        $Messages = $ModuleStrings.Commands
    }

    Process
    {
        # Use local path if no path was specified
        if ($Path -eq $null) { $Path = Get-Item -Path "." }
    
        # Test management
        [bool] $_managementIsEnabled = $null
    
        try
        {
            $_managementIsEnabled = [FileManager]::TestManagement($Path)
        }
    
        # Catch missing static folder
        catch [FMMissingStaticFolderException]
        {
            [EventLogger]::LogException($_.Exception)
            [EventLogger]::LogWarning($Messages.MissingStaticFolder)
        }
    
        # Catch missing cache folder
        catch [FMMissingCacheFolderException]
        {
            [EventLogger]::LogException($_.Exception)
            [EventLogger]::LogWarning($Messages.MissingCacheFolder)
        }
    
        # Catch terminating exceptions
        catch [FMInconsistentStateException]
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