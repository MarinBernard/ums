###############################################################################
#   Static class DocumentCache
#==============================================================================
#
#   This class implements a caching mechanism for UMS documents.
#
###############################################################################

class DocumentCache
{
    ###########################################################################
    # Static properties
    ###########################################################################

    # The lifetime of all cached documents
    static $DocumentLifetime = (
        [ConfigurationStore]::GetSystemItem(
            "DocumentCacheLifeTime").Value)

    # The cache itself
    static [CachedDocument[]] $CachedDocuments = @()

    # Whether we use on-disk persistence
    static [bool] $Persist = $true

    # The folder used for on-disk caching
    static [System.IO.DirectoryInfo] $CacheFolder

    # Statistics
    static [hashtable] $Statistics = @{}

    ###########################################################################
    # Visible properties
    ###########################################################################

    ###########################################################################
    # Cache initializer
    ###########################################################################

    static Initialize([System.IO.DirectoryInfo] $CacheFolder)
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
                    $global:ModuleStrings.DocumentCache.
                        CacheFolderCreationFailure)
                [DocumentCache]::Persist = $false
            }
        }

        # Enable persistence
        [DocumentCache]::Persist = $true

        # Store a new instance of the cache folder
        [DocumentCache]::CacheFolder = $CacheFolder.FullName

        # Initialize document cache and cache statistics
        [DocumentCache]::Reset()

        # Populate the cache
        [DocumentCache]::Restore()
    }

    ###########################################################################
    # Sub-constructors
    ###########################################################################

    ###########################################################################
    # API
    ###########################################################################

    # Adds a document to the cache from a URI.
    # Throws:
    #   - [DCDocumentRetrievalFailureException] if the document cannot be
    #       retrieved at the specified Uri. Proxified from ::GetResource().
    #   - [DCCacheWriteFailureException] if the document cannot be added to
    #       the on-disk cache.
    #   - [DCNewCachedDocumentFailureException] if the document cannot be
    #       cached because of a failure of the [CachedDocument] constructor.
    static [void] AddDocument([System.Uri] $Uri)
    {
        # Try to fetch the remote resource
        try
        {
            $_resource = [DocumentCache]::GetResource($Uri)
        }
        # Resource not found
        catch [DCDocumentRetrievalFailureException]
        {
            throw [DCDocumentRetrievalFailureException]::New($Uri)
        }
        
        # Get the name of the file to use
        $_hash = [DocumentCache]::GetUriHash($Uri)
        if ([DocumentCache]::Persist)
        {
            $_onDiskFile = (
                Join-Path -Path ([DocumentCache]::CacheFolder) -ChildPath $_hash)
        }
        else
        {
            $_onDiskFile = [System.IO.Path]::GetTempFileName()
        }

        # Try to save the cached file to disk
        try
        {
            $_resource | Out-File `
                -Encoding UTF8 `
                -Force `
                -FilePath $_onDiskFile `
                -ErrorAction Stop
        }
        catch
        {
            Write-Error -Exception $_.Exception
            Remove-Item -Path $_onDiskFile -Force
            throw [DCCacheWriteFailureException]::New($Uri, $_onDiskFile)
        }

        # Create a CachedDocument instance
        try
        {
            $_cachedDocument = [CachedDocument]::New(
                [System.IO.FileInfo] $_onDiskFile,
                [DocumentCache]::DocumentLifetime)
        }
        catch [CachedDocumentException]
        {
            Write-Error -Message $_.Exception.MainMessage
            Remove-Item -Path $_onDiskFile -Force
            throw [DCNewCachedDocumentFailureException]::New($_onDiskFile)
        }

        # Remove temporary file if persistence is disabled
        if (-not [DocumentCache]::Persist)
        {
            Remove-Item -Path $_onDiskFile -Force
        }

        [DocumentCache]::Statistics.AddedDocuments += 1
        [DocumentCache]::CachedDocuments += $_cachedDocument
    }

    # Returns the whole CachedDocuments collection after a TTL update.
    # This method does not throw any custom exception.
    static [CachedDocument[]] Dump()
    {
        [DocumentCache]::RemoveExpiredCachedDocuments()
        return [DocumentCache]::CachedDocuments
    }

    # Force the removal of all expired documents 
    # This method does not throw any custom exception.
    static [void] Flush()
    {
        foreach ($_cachedDocument in [DocumentCache]::CachedDocuments)
        {
            [DocumentCache]::RemoveCachedDocument($_cachedDocument)
        }
    }

    # Returns a cached document from its URI. If the cached document is not
    # present in the cache, it is fetched and cached, then the method is called
    # again recursively.
    # This method does not throw any custom exception.
    static [UmsDocument] GetDocument([System.Uri] $Uri)
    {
        $_hash  = [DocumentCache]::GetUriHash($Uri)
        $_match = [DocumentCache]::CachedDocuments | Where-Object { $_.Hash -eq $_hash }

        # If a match is found, let's validate the caching status, and return
        # the document.
        if ($_match.Count -eq 1)
        {
            $_match.UpdateLifetimeStatistics()

            # Return the match
            if ($_match.Status -eq [CachedDocumentStatus]::Current)
            {
                [DocumentCache]::Statistics.CacheHits += 1
                return $_match.GetDocument()
            }

            # Remove the expired document from the cache.
            else
            {
                # Update statistics
                [DocumentCache]::Statistics.ExpiredDocuments += 1
                # Remove expired document
                [DocumentCache]::RemoveCachedDocument($_match)
                # Recursive call to get fresh copy
                return [DocumentCache]::GetDocument($Uri)
            }
        }

        # Else, we need to fetch and cache the document first.
        else
        {
            [DocumentCache]::Statistics.CacheMisses += 1
            [DocumentCache]::AddDocument($Uri)
            return [DocumentCache]::GetDocument($Uri)
        }
    }

    # Fetches and returns a resource from a URI.
    # Throws:
    #   - [DCDocumentRetrievalFailureException] if the resource cannot be 
    #       retrieved.
    #   - [DCResponseConversionFailureException] if the fetched resource cannot
    #       be converted to UTF-8.
    static [string] GetResource([System.Uri] $Uri)
    {
        # Verbose prefix
        $_verbosePrefix = "[DocumentCache]::GetResource(): "

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
            [DocumentCache]::Statistics.FetchFailures += 1
            throw [DCDocumentRetrievalFailureException]::New($Uri)
        }
        
        [DocumentCache]::Statistics.FetchSuccesses += 1

        # Convert the resource body to UTF-8
        try
        {
            $_convertedResponse = (
                [System.Text.Encoding]::UTF8.GetString(
                    $_response.Content))
        }
        catch [System.ArgumentException]
        {
            Write-Error -Exception $_.Exception
            throw [DCResponseConversionFailureException]::New($Uri)
        }

        return $_convertedResponse 
    }

    # Returns a PSCustomObject from the ::Statistics array.
    # This method does not throw any custom exception.
    static [object[]] GetStatistics()
    {
        return New-Object `
            -Type "PSCustomObject" `
            -Property ([DocumentCache]::Statistics)
    }

    # Returns a MD5 hash from a Uri instance
    # Throws [DCHashGenerationFailureException] on failure.
    static [string] GetUriHash([System.Uri] $Uri)
    {
        $_encoder = [System.Text.UTF8Encoding]::New()

        try
        {
            $_stream = [System.IO.MemoryStream]::new(
                $_encoder.GetBytes(
                    $Uri.AbsoluteUri))
        }
        catch [System.ArgumentException]
        {
            throw [DCHashGenerationFailureException]::New(
                "md5", $Uri.AbsoluteUri)
        }

        return (Get-FileHash -Algorithm MD5 -InputStream $_stream).Hash
    }

    # Removes a cached document from the cache and the disk
    # Does not throw any custom exception.
    static [void] RemoveCachedDocument([CachedDocument] $CachedDocument)
    {
        # Remove the file from the disk
        if ([DocumentCache]::Persist)
        {
            if (Test-Path $CachedDocument.File.FullName )
            {
                Remove-Item -Force -Path $CachedDocument.File.FullName -ErrorAction Stop
            }
        }

        # Remove the document from the cache
        [DocumentCache]::CachedDocuments = [DocumentCache]::CachedDocuments |
            Where-Object { $_ -ne $CachedDocument }

        # Update statistics
        [DocumentCache]::Statistics.RemovedDocuments += 1
    }

    # Force the removal of all expired documents 
    # This method does not throw any custom exception.
    static [void] RemoveExpiredCachedDocuments()
    {
        foreach ($_cachedDocument in [DocumentCache]::CachedDocuments)
        {
            $_cachedDocument.UpdateLifetimeStatistics()
            
            if ($_cachedDocument.Status -eq [CachedDocumentStatus]::Expired)
            {
                # Update statistics
                [DocumentCache]::Statistics.ExpiredDocuments += 1
                # Remove document
                [DocumentCache]::RemoveCachedDocument($_cachedDocument)
            }
        }
    }

    # Removes any cached document from the cache and resets statistics.
    # This method does not throw any custom exception.
    static [void] Reset()
    {
        [DocumentCache]::CachedDocuments = @()
        [DocumentCache]::Statistics = (
            [ordered] @{
                FetchFailures = 0;
                FetchSuccesses = 0;
                CacheHits = 0;
                CacheMisses = 0;
                AddedDocuments = 0;
                ExpiredDocuments = 0;
                InvalidDocuments = 0;
                RemovedDocuments = 0;
        })
    }

    # Loads cached files present in the cache folder.
    # Does not throw any custom exception, but outputs all
    # [CachedDocumentException] as error messages.
    static [void] Restore()
    {
        if (-not [DocumentCache]::Persist){ return }

        $_cachedFiles = Get-ChildItem -Path ([DocumentCache]::CacheFolder)
        foreach ($_cachedFile in $_cachedFiles)
        {
            # Creating and storing a CachedDocument instance
            try
            {
                [DocumentCache]::CachedDocuments = (
                    [CachedDocument]::New(
                        $_cachedFile,
                        [DocumentCache]::DocumentLifetime))
            }
            catch [CachedDocumentException]
            {
                [DocumentCache]::Statistics.InvalidDocuments += 1
                Write-Error -Message $_.Exception.MainMessage
            }
        }
    }
}