function Update-UmsItem
{
    <#
    .SYNOPSIS
    Update the static and cached version of an UMS item.
    
    .DESCRIPTION
    Update the static and cached version of an UMS item. Static metadata are stored locally and consist of a single, dependency-free UMS file. Most advanced metadata converters use cached versions as a data source, and expect them to be up-to-date.

    .PARAMETER Item
    A valid UmsItem instance. Use Get-UmsItem to retrieve UmsItem instances.

    .PARAMETER Version
    The type of version to update. Default is to update both static and cached versions, but this behaviour may be altered using this parameter.

    .PARAMETER Silent
    Do not show the update report.

    .PARAMETER Force
    Force cache update even if it is not necessary. Default is to skip cache updates if the cached file is newer than the source UMS item.
    
    .EXAMPLE
    Get-UmsItem -Path "D:\MyMusic" -Status Sidecar | Update-UmsItem
    #>

    [CmdletBinding(DefaultParametersetName='None')]
    Param(
        [Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true)]
        [ValidateNotNull()]
        [UmsItem] $Item,

        [ValidateSet("All", "Static", "Cached")]
        [string] $Version = "All",

        [switch] $Silent,

        [switch] $Force
    )
    
    Begin
    {
        # Get the expander stylesheet URI
        $_stylesheetUri = Get-UmsConfigurationItem -ShortName "ExpanderStylesheetUri"
    }

    Process
    {
        # Update progress bar
        $_progressActivity = $("Updating UMS item " + $Item.Name + "...")
        Write-Progress `
            -Activity $_progressActivity `
            -CurrentOperation "Updating static version" `
            -PercentComplete 50

        # Update static version, if asked to
        if (@("All", "Static") -contains $Version)
        {
            # Check whether the update is needed
            if (($Item.StaticVersion -eq [UIVersionStatus]::Current) -and (-not $Force.IsPresent))
            {
                Write-Verbose "Static version is up-to-date."
            }
            else
            {
                # Get the full name of the static file
                $_staticFileFullName = $Item.StaticFileFullName

                # Build the name of the temporary destination file
                $_tempFileFullName = $($_staticFileFullName + ".tmp")

                # Remove previous temporary file, if needed
                if (Test-Path -LiteralPath $_tempFileFullName)
                {
                    try
                    {
                        Remove-Item -LiteralPath $_tempFileFullName `
                            -Force -ErrorAction "Stop"
                    }
                    catch
                    {
                        throw $ModuleStrings.UpdateUmsItem.TempFileRemovalFailure
                    }
                }

                # Run XSL transform
                try 
                {
                    Invoke-XslTransformer `
                        -Source $Item.Uri `
                        -Stylesheet $_stylesheetUri `
                        -Destination $_tempFileFullName
                }
                catch
                {
                    # Temporary file should be removed if transform has failed
                    Remove-Item `
                        -Force `
                        -LiteralPath $_tempFileFullName `
                        -ErrorAction SilentlyContinue
                    
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
                    throw $ModuleStrings.UpdateUmsItem.ValidationFailure
                }

                # Promote temporary file to be the new static file
                try
                {
                    # Remove pre-existing static file, if it exists
                    if (Test-Path -LiteralPath $_staticFileFullName)
                        { Remove-Item -Force -LiteralPath $_staticFileFullName }
                    
                    # Promote temporary file to static item
                    Move-Item -Path $_tempFileFullName -Destination $_staticFileFullName
                }

                # Catch promotion failure
                catch
                {
                    # Temporary file should be removed if validation has failed
                    Remove-Item -Force -LiteralPath $_tempFileFullName
                    throw $ModuleStrings.UpdateUmsItem.PromotionFailure
                }

                # Update static version status in the UmsItem instance
                $Item.UpdateStaticInfo()
            }
        }

        # Update progress bar
        Write-Progress `
            -Activity $_progressActivity `
            -CurrentOperation "Updating cached version" `
            -PercentComplete 50

        # Update cached version, if asked to
        if (@("All", "Cached") -contains $Version)
        {
            # Check whether the update is needed
            if (
                ($Item.CachedVersion -eq [UIVersionStatus]::Current) -and
                (-not $Force.IsPresent))
            {
                Write-Verbose "Cached version is up-to-date."
            }
            else
            {
                # Retrieve metadata
                try
                {
                    $_metadata = Get-UmsMetadata -Silent -Item $Item -Source Raw
                }
                catch [UmsException]
                {
                    Write-Error $_.Exception.MainMessage
                    throw [UmsItemUpdateFailure]::New($Item)
                }

                # Build the name of the temporary destination file
                $_tempFileFullName = $($Item.CacheFileFullName + ".tmp")

                # Cache metadata
                try
                {
                    $_depth = (
                        Get-UmsConfigurationItem -ShortName "UmsXmlCacheDepth")
                        
                    $_metadata | Export-Clixml `
                        -LiteralPath $_tempFileFullName `
                        -Depth $_depth
                }
                catch
                {
                    # Temporary file should be removed if caching has failed
                    Remove-Item `
                        -Force `
                        -LiteralPath $_tempFileFullName `
                        -ErrorAction SilentlyContinue

                    Write-Error $_.Exception.Message
                    throw [UmsItemUpdateFailure]::New($Item)
                }

                # Promote temporary file to be the new cache file
                try
                {
                    # Remove pre-existing cache file, if it exists
                    if (Test-Path -LiteralPath $Item.CacheFileFullName)
                        { Remove-Item -Force -LiteralPath $Item.CacheFileFullName }
                    
                    # Promote temporary file to cache file
                    Move-Item `
                        -Path $_tempFileFullName `
                        -Destination $Item.CacheFileFullName
                }

                # Catch promotion failure
                catch
                {
                    # Temporary file should be removed if validation has failed
                    Remove-Item -Force -LiteralPath $_tempFileFullName
                    throw $ModuleStrings.UpdateUmsItem.PromotionFailure
                }

                # Update cached version status in the UmsItem instance
                $Item.UpdateCacheInfo()
            }
        }

        # Return item update report
        if (-not $Silent.IsPresent)
        {
            return New-Object -Type PSCustomObject -Property (
                [ordered] @{
                    Item = $Item.Name
                    StaticVersion = $Item.StaticVersion
                    CachedVersion = $Item.CachedVersion
                })
        }

        # Update progress bar
        Write-Progress `
            -Activity $_progressActivity `
            -Completed
    }
}