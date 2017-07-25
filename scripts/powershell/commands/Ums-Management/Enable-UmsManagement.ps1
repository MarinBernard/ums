function Enable-UmsManagement
{
    <#
    .SYNOPSIS
    Enables UMS metadata management for the specified folder.
    
    .DESCRIPTION
    This function creates the ums folder which is needed to store UMS metadata.
    
    .PARAMETER Path
    A path to a valid folder. Default is the current folder.
    
    .EXAMPLE
    Enable-UmsMetadata -Path "D:\MyMusic"
    #>

    Param(
        [ValidateNotNull()]
        [string] $Path = "."
    )

    # Check whether UMS management is enabled
    try
    {  
        if (Test-UmsManagement -Boolean -Path $Path)
        {
            Write-Warning -Message $ModuleStrings.EnableUmsManagement.AlreadyEnabled
            return
        }
    }
    catch
    {
        Write-Host $_.Exception.Message
        return
    }

    ### From now on, we assume UMS management is enabled and UMS items are available ###

    # Attempt folder creation
    try
    {
        $_umsFolderPath = Get-UmsSpecialFolderPath -Path $Path
        $_folder = New-Item -Type Directory -Path $_umsFolderPath
    }

    # If folder creation fails, we stop here
    catch
    {
        Write-Error $_.Exception.Message
        Write-Error -Message $ModuleStrings.EnableUmsManagement.FolderCreationError
        return
    }

    # Hide the folder if hidden folders are enabled
    if (Get-UmsConfigurationItem -ShortName "UmsHiddenFolders")
    {
        try
        {
            $_folder | ForEach-Object { $_.Attributes = $_.Attributes -bor [System.IO.FileAttributes]::Hidden }
        }
        catch
        {
            Write-Warning -Message $ModuleStrings.EnableUmsManagement.FolderHideoutError
        }
    }

    # Create the cache subfolder
    try
    {
        $_umsCacheFolderPath = Get-UmsSpecialFolderPath -Path $Path -Type "Cache"
        $_folder = New-Item -Type Directory -Path $_umsCacheFolderPath
    }

    # If folder creation fails, we stop here
    catch
    {
        Write-Error $_.Exception.Message
        Write-Error -Message $ModuleStrings.EnableUmsManagement.CacheFolderCreationError
        return
    }

}