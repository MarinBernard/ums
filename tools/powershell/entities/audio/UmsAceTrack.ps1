###############################################################################
#   Concrete entity class UmsAceTrack
#==============================================================================
#
#   This class describes an audio track entity, built from a 'track' XML
#   element from the audio namespace.
#
###############################################################################

class UmsAceTrack : UmsBaeProduct
{
    ###########################################################################
    # Static properties
    ###########################################################################

    ###########################################################################
    # Hidden properties
    ###########################################################################
    
    hidden [string] $PerformanceRef         # The uid of the target performance
    hidden [string] $SectionRef             # The uid of the target section

    ###########################################################################
    # Visible properties
    ###########################################################################

    [int]   $Number

    ###########################################################################
    # Constructors
    ###########################################################################

    # Standard constructor.
    UmsAceTrack([System.Xml.XmlElement] $XmlElement, [System.Uri] $Uri)
        : base($XmlElement, $Uri)
    {
        # Verbose prefix
        $_verbosePrefix = "[UmsAceTrack]::UmsAceTrack(): "

        # Validate the XML root element
        $this.ValidateXmlElement(
            $XmlElement, [UmsAeEntity]::NamespaceUri.Audio, "track")

        # Attributes
        $this.Number = $this.GetMandatoryXmlAttributeValue(
            $XmlElement, "number")
        $this.PerformanceRef = $this.GetMandatoryXmlAttributeValue(
            $XmlElement, "performance")
        $this.SectionRef = $this.GetMandatoryXmlAttributeValue(
            $XmlElement, "section")
    }

    ###########################################################################
    # Helpers
    ###########################################################################

}