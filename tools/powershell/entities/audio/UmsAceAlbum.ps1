###############################################################################
#   Concrete entity class UmsAceAlbum
#==============================================================================
#
#   This class describes an audio album entity, built from an 'album' XML
#   element from the audio namespace.
#
###############################################################################

class UmsAceAlbum : UmsBaePublication
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

    [UmsAceLabel[]]         $Labels
    [UmsAceMedium[]]        $Media

    # Views
    [UmsMcePerformance[]]   $Performances

    ###########################################################################
    # Constructors
    ###########################################################################

    # Standard constructor.
    UmsAceAlbum([System.Xml.XmlElement] $XmlElement, [System.Uri] $Uri)
        : base($XmlElement, $Uri)
    {
        # Verbose prefix
        $_verbosePrefix = "[UmsAceAlbum]::UmsAceAlbum(): "

        # Validate the XML root element
        $this.ValidateXmlElement(
            $XmlElement, [UmsAeEntity]::NamespaceUri.Audio, "album")
        
        # Mandatory 'labels' element (collection of 'label' elements)
        $this.BuildLabels(
            $this.GetOneXmlElement(
                $XmlElement,
                [UmsAeEntity]::NamespaceUri.Audio,
                "labels"))

        # Mandatory 'media' element (collection of 'medium' elements)
        $this.BuildMedia(
            $this.GetOneXmlElement(
                $XmlElement,
                [UmsAeEntity]::NamespaceUri.Audio,
                "media"))

        # Update views
        $this.UpdatePerformances()
    }

    # Sub-constructor for the 'labels' element
    [void] BuildLabels([System.Xml.XmlElement] $LabelsElement)
    {
        # Verbose prefix
        $_verbosePrefix = "[UmsAceAlbum]::BuildLabels(): "

        $this.GetOneOrManyXmlElement(
            $LabelsElement,
            [UmsAeEntity]::NamespaceUri.Audio,
            "label"
        ) | foreach {
                $this.Labels += [EntityFactory]::GetEntity(
                    $_, $this.SourcePathUri, $this.SourceFileUri) }
    }

    # Sub-constructor for the 'media' element
    [void] BuildMedia([System.Xml.XmlElement] $MediaElement)
    {
        $this.GetOneOrManyXmlElement(
            $MediaElement,
            [UmsAeEntity]::NamespaceUri.Audio,
            "medium"
        ) | foreach {
                $this.Media += [EntityFactory]::GetEntity(
                    $_, $this.SourcePathUri, $this.SourceFileUri) }
    }

    ###########################################################################
    # Query helpers
    ###########################################################################

    # Returns the UmsAceMedium instance matching both medium number and side.
    [UmsAceMedium] GetAlbumMedium([int] $MediumNumber, [int] $MediumSide)
    {
        return $this.Media | Where-Object {
            ($_.Number -eq $MediumNumber) -and ($_.Side -eq $MediumSide) }
    }

    # Returns the UmsAceMedium instance matching a medium number.
    [UmsAceMedium] GetAlbumMedium([int] $MediumNumber)
    {
        return $this.GetAlbumMedium($MediumNumber, 0)
    }

    # Returns a UmsBaeTrack instance (either UmsMaeTrack or, one day maybe, a
    # UmsAceTrack instance) matching the supplied medium number, medium side,
    # and track number.
    [UmsBaeTrack] GetAlbumTrack(
        [int] $MediumNumber, [int] $MediumSide, [int] $TrackNumber)
    {
        $_medium = $this.GetAlbumMedium($MediumNumber, $MediumSide)
        return $_medium.Tracks | Where-Object { $_.Number -eq $TrackNumber }
    }

    # Returns a UmsBaeTrack instance (either UmsMaeTrack or, one day maybe, a
    # UmsAceTrack instance) matching the supplied medium and track numbers.
    [UmsBaeTrack] GetAlbumTrack([int] $MediumNumber, [int] $TrackNumber)
    {
        return $this.GetAlbumTrack($MediumNumber, 0, $TrackNumber)
    }  

    ###########################################################################
    # Helpers
    ###########################################################################

    # Update the Performances view
    [void] UpdatePerformances()
    {
        [UmsMcePerformance[]] $_performances = $null

        foreach ($_medium in $this.Media)
        {
            foreach ($_track in $_medium.Tracks)
            {
                $_performances += $_track.Performance
            }
        }

        $this.Performances = $_performances | Sort-Object -Unique
    }
}