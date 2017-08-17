function Update-UmsManagedItem
{
    <#
    .SYNOPSIS
    Update the static and cached version of a managed UMS item.
    
    .DESCRIPTION
    Update the static and cached version of a managed UMS item. Static metadata are stored locally and consist of a single, dependency-free UMS file. Most advanced metadata converters use cached versions as a data source, and expect them to be up-to-date.

    .PARAMETER ManagedItem
    A valid UmsManagedItem instance. Use Get-UmsManagedItem to retrieve UmsManagedItem instances.

    .PARAMETER Version
    The type of version to update. Default is to update both static and cached versions, but this behaviour may be altered using this parameter.

    .PARAMETER Silent
    Do not show the update report.

    .PARAMETER Force
    Force cache update even if it is not necessary. Default is to skip cache updates if the cached file is newer than the source UMS item.
    
    .EXAMPLE
    Get-UmsManagedItem -Path "D:\MyMusic" -Status Sidecar | Update-UmsManagedItem
    #>

    [CmdletBinding(DefaultParametersetName='None')]
    Param(
        [Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true)]
        [ValidateNotNull()]
        [UmsManagedItem] $ManagedItem,

        [ValidateSet("All", "Static", "Cached")]
        [string] $Version = "All",

        [switch] $Silent,

        [switch] $Force
    )
    
    Begin
    {
        # Get the expander stylesheet URI
        
        $_stylesheetUri = (
            [ConfigurationStore]::GetStylesheetItem("expander")).Uri
    }

    Process
    {
        # Update progress bar
        $_progressActivity = $("Updating UMS item " + $ManagedItem.Name + "...")
        Write-Progress `
            -Activity $_progressActivity `
            -CurrentOperation "Updating static version" `
            -PercentComplete 50

        # Update static version, if asked to
        if (@("All", "Static") -contains $Version)
        {
            # Check whether the update is needed
            if (($ManagedItem.StaticVersion -eq [UmsItemVersionStatus]::Current) -and (-not $Force.IsPresent))
            {
                Write-Verbose "Static version is up-to-date."
            }
            else
            {
                # Get the full name of the static file
                $_staticFileFullName = $ManagedItem.StaticFileFullName

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
                        throw $ModuleStrings.UpdateUmsManagedItem.TempFileRemovalFailure
                    }
                }

                # Run XSL transform
                try 
                {
                    Invoke-XslTransformer `
                        -Source $ManagedItem.Uri `
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
                $_tempItem = New-object -Type UmsManagedItem -ArgumentList (Get-Item -LiteralPath $_tempFileFullName)
                
                # Validate the temporary file
                $_schemaUri = (
                    [ConfigurationStore]::GetSchemaItem("") | 
                        Where-Object { 
                            $_.Namespace -eq $_tempItem.XmlNamespace }).Uri
                
                $_validator = [RelaxNgValidator]::New($_schemaUri.LocalPath)
                $_isValid = $_validator.Validate($_tempItem.Uri)

                # Check validation result
                if (-not $_isValid)
                {
                    # Temporary file should be removed if validation has failed
                    Remove-Item -Force -LiteralPath $_tempFileFullName
                    throw $ModuleStrings.UpdateUmsManagedItem.ValidationFailure
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
                    throw $ModuleStrings.UpdateUmsManagedItem.PromotionFailure
                }

                # Update static version status in the UmsManagedItem instance
                $ManagedItem.UpdateStaticInfo()
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
                ($ManagedItem.CachedVersion -eq [UmsItemVersionStatus]::Current) -and
                (-not $Force.IsPresent))
            {
                Write-Verbose "Cached version is up-to-date."
            }
            else
            {
                # Retrieve metadata
                try
                {
                    $_metadata = Get-UmsMetadata `
                        -Silent `
                        -ManagedItem $ManagedItem `
                        -Source "Raw"
                }
                catch [UmsException]
                {
                    Write-Error $_.Exception.MainMessage
                    throw [UmsManagedItemUpdateFailure]::New($ManagedItem)
                }

                # Build the name of the temporary destination file
                $_tempFileFullName = $($ManagedItem.CacheFileFullName + ".tmp")

                # Cache metadata
                try
                {
                    $_depth = (
                        [ConfigurationStore]::GetSystemItem(
                            "ExportCliXmlDepth")).Value
                        
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
                    throw [UmsManagedItemUpdateFailure]::New($ManagedItem)
                }

                # Promote temporary file to be the new cache file
                try
                {
                    # Remove pre-existing cache file, if it exists
                    if (Test-Path -LiteralPath $ManagedItem.CacheFileFullName)
                        { Remove-Item -Force -LiteralPath $ManagedItem.CacheFileFullName }
                    
                    # Promote temporary file to cache file
                    Move-Item `
                        -Path $_tempFileFullName `
                        -Destination $ManagedItem.CacheFileFullName
                }

                # Catch promotion failure
                catch
                {
                    # Temporary file should be removed if validation has failed
                    Remove-Item -Force -LiteralPath $_tempFileFullName
                    throw $ModuleStrings.UpdateUmsManagedItem.PromotionFailure
                }

                # Update cached version status in the UmsManagedItem instance
                $ManagedItem.UpdateCacheInfo()
            }
        }

        # Return item update report
        if (-not $Silent.IsPresent)
        {
            return New-Object -Type PSCustomObject -Property (
                [ordered] @{
                    Item = $ManagedItem.Name
                    StaticVersion = $ManagedItem.StaticVersion
                    CachedVersion = $ManagedItem.CachedVersion
                })
        }

        # Update progress bar
        Write-Progress `
            -Activity $_progressActivity `
            -Completed
    }
}