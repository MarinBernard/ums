function Update-UmsItem
{
    <#
    .SYNOPSIS
    Update the static and cached version of an UMS item.
    
    .DESCRIPTION
    Update the static and cached version of an UMS item. Static metadata are stored locally and consist of a single, dependency-free UMS file. Most advanced metadata converters use cached versions as a data source, and expect them to be up-to-date.
    
    .PARAMETER FileInfo
    A valid FileInfo instance as returned by the Get-Item command. Use this parameter to trigger cache update on a sidecar UMS item by specifying a reference to its linked file.

    .PARAMETER Item
    A valid UmsItem instance. Use Get-UmsItem to retrieve UmsItem instances.    

    .PARAMETER Force
    Force cache update even if it is not necessary. Default is to skip cache updates if the cached file is newer than the source UMS item.
    
    .EXAMPLE
    Get-UmsItem -Path "D:\MyMusic" -Status Sidecar | Update-UmsItem
    #>

    [CmdletBinding(DefaultParametersetName='None')]
    Param(
        [Parameter(ParameterSetName='FileInfoInstance',Position=0,Mandatory=$true,ValueFromPipeline=$true)]  
        [ValidateNotNull()]
        [System.IO.FileInfo[]] $FileInfo,

        [Parameter(ParameterSetName='ItemInstance',Position=0,Mandatory=$true,ValueFromPipeline=$true)]
        [ValidateNotNull()]
        [UmsItem[]] $Item,

        [switch] $Force
    )
    
    Begin
    {
        # Get the expander stylesheet URI
        $_stylesheetUri = Get-UmsConfigurationItem -ShortName "ExpanderStylesheetUri"
    }

    Process
    {
        # If FileInfo were specified, we need to retrieve an UmsItem instance
        # which is the sidecar file of the target file.
        if($FileInfo)
        {
            $_item = $FileInfo.Directory | Get-UmsItem -Cardinality Sidecar | Where-Object { $_.LinkedFileName -eq $FileInfo.Name }
            if ($Item)
                { $Item = $_item }
            else
            {
                Write-Warning -Message $($FileInfo.Name + ": " + $ModuleStrings.Common.MissingSidecarFile)
                continue
            }
        }

        # Check whether the update is needed
        if (($Item.StaticVersion -eq [UIStaticVersionStatus]::Current) -and (-not $Force.IsPresent))
        {
            Write-Host $($Item.Name + ": " + $ModuleStrings.UpdateUmsItem.NoUpdateNeeded)
            return
        }
        
        # Get the full name of the static file
        $_staticFileFullName = $Item.StaticFileFullName

        # Build the name of the temporary destination file
        $_tempFileFullName = $($_staticFileFullName + ".tmp")

        # Remove previous temporary file, if needed
        if (Test-Path -LiteralPath $_tempFileFullName)
        {
            try
                { Remove-Item -LiteralPath $_tempFileFullName -Force -ErrorAction "Stop" }
            catch
                { throw $ModuleStrings.UpdateUmsItem.TempFileRemovalFailure }
        }

        # Run XSL transform
        try 
        {
            Invoke-XslTransformer -Source $Item.Uri -Stylesheet $_stylesheetUri -Destination $_tempFileFullName
        }
        catch
        {
            # Temporary file should be removed if transform has failed
            Remove-Item -Force -LiteralPath $_tempFileFullName -ErrorAction SilentlyContinue
            Write-Error -Message $_.Exception.Message
            return
        }

        # Instantiate temporary file
        $_tempItem = New-object -Type UmsItem -ArgumentList (Get-Item -LiteralPath $_tempFileFullName)
        
        # Validate the temporary file
        $_schemaUri = (Get-UmsConfigurationItem -Type Schema | Where-Object { $_.Namespace -eq $_tempItem.XmlNamespace }).Uri
        $_isInvalid = Invoke-XmlValidator -Source $_tempItem.Uri -Schema $_schemaUri

        # Check validation result
        if ($_isInvalid)
        {
            # Temporary file should be removed if validation has failed
            Remove-Item -Force -LiteralPath $_tempFileFullName
            throw $ModuleStrings.UpdateUmsItem.ValidationFailure
        }

        # Promote temporary file to be the new static file
        try
        {
            # Remove pre-existing static file, if it exists
            if (Test-Path -LiteralPath $_staticFileFullName)
                { Remove-Item -Force -LiteralPath $_staticFileFullName }
            
            # Promote temporary file to static item
            Move-Item -Path $_tempFileFullName -Destination $_staticFileFullName
        }

        # Catch promotion failure
        catch
        {
            # Temporary file should be removed if validation has failed
            Remove-Item -Force -LiteralPath $_tempFileFullName
            throw $ModuleStrings.UpdateUmsItem.PromotionFailure
        }
    }
}