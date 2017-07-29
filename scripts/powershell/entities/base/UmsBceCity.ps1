###############################################################################
#   Concrete entity class UmsBceCity
#==============================================================================
#
#   This class describes a city entity, built from an XML 'city' element from
#   the base namespace.
#
###############################################################################

class UmsBceCity : UmsBaeItem
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

    # Parent country state, if any
    [UmsBceCountryState] $CountryState

    # Parent country
    [UmsBceCountry] $Country    

    ###########################################################################
    # Constructors
    ###########################################################################

    # Standard constructor.
    UmsBceCity([System.Xml.XmlElement] $XmlElement) : base($XmlElement)
    {
        # Validate the XML root element
        $this.ValidateXmlElement(
            $XmlElement, [UmsAeEntity]::NamespaceUri.Base, "city")
        
        # Try to get a 'countryState' element
        if ($XmlElement.countryState)
        {
            $this.CountryState = (
                [EntityFactory]::GetEntity(
                    $this.GetOneXmlElement(
                        $XmlElement,
                        [UmsAeEntity]::NamespaceUri.Base,
                        "countryState")))
            
            # Set the country property to that of the CountryState
            $this.Country = $this.CountryState.Country
        }

        # If no 'countryState' element was found, a 'country' child element
        # becomes mandatory.
        else
        {
            $this.Country = (
                [EntityFactory]::GetEntity(
                    $this.GetOneXmlElement(
                        $XmlElement,
                        [UmsAeEntity]::NamespaceUri.Base,
                        "country")))
        }
    }

    ###########################################################################
    # Helpers
    ###########################################################################

    # Returns the string version of the place, which tries to include the names
    # of the country state and of the country as suffices, if available.
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

        # Add countryState string, which includes a country suffix
        if($this.CountryState)
        {
            $_string += [UmsBceCity]::PlaceDelimiter
            $_string += $this.CountryState.ToString()
        }

        # Add country string, which includes no suffix
        elseif($this.Country)
        {
            $_string += [UmsBceCity]::PlaceDelimiter
            $_string += $this.Country.ToString()
        }

        return $_string
    }
}