###############################################################################
#   Concrete entity class UmsMceSection
#==============================================================================
#
#   This class describes a music section entity, built from an 'section' XML
#   element from the music namespace. A section entity describes a section from
#   a musical work, which is a grouping of one or several movements.
#
###############################################################################

class UmsMceSection : UmsBaeProduct
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

    # Unique identifier of the section
    [string] $Id

    # Numbering of the section
    [string] $Numbering

    # Subsections of the section
    [UmsMceSection[]] $Sections

    # Movements of the section
    [UmsMceMovement[]] $Movements

    ###########################################################################
    # Constructors
    ###########################################################################

    # Standard constructor.
    UmsMceSection([System.Xml.XmlElement] $XmlElement, [System.Uri] $Uri)
        : base($XmlElement, $Uri)
    {
        # Validate the XML root element
        $this.ValidateXmlElement(
            $XmlElement, [UmsAeEntity]::NamespaceUri.Music, "section")

        # Mandatory attributes
        $this.Id = $this.GetMandatoryXmlAttributeValue(
            $XmlElement, "id")        
        $this.Numbering = $this.GetMandatoryXmlAttributeValue(
            $XmlElement, "numbering")
        
        # Optional 'sections' element (collection of 'section' elements)
        if ($XmlElement.sections)
        {
            $this.BuildSections(
                $this.GetOneXmlElement(
                    $XmlElement,
                    [UmsAeEntity]::NamespaceUri.Music,
                    "sections"))
        }

        # Optional 'movements' element (collection of 'movement' elements)
        elseif ($XmlElement.movements)
        {
            $this.BuildMovements(
                $this.GetOneXmlElement(
                    $XmlElement,
                    [UmsAeEntity]::NamespaceUri.Music,
                    "movements"))
        }
    }

    # Sub-constructor for the 'sections' element
    [void] BuildSections([System.Xml.XmlElement] $SectionsElement)
    {
        $this.GetOneOrManyXmlElement(
            $SectionsElement,
            [UmsAeEntity]::NamespaceUri.Music,
            "section"
        ) | foreach {
                $this.Sections += [EntityFactory]::GetEntity(
                    $_, $this.SourcePathUri, $this.SourceFileUri) }
    }

    # Sub-constructor for the 'movements' element
    [void] BuildMovements([System.Xml.XmlElement] $MovementsElement)
    {
        $this.GetOneOrManyXmlElement(
            $MovementsElement,
            [UmsAeEntity]::NamespaceUri.Music,
            "movement"
        ) | foreach {
                $this.Movements += [EntityFactory]::GetEntity(
                    $_, $this.SourcePathUri, $this.SourceFileUri) }
    }   

    ###########################################################################
    # Helpers
    ###########################################################################
}