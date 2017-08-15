###############################################################################
#   Class UmsItem
#==============================================================================
#
#   This class describes an unmanaged UMS document.
#
###############################################################################

class UmsItem
{
    ###########################################################################
    # Static properties
    ###########################################################################

    ###########################################################################
    # Hidden properties
    ###########################################################################

    # Properties describing the item itself
    hidden [string] $Extension          # Extension of the UMS doc
    hidden [string] $FullName           # Fully qualified name of the UMS doc
    hidden [string] $RealName           # Real name of the UMS doc on the FS
    hidden [string] $Path               # Fully qualified path of the UMS doc
    hidden [string] $Uri                # Absolute URI to $FullName
    hidden [string] $PathUri            # Absolute URI to $Path
    hidden [string] $LastWriteTime      # Last write time of the UMS doc
    hidden [string] $ManagedPath        # Fully qualified path of the folder
                                        # containing linked files

    # Properties describing the XML content of the UMS document
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

        # Calling sub-constructor for XML content information
        $this.UpdateContentInfo()     
    }

    # Sub-constructor for content information
    [void] UpdateContentInfo()
    {
        # Read XML document
        [xml] $_xmlDocument = Get-Content -Path $this.FullName

        # Get and store XML namespace and document element
        $this.XmlNamespace = $_xmlDocument.DocumentElement.NamespaceURI
        $this.XmlElementName = $_xmlDocument.DocumentElement.LocalName

        # Set default value for schema and element visible properties.
        # These values shall be replaced with the values from the binding
        # element if the Item has a Sidecar/Orphan cardinality.
        $this.Schema = (
            Get-UmsConfigurationItem -Type "Schema" | Where-Object {
                $_.Namespace -eq $this.XmlNamespace }).Id
        $this.Element = $this.XmlElementName

        # Get and store content binding information (only for binding files)
        $_baseNamespace = (
            Get-UmsConfigurationItem -ShortName "BaseSchemaNamespace")
        
        # If the document element is umsb:file, we need to retrieve and
        # store binding information.
        if (
            ($this.XmlNamespace   -eq $_baseNamespace) -and 
            ($this.XmlElementName -eq "file"))
        {
            $this.BindingNamespace = (
                $_xmlDocument.DocumentElement.FirstChild.NamespaceURI)
            $this.BindingElementName = (
                $_xmlDocument.DocumentElement.FirstChild.LocalName)
            $this.BindingSchema = (
                Get-UmsConfigurationItem -Type "Schema" | Where-Object {
                    $_.Namespace -eq $this.BindingNamespace }).Id

            # Set schema and element visible properties to those of the binding
            $this.Schema = $this.BindingSchema
            $this.Element = $this.BindingElementName
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

Enum UIValidity
{
    Unknown
    Valid
    Invalid
}