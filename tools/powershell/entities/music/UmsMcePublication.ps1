###############################################################################
#   Concrete entity class UmsMcePublication
#==============================================================================
#
#   This class describes a music publication entity, built from a 'publication'
#   XML element from the UMS music namespace.
#
###############################################################################

class UmsMcePublication : UmsBaeProduct
{
    ###########################################################################
    # Static properties
    ###########################################################################

    # One or several characters which will be inserted between each name
    # in a list of composers.
    static [string] $ComposerDelimiter = 
        (Get-UmsConfigurationItem -ShortName "ComposerDelimiter")
    
    # One or several characters which will be inserted before a list of
    # composers.
    static [string] $ComposerListPrefix = 
        (Get-UmsConfigurationItem -ShortName "ComposerListPrefix")

    # One or several characters which will be inserted after a list of
    # composers.
    static [string] $ComposerListSuffix = 
        (Get-UmsConfigurationItem -ShortName "ComposerListSuffix")

    # One or several characters which will be inserted between each name
    # in a list of catalog ids.
    static [string] $CatalogIdDelimiter = 
        (Get-UmsConfigurationItem -ShortName "CatalogIdDelimiter")
    
    # One or several characters which will be inserted before a list of
    # catalog ids.
    static [string] $CatalogIdListPrefix = 
        (Get-UmsConfigurationItem -ShortName "CatalogIdListPrefix")

    # One or several characters which will be inserted after a list of
    # catalog ids.
    static [string] $CatalogIdListSuffix = 
        (Get-UmsConfigurationItem -ShortName "CatalogIdListSuffix")

    ###########################################################################
    # Hidden properties
    ###########################################################################

    ###########################################################################
    # Visible properties
    ###########################################################################

    [UmsMceCatalogId[]]     $CatalogIds
    [UmsMceComposer[]]      $Composers

    ###########################################################################
    # Constructors
    ###########################################################################

    # Standard constructor.
    UmsMcePublication([System.Xml.XmlElement] $XmlElement) : base($XmlElement)
    {
        # Validate the XML root element
        $this.ValidateXmlElement(
            $XmlElement, [UmsAeEntity]::NamespaceUri.Music, "publication")

        # Optional 'catalogIds' element
        if ($XmlElement.catalogIds)
        {
            $this.BuildCatalogIds(
                $this.GetOneXmlElement(
                    $XmlElement,
                    [UmsAeEntity]::NamespaceUri.Music,
                    "catalogIds"))
        }
        
        # Optional 'composers' element (collection of 'composer' elements)
        if ($XmlElement.composers)
        {
            $this.BuildComposers(
                $this.GetOneXmlElement(
                    $XmlElement, [UmsAeEntity]::NamespaceUri.Music, "composers"))
        }
    }

    # Sub-constructor for the 'catalogIds' element
    [void] BuildCatalogIds([System.Xml.XmlElement] $CatalogIdsElement)
    {
        $this.GetOneOrManyXmlElement(
            $CatalogIdsElement,
            [UmsAeEntity]::NamespaceUri.Music,
            "catalogId"
        ) | foreach {
                $this.CatalogIds += [EntityFactory]::GetEntity($_) }
    }    
    
    # Sub-constructor for the 'composers' element
    [void] BuildComposers([System.Xml.XmlElement] $ComposersElement)
    {
        $this.GetOneOrManyXmlElement(
            $ComposersElement,
            [UmsAeEntity]::NamespaceUri.Music,
            "composer"
        ) | foreach {
                $this.Composers += [EntityFactory]::GetEntity($_) }
    }

    ###########################################################################
    # Helpers
    ###########################################################################

    [string] ToString()
    {
        $_string = ""
        $_addSpace = $false
        
        # Show composer list
        # Add space, if needed
        if ($_addSpace) { $_string += ([UmsAeEntity]::NonBreakingSpace) }

        # Get an array of composer short names
        $_composers = @()
        foreach ($_composer in $this.Composers)
            { $_composers += $_composer.Name.ShortName }

        # Add composers to the buffer
        $_string += ([UmsMcePublication]::ComposerListPrefix)
        $_string += ($_composers -join(
            [UmsMcePublication]::ComposerDelimiter))
        $_string += ([UmsMcePublication]::ComposerListSuffix)
        $_addSpace = $true

        # Include publication title. We use the ToString() method from the
        # UmsBaeProduct base type to get the string.
        # Add space, if needed
        if ($_addSpace) { $_string += ([UmsAeEntity]::NonBreakingSpace) }

        # Add publication title to the buffer
        $_string += ([UmsBaeProduct] $this).ToString()
        $_addSpace = $true

        # Show catalog ids
        if ($this.CatalogIds)
        {
            # Add space, if needed
            if ($_addSpace) { $_string += ([UmsAeEntity]::NonBreakingSpace) }

            # Get an array of catalog ids
            $_catalogIds = @()
            foreach ($_catalogId in $this.CatalogIds)
                { $_catalogIds += $_catalogId.ToString() }

            # Add catalog ids to the buffer
            $_string += ([UmsMcePublication]::CatalogIdListPrefix)
            $_string += ($_catalogIds -join(
                [UmsMcePublication]::CatalogIdDelimiter))
            $_string += ([UmsMcePublication]::CatalogIdListSuffix)
            $_addSpace = $true
        }

        return $_string
    }

}