###############################################################################
#   Class UmsDocumentCache
#==============================================================================
#
#   This class implements a caching mechanism for UMS documents.
#
###############################################################################

class UmsDocumentCache
{
    ###########################################################################
    # Static properties
    ###########################################################################

    # The lifetime of all cached documents
    static $DocumentLifetime = (
        [ConfigurationStore]::GetSystemItem("DocumentCacheLifeTime").Value)

    ###########################################################################
    # Hidden properties
    ###########################################################################

    # The cache itself
    hidden [UmsCachedDocument[]] $CachedDocuments = @()

    # Whether we use on-disk persistence
    [bool] $Persist = $true

    # The folder used for on-disk caching
    [System.IO.DirectoryInfo] $CacheFolder

    # Statistics
    hidden [hashtable] $Statistics = @{}

    ###########################################################################
    # Visible properties
    ###########################################################################

    ###########################################################################
    # Constructors
    ###########################################################################

    UmsDocumentCache([System.IO.DirectoryInfo] $CacheFolder)
    {   
        # Create the on-disk cache folder, if needed
        if (-not $CacheFolder.Exists)
        {
            try
            {
                $CacheFolder.Create()
            }
            # Disable on-disk persistence on cache folder creation failure
            catch [System.IO.IOException]
            {
                Write-Warning -Message (
                    $global:ModuleStrings.UmsDocumentCache.
                        CacheFolderCreationFailure)
                $this.Persist = $false
            }
        }

        # Enable persistence
        $this.Persist = $true
        # Store a new instance of the cache folder
        $this.CacheFolder = $CacheFolder.FullName        

        # Initialize document cache and cache statistics
        $this.Reset()

        # Populate the cache
        $this.Restore()
    }

    ###########################################################################
    # Sub-constructors
    ###########################################################################

    ###########################################################################
    # API
    ###########################################################################

    [void] AddDocument([System.Uri] $Uri)
    {
        # Try to fetch the remote resource
        try
        {
            $_resource = $this.GetResource($Uri)
        }
        # Resource not found
        catch [System.Net.WebException]
        {
            throw [UmsDocumentNotFoundExcepion]::New($Uri)
        }
        
        # Get the name of the file to use
        $_hash = $this.GetUriHash($Uri)
        if ($this.Persist)
        {
            $_onDiskFile = (
                Join-Path -Path $this.CacheFolder -ChildPath $_hash)
        }
        else
        {
            $_onDiskFile = [System.IO.Path]::GetTempFileName()
        }

        # Try to save the cached file to disk
        try
        {
            $_resource | Out-File -Encoding UTF8 -Force -FilePath $_onDiskFile
        }
        catch
        {
            Write-Error -Exception $_.Exception
            Remove-Item -Path $_onDiskFile -Force
            throw [UmsCachedDocumentWriteFailureException]::New($_onDiskFile)
        }

        # Create a UmsCachedDocument instance
        try
        {
            $_cachedDocument = [UmsCachedDocument]::New(
                [System.IO.FileInfo] $_onDiskFile,
                [UmsDocumentCache]::DocumentLifetime)
        }
        catch [InvalidUmsDocumentException]
        {
            Remove-Item -Path $_onDiskFile -Force
            throw $_.Exception
        }

        # Remove temp file if persistence is disabled
        if (-not $this.Persist)
        {
            Remove-Item -Path $_onDiskFile -Force
        }

        $this.Statistics.AddedDocuments += 1
        $this.CachedDocuments += $_cachedDocument
    }

    # Returns the whole CachedDocuments collection after a TTL update
    [UmsCachedDocument[]] DumpCachedDocuments()
    {
        $this.RemoveExpiredCachedDocuments()
        return $this.CachedDocuments
    }

    # Force the removal of all expired documents 
    [void] Flush()
    {
        foreach ($_cachedDocument in $this.CachedDocuments)
        {
            $this.RemoveCachedDocument($_cachedDocument)
        }
    }

    # Returns a cached document from its URI. If the cached document is not
    # present in the cache, it is fetched and cached first.
    [System.Xml.XmlDocument] GetDocument([System.Uri] $Uri)
    {
        $_hash = $this.GetUriHash($Uri)
        $_match = $this.CachedDocuments | Where-Object { $_.Hash -eq $_hash }

        # If a match is found, let's validate the caching status, and return
        # the document.
        if ($_match.Count -eq 1)
        {
            $_match.UpdateLifetimeStatistics()

            # Return the match
            if ($_match.Status -eq [UmsCachedDocumentStatus]::Current)
            {
                $this.Statistics.CacheHits += 1
                return $_match.GetDocument()
            }

            # Remove the expired document from the cache.
            else
            {
                # Update statistics
                $this.Statistics.ExpiredDocuments += 1
                # Remove expired document
                $this.RemoveCachedDocument($_match)
                # Recursive call to get fresh copy
                return $this.GetDocument($Uri)
            }
        }

        # Else, we need to fetch and cache the document first.
        else
        {
            $this.Statistics.CacheMisses += 1
            $this.AddDocument($Uri)
            return $this.GetDocument($Uri)
        }
    }

    # Fetches and returns a resource from a URI.
    [string] GetResource([System.Uri] $Uri)
    {
        # Verbose prefix
        $_verbosePrefix = "[UmsDocumentCache]::FetchDocument(): "

        # Returned object
        [Microsoft.PowerShell.Commands.WebResponseObject] $_response = $null

        # Fetch the target document
        try
        {
            Write-Verbose $(
                $_verbosePrefix + `
                "About to retrieve a document from URI: " + `
                $Uri.AbsoluteUri)
            
            $_response = Invoke-WebRequest -Uri $Uri -UseBasicParsing
        }
        catch [System.Net.WebException]
        {
            $this.Statistics.FetchFailures += 1
            Write-Error -Exception $_.Exception
            throw $_.Exception
        }
        
        $this.Statistics.FetchSuccesses += 1

        # Convert the resource body to UTF-8
        return [System.Text.Encoding]::UTF8.GetString(
            $_response.Content)
    }

    [object[]] GetStatistics()
    {
        return New-Object -Type PSCustomObject -Property $this.Statistics
    }

    # Returns a MD5 from a Uri instance
    [string] GetUriHash([System.Uri] $Uri)
    {
        $_encoder = [System.Text.UTF8Encoding]::New()

        $_stream = [System.IO.MemoryStream]::new(
            $_encoder.GetBytes(
                $Uri.AbsoluteUri))

        return (Get-FileHash -Algorithm MD5 -InputStream $_stream).Hash
    }

    # Removes a cached document from the cache and the disk
    [void] RemoveCachedDocument([UmsCachedDocument] $CachedDocument)
    {
        # Remove the file from the disk
        if ($this.Persist)
        {
            if (Test-Path $CachedDocument.File.FullName )
            {
                try
                {
                    Remove-Item -Force -Path $CachedDocument.File.FullName
                }
                catch
                {
                    Write-Warning $_.Exception.Message
                    Write-Warning -Message ($global:ModuleStrings.
                        UmsDocumentCache.CacheFileRemovalFailure `
                        -f $CachedDocument.File.FullName)
                }
            }
        }

        # Remove the document from the cache
        $this.CachedDocuments = $this.CachedDocuments |
            Where-Object { $_ -ne $CachedDocument }

        # Update statistics
        $this.Statistics.RemovedDocuments += 1
    }

    # Force the removal of all expired documents 
    [void] RemoveExpiredCachedDocuments()
    {
        foreach ($_cachedDocument in $this.CachedDocuments)
        {
            $_cachedDocument.UpdateLifetimeStatistics()
            
            if ($_cachedDocument.Status -eq [UmsCachedDocumentStatus]::Expired)
            {
                # Update statistics
                $this.Statistics.ExpiredDocuments += 1
                # Remove document
                $this.RemoveCachedDocument($_cachedDocument)
            }
        }
    }

    # Removes any cached document from the cache and resets statistics.
    [void] Reset()
    {
        $this.CachedDocuments = @()
        $this.Statistics = @{
            FetchFailures = 0;
            FetchSuccesses = 0;
            CacheHits = 0;
            CacheMisses = 0;
            CacheQueries = 0;
            AddedDocuments = 0;
            ExpiredDocuments = 0;
            RemovedDocuments = 0;
        }
    }

    # Loads cached files present in the cache folder.
    [void] Restore()
    {
        if (-not $this.Persist){ return }

        $_cachedFiles = Get-ChildItem -Path $this.CacheFolder
        foreach ($_cachedFile in $_cachedFiles)
        {
            # Creating and storing a UmsCachedDocument instance
            $this.CachedDocuments = (
                [UmsCachedDocument]::New(
                    $_cachedFile,
                    [UmsDocumentCache]::DocumentLifetime))
        }
    }
}