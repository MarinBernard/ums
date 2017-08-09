###############################################################################
#   Concrete entity class UmsBceCountry
#==============================================================================
#
#   This class describes a country entity, built from an XML 'country'
#   element from the base namespace.
#
###############################################################################

class UmsBceCountry : UmsBaeItem
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
    UmsBceCountry([System.Xml.XmlElement] $XmlElement, [System.Uri] $Uri)
        : base($XmlElement, $Uri)
    {
        # Validate the XML root element
        $this.ValidateXmlElement(
            $XmlElement, [UmsAeEntity]::NamespaceUri.Base, "country")
    }

    ###########################################################################
    # Helpers
    ###########################################################################

}