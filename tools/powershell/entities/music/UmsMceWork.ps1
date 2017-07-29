###############################################################################
#   Concrete entity class UmsMceWork
#==============================================================================
#
#   This class describes a music work entity, built from a 'work' XML element
#   from the UMS music namespace.
#
###############################################################################

class UmsMceWork : UmsBaeProduct
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
    [UmsMceInstrument[]]    $Instruments
    [UmsMceForm]            $Form
    [UmsMceStyle]           $Style
    [UmsMceInception]       $Inception
    [UmsMceCompletion]      $Completion
    [UmsMcePremiere]        $Premiere
    [UmsMceSection[]]       $Sections

    ###########################################################################
    # Constructors
    ###########################################################################

    # Standard constructor.
    UmsMceWork([System.Xml.XmlElement] $XmlElement) : base($XmlElement)
    {
        # Validate the XML root element
        $this.ValidateXmlElement(
            $XmlElement, [UmsAeEntity]::NamespaceUri.Music, "work")

        # Optional 'catalogIds' element
        if ($XmlElement.catalogIds)
        {
            $this.BuildCatalogIds(
                $this.GetOneXmlElement(
                    $XmlElement,
                    [UmsAeEntity]::NamespaceUri.Music,
                    "catalogIds"))
        }

        # Optional 'inception' element
        if ($XmlElement.inception)
        {
            $this.Inception = (
                [EntityFactory]::GetEntity(
                    $this.GetOneXmlElement(
                        $XmlElement,
                        [UmsAeEntity]::NamespaceUri.Music,
                        "inception")))
        }

        # Optional 'completion' element
        if ($XmlElement.completion)
        {
            $this.Completion = (
                [EntityFactory]::GetEntity(
                    $this.GetOneXmlElement(
                        $XmlElement,
                        [UmsAeEntity]::NamespaceUri.Music,
                        "completion")))
        }

        # Optional 'premiere' element
        if ($XmlElement.premiere)
        {
            $this.Premiere = (
                [EntityFactory]::GetEntity(
                    $this.GetOneXmlElement(
                        $XmlElement,
                        [UmsAeEntity]::NamespaceUri.Music,
                        "premiere")))
        }
        
        # Mandatory 'composers' element (collection of 'composer' elements)
        $this.BuildComposers(
            $this.GetOneXmlElement(
                $XmlElement, [UmsAeEntity]::NamespaceUri.Music, "composers"))

        # Mandatory 'instruments' element (collection of 'instrument' elements)
        $this.BuildInstruments(
            $this.GetOneXmlElement(
                $XmlElement, [UmsAeEntity]::NamespaceUri.Music, "instruments"))

        # Mandatory 'form' element
        $this.Form = [EntityFactory]::GetEntity(
            $this.GetOneXmlElement(
                $XmlElement, [UmsAeEntity]::NamespaceUri.Music, "form"))

        # Mandatory 'style' element
        $this.Style = [EntityFactory]::GetEntity(
            $this.GetOneXmlElement(
                $XmlElement, [UmsAeEntity]::NamespaceUri.Music, "style"))
        
        # Mandatory 'sections' element (collection of 'section' elements)
        $this.BuildSections(
            $this.GetOneXmlElement(
                $XmlElement, [UmsAeEntity]::NamespaceUri.Music, "sections"))
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

    # Sub-constructor for the 'instruments' element
    [void] BuildInstruments([System.Xml.XmlElement] $InstrumentsElement)
    {
        $this.GetOneOrManyXmlElement(
            $InstrumentsElement,
            [UmsAeEntity]::NamespaceUri.Music,
            "instrument"
        ) | foreach {
                $this.Instruments += [EntityFactory]::GetEntity($_) }
    }   

    # Sub-constructor for the 'sections' element
    [void] BuildSections([System.Xml.XmlElement] $SectionsElement)
    {
        $this.GetOneOrManyXmlElement(
            $SectionsElement,
            [UmsAeEntity]::NamespaceUri.Music,
            "section"
        ) | foreach {
                $this.Sections += [EntityFactory]::GetEntity($_) }
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
        $_string += ([UmsMceWork]::ComposerListPrefix)
        $_string += ($_composers -join(
            [UmsMceWork]::ComposerDelimiter))
        $_string += ([UmsMceWork]::ComposerListSuffix)
        $_addSpace = $true

        # Include work title. We use the ToString() method from the
        # UmsBaeProduct base type to get the string.
        # Add space, if needed
        if ($_addSpace) { $_string += ([UmsAeEntity]::NonBreakingSpace) }

        # Add work title to the buffer
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
            $_string += ([UmsMceWork]::CatalogIdListPrefix)
            $_string += ($_catalogIds -join(
                [UmsMceWork]::CatalogIdDelimiter))
            $_string += ([UmsMceWork]::CatalogIdListSuffix)
            $_addSpace = $true
        }

        return $_string
    }

}