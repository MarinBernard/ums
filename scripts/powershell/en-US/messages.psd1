@{
    Common = @{
        AccessDenied = "Target folder does not exist or access is denied."
        InvalidState = "Invalid"
        MissingUmsCache = "No cached metadata are available for the target folder. Run Update-UmsCache then try again."
        UmsNotEnabled = "UMS metadata are not enabled with this folder."
        UnknownState = "Unknown"
        ValidState = "Valid"
        VoidUmsMetadata = "No UMS metadata were ever defined for this folder."
    }
    ConvertToForeignMetadata = @{
        BadSourceNamespace = "UMS metadata belong to an incompatible namespace. The source namespace is {0}, whereas the parameters you specified require metadata from the {1} namespace."
    }
    DisableUmsMetadata = @{
        ConfirmDeletion = "This will destroy all UMS metadata for any file within in this folder. Please confirm to continue."
    }
    EnableUmsMetadata = @{
        AlreadyEnabled = "UMS metadata are already enabled with this folder."
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
        TransformFailure = "An error occured while running the XSLT transform. Use the -Verbose switch to show the output of the XSLT processor."
    }
    UpdateUmsCache = @{
        MissingTarget = "The target file does not exist or access is denied."
        NoUpdateNeeded = "UMS cache is up-to-date. No update needed."
        TempFileRemovalFailure = "A temporary file could not be removed."
        ValidationFailure = "The cache file did not pass XML validation."     
    }
    TestUmsMetadata = @{
        Enabled = "UMS metadata are enabled."
        Disabled = "UMS metadata are disabled."
    }
}