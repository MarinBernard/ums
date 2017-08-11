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

    # Whether the numbering of the section will be shown when it is rendered
    # as a string.
    static [bool] $ShowSectionNumber = 
    (Get-UmsConfigurationItem -ShortName "ShowSectionNumber") 

    # One or several characters which will be inserted between the section
    # number and the section title.
    static [string] $SectionNumberingDelimiter = 
    (Get-UmsConfigurationItem -ShortName "SectionNumberingDelimiter")

    # One or several characters which will be inserted between each section
    # level when the section hierarchy is rendered as a string.
    static [string] $SectionListDelimiter = 
    (Get-UmsConfigurationItem -ShortName "SectionListDelimiter") 

    # Whether the title of the section will be shown when rendered as a string.
    static [bool] $ShowSectionTitle = 
    (Get-UmsConfigurationItem -ShortName "ShowSectionTitle") 

    ###########################################################################
    # Hidden properties
    ###########################################################################

    # Parent section of the section
    hidden [UmsMceSection] $ParentSection

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
            $_section = [EntityFactory]::GetEntity(
                $_, $this.SourcePathUri, $this.SourceFileUri)
            $_section.UpdateParentSection($this)
            $this.Sections += $_section
        }
    }

    # Sub-constructor for the 'movements' element
    [void] BuildMovements([System.Xml.XmlElement] $MovementsElement)
    {
        $this.GetOneOrManyXmlElement(
            $MovementsElement,
            [UmsAeEntity]::NamespaceUri.Music,
            "movement"
        ) | foreach {
            $_movement = [EntityFactory]::GetEntity(
                $_, $this.SourcePathUri, $this.SourceFileUri)
            $_movement.UpdateParentSection($this)
            $this.Movements += $_movement
        }
    }   

    ###########################################################################
    # Helpers
    ###########################################################################

    # Updates the parent section after the instance was constructed.
    [void] UpdateParentSection([UmsMceSection] $ParentSection)
    {
        if ($this.ParentSection -eq $null)
        {
            $this.ParentSection  = $ParentSection
        }
    }

    # Returns a list of movements from a section path.
    [UmsMceMovement[]] GetMovementFromSPath([string[]] $Segments)
    {
        # Initialize return collection
        [UmsMceMovement[]] $_movements = @()

        # Split the SPath expression into segments.
        $_firstSegment = $Segments[0]
        $_remainingSegments = $Segments[1..$Segments.Length]

        # Enumerate subsections
        foreach ($_section in $this.Sections)
        {
            # If the Id of the current section matches the first level of the
            # path, or if there is no filter segment left, let's ask the
            # subsection to perform a recursive search.
            if (
                ($_section.Id -eq $_firstSegment) -or
                ($Segments.Count -eq 0))
            {
                $_movements += (
                    $_section.GetMovementFromSPath($_remainingSegments))
            }
        }

        # If there is no filter segment left, let's add the movements of
        # the current section.
        if ($Segments.Count -eq 0) { $_movements += $this.Movements }

        return $_movements
    }

    # Renders the section as a string including data inherited from parent
    # sections.
    [string] ToFullString()
    {
        $_string = ""

        # Include parent sections, if any
        if ($this.ParentSection)
        {
            $_string += $this.ParentSection.ToString()
            # Delimiter is shown only if section titles are enabled
            if ([UmsMceSection]::ShowSectionTitle)
                { $_string += ([UmsMceSection]::SectionListDelimiter) }
        }

        $_string += $this.ToString()

        return $_string
    }

    # Renders the section as a string.
    [string] ToString()
    {
        $_string = ""
        $_addSpace = $false

        # Add section numbering, if enabled
        if ([UmsMceSection]::ShowSectionNumber)
        {
            # Include numbering of the current section.
            $_string += $this.Numbering
            $_string += ([UmsMceSection]::SectionNumberingDelimiter)
            $_addSpace = $true
        }

        # Add section title, if enabled
        $_title = ([UmsBaeProduct] $this).ToString()
        if (([UmsMceSection]::ShowSectionTitle) -and ($_title))
        {
            if ($_addSpace) { $_string += ([UmsAeEntity]::NonBreakingSpace) }
            $_string += $_title
            $_addSpace = $true        
        }

        return $_string
    }
}