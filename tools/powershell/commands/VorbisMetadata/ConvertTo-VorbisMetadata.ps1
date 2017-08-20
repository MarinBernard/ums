function ConvertTo-VorbisMetadata
{
    <#
    .SYNOPSIS
    Converts UMS metadata to Vorbis Comments.
    
    .DESCRIPTION
    This command converts metadata to Vorbis Comments. The conversion process is complex, and the resulting metadata will not fit the original entities one for one. This, this command will only perform conversion on UmsManagedFile instances which have a Sidecar or Orphan cardinality, and embed a umsa:albumTrackBinding binding element.
    
    .PARAMETER ManagedItem
    An instance of the UmsManagedFile class, as returned by the Get-UmsManagedFile command, with a Sidecar or Orphan cardinality and a umsa:albumTrackBinding binding element.

    .EXAMPLE
    Get-UmsManagedFile -Path "D:\MyMusic" -Filter "track01*" | ConvertTo-VorbisMetadata
    #>

    [CmdletBinding(DefaultParametersetName='None')]
    Param(
        [Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true)]
        [ValidateNotNull()]
        [UmsManagedFile] $ManagedItem
    )

    Begin
    {
        # Shortcut to messages
        $Messages = $ModuleStrings.Commands

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
        # Validation failure
        catch [CVValidationFailureException]
        {
            [EventLogger]::LogException($_.Exception)
            [EventLogger]::LogError($Messages.ConstraintValidationFailure)
            throw [UmsPublicCommandFailureException]::New(
                "ConvertTo-VorbisMetadata")
        }
        # All other exceptions are also terminating
        catch
        {
            [EventLogger]::LogException($_.Exception)
            throw [UmsPublicCommandFailureException]::New(
                "ConvertTo-VorbisMetadata")
        }        

        # Get item metadata
        $metadata = $ManagedItem | Get-UmsMetadata

        # Start conversion
        try
        {
            $Converter.Convert($metadata)
        }
        # Converter failure
        catch [VorbisCommentConverterException]
        {
            [EventLogger]::LogException($_.Exception)
            [EventLogger]::LogError($Messages.ConverterInvocationFailure)
            throw [UmsPublicCommandFailureException]::New(
                "ConvertTo-VorbisMetadata")
        }
        # All other exceptions are also terminating
        catch
        {
            [EventLogger]::LogException($_.Exception)
            throw [UmsPublicCommandFailureException]::New(
                "ConvertTo-VorbisMetadata")
        }        
    }
}