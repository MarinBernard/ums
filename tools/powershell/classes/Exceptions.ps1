# Base class for all UMS exceptions.
class UmsException : System.Exception
{
    [string] $MainMessage
    [string[]] $SubMessages
    
    UmsException() : base() {}
}

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

# Thrown when the entity factory finds a UMS reference.
class UnhandlableUmsReferenceException : UmsException
{
    UnhandlableUmsReferenceException(
        [string] $NamespaceUri,
        [string] $ElementName,
        [string] $Uid
    ) : base()
    {
        $_strings = $global:ModuleStrings.Exceptions.UnhandlableUmsReference
        $this.MainMessage =  (
            $_strings.MainMessage -f $ElementName,$NamespaceUri,$Uid)
    }
}

# Thrown when the entity factory finds a UMS reference.
class ClassLookupFailureException : UmsException
{
    ClassLookupFailureException(
        [string] $NamespaceUri,
        [string] $ElementName
    ) : base()
    {
        $_strings = $global:ModuleStrings.Exceptions.ClassLookupFailure
        $this.MainMessage =  (
            $_strings.MainMessage -f $ElementName,$NamespaceUri)
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

# Thrown when a null Xml element is supplied.
class NullXmlElementException : UmsException
    { NullXmlElementException() : base() {} }