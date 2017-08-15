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
            Test-ConstraintValidation  -Item $ManagedItem  -Constraints $_constraints
        }
        catch [ConstraintValidationFailure]
        {
            Write-Error $_.Exception.MainMessage
            throw [UmsManagedItemMetadataConversionFailure]::New($ManagedItem)
        }

        # Instantiate a converter instance
        try
        {
            $_converter = [VorbisCommentConverter] $_options
        }
        catch
        {
            Write-Error $_.Exception.Message
            throw [UmsManagedItemMetadataConversionFailure]::New($ManagedItem)
        }

        # Get item metadata
        $metadata = $ManagedItem | Get-UmsMetadata

        # Start conversion
        try
        {
            $_converter.Convert($metadata)
        }
        catch [UmsException]
        {
            Write-Error -Message $_.Exception.MainMessage
            throw [UmsManagedItemMetadataConversionFailure]::New($ManagedItem)
        }
    }
}