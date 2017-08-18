###############################################################################
# Entities and classes
###############################################################################

# Event logger (Needed by all classes and helpers)
. "$PSScriptRoot\helpers\EventLogger\EventLogger.ps1"

# Base class for all exceptions (Needed by all classes and helpers)
. "$PSScriptRoot\classes\UmsException.ps1"

# Configuration store (Needed by all classes and helpers)
. "$PSScriptRoot\helpers\ConfigurationStore\ConfigurationStore.Exceptions.ps1"
. "$PSScriptRoot\helpers\ConfigurationStore\ConfigurationStore.ps1"

# Relax NG Validator (Needed by the UmsDocument class)
. "$PSScriptRoot\helpers\RelaxNgValidator\RelaxNgValidator.Exceptions.ps1"
. "$PSScriptRoot\helpers\RelaxNgValidator\RelaxNgValidator.ps1"

# Document cache (Needed by the DocumentFactory helper)
. "$PSScriptRoot\helpers\DocumentCache\classes\UmsDocument.Exceptions.ps1"
. "$PSScriptRoot\helpers\DocumentCache\classes\UmsDocument.ps1"
. "$PSScriptRoot\helpers\DocumentCache\classes\CachedDocument.Exceptions.ps1"
. "$PSScriptRoot\helpers\DocumentCache\classes\CachedDocument.ps1"
. "$PSScriptRoot\helpers\DocumentCache\DocumentCache.Exceptions.ps1"
. "$PSScriptRoot\helpers\DocumentCache\DocumentCache.ps1"

# Document factory (Needed by the FileManager helper)
. "$PSScriptRoot\helpers\DocumentFactory\DocumentFactory.Exceptions.ps1"
. "$PSScriptRoot\helpers\DocumentFactory\DocumentFactory.ps1"

# File manager
. "$PSScriptRoot\helpers\FileManager\FileManager.Exceptions.ps1"
. "$PSScriptRoot\helpers\FileManager\FileManager.ps1"

# Common exceptions
. "$PSScriptRoot\classes\Exceptions.ps1"

# Constraint validator (Needed by all stylesheets and converters)
. "$PSScriptRoot\helpers\ConstraintValidator\ConstraintValidator.Exceptions.ps1"
. "$PSScriptRoot\helpers\ConstraintValidator\ConstraintValidator.ps1"

# Abstract base entity
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

. "$PSScriptRoot\helpers\Invoke-XslTransformer.ps1"
. "$PSScriptRoot\helpers\Wait-UserConfirmation.ps1"

###############################################################################
# Converters
###############################################################################

. "$PSScriptRoot\converters\VorbisCommentConverter.Exceptions.ps1"
. "$PSScriptRoot\converters\VorbisCommentConverter.ps1"

###############################################################################
# Commands
###############################################################################

# *-CachedDocument
. "$PSScriptRoot\commands\CachedDocument\Get-CachedDocument.ps1"
. "$PSScriptRoot\commands\CachedDocument\Remove-CachedDocument.ps1"

# *-DocumentCache
. "$PSScriptRoot\commands\DocumentCache\Clear-DocumentCache.ps1"
. "$PSScriptRoot\commands\DocumentCache\Reset-DocumentCache.ps1"
. "$PSScriptRoot\commands\DocumentCache\Measure-DocumentCache.ps1"

# *-Document
. "$PSScriptRoot\commands\Document\Get-Document.ps1"

# *-Item
. "$PSScriptRoot\commands\File\Get-File.ps1"

# *-ItemManagement
. "$PSScriptRoot\commands\FileManagement\Enable-FileManagement.ps1"
. "$PSScriptRoot\commands\FileManagement\Disable-FileManagement.ps1"
. "$PSScriptRoot\commands\FileManagement\Test-FileManagement.ps1"

# *-UmsManagedFile
. "$PSScriptRoot\commands\UmsManagedFile\Get-ManagedFile.ps1"
. "$PSScriptRoot\commands\UmsManagedFile\Remove-ManagedFile.ps1"
. "$PSScriptRoot\commands\UmsManagedFile\Rename-ManagedFile.ps1"
. "$PSScriptRoot\commands\UmsManagedFile\Update-ManagedFile.ps1"

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