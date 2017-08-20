# Thrown when the XML namespace or the local name of an XML element is not the
# one expected by the constructor of an entity class.
class IncompatibleXmlElementException : UmsException
{
    IncompatibleXmlElementException(
        [string] $ActualNamespaceUri,
        [string] $ExpectedNamespaceUri,
        [string] $ActualElementName,
        [string] $ExpectedElementName,
        [string] $EntityClassName
    ) : base()
    {
        $_strings = $global:ModuleStrings.Exceptions.IncompatibleXmlElement
        $this.MainMessage =  (
            $_strings.MainMessage -f $EntityClassName)
        $this.SubMessages += (
            $_strings.ElementNamespace -f $ActualNamespaceUri)
        $this.SubMessages += (
            $_strings.ExpectedNamespace -f $ExpectedNamespaceUri)
        $this.SubMessages += (
            $_strings.ElementName -f $ActualElementName)
        $this.SubMessages += (
            $_strings.ExpectedName -f $ExpectedElementName)
    }
}

# Thrown when a pseudo-abstract class is instantiated, which is forbidden.
class AbstractClassInstantiationException : UmsException
{
    AbstractClassInstantiationException([string] $EntityClassName) : base()
    {
        $_strings = $global:ModuleStrings.Exceptions.AbstractClassInstantiation
        $this.MainMessage =  (
            $_strings.MainMessage -f $EntityClassName)
    }
}

# Thrown when the value of an attribute of an XML element is illegal.
class IllegalXmlAttributeValueException : UmsException
{
    IllegalXmlAttributeValueException(
        [string] $NamespaceUri,
        [string] $ElementName,
        [string] $AttributeName,
        [string] $AttributeValue,
        [string[]] $AllowedValues
    ) : base()
      {
        $_strings = $global:ModuleStrings.Exceptions.IllegalXmlAttributeValue
        $this.MainMessage =  (
            $_strings.MainMessage -f $AttributeName,$ElementName,$NamespaceUri)
        $this.SubMessages += ($_strings.ActualValue -f $AttributeValue)
        $this.SubMessages += ($_strings.AllowedValues -f ($AllowedValues -join(", ")))
    }
}

# Thrown when an XML document is illegal.
class IllegalXmlElementCountException : UmsException
{
    IllegalXmlElementCountException(
        [string] $NamespaceUri,
        [string] $ElementName,
        [string] $ContextXmlNamespace,
        [string] $ContextElementName,
        [int] $ActualCount,
        [int] $MinExpectedCount,
        [int] $MaxExpectedCount
    ) : base()
      {
        $_strings = $global:ModuleStrings.Exceptions.IllegalXmlElementCount
        $this.MainMessage =  (
            $_strings.MainMessage -f $ElementName,$NamespaceUri)
        $this.SubMessages += (
            $_strings.Context -f $ContextXmlNamespace,$ContextElementName)
        $this.SubMessages += ($_strings.ActualCount -f $ActualCount)
        $this.SubMessages += ($_strings.MinExpectedCount -f $MinExpectedCount)
        $this.SubMessages += ($_strings.MaxExpectedCount -f $MaxExpectedCount)
    }
}

# Thrown when a mandatory attribute is missing from an Xml Element.
class MissingXmlElementAttributeException : UmsException
{
    MissingXmlElementAttributeException(
        [string] $AttributeName,
        [string] $ContextXmlNamespace,
        [string] $ContextElementName
    ) : base()
      {
        $_strings = $global:ModuleStrings.Exceptions.MissingXmlElementAttribute
        $this.MainMessage =  ($_strings.MainMessage -f $AttributeName)
        $this.SubMessages += (
            $_strings.Context -f $ContextXmlNamespace,$ContextElementName)
    }
}

# Thrown when a UMS reference targets a resource which is not from the expected
# type.
class IncompatibleUmsReferenceResourceType : UmsException
{
    IncompatibleUmsReferenceResourceType(
        [string] $ResourceUri,
        [string] $ActualResourceType,
        [string] $ExpectedResourceType
    ) : base()
    {
        $_strings = $global:ModuleStrings.Exceptions.IncompatibleUmsReferenceResourceType
        $this.MainMessage =  $_strings.MainMessage
        $this.SubMessages += (
            $_strings.ResourceUri -f $ResourceUri)
        $this.SubMessages += (
            $_strings.ResourceType -f $ActualResourceType)
        $this.SubMessages += (
            $_strings.ExpectedType -f $ExpectedResourceType)
    }
}

# Thrown when a UMS reference targets an XML document whose document element
# is not from the expected namespace.
class IncompatibleUmsReferenceElementNamespace : UmsException
{
    IncompatibleUmsReferenceElementNamespace(
        [string] $ResourceUri,
        [string] $ActualNamespace,
        [string] $ExpectedNamespace
    ) : base()
    {
        $_strings = $global:ModuleStrings.Exceptions.IncompatibleUmsReferenceElementNamespace
        $this.MainMessage =  $_strings.MainMessage
        $this.SubMessages += (
            $_strings.ResourceUri -f $ResourceUri)
        $this.SubMessages += (
            $_strings.ActualNamespace -f $ActualNamespace)
        $this.SubMessages += (
            $_strings.ExpectedNamespace -f $ExpectedNamespace)
    }
}

# Thrown when a UMS reference targets an XML document whose document element
# does not have the expected local name.
class IncompatibleUmsReferenceElementName : UmsException
{
    IncompatibleUmsReferenceElementName(
        [string] $ResourceUri,
        [string] $ActualName,
        [string] $ExpectedName
    ) : base()
    {
        $_strings = $global:ModuleStrings.Exceptions.IncompatibleUmsReferenceElementName
        $this.MainMessage =  $_strings.MainMessage
        $this.SubMessages += (
            $_strings.ResourceUri -f $ResourceUri)
        $this.SubMessages += (
            $_strings.ActualName -f $ActualName)
        $this.SubMessages += (
            $_strings.ExpectedName -f $ExpectedName)
    }
}

# Thrown when an UMS item update failed.
class MandatoryStandardIdSegmentNotFoundException : UmsException
{
    MandatoryStandardIdSegmentNotFoundException(
        [object] $Segment
    ) : base()
    {
        $_strings = (
            $global:ModuleStrings.Exceptions.
                MandatoryStandardIdSegmentNotFoundException)
        $this.MainMessage =  ($_strings.MainMessage -f $Segment.Order)
    }
}

# Thrown on public command failure
class UmsPublicCommandFailureException : UmsException
{
    UmsPublicCommandFailureException([string] $Command) : base()
    {
        $this.MainMessage = ("The {0} public command has failed." -f $Command)
    }
}

# Base class for all entities exception
class UmsEntityException : UmsException
{
    UmsEntityException() : base()
    {
    }
}