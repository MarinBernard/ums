function ConvertTo-VorbisMetadata
{
    <#
    .SYNOPSIS
    Converts UMS metadata to Vorbis Comments.
    
    .DESCRIPTION
    This command converts metadata to Vorbis Comments. The conversion process is complex, and the resulting metadata will not fit the original entities one for one. This, this command will only perform conversion on UmsManagedItem instances which have a Sidecar or Orphan cardinality, and embed a umsa:albumTrackBinding binding element.
    
    .PARAMETER ManagedItem
    An instance of the UmsManagedItem class, as returned by the Get-UmsManagedItem command, with a Sidecar or Orphan cardinality and a umsa:albumTrackBinding binding element.

    .EXAMPLE
    Get-UmsManagedItem -Path "D:\MyMusic" -Filter "track01*" | ConvertTo-VorbisMetadata
    #>

    [CmdletBinding(DefaultParametersetName='None')]
    Param(
        [Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true)]
        [ValidateNotNull()]
        [UmsManagedItem] $ManagedItem
    )

    Begin
    {
        # Instantiate the constraint validator
        $Validator = [ConstraintValidator]::New(
            [ConfigurationStore]::GetConverterItem("VorbisComment").Constraints
        )

        # Instantiate the converter
        $Converter = [VorbisCommentConverter]::New(
            [ConfigurationStore]::GetConverterItem("VorbisComment").Options
        )
    }

    Process
    {
        # Validate constraints
        try
        {
            $Validator.Validate($ManagedItem)
        }
        catch [CVValidationFailureException]
        {
            [EventLogger]::LogException($_.Exception)
            throw [UmsManagedItemMetadataConversionFailure]::New($ManagedItem)
        }

        # Get item metadata
        $metadata = $ManagedItem | Get-UmsMetadata

        # Start conversion
        try
        {
            $Converter.Convert($metadata)
        }
        catch [VorbisCommentConverterException]
        {
            [EventLogger]::LogException($_.Exception)
            throw [UmsManagedItemMetadataConversionFailure]::New($ManagedItem)
        }
    }
}