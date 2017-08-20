@{
    Commands = @{
        CachedVersionUpToDate = "La mise à jour de la version cachée n'est pas nécessaire."
        CommandFailure = "La commande a échoué."
        ConstraintValidationFailure = "Le fichier fourni ne satisfait pas aux contraintes associées à cette commande."
        ConverterInvocationFailure = "La conversion des métadonnées a échoué."
        DisableManagementFailure = "Une erreur est survenue lors de la désactivation de la gestion des fichiers UMS pour le dossier spécifié."
        DisableManagementSuccess = "La gestion des fichiers UMS a été correctement désactivée pour le dossier spécifié."
        DocumentCachingFailure = "Le document a été récupéré mais n'a pas pu être mis en cache."
        EnableManagementFailure = "Une erreur est survenue lors de l'activation de la gestion des fichiers UMS pour le dossier spécifié."
        EnableManagementSuccess = "La gestion des fichiers UMS a été correctement activée pour le dossier spécifié."
        EntityGenerationFailure = "La génération de l'entité UMS a échoué."
        FileDeletionFailure = "Une erreur est survenue lors de la suppression du fichier."
        FileRenameFailure = "Une erreur est survenue lors du renommage du fichier."
        FileNotFound = "Le fichier UMS spécifié n'existe pas ou n'est pas accessible."
        GetDocumentByURIFailure = "Impossible de récupérer un document UMS à partir de l'URI spécifiée."
        InconsistentState = "Le dossier est dans un état incohérent."
        ManagedFileRequired = "Un fichier UMS géré est requis."
        ManagementDisabled = "La gestion des fichiers UMS est désactivée."
        ManagementEnabled = "La gestion des fichiers UMS est activée."
        MetadataConversionFailure = "La conversion des métadonnées à échoué."
        MissingCacheFolder = "Le sous-dossier du cache de métadonnées n'est pas présent."
        MissingStaticFolder = "Le sous-dossier des documents statiques n'est pas présent."
        ResourceRetrievalFailure = "La ressource n'a pas pu être récupérée."
        RunCommandAdvice = "Exécutez la commande {0} pour obtenir plus d'informations."
        StaticVersionUpdateFailure = "La mise à jour de la version statique a échoué."
        StaticVersionUpToDate = "La mise à jour de la version statique n'est pas nécessaire."
    }
    Common = @{
        AccessDenied = "Le dossier spécifié n'existe pas ou l'accès a été refusé."
        ConfirmPrompt = "Êtes-vous sûr de vouloir continuer ?"
        ExpiredCachedVersion = "La version cachée des métadonnées de l'élément UMS est périmée."
        ExpiredStaticVersion = "La version statique de l'élément UMS est périmée."
        InvalidState = "Invalide"
        MissingCachedVersion = "L'élément UMS ne possède pas de version cachée de ses métadonnées. Utilisez Update-UmsItem pour construire le cache et accélérer l'exécution de futures requêtes."
        MissingSidecarFile = "Le fichier sera ignoré car il ne possède pas de fichier UMS compagnon."
        MissingStaticVersion = "L'élément cible ne dispose pas d'une copie statique. Exécutez Update-UmsItemCache pour construire une copie statique."
        OrphanCardinalityWarning = "Vous êtes sur le point d'exécuter une tâche impliquant un élément orphelin."
        UmsNotEnabled = "Les métadonnées UMS ne sont pas activées pour ce dossier."
        UnknownState = "Inconnu"
        ValidState = "Valide"
        VoidUmsMetadata = "Aucune métadonnée UMS n'a jamais été définie pour ce dossier."
    }
    Exceptions = @{
        AbstractClassInstantiation = @{
            MainMessage = "Impossible de créer une instance de la classe pseudo-abstraite {0}. L'instantiation de classes abstraites est interdite.."
        }
        ClassLookupFailure = @{
            MainMessage = "La fabrique d'entités a échoué à trouver une classe d'entité adaptée à l'élément XML {0} issu de l'espace de noms {1}."
        }
        IllegalXmlAttributeValue = @{
            MainMessage = "La valeur de l'attribut {0} de l'élément XML {1} issu de l'espace noms {2} est illégale."
            ActualValue = "Valeur de l'attribut: {0}"
            AllowedValues = "Valeurs autorisées: {0}"
        }
        IllegalXmlElementCount = @{
            MainMessage = "Le nombre d'éléments XML {0} issus de l'espace de noms {1} est illégal dans ce contexte."
            Context = "Le contexte est celui d'un élément {0} issue de l'espace de noms {1}."
            ActualCount = "Nombre d'éléments: {0}"
            MinExpectedCount =  "Nombre minimal attendu: {0}"
            MaxExpectedCount =  "Nombre maximal attendu: {0}"
        }
        IncompatibleUmsReferenceElementName =  @{
            MainMessage = "L'élément racine du document XML ciblé par une référence UMS ne possède pas le nom local attendu."
            ResourceUri = "L'URI de la ressource est: {0}"
            ActualName = "Le nom local de l'élément est: {0}"
            ExpectedName = "Le nom local attendu est: {0}"
        }         
        IncompatibleUmsReferenceElementNamespace =  @{
            MainMessage = "L'élément racine du document XML ciblé par une référence UMS n'appartient pas à l'espace de noms attendu."
            ResourceUri = "L'URI de la ressource est: {0}"
            ActualNamespace = "L'espace de noms de l'élément est: {0}"
            ExpectedNamespace = "L'espace de noms attendu est: {0}"
        }   
        IncompatibleUmsReferenceResourceType =  @{
            MainMessage = "La ressource ciblée par une référence UMS est d'un type non-supporté."
            ResourceUri = "L'URI de la ressource est: {0}"
            ResourceType = "Le type de la ressource est: {0}"
            ExpectedType = "Le type attendu est: {0}"
        }
        IncompatibleXmlElement = @{
            MainMessage = "Impossible de créer une instance de la classe {0} car l'élément XML fourni au constructeur a été rejeté."
            ElementNamespace = "L'espace de noms de l'élément est: {0}"
            ExpectedNamespace = "L'espace de noms attendu est: {0}"
            ElementName = "Le nom de l'élement est: {0}"
            ExpectedName = "Le nom attendu est: {0}"
        }
        MandatoryStandardIdSegmentNotFoundException = @{
            MainMessage = "Un segment d'ID obligatoire n'a pas été trouvé dans la collection de segments: le segment de niveau {0} est manquant."
        }
        MissingXmlElementAttributeException = @{
            MainMessage = "L'attribut {0} est manquant mais est obligatoire dans ce contexte."
            Context = "Le contexte est celui d'un élément {0} issue de l'espace de noms {1}."
        }
        UnresolvableUmsReference =  @{
            MainMessage = "Une référence UMS n'a pas pu être résolue: aucune correspondance n'a été trouvée via aucun des catalogues configurés, ni via un chemin local."
            NamespaceURI = "Espace de noms de la référence: {0}"
            LocalName = "Nom local de la référence: {0}"
            TriedUri = "URI tentée: {0}"
            Uid = "Uid de la référence: {0}"
        }
    }
    ConvertToForeignMetadata = @{
        BadBindingNamespace = "L'espace de noms de liaison de l'élement UMS est incompatible avec cette opération. L'espace de noms de liaison est {0}, mais les paramètres que vous avez spécifiés exigent l'espace de noms {1}."
        BadBindingElement = "L'élement de liaison de l'élement UMS est incompatible avec cette opération. L'élement de liaison est {0}, mais les paramètres que vous avez spécifiés exigent une balise {1}."
        BadDocumentNamespace = "L'espace de noms du document de l'élement UMS est incompatible avec cette opération. L'espace de noms est {0}, mais les paramètres que vous avez spécifiés exigent l'espace de noms {1}."
        BadDocumentElement = "L'élement racine du document de l'élement UMS est incompatible avec cette opération. L'élement racine est {0}, mais les paramètres que vous avez spécifiés exigent une balise {1}."
    }
    DocumentCache = @{
        CacheFolderCreationFailure = "La persistance du cache sur le disque dur a été désactivée car le dossier de cache n'a pas pu être créé."
        CacheFileRemovalFailure = "Le fichier de cache à l'emplacement suivant n'a pas pu être supprimé du disque: {0}"
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
    RemoveUmsManagedFile = @{
        CacheFileRemovalFailure = "La commande n'est pas parvenue à supprimer le fichier contenant le cache des métadonnées."
        CompanionFileRemovalFailure = "La commande n'est pas parvenue à supprimer le fichier compagnion de l'élément UMS."
        StaticFileRemovalFailure = "La commande n'est pas parvenue à supprimer le fichier contenant la copie statique."
        UmsFileRemovalFailure = "La commande n'est pas parvenue à supprimer le fichier UMS principal."
    }
    RenameUmsManagedFile = @{
        CacheFileRenameFailure = "La commande n'est pas parvenue à renommer le fichier contenant le cache des métadonnées."
        CompanionFileRenameFailure = "La commande n'est pas parvenue à renommer le fichier compagnion de l'élément UMS."
        StaticFileRenameFailure = "La commande n'est pas parvenue à renommer le fichier contenant la copie statique."
        UmsFileRenameFailure = "La commande n'est pas parvenue à renommer le fichier UMS principal."
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
    UpdateUmsManagedFile = @{
        MissingTarget = "Le fichier cible n'existe pas ou n'est pas accessible."
        PromotionFailure = "Echec de la promotion du fichier nouvellement généré en fichier de cache."
        TempFileRemovalFailure = "Un fichier temporaire n'a pas pu être supprimé."
        ValidationFailure = "Le fichier de cache n'a pas réussi la validation XML."
    }
}