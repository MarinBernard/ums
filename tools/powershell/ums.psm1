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

# Initialize the document cache
[DocumentCache]::Initialize(
    (Join-Path -Path $env:LocalAppData -ChildPath "UMSCache"))

###############################################################################
# Exports
###############################################################################

# *-CachedDocument
Export-ModuleMember -Function Get-CachedDocument
Export-ModuleMember -Function Remove-CachedDocument

# *-DocumentCache
Export-ModuleMember -Function Clear-DocumentCache
Export-ModuleMember -Function Reset-DocumentCache
Export-ModuleMember -Function Measure-DocumentCache

# *-Document
Export-ModuleMember -Function Get-Document

# *-Item
Export-ModuleMember -Function Get-Item

# *-UmsManagedItem
Export-ModuleMember -Function Get-UmsManagedItem
Export-ModuleMember -Function Remove-UmsManagedItem
Export-ModuleMember -Function Rename-UmsManagedItem
Export-ModuleMember -Function Update-UmsManagedItem

# *-ItemManagement
Export-ModuleMember -Function Disable-ItemManagement
Export-ModuleMember -Function Enable-ItemManagement
Export-ModuleMember -Function Test-ItemManagement

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