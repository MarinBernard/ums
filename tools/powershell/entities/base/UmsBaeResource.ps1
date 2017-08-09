###############################################################################
#   Abstract entity class UmsBaeResource
#==============================================================================
#
#   This class describes an abstract UMS entity representing a generic
#   resource. The specificity of a resource entity is to represent a single,
#   self-sufficient piece of information. For instance, language variant
#   entities are not resources, as they are not self-sufficient.
#
#   This abstract type has not equivalent in the XML schema. Its goal is to
#   lighten class definitions by regrouping pieces of code which are common
#   to all resources, such as the management of link variants.
#
#   This class must *NOT* be instantiated, but rather be inherited by concrete 
#   entity classes.
#
###############################################################################

class UmsBaeResource : UmsAeEntity
{
    ###########################################################################
    # Static properties
    ###########################################################################

    ###########################################################################
    # Hidden properties
    ###########################################################################

    # Collection of all link variants
    hidden [UmsBceLinkVariant[]] $LinkVariants

    ###########################################################################
    # Visible properties
    ###########################################################################

    # Elected link variants
    [UmsBceLinkVariant[]] $Links

    ###########################################################################
    # Constructors
    ###########################################################################

    # Abstract constructor, to be called by child constructors.
    UmsBaeResource([System.Xml.XmlElement] $XmlElement, [System.Uri] $Uri)
        : base($XmlElement, $Uri)
    {
        # Instantiation of an abstract class is forbidden
        if ($this.getType().Name -eq "UmsBaeResource")
        {
            throw [AbstractClassInstantiationException]::New(
                $this.getType().Name)
        }

        # Build optional link variants
        $this.BuildLinkVariants(
            $this.GetZeroOrOneXmlElement(
                $XmlElement, [UmsAeEntity]::NamespaceUri.Base, "linkVariants"))
    }

    # Builds instances of all link variants and elects those which fit
    # the best language.
    [void] BuildLinkVariants([System.Xml.XmlElement] $LinkVariantsElement)
    {
        $this.GetZeroOrManyXmlElement(
            $LinkVariantsElement,
            [UmsAeEntity]::NamespaceUri.Base,
            "linkVariant"
        ) | foreach {
                $this.LinkVariants += [EntityFactory]::GetEntity(
                    $_, $this.SourcePathUri, $this.SourceFileUri) }

        # Select the best link variant for each resource type
        $_groups = $this.LinkVariants | Group-Object -Property ResourceType
        foreach ($_group in $_groups)
        {
            $this.Links += [UmsBaeVariant]::GetBestVariant($_group.Group)
        }
    }

    ###########################################################################
    # Helpers
    ########################################################################### 
}