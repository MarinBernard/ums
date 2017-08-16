###############################################################################
#   Class ItemManager
#==============================================================================
#
#   This class implements common routines realted to UMS item management.
#
###############################################################################

class ItemManager
{
    ###########################################################################
    # Static properties
    ###########################################################################

    # Whether UMS item management folders should be hidden.
    static [bool] $HideManagementFolders = (
        [ConfigurationStore]::GetSystemItem("HideManagementFolder"))

    ###########################################################################
    # Management enable/disable/update/test routines
    ###########################################################################

    # Disables UMS item management for the specified location.
    # Throws:
    #   - [IMDisableManagementFailureException] when an unrecoverable error is
    #       encountered.
    static [void] DisableManagement(
        [System.IO.DirectoryInfo] $Path, [bool] $Confirm)
    {
        $VerbosePrefix = "[ItemManager]::DisableManagement(): "

        # Try to get a handle to the management folder
        [System.IO.DirectoryInfo] $_managementFolder = $null
        try
        {
            $_managementFolder = [ItemManager]::GetManagementFolder($Path)
        }
        catch [IMGetFolderFailureException]
        {
            Write-Error -Message $_.Exception.MainMessage
            throw [IMDisableManagementFailureException]::New($Path)
        }

        # Test management folder existence. If the folder does not exist, there
        # is nothing to disable and we halt here.
        if (-not $_managementFolder.Exists) { return }

        # Try to remove the whole management directory
        Write-Verbose -Message ($(
            $VerbosePrefix + `
            "Removing UMS management directory at location: {0}") `
            -f $_managementFolder.FullName)
        try
        {            
            Remove-Item `
                -Path $_managementFolder `
                -Recurse -Force -Confirm:$Confirm `
                -ErrorAction Stop
        }
        catch [System.IO.IOException]
        {
            Write-Error -Exception $_.Exception
            throw [IMDisableManagementFailureException]::New($Path)
        }
    }

    # Enables UMS item management for the specified location.
    # Throws:
    #   - [IMEnableManagementFailureException] when an unrecoverable error is
    #       encountered.
    static [void] EnableManagement([System.IO.DirectoryInfo] $Path)
    {
        $VerbosePrefix = "[UmsItem]::EnableManagement(): "

        # Try to get a handle to the management folder
        [System.IO.DirectoryInfo] $_managementFolder = $null
        try
        {
            $_managementFolder = [ItemManager]::GetManagementFolder($Path)
        }
        catch [IMGetFolderFailureException]
        {
            Write-Error -Message $_.Exception.MainMessage
            throw [IMEnableManagementFailureException]::New($Path)
        }

        # Test management folder existence. If the folder does exist, there
        # is nothing to enable and we stop here.
        if ($_managementFolder.Exists) { return }

        # Try to create the management folder
        Write-Verbose -Message ($(
            $VerbosePrefix + `
            "Creating a UMS management directory at location: {0}") `
            -f $_managementFolder.FullName)        
        try
        {
            $_managementFolder = $_managementFolder.Create()
        }
        catch [System.IO.IOException]
        {
            Write-Error -Exception $_.Exception
            throw [IMEnableManagementFailureException]::New($Path)
        }

        # Try to get the full path to the cache folder
        [System.IO.DirectoryInfo] $_cacheFolder = $null
        try
        {
            $_cacheFolder = [ItemManager]::GetCacheFolder($Path)
        }
        catch [IMGetFolderFailureException]
        {
            Write-Error -Message $_.Exception.MainMessage
            throw [IMEnableManagementFailureException]::New($Path)
        }

        # Try to create the cache folder
        Write-Verbose -Message ($(
            $VerbosePrefix + `
            "Creating a UMS management cache directory at location: {0}") `
            -f $_cacheFolder.FullName)        
        try
        {
            $_cacheFolder = $_cacheFolder.Create()
        }
        catch [System.IO.IOException]
        {
            Write-Error -Exception $_.Exception
            throw [IMEnableManagementFailureException]::New($Path)
        }

        # Try to get the full path to the static folder
        [System.IO.DirectoryInfo] $_staticFolder = $null
        try
        {
            $_staticFolder = [ItemManager]::GetStaticFolder($Path)
        }
        catch [IMGetFolderFailureException]
        {
            Write-Error -Message $_.Exception.MainMessage
            throw [IMEnableManagementFailureException]::New($Path)
        }

        # Try to create the management folder
        Write-Verbose -Message ($(
            $VerbosePrefix + `
            "Creating a UMS management static directory at location: {0}") `
            -f $_staticFolder.FullName)        
        try
        {
            $_staticFolder = $_staticFolder.Create()
        }
        catch [System.IO.IOException]
        {
            Write-Error -Exception $_.Exception
            throw [IMEnableManagementFailureException]::New($Path)
        }

        # Hide management folder is hidden folders are enabled
        if ([ItemManager]::HideManagementFolders)
        {
            try
            {
                [ItemManager]::HideManagementFolder($Path)
            }
            catch [IMHideManagementFolderFailureException]
            {
                Write-Error -Message $_.Exception.MainMessage
                throw [IMEnableManagementFailureException]::New($Path)
            }
        }
    }

    # Checks whether UMS management is enabled for the specified location.
    # Returns $true if it is, $false otherwise.
    # Throws:
    #   - [IMTestManagementFailureException] if the method cannot do its job.
    #   - [IMMissingCacheFolderException] if the cache folder is missing.
    #   - [IMMissingStaticFolderException] if the static folder is missing.
    static [bool] TestManagement([System.IO.DirectoryInfo] $Path)
    {
        # Try to get a handle to the management folder
        [System.IO.DirectoryInfo] $_managementFolder = $null
        try
        {
            $_managementFolder = [ItemManager]::GetManagementFolder($Path)
        }
        catch [IMGetFolderFailureException]
        {
            Write-Error -Message $_.Exception.MainMessage
            throw [IMTestManagementFailureException]::New($Path)
        }

        # Test management folder existence
        if (-not $_managementFolder.Exists){ return $false }

        # Try to get a handle to the cache folder
        [System.IO.DirectoryInfo] $_cacheFolder = $null
        try
        {
            $_cacheFolder = [ItemManager]::GetCacheFolder($Path)
        }
        catch [IMGetFolderFailureException]
        {
            Write-Error -Message $_.Exception.MainMessage
            throw [IMTestManagementFailureException]::New($Path)
        }
        
        # Test cache folder existence. It should exist. If it does not, we
        # assume the management folder is inconsistent and throw an exception.
        if (-not $_cacheFolder.Exists)
        {
            throw [IMMissingCacheFolderException]::New($Path)
        }

        # Try to get a handle to the static folder
        [System.IO.DirectoryInfo] $_staticFolder = $null
        try
        {
            $_staticFolder = [ItemManager]::GetStaticFolder($Path)
        }
        catch [IMGetFolderFailureException]
        {
            Write-Error -Message $_.Exception.MainMessage
            throw [IMTestManagementFailureException]::New($Path)
        }
        
        # Test static folder existence. It should exist. If it does not, we
        # assume the management folder is inconsistent and throw an exception.
        if (-not $_staticFolder.Exists)
        {
            throw [IMMissingStaticFolderException]::New($Path)
        }

        # If we land here, management is declared enabled and valid.
        return $true
    }

    ###########################################################################
    # Management path routines
    ###########################################################################

    # Returns the path of the cache folder for the specified final path.
    # Throws [IMGetFolderFailureException] if an unrecoverable error is met.
    static [System.IO.DirectoryInfo] GetCacheFolder(
        [System.IO.DirectoryInfo] $Path)
    {
        [System.IO.DirectoryInfo] $_managementFolder = $null
        [string] $_cacheFolderName = $null

        # Try to get the path to the management folder.
        try
        {
            $_managementFolder = [ItemManager]::GetManagementFolder($Path)
        }
        catch [IMGetFolderFailureException]
        {
            Write-Error -Message $_.Exception.MainMessage
            throw [IMGetFolderFailureException]::New($Path, "cache")
        }        

        # Try to get the name of the cache folder from the configuration store
        try
        {
            $_cacheFolderName  = ([ConfigurationStore]::GetSystemItem(
                "UmsFolderNameCache").Value)
        }
        catch [ConfigurationStoreException]
        {
            Write-Error -Message $_.Exception.MainMessage
            throw [IMGetFolderFailureException]::New($Path, "cache")
        }

        # We assume Join-Path will never throw an exception.
        return (
            [System.IO.DirectoryInfo] (Join-Path `
                -Path $_managementFolder `
                -ChildPath $_cacheFolderName))
    }

    # Returns the path of the management folder for the specified final path.
    # Throws [IMGetFolderFailureException] if an unrecoverable error is met.
    static [System.IO.DirectoryInfo] GetManagementFolder(
        [System.IO.DirectoryInfo] $Path)
    {
        [string] $_managementFolderName = $null

        try
        {
            $_managementFolderName  = ([ConfigurationStore]::GetSystemItem(
                "UmsFolderNameMain").Value)
        }
        catch [ConfigurationStoreException]
        {
            Write-Error -Message $_.Exception.MainMessage
            throw [IMGetFolderFailureException]::New($Path, "management")
        }        

        # We assume that Join-Path will never throw an exception.
        return (
            [System.IO.DirectoryInfo] (Join-Path `
                -Path $Path `
                -ChildPath $_managementFolderName))
    }

    # Returns the path of the static folder for the specified final path.
    # Throws [IMGetFolderFailureException] if an unrecoverable error is met.
    static [System.IO.DirectoryInfo] GetStaticFolder(
        [System.IO.DirectoryInfo] $Path)
    {
        [System.IO.DirectoryInfo] $_managementFolder = $null
        [string] $_staticFolderName = $null

        # Try to get the path to the management folder.
        try
        {
            $_managementFolder = [ItemManager]::GetManagementFolder($Path)
        }
        catch [IMGetFolderFailureException]
        {
            Write-Error -Message $_.Exception.MainMessage
            throw [IMGetFolderFailureException]::New($Path, "static")
        } 

        # Try to get the name of the cache folder from the configuration store
        try
        {
            $_staticFolderName  = ([ConfigurationStore]::GetSystemItem(
                "UmsFolderNameStatic").Value)
        }
        catch [ConfigurationStoreException]
        {
            Write-Error -Message $_.Exception.MainMessage
            throw [IMGetFolderFailureException]::New($Path, "static")
        }

        # We assume Join-Path will never throw an exception.
        return (
            [System.IO.DirectoryInfo] (Join-Path `
                -Path $_managementFolder `
                -ChildPath $_staticFolderName))
    }

    # Hides the UMS management folder for the specified location.
    # Throws [IMHideManagementFolderFailureException] on error.
    static [void] HideManagementFolder([System.IO.DirectoryInfo] $Path)
    {
        $VerbosePrefix = "[ItemManager]::HideManagementFolder(): "

        # Try to get a handle to the management folder
        [System.IO.DirectoryInfo] $_managementFolder = $null
        try
        {
            $_managementFolder = [ItemManager]::GetManagementFolder($Path)
        }
        catch [IMGetFolderFailureException]
        {
            Write-Error -Message $_.Exception.MainMessage
            throw [IMHideManagementFolderFailureException]::New($Path)
        }

        # Test management folder existence. It should exist. If it does not, we
        # throw an exception.
        if (-not $_managementFolder.Exists)
        {
            throw [IMHideManagementFolderFailureException]::New($Path)
        }

        # Try to hide the management folder
        Write-Verbose -Message ($(
            $VerbosePrefix + `
            "Hiding the UMS management directory at location: {0}") `
            -f $_managementFolder.FullName)  
        try
        {
            $_managementFolder.Attributes = (
                $_managementFolder.Attributes -bor 
                ([System.IO.FileAttributes]::Hidden))
        }
        catch [System.IO.IOException]
        {
            Write-Error -Exception $_.Exception
            throw [IMHideManagementFolderFailureException]::New($Path)
        }
    }
}