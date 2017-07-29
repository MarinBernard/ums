###############################################################################
#   Concrete entity class UmsMceCompletion
#==============================================================================
#
#   This class describes a composition completion event entity, built from an
#   'completion' XML element from the music namespace. This describes the date
#   and place at which the composition of a music work was completed.
#
###############################################################################

class UmsMceCompletion : UmsBaeEvent
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
    UmsMceCompletion([System.Xml.XmlElement] $XmlElement) : base($XmlElement)
    {
        # Validate the XML root element
        $this.ValidateXmlElement(
            $XmlElement, [UmsAeEntity]::NamespaceUri.Music, "completion")
    }

    ###########################################################################
    # Helpers
    ###########################################################################
}