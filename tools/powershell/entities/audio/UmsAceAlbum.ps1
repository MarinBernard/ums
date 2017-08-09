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
    [UmsAceRelease[]]       $Releases 

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
        
        # Optional 'releases' element (collection of 'release' elements)
        if ($XmlElement.releases)
        {
            $this.BuildReleases(
                $this.GetOneXmlElement(
                    $XmlElement,
                    [UmsAeEntity]::NamespaceUri.Audio,
                    "releases"))
        }
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

    # Sub-constructor for the 'releases' element
    [void] BuildReleases([System.Xml.XmlElement] $ReleasesElement)
    {
        $this.GetOneOrManyXmlElement(
            $ReleasesElement,
            [UmsAeEntity]::NamespaceUri.Audio,
            "release"
        ) | foreach {
                $this.Releases += [EntityFactory]::GetEntity(
                    $_, $this.SourcePathUri, $this.SourceFileUri) }
    }

    ###########################################################################
    # Helpers
    ###########################################################################
}