function Remove-ManagedFile
{
    <#
    .SYNOPSIS
    Removes a managed file from the UMS store.
    
    .DESCRIPTION
    This command removes all versions of a managed file from the UMS store.
    
    .PARAMETER ManagedFile
    An instance of the UmsManagedFile class, as returned by the Get-UmsManagedFile command.

    .PARAMETER WithContentFile
    If this parameter is specified, the command will also remove the content file linked to the UMS item, if it exists.

    .PARAMETER Confirm
    Whether the command will ask the user to confirm each file deletion.

    .EXAMPLE
    Get-UmsManagedFile -Path "D:\MyMusic" -Filter "uselessFile" | Remove-UmsManagedFile
    #>

    [CmdletBinding(DefaultParametersetName='None')]
    Param(
        [Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true)]
        [ValidateNotNull()]
        [UmsManagedFile] $ManagedFile,

        [switch] $WithContentFile,

        [bool] $Confirm = $true
    )
    
    Begin
    {
        # Shortcut to messages
        $Messages = $ModuleStrings.Commands
    }

    Process
    {
        # Remove the managed file
        try
        {
            if ($WithContentFile.IsPresent)
            {
                $ManagedFile.DeleteWithContentFile()
            }
            else
            {
                $ManagedFile.Delete()
            }
        }
        catch [UmsFileException]
        {
            [EventLogger]::LogException($_.Exception)
            [EventLogger]::LogError($Messages.FileDeletionFailure)
        }
    }
}