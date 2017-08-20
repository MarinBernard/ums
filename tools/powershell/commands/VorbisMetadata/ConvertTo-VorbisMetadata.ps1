function ConvertTo-VorbisMetadata
{
    <#
    .SYNOPSIS
    Converts UMS metadata, either live entity or cached metadata, to Vorbis Comment.
    
    .DESCRIPTION
    This command converts a set of UMS metadata to Vorbis Comments. The conversion process is complex and can't be reverted, as the resulting metadata will not fit the original entities one for one. Thus, this command will only process UmsManagedFile instances which have a Sidecar or Orphan cardinality, and which embed a umsa:albumTrackBinding binding element.
    
    .PARAMETER ManagedFile
    An instance of the UmsManagedFile class, as returned by the Get-UmsManagedFile command, with a Sidecar or Orphan cardinality and a umsa:albumTrackBinding binding element.

    .EXAMPLE
    Get-UmsManagedFile -Path "D:\MyMusic" -Filter "track01*" | ConvertTo-VorbisMetadata
    #>

    [CmdletBinding(DefaultParametersetName='None')]
    Param(
        [Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true)]
        [ValidateNotNull()]
        [UmsManagedFile] $ManagedFile
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
            $Validator.Validate($ManagedFile)
        }
        catch [CVValidationFailureException]
        {
            # Validation failure
            [EventLogger]::LogException($_.Exception)
            [EventLogger]::LogError($Messages.ConstraintValidationFailure)
            throw [UmsPublicCommandFailureException]::New(
                "ConvertTo-VorbisMetadata")
        }
        catch
        {
            # All other exceptions are also terminating
            [EventLogger]::LogException($_.Exception)
            throw [UmsPublicCommandFailureException]::New(
                "ConvertTo-VorbisMetadata")
        }        

        # Try to obtain an entity or cached metadata
        [object] $_metadata = $null
        try
        {
            $_metadata = $ManagedFile | Get-UmsEntity
        }
        catch
        {
            [EventLogger]::LogException($_.Exception)
            throw [UmsPublicCommandFailureException]::New(
                "ConvertTo-VorbisMetadata")
        }         
        
        # Start conversion
        try
        {
            $Converter.Convert($_metadata)
        }
        catch [VorbisCommentConverterException]
        {
            # Conversion failure
            [EventLogger]::LogException($_.Exception)
            [EventLogger]::LogError($Messages.ConverterInvocationFailure)
            throw [UmsPublicCommandFailureException]::New(
                "ConvertTo-VorbisMetadata")
        }
        catch
        {
            # All other exceptions are also terminating
            [EventLogger]::LogException($_.Exception)
            throw [UmsPublicCommandFailureException]::New(
                "ConvertTo-VorbisMetadata")
        }        
    }
}