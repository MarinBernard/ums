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

    [CmdletBinding(DefaultParametersetName='ByType')]
    Param(
        [Parameter(ParameterSetName="ByType")]
        [ValidateSet("All", "Catalog", "Schema", "Stylesheet", "StylesheetConstraint", "StylesheetOption", "Tool", "UmsOption")]
        [string[]] $Type = "All",

        [Parameter(ParameterSetName="ByShortName")]
        [ValidateSet(
            # Schema namespaces
            "AudioSchemaNamespace", "BaseSchemaNamespace", "MusicSchemaNamespace",

            # Stylesheet paths
            "ExpanderStylesheetUri", "Music2vcStylesheetUri",

            # Tool paths
            "JingJarPath", "JreBinPath", "SaxonJarPath",

            # UMS options
            "UmsFileExtension", "UmsCacheFolderName", "UmsFolderName", "UmsHiddenFolders")]
        [string] $ShortName
    )

    # Returning item from short name, if specified
    switch ($ShortName)
    {
        # Schema namespaces
        "AudioSchemaNamespace" { return (Get-UmsConfigurationItem -Type Schema | Where-Object { $_.Id -eq "audio" }).Namespace }
        "BaseSchemaNamespace"  { return (Get-UmsConfigurationItem -Type Schema | Where-Object { $_.Id -eq "base" }).Namespace }
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
        "UmsCacheFolderName"    { return (Get-UmsConfigurationItem -Type UmsOption | Where-Object { $_.Id -eq "ums-folder-name-cache" }).Value }
        "UmsFolderName"         { return (Get-UmsConfigurationItem -Type UmsOption | Where-Object { $_.Id -eq "ums-folder-name" }).Value }
        "UmsHiddenFolders"      { return (Get-UmsConfigurationItem -Type UmsOption | Where-Object { $_.Id -eq "ums-hidden-folders" }).Value }
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

    if (($Type -eq "all") -or ($Type -contains "stylesheetConstraint"))
    {
        $_stylesheets = $ConfigurationDocument | Select-Xml -XPath "/configuration/stylesheets/*"
        foreach ($_stylesheet in $_stylesheets)
        {
            # Returning stylesheet constraints
            $_documentElementConstraints = $_stylesheet.Node | Select-Xml -XPath "constraints/documentElement"
            foreach ($_documentElementConstraint in $_documentElementConstraints)
            {
                $_contentBindingElementSubConstraint = $_documentElementConstraint.Node | Select-Xml -Xpath "contentBindingElement"
                New-Object -Type PSCustomObject -Property @{
                    Type = "StylesheetConstraint";
                    SubType = "DocumentElementConstraint"
                    StylesheetId = $_stylesheet.Node.id;
                    StylesheetUri = $_stylesheet.Node.uri;
                    DocumentNamespace = $_documentElementConstraint.Node.namespace;
                    DocumentElement = $_documentElementConstraint.Node.element;
                    BindingNamespace = $_contentBindingElementSubConstraint.Node.Namespace;
                    BindingElement = $_contentBindingElementSubConstraint.Node.Element;
                }
            }
        }
    }

    if (($Type -eq "all") -or ($Type -contains "stylesheetOption"))
    {
        $_stylesheets = $ConfigurationDocument | Select-Xml -XPath "/configuration/stylesheets/*"
        foreach ($_stylesheet in $_stylesheets)
        {
            # Returning stylesheet options
            $_options = $_stylesheet.Node | Select-Xml -XPath "options/option"
            foreach ($_option in $_options)
            {
                New-Object -Type PSCustomObject -Property @{
                    Type = "StylesheetOption";
                    StylesheetId = $_stylesheet.Node.id;
                    StylesheetUri = $_stylesheet.Node.uri;
                    Id = $_option.Node.id;
                    Value = $_option.Node.'#Text'
                }
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