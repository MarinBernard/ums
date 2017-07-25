@{
    Common = @{
        AccessDenied = "Le dossier spécifié n'existe pas ou l'accès a été refusé."
        ConfirmPrompt = "Êtes-vous sûr de vouloir continuer ?"
        IncompatibleCardinality = "La cardinalité de l'élément cible est incompatible avec cette commande. Cardinalité attendue: {0}"
        ExpiredStaticVersion = "La copie statique de l'élément cible est périmée."
        InvalidState = "Invalide"
        MissingSidecarFile = "Le fichier sera ignoré car il ne possède pas de fichier UMS compagnon."
        MissingUmsItemStaticVersion = "L'élément cible ne dispose pas d'une copie statique. Exécutez Update-UmsItemCache puis réessayez."
        OrphanCardinalityWarning = "Vous êtes sur le point d'exécuter une tâche impliquant un élément orphelin."
        UmsNotEnabled = "Les métadonnées UMS ne sont pas activées pour ce dossier."
        UnknownState = "Inconnu"
        ValidState = "Valide"
        VoidUmsMetadata = "Aucune métadonnée UMS n'a jamais été définie pour ce dossier."
    }
    ConvertToForeignMetadata = @{
        BadBindingNamespace = "L'espace de noms de liaison de l'élement UMS est incompatible avec cette opération. L'espace de noms de liaison est {0}, mais les paramètres que vous avez spécifiés exigent l'espace de noms {1}."
        BadBindingElement = "L'élement de liaison de l'élement UMS est incompatible avec cette opération. L'élement de liaison est {0}, mais les paramètres que vous avez spécifiés exigent une balise {1}."
        BadDocumentNamespace = "L'espace de noms du document de l'élement UMS est incompatible avec cette opération. L'espace de noms est {0}, mais les paramètres que vous avez spécifiés exigent l'espace de noms {1}."
        BadDocumentElement = "L'élement racine du document de l'élement UMS est incompatible avec cette opération. L'élement racine est {0}, mais les paramètres que vous avez spécifiés exigent une balise {1}."
    }
    DisableUmsManagement = @{
        ConfirmDeletion = "Vous vous apprêtez à détruire la totalité des métadonnées UMS pour chacun des fichiers présents dans ce dossier. Confirmez pour continuer."
    }
    EnableUmsManagement = @{
        AlreadyEnabled = "Les métadonnées UMS sont déjà activées pour ce dossier."
        CacheFolderCreationError = "Le sous-dossier de cache n'a pas pu être créé."
        StaticFolderCreationError = "Le sous-dossier des données statiques n'a pas pu être créé."
        FolderCreationError = "Le dossier de stockage des métadonnées n'a pas pu être créé."
        FolderHideoutError = "Le dossier de stockage des métadonnées a bien été créé mais n'a pas pu être caché."
    }
    ReadXmlNamespaceUri = @{
        FileNotFound = "Le fichier XML {0} n'a pas été trouvé ou n'est pas accessible."
        BadXmlContent = "Le fichier XML {0} est invalide et n'a pas pu être lu."
        NoNamespace = "Le fichier XML {0} est vide ou utilise des éléments non-qualifiés."
    }
    RunUmsXmlValidation = @{
        SourceFileNotFound = "Le fichier source XML {0} n'existe pas ou n'est pas accessible."
        SchemaFileNotFound = "Le fichier de schéma UMS {0} n'existe pas ou n'est pas accessible."
    }
    RunXmlValidation = @{
        JingNotFound = "Le valideur Relax NG Jing n'est pas disponible. Veuillez vérifier votre fichier de configuration."
        JreNotFound = "L'environnement d'exécution Java n'est pas disponible. Veuillez vérifier votre fichier de configuration."
        SourceFileNotFound = "Le fichier source XML {0} n'existe pas ou n'est pas accessible."
        SchemaFileNotFound = "Le fichier de schéma Relax NG {0} n'existe pas ou n'est pas accessible."
    }
    RunXslTransform = @{
        JreNotFound = "L'environnement d'exécution Java n'est pas disponible. Veuillez vérifier votre fichier de configuration."
        SaxonNotFound = "Le processeur XSLT Saxon PE n'est pas disponible. Veuillez vérifier votre fichier de configuration."
        SourceFileNotFound = "Le fichier source XML {0} n'existe pas ou n'est pas accessible."
        StylesheetNotFound = "La feuille de style {0} n'existe pas ou n'est pas accessible."
        TransformFailure = "Une erreur s'est produite lors de la transformation XSLT."
    }
    TestUmsManagement = @{
        Enabled = "Les métadonnées UMS sont activées."
        Disabled = "Les métadonnées UMS sont désactivées."
        CacheFolderNotFound = "Le sous-dossier du cache de données n'est pas présent."
        StaticFolderNotFound = "Le sous-dossier des données statiques n'est pas présent."
    }
    UpdateUmsItemCache = @{
        MissingTarget = "Le fichier cible n'existe pas ou n'est pas accessible."
        NoUpdateNeeded = "Le cache UMS est à jour. Aucune mise à jour n'est nécessaire."
        PromotionFailure = "Echec de la promotion du fichier nouvellement généré en fichier de cache."
        TempFileRemovalFailure = "Un fichier temporaire n'a pas pu être supprimé."
        ValidationFailure = "Le fichier de cache n'a pas réussi la validation XML."
    }
}