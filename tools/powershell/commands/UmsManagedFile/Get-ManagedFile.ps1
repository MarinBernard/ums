function Get-ManagedFile
{
    <#
    .SYNOPSIS
    Returns a list of managed UMS files for the specified folder.
    
    .DESCRIPTION
    This command lists all managed UMS files available for the specified folder.
    
    .PARAMETER Filter
    Allows to specify a file name filter. This parater is similar to the -Filter parameter of Get-ChildItem.

    .PARAMETER Path
    A path to a UMS-management-enabled folder. Default is to use the current folder.

    .PARAMETER Cardinality
    Filters UMS files according to their cardinality. By default, the command returns UMS items with any cardinality. Use this parameter to filter the command output. Sidecar cardinality applies to UMS files which are linked to a companion file in the parent folder. Such files are XML documents beginning with a 'umsb:file' root element, which 'binds' the companion file to specific metadata. 'Orphan' cardinality applies to Sidecar items which are missing a companion file. 'Independent' cardinality applies to any other kind of UMS item.

    .EXAMPLE
    Get-UmsManagedFile -Path "D:\MyMusic"
    #>

    [CmdletBinding(DefaultParametersetName='None')]
    Param(
        [Parameter(Position=0)]
        [string] $Filter = "*",

        [Parameter(Position=1,ValueFromPipeline=$true)]
        [System.IO.DirectoryInfo] $Path,

        [ValidateSet("All", "Independent", "Sidecar", "Orphan")]
        [string[]] $Cardinality = "Any"
    )

    Begin
    {
        # Shortcut to messages
        $Messages = $ModuleStrings.Commands
    }

    Process
    {
        # Use local path if no path was specified
        if ($Path -eq $null) { $Path = Get-Item -Path "." }

        # Test management state: catch any exception and abort.
        try
        {
            $_managementIsEnabled = [FileManager]::TestManagement($Path)
        }
        catch
        {
            [EventLogger]::LogException($_.Exception)
            [EventLogger]::LogWarning($Messages.InconsistentState)
            [EventLogger]::LogWarning($Messages.RunCommandAdvice `
                -f "Test-UmsItemManagement")
            return
        }

        # We only list managed files if management is enabled.
        if (-not $_managementIsEnabled)
        {
            [EventLogger]::LogWarning($Messages.ManagementDisabled)
            return
        }

        # Get the collection of UmsManagedFile instances
        [UmsManagedFile[]] $managedFiles = $null
        try
        {
            $_managedFiles = [FileManager]::GetManagedFiles($Path, $Filter)
        }
        catch [FileManagerException]
        {
            [EventLogger]::LogException($_.Exception)
            [EventLogger]::LogError($Messages.CommandFailure)
            return
        }

        return $_managedFiles
    }
}