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
    [UmsMcePerformance[]]   $Performances
    [UmsBcePublication[]]   $Publications
    [UmsAceMedium[]]        $Media

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

        # Mandatory 'performances' element (collection of 'performance' elements)
        $this.BuildPerformances(
            $this.GetOneXmlElement(
                $XmlElement,
                [UmsAeEntity]::NamespaceUri.Music,
                "performances"))
        
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

    # Sub-constructor for the 'performances' element
    [void] BuildPerformances([System.Xml.XmlElement] $PerformancesElement)
    {
        $this.GetOneOrManyXmlElement(
            $PerformancesElement,
            [UmsAeEntity]::NamespaceUri.Music,
            "performance"
        ) | foreach {
                $this.Performances += [EntityFactory]::GetEntity(
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
}