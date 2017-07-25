class UmsItem
{
    ###########################################################################
    # Attributes and properties
    ###########################################################################
    # Properties describing the item itself
    hidden [string] $Extension          # Extension of the UMS file
    hidden [string] $FullName           # Fully qualified name of the UMS file
    hidden [string] $RealName           # Local name of the UMS file
    hidden [string] $Path               # Fully qualified path of the UMS file
    hidden [string] $Uri                # Absolute URI to $FullName
    hidden [string] $PathUri            # Absolute URI to $Path
    hidden [string] $LastWriteTime      # Last write time of the UMS file
    hidden [string] $ManagedPath        # Fully qualified path of the folder
                                        # containing linked files

    # Properties related to the static version of the item
    hidden [string] $StaticPath                 # Fully qualified path to the
                                                # UMS static folder
    hidden [string] $StaticPathUri              # Absolute URI to $StaticPath
    hidden [string] $StaticFileFullName         # Fully qualified name of the
                                                # static file of this instance
    hidden [string] $StaticFileUri              # Absolute URI to $StaticFileFullName
    hidden [string] $StaticFileLastWriteTime    # Last write time of the static file

    # Properties describing the linked file
    hidden [string] $LinkedFileName
    hidden [string] $LinkedFileExtension
    hidden [string] $LinkedFileBaseName
    hidden [string] $LinkedFileFullName
    hidden [string] $LinkedFilePath
    hidden [string] $LinkedFileUri
    hidden [string] $LinkedFilePathUri
    hidden [string] $LinkedFileLastWriteTime

    # Properties describing document content
    hidden [string] $XmlNamespace
    hidden [string] $XmlElementName
    hidden [string] $BindingNamespace
    hidden [string] $BindingSchema
    hidden [string] $BindingElementName

    # Visible properties
    [string] $Name
    [string] $Schema
    [string] $BindingElement = "None"
    [UmsItemCardinality] $Cardinality = [UmsItemCardinality]::Unknown
    [UmsItemStaticVersionStatus] $StaticVersion = [UmsItemStaticVersionStatus]::Unknown
    [UmsItemValidity] $Validity = [UmsItemValidity]::Unknown

    ###########################################################################
    # Constructor
    ###########################################################################
    UmsItem([System.IO.FileInfo] $FileInfo)
    {
        # Main properties
        $this.Extension = $FileInfo.Extension
        $this.RealName = $FileInfo.Name
        $this.Path = $FileInfo.Directory.FullName
        $this.ManagedPath = $FileInfo.Directory.Parent.FullName
        $this.FullName = $FileInfo.FullName
        $this.Uri = (New-Object -Type System.Uri -ArgumentList $this.FullName).AbsoluteUri
        $this.PathUri = (New-Object -Type System.Uri -ArgumentList $this.Path).AbsoluteUri
        $this.LastWriteTime = $FileInfo.LastWriteTime
        $this.Name = $FileInfo.BaseName
        
        # Calling sub-constructor for static information
        $this.constructStaticInformation($FileInfo)

        # Calling sub-constructor for cardinality information
        $this.constructCardinalityInformation($FileInfo)

        # Calling sub-constructor for XML content information
        $this.constructContentInformation($FileInfo)
    }

    # Sub-constructor for static information
    [void] constructStaticInformation([System.IO.FileInfo] $FileInfo)
    {
        # Static file properties
        $this.StaticPath = Get-UmsManagementFolderPath -Type "Static" -Path $this.ManagedPath
        $this.StaticPathUri = (New-Object -Type System.Uri -ArgumentList $this.StaticPath).AbsoluteUri
        $this.StaticFileFullName = Join-Path -Path $this.StaticPath -ChildPath $this.RealName
        $this.StaticFileUri = (New-Object -Type System.Uri -ArgumentList $this.StaticFileFullName).AbsoluteUri

        # Static version status
        if (Test-Path -Path $this.StaticFileFullName)
        {
            $this.StaticFileLastWriteTime = (Get-Item -LiteralPath $this.StaticFileFullName).LastWriteTime
            
            # Init static version status
            if ($this.LastWriteTime -gt $this.StaticFileLastWriteTime)
                {  $this.StaticVersion = [UmsItemStaticVersionStatus]::Expired }
            else
                {  $this.StaticVersion = [UmsItemStaticVersionStatus]::Current }
        }
        else
            { $this.StaticVersion = [UmsItemStaticVersionStatus]::Absent }
    }

    # Sub-constructor for cardinality information
    [void] constructCardinalityInformation([System.IO.FileInfo] $FileInfo)
    {
        # If the item is independent
        if ($this.Name[0] -eq "_")
        {
            [UmsItemCardinality] $this.Cardinality = [UmsItemCardinality]::Independent
            # Remove prefix from item name
            $this.Name = $this.Name.Substring(1)
        }
        # Else, cardinality is orphan or sidecar
        else
        {
            # Update hidden properties
            $this.LinkedFileName = $FileInfo.BaseName
            $this.LinkedFilePath = $this.ManagedPath
            $this.LinkedFileFullName = Join-Path -Path $this.LinkedFilePath -ChildPath $this.LinkedFileName
            $this.LinkedFileExtension = [System.IO.Path]::GetExtension($this.LinkedFileName)
            $this.LinkedFileUri = (New-Object -Type System.Uri -ArgumentList $this.LinkedFileFullName).AbsoluteUri
            $this.LinkedFilePathUri = (New-Object -Type System.Uri -ArgumentList $this.LinkedFilePath).AbsoluteUri
            $_tmpBaseName = [System.IO.Path]::ChangeExtension($this.LinkedFileName, $null)
            $this.LinkedFileBaseName = $_tmpBaseName.Substring(0, $_tmpBaseName.Length - 1)
            
            # Check item link status
            if (Test-Path -Path $this.LinkedFileFullName)
            {
                $this.LinkedFileLastWriteTime = (Get-Item -LiteralPath $this.LinkedFileFullName).LastWriteTime
                $this.Cardinality = [UmsItemCardinality]::Sidecar
            }
            else
            {
                $this.Cardinality = [UmsItemCardinality]::Orphan
            }
        }
    }

    # Sub-constructor for content information
    [void] constructContentInformation([System.IO.FileInfo] $FileInfo)
    {
        # Read XML document
        [xml] $_xmlDocument = Get-Content -Path $this.FullName

        # Get and store XML namespace and document element
        $this.XmlNamespace = $_xmlDocument.DocumentElement.NamespaceURI
        $this.XmlElementName = $_xmlDocument.DocumentElement.LocalName

        # Resolve schema friendly name
        $this.Schema = (Get-UmsConfigurationItem -Type "Schema" | Where-Object { $_.Namespace -eq $this.XmlNamespace }).Id

        # Get and store content binding information (only for sidecar files)
        if ($this.Cardinality -eq [UmsItemCardinality]::Sidecar)
        {
            $this.BindingNamespace = $_xmlDocument.DocumentElement.contentBinding.FirstChild.NamespaceURI
            $this.BindingElementName = $_xmlDocument.DocumentElement.contentBinding.FirstChild.LocalName
            $this.BindingElement = $_xmlDocument.DocumentElement.contentBinding.FirstChild.Name
            $this.BindingSchema = (Get-UmsConfigurationItem -Type "Schema" | Where-Object { $_.Namespace -eq $this.BindingNamespace }).Id
        }
    }

    # String representation
    [string] ToString()
    {
        return $this._name
    } 
}

Enum UmsItemStaticVersionStatus
{
    Unknown
    Absent
    Current
    Expired
}

Enum UmsItemCardinality
{
    Unknown
    Independent
    Sidecar
    Orphan
}

Enum UmsItemValidity
{
    Unknown
    Valid
    Invalid
}