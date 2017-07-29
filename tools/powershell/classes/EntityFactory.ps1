###############################################################################
#   Static factory class EntityFactory
#==============================================================================
#
#   This class is a factory in charge of instantiating entity classes derivated
#   from the UmsEntity parent class. The class decides which entity type to
#   instantiate from the local name and namespace URI of the supplied XML
#   document. It also maintains a static cache of instantiated objects to
#   avoid instantiating the same entity twice.
#
###############################################################################

class EntityFactory
{
    ###########################################################################
    # Static properties
    ###########################################################################

    # Element cache
    static [CachedEntity[]] $EntityCache

    # Total number of instantations
    static [int] $InstantiationCount = 0
    # Total number of cache hits
    static [int] $CacheHitCount = 0
    # Total number of cache misses
    static [int] $CacheMissCount = 0
    # Total number of entities uneligible to cache
    static [int] $CacheSkipCount = 0       

    ###########################################################################
    # Factory method
    ###########################################################################

    # Returns an instance of an entity class.
    static [UmsAeEntity] GetEntity([System.Xml.XmlElement] $XmlElement)
    {
        # If the Xml element is null, we halt there
        if ($XmlElement -eq $null) { throw [NullXmlElementException] }

        # If the XML element has a 'uid' attribute, it is eligible to caching,
        # and might even be a UMS reference.
        if ($XmlElement.HasAttribute("uid"))
        {
            # If the XML element is a UMS reference, we cannot handle it.
            if ($XmlElement.ChildNodes.Count -eq 0)
            {
                throw [UnhandlableUmsReferenceException]::New(
                    $XmlElement.NamespaceUri,
                    $XmlElement.LocalName,
                    $XmlElement.Uid)
            }
            
            # Else, check whether the element is already cached, and return
            # the cached instance if it is.
            if ([EntityFactory]::HasCachedEntity($XmlElement))
                { return [EntityFactory]::GetCachedEntity($XmlElement) }
            # If not cached, instantiate, cache, then return.
            else
            {
                # Increase cache miss count
                [EntityFactory]::CacheMissCount += 1

                $_instance = [EntityFactory]::NewEntity($XmlElement)
                [EntityFactory]::AddCachedEntity($_instance)
                return $_instance
            }
        }

        # Else, the entity is not eligible to cache
        # Increase cache skip count
        [EntityFactory]::CacheSkipCount += 1

        # Return an uncached entity
        return [EntityFactory]::NewEntity($XmlElement)
    }

    ###########################################################################
    # Entity creator
    ###########################################################################

    # Creates and returns an entity instance from an Xml element.
    static [UmsAeEntity] NewEntity([System.Xml.XmlElement] $XmlElement)
    {
        # Increase instantiation count
        [EntityFactory]::InstantiationCount += 1

        # Base namespace
        if ($XmlElement.NamespaceUri -eq [UmsAeEntity]::NamespaceUri["Base"])
        {
            switch ($XmlElement.LocalName)
            {
                "birth"
                    { return New-Object -Type UmsBceBirth($XmlElement) }
                "character"
                    { return New-Object -Type UmsBceCharacter($XmlElement) }                    
                "city"
                    { return New-Object -Type UmsBceCity($XmlElement) }
                "country"
                    { return New-Object -Type UmsBceCountry($XmlElement) }
                "countryState"
                    { return New-Object -Type UmsBceCountryState($XmlElement) }
                "death"
                    { return New-Object -Type UmsBceDeath($XmlElement) }                 
                "labelVariant"
                    { return New-Object -Type UmsBceLabelVariant($XmlElement) }
                "linkVariant"
                    { return New-Object -Type UmsBceLinkVariant($XmlElement) }
                "nameVariant"
                    { return New-Object -Type UmsBceNameVariant($XmlElement) }
                "place"
                    { return New-Object -Type UmsBcePlace($XmlElement) }
                "standardId"
                    { return New-Object -Type UmsBceStandardId($XmlElement) }
                "titleVariant"
                    { return New-Object -Type UmsBceTitleVariant($XmlElement) }
            }
        }

        # Music namespace
        elseif (
            $XmlElement.NamespaceUri -eq [UmsAeEntity]::NamespaceUri["Music"])
        {
            switch ($XmlElement.LocalName)
            {
                "catalog"
                    { return New-Object -Type UmsMceCatalog($XmlElement) }
                "catalogId"
                    { return New-Object -Type UmsMceCatalogId($XmlElement) }
                "completion"
                    { return New-Object -Type UmsMceCompletion($XmlElement) }
                "composer"
                    { return New-Object -Type UmsMceComposer($XmlElement) }
                "conductor"
                    { return New-Object -Type UmsMceConductor($XmlElement) }
                "ensemble"
                    { return New-Object -Type UmsMceEnsemble($XmlElement) }                    
                "form"
                    { return New-Object -Type UmsMceForm($XmlElement) }
                "inception"
                    { return New-Object -Type UmsMceInception($XmlElement) }
                "instrument"
                    { return New-Object -Type UmsMceInstrument($XmlElement) }
                "instrumentalist"
                    { return New-Object -Type UmsMceInstrumentalist($XmlElement) }                    
                "key"
                    { return New-Object -Type UmsMceKey($XmlElement) }
                "lyricist"
                    { return New-Object -Type UmsMceLyricist($XmlElement) }   
                "movement"
                    { return New-Object -Type UmsMceMovement($XmlElement) }                    
                "place"
                    { return New-Object -Type UmsMcePlace($XmlElement) }
                "performance"
                    { return New-Object -Type UmsMcePerformance($XmlElement) }
                "premiere"
                    { return New-Object -Type UmsMcePremiere($XmlElement) }
                "section"
                    { return New-Object -Type UmsMceSection($XmlElement) }
                "style"
                    { return New-Object -Type UmsMceStyle($XmlElement) }
                "venue"
                    { return New-Object -Type UmsMceVenue($XmlElement) }   
                "work"
                    { return New-Object -Type UmsMceWork($XmlElement) }
            }
        }

        # Audio namespace
        elseif (
            $XmlElement.NamespaceUri -eq [UmsAeEntity]::NamespaceUri["Audio"])
        {
            switch ($XmlElement.LocalName)
            {
                "album"
                    { return New-Object -Type UmsAceAlbum($XmlElement) }
                "label"
                    { return New-Object -Type UmsAceLabel($XmlElement) }                    
            }
        }

        # Unknown namespace or element
        throw [ClassLookupFailureException]::New(
            $XmlElement.NamespaceUri, $XmlElement.LocalName)
    }

    ###########################################################################
    # Cache methods
    ###########################################################################

    # Searches the cache for a cached entity. Returns $true if a match is
    # found, $false otherwise.
    static [bool] HasCachedEntity([System.Xml.XmlElement] $XmlElement)
    {
        # Return false if the cache is empty
        if ([EntityFactory]::EntityCache.Count -eq 0){ return $false }

        return (([EntityFactory]::EntityCache | Where-Object {
            ($_.XmlNamespaceUri -eq $XmlElement.NamespaceUri) -and
            ($_.XmlElementName -eq $XmlElement.LocalName)    -and
            ($_.Uid -eq $XmlElement.Uid) }).Count -eq 1)
    }

    # Returns the instance of a cached entity
    static [UmsAeEntity] GetCachedEntity([System.Xml.XmlElement] $XmlElement)
    {
        # Increase cache hit count
        [EntityFactory]::CacheHitCount += 1

        return ([EntityFactory]::EntityCache | Where-Object {
            ($_.XmlNamespaceUri -eq $XmlElement.NamespaceUri) -and
            ($_.XmlElementName -eq $XmlElement.LocalName)   -and
            ($_.Uid -eq $XmlElement.Uid)}).Instance
    }

    # Adds an entity instance to the cache
    static [void] AddCachedEntity([UmsAeEntity] $Instance)
    {
        [EntityFactory]::EntityCache += (
            New-Object -Type CachedEntity -ArgumentList @(
                $Instance.XmlNamespaceUri,
                $Instance.XmlElementName,
                $Instance.Uid,
                $Instance
            )
        )
    }

    ###########################################################################
    # Statistic methods
    ###########################################################################

    # Show statistics
    static [void] GetStatistics()
    {
        Write-Host "Number of instances created:" $([EntityFactory]::InstantiationCount)
        Write-Host "Cache size:" $([EntityFactory]::EntityCache.Count)
        Write-Host "Cache skips:" $([EntityFactory]::CacheSkipCount)
        Write-Host "Cache hits:" $([EntityFactory]::CacheHitCount)
        Write-Host "Cache misses:" $([EntityFactory]::CacheMissCount)
        Write-Host "Cache hit ratio:" ($([EntityFactory]::CacheHitCount) / $([EntityFactory]::CacheMissCount))
    }
}