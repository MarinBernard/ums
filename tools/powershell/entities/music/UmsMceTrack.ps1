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
    
    hidden [string] $SPath          # An SPath expression to the target section

    ###########################################################################
    # Visible properties
    ###########################################################################

    [UmsMcePerformance] $Performance

    # Views
    [UmsMceMovement[]]  $Movements

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
        $this.SPath = $this.GetMandatoryXmlAttributeValue(
            $XmlElement, "section")

        # Mandatory 'performance' instance
        $this.Performance = [EntityFactory]::GetEntity(
            $this.GetOneXmlElement(
                $XmlElement, [UmsAeEntity]::NamespaceUri.Music, "performance"),
            $this.SourcePathUri,
            $this.SourceFileUri)

        # Update movement list
        $this.Movements = $this.Performance.GetMovementFromSPath($this.SPath)
    }

    ###########################################################################
    # Helpers
    ###########################################################################

}