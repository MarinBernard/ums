###############################################################################
#   Concrete entity class UmsMceInstrumentalist
#==============================================================================
#
#   This class describes a music instrumentalist entity, built from an
#   'instrumentalist' XML element from the UMS music namespace.
#
###############################################################################

class UmsMceInstrumentalist : UmsBaePerson
{
    ###########################################################################
    # Static properties
    ###########################################################################

    # Whether the name of the played instrument should be added to the name of
    # the instrumentalist when it is rendered as a string.
    static [string] $ShowPlayedInstrument = 
        (Get-UmsConfigurationItem -ShortName "ShowPlayedInstrument")
    
    # One or several characters which will be inserted before the name of the
    # played instrument.
    static [string] $PlayedInstrumentPrefix = 
        (Get-UmsConfigurationItem -ShortName "PlayedInstrumentPrefix")

    # One or several characters which will be inserted after the name of the
    # played instrument.
    static [string] $PlayedInstrumentSuffix = 
        (Get-UmsConfigurationItem -ShortName "PlayedInstrumentSuffix")

    ###########################################################################
    # Hidden properties
    ###########################################################################

    ###########################################################################
    # Visible properties
    ###########################################################################

    [UmsMceInstrument] $Instrument

    ###########################################################################
    # Constructors
    ###########################################################################

    # Standard constructor.
    UmsMceInstrumentalist(
        [System.Xml.XmlElement] $XmlElement,
        [System.Uri] $Uri)
        : base($XmlElement, $Uri)
    {
        # Validate the XML root element
        $this.ValidateXmlElement(
            $XmlElement, [UmsAeEntity]::NamespaceUri.Music, "instrumentalist")
    }

    ###########################################################################
    # Helpers
    ###########################################################################

    [void] RegisterInstrument([UmsMceInstrument] $Instrument)
    {
        if ($this.Instrument -eq $null) { $this.Instrument = $Instrument }
    }

    # Renders the instrumentalist as a string, with the played instrument as an
    # optional suffix.
    [string] ToString()
    {
        $_string = ""

        # Full name of the instrumentalist, gathered from base type.
        $_string += ([UmsBaePerson] $this).ToString()

        # Show instrument suffix, if enabled.
        if ([UmsMceInstrumentalist]::ShowPlayedInstrument)
        {
            $_string += ([UmsAeEntity]::NonBreakingSpace)
            $_string += ([UmsMceInstrumentalist]::PlayedInstrumentPrefix)
            $_string += $this.Instrument
            $_string += ([UmsMceInstrumentalist]::PlayedInstrumentSuffix)
        }

        return $_string
    }

}