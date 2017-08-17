function ConvertTo-ForeignMetadata
{
    Param(
        [Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true)]
        [ValidateNotNull()]
        [UmsItem] $Item,

        [ValidateSet("VorbisComment", "RawLyrics")]
        [string] $Format = "VorbisComment"
    )

    Begin
    {
        # Select the stylesheet to use
        switch ($Format)
        {
            "VorbisComment"
            {
                # Select the music2vc stylesheet
                $Stylesheet = [ConfigurationStore]::GetStylesheetItem("music2vc")
            }

            "RawLyrics"
            {
                # Select the music2vc stylesheet
                $Stylesheet = [ConfigurationStore]::GetStylesheetItem("music2vc")
            }
        }

        # Instantiate the constraint validator
        $Validator = [ConstraintValidator]::New($Stylesheet.Constraints)
    }

    Process
    {
        # Build transform arguments
        switch ($Format)
        {
            "VorbisComment"
            {
                # Build transform arguments
                $_outputFileFullName = $($Item.LinkedFileBaseName + ".tags")
                $_arguments = @{
                    OutputMode = "VORBIS";
                }
            }

            "RawLyrics"
            {
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
            $Validator.Validate($Item)
        }
        catch [CVValidationFailureException]
        {
            Write-Error $_.Exception.MainMessage
            throw($_.Exception)
        }
        
        # Expired static version warning
        if ($Item.StaticVersion -eq [UmsItemVersionStatus]::Expired)
        {
            Write-Warning -Message $ModuleStrings.Common.ExpiredStaticVersion
            if( (Wait-UserConfirmation) -eq $false ){ return }
        }       
        
        # Orphan cardinality warning
        if ($Item.Cardinality -eq [UmsItemCardinality]::Orphan)
        {
            Write-Warning -Message $ModuleStrings.Common.OrphanCardinalityWarning
            if( (Wait-UserConfirmation) -eq $false ){ return }
        }

        # Run the transform
        try 
        {
            Invoke-XslTransformer -Source $Item.StaticFileUri -Stylesheet $Stylesheet.Uri -Destination $_outputFileFullName -Arguments $_arguments
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