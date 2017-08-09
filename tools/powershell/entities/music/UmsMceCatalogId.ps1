###############################################################################
#   Concrete entity class UmsMceCatalogId
#==============================================================================
#
#   This class describes a music catalog if entity, built from a 'catalogId'
#   XML element from the UMS music namespace.
#
###############################################################################

class UmsMceCatalogId : UmsAeEntity
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

    # Music catalog
    [UmsMceCatalog] $Catalog

    # Catalog entries
    [UmsMceCatalogIdEntry[]] $Entries

    ###########################################################################
    # Constructors
    ###########################################################################

    # Standard constructor.
    UmsMceCatalogId([System.Xml.XmlElement] $XmlElement, [System.Uri] $Uri)
        : base($XmlElement, $Uri)
    {
        # Validate the XML root element
        $this.ValidateXmlElement(
            $XmlElement, [UmsAeEntity]::NamespaceUri.Music, "catalogId")
        
        # Populate the 'Catalog' property with an UmsMceCatalog instance
        $this.Catalog = (
            [EntityFactory]::GetEntity(
                $this.GetOneXmlElement(
                    $XmlElement,
                    [UmsAeEntity]::NamespaceUri.Music,
                    "catalog"),
                    $this.SourcePathUri,
                    $this.SourceFileUri))
        
        # Populate the 'Entries' property with UmsMceCatalogIdEntry instances
        $this.BuildEntries(
            $this.GetOneOrManyXmlElement(
                    $XmlElement, [UmsAeEntity]::NamespaceUri.Music, "id"))
    }

    # Sub-constructor for catalog id entries
    [void] BuildEntries([System.Xml.XmlElement[]] $XmlElements)
    {
        foreach ($_idElement in $XmlElements)
        {
            # Build and store the entry instance. We do not use the factory here, as
            # the name of 'id' elements is too common.
            $this.Entries += New-Object -Type UmsMceCatalogIdEntry($_idElement, $this.SourceFileUri)
        }
    }

    ###########################################################################
    # Helpers
    ###########################################################################

    # String representation
    [string] ToString()
    {
        $_string = ""

        $_string += $this.Catalog.Label.ShortLabel

        foreach ($_entry in ($this.Entries | Sort-Object -Property "Level"))
        {
            $_string += [UmsAeEntity]::NonBreakingSpace
            $_string += $_entry.ToString()
        }
       
        return $_string
    }
}