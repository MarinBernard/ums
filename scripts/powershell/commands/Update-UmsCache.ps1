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
        if (Test-UmsMetadata -Boolean -Path $Path)
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

    # Check whether the main metadata file exists
    if (-not $_mainFileObject)
    {
        throw $ModuleStrings.Common.VoidUmsMetadata
    }

    # Get the path to the static metadata file
    $_staticFileObject = Get-UmsItem -Type "Static" -Path $Path
    $_staticFileName = $_staticFileObject.FullName

    # Check whether the update is needed by comparing last write times
    if (($_staticFileObject) -and (-not ($Force.IsPresent)))
    {
        if ($_staticFileObject.LastWriteTime -gt $_mainFileObject.LastWriteTime)
        {
            Write-Host $ModuleStrings.UpdateUmsCache.NoUpdateNeeded
            return
        }
    }
    
    # Select the expander stylesheet
    $_stylesheet = $ModuleConfig.UMS.Stylesheets.Expander

    # Build the name of the temporary file
    $_temporaryFile = $($_mainFileName + ".tmp")

    # Remove previous temporary file, if needed
    if (Test-Path -LiteralPath $_temporaryFile)
    {
        try
        {
            Remove-Item -LiteralPath $_temporaryFile -Force -ErrorAction "Stop"
        }
        catch
        {
            throw $ModuleStrings.UpdateUmsCache.TempFileRemovalFailure
        }
    }

    # Run the transform
    try 
    {
        Run-XslTransform -Source $_mainFileName -Stylesheet $_stylesheet -Destination $_temporaryFile    
    }
    catch
    {
        # Temporary file should be removed if transform has failed
        Remove-Item -Force -LiteralPath $_temporaryFile
        Write-Error -Message $_.Exception.Message
    }

    # Validate the temporary file
    $invalid = Run-UmsXmlValidation -Path $_temporaryFile

    # Check validation result
    if ($invalid)
    {
        # Temporary file should be removed if validation has failed
        Remove-Item -Force -LiteralPath $_temporaryFile
        throw $ModuleStrings.UpdateUmsCache.ValidationFailure
    }

    # Promote temporary file to final file
    Remove-Item -Force -LiteralPath $_staticFileName -ErrorAction "SilentlyContinue"
    Move-Item -Path $_temporaryFile -Destination $_staticFileName
}