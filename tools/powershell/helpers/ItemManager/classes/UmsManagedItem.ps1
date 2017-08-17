###############################################################################
#   Class UmsManagedItem
#==============================================================================
#
#   This class describes a managed UmsItem, i.e. a UmsItem which is stored
#   in a local dedicated folder, and eligible to metadata and static version
#   caching.
#
#   The class inherits the UmsItem parent class, and adds:
#   - Properties dealing with the managed path and the optional linked file
#   - Properties describing the cache file and metadata caching status.
#   - Properties describing the static file and static version status.
#
###############################################################################

class UmsManagedItem : UmsItem
{
    ###########################################################################
    # Static properties
    ###########################################################################

    ###########################################################################
    # Hidden properties
    ###########################################################################

    # References to folders involved in UMS management
    hidden [System.IO.DirectoryInfo] $CacheFolder
    hidden [System.IO.DirectoryInfo] $ContentFolder
    hidden [System.IO.DirectoryInfo] $ManagementFolder
    hidden [System.IO.DirectoryInfo] $StaticFolder

    # URI to folders involved in UMS management
    hidden [System.Uri] $CacheFolderUri
    hidden [System.Uri] $ContentFolderUri
    hidden [System.Uri] $ManagementFolderUri
    hidden [System.Uri] $StaticFolderUri

    # Properties related to the static version of the item
    hidden [System.IO.FileInfo] $StaticFile
    hidden [System.Uri]         $StaticFileUri

    # Properties related to the cached metadata of the item
    hidden [System.IO.FileInfo] $MetadataCacheFile
    hidden [System.Uri]         $MetadataCacheFileUri

    # Properties related to the content file (for sidecar items only)
    hidden [System.IO.FileInfo] $ContentFile
    hidden [System.Uri]         $ContentFileUri

    ###########################################################################
    # Visible properties
    ###########################################################################

    # Cardinality of the UMS item: whether it is an independent, sidecar or
    # orphaned item. Value Unknown is set by default but should never make it
    # through the construction process.
    [UmsItemCardinality] $Cardinality = [UmsItemCardinality]::Unknown

    # Status of the static version of the UMS item. This property is set to
    # Unknown by default but should always be updated by the constructor.
    [UmsItemVersionStatus] $StaticVersion = [UmsItemVersionStatus]::Unknown

    # Status of the cached version of the UMS item metadata. This property is
    # set to Unknown by default but should always be updated by the constructor
    [UmsItemVersionStatus] $CachedVersion = [UmsItemVersionStatus]::Unknown

    ###########################################################################
    # Constructors
    ###########################################################################

    # Default constructor.
    # Throws:
    #   - [UmsItemException] on construction failure.
    UmsManagedItem([System.IO.FileInfo] $FileInfo) : base($FileInfo)
    {
        # Call the sub-constructor to initialize properties dealing with
        # management-related folders.
        try
        {
            $this.InitManagementFolderProperties()
        }
        catch [UmsItemException]
        {
            Write-Error -Message $_.Exception.MainMessage
            throw [UmsItemException]::New()
        }
        
        # Calling sub-constructor dedicated to static file info
        try
        {
            $this.UpdateStaticFileInfo()
        }
        catch [UmsItemException]
        {
            Write-Error -Message $_.Exception.MainMessage
            throw [UmsItemException]::New()
        }
        
        # Calling sub-constructor dedicated to cache file info
        try
        {
            $this.UpdateCacheFileInfo()
        }
        catch [UmsItemException]
        {
            Write-Error -Message $_.Exception.MainMessage
            throw [UmsItemException]::New()
        }

        # Calling sub-constructor dedicated to content file info
        try
        {
            $this.UpdateContentFileInfo()
        }
        catch [UmsItemException]
        {
            Write-Error -Message $_.Exception.MainMessage
            throw [UmsItemException]::New()
        }
       
        # Calling sub-constructor dedicated to cardinality info
        try
        {
            $this.UpdateCardinalityInfo()
        }
        catch [UmsItemException]
        {
            Write-Error -Message $_.Exception.MainMessage
            throw [UmsItemException]::New()
        }
    }

    # Sub-constructor for properties describing management-related folders.
    # This methods initialize all [DirectoryInfo] and [System.Uri] properties
    # dealing with management folders.
    # Throws:
    #   - [UIGetManagementFolderFailureException] if a folder reference cannot
    #       be obtained.
    #   - [UIUriCreationFailureException] if a URI cannot be created.
    [void] InitManagementFolderProperties()
    {
        # Management folder
        try
        {
            # The main management folder is always assumed to be the parent
            # directory of the item.
            $this.ManagementFolder = $this.File.Directory
            $this.ManagementFolderUri = (
                [System.Uri]::New($this.ManagementFolder))
        }
        catch [System.SystemException]
        {
            Write-Error -Exception $_.Exception
            throw [UIGetManagementFolderFailureException]::New(
                $this.File, "management")
        }

        # Content folder
        try
        {
            $this.ContentFolder = (
                [ItemManager]::GetContentFolder($this.ManagementFolder))
            $this.ContentFolderUri = [System.Uri]::New($this.ContentFolder)
        }
        catch [ItemManagerException]
        {
            Write-Error -Message $_.Exception.MainMessage
            throw [UIGetManagementFolderFailureException]::New(
                $this.File, "content")
        }
        catch [System.SystemException]
        {
            Write-Error -Exception $_.Exception
            throw [UIUriCreationFailureException]::New($this.ContentFolder)
        }
        
        # Cache folder
        try
        {
            $this.CacheFolder = (
                [ItemManager]::GetCacheFolder($this.ManagementFolder))
            $this.CacheFolderUri = [System.Uri]::New($this.CacheFolder)
        }
        catch [ItemManagerException]
        {
            Write-Error -Message $_.Exception.MainMessage
            throw [UIGetManagementFolderFailureException]::New(
                $this.File, "cache")
        }
        catch [System.SystemException]
        {
            Write-Error -Exception $_.Exception
            throw [UIUriCreationFailureException]::New($this.CacheFolder)
        }

        # Static folder
        try
        {   
            $this.StaticFolder = (
                [ItemManager]::GetStaticFolder($this.ManagementFolder))
            $this.StaticFolderUri = [System.Uri]::New($this.StaticFolder)
        }
        catch [ItemManagerException]
        {
            Write-Error -Message $_.Exception.MainMessage
            throw [UIGetManagementFolderFailureException]::New(
                $this.File, "static")
        }
        catch [System.SystemException]
        {
            Write-Error -Exception $_.Exception
            throw [UIUriCreationFailureException]::New($this.StaticFolder)
        }
    }

    # Update all properties related to the static file.
    # Throws:
    #   - [UIUriCreationFailureException] if a URI cannot be created.
    [void] UpdateStaticFileInfo()
    {
        # Build a reference to the static file.
        $this.StaticFile = [System.IO.FileInfo] (
            Join-Path -Path $this.StaticFolder -ChildPath $this.File.Name)

        # Create a URI to the static file
        try
        {
            $this.StaticFileUri = [System.Uri]::New($this.StaticFile)
        }
        catch [System.SystemException]
        {
            Write-Error -Exception $_.Exception
            throw [UIUriCreationFailureException]::New($this.StaticFile)
        }

        # Update static version status
        if ($this.StaticFile.Exists)
        {
            if ($this.File.LastWriteTime -gt $this.StaticFile.LastWriteTime)
            {
                $this.StaticVersion = [UmsItemVersionStatus]::Expired
            }
            else
            {
                $this.StaticVersion = [UmsItemVersionStatus]::Current
            }
        }
        else
        {
            $this.StaticVersion = [UmsItemVersionStatus]::Absent
        }
    }

    # Update all properties related to the cache file.
    # Throws:
    #   - [UIUriCreationFailureException] if a URI cannot be created.
    [void] UpdateCacheFileInfo()
    {
        # Build a reference to the cache file.
        $this.CacheFile = [System.IO.FileInfo] (
            Join-Path -Path $this.CacheFolder -ChildPath $this.File.Name)

        # Create a URI to the cache file
        try
        {
            $this.CacheFileUri = [System.Uri]::New($this.CacheFile)
        }
        catch [System.SystemException]
        {
            Write-Error -Exception $_.Exception
            throw [UIUriCreationFailureException]::New($this.CacheFile)
        }

        # Cached metadata status
        if ($this.CacheFile.Exists)
        {
            if ($this.File.LastWriteTime -gt $this.CacheFile.LastWriteTime)
            {
                $this.CachedVersion = [UmsItemVersionStatus]::Expired
            }
            else
            {
                $this.CachedVersion = [UmsItemVersionStatus]::Current
            }
        }
        else
        {
            $this.CachedVersion = [UmsItemVersionStatus]::Absent
        }
    }

    # Update all properties related to the content file.
    # Throws:
    #   - [UIUriCreationFailureException] if a URI cannot be created.
    [void] UpdateContentFileInfo()
    {
        # We only proceed if the item includes a binding document.
        if ($this.Document.BindingDocument)
        {
            # Build a reference to the content file.
            $this.ContentFile = [System.IO.FileInfo] (
                Join-Path `
                    -Path $this.ContentFolder `
                    -ChildPath $this.File.BaseName)

            # Create a URI to the content file
            try
            {
                $this.ContentFileUri = [System.Uri]::New($this.ContentFile)
            }
            catch [System.SystemException]
            {
                Write-Error -Exception $_.Exception
                throw [UIUriCreationFailureException]::New($this.ContentFile)
            }
        }
    }

    # Sub-constructor for cardinality information
    # Does not throw any exception.
    [void] UpdateCardinalityInfo()
    {
        if ($this.Document.BindingDocument)
        {
            # Check item link status
            if ($this.ContentFile.Exists)
            {
                $this.Cardinality = [UmsItemCardinality]::Sidecar
            }
            else
            {
                $this.Cardinality = [UmsItemCardinality]::Orphan
            }
        }

        # Any item including a non-binding document is declared independent
        else
        {
            $this.Cardinality = [UmsItemCardinality]::Independent
        }
    }

    ###########################################################################
    # Helpers
    ###########################################################################
}

Enum UmsItemVersionStatus
{
    Unknown
    Absent
    Current
    Expired
}

Enum UmsItemCardinality
{
    Unknown
    Independent
    Sidecar
    Orphan
}