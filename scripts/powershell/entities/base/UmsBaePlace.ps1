###############################################################################
#   Abstract entity class UmsBaePlace
#==============================================================================
#
#   This class describes an abstract UMS entity representing a generic place.
#   It deals with properties defined in the 'Place' abstract type from the XML
#   schema, and includes various standard place information.
#
#   This class must *NOT* be instantiated, but rather be inherited by concrete 
#   entity classes.
#
###############################################################################

class UmsBaePlace : UmsBaeItem
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

    # Parent city, if any
    [UmsBceCity] $City

    # Parent country state, if any
    [UmsBceCountryState] $CountryState

    # Parent country, if any
    [UmsBceCountry] $Country

    ###########################################################################
    # Constructors
    ###########################################################################

    # Standard constructor.
    UmsBaePlace([System.Xml.XmlElement] $XmlElement) : base($XmlElement)
    {
        # Instantiation of an abstract class is forbidden
        if ($this.getType().Name -eq "UmsBaePlace")
        {
            throw [AbstractClassInstantiationException]::New(
                $this.getType().Name)
        }

        # Try to get an instance of a city entity
        if ($XmlElement.city)
        {
            $this.City = (
                [EntityFactory]::GetEntity(
                    $this.GetOneXmlElement(
                        $XmlElement,
                        [UmsAeEntity]::NamespaceUri.Base,
                        "city")))
            
            # Set the other properties to that of the City
            $this.CountryState = $this.City.CountryState
            $this.Country = $this.City.Country
        }
        
        # Try to get an instance of a countryState entity
        elseif ($XmlElement.countryState)
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

        # Try to get an instance of a country entity
        elseif ($XmlElement.country)
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
    # of the city, the country state and the country as suffices, if available.
    [string] ToString()
    {
        # Initialize empty string
        [string] $_string = ""

        # Include ToString() output for labelVariant data. This string shall be
        # void if the 'place' element has no 'labelVariants' child element.
        $_labelToString = ([UmsBaeItem] $this).ToString()
        if ($_labelToString)
        {
            $_string += $_labelToString
        }

        # Add city string, which includes countryState and country suffices
        if($this.City)
        {
            if ($_labelToString)
                { $_string += [UmsBaePlace]::PlaceDelimiter }
            $_string += $this.City.ToString()
        }

        # Add countryState string, which includes a country suffix
        elseif($this.CountryState)
        {
            $_string += [UmsBaePlace]::PlaceDelimiter
            $_string += $this.CountryState.ToString()
        }

        # Add country string, which includes no suffix
        elseif($this.Country)
        {
            $_string += [UmsBaePlace]::PlaceDelimiter
            $_string += $this.Country.ToString()
        }

        return $_string
    }
}