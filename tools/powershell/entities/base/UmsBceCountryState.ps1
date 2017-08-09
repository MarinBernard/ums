###############################################################################
#   Concrete entity class UmsBceCountryState
#==============================================================================
#
#   This class describes a country state entity, built from an XML
#    'countryState' element from the base namespace.
#
###############################################################################

class UmsBceCountryState : UmsBaeItem
{
    ###########################################################################
    # Static properties
    ###########################################################################

    # A string inserted between each part of a multi-part place
    static [string] $PlaceDelimiter = 
        (Get-UmsConfigurationItem -ShortName "PlaceDelimiter")

    ###########################################################################
    # Hidden properties
    ###########################################################################

    ###########################################################################
    # Visible properties
    ###########################################################################

    # Parent country
    [UmsBceCountry] $Country

    ###########################################################################
    # Constructors
    ###########################################################################

    # Standard constructor.
    UmsBceCountryState([System.Xml.XmlElement] $XmlElement, [System.Uri] $Uri)
        : base($XmlElement, $Uri)
    {
        # Validate the XML root element
        $this.ValidateXmlElement(
            $XmlElement, [UmsAeEntity]::NamespaceUri.Base, "countryState")

        # Get the mandatory 'country' instance
        $this.Country = [EntityFactory]::GetEntity(
            $this.GetOneXmlElement(
                $XmlElement, [UmsAeEntity]::NamespaceUri.Base, "country"),
            $this.SourcePathUri,
            $this.SourceFileUri)
    }

    ###########################################################################
    # Helpers
    ###########################################################################

    # Returns the string version of the place, which tries to include the
    # name of the country as a suffix.
    [string] ToString()
    {
        # Initialize empty string
        [string] $_string = ""

        # Include ToString() output for labelVariant data. This string shall be
        # void if the 'place' element has no 'labelVariants' child element.
        if (([UmsBaeItem]$this).ToString())
        {
            $_string += ([UmsBaeItem]$this).ToString()
        }

        # Add country name as a suffix
        if($this.Country)
        {
            $_string += [UmsBceCountryState]::PlaceDelimiter
            $_string += $this.Country.ToString()
        }

        return $_string
    }
}