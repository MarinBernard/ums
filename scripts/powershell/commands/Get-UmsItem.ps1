function Get-UmsItem
{
    <#
    .SYNOPSIS
    Returns a list of UMS items for the specified folder.
    
    .DESCRIPTION
    This command lists all UMS items available in the specified folder.
    
    .PARAMETER Path
    A path to a valid, UMS-enabled folder. Default is the current folder.

    .PARAMETER Status
    Filters UMS items according to their status.

    .PARAMETER Validate
    Runs an XML validation for each UMS item.

    .PARAMETER Validity
    Filters UMS items according to the result of the XML validation. This parameter requires the presence of the -Validate switch.
    
    .EXAMPLE
    Update-UmsCache -Path "D:\MyMusic"
    #>

    [CmdletBinding(DefaultParametersetName='None')]
    Param(
        [Parameter(ParameterSetName='LiteralPath',Position=0)]
        [ValidateNotNull()]
        [string] $Path = ".",

        [Parameter(ParameterSetName='ObjectPath',Position=0,ValueFromPipeline=$true)]
        [ValidateNotNull()]
        [System.IO.DirectoryInfo] $DirectoryInfo,

        [ValidateSet("All", "Independent", "Sidecar", "Orphan")]
        [string[]] $Cardinality = "Any",

        [Parameter(ParameterSetName='WithValidation',Mandatory=$true)]
        [switch] $Validate,

        [Parameter(ParameterSetName='WithValidation',Mandatory=$false)]
        [ValidateSet("All", "Valid", "Invalid")]
        [string[]] $Validity = "All"
    )

    # Convert DirectoryInfo object to string
    if ($PsCmdLet.ParameterSetName -eq "ObjectPath")
    {
        $Path = $DirectoryInfo.FullName
    }

    # Check whether UMS metadata are enabled
    try
    {  
        if (-not (Test-UmsMetadata -Boolean -Path $Path))
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
    $_umsFolderPath = Get-UmsSpecialFolderPath -Path $Path
   
    # Build item list
    $_umsLocalFileExtension = Get-UmsConfigurationItem -ShortName "UmsLocalFileExtension"
    $_filter = $("*" + $_umsLocalFileExtension)

    # Enumerate files from the local folder
    foreach ($_file in (Get-ChildItem -Path $_umsFolderPath -File -Filter $_filter))
    {
        # Create item instance
        $_item = New-Object -Type UmsItem -ArgumentList $_file

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
            $_schemaUri = (Get-UmsConfigurationItem -Type Schema | Where-Object { $_.Namespace -eq $_item.XmlNamespace }).Uri

            # Run XML validation
            $_isInvalid = Invoke-XmlValidator -Source $_item.Uri -Schema $_schemaUri

            if ($_isInvalid)
            {
                 $_item.Validity = [UmsItemValidity]::Invalid
            }
            else
            {
                $_item.Validity = [UmsItemValidity]::Valid
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