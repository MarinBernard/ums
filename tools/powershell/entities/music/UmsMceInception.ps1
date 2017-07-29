###############################################################################
#   Concrete entity class UmsMceInception
#==============================================================================
#
#   This class describes a composition inception event entity, built from an
#   'inception' XML element from the music namespace. This describes the date
#   and place at which the composition of a music work began.
#
###############################################################################

class UmsMceInception : UmsBaeEvent
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
    UmsMceInception([System.Xml.XmlElement] $XmlElement) : base($XmlElement)
    {
        # Validate the XML root element
        $this.ValidateXmlElement(
            $XmlElement, [UmsAeEntity]::NamespaceUri.Music, "inception")
    }

    ###########################################################################
    # Helpers
    ###########################################################################

}