function Get-UmsConfigurationItem
{
    <#
    .SYNOPSIS
    Returns a list of UMS configuration items.
    
    .DESCRIPTION
    This commands parses the UMS configuration file and returns a collection of configuration items.
    
    .PARAMETER Type
    The type of the configuration item to return. Default is 'All'.

    .PARAMETER ShortName
    The short name of a configuration item shortcut.
    
    .EXAMPLE
    Get-UmsConfigurationItem -Type "Schema"
    #>

    Param(
        [Parameter(ParameterSetName="ByType")]
        [ValidateSet("All", "Catalog", "Schema", "Stylesheet", "Tool", "UmsOption")]
        [string[]] $Type = "All",

        [Parameter(ParameterSetName="ByShortName")]
        [ValidateSet(
            # Schema namespaces
            "MusicSchemaNamespace",

            # Stylesheet paths
            "ExpanderStylesheetUri", "Music2vcStylesheetUri",

            # Tool paths
            "JingJarPath", "JreBinPath", "SaxonJarPath",

            # UMS options
            "UmsFileExtension", "UmsFolderName", "UmsHiddenFolders", "UmsMainFileBaseName", "UmsMainFileName", "UmsStaticFileBaseName",
            "UmsStaticFileName")]
        [string] $ShortName
    )

    # Returning item from short name, if specified
    switch ($ShortName)
    {
        # Schema namespaces
        "MusicSchemaNamespace" { return (Get-UmsConfigurationItem -Type Schema | Where-Object { $_.Id -eq "music" }).Namespace }

        # Stylesheet paths
        "ExpanderStylesheetUri" { return (Get-UmsConfigurationItem -Type Stylesheet | Where-Object { $_.Id -eq "expander" }).Uri }
        "Music2vcStylesheetUri" { return (Get-UmsConfigurationItem -Type Stylesheet | Where-Object { $_.Id -eq "music2vc" }).Uri }

        # Tools paths
        "JingJarPath"           { return (Get-UmsConfigurationItem -Type Tool | Where-Object { $_.Id -eq "jing-jar" }).Path }
        "JreBinPath"            { return (Get-UmsConfigurationItem -Type Tool | Where-Object { $_.Id -eq "jre-bin" }).Path }
        "SaxonJarPath"          { return (Get-UmsConfigurationItem -Type Tool | Where-Object { $_.Id -eq "saxon-jar" }).Path }        

        # UMS Options
        "UmsFileExtension"      { return (Get-UmsConfigurationItem -Type UmsOption | Where-Object { $_.Id -eq "ums-file-extension" }).Value }
        "UmsFolderName"         { return (Get-UmsConfigurationItem -Type UmsOption | Where-Object { $_.Id -eq "ums-folder-name" }).Value }
        "UmsHiddenFolders"      { return (Get-UmsConfigurationItem -Type UmsOption | Where-Object { $_.Id -eq "ums-hidden-folders" }).Value }
        "UmsMainFileBaseName"   { return (Get-UmsConfigurationItem -Type UmsOption | Where-Object { $_.Id -eq "ums-main-file-name" }).Value }
        "UmsMainFileName"       { return (Get-UmsConfigurationItem -ShortName "UmsMainFileBaseName") + (Get-UmsConfigurationItem -ShortName "UmsFileExtension") }
        "UmsStaticFileBaseName" { return (Get-UmsConfigurationItem -Type UmsOption | Where-Object { $_.Id -eq "ums-static-file-name" }).Value }
        "UmsStaticFileName"     { return (Get-UmsConfigurationItem -ShortName "UmsStaticFileBaseName") + (Get-UmsConfigurationItem -ShortName "UmsFileExtension") }
    }

    # Normal evaluation
    if (($Type -eq "all") -or ($Type -contains "catalog"))
    {
        $_catalogs = $ConfigurationDocument | Select-Xml -XPath "/configuration/catalogs/*"
        foreach ($_catalog in $_catalogs)
        {
            # Extracting catalog mappings
            $_mappings = @()
            foreach ($_mapping in $_catalog.Node.mapping)
            {
                $_mappings += New-Object -Type PSCustomObject -Property @{
                    Element = $_mapping.element;
                    SubPath = $_mapping.subpath;
                }
            }
            # Returning catalog object
            New-Object -Type PSCustomObject -Property @{
                Type = "Catalog";
                Id = $_catalog.Node.id;
                Namespace = $_catalog.Node.namespace;
                Uri = $_catalog.Node.uri;
                Mappings = $_mappings;
            }   
        }
    }

    if (($Type -eq "all") -or ($Type -contains "schema"))
    {
        $_schemas = $ConfigurationDocument | Select-Xml -XPath "/configuration/schemas/*"
        foreach ($_schema in $_schemas)
        {
            # Returning schema object
            New-Object -Type PSCustomObject -Property @{
                Type = "Schema";
                Id = $_schema.Node.id;
                Namespace = $_schema.Node.namespace;
                Uri = $_schema.Node.uri;
            }   
        }
    }

    if (($Type -eq "all") -or ($Type -contains "stylesheet"))
    {
        $_stylesheets = $ConfigurationDocument | Select-Xml -XPath "/configuration/stylesheets/*"
        foreach ($_stylesheet in $_stylesheets)
        {
            # Returning stylesheet object
            New-Object -Type PSCustomObject -Property @{
                Type = "Stylesheet";
                Id = $_stylesheet.Node.id;
                Uri = $_stylesheet.Node.uri;
            }   
        }
    }

    if (($Type -eq "all") -or ($Type -contains "tool"))
    {
        $_tools = $ConfigurationDocument | Select-Xml -XPath "/configuration/tools/*"
        foreach ($_tool in $_tools)
        {
            # Returning tool object
            New-Object -Type PSCustomObject -Property @{
                Type = "Tool";
                Id = $_tool.Node.id;
                Path = $_tool.Node.path;
            }   
        }
    }

    if (($Type -eq "all") -or ($Type -contains "umsoption"))
    {
        $_umsOptions = $ConfigurationDocument | Select-Xml -XPath "/configuration/umsOptions/*"
        foreach ($_umsOption in $_umsOptions)
        {
            # Returning umsOption object
            New-Object -Type PSCustomObject -Property @{
                Type = "UmsOption";
                Id = $_umsOption.Node.id;
                Value = $_umsOption.Node.'#text';
            }   
        }
    }
}