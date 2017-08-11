###############################################################################
#   Concrete entity class UmsMcePerformance
#==============================================================================
#
#   This class describes a music performance event entity, built from an
#   'performance' XML element from the music namespace. This describes the date
#   and place at which a performance of a music work took place. This entity
#   also includes a reference to an instance of UmsMceWork describing the
#   performed work.
#   This entity inherits the UmsMaeEvent class rather that the UmsBaeEvent
#   class. This means it supports specifying a musical venue as an event place.
#
###############################################################################

class UmsMcePerformance : UmsMaeEvent
{
    ###########################################################################
    # Static properties
    ###########################################################################

    # One or several characters which will be inserted between each name
    # in a list of music performers.
    static [string] $PerformerDelimiter = 
        (Get-UmsConfigurationItem -ShortName "PerformerDelimiter")
    
    # One or several characters which will be inserted before a list of
    # music performers.
    static [string] $PerformerListPrefix = 
        (Get-UmsConfigurationItem -ShortName "PerformerListPrefix")

    # One or several characters which will be inserted after a list of
    # music performers.
    static [string] $PerformerListSuffix = 
        (Get-UmsConfigurationItem -ShortName "PerformerListSuffix")

    # One or several characters which will be inserted before a the year of a
    # music performance.
    static [string] $PerformanceYearPrefix = 
        (Get-UmsConfigurationItem -ShortName "PerformanceYearPrefix")

    ###########################################################################
    # Hidden properties
    ###########################################################################

    ###########################################################################
    # Visible properties
    ###########################################################################

    [UmsMceWork] $Work
    [UmsMceEnsemble[]] $Ensembles
    [UmsMceInstrumentalist[]] $Instrumentalists
    [UmsMceConductor[]] $Conductors

    ###########################################################################
    # Constructors
    ###########################################################################

    # Standard constructor.
    UmsMcePerformance([System.Xml.XmlElement] $XmlElement, [System.Uri] $Uri)
        : base($XmlElement, $Uri)
    {
        # Validate the XML root element
        $this.ValidateXmlElement(
            $XmlElement, [UmsAeEntity]::NamespaceUri.Music, "performance")
        
        # Mandatory 'work' element
        $this.Work = (
            [EntityFactory]::GetEntity(
                $this.GetOneXmlElement(
                    $XmlElement,
                    [UmsAeEntity]::NamespaceUri.Music,
                    "work"),
                $this.SourcePathUri,
                $this.SourceFileUri))
        
        # Mandatory 'performers' element (collection of 'performer' elements)
        $this.BuildPerformers(
            $this.GetOneXmlElement(
                $XmlElement,
                [UmsAeEntity]::NamespaceUri.Music,
                "performers"))
    
        # Optional 'conductors' element
        if ($XmlElement.conductors)
        {
            $this.BuildConductors(
                $this.GetOneXmlElement(
                    $XmlElement,
                    [UmsAeEntity]::NamespaceUri.Music,
                    "conductors"))
        }
    }

    # Sub-constructor for the 'performers' element
    [void] BuildPerformers([System.Xml.XmlElement] $PerformersElement)
    {
        # Enumerate performers
        foreach ($_performerElement in (
            $this.GetOneOrManyXmlElement(
                $PerformersElement,
                [UmsAeEntity]::NamespaceUri.Music,
                "performer")))
        {            
            # If an instrumentalist is specified
            if ($_performerElement.instrumentalist)
            {
                # Retrieve the instrument of the instrumentalist
                $_element = $this.GetOneXmlElement(
                    $_performerElement,
                    [UmsAeEntity]::NamespaceUri.Music,
                    "instrument")

                $_instrument = (
                    [EntityFactory]::GetEntity(
                        $_element,
                        $this.SourcePathUri,
                        $this.SourceFileUri))

                # Instantiate the instrumentalist
                $_element = $this.GetOneXmlElement(
                    $_performerElement,
                    [UmsAeEntity]::NamespaceUri.Music,
                    "instrumentalist")
                
                $_instrumentalist = (
                    [EntityFactory]::GetEntity(
                        $_element,
                        $this.SourcePathUri,
                        $this.SourceFileUri))

                # Register the instrument
                $_instrumentalist.RegisterInstrument($_instrument)

                # Register the instrumentalist
                $this.Instrumentalists += $_instrumentalist
            }

            # If the performer is not an instrumentalist, it has to be
            # a musical ensemble.
            else
            {
                $this.GetOneXmlElement(
                    $_performerElement,
                    [UmsAeEntity]::NamespaceUri.Music,
                    "ensemble"
                ) | foreach {
                        $this.Ensembles += [EntityFactory]::GetEntity(
                        $_, $this.SourcePathUri, $this.SourceFileUri) }
            }
        }
    }

    # Sub-constructor for the 'conductors' element
    [void] BuildConductors([System.Xml.XmlElement] $ConductorsElement)
    {
        $this.GetOneOrManyXmlElement(
            $ConductorsElement,
            [UmsAeEntity]::NamespaceUri.Music,
            "conductor"
        ) | foreach {
                $this.Conductors += [EntityFactory]::GetEntity(
                    $_, $this.SourcePathUri, $this.SourceFileUri) }
    }
    
    ###########################################################################
    # Helpers
    ###########################################################################

    # Returns a list of movements from a section path.
    [UmsMceMovement[]] GetMovementFromSPath([string] $SPath)
    {
        # Initialize return collection
        [UmsMceMovement[]] $_movements = @()

        # Split the SPath expression into segments.
        $_segments = $SPath.Split("/")
        $_firstSegment = $_segments[0]
        $_remainingSegments = $_segments[1..$_segments.Length]

        foreach ($_section in $this.Work.Sections)
        {
            # If the Id current section matches the first level of the path,
            # or if the SPath expression was empty (empty first segment),
            # let's ask the current section to perform a recursive search.
            if (
                ($_section.Id -eq $_firstSegment) -or
                (-not $_firstSegment))
            {
                $_movements += (
                    $_section.GetMovementFromSPath($_remainingSegments))
            }
        }

        return $_movements
    }

    # Performance to string
    [string] ToString()
    {
        $_string = ""

        # Add work title to the buffer
        $_string += $this.Work.ToString()
        $_string += ([UmsAeEntity]::NonBreakingSpace)

        # Begin performer list
        $_performers = @()
        $_string += ([UmsMcePerformance]::PerformerListPrefix)

        # Add ensembles to the performer list
        # Get an array of ensemble short names
        foreach ($_ensemble in $this.Ensembles)
        {
            if ($_ensemble.Label.ShortLabel)
                { $_performers += $_ensemble.Label.ShortLabel }
            else
                { $_performers += $_ensemble.Label.FullLabel }
        }

        # Add conductors to the performer list
        # Get an array of conductor short names
        foreach ($_conductor in $this.Conductors)
        {
            if ($_conductor.Name.ShortName)
                { $_performers += $_conductor.Name.ShortName }
            else
                { $_performers += $_conductor.Name.FullName }
        }

        # Add performer names to the buffer
        $_string += ($_performers -join(
            [UmsMcePerformance]::PerformerDelimiter))

        # Include performance year
        if($this.Date)
        {
            $_string += ([UmsMcePerformance]::PerformanceYearPrefix)
            $_string += (Get-Date -Date $this.Date -Format "yyyy")
        }

        # End performer list
        $_string += ([UmsMcePerformance]::PerformerListSuffix)

        return $_string
    }
}