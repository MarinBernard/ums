###############################################################################
# Include dependencies
###############################################################################

. "$PSScriptRoot\includes.ps1"

###############################################################################
# Initialize the configuration store
###############################################################################

[ConfigurationStore]::LoadConfiguration("$PSScriptRoot\..\..\configuration.xml")
#([configurationStore]::GetConverterItem("vorbiscomment").Options) | %{ Write-Host $_.GetType(); Write-Host $_.Id; Write-Host $_.Value}

# Configuration file
[xml] $global:ConfigurationDocument = Get-Content -Path "$PSScriptRoot\..\..\configuration.xml"

# Load localization
$global:ModuleStrings = Import-LocalizedData -FileName "messages.psd1" -BaseDirectory "$PSScriptRoot\messages"

###############################################################################
# Initialize caching toolset
###############################################################################

# Document cache
$_cacheFolder = Join-Path -Path $env:LocalAppData -ChildPath "UMSCache"
$global:UmsDocumentCache = [UmsDocumentCache]::New($_cacheFolder)

###############################################################################
# Exports
###############################################################################

# *-UmsCachedDocument
Export-ModuleMember -Function Get-UmsCachedDocument
Export-ModuleMember -Function Remove-UmsCachedDocument

# *-UmsDocument
Export-ModuleMember -Function Get-UmsDocument

# *-UmsDocumentCache
Export-ModuleMember -Function Clear-UmsDocumentCache
Export-ModuleMember -Function Reset-UmsDocumentCache
Export-ModuleMember -Function Measure-UmsDocumentCache

# *-UmsManagedItem
Export-ModuleMember -Function Get-UmsManagedItem
Export-ModuleMember -Function Remove-UmsManagedItem
Export-ModuleMember -Function Rename-UmsManagedItem
Export-ModuleMember -Function Update-UmsManagedItem

# *-UmsManagement
Export-ModuleMember -Function Disable-UmsManagement
Export-ModuleMember -Function Enable-UmsManagement
Export-ModuleMember -Function Test-UmsManagement

# *-UmsMetadata
Export-ModuleMember -Function Get-UmsMetadata

# *-UmsMetadataCache
Export-ModuleMember -Function Get-UmsMetadataCache
Export-ModuleMember -Function Measure-UmsMetadataCache
Export-ModuleMember -Function Reset-UmsMetadataCache

# *-VorbisMetadata
Export-ModuleMember -Function ConvertTo-VorbisMetadata

# Other
Export-ModuleMember -Function ConvertTo-ForeignMetadata