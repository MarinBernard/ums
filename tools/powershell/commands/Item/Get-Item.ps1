function Get-Item
{
    <#
    .SYNOPSIS
    Retrieves and returns a UMS item from a file.
    
    .DESCRIPTION
    Retrieves and returns a UmsItem instance from a file.

    .EXAMPLE
    Get-UmsItem -Path "MyFile.ums"
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
        $Messages = $ModuleStrings.Commands.Item
    }

    Process
    {
        # Give up now if file does not exist
        if (-not $Path.Exists)
        {
            [EventLogger]::LogError($Messages.FileNotFound)
            return
        }

        # Try to get a UmsItem instance
        try
        {
            $_item = [UmsItem]::New($Path)
        }
        catch [UmsItemException]
        {
            [EventLogger]::LogException($_.Exception)
            return
        }

        return $_item
    }
}