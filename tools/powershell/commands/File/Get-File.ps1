function Get-File
{
    <#
    .SYNOPSIS
    Retrieves and returns a UMS file.
    
    .DESCRIPTION
    Retrieves and returns a UmsFile instance from a file.

    .EXAMPLE
    Get-UmsFile -Path "MyFile.ums"
    #>

    [CmdletBinding()]
    Param(
        [Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true)]
        [ValidateNotNull()]
        [System.IO.FileInfo] $Path
    )

    Begin
    {
        # Shortcut to messages
        $Messages = $ModuleStrings.Commands
    }

    Process
    {
        # Give up now if the file does not exist
        if (-not $Path.Exists)
        {
            [EventLogger]::LogError($Messages.FileNotFound)
            return
        }

        # Try to get a UmsFile instance
        try
        {
            $_file = [UmsFile]::New($Path)
        }
        catch [UmsFileException]
        {
            [EventLogger]::LogException($_.Exception)
            return
        }

        return $_file
    }
}