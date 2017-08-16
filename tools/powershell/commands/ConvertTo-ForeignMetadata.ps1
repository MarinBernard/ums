function ConvertTo-ForeignMetadata
{
    Param(
        [Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true)]
        [ValidateNotNull()]
        [UmsItem] $Item,

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
                $_stylesheet = [ConfigurationStore]::GetStylesheetItem("music2vc")

                # Build transform arguments
                $_outputFileFullName = $($Item.LinkedFileBaseName + ".tags")
                $_arguments = @{
                    OutputMode = "VORBIS";
                }
            }

            "RawLyrics"
            {
                # Select the music2vc stylesheet
                $_stylesheet = [ConfigurationStore]::GetStylesheetItem("music2vc")

                # Build transform arguments
                $_outputFileFullName = $($Item.LinkedFileBaseName + ".txt")
                $_arguments = @{
                    OutputMode = "RAWLYRICS";
                }
            }
        }

        # Validate stylesheet constraints
        try
        {
            Test-ConstraintValidation `
                -Item $Item `
                -Constraints $_stylesheet.Constraints
        }
        catch [ConstraintValidationFailure]
        {
            Write-Error $_.Exception.MainMessage
            throw($_.Exception)
        }
        
        # Expired static version warning
        if ($Item.StaticVersion -eq [UIVersionStatus]::Expired)
        {
            Write-Warning -Message $ModuleStrings.Common.ExpiredStaticVersion
            if( (Wait-UserConfirmation) -eq $false ){ return }
        }       
        
        # Orphan cardinality warning
        if ($Item.Cardinality -eq [UICardinality]::Orphan)
        {
            Write-Warning -Message $ModuleStrings.Common.OrphanCardinalityWarning
            if( (Wait-UserConfirmation) -eq $false ){ return }
        }

        # Run the transform
        try 
        {
            Invoke-XslTransformer -Source $Item.StaticFileUri -Stylesheet $_stylesheet.Uri -Destination $_outputFileFullName -Arguments $_arguments
        }
        catch [UmsException]
        {
            Write-Error -Message $_.Exception.MainMessage
            throw($_.Exception)
        }        
        catch [System.Exception]
        {
            Write-Error -Exception $_.Exception
            throw($_.Exception)
        }
    }
}