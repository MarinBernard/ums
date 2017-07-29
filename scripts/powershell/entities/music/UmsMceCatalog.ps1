###############################################################################
#   Concrete entity class UmsMceCatalog
#==============================================================================
#
#   This class describes a music catalog entity, built from an 'catalog'
#   XML element from the music namespace.
#
###############################################################################

class UmsMceCatalog : UmsBaeItem
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

    ###########################################################################
    # Constructors
    ###########################################################################

    # Standard constructor.
    UmsMceCatalog([System.Xml.XmlElement] $XmlElement) : base($XmlElement)
    {
        # Validate the XML root element
        $this.ValidateXmlElement(
            $XmlElement, [UmsAeEntity]::NamespaceUri.Music, "catalog")
    }

    ###########################################################################
    # Helpers
    ###########################################################################

    # String representation uses the short label if it is available.
    [string] ToString()
    {
        # Short label
        if ($this.Label.ShortLabel)
            { return $this.Label.ShortLabel }
        
        # Default string representation for items
        else
            { return ([UmsBaeItem] $this).ToString() }
    }
}