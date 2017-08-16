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
{
    NullXmlElementException() : base() {}
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

# Thrown when a UMS reference could not be resolved.
class UnresolvableUmsReference : UmsException
{
    UnresolvableUmsReference(
        [string] $NamespaceURI,
        [string] $LocalName,
        [string] $Uid,
        [System.Uri[]] $Uris
    ) : base()
    {
        $_strings = $global:ModuleStrings.Exceptions.UnresolvableUmsReference
        $this.MainMessage =  $_strings.MainMessage
        $this.SubMessages += (
            $_strings.NamespaceURI -f $NamespaceURI)
        $this.SubMessages += (
            $_strings.LocalName -f $LocalName)
        $this.SubMessages += (
            $_strings.Uid -f $Uid)
        foreach ($_uri in $Uris)
        {
            $this.SubMessages += (
                $_strings.TriedUri -f $_uri)
        }
    }
}

# Thrown when a UMS item does not have the expected cardinality.
class IncompatibleCardinalityException : UmsException
{
    IncompatibleCardinalityException(
        [UmsManagedItem] $Item,
        [UICardinality[]] $CompatibleCardinalities
    ) : base()
    {
        $_strings = $global:ModuleStrings.Exceptions.IncompatibleCardinalityException
        $this.MainMessage =  $_strings.MainMessage
        $this.SubMessages += (
            $_strings.ItemName -f $Item.FullName)
        $this.SubMessages += (
            $_strings.ActualCardinality -f $Item.Cardinality)
        $this.SubMessages += (
            $_strings.CompatibleCardinalities -f $CompatibleCardinalities.Join(", "))
    }
}

# Thrown when an UMS item update failed.
class UmsManagedItemUpdateFailure : UmsException
{
    UmsManagedItemUpdateFailure(
        [UmsManagedItem] $Item
    ) : base()
    {
        $_strings = (
            $global:ModuleStrings.Exceptions.UmsManagedItemUpdateFailure)
        $this.MainMessage =  $_strings.MainMessage
        $this.SubMessages += (
            $_strings.ItemPath -f $Item.Path)
        $this.SubMessages += (
            $_strings.ItemName -f $Item.Name)
    }
}

# Thrown on metadata conversion failure.
class UmsManagedItemMetadataConversionFailure : UmsException
{
    UmsManagedItemMetadataConversionFailure(
        [UmsManagedItem] $Item
    ) : base()
    {
        $_strings = (
            $global:ModuleStrings.Exceptions.UmsManagedItemMetadataConversionFailure)
        $this.MainMessage =  $_strings.MainMessage
        $this.SubMessages += (
            $_strings.ItemPath -f $Item.Path)
        $this.SubMessages += (
            $_strings.ItemName -f $Item.Name)
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

# Thrown when the retrieved document is invalid
class InvalidUmsDocumentException : UmsException
{
    InvalidUmsDocumentException(
        [string] $FullPath
    ) : base()
    {
        $_strings = (
            $global:ModuleStrings.Exceptions.
                InvalidUmsDocumentException)
        $this.MainMessage =  ($_strings.MainMessage -f $FullPath)
    }
}

###############################################################################
# Exceptions thrown by the UmsDocumentCache class
###############################################################################

# Thrown when a document cannot not be retrieved
class UmsDocumentNotFoundExcepion : UmsException
{
    UmsDocumentNotFoundExcepion(
        [System.Uri] $Uri
    ) : base()
    {
        $_strings = (
            $global:ModuleStrings.Exceptions.
            UmsDocumentNotFoundExcepion)
        $this.MainMessage =  ($_strings.MainMessage -f $Uri.AbsoluteUri)
    }
}

# Thrown when a cached document cannot not be written to disk
class UmsCachedDocumentWriteFailureException : UmsException
{
    UmsCachedDocumentWriteFailureException(
        [System.Uri] $Uri,
        [string] $CacheFileName
    ) : base()
    {
        $_strings = (
            $global:ModuleStrings.Exceptions.
                UmsCachedDocumentWriteFailureException)
        $this.MainMessage =  ($_strings.MainMessage -f $Uri.AbsoluteUri)
        $this.SubMessages += (
            $_strings.CacheFileName -f $CacheFileName)
    }
}