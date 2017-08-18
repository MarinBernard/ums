function ConvertTo-ForeignMetadata
{
    Param(
        [Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true)]
        [ValidateNotNull()]
        [UmsFile] $File,

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
                $_outputFileFullName = $($File.LinkedFileBaseName + ".tags")
                $_arguments = @{
                    OutputMode = "VORBIS";
                }
            }

            "RawLyrics"
            {
                # Build transform arguments
                $_outputFileFullName = $($File.LinkedFileBaseName + ".txt")
                $_arguments = @{
                    OutputMode = "RAWLYRICS";
                }
            }
        }

        # Validate stylesheet constraints
        try
        {
            $Validator.Validate($File)
        }
        catch [CVValidationFailureException]
        {
            [EventLogger]::LogException($_.Exception)
            throw($_.Exception)
        }
        
        # Expired static version warning
        if ($File.StaticVersion -eq [FileVersionStatus]::Expired)
        {
            [EventLogger]::LogWarning($ModuleStrings.Common.ExpiredStaticVersion)
            if( (Wait-UserConfirmation) -eq $false ){ return }
        }       
        
        # Orphan cardinality warning
        if ($File.Cardinality -eq [FileCardinality]::Orphan)
        {
            [EventLogger]::LogWarning($ModuleStrings.Common.OrphanCardinalityWarning)
            if( (Wait-UserConfirmation) -eq $false ){ return }
        }

        # Run the transform
        try 
        {
            Invoke-XslTransformer -Source $File.StaticFileUri -Stylesheet $Stylesheet.Uri -Destination $_outputFileFullName -Arguments $_arguments
        }
        catch [UmsException]
        {
            [EventLogger]::LogException($_.Exception)
            throw($_.Exception)
        }        
        catch [System.Exception]
        {
            [EventLogger]::LogException($_.Exception)
            throw($_.Exception)
        }
    }
}