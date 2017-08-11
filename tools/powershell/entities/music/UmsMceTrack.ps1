###############################################################################
#   Concrete entity class UmsMceTrack
#==============================================================================
#
#   This class describes a music track entity, built from a 'track' XML
#   element from the music namespace.
#
###############################################################################

class UmsMceTrack : UmsBaeTrack
{
    ###########################################################################
    # Static properties
    ###########################################################################

    ###########################################################################
    # Hidden properties
    ###########################################################################
    
    hidden [string] $SectionRef             # The uid of the target section

    ###########################################################################
    # Visible properties
    ###########################################################################

    [UmsMcePerformance] $Performance

    ###########################################################################
    # Constructors
    ###########################################################################

    # Standard constructor.
    UmsMceTrack([System.Xml.XmlElement] $XmlElement, [System.Uri] $Uri)
        : base($XmlElement, $Uri)
    {
        # Verbose prefix
        $_verbosePrefix = "[UmsMceTrack]::UmsMceTrack(): "

        # Validate the XML root element
        $this.ValidateXmlElement(
            $XmlElement, [UmsAeEntity]::NamespaceUri.Music, "track")

        # Attributes specific to music tracks
        $this.SectionRef = $this.GetMandatoryXmlAttributeValue(
            $XmlElement, "section")

        # Mandatory 'performance' instance
        $this.Performance = [EntityFactory]::GetEntity(
            $this.GetOneXmlElement(
                $XmlElement, [UmsAeEntity]::NamespaceUri.Music, "performance"),
            $this.SourcePathUri,
            $this.SourceFileUri)
    }

    ###########################################################################
    # Helpers
    ###########################################################################
}