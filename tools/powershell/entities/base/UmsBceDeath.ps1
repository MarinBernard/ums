###############################################################################
#   Concrete entity class UmsBceDeath
#==============================================================================
#
#   This class describes a death event entity, built from an XML 'death'
#   element from the base namespace.
#
###############################################################################

class UmsBceDeath : UmsBaeEvent
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
    UmsBceDeath([System.Xml.XmlElement] $XmlElement, [System.Uri] $Uri)
        : base($XmlElement, $Uri)
    {
        # Validate the XML root element
        $this.ValidateXmlElement(
            $XmlElement, [UmsAeEntity]::NamespaceUri.Base, "death")
    }

    ###########################################################################
    # Helpers
    ###########################################################################

}