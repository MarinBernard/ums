###############################################################################
#   Exception class DocumentCacheException
#==============================================================================
#
#   Parent type for all exceptions thrown by the [DocumentCache] class.
#
###############################################################################

class DocumentCacheException : UmsException
{
    DocumentCacheException() : base() {}
}

###############################################################################
#   Exception class DCCacheWriteFailureException
#==============================================================================
#
#   Thrown by the [DocumentCache] class after a write operation to the on-disk
#   cache has failed.
#
###############################################################################

class DCCacheWriteFailureException : DocumentCacheException
{
    DCCacheWriteFailureException(
        [System.Uri] $Uri,
        [string] $CacheFileName
    ) : base()
    {
        $this.MainMessage =  ($(
            "The document at the following URI could not be written " + `
            "to the on-disk cache store: {0}") `
            -f $Uri.AbsoluteUri)
        
        $this.SubMessages += ("Cache file name: {0}" -f $CacheFileName)
    }
}

###############################################################################
#   Exception class DCDocumentRetrievalFailureException
#==============================================================================
#
#   Thrown by the [DocumentCache] class when a remote document cannot be
#   be retrieved.
#
###############################################################################

class DCDocumentRetrievalFailureException : DocumentCacheException
{
    DCDocumentRetrievalFailureException([System.Uri] $Uri) : base()
    {
        $this.MainMessage = (
            "The document at the following URI cannot not be retrieved: {0}" `
            -f $Uri.AbsoluteUri)
    }
}

###############################################################################
#   Exception class DCHashGenerationFailureException
#==============================================================================
#
#   Thrown by the [DocumentCache] class when the md5 hash generation process
#   failed.
#
###############################################################################

class DCHashGenerationFailureException : DocumentCacheException
{
    DCHashGenerationFailureException(
        [string] $Algorithm,
        [string] $SourceData) : base()
    {
        $this.MainMessage = (
            "Unable to generate a {0} hash with algorithm from data: {1}" `
            -f $Algorithm,$SourceData)
    }
}

###############################################################################
#   Exception class DCNewCachedDocumentFailureException
#==============================================================================
#
#   Thrown when an exception thrown by the [CachedDocument] constructor is
#   caught, which means that the document cannot be instantiated.
#
###############################################################################

class DCNewCachedDocumentFailureException : DocumentCacheException
{
    DCNewCachedDocumentFailureException([string] $FullPath) : base()
    {
        $this.MainMessage = ($(
            "Unable to create a CacheDocument from the file " + `
            "at the following location: {0}") `
            -f $FullPath)
    }
}

###############################################################################
#   Exception class DCResponseConversionFailureException
#==============================================================================
#
#   Thrown by the [CachedDocument] class if a fetched resource cannot be
#   converted to UTF-8.
#
###############################################################################

class DCResponseConversionFailureException : DocumentCacheException
{
    DCResponseConversionFailureException([System.Uri] $Uri) : base()
    {
        $this.MainMessage = ($(
            "The resource at the following location " + `
            "cannot be converted to UTF-8: {0}") `
            -f $Uri.AbsoluteUri)
    }
}