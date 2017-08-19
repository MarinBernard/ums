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

# *-UmsCachedDocument
Export-ModuleMember -Function Get-UmsCachedDocument
Export-ModuleMember -Function Remove-UmsCachedDocument

# *-UmsCachedEntity
Export-ModuleMember -Function Get-UmsCachedEntity

# *-UmsDocument
Export-ModuleMember -Function Get-UmsDocument

# *-UmsDocumentCache
Export-ModuleMember -Function Clear-UmsDocumentCache
Export-ModuleMember -Function Reset-UmsDocumentCache
Export-ModuleMember -Function Measure-UmsDocumentCache

# *-UmsEntityCache
Export-ModuleMember -Function Clear-UmsEntityCache
Export-ModuleMember -Function Measure-UmsEntityCache
Export-ModuleMember -Function Reset-UmsEntityCache

# *-UmsFile
Export-ModuleMember -Function Get-UmsFile
Export-ModuleMember -Function Rename-UmsFile
Export-ModuleMember -Function Remove-UmsFile

# *-UmsFileManagement
Export-ModuleMember -Function Disable-UmsFileManagement
Export-ModuleMember -Function Enable-UmsFileManagement
Export-ModuleMember -Function Test-UmsFileManagement

# *-UmsManagedFile
Export-ModuleMember -Function Get-UmsManagedFile
Export-ModuleMember -Function Remove-UmsManagedFile
Export-ModuleMember -Function Rename-UmsManagedFile
Export-ModuleMember -Function Update-UmsManagedFile

# *-UmsMetadata
Export-ModuleMember -Function Get-UmsMetadata

# *-VorbisMetadata
Export-ModuleMember -Function ConvertTo-VorbisMetadata

# Other
Export-ModuleMember -Function ConvertTo-ForeignMetadata