function Rename-UmsManagedItem
{
    <#
    .SYNOPSIS
    Renames an item in the UMS store.
    
    .DESCRIPTION
    This command renames all versions of a UMS item in the UMS store.
    
    .PARAMETER ManagedItem
    An instance of the UmsManagedItem class, as returned by the Get-UmsManagedItem command.

    .PARAMETER NewName
    The new name of the UMS item.

    .PARAMETER WithCompanion
    If this parameter is specified, the command will also rename the companion file of the UMS item, if it exists.

    .EXAMPLE
    Get-UmsManagedItem -Path "D:\MyMusic" -Filter "uselessFile" | Remove-UmsManagedItem
    #>

    [CmdletBinding(DefaultParametersetName='None')]
    Param(
        [Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true)]
        [ValidateNotNull()]
        [UmsManagedItem] $ManagedItem,

        [Parameter(Position=1,Mandatory=$true)]
        [ValidateNotNull()]
        [string] $NewName,

        [switch] $WithCompanion
    )

    Process
    {
        # Build paths
        $_newFileName = $NewName + $ManagedItem.Extension
        $_newFullFileName = Join-Path -Path $ManagedItem.Path -ChildPath $_newFileName

        # Prevent name collisions
        if (Test-Path $_newFullFileName)
        {
            throw "Another item with the same name already exists in the UMS store."
        }

        # Move cached metadata
        try
        {
            $_newPath = Join-Path -Path $ManagedItem.CachePath -ChildPath $_newFileName
            Move-Item -Force -Path $ManagedItem.CacheFileFullName -Destination $_newPath
        }
        catch [System.IO.IOException]
        {
            Write-Warning -Message (
                $ModuleStrings.RemoveUmsManagedItem.CacheFileRenameFailure)
        }

        # Move static version
        try
        {
            $_newPath = Join-Path -Path $ManagedItem.StaticPath -ChildPath $_newFileName
            Move-Item -Force -Path $ManagedItem.StaticFileFullName -Destination $_newPath
        }
        catch [System.IO.IOException]
        {
            Write-Warning -Message (
                $ModuleStrings.RemoveUmsManagedItem.StaticFileRenameFailure)
        }

        # Move companion file
        if (($WithCompanion.IsPresent) -and
            ($ManagedItem.Cardinality -eq [UmsItemCardinality]::Sidecar))
        {
            try
            {
                $_newPath = Join-Path -Path $ManagedItem.LinkedFilePath -ChildPath $NewName
                Move-Item -Force -Path $ManagedItem.LinkedFileFullName -Destination $_newPath
            }
            catch [System.IO.IOException]
            {
                Write-Warning -Message (
                    $ModuleStrings.RemoveUmsManagedItem.CompanionFileRenameFailure)
            }
        }

        # Move the UMS file
        try
        {
            Move-Item -Force -Path $ManagedItem.FullName -Destination $_newFullFileName
        }
        catch [System.IO.IOException]
        {
            Write-Warning -Message (
                $ModuleStrings.RemoveUmsManagedItem.UmsFileRemovalFailure)
        }

        # Return a fresh instance
        return New-Object -Type UmsManagedItem -ArgumentList $_newFullFileName
    }
}