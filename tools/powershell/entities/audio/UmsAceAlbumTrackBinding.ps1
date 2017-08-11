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

    [int] $MediumNumber
    [int] $MediumSide
    [int] $TrackNumber
    [UmsAceAlbum] $Album

    # Views
    [UmsBaeTrack] $Track

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
        $this.MediumNumber = $this.GetMandatoryXmlAttributeValue(
            $XmlElement, "medium")
        $this.MediumSide = $this.GetOptionalXmlAttributeValue(
            $XmlElement, "side")
        $this.TrackNumber = $this.GetMandatoryXmlAttributeValue(
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

        # Bound album track
        $this.Track = $this.Album.GetAlbumTrack(
            $this.MediumNumber,
            $this.MediumSide,
            $this.TrackNumber)
    }

    ###########################################################################
    # Helpers
    ###########################################################################
}