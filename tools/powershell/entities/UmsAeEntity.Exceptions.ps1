###############################################################################
#   Exception class UmsEntityException
#==============================================================================
#
#   Base type for all exceptions thrown by UMS entities.
#
###############################################################################

class UmsEntityException : UmsException
{
    UmsEntityException() : base() {}
}

###############################################################################
#   Exception class UEAbstractEntityInstantiationException
#==============================================================================
#
#   Thrown when a pseudo-abstract entity class is instantiated, which is
#   forbidden.
#
###############################################################################

class UEAbstractEntityInstantiationException : UmsEntityException
{
    UEAbstractEntityInstantiationException([string] $EntityClassName) : base()
    {
        $this.MainMessage =  (
            "The '{0}' abstract entity class cannot be instantiated." `
            -f $EntityClassName)
    }
}

###############################################################################
#   Exception class UEIncompatibleXmlElementException
#==============================================================================
#
#   Thrown when the XML namespace or the local name of an XML element is not
#   the one expected by the constructor of an entity class.
#
###############################################################################

class UEIncompatibleXmlElementException : UmsEntityException
{
    UEIncompatibleXmlElementException(
        [string] $ActualNamespaceUri,
        [string] $ExpectedNamespaceUri,
        [string] $ActualElementName,
        [string] $ExpectedElementName,
        [string] $EntityClassName
    ) : base()
    {
        $this.MainMessage =  ($(
            "Unable to instantiate the entity class '{0}', because the " + `
            "XML element passed to the constructor was rejected.") `
            -f $EntityClassName)
        
        $this.SubMessages += (
            "Namespace of the Xml element is: {0}" -f $ActualNamespaceUri)

        $this.SubMessages += (
            "Expected namespace is: {0}" -f $ExpectedNamespaceUri)

        $this.SubMessages += (
            "Local name of the Xml element is: {0}" -f $ActualElementName)
        
        $this.SubMessages += (
            "Expected local name is: {0}" -f $ExpectedElementName)
    }
}

###############################################################################
#   Exception class UEIllegalXmlElementCountException
#==============================================================================
#
#   Thrown when the cardinality of an XML element is invalid in a specific
#   context.
#
###############################################################################

# Thrown when an XML document is illegal.
class UEIllegalXmlElementCountException : UmsEntityException
{
    UEIllegalXmlElementCountException(
        [string] $NamespaceUri,
        [string] $ElementName,
        [string] $ContextXmlNamespace,
        [string] $ContextElementName,
        [int] $ActualCount,
        [int] $MinExpectedCount,
        [int] $MaxExpectedCount)
        : base()
    {
        $this.MainMessage =  ($(
            "The number of '{0}' XML elements from the '{1}' namespace " + `
            "is illegal in this context.") `
            -f @($ElementName, $NamespaceUri))

        $this.SubMessages += (
            "Found {0} elements (Required range: {1}, {2})" `
            -f @($ActualCount, $MinExpectedCount, $MaxExpectedCount))

        $this.SubMessages += (
            "Context is a '{0}' XML element from namespace '{1}'." `
            -f @($ContextXmlNamespace, $ContextElementName))
    }
}

###############################################################################
#   Exception class UEMissingXmlElementAttributeException
#==============================================================================
#
#   Thrown when a mandatory attribute is missing from an XLM element.
#
###############################################################################

class UEMissingXmlElementAttributeException : UmsEntityException
{
    UEMissingXmlElementAttributeException(
        [string] $AttributeName,
        [string] $ContextXmlNamespace,
        [string] $ContextElementName)
    : base()
    {
        $this.MainMessage = (
            "XML attribute '{0}' is missing but mandatory in this context." `
            -f $AttributeName)

        $this.SubMessages += (
            "Context is a '{0}' XML element from namespace '{1}'." `
            -f @($ContextXmlNamespace, $ContextElementName))
    }
}