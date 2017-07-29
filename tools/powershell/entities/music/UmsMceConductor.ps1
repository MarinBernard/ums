###############################################################################
#   Concrete entity class UmsMceConductor
#==============================================================================
#
#   This class describes a music conductor entity, built from a 'conductor'
#   XML element from the UMS music namespace.
#
###############################################################################

class UmsMceConductor : UmsBaePerson
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
    UmsMceConductor([System.Xml.XmlElement] $XmlElement) : base($XmlElement)
    {
        # Validate the XML root element
        $this.ValidateXmlElement(
            $XmlElement, [UmsAeEntity]::NamespaceUri.Music, "conductor")
    }

    ###########################################################################
    # Helpers
    ###########################################################################

}