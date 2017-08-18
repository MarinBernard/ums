###############################################################################
# Include dependencies
###############################################################################

. "$PSScriptRoot\includes.ps1"

###############################################################################
# Initialize the configuration store
###############################################################################

[ConfigurationStore]::LoadConfiguration("$PSScriptRoot\..\..\configuration.xml")

# Configuration file
[xml] $global:ConfigurationDocument = Get-Content -Path "$PSScriptRoot\..\..\configuration.xml"

# Load localization
$global:ModuleStrings = Import-LocalizedData -FileName "messages.psd1" -BaseDirectory "$PSScriptRoot\messages"

###############################################################################
# Initialize caching toolset
###############################################################################

# Initialize the document cache
[DocumentCache]::Initialize(
    (Join-Path -Path $env:LocalAppData -ChildPath "UMS\DocumentCache"))

###############################################################################
# Exports
###############################################################################

# *-<prefix>CachedDocument
Export-ModuleMember -Function Get-CachedDocument
Export-ModuleMember -Function Remove-CachedDocument

# *-<prefix>DocumentCache
Export-ModuleMember -Function Clear-DocumentCache
Export-ModuleMember -Function Reset-DocumentCache
Export-ModuleMember -Function Measure-DocumentCache

# *-<prefix>Document
Export-ModuleMember -Function Get-Document

# *-<prefix>File
Export-ModuleMember -Function Get-File

# *-<prefix>ManagedFile
Export-ModuleMember -Function Get-ManagedFile
Export-ModuleMember -Function Remove-ManagedFile
Export-ModuleMember -Function Rename-ManagedFile
Export-ModuleMember -Function Update-ManagedFile

# *-<prefix>FileManagement
Export-ModuleMember -Function Disable-FileManagement
Export-ModuleMember -Function Enable-FileManagement
Export-ModuleMember -Function Test-FileManagement

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