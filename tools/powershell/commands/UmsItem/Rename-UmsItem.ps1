function Rename-UmsItem
{
    <#
    .SYNOPSIS
    Renames an item in the UMS store.
    
    .DESCRIPTION
    This command renames all versions of a UMS item in the UMS store.
    
    .PARAMETER Item
    An instance of the UmsItem class, as returned by the Get-UmsItem command.

    .PARAMETER NewName
    The new name of the UMS item.

    .EXAMPLE
    Get-UmsItem -Path "D:\MyMusic" -Filter "uselessFile" | Remove-UmsItem
    #>

    [CmdletBinding(DefaultParametersetName='None')]
    Param(
        [Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true)]
        [ValidateNotNull()]
        [UmsItem[]] $Item,

        [Parameter(Position=1,Mandatory=$true)]
        [ValidateNotNull()]
        [string] $NewName
    )

    Process
    {
        # Build paths
        $_newFileName = $NewName + $Item.Extension
        $_newFullFileName = Join-Path -Path $Item.Path -ChildPath $_newFileName

        # Prevent name collisions
        if (Test-Path $_newFullFileName)
        {
            throw "Another item with the same name already exists in the UMS store."
        }

        # Move cached metadata
        try
        {
            $_newPath = Join-Path -Path $Item.CachePath -ChildPath $_newFileName
            Move-Item -Force -Path $Item.CacheFileFullName -Destination $_newPath
        }
        catch [System.IO.IOException]
        {
            Write-Warning -Message (
                $ModuleStrings.RemoveUmsItem.CacheFileRenameFailure)
        }

        # Move static version
        try
        {
            $_newPath = Join-Path -Path $Item.StaticPath -ChildPath $_newFileName
            Move-Item -Force -Path $Item.StaticFileFullName -Destination $_newPath
        }
        catch [System.IO.IOException]
        {
            Write-Warning -Message (
                $ModuleStrings.RemoveUmsItem.StaticFileRenameFailure)
        }

        # Move the UMS file
        try
        {
            Move-Item -Force -Path $Item.FullName -Destination $_newFullFileName
        }
        catch [System.IO.IOException]
        {
            Write-Warning -Message (
                $ModuleStrings.RemoveUmsItem.UmsFileRemovalFailure)
        }

        # Return a fresh instance
        return New-Object -Type UmsItem -ArgumentList $_newFullFileName
    }
}