# Include dependencies
. "$PSScriptRoot\includes.ps1"

# Export
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
Export-ModuleMember -Function Get-UmsConfigurationItem
