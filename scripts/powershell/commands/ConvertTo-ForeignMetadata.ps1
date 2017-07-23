function ConvertTo-ForeignMetadata
{
    Param(
        [ValidateNotNull()]
        [string] $Path = ".",

        [ValidateSet("VorbisComment", "RawLyrics")]
        [string] $Format = "VorbisComment"
    )

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

    # Get the static metadata item
    $_staticItem = Get-UmsItem -Type "Static" -Path $Path

    # If no static item is available, we halt here
    if (-not $_staticItem)
    {
        Write-Warning -Message $ModuleStrings.Common.MissingUmsCache
        return
    }

    switch ($Format)
    {
        "VorbisComment"
        {
            # Source metadata must use the UMS Music Schema
            $_requiredNamespace = Get-UmsConfigurationItem -ShortName "MusicSchemaNamespace"

            # Select the music2vc stylesheet
            $_stylesheet = Get-UmsConfigurationItem -ShortName "Music2vcStylesheetUri"

            # Build transform arguments
            $_targetDirectory = (Get-Item -LiteralPath $Path).FullName
            $_targetDirectoryUri = (New-Object -Type System.Uri -ArgumentList $_targetDirectory).AbsoluteUri
            $_arguments = @{
                OutputDirectory = $_targetDirectoryUri;
                OutputMode = "VORBIS";
            }
        }

        "RawLyrics"
        {
            # Source namespace must be the music UMS Schema
            $_requiredNamespace = Get-UmsConfigurationItem -ShortName "MusicSchemaNamespace"

            # Select the music2vc stylesheet
            $_stylesheet = Get-UmsConfigurationItem -ShortName "Music2vcStylesheetUri"

            # Build transform arguments
            $_targetDirectory = (Get-Item -LiteralPath $Path).FullName
            $_targetDirectoryUri = (New-Object -Type System.Uri -ArgumentList $_targetDirectory).AbsoluteUri
            $_arguments = @{
                OutputDirectory = $_targetDirectoryUri;
                OutputMode = "RAWLYRICS";
            }
        }
    }

    # Source metadata must use the required UMS namespace
    if ($_staticItem.Namespace -ne $_requiredNamespace)
    {
        Write-Error -Message ($ModuleStrings.ConvertToForeignMetadata.BadSourceNamespace -f $_staticItem.Namespace,$_requiredNamespace )
        return
    }

    # Run the transform
    try 
    {
        Invoke-XslTransformer -Source $_staticItem.FullName -Stylesheet $_stylesheet -Arguments $_arguments
    }
    catch
    {
        Write-Error -Message $_.Exception.Message
        return
    }
}