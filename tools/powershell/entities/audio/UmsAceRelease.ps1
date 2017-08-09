###############################################################################
#   Concrete entity class UmsAceRelease
#==============================================================================
#
#   This class describes an album release event entity, built from a
#   'release' XML element from the audio namespace. This describes the date
#   and place at which an audio album was released.
#
###############################################################################

class UmsAceRelease : UmsBaeEvent
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
    UmsAceRelease([System.Xml.XmlElement] $XmlElement, [System.Uri] $Uri)
        : base($XmlElement, $Uri)
    {
        # Validate the XML root element
        $this.ValidateXmlElement(
            $XmlElement, [UmsAeEntity]::NamespaceUri.Audio, "release")
    }

    ###########################################################################
    # Helpers
    ###########################################################################

}