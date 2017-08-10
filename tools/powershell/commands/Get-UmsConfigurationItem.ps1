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
        [ValidateSet("All", "Catalog", "Schema", "Stylesheet", "StylesheetConstraint", "StylesheetOption", "Tool", "Rendering", "System")]
        [string[]] $Type = "All",

        [Parameter(ParameterSetName="ByShortName")]
        [ValidateSet(
            # Schema namespaces
            "AudioSchemaNamespace", "BaseSchemaNamespace", "MusicSchemaNamespace",

            # Stylesheet paths
            "ExpanderStylesheetUri", "Music2vcStylesheetUri",

            # Tool paths
            "JingJarPath", "JreBinPath", "SaxonJarPath",          

            # Rendering options
            "CatalogIdDelimiter",
            "CatalogIdListPrefix",
            "CatalogIdListSuffix",
            "CharacterDelimiter",
            "CharacterListPrefix",
            "CharacterListSuffix",
            "ComposerDelimiter",
            "ComposerListPrefix",
            "ComposerListSuffix",
            "EventDatePlaceDelimiter",
            "FallbackLanguage",
            "FormDelimiter",
            "FormListPrefix",
            "FormListSuffix",
            "FullDateFormat",
            "IncipitPrefix",
            "IncipitSuffix",
            "KeyListPrefix",
            "KeyListSuffix",
            "MediumNumberFormat",
            "MediumTitlePrefix",
            "MediumTitleSuffix",
            "MovementTitleInfix",
            "PerformanceYearPrefix",
            "PerformerDelimiter",
            "PerformerListPrefix",
            "PerformerListSuffix",
            "PlaceDelimiter",
            "PlayedInstrumentPrefix",
            "PlayedInstrumentSuffix",
            "PreferCommonNames",
            "PreferCommonLabels",
            "PreferShortKeys",
            "PseudonymPrefix",
            "PseudonymSuffix",
            "ShowCatalogIds",
            "ShowCharacterList",
            "ShowComposerList",
            "ShowMediumTitle",
            "ShowMovementIncipit",
            "ShowMovementTitle",
            "ShowMusicalForm",
            "ShowMusicalKey",
            "ShowPlayedInstrument",
            "ShowPseudonyms",
            "ShowTempoMarking",
            "SortNameDelimiter",
            "TempoMarkingListPrefix",
            "TempoMarkingListSuffix",
            "UseDefaultVariants",
            "UseFakeSortVariants",
            "UseOriginalVariants",
            "YearDateFormat",
            "YearMonthDateFormat",

            # System options
            "UmsCacheFolderName",
            "UmsFileExtension",
            "UmsFolderName",
            "UmsHiddenFolders",
            "UmsStaticFolderName")]
        [string] $ShortName
    )

    # Returning item from short name, if specified
    if ($ShortName)
    {
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

            # System Options
            "UmsCacheFolderName"       { return (Get-UmsConfigurationItem -Type System | Where-Object { $_.Id -eq "ums-folder-name-cache" }).Value }
            "UmsFileExtension"         { return (Get-UmsConfigurationItem -Type System | Where-Object { $_.Id -eq "ums-file-extension" }).Value }
            "UmsFolderName"            { return (Get-UmsConfigurationItem -Type System | Where-Object { $_.Id -eq "ums-folder-name" }).Value }
            "UmsHiddenFolders"         { return (Get-UmsConfigurationItem -Type System | Where-Object { $_.Id -eq "ums-hidden-folders" }).Value }
            "UmsStaticFolderName"      { return (Get-UmsConfigurationItem -Type System | Where-Object { $_.Id -eq "ums-folder-name-static" }).Value }

            # UMS rendering options
            "CatalogIdDelimiter"        { return (Get-UmsConfigurationItem -Type Rendering | Where-Object { $_.Id -eq "catalog-id-delimiter" }).Value }
            "CatalogIdListPrefix"       { return (Get-UmsConfigurationItem -Type Rendering | Where-Object { $_.Id -eq "catalog-id-list-prefix" }).Value }
            "CatalogIdListSuffix"       { return (Get-UmsConfigurationItem -Type Rendering | Where-Object { $_.Id -eq "catalog-id-list-suffix" }).Value }
            "CharacterDelimiter"        { return (Get-UmsConfigurationItem -Type Rendering | Where-Object { $_.Id -eq "character-delimiter" }).Value }
            "CharacterListPrefix"       { return (Get-UmsConfigurationItem -Type Rendering | Where-Object { $_.Id -eq "character-list-prefix" }).Value }
            "CharacterListSuffix"       { return (Get-UmsConfigurationItem -Type Rendering | Where-Object { $_.Id -eq "character-list-suffix" }).Value }
            "ComposerDelimiter"         { return (Get-UmsConfigurationItem -Type Rendering | Where-Object { $_.Id -eq "composer-delimiter" }).Value }
            "ComposerListPrefix"        { return (Get-UmsConfigurationItem -Type Rendering | Where-Object { $_.Id -eq "composer-list-prefix" }).Value }
            "ComposerListSuffix"        { return (Get-UmsConfigurationItem -Type Rendering | Where-Object { $_.Id -eq "composer-list-suffix" }).Value }
            "EventDatePlaceDelimiter"   { return (Get-UmsConfigurationItem -Type Rendering | Where-Object { $_.Id -eq "event-date-place-delimiter" }).Value }
            "FallbackLanguage"          { return (Get-UmsConfigurationItem -Type Rendering | Where-Object { $_.Id -eq "fallback-language" }).Value }
            "FormDelimiter"             { return (Get-UmsConfigurationItem -Type Rendering | Where-Object { $_.Id -eq "form-delimiter" }).Value }
            "FormListPrefix"            { return (Get-UmsConfigurationItem -Type Rendering | Where-Object { $_.Id -eq "form-list-prefix" }).Value }
            "FormListSuffix"            { return (Get-UmsConfigurationItem -Type Rendering | Where-Object { $_.Id -eq "form-list-suffix" }).Value }
            "FullDateFormat"            { return (Get-UmsConfigurationItem -Type Rendering | Where-Object { $_.Id -eq "date-format-full" }).Value }
            "IncipitPrefix"             { return (Get-UmsConfigurationItem -Type Rendering | Where-Object { $_.Id -eq "incipit-prefix" }).Value }
            "IncipitSuffix"             { return (Get-UmsConfigurationItem -Type Rendering | Where-Object { $_.Id -eq "incipit-suffix" }).Value }
            "KeyListPrefix"             { return (Get-UmsConfigurationItem -Type Rendering | Where-Object { $_.Id -eq "key-list-prefix" }).Value }
            "KeyListSuffix"             { return (Get-UmsConfigurationItem -Type Rendering | Where-Object { $_.Id -eq "key-list-suffix" }).Value }
            "MediumNumberFormat"        { return (Get-UmsConfigurationItem -Type Rendering | Where-Object { $_.Id -eq "medium-number-format" }).Value }
            "MediumTitlePrefix"         { return (Get-UmsConfigurationItem -Type Rendering | Where-Object { $_.Id -eq "medium-title-prefix" }).Value }
            "MediumTitleSuffix"         { return (Get-UmsConfigurationItem -Type Rendering | Where-Object { $_.Id -eq "medium-title-suffix" }).Value }
            "MovementTitleInfix"        { return (Get-UmsConfigurationItem -Type Rendering | Where-Object { $_.Id -eq "movement-title-infix" }).Value }
            "PlaceDelimiter"            { return (Get-UmsConfigurationItem -Type Rendering | Where-Object { $_.Id -eq "place-delimiter" }).Value }
            "PerformanceYearPrefix"     { return (Get-UmsConfigurationItem -Type Rendering | Where-Object { $_.Id -eq "performance-year-prefix" }).Value }
            "PerformerDelimiter"        { return (Get-UmsConfigurationItem -Type Rendering | Where-Object { $_.Id -eq "performer-delimiter" }).Value }
            "PerformerListPrefix"       { return (Get-UmsConfigurationItem -Type Rendering | Where-Object { $_.Id -eq "performer-list-prefix" }).Value }
            "PerformerListSuffix"       { return (Get-UmsConfigurationItem -Type Rendering | Where-Object { $_.Id -eq "performer-list-suffix" }).Value }
            "PlayedInstrumentPrefix"    { return (Get-UmsConfigurationItem -Type Rendering | Where-Object { $_.Id -eq "played-instrument-prefix" }).Value }
            "PlayedInstrumentSuffix"    { return (Get-UmsConfigurationItem -Type Rendering | Where-Object { $_.Id -eq "played-instrument-suffix" }).Value }
            "PreferCommonLabels"        { return (Get-UmsConfigurationItem -Type Rendering | Where-Object { $_.Id -eq "prefer-common-labels" }).Value }
            "PreferCommonNames"         { return (Get-UmsConfigurationItem -Type Rendering | Where-Object { $_.Id -eq "prefer-common-names" }).Value }
            "PreferShortKeys"           { return (Get-UmsConfigurationItem -Type Rendering | Where-Object { $_.Id -eq "prefer-short-keys" }).Value }
            "PseudonymPrefix"           { return (Get-UmsConfigurationItem -Type Rendering | Where-Object { $_.Id -eq "pseudonym-prefix" }).Value }
            "PseudonymSuffix"           { return (Get-UmsConfigurationItem -Type Rendering | Where-Object { $_.Id -eq "pseudonym-suffix" }).Value }
            "ShowCatalogIds"            { return (Get-UmsConfigurationItem -Type Rendering | Where-Object { $_.Id -eq "show-catalog-ids" }).Value }
            "ShowCharacterList"         { return (Get-UmsConfigurationItem -Type Rendering | Where-Object { $_.Id -eq "show-character-list" }).Value }
            "ShowComposerList"          { return (Get-UmsConfigurationItem -Type Rendering | Where-Object { $_.Id -eq "show-composer-list" }).Value }
            "ShowMediumTitle"           { return (Get-UmsConfigurationItem -Type Rendering | Where-Object { $_.Id -eq "show-medium-title" }).Value }
            "ShowMovementIncipit"       { return (Get-UmsConfigurationItem -Type Rendering | Where-Object { $_.Id -eq "show-movement-incipit" }).Value }
            "ShowMovementTitle"         { return (Get-UmsConfigurationItem -Type Rendering | Where-Object { $_.Id -eq "show-movement-title" }).Value }
            "ShowMusicalForm"           { return (Get-UmsConfigurationItem -Type Rendering | Where-Object { $_.Id -eq "show-musical-form" }).Value }
            "ShowMusicalKey"            { return (Get-UmsConfigurationItem -Type Rendering | Where-Object { $_.Id -eq "show-musical-key" }).Value }
            "ShowPlayedInstrument"      { return (Get-UmsConfigurationItem -Type Rendering | Where-Object { $_.Id -eq "show-played-instrument" }).Value }
            "ShowPseudonyms"            { return (Get-UmsConfigurationItem -Type Rendering | Where-Object { $_.Id -eq "show-pseudonyms" }).Value }
            "ShowTempomarking"          { return (Get-UmsConfigurationItem -Type Rendering | Where-Object { $_.Id -eq "show-tempo-marking" }).Value }
            "SortNameDelimiter"         { return (Get-UmsConfigurationItem -Type Rendering | Where-Object { $_.Id -eq "sort-name-delimiter" }).Value }
            "TempoMarkingListPrefix"    { return (Get-UmsConfigurationItem -Type Rendering | Where-Object { $_.Id -eq "tempo-marking-list-prefix" }).Value }
            "TempoMarkingListSuffix"    { return (Get-UmsConfigurationItem -Type Rendering | Where-Object { $_.Id -eq "tempo-marking-list-suffix" }).Value }
            "UseDefaultVariants"        { return (Get-UmsConfigurationItem -Type Rendering | Where-Object { $_.Id -eq "use-default-variants" }).Value }
            "UseFakeSortVariants"       { return (Get-UmsConfigurationItem -Type Rendering | Where-Object { $_.Id -eq "use-fake-sort-variants" }).Value }
            "UseOriginalVariants"       { return (Get-UmsConfigurationItem -Type Rendering | Where-Object { $_.Id -eq "use-original-variants" }).Value }
            "YearDateFormat"            { return (Get-UmsConfigurationItem -Type Rendering | Where-Object { $_.Id -eq "date-format-year" }).Value }
            "YearMonthDateFormat"       { return (Get-UmsConfigurationItem -Type Rendering | Where-Object { $_.Id -eq "date-format-year-month" }).Value }            

            default { return }
        }
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
                XmlNamespace = $_catalog.Node.namespace;
                Uri = $($_catalog.Node.uri + "/");
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

    if (($Type -eq "all") -or ($Type -contains "rendering"))
    {
        $_options = $ConfigurationDocument | Select-Xml -XPath "/configuration/rendering/*"
        foreach ($_option in $_options)
        {
            # Returning rendering option object
            New-Object -Type PSCustomObject -Property @{
                Type = "Rendering";
                Id = $_option.Node.id;
                Value = $_option.Node.'#text';
            }   
        }
    }

    if (($Type -eq "all") -or ($Type -contains "system"))
    {
        $_options = $ConfigurationDocument | Select-Xml -XPath "/configuration/system/*"
        foreach ($_option in $_options)
        {
            # Returning UmsSystem object
            New-Object -Type PSCustomObject -Property @{
                Type = "System";
                Id = $_option.Node.id;
                Value = $_option.Node.'#text';
            }   
        }
    }  
}