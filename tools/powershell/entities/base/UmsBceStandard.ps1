###############################################################################
#   Concrete entity class UmsBceStandard
#==============================================================================
#
#   This class describes a standard entity, built from an XML 'standard'
#   element from the base namespace.
#
###############################################################################

class UmsBceStandard : UmsBaeStandard
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

    [UmsBceStandard] $ParentStandard

    ###########################################################################
    # Constructors
    ###########################################################################

    # Standard constructor.
    UmsBceStandard([System.Xml.XmlElement] $XmlElement, [System.Uri] $Uri)
        : base($XmlElement, $Uri)
    {
        # Validate the XML root element
        $this.ValidateXmlElement(
            $XmlElement, [UmsAeEntity]::NamespaceUri.Base, "standard")

        # Optional 'parent' element (wrapper of a single 'standard' element)
        if ($XmlElement.parent)
        {
            $this.BuildParentStandard(
                $this.GetOneXmlElement(
                    $XmlElement,
                    [UmsAeEntity]::NamespaceUri.Base,
                    "parent"))     
        }
    }

    # Sub-constructor for the 'parent/standard' element
    [void] BuildParentStandard([System.Xml.XmlElement] $ParentElement)
    {
        $this.ParentStandard = (
            [EntityFactory]::GetEntity(
                $this.GetOneXmlElement(
                    $ParentElement,
                    [UmsAeEntity]::NamespaceUri.Base,
                    "standard"),
                $this.SourcePathUri,
                $this.SourceFileUri))
    }

    ###########################################################################
    # Helpers
    ###########################################################################
}