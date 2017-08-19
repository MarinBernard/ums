@{
    Commands = @{
        CachedVersionUpToDate = "The cached version is already up-to-date."
        CommandFailure = "The command failed."
        ConstraintValidationFailure = "The supplied file did not validate all constraints associated to this command."
        DisableManagementFailure = "An error occurred while trying to disable UMS file management for the specified folder."
        DisableManagementSuccess = "UMS file management was successfully disabled for the specified folder."
        EnableManagementFailure = "An error occurred while trying to enable UMS file management for the specified folder."
        EnableManagementSuccess = "UMS file management was successfully enabled for the specified folder."
        FileDeletionFailure = "An error occured during file deletion."
        FileRenameFailure = "An error occured during file renaming."
        FileNotFound = "The specified UMS file does not exist or cannot be accessed."
        InconsistentState = "The state of the management folder is inconsistent."
        ManagementDisabled = "The management of UMS files is disabled."
        ManagementEnabled = "The management of UMS files is enabled."
        MetadataConversionFailure = "The metadata conversion process has failed."
        MissingCacheFolder = "The metadata cache subfolder is missing."
        MissingStaticFolder = "The static document subfolder is missing."
        RunCommandAdvice = "Run the {0} command to obtain more information."
        StaticVersionUpdateFailure = "The static version update has failed."
        StaticVersionUpToDate = "The static version is already up-to-date."
    }
    Common = @{
        AccessDenied = "Target folder does not exist or access is denied."
        ConfirmPrompt = "Are you sure you want to continue?"
        ExpiredCachedVersion = "The cached version of the metadata of the UMS item is obsolete."
        ExpiredStaticVersion = "The static version of the target item is obsolete."
        InvalidState = "Invalid"
        MissingCachedVersion = "The UMS item has no cached version of its metadata. Use Update-UmsItem to build the cache and speed up future metadata retrieval."
        MissingSidecarFile = "Skipping this file as it lacks a UMS sidecar file."
        MissingStaticVersion = "No static version is available for the target item. Run Update-UmsItemCache to create a static version.."
        OrphanCardinalityWarning = "You are about to run a command on an orphaned item."
        UmsNotEnabled = "UMS metadata are not enabled with this folder."
        UnknownState = "Unknown"
        ValidState = "Valid"
        VoidUmsMetadata = "No UMS metadata were ever defined for this folder."
    }
    Exceptions = @{
        AbstractClassInstantiation = @{
            MainMessage = "Unable to create an instance of pseudo-abstract class {0}. Instantiation of abstract classes is forbidden."
        }
        ClassLookupFailure = @{
            MainMessage = "The entity factory was unable to find a matching entity class for the XML element {0} in namespace {1}."
        }
        IllegalXmlAttributeValue = @{
            MainMessage = "The value of the {0} attribute of the {1} XML element from the {2} namespace is illegal."
            ActualValue = "Attribute value: {0}"
            AllowedValues = "Allowed values: {0}"
        }
        IllegalXmlElementCount = @{
            MainMessage = "The number of {0} XML elements from the {1} namespace is illegal in this context."
            Context = "Context is XML element {0} in namespace {1}."
            ActualCount = "Number of elements: {0}"
            MinExpectedCount =  "Minimum expected number: {0}"
            MaxExpectedCount =  "Maximum expected number: {0}"
        }
        IncompatibleCardinalityException = @{
            MainMessage = "The cardinality of the item is not compatible with this command."
            ItemName = "Item full name: {0}"
            ActualCardinality = "Item cardinality: {0}"
            CompatibleCardinalities = "Compatible cardinalities: {0}"
        }
        IncompatibleUmsReferenceElementName =  @{
            MainMessage = "The document element of the XML document targeted by a UMS reference does not have the expected local name."
            ResourceUri = "Resource URI is: {0}"
            ActualName = "Actual local name is: {0}"
            ExpectedName = "Expected local name is: {0}"
        }       
        IncompatibleUmsReferenceElementNamespace =  @{
            MainMessage = "The document element of the XML document targeted by a UMS reference does not belong to the expected namespace."
            ResourceUri = "Resource URI is: {0}"
            ActualNamespace = "Actual namespace is: {0}"
            ExpectedNamespace = "Expected namespace is: {0}"
        }        
        IncompatibleUmsReferenceResourceType =  @{
            MainMessage = "The resource targeted by a UMS reference is of an unsupported type."
            ResourceUri = "Resource URI is: {0}"
            ResourceType = "Actual resource type is: {0}"
            ExpectedType = "Expected resource type is: {0}"
        }
        IncompatibleXmlElement = @{
            MainMessage = "Unable to create an instance of class {0} because the XML element passed to the constructor was rejected."
            ElementNamespace = "Element namespace is: {0}"
            ExpectedNamespace = "Expected namespace is: {0}"
            ElementName = "Element name is: {0}"
            ExpectedName = "Expected name is: {0}"
        }
        MandatoryStandardIdSegmentNotFoundException = @{
            MainMessage = "A mandatory ID segment was not found in the segment collection: missing level {0} segment."
        }
        MissingXmlElementAttributeException = @{
            MainMessage = "The attribute {0} is missing but is mandatory in this context."
            Context = "Context is XML element {0} in namespace {1}."
        }
        UmsManagedFileMetadataConversionFailure = @{
            MainMessage = "The UMS item could not be converted."
            ItemPath = "Path of the item: {0}"
            ItemName = "Name of the item: {0}"
        }
        UmsManagedFileUpdateFailure = @{
            MainMessage = "The UMS item could not be updated."
            ItemPath = "Path of the item: {0}"
            ItemName = "Name of the item: {0}"
        }
        UnresolvableUmsReference =  @{
            MainMessage = "A UMS reference could not be resolved: no match was found using any of the configured catalogs, nor a local path."
            NamespaceURI = "Namespace of the reference: {0}"
            LocalName = "Local name of the reference: {0}"
            TriedUri = "Tried URI: {0}"
            Uid = "Uid of the reference: {0}"
        }
    ConvertToForeignMetadata = @{
        BadBindingNamespace = "The binding namespace of the source UMS item does not allow this operation. The binding element is {0}, whereas the parameters you specified require namespace {1}."
        BadBindingElement = "The binding element of the source UMS item does not allow this operation. The binding namespace is {0}, whereas the parameters you specified require element {1}."
        BadDocumentNamespace = "The document namespace of the source UMS item does not allow this operation. The document namespace is {0}, whereas the parameters you specified require namespace {1}."
        BadDocumentElement = "The document element of the source UMS item does not allow this operation. The document element is {0}, whereas the parameters you specified require element {1}."
    }
    DocumentCache = @{
        CacheFolderCreationFailure = "On-disk persistence was disabled as the cache folder could not be created."
        CacheFileRemovalFailure = "The cache file at the following location could not be removed from the disk: {0}"
    }
    ReadXmlNamespaceUri = @{
        FileNotFound = "XML file {0} was not found or access was denied."
        BadXmlContent = "XML file {0} is invalid and could not be read."
        NoNamespace = "XML file {0} is empty or uses unqualified elements."
    }
    RemoveUmsManagedFile = @{
        CacheFileRemovalFailure = "The command was unable to remove the metadata cache file."
        CompanionFileRemovalFailure = "The command was unable to remove the companion file of the item."
        StaticFileRemovalFailure = "The command was unable to remove the static version file."
        UmsFileRemovalFailure = "The command was unable to remove the main UMS file."
    }
    RenameUmsManagedFile = @{
        CacheFileRenameFailure = "The command was unable to rename the metadata cache file."
        CompanionFileRenameFailure = "The command was unable to rename the companion file of the item."
        StaticFileRenameFailure = "The command was unable to rename the static version file."
        UmsFileRenameFailure = "The command was unable to rename the main UMS file."
    }
    RunUmsXmlValidation = @{
       SourceFileNotFound = "XML source file {0} does not exist or access is denied."
       SchemaFileNotFound = "UMS schema file {0} does not exist or access is denied."
    }
    RunXmlValidation = @{
        JingNotFound = "The Jing Relax NG validator is not available. Please, update your config file."
        JreNotFound = "The Java Runtime Environment is not available. Please, update your config file."
        SourceFileNotFound = "XML source file {0} does not exist or access is denied."
        SchemaFileNotFound = "Relax NG schema file {0} does not exist or access is denied."
    }
    RunXslTransform = @{
        JreNotFound = "The Java Runtime Environment is not available. Please, update your config file."
        SaxonNotFound = "The Saxon PE XSLT processor is not available. Please, update your config file."
        SourceFileNotFound = "XML source file {0} does not exist or access is denied."
        StylesheetNotFound = "XSLT stylesheet {0} does not exist or access is denied."
        TransformFailure = "An error occured while running the XSLT transform."
    }
    UpdateUmsManagedFile = @{
        MissingTarget = "The target file does not exist or access is denied."
        PromotionFailure = "Failed to promote the newly generated file to be the new cache file."
        TempFileRemovalFailure = "A temporary file could not be removed."
        ValidationFailure = "The cache file did not pass XML validation."     
    }
}