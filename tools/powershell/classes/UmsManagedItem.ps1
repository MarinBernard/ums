class UmsManagedItem : UmsItem
{
    ###########################################################################
    # Static properties
    ###########################################################################

    ###########################################################################
    # Hidden properties
    ###########################################################################

    # Properties describing the item itself
    hidden [string] $Extension          # Extension of the UMS file
    hidden [string] $FullName           # Fully qualified name of the UMS file
    hidden [string] $RealName           # Real name of the UMS file on the FS
    hidden [string] $Path               # Fully qualified path of the UMS file
    hidden [string] $Uri                # Absolute URI to $FullName
    hidden [string] $PathUri            # Absolute URI to $Path
    hidden [string] $LastWriteTime      # Last write time of the UMS file
    hidden [string] $ManagedPath        # Fully qualified path of the folder
                                        # containing linked files

    # Properties related to the static version of the item
    hidden [string] $StaticPath                 # FQN of the static folder
    hidden [string] $StaticPathUri              # Absolute URI to $StaticPath
    hidden [string] $StaticFileFullName         # FQN of the static file linked
                                                # to this instance
    hidden [string] $StaticFileUri              # URI to $StaticFileFullName
    hidden [string] $StaticFileLastWriteTime    # Last write of the static file

    # Properties related to the cached version of the item metadata
    hidden [string] $CachePath                  # FQN of the cache folder
    hidden [string] $CachePathUri               # Absolute URI to $CachePath
    hidden [string] $CacheFileFullName          # FQN of the cache file linked
                                                # to this instance
    hidden [string] $CacheFileUri               # URI to $CacheFileFullName
    hidden [string] $CacheFileLastWriteTime     # Last write of the cache file

    # Properties related to the linked file (for sidecar items)
    hidden [string] $LinkedFileName             # Local name of the linked file
    hidden [string] $LinkedFileExtension        # Extension of the linked file
    hidden [string] $LinkedFileBaseName         # Base name of the linked file
    hidden [string] $LinkedFileFullName         # FQN of the linked file
    hidden [string] $LinkedFilePath             # FQN of the linked file path
    hidden [string] $LinkedFileUri              # URI to $LinkedFileFullName
    hidden [string] $LinkedFilePathUri          # URI to $LinkedFilePath
    hidden [string] $LinkedFileLastWriteTime    # Last write of the linked file

    # Properties describing the XML content of the UMS item
    hidden [string] $XmlNamespace       # Namespace of the document element
    hidden [string] $XmlElementName     # Local name of the document element
    hidden [string] $BindingNamespace   # Namespace of binding element, if any
    hidden [string] $BindingSchema      # Schema name of binding elmnt, if any
    hidden [string] $BindingElementName # Local name of binding elmnt, if any

    ###########################################################################
    # Visible properties
    ###########################################################################

    # Name of the UMS item. This name is virtual. Real name is stored in the
    # $RealName hidden property. For sidecar items, the $Name property is
    # the same as the name of the linked file. For independent items, the $Name
    # property is the same as $RealName, minus the UMS extension and the single
    # char prefix, which are removed from the real file name.
    [string] $Name

    # Friendly-name of the XML schema linked to the XML namespace of the
    # document element. If the item cardinality is Sidecar/Orphan, the
    # value of this property is set to the friendly-name of the XML schema
    # of the binding element, instead of the document element.
    [string] $Schema

    # The local name of the document element in the XML document. If the item
    # is a sidecar item, with a umsb:file root attribute, this property
    # is set to the local name of the binding element.
    [string] $Element

    # Cardinality of the UMS item: whether it is an independent, sidecar or
    # orphaned item. Value Unknown is set by default but should never make it
    # through the construction process.
    [UICardinality] $Cardinality = [UICardinality]::Unknown

    # Status of the static version of the UMS item. This property is set to
    # Unknown by default but should always be updated by the constructor.
    [UIVersionStatus] $StaticVersion = [UIVersionStatus]::Unknown

    # Status of the cached version of the UMS item metadata. This property is
    # set to Unknown by default but should always be updated by the constructor
    [UIVersionStatus] $CachedVersion = [UIVersionStatus]::Unknown

    # Validation status of the UMS item. Validation is CPU intensive, and does
    # not occur automatically. This property is set to Unknown by default, and
    # will show this value until validation eventually happens at a later time.
    [UIValidity] $Validity = [UIValidity]::Unknown

    ###########################################################################
    # Constructors
    ###########################################################################

    UmsManagedItem([System.IO.FileInfo] $FileInfo) : base($FileInfo)
    {        
        # Calling sub-constructor for static-related properties
        $this.UpdateStaticInfo()

        # Calling sub-constructor for cache-related properties
        $this.UpdateCacheInfo()

        # Calling sub-constructor for cardinality information.
        # This subconstructor relies on content information.
        $this.UpdateCardinalityInfo()       
    }

    # Sub-constructor for static information
    [void] UpdateStaticInfo()
    {
        # Static file properties
        $this.StaticPath = Get-UmsManagementFolderPath -Type "Static" -Path $this.ManagedPath
        $this.StaticPathUri = (New-Object -Type System.Uri -ArgumentList $this.StaticPath).AbsoluteUri
        $this.StaticFileFullName = Join-Path -Path $this.StaticPath -ChildPath $this.RealName
        $this.StaticFileUri = (New-Object -Type System.Uri -ArgumentList $this.StaticFileFullName).AbsoluteUri

        # Static version status
        if (Test-Path -Path $this.StaticFileFullName)
        {
            $this.StaticFileLastWriteTime = (Get-Item -LiteralPath $this.StaticFileFullName).LastWriteTime
            
            # Init static version status
            if ($this.LastWriteTime -gt $this.StaticFileLastWriteTime)
                {  $this.StaticVersion = [UIVersionStatus]::Expired }
            else
                {  $this.StaticVersion = [UIVersionStatus]::Current }
        }
        else
            { $this.StaticVersion = [UIVersionStatus]::Absent }
    }

    # Sub-constructor for cache-related information
    [void] UpdateCacheInfo()
    {
        # Cache file properties
        $this.CachePath = Get-UmsManagementFolderPath -Type "Cache" -Path $this.ManagedPath
        $this.CachePathUri = (New-Object -Type System.Uri -ArgumentList $this.CachePath).AbsoluteUri
        $this.CacheFileFullName = Join-Path -Path $this.CachePath -ChildPath $this.RealName
        $this.CacheFileUri = (New-Object -Type System.Uri -ArgumentList $this.CacheFileFullName).AbsoluteUri

        # Cached metadata status
        if (Test-Path -Path $this.CacheFileFullName)
        {
            $this.CacheFileLastWriteTime = (Get-Item -LiteralPath $this.CacheFileFullName).LastWriteTime
            
            # Init static version status
            if ($this.LastWriteTime -gt $this.CacheFileLastWriteTime)
                {  $this.CachedVersion = [UIVersionStatus]::Expired }
            else
                {  $this.CachedVersion = [UIVersionStatus]::Current }
        }
        else
            { $this.CachedVersion = [UIVersionStatus]::Absent }
    }

    # Sub-constructor for cardinality information
    [void] UpdateCardinalityInfo()
    {
        # If the item includes binding information, it is sidecar or orphaned.
        if ($this.BindingElementName)
        {
            # Update hidden properties
            $this.LinkedFileName = $this.Name
            $this.LinkedFilePath = $this.ManagedPath
            $this.LinkedFileFullName = Join-Path -Path $this.LinkedFilePath -ChildPath $this.LinkedFileName
            $this.LinkedFileExtension = [System.IO.Path]::GetExtension($this.LinkedFileName)
            $this.LinkedFileUri = (New-Object -Type System.Uri -ArgumentList $this.LinkedFileFullName).AbsoluteUri
            $this.LinkedFilePathUri = (New-Object -Type System.Uri -ArgumentList $this.LinkedFilePath).AbsoluteUri
            $_tmpBaseName = [System.IO.Path]::ChangeExtension($this.LinkedFileName, $null)
            $this.LinkedFileBaseName = $_tmpBaseName.Substring(0, $_tmpBaseName.Length - 1)
            
            # Check item link status
            if (Test-Path -Path $this.LinkedFileFullName)
            {
                $this.LinkedFileLastWriteTime = (Get-Item -LiteralPath $this.LinkedFileFullName).LastWriteTime
                $this.Cardinality = [UICardinality]::Sidecar
            }
            else
            {
                $this.Cardinality = [UICardinality]::Orphan
            }
        }

        # Any item without binding is declared independent
        else
        {
            [UICardinality] $this.Cardinality = [UICardinality]::Independent
        }
    }

    ###########################################################################
    # Helpers
    ###########################################################################
}

Enum UIVersionStatus
{
    Unknown
    Absent
    Current
    Expired
}

Enum UICardinality
{
    Unknown
    Independent
    Sidecar
    Orphan
}