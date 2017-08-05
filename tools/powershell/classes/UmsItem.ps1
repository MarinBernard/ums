class UmsItem
{
    ###########################################################################
    # Static properties
    ###########################################################################

    static [string] $IndependentFilePrefix = (
        Get-UmsConfigurationItem -ShortName "UmsIndependentFilePrefix")

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
    # document element. The value of this property is extracted from the
    # configuration file. It is the 'id' of the schema whose namespace is
    # identical to $XmlNamespace.
    [string] $Schema

    # The name of the binding element in the XML document, if present. This
    # name includes the namespace prefix.
    [string] $BindingElement = "None"

    # Cardinality of the UMS item: whether it is an independent, sidecar or
    # orphaned item. Value Unknown is set by default but should never make it
    # through the construction process.
    [UICardinality] $Cardinality = [UICardinality]::Unknown

    # Status of the static version of the UMS item. This property is set to
    # Unknown by default but should always be updated by the constructor.
    [UIStaticVersionStatus] $StaticVersion = [UIStaticVersionStatus]::Unknown

    # Validation status of the UMS item. Validation is CPU intensive, and does
    # not occur automatically. This property is set to Unknown by default, and
    # will show this value until validation eventually happens at a later time.
    [UIValidity] $Validity = [UIValidity]::Unknown

    ###########################################################################
    # Constructors
    ###########################################################################

    UmsItem([System.IO.FileInfo] $FileInfo)
    {
        # Main properties
        $this.Extension = $FileInfo.Extension
        $this.RealName = $FileInfo.Name
        $this.Path = $FileInfo.Directory.FullName
        $this.ManagedPath = $FileInfo.Directory.Parent.FullName
        $this.FullName = $FileInfo.FullName
        $this.Uri = (New-Object -Type System.Uri -ArgumentList $this.FullName).AbsoluteUri
        $this.PathUri = (New-Object -Type System.Uri -ArgumentList $this.Path).AbsoluteUri
        $this.LastWriteTime = $FileInfo.LastWriteTime
        $this.Name = $FileInfo.BaseName
        
        # Calling sub-constructor for static information
        $this.constructStaticInformation($FileInfo)

        # Calling sub-constructor for cardinality information
        $this.constructCardinalityInformation($FileInfo)

        # Calling sub-constructor for XML content information
        $this.constructContentInformation($FileInfo)
    }

    # Sub-constructor for static information
    [void] constructStaticInformation([System.IO.FileInfo] $FileInfo)
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
                {  $this.StaticVersion = [UIStaticVersionStatus]::Expired }
            else
                {  $this.StaticVersion = [UIStaticVersionStatus]::Current }
        }
        else
            { $this.StaticVersion = [UIStaticVersionStatus]::Absent }
    }

    # Sub-constructor for cardinality information
    [void] constructCardinalityInformation([System.IO.FileInfo] $FileInfo)
    {
        # If the item is independent
        if ($this.Name.StartsWith([UmsItem]::IndependentFilePrefix))
        {
            [UICardinality] $this.Cardinality = [UICardinality]::Independent
            # Remove prefix from item name
            $this.Name = $this.Name.Substring(([UmsItem]::IndependentFilePrefix).Length)
        }
        # Else, cardinality is orphan or sidecar
        else
        {
            # Update hidden properties
            $this.LinkedFileName = $FileInfo.BaseName
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
    }

    # Sub-constructor for content information
    [void] constructContentInformation([System.IO.FileInfo] $FileInfo)
    {
        # Read XML document
        [xml] $_xmlDocument = Get-Content -Path $this.FullName

        # Get and store XML namespace and document element
        $this.XmlNamespace = $_xmlDocument.DocumentElement.NamespaceURI
        $this.XmlElementName = $_xmlDocument.DocumentElement.LocalName

        # Resolve schema friendly name
        $this.Schema = (Get-UmsConfigurationItem -Type "Schema" | Where-Object { $_.Namespace -eq $this.XmlNamespace }).Id

        # Get and store content binding information (only for sidecar files)
        if ($this.Cardinality -eq [UICardinality]::Sidecar)
        {
            $this.BindingNamespace = $_xmlDocument.binding.FirstChild.NamespaceURI
            $this.BindingElementName = $_xmlDocument.binding.FirstChild.LocalName
            $this.BindingElement = $_xmlDocument.binding.FirstChild.Name
            $this.BindingSchema = (Get-UmsConfigurationItem -Type "Schema" | Where-Object { $_.Namespace -eq $this.BindingNamespace }).Id
        }
    }

    ###########################################################################
    # Helpers
    ###########################################################################

    # String representation
    [string] ToString()
    {
        return $this._name
    } 
}

Enum UIStaticVersionStatus
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

Enum UIValidity
{
    Unknown
    Valid
    Invalid
}