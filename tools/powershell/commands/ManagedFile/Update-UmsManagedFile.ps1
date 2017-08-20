function Update-UmsManagedFile
{
    <#
    .SYNOPSIS
    Update the static and cached versions of a managed UMS file.
    
    .DESCRIPTION
    Update the static and cached versions of a managed UMS file. Static metadata are stored locally and consist of a single, static, consolidated and dependency-free UMS file. Most foreign metadata converters use cached versions as data sources, and expect them to be up-to-date.

    .PARAMETER ManagedFile
    A valid instance of the UmsManagedFile class. Use Get-UmsManagedFile to retrieve UmsManagedFile instances.

    .PARAMETER Version
    The type of version to update. Default is to update both static and cached versions, but this behaviour may be altered using this parameter.

    .PARAMETER Force
    Forces the update even if it is not necessary. Default behaviour is to skip the update unless the managed UMS file is newer than the version to update.
    
    .EXAMPLE
    Get-UmsManagedFile -Path "D:\MyMusic" -Cardinality Sidecar | Update-UmsManagedFile
    #>

    [CmdletBinding(DefaultParametersetName='None')]
    Param(
        [Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true)]
        [ValidateNotNull()]
        [UmsManagedFile] $ManagedFile,

        [ValidateSet("All", "Static", "Cached")]
        [string] $Version = "All",

        [switch] $Force
    )

    Begin
    {
        # Shortcut to messages
        $Messages = $ModuleStrings.Commands
    }

    Process
    {
        # Update progress bar
        $_progressActivity = $("Updating UMS file " + $ManagedFile.Name + "...")
        Write-Progress `
            -Activity $_progressActivity `
            -CurrentOperation "Updating static version" `
            -PercentComplete 0

        # Update static version, if asked to
        if (@("All", "Static") -contains $Version)
        {
            # Check whether the update is needed
            if (
                ($ManagedFile.StaticVersion -eq 
                    [FileVersionStatus]::Current) -and
                (-not $Force.IsPresent))
            {
                [EventLogger]::LogInformation($Messages.StaticVersionUpToDate)
            }
            else
            {
                try
                {
                    $ManagedFile.UpdateStaticFile()
                }
                catch [UmsFileException]
                {
                    [EventLogger]::LogException($_.Exception)
                    [EventLogger]::LogError($Messages.StaticVersionUpdateFailure)
                }
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
                ($ManagedFile.CachedVersion -eq
                    [FileVersionStatus]::Current) -and
                (-not $Force.IsPresent))
            {
                [EventLogger]::LogInformation($Messages.CachedVersionUpToDate)
            }
            else
            {
                # Retrieve metadata
                try
                {
                    $_metadata = Get-UmsMetadata `
                        -Silent `
                        -ManagedFile $ManagedFile `
                        -Source "Raw"
                }
                catch [UmsException]
                {
                    [EventLogger]::LogException($_.Exception)
                    throw [UmsPublicCommandFailureException]::New("Update-UmsManagedFile")
                }

                # Build the name of the temporary destination file
                $_tempFileFullName = $($ManagedFile.CacheFileFullName + ".tmp")

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

                    [EventLogger]::LogException($_.Exception)
                    throw [UmsPublicCommandFailureException]::New("Update-UmsManagedFile")
                }

                # Promote temporary file to be the new cache file
                try
                {
                    # Remove pre-existing cache file, if it exists
                    if (Test-Path -LiteralPath $ManagedFile.CacheFileFullName)
                        { Remove-Item -Force -LiteralPath $ManagedFile.CacheFileFullName }
                    
                    # Promote temporary file to cache file
                    Move-Item `
                        -Path $_tempFileFullName `
                        -Destination $ManagedFile.CacheFileFullName
                }

                # Catch promotion failure
                catch
                {
                    # Temporary file should be removed if validation has failed
                    Remove-Item -Force -LiteralPath $_tempFileFullName
                    throw $ModuleStrings.UpdateUmsManagedFile.PromotionFailure
                }

                # Update cached version status in the UmsManagedFile instance
                $ManagedFile.UpdateCacheInfo()
            }
        }

        # Update progress bar
        Write-Progress `
            -Activity $_progressActivity `
            -Completed
    }
}