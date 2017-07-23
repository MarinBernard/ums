function Update-UmsCache
{
    <#
    .SYNOPSIS
    Update the cached version of the UMS metadata of a folder.
    
    .DESCRIPTION
    Update the cached version of the UMS metadata of a folder. Cached metadata are stored locally and consist of a single, static, dependency-free UMS file. Most advanced metadata converters use cached versions as a data source, and expect them to be up-to-date.
    
    .PARAMETER Path
    A path to a valid, UMS-enabled folder. Default is the current folder.

    .PARAMETER Force
    Force cache update even if it is not necessary.
    
    .EXAMPLE
    Update-UmsCache -Path "D:\MyMusic"
    #>

    Param(
        [ValidateNotNull()]
        [string] $Path = ".",

        [switch] $Force
    )

    # Check whether UMS metadata are enabled
    try
    {  
        if (-not(Test-UmsMetadata -Boolean -Path $Path))
        {
            Write-Warning -Message $ModuleStrings.EnableUmsMetadata.UmsNotEnabled
            return
        }
    }
    catch
    {
        Write-Host $_.Exception.Message
        return
    }
    
    ### From now on, we assume UMS is enabled and UMS items are available ###

    # Get the path to the main metadata file
    $_mainFileObject = Get-UmsItem -Type "Main" -Path $Path
    $_mainFileName = $_mainFileObject.FullName
    $_mainFileUri = (New-Object -Type System.Uri -ArgumentList $_mainFileName).AbsoluteUri

    # Check whether the main metadata file exists
    if (-not $_mainFileObject)
    {
        throw $ModuleStrings.Common.VoidUmsMetadata
    }

    # Get the path to the static metadata file
    $_staticUmsItem = Get-UmsItem -Type "Static" -Path $Path

    # Check whether the update is needed by comparing last write times
    if (($_staticUmsItem) -and (-not ($Force.IsPresent)))
    {
        if ($_staticUmsItem.LastWriteTime -gt $_mainFileObject.LastWriteTime)
        {
            Write-Host $ModuleStrings.UpdateUmsCache.NoUpdateNeeded
            return
        }
    }
    
    # Get the expander stylesheet URI
    $_stylesheetUri = Get-UmsConfigurationItem -ShortName "ExpanderStylesheetUri"

    # Build the name of the temporary destination file
    $_temporaryFileName = $($_mainFileName + ".tmp")

    # Remove previous temporary file, if needed
    if (Test-Path -LiteralPath $_temporaryFileName)
    {
        try
        {
            Remove-Item -LiteralPath $_temporaryFileName -Force -ErrorAction "Stop"
        }
        catch
        {
            throw $ModuleStrings.UpdateUmsCache.TempFileRemovalFailure
        }
    }

    # Run the transform
    try 
    {
        Invoke-XslTransformer -Source $_mainFileUri -Stylesheet $_stylesheetUri -Destination $_temporaryFileName
    }
    catch
    {
        # Temporary file should be removed if transform has failed
        Remove-Item -Force -LiteralPath $_temporaryFileName -ErrorAction SilentlyContinue
        Write-Error -Message $_.Exception.Message
        return
    }

    # Validate the temporary file
    $invalid = Test-UmsXmlValidation -Path $_temporaryFileName

    # Check validation result
    if ($invalid)
    {
        # Temporary file should be removed if validation has failed
        Remove-Item -Force -LiteralPath $_temporaryFileName
        throw $ModuleStrings.UpdateUmsCache.ValidationFailure
    }

    # Remove existing static item, if it exists
    if ($_staticUmsItem)
    {
        Remove-Item -Force -LiteralPath $_staticUmsItem.FullName
    }

    # Promote temporary file to static item
    $_staticFileName = Get-UmsMetadataFileName -Path $Path -Type "Static"
    Move-Item -Path $_temporaryFileName -Destination $_staticFileName
}