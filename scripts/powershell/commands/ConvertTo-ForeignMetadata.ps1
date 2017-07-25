function ConvertTo-ForeignMetadata
{
    Param(
        [Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true)]
        [ValidateNotNull()]
        [UmsItem[]] $Item,

        [ValidateSet("VorbisComment", "RawLyrics")]
        [string] $Format = "VorbisComment"
    )

    Process
    {
        # Build transform arguments
        switch ($Format)
        {
            "VorbisComment"
            {
                # Select the music2vc stylesheet
                $_stylesheet = Get-UmsConfigurationItem -Type "Stylesheet" | Where-Object { $_.Id -eq "music2vc" }

                # Build transform arguments
                $_outputFileFullName = $($Item.LinkedFileBaseName + ".tags")
                $_arguments = @{
                    OutputMode = "VORBIS";
                }
            }

            "RawLyrics"
            {
                # Select the music2vc stylesheet
                $_stylesheet = Get-UmsConfigurationItem -Type "Stylesheet" | Where-Object { $_.Id -eq "music2vc" }

                # Build transform arguments
                $_outputFileFullName = $($Item.LinkedFileBaseName + ".txt")
                $_arguments = @{
                    OutputMode = "RAWLYRICS";
                }
            }
        }

        # Execute preliminary checks
        try
        {
            # Validate cardinality
            $_allowedCardinality = @([UmsItemCardinality]::Sidecar, [UmsItemCardinality]::Orphan)

            if ($_allowedCardinality -notcontains($Item.Cardinality))
                { throw $($ModuleStrings.Common.IncompatibleCardinality -f ($_allowedCardinality -join(","))) }

            if ($Item.Cardinality -eq [UmsItemCardinality]::Orphan)
            {
                Write-Warning -Message $ModuleStrings.Common.OrphanCardinalityWarning
                if( Wait-UserConfirmation -eq $false ){ return }
            }

            # Validate caching status
            $_allowedCachingStatus = @([UmsItemCachingStatus]::Current, [UmsItemCachingStatus]::Expired)

            if ($_allowedCachingStatus -notcontains($Item.CachingStatus))
                { throw $ModuleStrings.Common.MissingUmsItemCache }

            if ($Item.CachingStatus -eq [UmsItemCardinality]::Expired)
            {
                Write-Warning -Message $ModuleStrings.Common.ExpiredItemCache
                if( Wait-UserConfirmation -eq $false ){ return }
            }

            # Validate stylesheet constraints
            $_constraints = Get-UmsConfigurationItem -Type "StylesheetConstraint" | Where-Object { $_.Id -eq $_stylesheet.Id }
            
            foreach ($_constraint in $_constraints)
            {
                # Constraint on document element
                if ($_constraint.SubType -eq "DocumentElementConstraint")
                {
                    # Validate document namespace
                    if ($Item.XmlNamespace -ne $_constraint.DocumentNamespace)
                        { throw ($ModuleStrings.ConvertToForeignMetadata.BadDocumentNamespace -f $Item.XmlNamespace,$_constraint.DocumentNamespace) }

                    # Validate document element
                    if ($Item.XmlElementName -ne $_constraint.DocumentElement)
                        { throw ($ModuleStrings.ConvertToForeignMetadata.BadDocumentElement -f $Item.XmlElementName,$_constraint.DocumentElement) }

                    # Validate content binding, if specified
                    if ($_constraint.BindingNamespace)
                    {
                        # Validate binding namespace
                        if ($Item.BindingNamespace -ne $_constraint.BindingNamespace)
                            { throw ($ModuleStrings.ConvertToForeignMetadata.BadBindingNamespace -f $Item.BindingNamespace,$_constraint.BindingNamespace) }

                        # Validate binding element
                        if ($Item.BindingElementName -ne $_constraint.BindingElement)
                            { throw ($ModuleStrings.ConvertToForeignMetadata.BadBindingElement -f $Item.BindingElementName,$_constraint.BindingElement) }
                    }
                }
            }            
        }

        # Escape here on validation failure
        catch
        {
            Write-Error -Message $_.Exception.Message
            return
        }

        # Run the transform
        try 
        {
            Invoke-XslTransformer -Source $Item.CacheFileUri -Stylesheet $_stylesheet.Uri -Destination $_outputFileFullName -Arguments $_arguments
        }
        catch
        {
            Write-Error -Message $_.Exception.Message
            return
        }
    }
}