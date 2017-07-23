function Enable-UmsMetadata
{
    <#
    .SYNOPSIS
    Enables Universal Metadata System management for the specified folder.
    
    .DESCRIPTION
    This function creates the .ums hidden folder which is needed to store UMS metadata.
    
    .PARAMETER Path
    A path to a valid folder. Default is the current folder.
    
    .EXAMPLE
    Enable-UmsMetadata -Path "D:\MyMusic"
    #>

    Param(
        [ValidateNotNull()]
        [string] $Path = "."
    )

    # Check whether UMS metadata are enabled
    try
    {  
        if (Test-UmsMetadata -Boolean -Path $Path)
        {
            Write-Warning -Message $ModuleStrings.EnableUmsMetadata.AlreadyEnabled
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
    $_umsFolderPath = Get-UmsMetadataFolderPath -Path $Path
    
    # Attempt folder creation
    try
    {
        $_folder = New-Item -Type Directory -Path $_umsFolderPath
    }

    # If folder creation fails, we stop here
    catch
    {
        Write-Error $_.Exception.Message
        Write-Error -Message $ModuleStrings.EnableUmsMetadata.FolderCreationError
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
            Write-Warning -Message $ModuleStrings.EnableUmsMetadata.FolderHideoutError
        }
    }

}