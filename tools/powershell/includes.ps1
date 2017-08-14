###############################################################################
# Configuration
###############################################################################
# Configuration file
[xml] $global:ConfigurationDocument = Get-Content -Path "$PSScriptRoot\..\..\configuration.xml"

# Load localization
$global:ModuleStrings = Import-LocalizedData -FileName "messages.psd1" -BaseDirectory "$PSScriptRoot\messages"
###############################################################################
# Entities and classes
###############################################################################
# UmsItem
. "$PSScriptRoot\classes\UmsItem.ps1"
# Exceptions
. "$PSScriptRoot\classes\Exceptions.ps1"
# Abstract entity
. "$PSScriptRoot\entities\UmsAeEntity.ps1"
# Entity Factory
. "$PSScriptRoot\classes\CachedEntity.ps1"
. "$PSScriptRoot\classes\EntityFactory.ps1"
# Base namespace
. "$PSScriptRoot\entities\base\UmsBaeBinding.ps1"
. "$PSScriptRoot\entities\base\UmsBaeVariant.ps1"
. "$PSScriptRoot\entities\base\UmsBceLabelVariant.ps1"
. "$PSScriptRoot\entities\base\UmsBceLinkVariant.ps1"
. "$PSScriptRoot\entities\base\UmsBceNameVariant.ps1"
. "$PSScriptRoot\entities\base\UmsBceSymbolVariant.ps1"
. "$PSScriptRoot\entities\base\UmsBceTitleVariant.ps1"
. "$PSScriptRoot\entities\base\UmsBaeResource.ps1"
. "$PSScriptRoot\entities\base\UmsBaeItem.ps1"
. "$PSScriptRoot\entities\base\UmsBaeStandard_Segment.ps1"
. "$PSScriptRoot\entities\base\UmsBaeStandard_IdSegment.ps1"
. "$PSScriptRoot\entities\base\UmsBaeStandard.ps1"
. "$PSScriptRoot\entities\base\UmsBaeStandardId.ps1"
. "$PSScriptRoot\entities\base\UmsBceStandard.ps1"
. "$PSScriptRoot\entities\base\UmsBceStandardId.ps1"
. "$PSScriptRoot\entities\base\UmsBceCountry.ps1"
. "$PSScriptRoot\entities\base\UmsBceCountryDivision.ps1"
. "$PSScriptRoot\entities\base\UmsBceCity.ps1"
. "$PSScriptRoot\entities\base\UmsBaePlace.ps1"
. "$PSScriptRoot\entities\base\UmsBcePlace.ps1"  
. "$PSScriptRoot\entities\base\UmsBaeProduct.ps1"
. "$PSScriptRoot\entities\base\UmsBaeMedium.ps1"
. "$PSScriptRoot\entities\base\UmsBaeTrack.ps1"
. "$PSScriptRoot\entities\base\UmsBaeEvent.ps1"
. "$PSScriptRoot\entities\base\UmsBceBirth.ps1"
. "$PSScriptRoot\entities\base\UmsBceCompletion.ps1"
. "$PSScriptRoot\entities\base\UmsBceDeath.ps1"
. "$PSScriptRoot\entities\base\UmsBceInception.ps1"
. "$PSScriptRoot\entities\base\UmsBceRelease.ps1"
. "$PSScriptRoot\entities\base\UmsBaePerson.ps1"
. "$PSScriptRoot\entities\base\UmsBceCharacter.ps1"
. "$PSScriptRoot\entities\base\UmsBaePublication.ps1"
# Music namespace
. "$PSScriptRoot\entities\music\UmsMceVenue.ps1"
. "$PSScriptRoot\entities\music\UmsMaePlace.ps1"
. "$PSScriptRoot\entities\music\UmsMcePlace.ps1"
. "$PSScriptRoot\entities\music\UmsMaeEvent.ps1"
. "$PSScriptRoot\entities\music\UmsMcePremiere.ps1"
. "$PSScriptRoot\entities\music\UmsMceCatalog.ps1"
. "$PSScriptRoot\entities\music\UmsMceCatalogIdEntry.ps1"
. "$PSScriptRoot\entities\music\UmsMceCatalogId.ps1"
. "$PSScriptRoot\entities\music\UmsMceComposer.ps1"
. "$PSScriptRoot\entities\music\UmsMceForm.ps1"
. "$PSScriptRoot\entities\music\UmsMceInstrument.ps1"
. "$PSScriptRoot\entities\music\UmsMceKey.ps1"
. "$PSScriptRoot\entities\music\UmsMceLyricist.ps1"
. "$PSScriptRoot\entities\music\UmsMceStyle.ps1"
. "$PSScriptRoot\entities\music\UmsMceMovement.ps1"
. "$PSScriptRoot\entities\music\UmsMceSection.ps1"
. "$PSScriptRoot\entities\music\UmsMceScore.ps1"
. "$PSScriptRoot\entities\music\UmsMceWork.ps1"
. "$PSScriptRoot\entities\music\UmsMceConductor.ps1"
. "$PSScriptRoot\entities\music\UmsMceEnsemble.ps1"
. "$PSScriptRoot\entities\music\UmsMceInstrumentalist.ps1"
. "$PSScriptRoot\entities\music\UmsMcePerformer.ps1"
. "$PSScriptRoot\entities\music\UmsMcePerformance.ps1"
. "$PSScriptRoot\entities\music\UmsMceTrack.ps1"
#  Audio namespace
. "$PSScriptRoot\entities\audio\UmsAceLabel.ps1"
. "$PSScriptRoot\entities\audio\UmsAceMedium.ps1"
. "$PSScriptRoot\entities\audio\UmsAceAlbum.ps1"
# Bindings
. "$PSScriptRoot\entities\audio\UmsAbeAlbumTrackBinding.ps1"
###############################################################################
# Helpers
###############################################################################
. "$PSScriptRoot\helpers\Get-UmsManagementFolderPath.ps1"
. "$PSScriptRoot\helpers\Invoke-XmlValidator.ps1"
. "$PSScriptRoot\helpers\Invoke-XslTransformer.ps1"
. "$PSScriptRoot\helpers\Test-ConstraintValidation.ps1"
. "$PSScriptRoot\helpers\Wait-UserConfirmation.ps1"
###############################################################################
# Converters
###############################################################################
. "$PSScriptRoot\converters\VorbisCommentConverter.ps1"
###############################################################################
# Commands
###############################################################################
# *-UmsItem
. "$PSScriptRoot\commands\UmsItem\Get-UmsItem.ps1"
. "$PSScriptRoot\commands\UmsItem\Remove-UmsItem.ps1"
. "$PSScriptRoot\commands\UmsItem\Rename-UmsItem.ps1"
. "$PSScriptRoot\commands\UmsItem\Update-UmsItem.ps1"
# *-UmsManagement
. "$PSScriptRoot\commands\UmsManagement\Enable-UmsManagement.ps1"
. "$PSScriptRoot\commands\UmsManagement\Disable-UmsManagement.ps1"
. "$PSScriptRoot\commands\UmsManagement\Test-UmsManagement.ps1"
# *-UmsMetadata
. "$PSScriptRoot\commands\UmsMetadata\Get-UmsMetadata.ps1"
# *-UmsMetadataCache
. "$PSScriptRoot\commands\UmsMetadataCache\Get-UmsMetadataCache.ps1"
. "$PSScriptRoot\commands\UmsMetadataCache\Measure-UmsMetadataCache.ps1"
. "$PSScriptRoot\commands\UmsMetadataCache\Reset-UmsMetadataCache.ps1"
# *-VorbisMetadata
. "$PSScriptRoot\commands\VorbisMetadata\ConvertTo-VorbisMetadata.ps1"
# Other
. "$PSScriptRoot\commands\ConvertTo-ForeignMetadata.ps1"
. "$PSScriptRoot\commands\Get-UmsConfigurationItem.ps1"