###############################################################################
#   Concrete entity class UmsAceAlbumTrackBinding
#==============================================================================
#
#   This class describes an album track binding, built from an
#   'albumTrackBinding' XML element from the audio namespace.
#
###############################################################################

class UmsAceAlbumTrackBinding : UmsAeEntity
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

    [int] $Medium
    [int] $Side = 1
    [int] $Track

    [UmsAceAlbum] $Album

    ###########################################################################
    # Constructors
    ###########################################################################

    # Standard constructor.
    UmsAceAlbumTrackBinding([System.Xml.XmlElement] $XmlElement, [System.Uri] $Uri)
        : base($XmlElement, $Uri)
    {
        # Validate the XML root element
        $this.ValidateXmlElement(
            $XmlElement, [UmsAeEntity]::NamespaceUri.Audio, "albumTrackBinding")

        # Attributes
        $this.Medium = $this.GetMandatoryXmlAttributeValue(
            $XmlElement, "medium")
        $this.Side = $this.GetOptionalXmlAttributeValue(
            $XmlElement, "side")
        $this.Track = $this.GetMandatoryXmlAttributeValue(
            $XmlElement, "track")

        # Mandatory 'album' element
        $this.Album = (
            [EntityFactory]::GetEntity(
                $this.GetOneXmlElement(
                    $XmlElement,
                    [UmsAeEntity]::NamespaceUri.Audio,
                    "album"),
                $this.SourcePathUri,
                $this.SourceFileUri))
    }

    ###########################################################################
    # Helpers
    ###########################################################################
}