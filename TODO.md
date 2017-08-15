# Caching
- Diviser UmsItem en UmsItem et UmsManagedItem

- Extraire EntityCache, collection de CachedEntity:
    Add-UmsCachedEntity
    Get-UmsCachedEntity
    Remove-UmsCachedEntity
    Test-UmsCachedEntity

- Créer DocumentCache, collection de CachedDocument:
    Add-UmsCachedDocument
    Get-UmsCachedDocument
    Remove-UmsCachedDocument
    Test-UmsCachedDocument

- Modifier les 2 commandes suivantes en conséquence:
    Reset-UmsCache
    Measure-UmsCache

# Convertisseurs
- Implémenter la conversion des paroles:
    ConvertTo-TextLyrics

# Schéma
- Réviser la gestion des paroles
- Gestion des performances partielles

# Utilitaires
- Créer classe de mise à jour des métadonnées via MétaFlac.