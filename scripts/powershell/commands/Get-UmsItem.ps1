function Get-UmsItem
{
    Param(
        [ValidateNotNull()]
        [string] $Path = ".",

        [ValidateSet("All", "Static", "Main")]
        [string] $Type = "All",

        [switch] $Validate
    )

    # Check whether UMS metadata are enabled
    try
    {  
        if (-not (Test-UmsMetadata -Boolean -Path $Path))
        {
            Write-Warning -Message $ModuleStrings.EnableUmsMetadata.UmsNotEnabled
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
    $_umsFolderPath = Get-UmsMetadataFolderPath -Path $Path
    
    # Build record list
    $_filter = $("*" + $ModuleConfig.UMS.MetadataFiles.Extension)
    $_files = Get-ChildItem -Path $_umsFolderPath -Filter $_filter
    foreach( $_file in $_files )
    {
        # Filters
        $_proceed = $true
        switch ($Type)
        {
            "Main"
            {
                $_mainFileName = $($ModuleConfig.UMS.MetadataFiles.MainFileName + $ModuleConfig.UMS.MetadataFiles.Extension)
                if ($_file.Name -ne $_mainFileName){ $_proceed = $false }
            }

            "Static"
            {
                $_staticFileName = $($ModuleConfig.UMS.MetadataFiles.StaticFileName + $ModuleConfig.UMS.MetadataFiles.Extension)
                if ($_file.Name -ne $_staticFileName){ $_proceed = $false }
            }
        }
        if ($_proceed -eq $false){ continue }

        # Basic properties
        $_properties = @{
            Name            =   $_file.BaseName
            FullName        =   $_file.FullName
            Length          =   $_file.Length
            LastWriteTime   =   $_file.LastWriteTime
        }

        # Add namespace info
        $_properties += @{ Namespace = (Read-XmlNamespaceURI -Path $_file.FullName) }

        # Add validation info
        if ($Validate.IsPresent)
        {
            if (Run-UmsXmlValidation -Path $_file.FullName)
            {
                $_properties += @{ State = "Invalid" }
            }
            else
            {
                $_properties += @{ State = "Valid" }
            }
        }

        # Return an object instance
        New-Object -Type PSCustomObject -Property $_properties
    }
}