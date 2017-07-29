###############################################################################
#   Concrete entity class UmsMceCatalogIdEntry
#==============================================================================
#
#   This class describes a music catalog id entry entity, built from an
#   'id' XML element from the UMS music namespace.
#
###############################################################################

class UmsMceCatalogIdEntry : UmsAeEntity
{
    ###########################################################################
    # Static properties
    ###########################################################################

    ###########################################################################
    # Hidden properties
    ###########################################################################

    ###########################################################################
    # Visible properties
    ###########################################################################

    # Value of the catalog id entry
    [string] $Value

    # Entry level
    [int] $Level

    # Qualifier
    [UmsMceCatalogIdEntryQualifier] $Qualifier
    
    ###########################################################################
    # Constructors
    ###########################################################################

    # Standard constructor.
    UmsMceCatalogIdEntry(
        [System.Xml.XmlElement] $XmlElement) : base($XmlElement)
    {
        # Validate the XML root element
        $this.ValidateXmlElement(
            $XmlElement, [UmsAeEntity]::NamespaceUri.Music, "id")

        # Build the entry level
        $this.Level = $this.GetOptionalXmlAttributeValue(
            $XmlElement, "level")
        if (-not ($this.Level)){ $this.Level = 1 }

        # Build the qualifier of the catalog id entry
        switch ($this.GetOptionalXmlAttributeValue($XmlElement, "qualifier"))
        {
            ""
                { $this.Qualifier = [UmsMceCatalogIdEntryQualifier]::None }
            "none"
                { $this.Qualifier = [UmsMceCatalogIdEntryQualifier]::None }
            "numero"
                { $this.Qualifier = [UmsMceCatalogIdEntryQualifier]::Numero }
            Default
            {
                throw [IllegalXmlAttributeValueException]::New(
                    $XmlElement.NamespaceUri,
                    $XmlElement.LocalName,
                    "qualifier",
                    $_,
                    @("none", "numero"))
            }
        }
        
        # Main value
        $this.Value = $XmlElement.'#text'
    }

    ###########################################################################
    # Helpers
    ###########################################################################

    # String representation
    [string] ToString()
    {
        $_string = ""

        if ($this.Qualifier -eq [UmsMceCatalogIdEntryQualifier]::Numero )
        {
            # TODO: use localized variants of the numero sign
            $_string += "n°"
            $_string += [UmsAeEntity]::NonBreakingSpace
        }

        $_string += $this.Value

        return $_string
    }
}

###############################################################################
#
#   Enum types used by UmsMceCatalogIdEntry and its children
#
###############################################################################

Enum UmsMceCatalogIdEntryQualifier
{
    None
    Numero
}