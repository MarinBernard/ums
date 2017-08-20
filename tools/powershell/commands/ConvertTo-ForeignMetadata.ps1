function ConvertTo-ForeignMetadata
{
    [CmdletBinding()]
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

        # Instantiate the XSLT transformer
        $Transformer = [XsltTransformer]::New($Stylesheet.Uri)
    }

    Process
    {
        # Build transform arguments
        switch ($Format)
        {
            "VorbisComment"
            {
                # Build transform arguments
                $_outputFileFullName = $($File.ContentFile.BaseName + ".tags")
                $_arguments = @{
                    OutputMode = "VORBIS";
                }
            }

            "RawLyrics"
            {
                # Build transform arguments
                $_outputFileFullName = $($File.ContentFile.BaseName + ".txt")
                $_arguments = @{
                    OutputMode = "RAWLYRICS";
                }
            }
        }

        # Validate stylesheet constraints
        try
        {
            $Validator.ValidateFile($File)
        }
        catch
        {
            [EventLogger]::LogException($_.Exception)
            [EventLogger]::LogError($Messages.ConstraintValidationFailure)
        }
        
        # Expired static version warning
        if ($File.StaticVersion -eq [FileVersionStatus]::Expired)
        {
            [EventLogger]::LogWarning($ModuleStrings.Common.ExpiredStaticVersion)
        }       
        
        # Orphan cardinality warning
        if ($File.Cardinality -eq [FileCardinality]::Orphan)
        {
            [EventLogger]::LogWarning($ModuleStrings.Common.OrphanCardinalityWarning)
        }

        # Run the transform
        try 
        {
            $Transformer.Transform($File.StaticFileUri, $_outputFileFullName, $_arguments)
        }
        catch [XsltTransformerException]
        {
            [EventLogger]::LogException($_.Exception)
            [EventLogger]::LogError($Messages.MetadataConversionFailure)
            return
        }
    }
}