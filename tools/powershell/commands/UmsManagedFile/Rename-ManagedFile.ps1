function Rename-ManagedFile
{
    <#
    .SYNOPSIS
    Renames an managed file in the UMS store.
    
    .DESCRIPTION
    This command renames all versions of a UMS file in the UMS store. If the file has a sidecar cardinality, the content file will also be renamed.
    
    .PARAMETER ManagedItem
    An instance of the UmsManagedFile class, as returned by the Get-UmsManagedFile command.

    .PARAMETER NewName
    The new name of the UMS item.

    .EXAMPLE
    Get-UmsManagedFile -Path "D:\MyMusic" -Filter "uselessFile" | Rename-UmsManagedFile -NewName "usefulFile"
    #>

    [CmdletBinding(DefaultParametersetName='None')]
    Param(
        [Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true)]
        [ValidateNotNull()]
        [UmsManagedFile] $ManagedFile,

        [Parameter(Position=1,Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string] $NewName,

        [switch] $WithContentFile
    )

    Begin
    {
        # Shortcut to messages
        $Messages = $ModuleStrings.Commands
    }

    Process
    {
        # Do something
    }
}