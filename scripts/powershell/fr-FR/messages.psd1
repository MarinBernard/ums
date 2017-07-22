@{
    Common = @{
        AccessDenied = "Le dossier spécifié n'existe pas ou l'accès a été refusé."
        InvalidState = "Invalide"
        MissingUmsCache = "Le dossier cible ne contient pas de métadonnées mises en cache. Exécutez Update-UmsCache puis réessayez."
        UmsNotEnabled = "Les métadonnées UMS ne sont pas activées pour ce dossier."
        UnknownState = "Inconnu"
        ValidState = "Valide"
        VoidUmsMetadata = "Aucune métadonnée UMS n'a jamais été définie pour ce dossier."
    }
    ConvertToForeignMetadata = @{
        BadSourceNamespace = "Les métadonnées UMS appartiennent à un espace de noms incompatible. L'espace de noms source est {0}, mais les paramètres que vous avez spécifiés exigent l'espace de noms {1}."
    }
    DisableUmsMetadata = @{
        ConfirmDeletion = "Vous vous apprêtez à détruire la totalité des métadonnées UMS pour chacun des fichiers présents dans ce dossier. Confirmez pour continuer."
    }
    EnableUmsMetadata = @{
        AlreadyEnabled = "Les métadonnées UMS sont déjà activées pour ce dossier."
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
        TransformFailure = "Une erreur s'est produite lors de la transformation XSLT. Utilisez le commutateur -Verbose pour afficher la sortie du processeur XSLT."
    }
    UpdateUmsCache = @{
        MissingTarget = "Le fichier cible n'existe pas ou n'est pas accessible."
        NoUpdateNeeded = "Le cache UMS est à jour. Aucune mise à jour n'est nécessaire."
        TempFileRemovalFailure = "Un fichier temporaire n'a pas pu être supprimé."
        ValidationFailure = "Le fichier de cache n'a pas réussi la validation XML."
    }
    TestUmsMetadata = @{
        Enabled = "Les métadonnées UMS sont activées."
        Disabled = "Les métadonnées UMS sont désactivées."
    }
}