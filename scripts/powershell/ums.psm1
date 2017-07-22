# Load module configuration
$global:ModuleConfig = Import-PowerShellDataFile -Path "$PSScriptRoot\configuration.psd1"

# Load localization
$global:ModuleStrings = Import-LocalizedData -FileName "messages.psd1"

# Include dependencies
. "$PSScriptRoot\helpers\Get-UmsMetadataFileName.ps1"
. "$PSScriptRoot\helpers\Get-UmsMetadataFolderPath.ps1"
. "$PSScriptRoot\helpers\Get-UmsSchemaFileName.ps1"
. "$PSScriptRoot\helpers\Run-UmsXmlValidation.ps1"
. "$PSScriptRoot\helpers\Read-XmlNamespaceURI.ps1"
. "$PSScriptRoot\helpers\Run-XmlValidation.ps1"
. "$PSScriptRoot\helpers\Run-XslTransform.ps1"
. "$PSScriptRoot\commands\ConvertTo-ForeignMetadata.ps1"
. "$PSScriptRoot\commands\Enable-UmsMetadata.ps1"
. "$PSScriptRoot\commands\Disable-UmsMetadata.ps1"
. "$PSScriptRoot\commands\Get-UmsItem.ps1"
. "$PSScriptRoot\commands\Test-UmsMetadata.ps1"
. "$PSScriptRoot\commands\Update-UmsCache.ps1"

# Export
Export-ModuleMember -Function ConvertTo-ForeignMetadata
Export-ModuleMember -Function Enable-UmsMetadata
Export-ModuleMember -Function Disable-UmsMetadata
Export-ModuleMember -Function Get-UmsItem
Export-ModuleMember -Function Test-UmsMetadata
Export-ModuleMember -Function Update-UmsCache