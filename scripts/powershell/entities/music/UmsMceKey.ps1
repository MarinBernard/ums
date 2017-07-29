###############################################################################
#   Concrete entity class UmsMceKey
#==============================================================================
#
#   This class describes a musical key entity, built from a 'key' XML element
#   from the music namespace.
#
###############################################################################

class UmsMceKey : UmsBaeItem
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
    UmsMceKey([System.Xml.XmlElement] $XmlElement) : base($XmlElement)
    {
        # Validate the XML root element
        $this.ValidateXmlElement(
            $XmlElement, [UmsAeEntity]::NamespaceUri.Music, "key")
    }

    ###########################################################################
    # Helpers
    ###########################################################################

}