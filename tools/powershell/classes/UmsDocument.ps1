###############################################################################
#   Class UmsDocument
#==============================================================================
#
#   This class describes a UMS document. It embeds a XmlDocument representation
#   of an UMS document, exposes various properties about the document, and
#   provides helper methods regarding document validation.
#
###############################################################################

class UmsDocument
{
    ###########################################################################
    # Static properties
    ###########################################################################

    # Catalog of namespace URIs.
    static [hashtable] $NamespaceUri = @{
        "Base"  = [ConfigurationStore]::GetSchemaItem("Base").Namespace;
        "Audio" = [ConfigurationStore]::GetSchemaItem("Audio").Namespace;
        "Music" = [ConfigurationStore]::GetSchemaItem("Music").Namespace;
    }

    ###########################################################################
    # Hidden properties
    ###########################################################################

    # The in-memory XML representation of the UMS document.
    hidden [System.Xml.XmlDocument] $Document

    # Uri to the authoritative schema file. Needed for validation.
    hidden [System.Uri] $SchemaFileUri

    # Properties describing the document element of the document.
    hidden [string] $RootLocalName      # Local name of the document element
    hidden [string] $RootName           # Full name of the document element
    hidden [string] $RootNamespace      # Namespace of the document element

    # Properties describing the binding element of the document, if present.
    hidden [string] $BindingLocalName   # Local name of binding elmnt, if any
    hidden [string] $BindingName        # Full name of binding element, if any
    hidden [string] $BindingNamespace   # Namespace of binding element, if any

    ###########################################################################
    # Visible properties
    ###########################################################################

    # Internal name of the XML schema linked to the XML namespace of the
    # document element.
    [string] $RootSchema

    # Reference to the document element.
    [System.Xml.XmlElement] $RootElement

    # Internal name of the XML schema linked to the XML namespace of the
    # binding element, if present.
    [string] $BindingSchema

    # Reference to the binding element.
    [System.Xml.XmlElement] $BindingElement

    # Validation status of the document. Validation is CPU intensive, and does
    # not occur automatically. This property is set to Unknown by default, and
    # will show this value until validation is eventually triggered.
    [UmsDocumentValidity] $Validity = [UmsDocumentValidity]::Unknown

    ###########################################################################
    # Constructors
    ###########################################################################

    # Default constructor. Builds an instance from a UMS document passed as a
    # simple string. Throws:
    #   - [UDParseFailureException] if the document cannot be parsed.
    #   - [UDBadRootNamespaceException] if the document element belongs to an
    #       unsupported XML namespace.
    #   - [UDBadbindingNamespaceException] if the binding element belongs to an
    #       unsupported XML namespace.
    UmsDocument([string] $DocumentString)
    {
        # Try to instantiate the XML document.
        try
        {
            $this.Document = [System.Xml.XmlDocument] ($DocumentString)
        }
        catch [System.Xml.XmlException]
        {
            Write-Error -Exception $_.Exception
            throw [UDParseFailureException]::New()
        }

        # Set default validity
        $this.Validity = [UmsDocumentValidity]::Unknown

        # Set properties related to the document element
        $this.RootElement = $this.Document.DocumentElement
        $this.RootLocalName = $this.RootElement.LocalName
        $this.RootName = $this.RootElement.Name
        $this.RootNamespace = $this.RootElement.NamespaceURI

        # Extract the namespace id of the root element
        try
        {
            $this.RootSchema = (
                [ConfigurationStore]::GetSchemaItem("") | Where-Object {
                    $_.Namespace -eq $this.RootNamespace }).Id
        }
        catch [ConfigurationStoreException]
        {
            Write-Error -Message $_.Exception.Message
            throw [UDBadRootNamespaceException]::New($this.RootNamespace)
        }

        # Set properties related to the binding element
        if (
            ($this.RootNamespace -eq ([UmsDocument]::NamespaceUri.Base)) -and
            ($this.RootLocalName -eq "file"))
        {
            $this.BindingElement = $this.Document.DocumentElement.FirstChild
            $this.BindingLocalName = $this.BindingElement.LocalName
            $this.BindingName = $this.BindingElement.Name
            $this.BindingNamespace = $this.BindingElement.NamespaceURI
        }

        # Extract the namespace id of the binding element
        try
        {
            $this.BindingSchema = (
                [ConfigurationStore]::GetSchemaItem("") | Where-Object {
                    $_.Namespace -eq $this.BindingNamespace }).Id
        }
        catch [ConfigurationStoreException]
        {
            Write-Error -Message $_.Exception.Message
            throw [UDBadBindingNamespaceException]::New($this.BindingNamespace)
        }

        # Store the URI to the schema file
        try
        {
            $this.SchemaFileUri = [System.Uri] (
                [ConfigurationStore]::GetSchemaItem($this.RootSchema).Uri)
        }
        catch [ConfigurationStoreException]
        {
            Write-Error -Message $_.Exception.Message
            throw [UDBadRootNamespaceException]::New($this.RootNamespace)
        }
    }

    ###########################################################################
    # Helpers
    ###########################################################################

    # Validates the document against a UMS schema, then updates the $Validity
    # property according to the result of the validation.
    # Throws:
    #   - [UDValidationFailureException] if the document cannot be validated.
    [void] Validate()
    {
        # Initialize a validator instance
        [RelaxNgValidator] $_validator = $null
        try
        {
            $_validator = [RelaxNgValidator]::New(
                $this.SchemaFileUri.LocalPath)
        }
        catch [RelaxNgValidatorException]
        {
            Write-Host -Message $_.Exception.MainMessage
            throw [UDValidationFailureException]::New()
        }

        # Get a handle to a temporary file
        [System.IO.FileInfo] $_tempFile = $null
        try
        {
            $_tempFile = New-TemporaryFile -ErrorAction Stop
        }
        # Not sure this is the right exception type.
        # Documentation is missing for PS exceptions.
        catch [System.Exception]
        {
            Write-Error -Exception $_.Exception
            throw [UDValidationFailureException]::New()
        }

        # Store the document into the temporary file
        try
        {
            $this.Document.Save($_tempFile)
        }
        catch [System.Xml.XmlException]
        {
            Write-Error -Exception $_.Exception
            throw [UDValidationFailureException]::New()
        }

        # Validate the file
        [bool] $_isValid = $null
        try
        {
            $_isValid = $_validator.Validate($_tempFile.FullName)
        }
        catch [RelaxNgValidatorException]
        {
            Write-Host -Message $_.Exception.MainMessage
            throw [UDValidationFailureException]::New()
        }
        finally
        {
            # Remove the temporary file
            Remove-Item -Force -Path $_tempFile
        }

        # Update validation status
        if ($_isValid)
        {
            $this.Validity = [UmsDocumentValidity]::Valid
        }
        else
        {
            $this.Validity = [UmsDocumentValidity]::Invalid
        }
    }
}

Enum UmsDocumentValidity
{
    Unknown
    Valid
    Invalid
}