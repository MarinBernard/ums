# Include dependencies
. "$PSScriptRoot\includes.ps1"

# Export
# *-UmsItem
Export-ModuleMember -Function Get-UmsItem
Export-ModuleMember -Function Update-UmsItem
# *-UmsManagement
Export-ModuleMember -Function Disable-UmsManagement
Export-ModuleMember -Function Enable-UmsManagement
Export-ModuleMember -Function Test-UmsManagement
# Other
Export-ModuleMember -Function ConvertTo-ForeignMetadata
Export-ModuleMember -Function Get-UmsConfigurationItem
