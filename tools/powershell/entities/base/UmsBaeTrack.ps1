###############################################################################
#   Concrete entity class UmsBaeTrack
#==============================================================================
#
#   This class describes an abstract UMS entity representing a generic track
#   on a generic medium.
#   This class includes routines common to more specialized types of tracks,
#   such as audio or music tracks on audio albums.
#
#   This class must *NOT* be instantiated, but rather be inherited by concrete 
#   entity classes.
#
###############################################################################

class UmsBaeTrack : UmsBaeProduct
{
    ###########################################################################
    # Static properties
    ###########################################################################

    # The format of track numbers in string representations.
    static [string] $TrackNumberFormat = 
    (Get-UmsConfigurationItem -ShortName "TrackNumberFormat")

    # Whether the title of the track will be shown when rendered as a string.
    static [string] $ShowTrackTitle = 
    (Get-UmsConfigurationItem -ShortName "ShowTrackTitle")

    ###########################################################################
    # Hidden properties
    ###########################################################################

    ###########################################################################
    # Visible properties
    ###########################################################################

    [int]   $Number

    ###########################################################################
    # Constructors
    ###########################################################################

    # Standard constructor.
    UmsBaeTrack([System.Xml.XmlElement] $XmlElement, [System.Uri] $Uri)
        : base($XmlElement, $Uri)
    {
        # Verbose prefix
        $_verbosePrefix = "[UmsBaeTrack]::UmsBaeTrack(): "

        # Instantiation of an abstract class is forbidden
        if ($this.getType().Name -eq "UmsBaeTrack")
        {
            throw [AbstractClassInstantiationException]::New(
                $this.getType().Name)
        }

        # Attributes
        $this.Number = $this.GetMandatoryXmlAttributeValue(
            $XmlElement, "number")
    }

    ###########################################################################
    # Helpers
    ###########################################################################

    # Returns the string representation of the track.
    [string] ToString()
    {
        $_string = ""

        # Include track number
        $_string += ([UmsBaeTrack]::TrackNumberFormat -f $this.Number)

        # Include track title, if defined. We use the ToString() method
        # from the UmsBaeProduct base type to get the string.
        $_fullTitle = ([UmsBaeProduct] $this).ToString()
        if (([UmsBaeTrack]::ShowMediumTitle) -and ($_fullTitle))
        {
            $_string += ([UmsAeEntity]::NonBreakingSpace)
            $_string += $_fullTitle
        }

        return $_string
    }
}