###############################################################################
#   Class UmsItem
#==============================================================================
#
#   This class describes an basic, unmanaged UMS item. A UMS item is the
#   internal representation of a UMS file. As a consequence, UMS items are
#   always instantiated from a file system object, either from a local file
#   system or from a network equivalent such as SMB, and cannot be created
#   from a URI.
#
#   Each UmsItem instance represents a file system file, and stores various
#   attributes such as:
#   - Attributes specific to the file itself, such as the file name, path, or
#       extension.
#   - A UmsDocument instance, which is the in-memory representation of the
#       XML document read from the UMS file.
#   - An optional UmsEntity instance, which is an in-memory, user-friendly
#       representation of the UMS metadata extracted from the UmsDocument.
#
###############################################################################

class UmsItem
{
    ###########################################################################
    # Static properties
    ###########################################################################

    ###########################################################################
    # Hidden properties
    ###########################################################################

    # A reference to the UmsDocument instance built from the file's content.
    hidden [UmsDocument] $Document

    # Properties describing the file from which the item was instantiated.
    hidden [System.IO.FileInfo] $File   # Reference to the item source file
    hidden [System.Uri] $Uri            # URI to $File
    hidden [System.Uri] $DirectoryUri   # URI to $File.Directory

    ###########################################################################
    # Visible properties
    ###########################################################################

    # Name of the UMS item. This name is not the same as the file name, which
    # is stored in the $File.Name property. The name of a UMS item is
    # equivalent to the base name of its source file (i.e.: without the file
    # extension).
    [string] $Name

    # Friendly-name of the XML schema linked to the XML namespace of the
    # document element. If the item cardinality is Sidecar/Orphan, the
    # value of this property is set to the friendly-name of the XML schema
    # of the binding element, instead of the document element.
    # The value of this property is proxified from the UmsDocument instance
    [string] $MainElementSchema

    # The full name of the main XML element of the document. If the item
    # includes a binding document, this property is set to the name of
    # the binding element. Otherwise, it is set to the name of the document
    # element.
    # The value of this property is proxified from the UmsDocument instance
    [string] $MainElementName

    # Validation status of the UMS item. Validation is CPU intensive, and does
    # not occur automatically.
    # The value of this property is proxified from the UmsDocument instance
    [UmsDocumentValidity] $Validity = [UmsDocumentValidity]::Unknown

    ###########################################################################
    # Constructors
    ###########################################################################

    # Constructs a new UmsItem instance from a reference to a file. The file
    # must exist and be a valid UMS document.
    # Throws:
    #   - [UIFileNotFoundException] if the supplied UMS file does not exist.
    #   - [UIUriCreationFailureException] if the full path to the source file
    #       or to the source directory cannot be transformed to a URI.
    #   - [UIDocumentCreationFailureException] if a UmsDocument instance cannot
    #       be created from the source file.
    UmsItem([System.IO.FileInfo] $File)
    {
        # Unable to instantiate if the source UMS file does not exist.
        if (-not $File.Exists)
        {
            throw [UIFileNotFoundException]::New($File)
        }

        # Store a reference to the source file
        $this.File = $File

        # Create a URI to the source file
        try
        {
            $this.Uri = [System.Uri]::New($this.File.FullName)
        }
        catch [System.SystemException]
        {
            [EventLogger]::LogException($_.Exception)
            throw [UIUriCreationFailureException]::New(
                $this.File.FullName)
        }

        # Create a URI to the source directory
        try
        {
            $this.DirectoryUri = (
                [System.Uri]::New($this.File.Directory.FullName))
        }
        catch [System.SystemException]
        {
            [EventLogger]::LogException($_.Exception)
            throw [UIUriCreationFailureException]::New(
                $this.File.Directory.FullName)
        }

        # Update public properties
        $this.Name = $this.File.BaseName

        # Try to obtain the UmsDocument instance
        try
        {
            $this.Document = [DocumentFactory]::GetDocument($this.Uri)
        }
        catch [DocumentFactoryException]
        {
            [EventLogger]::LogException($_.Exception)
            throw [UIDocumentCreationFailureException]::New($this.File)
        }

        # Update properties which are proxified from the UmsDocumentInstance
        $this.UpdateDocumentProperties()  
    }

    ###########################################################################
    # Helpers
    ###########################################################################

    # Updates all document properties which are proxified from the UmsDocument
    # instance.
    [void] UpdateDocumentProperties()
    {
        $this.Validity = $this.Document.Validity
        $this.MainElementSchema = $this.Document.MainSchema
        $this.MainElementName = $this.Document.MainName
    }

    # String representation
    [string] ToString()
    {
        return $this.Name
    } 
}