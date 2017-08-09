###############################################################################
#   Concrete entity class UmsBceStandardId
#==============================================================================
#
#   This class describes a standard id entity, built from an XML 'standardId'
#   element from the base namespace.
#
###############################################################################

class UmsBceStandardId : UmsAeEntity
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

    # Imported raw
    [string] $StandardName
    [string] $Id

    ###########################################################################
    # Constructors
    ###########################################################################

    # Standard constructor.
    UmsBceStandardId([System.Xml.XmlElement] $XmlElement, [System.Uri] $Uri)
        : base($XmlElement, $Uri)
    {
        # Validate the XML root element
        $this.ValidateXmlElement(
            $XmlElement, [UmsAeEntity]::NamespaceUri.Base, "standardId")

        # Attributes
        $this.StandardName = $this.GetMandatoryXmlAttributeValue(
            $XmlElement, "standard")
        
        # Text value
        $this.Id = $XmlElement.'#text'
    }

    ###########################################################################
    # Helpers
    ###########################################################################
    
    # String representation
    [string] ToString()
    {
        return $this.StandardName
    }
}