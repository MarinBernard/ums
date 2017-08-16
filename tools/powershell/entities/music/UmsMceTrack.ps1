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

    # Whether the track title rendered as string should include the title of
    # all the movements comprised in the track. If set to $false, the string
    # will only include the title of the first movement.
    static [bool] $ShowAllMovementTitles = (
        [ConfigurationStore]::GetRenderingItem(
            "AudioTrackTitleIncludeAllMovements").Value)

    # One or several characters which will be inserted between each movement's
    # title, if ShowAllMovementTitles is set to $true.
    static [string] $MovementTitleDelimiter = (
        [ConfigurationStore]::GetRenderingItem(
            "AudioTrackTitleMovementDelimiter").Value)

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

    # Returns the string representation of the album track.
    [string] ToString()
    {
        # If no movement is present, we just return the basic track title
        if ($this.Movements.Count -eq 0)
            { return ([UmsBaeTrack] $this).ToString() }

        $_string = ""

        # Include track number, if enabled.
        if ([UmsBaeTrack]::ShowTrackNumber)
        {
            $_string += ([UmsBaeTrack]::TrackNumberFormat -f $this.Number)
            $_string += ([UmsAeEntity]::NonBreakingSpace)
        }

        [string[]] $_movementTitles = @()

        # If ShowAllMovementTitles is enabled, we need to render the title of
        # every movement.
        if ([UmsMceTrack]::ShowAllMovementTitles)
        {
            foreach ($_movement in $this.Movements)
                { $_movementTitles += $_movement.ToFullString() }
        }
        # Else, we only render a single movement title
        else
            { $_movementTitles += $this.Movements[0].ToFullString()  }

        # Merge movement titles
        $_string += $_movementTitles -join([UmsMceTrack]::MovementTitleDelimiter)

        return $_string
    }
}