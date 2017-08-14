###############################################################################
#   Local class UmsBaeStandard_Segment
#==============================================================================
#
#   Describes a standard segment. It is used as an internal resource by the
#   UmsBaeStandard class.
#
###############################################################################

class UmsBaeStandard_Segment
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

    [int]       $Order
    [bool]      $Mandatory
    [string]    $Delimiter
    [UmsBaeStandard_Segment_Qualifier]  $Qualifier

    ###########################################################################
    # Constructors
    ###########################################################################

    UmsBaeStandard_Segment([System.Xml.XmlElement] $XmlElement)
    {
        if ($XmlElement.HasAttribute("order"))
            { $this.Order = $XmlElement.GetAttribute("order") }
        else
        {
            throw [MissingXmlElementAttributeException]::New(
                "order", $XmlElement.NamespaceURI, $XmlElement.LocalName)
        }

        if ($XmlElement.HasAttribute("mandatory"))
            { $this.Mandatory = [System.Boolean]::Parse(
                $XmlElement.GetAttribute("mandatory")) }
        else
        {
            throw [MissingXmlElementAttributeException]::New(
                "mandatory", $XmlElement.NamespaceURI, $XmlElement.LocalName)
        }

        if ($XmlElement.HasAttribute("delimiter"))
            { $this.Delimiter = $XmlElement.GetAttribute("delimiter") }
        elseif ($XmlElement.HasAttribute("qualifier"))
            { $this.Qualifier = $XmlElement.GetAttribute("qualifier") }
        else
        {
            throw [MissingXmlElementAttributeException]::New(
                "delimiter", $XmlElement.NamespaceURI, $XmlElement.LocalName)
        }            
    }

    ###########################################################################
    # Helpers
    ###########################################################################

    [string] GetPrefix()
    {
        [string] $_string = ""

        if ($this.Delimiter)
            { $_string += $this.Delimiter }

        elseif ($this.Qualifier)
        {
            switch ($this.Qualifier)
            {
                "Numero"
                {
                    $_string += ([UmsAeEntity]::NonBreakingSpace)
                    $_string += "n°"
                    $_string += ([UmsAeEntity]::NonBreakingSpace)
                }
            }
        }

        return $_string
    }
}

###############################################################################
#   Local enum UmsBaeStandard_Segment_Qualifier
#==============================================================================
#
#   Describes a qualifier in a standard's segment.
#
###############################################################################

Enum UmsBaeStandard_Segment_Qualifier
{
    Numero
}