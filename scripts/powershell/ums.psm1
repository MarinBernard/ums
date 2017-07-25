# Load module configuration
[xml] $global:ConfigurationDocument = Get-Content -Path "$PSScriptRoot\..\..\configuration.xml"

# Load localization
$global:ModuleStrings = Import-LocalizedData -FileName "messages.psd1"

# Include dependencies
. "$PSScriptRoot\classes\UmsItem.ps1"
. "$PSScriptRoot\helpers\Get-UmsSpecialFolderPath.ps1"
. "$PSScriptRoot\helpers\Invoke-XmlValidator.ps1"
. "$PSScriptRoot\helpers\Invoke-XslTransformer.ps1"
. "$PSScriptRoot\helpers\Wait-UserConfirmation.ps1"
. "$PSScriptRoot\commands\Enable-UmsMetadata.ps1"
. "$PSScriptRoot\commands\Disable-UmsMetadata.ps1"
. "$PSScriptRoot\commands\Test-UmsMetadata.ps1"
. "$PSScriptRoot\commands\ConvertTo-ForeignMetadata.ps1"
. "$PSScriptRoot\commands\Get-UmsConfigurationItem.ps1"
. "$PSScriptRoot\commands\Get-UmsItem.ps1"
. "$PSScriptRoot\commands\Update-UmsItemCache.ps1"

# Export
Export-ModuleMember -Function Disable-UmsMetadata
Export-ModuleMember -Function Enable-UmsMetadata
Export-ModuleMember -Function Test-UmsMetadata
Export-ModuleMember -Function ConvertTo-ForeignMetadata
Export-ModuleMember -Function Get-UmsConfigurationItem
Export-ModuleMember -Function Get-UmsItem
Export-ModuleMember -Function Update-UmsItemCache