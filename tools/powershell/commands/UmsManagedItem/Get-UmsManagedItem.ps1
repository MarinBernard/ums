function Get-UmsManagedItem
{
    <#
    .SYNOPSIS
    Returns a list of managed UMS items for the specified folder.
    
    .DESCRIPTION
    This command lists all managed UMS items available in the specified folder.
    
    .PARAMETER Filter
    Allows to specify a file name filter. This parater is similar to the -Filter parameter of Get-ChildItem.

    .PARAMETER Path
    A path to a valid, UMS-enabled folder. Default is the current folder.

    .PARAMETER Cardinality
    Filters UMS items according to their cardinality. By default, the command returns UMS items with any cardinality. Use this parameter to filter the command output. Sidecar cardinality applies to UMS files which are linked to a companion file in the parent folder. Such files are XML documents beginning with a 'umsb:binding' root element, which 'binds' the companion file to specific metadata. 'Orphan' cardinality applies to Sidecar items which are missing a companion file. 'Independent' cardinality applies to any other kind of UMS item.

    .PARAMETER Validate
    Runs an XML validation for each UMS item.

    .PARAMETER Validity
    Filters UMS items according to the result of the XML validation. This parameter requires the presence of the -Validate switch.

    .EXAMPLE
    Get-UmsItem -Path "D:\MyMusic"
    #>

    [CmdletBinding(DefaultParametersetName='None')]
    Param(
        [Parameter(Position=0)]
        [string] $Filter,

        [Parameter(Position=1,ValueFromPipeline=$true)]
        [ValidateNotNull()]
        [System.IO.DirectoryInfo] $Path = ".",

        [ValidateSet("All", "Independent", "Sidecar", "Orphan")]
        [string[]] $Cardinality = "Any",

        [Parameter(ParameterSetName='WithValidation',Mandatory=$true)]
        [switch] $Validate,

        [Parameter(ParameterSetName='WithValidation',Mandatory=$false)]
        [ValidateSet("All", "Valid", "Invalid")]
        [string[]] $Validity = "All"
    )

    # Check whether UMS metadata are enabled
    try
    {  
        if (-not (Test-UmsManagement -Boolean -Path $Path))
        {
            Write-Warning -Message $ModuleStrings.Common.UmsNotEnabled
            return
        }
    }
    catch
    {
        Write-Host $_.Exception.Message
        return
    }

    ### From now on, we assume UMS is enabled and UMS items are available ###

    # Get path to the UMS folder
    $_umsFolderPath = Get-UmsManagementFolderPath -Path $Path
   
    # Build item list
    $_umsFileExtension = (
        [ConfigurationStore]::GetSystemItem("UmsFileExtension"))
    
    $_filter = $("*" + $_umsFileExtension)

    # Enumerate files from the local folder
    foreach ($_file in (Get-ChildItem -Path $_umsFolderPath -File -Filter $_filter))
    {
        # Apply filter, if specified
        if ($Filter)
        {
            if ($_file.Name -notlike $($Filter + $_umsFileExtension))
                { continue }
        }

        # Create item instance
        $_item = New-Object -Type UmsManagedItem -ArgumentList $_file

        # Filter by status
        if ($Cardinality -notcontains "Any")
        {
            if ($Cardinality -notcontains $_item.Cardinality)
                { continue }
        }

        # Add validation info
        if ($Validate.IsPresent)
        {
            # Get the URI to the Relax NG schema to use
            $_schemaUri = ([ConfigurationStore]::GetSchemaItem("") | 
                Where-Object { $_.Namespace -eq $_item.XmlNamespace }).Uri

            # Run XML validation
            $_validator = [RelaxNgValidator]::New($_schemaUri.LocalPath)
            $_isValid = $_validator.Validate($_item.Uri)

            if ($_isValid)
            {
                 $_item.Validity = [UIValidity]::Valid
            }
            else
            {
                $_item.Validity = [UIValidity]::Invalid
            }
        }

        # Filter by validity
        if ($Validity -notcontains "All")
        {
            if ($Validity -notcontains $_item.Validity)
                { continue }
        }

        # Return item instance
        $_item
    }
}