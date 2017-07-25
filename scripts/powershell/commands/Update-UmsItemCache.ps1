function Update-UmsItemCache
{
    <#
    .SYNOPSIS
    Update the cached version of an UMS item.
    
    .DESCRIPTION
    Update the cached version of an UMS item. Cached metadata are stored locally and consist of a single, static, dependency-free UMS file. Most advanced metadata converters use cached versions as a data source, and expect them to be up-to-date.
    
    .PARAMETER FileInfo
    A valid FileInfo instance as returned by the Get-Item command. Use this parameter to trigger cache update on a sidecar UMS item by specifying a reference to its linked file.

    .PARAMETER Item
    A valid UmsItem instance. Use Get-UmsItem to retrieve UmsItem instances.    

    .PARAMETER Force
    Force cache update even if it is not necessary. Default is to skip cache updates if the cached file is newer than the source UMS item.
    
    .EXAMPLE
    Get-UmsItem -Path "D:\MyMusic" -Status Sidecar | Update-UmsItemCache
    #>

    [CmdletBinding(DefaultParametersetName='None')]
    Param(
        [Parameter(ParameterSetName='FileInfoInstance',Position=0,Mandatory=$true,ValueFromPipeline=$true)]  
        [ValidateNotNull()]
        [System.IO.FileInfo[]] $FileInfo,

        [Parameter(ParameterSetName='ItemInstance',Position=0,Mandatory=$true,ValueFromPipeline=$true)]
        [ValidateNotNull()]
        [UmsItem[]] $Item,

        [switch] $Force
    )
    
    Begin
    {
        # Get the expander stylesheet URI
        $_stylesheetUri = Get-UmsConfigurationItem -ShortName "ExpanderStylesheetUri"
    }

    Process
    {
        # If FileInfo were specified, we need to retrieve an UmsItem instance
        # which is the sidecar file of the target file.
        if($FileInfo)
        {
            $_item = $FileInfo.Directory | Get-UmsItem -Cardinality Sidecar | Where-Object { $_.LinkedFileName -eq $FileInfo.Name }
            if ($Item)
                { $Item = $_item }
            else
            {
                Write-Warning -Message $($FileInfo.Name + ": " + $ModuleStrings.Common.MissingSidecarFile)
                continue
            }
        }

        # Check whether the update is needed
        if (($Item.CachingStatus -eq [UmsItemCachingStatus]::Current) -and (-not $Force.IsPresent))
        {
            Write-Host $($Item.Name + ": " + $ModuleStrings.UpdateUmsItemCache.NoUpdateNeeded)
            return
        }
        
        # Build the full name of the cache file
        $_cacheFileFullName = $Item.CacheFileFullName

        # Build the name of the temporary destination file
        $_tempFileFullName = $($_cacheFileFullName + ".tmp")

        # Remove previous temporary file, if needed
        if (Test-Path -LiteralPath $_tempFileFullName)
        {
            try
                { Remove-Item -LiteralPath $_tempFileFullName -Force -ErrorAction "Stop" }
            catch
                { throw $ModuleStrings.UpdateUmsItemCache.TempFileRemovalFailure }
        }

        # Run XSL transform
        try 
        {
            Invoke-XslTransformer -Source $Item.Uri -Stylesheet $_stylesheetUri -Destination $_tempFileFullName
        }
        catch
        {
            # Temporary file should be removed if transform has failed
            Remove-Item -Force -LiteralPath $_tempFileFullName -ErrorAction SilentlyContinue
            Write-Error -Message $_.Exception.Message
            return
        }

        # Instantiate temporary file
        $_tempItem = New-object -Type UmsItem -ArgumentList (Get-Item -LiteralPath $_tempFileFullName)
        
        # Validate the temporary file
        $_schemaUri = (Get-UmsConfigurationItem -Type Schema | Where-Object { $_.Namespace -eq $_tempItem.XmlNamespace }).Uri
        $_isInvalid = Invoke-XmlValidator -Source $_tempItem.Uri -Schema $_schemaUri

        # Check validation result
        if ($_isInvalid)
        {
            # Temporary file should be removed if validation has failed
            Remove-Item -Force -LiteralPath $_tempFileFullName
            throw $ModuleStrings.UpdateUmsItemCache.ValidationFailure
        }

        # Promote temporary file to the new cache file
        try
        {
            # Remove pre-existing cache file, if it exists
            if (Test-Path -LiteralPath $_cacheFileFullName)
                { Remove-Item -Force -LiteralPath $_cacheFileFullName }
            
            # Promote temporary file to static item
            Move-Item -Path $_tempFileFullName -Destination $_cacheFileFullName
        }

        # Catch promotion failure
        catch
        {
            # Temporary file should be removed if validation has failed
            Remove-Item -Force -LiteralPath $_tempFileFullName
            throw $ModuleStrings.UpdateUmsItemCache.PromotionFailure
        }
    }
}