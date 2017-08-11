function Remove-UmsItem
{
    <#
    .SYNOPSIS
    Removes an item from the UMS store.
    
    .DESCRIPTION
    This command removes all versions of a UMS item from the UMS store.
    
    .PARAMETER Item
    An instance of the UmsItem class, as returned by the Get-UmsItem command.

    .PARAMETER WithCompanion
    If this parameter is specified, the command will also remove the companion file of the UMS item, if it exists.

    .PARAMETER Confirm
    Whether the command will ask the user to confirm each file deletion.

    .EXAMPLE
    Get-UmsItem -Path "D:\MyMusic" -Filter "uselessFile" | Remove-UmsItem
    #>

    [CmdletBinding(DefaultParametersetName='None')]
    Param(
        [Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true)]
        [ValidateNotNull()]
        [UmsItem[]] $Item,

        [switch] $WithCompanion,

        [bool] $Confirm = $true
    )

    Process
    {
        # Remove cached metadata
        try
        {
            Remove-Item -Force -Confirm:$Confirm -Path $Item.CacheFileFullName
            $Item.UpdateCacheInfo()
        }
        catch [System.IO.IOException]
        {
            Write-Warning -Message (
                $ModuleStrings.RemoveUmsItem.CacheFileRemovalFailure)
        }

        # Remove static version
        try
        {
            Remove-Item -Force -Confirm:$Confirm -Path $Item.StaticFileFullName
            $Item.UpdateStaticInfo()
        }
        catch [System.IO.IOException]
        {
            Write-Warning -Message (
                $ModuleStrings.RemoveUmsItem.StaticFileRemovalFailure)
        }

        # Remove companion file
        if (($WithCompanion.IsPresent) -and
            ($Item.Cardinality -eq [UICardinality]::Sidecar))
        {
            try
            {
                Remove-Item -Force -Confirm:$Confirm -Path $Item.LinkedFileFullName
                $Item.UpdateCardinalityInfo()
            }
            catch [System.IO.IOException]
            {
                Write-Warning -Message (
                    $ModuleStrings.RemoveUmsItem.CompanionFileRemovalFailure)
            }
        }

        # Remove the UMS file
        try
        {
            Remove-Item -Force -Confirm:$Confirm -Path $Item.FullName
        }
        catch [System.IO.IOException]
        {
            Write-Warning -Message (
                $ModuleStrings.RemoveUmsItem.UmsFileRemovalFailure)
        }
    }
}