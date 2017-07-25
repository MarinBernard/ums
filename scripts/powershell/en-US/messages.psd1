@{
    Common = @{
        AccessDenied = "Target folder does not exist or access is denied."
        IncompatibleCardinality = "The cardinality of the target item is not compatible with this command. Valid cardinality: {0}"
        ConfirmPrompt = "Are you sure you want to continue?"
        ExpiredItemCache = "Cached metadata of the target item are expired."
        InvalidState = "Invalid"
        MissingSidecarFile = "Skipping this file as it lacks a UMS sidecar file."
        MissingUmsItemCache = "The metadata cache of the target file is empty. Run Update-UmsItemCache then try again."
        OrphanCardinalityWarning = "You are about to run a command on an orphaned item."
        UmsNotEnabled = "UMS metadata are not enabled with this folder."
        UnknownState = "Unknown"
        ValidState = "Valid"
        VoidUmsMetadata = "No UMS metadata were ever defined for this folder."
    }
    ConvertToForeignMetadata = @{
        BadBindingNamespace = "The binding namespace of the source UMS item does not allow this operation. The binding element is {0}, whereas the parameters you specified require namespace {1}."
        BadBindingElement = "The binding element of the source UMS item does not allow this operation. The binding namespace is {0}, whereas the parameters you specified require element {1}."
        BadDocumentNamespace = "The document namespace of the source UMS item does not allow this operation. The document namespace is {0}, whereas the parameters you specified require namespace {1}."
        BadDocumentElement = "The document element of the source UMS item does not allow this operation. The document element is {0}, whereas the parameters you specified require element {1}."
    }
    DisableUmsManagement = @{
        ConfirmDeletion = "This will destroy all UMS metadata for any file within in this folder. Please confirm to continue."
    }
    EnableUmsManagement = @{
        AlreadyEnabled = "UMS metadata are already enabled with this folder."
        CacheFolderCreationError = "The cache subfolder could not be created."
        FolderCreationError = "The metadata storage folder could not be created."
        FolderHideoutError = "The metadata folder was created but not hidden."
    }
    ReadXmlNamespaceUri = @{
        FileNotFound = "XML file {0} was not found or access was denied."
        BadXmlContent = "XML file {0} is invalid and could not be read."
        NoNamespace = "XML file {0} is empty or uses unqualified elements."
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
    TestUmsManagement = @{
        Enabled = "UMS metadata are enabled."
        Disabled = "UMS metadata are disabled."
        CacheFolderNotFound = "The UMS cache subfolder is missing."
    }
    UpdateUmsItemCache = @{
        MissingTarget = "The target file does not exist or access is denied."
        NoUpdateNeeded = "UMS cache is up-to-date. No update needed."
        PromotionFailure = "Failed to promote the newly generated file to the new cache file."
        TempFileRemovalFailure = "A temporary file could not be removed."
        ValidationFailure = "The cache file did not pass XML validation."     
    }
}