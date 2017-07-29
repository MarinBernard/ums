﻿###############################################################################
#   Concrete entity class UmsMceMovement
#==============================================================================
#
#   This class describes a music movement entity, built from a 'movement'
#   XML element from the UMS music namespace. Movement entities describe a
#   movement from a musical work. They are grouped together by UmsMceSection
#   entities.
#
###############################################################################

class UmsMceMovement : UmsBaeProduct
{
    ###########################################################################
    # Static properties
    ###########################################################################

    # One or several characters which will be inserted between each form name.
    static [string] $FormDelimiter = 
        (Get-UmsConfigurationItem -ShortName "FormDelimiter")
    
    # One or several characters which will be inserted before a form list.
    static [string] $FormListPrefix = 
        (Get-UmsConfigurationItem -ShortName "FormListPrefix")

    # One or several characters which will be inserted after a form list.
    static [string] $FormListSuffix = 
        (Get-UmsConfigurationItem -ShortName "FormListSuffix")

    # Whether musical keys will be displayed as their short form.
    static [string] $PreferShortKeys = 
        (Get-UmsConfigurationItem -ShortName "PreferShortKeys")
    
    # One or several characters which will be inserted before a list of keys.
    static [string] $KeyListPrefix = 
        (Get-UmsConfigurationItem -ShortName "KeyListPrefix")

    # One or several characters which will be inserted after a list of keys.
    static [string] $KeyListSuffix = 
        (Get-UmsConfigurationItem -ShortName "KeyListSuffix")

    # One or several characters which will be inserted between each name
    # in a list of characters.
    static [string] $CharacterDelimiter = 
        (Get-UmsConfigurationItem -ShortName "CharacterDelimiter")
    
    # One or several characters which will be inserted before a list of
    # characters.
    static [string] $CharacterListPrefix = 
        (Get-UmsConfigurationItem -ShortName "CharacterListPrefix")

    # One or several characters which will be inserted after a list of
    # characters.
    static [string] $CharacterListSuffix = 
        (Get-UmsConfigurationItem -ShortName "CharacterListSuffix")
    
    # One or several characters which will be inserted before the title
    # of the movement.
    static [string] $MovementTitlePrefix = 
        (Get-UmsConfigurationItem -ShortName "MovementTitlePrefix")
    
    # One or several characters which will be inserted before a list of
    # tempo markings.
    static [string] $TempoMarkingListPrefix = 
        (Get-UmsConfigurationItem -ShortName "TempoMarkingListPrefix")
    
    # One or several characters which will be inserted after a list of
    # tempo markings.
    static [string] $TempoMarkingListSuffix = 
        (Get-UmsConfigurationItem -ShortName "TempoMarkingListSuffix")
    
    # One or several characters which will be inserted before an incipit.
    static [string] $IncipitPrefix = 
        (Get-UmsConfigurationItem -ShortName "IncipitPrefix")
    
    # One or several characters which will be inserted after an incipit.
    static [string] $IncipitSuffix = 
        (Get-UmsConfigurationItem -ShortName "IncipitSuffix")
    
    ###########################################################################
    # Hidden properties
    ###########################################################################

    ###########################################################################
    # Visible properties
    ###########################################################################

    [string]                $TempoMarking
    [string]                $Incipit
    [UmsBceCharacter[]]     $Characters
    [UmsMceLyricist[]]      $Lyricists
    [UmsMceKey]             $Key
    [UmsMceInstrument[]]    $Instruments
    [UmsMceForm[]]          $Forms
    [UmsMceCatalogId[]]     $CatalogIds

    ###########################################################################
    # Constructors
    ###########################################################################

    # Standard constructor.
    UmsMceMovement([System.Xml.XmlElement] $XmlElement) : base($XmlElement)
    {
        # Validate the XML root element
        $this.ValidateXmlElement(
            $XmlElement, [UmsAeEntity]::NamespaceUri.Music, "movement")

        # Optional 'tempoMarking' element
        if ($XmlElement.tempoMarking)
        {
            $this.TempoMarking = (
                $this.GetOneXmlElementValue(
                    $XmlElement,
                    [UmsAeEntity]::NamespaceUri.Music,
                    "tempoMarking"))
        }

        # Optional 'incipit' element
        if ($XmlElement.incipit)
        {
            $this.Incipit = (
                $this.GetOneXmlElementValue(
                    $XmlElement,
                    [UmsAeEntity]::NamespaceUri.Music,
                    "incipit"))
        }
        
        # Optional 'characters' element (collection of 'character' elements)
        if ($XmlElement.characters)
        {
            $this.BuildCharacters(
                $this.GetOneXmlElement(
                    $XmlElement,
                    [UmsAeEntity]::NamespaceUri.Base,
                    "characters"))     
        }

        # Optional 'lyricists' element (collection of 'lyricist' elements)
        if ($XmlElement.lyricists)
        {
            $this.BuildLyricists(
                $this.GetOneXmlElement(
                    $XmlElement,
                    [UmsAeEntity]::NamespaceUri.Music,
                    "lyricists"))     
        }
        
        # Optional 'key' element
        if ($XmlElement.key)
        {
            $this.Key = (
                [EntityFactory]::GetEntity(
                    $this.GetOneXmlElement(
                        $XmlElement,
                        [UmsAeEntity]::NamespaceUri.Music,
                        "key")))
        }

        # Mandatory 'instruments' element (collection of 'instrument' elements)
        $this.BuildInstruments(
            $this.GetOneXmlElement(
                $XmlElement,
                [UmsAeEntity]::NamespaceUri.Music,
                "instruments"))

        # Mandatory 'forms' element (collection of 'form' elements)
        $this.BuildForms(
            $this.GetOneXmlElement(
                $XmlElement, [UmsAeEntity]::NamespaceUri.Music, "forms"))
    
        # Optional 'catalogIds' element
        if ($XmlElement.catalogIds)
        {
            $this.BuildCatalogIds(
                $this.GetOneXmlElement(
                    $XmlElement,
                    [UmsAeEntity]::NamespaceUri.Music,
                    "catalogIds"))
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

    # Sub-constructor for the 'forms' element
    [void] BuildForms([System.Xml.XmlElement] $FormsElement)
    {
        $this.GetOneOrManyXmlElement(
            $FormsElement,
            [UmsAeEntity]::NamespaceUri.Music,
            "form"
        ) | foreach {
                $this.Forms += [EntityFactory]::GetEntity($_) }
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

    # Sub-constructor for the 'characters' element
    [void] BuildCharacters([System.Xml.XmlElement] $CharactersElement)
    {
        $this.GetOneOrManyXmlElement(
            $CharactersElement,
            [UmsAeEntity]::NamespaceUri.Base,
            "character"
        ) | foreach {
                $this.Characters += [EntityFactory]::GetEntity($_) }
    }
        
    # Sub-constructor for the 'lyricists' element
    [void] BuildLyricists([System.Xml.XmlElement] $LyricistsElement)
    {
        $this.GetOneOrManyXmlElement(
            $LyricistsElement,
            [UmsAeEntity]::NamespaceUri.Music,
            "lyricist"
        ) | foreach {
                $this.Lyricists += [EntityFactory]::GetEntity($_) }
    }

    ###########################################################################
    # Helpers
    ###########################################################################

    # Builds the full title of a music movement
    [string] ToString()
    {
        $_string = ""
        $_addSpace = $false

        # Show labels of all musical forms
        if ($this.Forms)
        {
            # Add space, if needed
            if ($_addSpace) { $_string += ([UmsAeEntity]::NonBreakingSpace) }

            # Get an array of form labels
            $_forms = @()
            foreach ($_form in $this.Forms)
                { $_forms += $_form.Label.FullLabel }

            # Add form names to the buffer
            $_string += ([UmsMceMovement]::FormListPrefix)
            $_string += ($_forms -join([UmsMceMovement]::FormDelimiter))
            $_string += ([UmsMceMovement]::FormListSuffix)
            $_addSpace = $true
        }

        # Show musical key
        if ($this.Key)
        {
            # Add space, if needed
            if ($_addSpace) { $_string += ([UmsAeEntity]::NonBreakingSpace) }

            # Get key value
            if ([UmsMceMovement]::PreferShortKeys)
                { $_key = $this.Key.Label.ShortLabel }
            else
                { $_key = $this.Key.Label.FullLabel }

            # Add musical key to the buffer
            $_string += ([UmsMceMovement]::KeyListPrefix)
            $_string += $_key
            $_string += ([UmsMceMovement]::KeyListSuffix)
            $_addSpace = $true
        }

        # Show character list
        if ($this.Characters)
        {
            # Add space, if needed
            if ($_addSpace) { $_string += ([UmsAeEntity]::NonBreakingSpace) }

            # Get an array of character names
            $_characters = @()
            foreach ($_character in $this.Characters)
                { $_characters += $_character.Name.ShortName }

            # Add musical key to the buffer
            $_string += ([UmsMceMovement]::CharacterListPrefix)
            $_string += ($_characters -join(
                [UmsMceMovement]::CharacterDelimiter))
            $_string += ([UmsMceMovement]::CharacterListSuffix)
            $_addSpace = $true
        }

        # Show movement title prefix
        $_string += ([UmsMceMovement]::MovementTitlePrefix)
        $_addSpace = $true

        # Include movement title, it defined. We use the ToString() method
        # from the UmsBaeProduct base type to get the string.
        $_fullTitle = ([UmsBaeProduct] $this).ToString()
        if ($_fullTitle)
        {
            # Add space, if needed
            if ($_addSpace) { $_string += ([UmsAeEntity]::NonBreakingSpace) }

            # Add movement title to the buffer
            $_string += $_fullTitle
            $_addSpace = $true
        }

        # Show tempo marking
        if ($this.TempoMarking)
        {
            # Add space, if needed
            if ($_addSpace) { $_string += ([UmsAeEntity]::NonBreakingSpace) }

            # Add tempo marking to the buffer
            $_string += ([UmsMceMovement]::TempoMarkingListPrefix)
            $_string += $this.TempoMarking
            $_string += ([UmsMceMovement]::TempoMarkingListSuffix)
            $_addSpace = $true
        }

        # Show incipit
        if ($this.Incipit)
        {
            # Add space, if needed
            if ($_addSpace) { $_string += ([UmsAeEntity]::NonBreakingSpace) }

            # Add incipit to the buffer
            $_string += ([UmsMceMovement]::IncipitPrefix)
            $_string += $this.Incipit
            $_string += ([UmsMceMovement]::IncipitSuffix)
            $_addSpace = $true
        }

        return $_string
    }
}