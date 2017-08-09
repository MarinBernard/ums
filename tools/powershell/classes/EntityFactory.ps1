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

    # Properties below are used for UMS reference resolution.
    # Extension of UMS items
    static [string] $UmsFileExtension = (
        Get-UmsConfigurationItem -ShortName "UmsFileExtension")

    # Prefix of independent UMS items
    static [string] $UmsIndependentFilePrefix = (
        Get-UmsConfigurationItem -ShortName "UmsIndependentFilePrefix")

    ###########################################################################
    # Factory method
    ###########################################################################

    # Main entry point of the class. This method is a wrapper around GetEntity.
    # It handles document-related properties such as the sourcePathUri or
    # sourceUri properties, then delegates entity instantiation to GetEntity().
    static [UmsAeEntity] ParseDocument(
        [System.Uri] $Uri,
        [string] $Uid = "")
    {
        $_verbosePrefix = "[EntityFactory]::ParseDocument(): "
        Write-Verbose $($_verbosePrefix + "About to retrieve document with URI " + $Uri)
        
        # Read target document
        [System.Xml.XmlDocument] $_document = Invoke-RestMethod -Uri $Uri
        
        # Build source path URI
        $_sourcePathUri = [System.Uri]::New($Uri.AbsoluteUri.Substring(0, $Uri.AbsoluteUri.Length - $Uri.Segments[-1].Length)).AbsoluteUri
        Write-Verbose $($_verbosePrefix + "Built source path URI: " + $_sourcePathUri)

        # Get first usable element (for bindings only)
        if ($_document.DocumentElement.LocalName -eq "binding")
        {
            Write-Verbose $($_verbosePrefix + "Retrieved document is a binding entity from namespace " + $_document.DocumentElement.NamespaceURI)
            $_element = $_document.DocumentElement.SelectNodes("*")[0]
        }
        else { $_element = $_document.DocumentElement }

        # Log first usable element
        Write-Verbose $($_verbosePrefix + "First usable element is '" + $_element.LocalName + "' from namespace '" + $_element.NamespaceURI + "'")

        # Add transclusion attributes to the element
        $_element.SetAttribute("src", $Uri)
        if ($Uid) { $_element.SetAttribute("uid", $Uid) }

        # Start entity instantation
        return [EntityFactory]::GetEntity($_element, $_sourcePathUri, $Uri)
    }

    # Returns an instance of an entity class.
    static [UmsAeEntity] GetEntity(
        [System.Xml.XmlElement] $XmlElement,
        [string] $SourcePathUri,
        [string] $SourceFileUri)
    {
        # Verbose prefix
        $_verbosePrefix = "[EntityFactory]::GetEntity(): "

        # Log beginning
        Write-Verbose $($_verbosePrefix + "Beginning to process element '" + $XmlElement.LocalName + "' from namespace '"  + $XmlElement.NamespaceURI + "'.")

        # If the Xml element is null, we halt there
        if ($XmlElement -eq $null) { throw [NullXmlElementException] }

        # If the XML element has a 'uid' attribute, it is eligible to caching,
        # and might even be a UMS reference.
        if ($XmlElement.HasAttribute("uid"))
        {
            # If the XML element is a UMS reference, we need to perform a
            # cache lookup to check whether the reference has already been
            # instantiated.
            if ($XmlElement.ChildNodes.Count -eq 0)
            {
                Write-Verbose $($_verbosePrefix + "The XML element describes a UMS reference.")

                # If a cached entity already exists, we return it now
                if ([EntityFactory]::HasCachedEntity($XmlElement, $SourceFileUri))
                {
                    Write-Verbose $($_verbosePrefix + "A cached entity matching the element was found.")
                    return [EntityFactory]::GetCachedEntity($XmlElement, $SourceFileUri)
                }
                
                # Else, we need to resolve the reference.
                else
                {
                    Write-Verbose $($_verbosePrefix + "No cached entity matching the element was found. Beginning transclusion.")

                    # Gather all possible matches
                    $_uris = [EntityFactory]::GetForeignDocumentUri($XmlElement, $SourcePathUri)

                    # Test each candidate. First instantiated file wins.
                    [UmsAeEntity] $_instance = $null
                    foreach ($_uri in $_uris)
                    {
                        try
                        {
                            Write-Verbose $($_verbosePrefix + "Calling ParseDocument() with URI " + $_uri)
                            $_instance = [EntityFactory]::ParseDocument($_uri, $XmlElement.GetAttribute("uid"))
                        }
                        catch
                        {
                            Write-Verbose $($_verbosePrefix + "Recoverable instantiation failure.")
                            Write-Verbose $($_verbosePrefix + "Exception message: " + $_.Exception.Message)
                            continue
                        }
                    }

                    # If no instance was created, the reference is unresolved.
                    if ($_instance -eq $null)
                    {
                        throw [UnresolvableUmsReference]::New(
                            $XmlElement.NamespaceUri,
                            $XmlElement.LocalName,
                            $XmlElement.Uid,
                            $_uris)
                    }
                    
                    [EntityFactory]::AddCachedEntity($_instance)
                    return $_instance
                }
            }

            # Else, if the element has at least one child, it means the reference
            # does not need to be transcluded.
            else
            {
                Write-Verbose $($_verbosePrefix + "The XML element describes a UMS reference which has already been transcluded.")
                
                # Check whether the element is already cached, and return
                # the cached instance if it is.
                if ([EntityFactory]::HasCachedEntity($XmlElement, $SourceFileUri))
                {
                    Write-Verbose $($_verbosePrefix + "A cached entity matching the element was found.")
                    return [EntityFactory]::GetCachedEntity($XmlElement, $SourceFileUri)
                }
                # If not cached, instantiate, cache, then return.
                else
                {
                    # Increase cache miss count
                    Write-Verbose $($_verbosePrefix + "No cached entity matching the element was found.")
                    [EntityFactory]::CacheMissCount += 1

                    $_instance = [EntityFactory]::NewEntity($XmlElement, $SourceFileUri)
                    [EntityFactory]::AddCachedEntity($_instance)
                    return $_instance
                }
            }
        }

        # Else, the entity is not eligible to cache
        # Increase cache skip count
        Write-Verbose $($_verbosePrefix + "The XML element describes a regular UMS value which is not eligible to caching.")
        [EntityFactory]::CacheSkipCount += 1

        # Return an uncached entity
        return [EntityFactory]::NewEntity($XmlElement, $SourceFileUri)
    }

    ###########################################################################
    # Entity creator
    ###########################################################################

    # Creates and returns an entity instance from an Xml element. Parameters:
    #   - XmlElement is the source XML element from which the entity will be
    #       instantiated.
    #   - Uri is the absolute URI to the source file from which the calling
    #       entity was instantiated.
    static [UmsAeEntity] NewEntity(
        [System.Xml.XmlElement] $XmlElement,
        [System.Uri] $Uri)
    {
        # Verbose prefix
        $_verbosePrefix = "[EntityFactory]::NewEntity(): "

        # Increase instantiation count
        Write-Verbose $($_verbosePrefix + "Beginning entity instantiation from element '" + $XmlElement.LocalName + "' from namespace '" + $XmlElement.NamespaceURI + "'.")
        Write-Verbose $($_verbosePrefix + "Source URI is: " + $Uri)
        [EntityFactory]::InstantiationCount += 1

        # Audio namespace
        if (
            $XmlElement.NamespaceUri -eq [UmsAeEntity]::NamespaceUri["Audio"])
        {
            switch ($XmlElement.LocalName)
            {
                "album"
                    { return New-Object -Type UmsAceAlbum($XmlElement, $Uri) }
                "albumTrackBinding"
                    { return New-Object -Type UmsAceAlbumTrackBinding($XmlElement, $Uri) }
                "label"
                    { return New-Object -Type UmsAceLabel($XmlElement, $Uri) }
                "release"
                    { return New-Object -Type UmsAceRelease($XmlElement, $Uri) }                    
            }
        }

        # Base namespace
        elseif ($XmlElement.NamespaceUri -eq [UmsAeEntity]::NamespaceUri["Base"])
        {
            switch ($XmlElement.LocalName)
            {
                "birth"
                    { return New-Object -Type UmsBceBirth($XmlElement, $Uri) }
                "character"
                    { return New-Object -Type UmsBceCharacter($XmlElement, $Uri) }                    
                "city"
                    { return New-Object -Type UmsBceCity($XmlElement, $Uri) }
                "country"
                    { return New-Object -Type UmsBceCountry($XmlElement, $Uri) }
                "countryState"
                    { return New-Object -Type UmsBceCountryState($XmlElement, $Uri) }
                "death"
                    { return New-Object -Type UmsBceDeath($XmlElement, $Uri) }                 
                "labelVariant"
                    { return New-Object -Type UmsBceLabelVariant($XmlElement, $Uri) }
                "linkVariant"
                    { return New-Object -Type UmsBceLinkVariant($XmlElement, $Uri) }
                "nameVariant"
                    { return New-Object -Type UmsBceNameVariant($XmlElement, $Uri) }
                "place"
                    { return New-Object -Type UmsBcePlace($XmlElement, $Uri) }
                "standardId"
                    { return New-Object -Type UmsBceStandardId($XmlElement, $Uri) }
                "titleVariant"
                    { return New-Object -Type UmsBceTitleVariant($XmlElement, $Uri) }
            }
        }

        # Music namespace
        elseif (
            $XmlElement.NamespaceUri -eq [UmsAeEntity]::NamespaceUri["Music"])
        {
            switch ($XmlElement.LocalName)
            {
                "catalog"
                    { return New-Object -Type UmsMceCatalog($XmlElement, $Uri) }
                "catalogId"
                    { return New-Object -Type UmsMceCatalogId($XmlElement, $Uri) }
                "completion"
                    { return New-Object -Type UmsMceCompletion($XmlElement, $Uri) }
                "composer"
                    { return New-Object -Type UmsMceComposer($XmlElement, $Uri) }
                "conductor"
                    { return New-Object -Type UmsMceConductor($XmlElement, $Uri) }
                "ensemble"
                    { return New-Object -Type UmsMceEnsemble($XmlElement, $Uri) }                    
                "form"
                    { return New-Object -Type UmsMceForm($XmlElement, $Uri) }
                "inception"
                    { return New-Object -Type UmsMceInception($XmlElement, $Uri) }
                "instrument"
                    { return New-Object -Type UmsMceInstrument($XmlElement, $Uri) }
                "instrumentalist"
                    { return New-Object -Type UmsMceInstrumentalist($XmlElement, $Uri) }                    
                "key"
                    { return New-Object -Type UmsMceKey($XmlElement, $Uri) }
                "lyricist"
                    { return New-Object -Type UmsMceLyricist($XmlElement, $Uri) }   
                "movement"
                    { return New-Object -Type UmsMceMovement($XmlElement, $Uri) }                    
                "place"
                    { return New-Object -Type UmsMcePlace($XmlElement, $Uri) }
                "performance"
                    { return New-Object -Type UmsMcePerformance($XmlElement, $Uri) }
                "premiere"
                    { return New-Object -Type UmsMcePremiere($XmlElement, $Uri) }
                "publication"
                    { return New-Object -Type UmsMcePublication($XmlElement, $Uri) }
                "section"
                    { return New-Object -Type UmsMceSection($XmlElement, $Uri) }
                "style"
                    { return New-Object -Type UmsMceStyle($XmlElement, $Uri) }
                "venue"
                    { return New-Object -Type UmsMceVenue($XmlElement, $Uri) }   
                "work"
                    { return New-Object -Type UmsMceWork($XmlElement, $Uri) }
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
    static [bool] HasCachedEntity(
        [System.Xml.XmlElement] $XmlElement,
        [string] $SourceFileUri)
    {
        # Return false if the cache is empty
        if ([EntityFactory]::EntityCache.Count -eq 0){ return $false }

        return (([EntityFactory]::EntityCache | Where-Object {
            ($_.XmlNamespaceUri -eq $XmlElement.NamespaceUri) -and
            ($_.XmlElementName -eq $XmlElement.LocalName)     -and
            ($_.SourceUri -eq $SourceFileUri)                 -and
            ($_.Uid -eq $XmlElement.Uid) }).Count -eq 1)
    }

    # Returns the instance of a cached entity
    static [UmsAeEntity] GetCachedEntity(
        [System.Xml.XmlElement] $XmlElement,
        [string] $SourceFileUri)
    {
        # Increase cache hit count
        [EntityFactory]::CacheHitCount += 1

        return ([EntityFactory]::EntityCache | Where-Object {
            ($_.XmlNamespaceUri -eq $XmlElement.NamespaceUri) -and
            ($_.XmlElementName -eq $XmlElement.LocalName)     -and
            ($_.SourceUri -eq $SourceFileUri)                 -and
            ($_.Uid -eq $XmlElement.Uid)}).Instance
    }

    # Adds an entity instance to the cache
    static [void] AddCachedEntity([UmsAeEntity] $Instance)
    {
        # If the instance was created by transclusion, and that transclusion
        # targeted a file with a relative path, we cannot guarantee that a
        # future entity with the same UID should match the same instance.
        # In such a case, the instance bypasses the cache.
        if ($Instance.RelativeSource -eq $true){ return }

        # Else, we add the instance to the cache
        [EntityFactory]::EntityCache += (
            New-Object -Type CachedEntity -ArgumentList @(
                $Instance.XmlNamespaceUri,
                $Instance.XmlElementName,
                $Instance.Uid,
                $Instance.SourceFileUri,
                $Instance.RelativeSource,
                $Instance
            )
        )
    }

    ###########################################################################
    # Transclusion methods
    ###########################################################################

    # Returns a list of candidate URIs to the XML UMS document targeted by
    # a UMS reference.
    static [System.Uri[]] GetForeignDocumentUri(
        [System.Xml.XmlElement] $XmlElement,
        [System.Uri] $SourcePathUri)
    {
        # Verbose prefix
        $_verbosePrefix = "[EntityFactory]::GetForeignDocumentUri(): "

        # Names of the UMS file targeted by the reference
        $_fileName = $(
            $XmlElement.GetAttribute("uid") + `
            [EntityFactory]::UmsFileExtension)
        Write-Verbose $($_verbosePrefix + "Target file name is: " + $_fileName)
        $_independentFileName = $(
            [EntityFactory]::UmsIndependentFilePrefix + `
            $XmlElement.GetAttribute("uid") + `
            [EntityFactory]::UmsFileExtension)
        Write-Verbose $($_verbosePrefix + "Target independent file name is: " + $_independentFileName)
        
        # Relative URIs to the target file, in catalog and managed UMS
        # contexts.
        $_fileRelativeUri = (
            [System.Uri]::New($_fileName, [System.UriKind]::Relative))
        $_independentFileRelativeUri = (
            [System.Uri]::New($_independentFileName, [System.UriKind]::Relative))

        # Gather a list of potential catalog sub-paths
        [System.Uri[]] $_uris = [EntityFactory]::GetUmsCatalogCandidateUri(
            $XmlElement.NamespaceUri,
            $XmlElement.LocalName,
            $_fileRelativeUri)
        
        # Add candidate URIs built from relative paths
        $_uris += [System.Uri]::New($SourcePathUri, $_fileRelativeUri)
        $_uris += [System.Uri]::New($SourcePathUri, $_independentFileRelativeUri)
        
        # Log URI candidates
        foreach ($_uri in $_uris)
            {  Write-Verbose $($_verbosePrefix + "Found candidate URI: " + $_uri) }

        return $_uris
    }

    # Returns an array of locations to search for the target file of a UMS
    # reference. Each location is an absolute URI to a catalog sub-path.
    static [System.Uri[]] GetUmsCatalogCandidateUri(
        [string] $XmlNamespace,
        [string] $XmlElement,
        [System.Uri] $LeafUri)
    {
        # Verbose prefix
        $_verbosePrefix = "[EntityFactory]::GetUmsCatalogCandidateUri(): "
        Write-Verbose $($_verbosePrefix + "Searching candidate URIs in all configured catalogs for element '" + $XmlElement + "' from namespace '" + $XmlNamespace + "'.")

        [System.Uri[]] $_list = @()

        foreach ($_catalog in (Get-UmsConfigurationItem -Type Catalog))
        {
            Write-Verbose $($_verbosePrefix + "Evaluating catalog with id '" + $_catalog.Id + "' and namespace '" + $_catalog.XmlNamespace + "'.")

            if ($_catalog.XmlNamespace -eq $XmlNamespace)
            {
                Write-Verbose $($_verbosePrefix + "Catalog with id '" + $_catalog.Id + "' matches the element namespace.")
                $_catalogUri = [System.Uri]::New($_catalog.Uri)

                foreach ($_mapping in $_catalog.Mappings)
                {
                    if ($_mapping.Element -eq $XmlElement)
                    {
                        Write-Verbose $($_verbosePrefix + "Mapping with sub-path '" + $_mapping.SubPath + "' matches element name.")

                        $_mappingUri = (
                            [System.Uri]::New(
                                $($_mapping.SubPath + "/"), [System.UriKind]::Relative))
                        Write-Verbose $($_verbosePrefix + "Sub-path relative URI is: " + $_mappingUri)
                        
                        $_subPathUri = [System.Uri]::New($_catalogUri, $_mappingUri)
                        Write-Verbose $($_verbosePrefix + "Sub-path absolute URI is: " + $_subPathUri)

                        $_candidateUri = [System.Uri]::New($_subPathUri, $LeafUri)
                        Write-Verbose $($_verbosePrefix + "Candidate absolute URI is: " + $_candidateUri)

                        $_list += $_candidateUri
                    }
                }
            }
        }

        return $_list
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
        if ([EntityFactory]::CacheMissCount -gt 0)
        {
            Write-Host "Cache hit ratio:" ($([EntityFactory]::CacheHitCount) / $([EntityFactory]::CacheMissCount))
        }
    }
}