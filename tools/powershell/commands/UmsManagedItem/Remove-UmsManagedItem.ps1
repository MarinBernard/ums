function Remove-UmsManagedItem
{
    <#
    .SYNOPSIS
    Removes a managed UMS item from the UMS store.
    
    .DESCRIPTION
    This command removes all versions of a managed item from the UMS store.
    
    .PARAMETER ManagedItem
    An instance of the UmsManagedItem class, as returned by the Get-UmsManagedItem command.

    .PARAMETER WithCompanion
    If this parameter is specified, the command will also remove the companion file of the UMS item, if it exists.

    .PARAMETER Confirm
    Whether the command will ask the user to confirm each file deletion.

    .EXAMPLE
    Get-UmsManagedItem -Path "D:\MyMusic" -Filter "uselessFile" | Remove-UmsManagedItem
    #>

    [CmdletBinding(DefaultParametersetName='None')]
    Param(
        [Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true)]
        [ValidateNotNull()]
        [UmsManagedItem] $ManagedItem,

        [switch] $WithCompanion,

        [bool] $Confirm = $true
    )

    Process
    {
        # Remove cached metadata
        try
        {
            Remove-Item -Force -Confirm:$Confirm -Path $ManagedItem.CacheFileFullName
            $ManagedItem.UpdateCacheInfo()
        }
        catch [System.IO.IOException]
        {
            Write-Warning -Message (
                $ModuleStrings.RemoveUmsManagedItem.CacheFileRemovalFailure)
        }

        # Remove static version
        try
        {
            Remove-Item -Force -Confirm:$Confirm -Path $ManagedItem.StaticFileFullName
            $ManagedItem.UpdateStaticInfo()
        }
        catch [System.IO.IOException]
        {
            Write-Warning -Message (
                $ModuleStrings.RemoveUmsManagedItem.StaticFileRemovalFailure)
        }

        # Remove companion file
        if (($WithCompanion.IsPresent) -and
            ($ManagedItem.Cardinality -eq [UmsItemCardinality]::Sidecar))
        {
            try
            {
                Remove-Item -Force -Confirm:$Confirm -Path $ManagedItem.LinkedFileFullName
                $ManagedItem.UpdateCardinalityInfo()
            }
            catch [System.IO.IOException]
            {
                Write-Warning -Message (
                    $ModuleStrings.RemoveUmsManagedItem.CompanionFileRemovalFailure)
            }
        }

        # Remove the UMS file
        try
        {
            Remove-Item -Force -Confirm:$Confirm -Path $ManagedItem.FullName
        }
        catch [System.IO.IOException]
        {
            Write-Warning -Message (
                $ModuleStrings.RemoveUmsManagedItem.UmsFileRemovalFailure)
        }
    }
}