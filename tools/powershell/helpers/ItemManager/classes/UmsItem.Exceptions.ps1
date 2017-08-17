###############################################################################
#   Exception class UmsItemException
#==============================================================================
#
#   Parent class for all exceptions thrown by the [UmsItem] class.
#
###############################################################################

class UmsItemException : UmsException
{
    UmsItemException() : base()
    {}
}

###############################################################################
#   Exception class UIFileNotFoundException
#==============================================================================
#
#   Thrown when the [UmsItem] constructor cannot find the source UMS file.
#
###############################################################################

class UIFileNotFoundException : UmsItemException
{
    UIFileNotFoundException([System.IO.FileInfo] $File) : base()
    {
        $this.MainMessage = ($(
            "Unable to create a new instance as the UMS file at the " + `
            "following location does not exist: {0}") -f $File.FullName)
    }
}

###############################################################################
#   Exception class UIDocumentCreationFailureException
#==============================================================================
#
#   Thrown when the [DocumentCache] class threw an error when the [UmsItem]
#   constructor tried to retrieve a [UmsDocument] instance from the source
#   UMS file.
#
###############################################################################

class UIDocumentCreationFailureException : UmsItemException
{
    UIDocumentCreationFailureException([System.IO.FileInfo] $File) : base()
    {
        $this.MainMessage = ($(
            "Unable to obtain a UmsDocument instance from the UMS " + `
            "file at the following location: {0}") -f $File.FullName)
    }
}

###############################################################################
#   Exception class UIUriCreationFailureException
#==============================================================================
#
#   Thrown by the constructor when a path could not be parsed to a URI.
#
###############################################################################

class UIUriCreationFailureException : UmsItemException
{
    UIUriCreationFailureException([string] $Location) : base()
    {
        $this.MainMessage = ($(
            "Unable to parse the following string to a URI: {0}") `
            -f $Location)
    }
}