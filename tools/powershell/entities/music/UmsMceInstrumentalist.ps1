###############################################################################
#   Concrete entity class UmsMceInstrumentalist
#==============================================================================
#
#   This class describes a music instrumentalist entity, built from an
#   'instrumentalist' XML element from the UMS music namespace.
#
###############################################################################

class UmsMceInstrumentalist : UmsBaePerson
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
    UmsMceInstrumentalist(
        [System.Xml.XmlElement] $XmlElement,
        [System.Uri] $Uri)
        : base($XmlElement, $Uri)
    {
        # Validate the XML root element
        $this.ValidateXmlElement(
            $XmlElement, [UmsAeEntity]::NamespaceUri.Music, "instrumentalist")
    }

    ###########################################################################
    # Helpers
    ###########################################################################

}