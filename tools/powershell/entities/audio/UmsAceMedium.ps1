###############################################################################
#   Concrete entity class UmsAceMedium
#==============================================================================
#
#   This class describes an audio medium entity, built from a 'medium' XML
#   element from the audio namespace.
#
###############################################################################

class UmsAceMedium : UmsBaeProduct
{
    ###########################################################################
    # Static properties
    ###########################################################################

    # The format of medium numbers
    static [string] $MediumNumberFormat = 
        (Get-UmsConfigurationItem -ShortName "MediumNumberFormat")

    # Whether the title of the medium will be shown when rendered as a string.
    static [string] $ShowMediumTitle = 
        (Get-UmsConfigurationItem -ShortName "ShowMediumTitle")

    # One or several characters which will be inserted before the title of the
    # medium when it is rendered as a string.
    static [string] $MediumTitlePrefix = 
        (Get-UmsConfigurationItem -ShortName "MediumTitlePrefix")

    # One or several characters which will be inserted after the title of the
    # medium when it is rendered as a string.
    static [string] $MediumTitleSuffix = 
        (Get-UmsConfigurationItem -ShortName "MediumTitleSuffix")

    ###########################################################################
    # Hidden properties
    ###########################################################################

    ###########################################################################
    # Visible properties
    ###########################################################################

    [int]               $Number
    [int]               $Side = 1
    [UmsAceMediumType]  $Type


    ###########################################################################
    # Constructors
    ###########################################################################

    # Standard constructor.
    UmsAceMedium([System.Xml.XmlElement] $XmlElement, [System.Uri] $Uri)
        : base($XmlElement, $Uri)
    {
        # Verbose prefix
        $_verbosePrefix = "[UmsAceMedium]::UmsAceMedium(): "

        # Validate the XML root element
        $this.ValidateXmlElement(
            $XmlElement, [UmsAeEntity]::NamespaceUri.Audio, "medium")

        # Attributes
        $this.Number = $this.GetMandatoryXmlAttributeValue(
            $XmlElement, "number")
        $this.Side = $this.GetOptionalXmlAttributeValue(
            $XmlElement, "side")
        $this.Type = $this.GetMandatoryXmlAttributeValue(
            $XmlElement, "type")
    }

    ###########################################################################
    # Helpers
    ###########################################################################

    # Returns the string representation of the medium.
    [string] ToString()
    {
        $_string = ""

        # Include medium type and number
        $_string += $this.Type
        $_string += ([UmsAeEntity]::NonBreakingSpace)
        $_string += ([UmsAceMedium]::MediumNumberFormat -f $this.Number)

        # Include medium title, if defined. We use the ToString() method
        # from the UmsBaeProduct base type to get the string.
        $_fullTitle = ([UmsBaeProduct] $this).ToString()
        if (([UmsAeEntity]::ShowMediumTitle) -and ($_fullTitle))
        {
            $_string += ([UmsAeEntity]::NonBreakingSpace)
            $_string += ([UmsAceMedium]::MediumTitlePrefix)
            $_string += $_fullTitle
            $_string += ([UmsAceMedium]::MediumTitleSuffix)
        }

        return $_string
    }
}

# Supported audio medium types
Enum UmsAceMediumType
{
    CDDA
}