###############################################################################
#   Concrete entity class UmsAceAlbum
#==============================================================================
#
#   This class describes an audio album entity, built from an 'album' XML
#   element from the audio namespace.
#
###############################################################################

class UmsAceAlbum : UmsBaeProduct
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
    [UmsBcePublication[]]   $Publications
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
        
        # Optional 'publications' element (collection of 'publication' elements)
        if ($XmlElement.publications)
        {
            $this.BuildPublications(
                $this.GetOneXmlElement(
                    $XmlElement,
                    [UmsAeEntity]::NamespaceUri.Base,
                    "publications"))
        }

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

    # Sub-constructor for the 'publications' element
    [void] BuildPublications([System.Xml.XmlElement] $PublicationsElement)
    {
        $this.GetOneOrManyXmlElement(
            $PublicationsElement,
            [UmsAeEntity]::NamespaceUri.Base,
            "publication"
        ) | foreach {
                $this.Publications += [EntityFactory]::GetEntity(
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