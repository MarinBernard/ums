###############################################################################
#   Concrete entity class UmsBcePublication
#==============================================================================
#
#   This class describes a music publication entity, built from a 'publication'
#   XML element from the vase namespace. This entity describes a generic
#   publication event.
#
###############################################################################

class UmsBcePublication : UmsBaeEvent
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
    UmsBcePublication([System.Xml.XmlElement] $XmlElement, [System.Uri] $Uri)
        : base($XmlElement, $Uri)
    {
        # Validate the XML root element
        $this.ValidateXmlElement(
            $XmlElement, [UmsAeEntity]::NamespaceUri.Base, "publication")
    }

    ###########################################################################
    # Helpers
    ###########################################################################
}