###############################################################################
#   Concrete entity class UmsMceComposer
#==============================================================================
#
#   This class describes a music composer entity, built from an XML 'composer'
#   element from the UMS music namespace.
#
###############################################################################

class UmsMceComposer : UmsBaePerson
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
    UmsMceComposer([System.Xml.XmlElement] $XmlElement, [System.Uri] $Uri)
        : base($XmlElement, $Uri)
    {
        # Validate the XML root element
        $this.ValidateXmlElement(
            $XmlElement, [UmsAeEntity]::NamespaceUri.Music, "composer")
    }

    ###########################################################################
    # Helpers
    ###########################################################################

}