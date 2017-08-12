function ConvertTo-VorbisMetadata
{
    <#
    .SYNOPSIS
    Converts UMS metadata to Vorbis Comments.
    
    .DESCRIPTION
    This command converts metadata to Vorbis Comments. The conversion process is complex, and the resulting metadata will not fit the original entities one for one. This, this command will only perform conversion on UmsItem instances which have a Sidecar or Orphan cardinality, and embed a umsa:albumTrackBinding binding element.
    
    .PARAMETER Item
    An instance of the UmsItem class, as returned by the Get-UmsItem command, with a Sidecar or Orphan cardinality and a umsa:albumTrackBinding binding element.

    .EXAMPLE
    Get-UmsItem -Path "D:\MyMusic" -Filter "uselessFile" | Remove-UmsItem
    #>

    [CmdletBinding(DefaultParametersetName='None')]
    Param(
        [Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true)]
        [ValidateNotNull()]
        [UmsItem] $Item
    )

    Begin
    {
        $_converterConfiguration = (
            Get-UmsConfigurationItem -Type Converter |
                Where-Object { $_.Name -eq "VorbisComment"})
        
        $_constraints = $_converterConfiguration.Constraints
        $_options = $_converterConfiguration.Options
    }

    Process
    {
        # Validate constraints
        try
        {
            Test-ConstraintValidation  -Item $Item  -Constraints $_constraints
        }
        catch [ConstraintValidationFailure]
        {
            Write-Error $_.Exception.MainMessage
            throw [UmsItemMetadataConversionFailure]::New($Item)
        }

        # Instantiate a converter instance
        try
        {
            $_converter = [VorbisCommentConverter] $_options
        }
        catch
        {
            Write-Error $_.Exception.Message
            throw [UmsItemMetadataConversionFailure]::New($Item)
        }

        # Get item metadata
        $metadata = Get-UmsMetadata -Item $Item

        # Start conversion
        try
        {
            $_converter.Convert($metadata)
        }
        catch [UmsException]
        {
            Write-Error -Message $_.Exception.MainMessage
            throw [UmsItemMetadataConversionFailure]::New($Item)
        }
    }
}