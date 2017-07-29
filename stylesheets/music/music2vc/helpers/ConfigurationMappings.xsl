<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="3.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:umsa="http://schemas.olivarim.com/ums/1.0/audio"
	xmlns:umsb="http://schemas.olivarim.com/ums/1.0/base"
	xmlns:umsm="http://schemas.olivarim.com/ums/1.0/music">
	<!--
	==============================================================================
	!
	!	Load configuration file
	!
	==============================================================================
	-->
	<!-- Load configuration -->
	<xsl:variable name="ConfigData">
		<xsl:if test="not(document($ConfigFile))">
			<xsl:message terminate="yes" select="concat('Failed to load config file: ', $ConfigFile)"/>
		</xsl:if>
		<xsl:copy-of select="document($ConfigFile)/configuration/*"/>
	</xsl:variable>
	<!--
	==============================================================================
	!
	!	External catalogs
	!
	==============================================================================
	-->	
	<!-- URI to the catalog hosting common language elements -->
	<xsl:variable name="config.catalogs.languages">
		<xsl:call-template name="getCatalogUriForElement">
			<xsl:with-param name="Namespace" select="'http://schema.olivarim.com/ums/1.0/base'"/>
			<xsl:with-param name="ElementName" select="'language'"/>
		</xsl:call-template>
	</xsl:variable>
	<!--
	==============================================================================
	!
	!	Name, title and label variants
	!
	==============================================================================
	
	A two-letter IETF language code describing the preferred language.
	All localized data will be rendered in this language, if available. -->
	<xsl:variable name="config.variants.preferredLanguage">
		<xsl:call-template name="getUmsOptionValue">
			<xsl:with-param name="OptionName" select="'preferred-language'"/>
		</xsl:call-template>
	</xsl:variable>
	<!--
	
	A two-letter IETF language code describing the fallback language.
	Localized data will be rendered in this language if no variant is available
	in the prefered language. -->
	<xsl:variable name="config.variants.fallbackLanguage">
		<xsl:call-template name="getUmsOptionValue">
			<xsl:with-param name="OptionName" select="'fallback-language'"/>
		</xsl:call-template>
	</xsl:variable>
	<!--
	
	Whether we should use the default language variant when no variant is available
	in prefered or fallback language. -->
	<xsl:variable name="config.variants.useDefaultVariants">
		<xsl:call-template name="getUmsOptionValue">
			<xsl:with-param name="OptionName" select="'use-default-variants'"/>
			<xsl:with-param name="Boolean" select="true()"/>
		</xsl:call-template>
	</xsl:variable>
	<!--
	
	Whether we should use the original language variant when no variant is available
	in the prefered or fallback languages,
	and no default variant was available either. -->
	<xsl:variable name="config.variants.useOriginalVariants">
		<xsl:call-template name="getUmsOptionValue">
			<xsl:with-param name="OptionName" select="'use-original-variants'"/>
			<xsl:with-param name="Boolean" select="true()"/>
		</xsl:call-template>
	</xsl:variable>
	<!--
	
	If set to true(), a fake sort variant is created from the full variant
	when no sort variant is explicitely available. -->
	<xsl:variable name="config.variants.useFakeSortVariants">
		<xsl:call-template name="getUmsOptionValue">
			<xsl:with-param name="OptionName" select="'use-fake-sort-variants'"/>
			<xsl:with-param name="Boolean" select="true()"/>
		</xsl:call-template>
	</xsl:variable>
	<!--
	
	A character which will be inserted between the first and second parts
	of a sort-friendly name. -->
	<xsl:variable name="config.variants.sortNameDelimiter">
		<xsl:call-template name="getUmsOptionValue">
			<xsl:with-param name="OptionName" select="'sort-name-delimiter'"/>
			<xsl:with-param name="AllowEmptyValue" select="true()"/>
		</xsl:call-template>
	</xsl:variable>
	<!--
	
	If set to true(), pseudonyms will be added as suffices to the full
	and sort-friendly variants of persons' names. -->
	<xsl:variable name="config.variants.showPseudonyms">
		<xsl:call-template name="getUmsOptionValue">
			<xsl:with-param name="OptionName" select="'show-pseudonyms'"/>
			<xsl:with-param name="Boolean" select="true()"/>
		</xsl:call-template>
	</xsl:variable>
	<!--
	
	Opening and closing characters surrounding pseudonym suffices. -->
	<xsl:variable name="config.variants.pseudonymPrefix">
		<xsl:call-template name="getUmsOptionValue">
			<xsl:with-param name="OptionName" select="'pseudonym-prefix'"/>
			<xsl:with-param name="AllowEmptyValue" select="true()"/>
		</xsl:call-template>
	</xsl:variable>
	<xsl:variable name="config.variants.pseudonymSuffix">
		<xsl:call-template name="getUmsOptionValue">
			<xsl:with-param name="OptionName" select="'pseudonym-suffix'"/>
			<xsl:with-param name="AllowEmptyValue" select="true()"/>
		</xsl:call-template>
	</xsl:variable>
	<!--
	
	If set to true(), common names will take precedence over full names. -->
	<xsl:variable name="config.variants.preferCommonNames">
		<xsl:call-template name="getUmsOptionValue">
			<xsl:with-param name="OptionName" select="'prefer-common-names'"/>
			<xsl:with-param name="Boolean" select="true()"/>
		</xsl:call-template>
	</xsl:variable>
	<!--
	
	If set to true(), common labels will take precedence over full labels. -->
	<xsl:variable name="config.variants.preferCommonLabels">
		<xsl:call-template name="getUmsOptionValue">
			<xsl:with-param name="OptionName" select="'prefer-common-labels'"/>
			<xsl:with-param name="Boolean" select="true()"/>
		</xsl:call-template>
	</xsl:variable>
	<!--
	
	==============================================================================
	!
	!	Musical keys
	!
	==============================================================================
	
	If set to true(), musical keys will be rendered in their short forms. -->
	<xsl:variable name="config.keys.preferShortLabels">
		<xsl:call-template name="getUmsOptionValue">
			<xsl:with-param name="OptionName" select="'prefer-short-keys'"/>
			<xsl:with-param name="Boolean" select="true()"/>
		</xsl:call-template>
	</xsl:variable>
	<!--
	
	==============================================================================
	!
	!	Catalog IDs
	!
	==============================================================================

	One or several chars which will be inserted between each catalog ID
	is a list of catalog IDs. -->
	<xsl:variable name="config.catalogIds.Delimiter">
		<xsl:call-template name="getUmsOptionValue">
			<xsl:with-param name="OptionName" select="'catalog-id-delimiter'"/>
			<xsl:with-param name="AllowEmptyValue" select="true()"/>
		</xsl:call-template>
	</xsl:variable>
	<!--
	
	Opening and closing characters surrounding a list of catalog IDs
	when added to the title of a work. -->
	<xsl:variable name="config.catalogIds.listPrefix">
		<xsl:call-template name="getUmsOptionValue">
			<xsl:with-param name="OptionName" select="'catalog-id-list-prefix'"/>
			<xsl:with-param name="AllowEmptyValue" select="true()"/>
		</xsl:call-template>
	</xsl:variable>
	<xsl:variable name="config.catalogIds.listSuffix">
		<xsl:call-template name="getUmsOptionValue">
			<xsl:with-param name="OptionName" select="'catalog-id-list-suffix'"/>
			<xsl:with-param name="AllowEmptyValue" select="true()"/>
		</xsl:call-template>
	</xsl:variable>
	<!--
	
	==============================================================================
	!
	!	Instruments
	!
	==============================================================================
	
	Opening and closing characters surrounding the name of an instrument as a suffix
	to a performer's name. -->
	<xsl:variable name="config.instruments.listPrefix">
		<xsl:call-template name="getStylesheetOptionValue">
			<xsl:with-param name="Stylesheet" select="'music2vc'"/>
			<xsl:with-param name="OptionName" select="'instruments-list-prefix'"/>
			<xsl:with-param name="AllowEmptyValue" select="true()"/>
		</xsl:call-template>
	</xsl:variable>
	<xsl:variable name="config.instruments.listSuffix">
		<xsl:call-template name="getStylesheetOptionValue">
			<xsl:with-param name="Stylesheet" select="'music2vc'"/>
			<xsl:with-param name="OptionName" select="'instruments-list-suffix'"/>
			<xsl:with-param name="AllowEmptyValue" select="true()"/>
		</xsl:call-template>
	</xsl:variable>
	<!--
	
	==============================================================================
	!
	!	Characters
	!
	==============================================================================
	
	One or several characters which will be inserted between each character name
	in a character list embedded in the title of a track. -->
	<xsl:variable name="config.characters.delimiter">
		<xsl:call-template name="getUmsOptionValue">
			<xsl:with-param name="OptionName" select="'character-delimiter'"/>
			<xsl:with-param name="AllowEmptyValue" select="true()"/>
		</xsl:call-template>
	</xsl:variable>
	<!--
	
	Opening and closing characters surrounding a list of characters. -->
	<xsl:variable name="config.characters.listPrefix">
		<xsl:call-template name="getUmsOptionValue">
			<xsl:with-param name="OptionName" select="'character-list-prefix'"/>
			<xsl:with-param name="AllowEmptyValue" select="true()"/>
		</xsl:call-template>
	</xsl:variable>
	<xsl:variable name="config.characters.listSuffix">
		<xsl:call-template name="getUmsOptionValue">
			<xsl:with-param name="OptionName" select="'character-list-suffix'"/>
			<xsl:with-param name="AllowEmptyValue" select="true()"/>
		</xsl:call-template>
	</xsl:variable>
	<!--
	
	==============================================================================
	!
	!	Musical forms
	!
	==============================================================================
	
	One or several characters which will be inserted between each musical form
	label in the title of a track. -->
	<xsl:variable name="config.musicalForms.delimiter">
		<xsl:call-template name="getUmsOptionValue">
			<xsl:with-param name="OptionName" select="'form-delimiter'"/>
			<xsl:with-param name="AllowEmptyValue" select="true()"/>
		</xsl:call-template>
	</xsl:variable>
	<!--
	
	Opening and closing characters surrounding musical forms when embedded
	in the title of track. -->
	<xsl:variable name="config.musicalForms.listPrefix">
		<xsl:call-template name="getUmsOptionValue">
			<xsl:with-param name="OptionName" select="'form-list-prefix'"/>
			<xsl:with-param name="AllowEmptyValue" select="true()"/>
		</xsl:call-template>
	</xsl:variable>
	<xsl:variable name="config.musicalForms.listSuffix">
		<xsl:call-template name="getUmsOptionValue">
			<xsl:with-param name="OptionName" select="'form-list-suffix'"/>
			<xsl:with-param name="AllowEmptyValue" select="true()"/>
		</xsl:call-template>
	</xsl:variable>
	<!--
	
	==============================================================================
	!
	!	Movement titles
	!
	==============================================================================
	
	If set to true(), when a track include several movements, the stylesheet will
	merge movement titles so that they all fit in the track title. If set to
	false(), the track title will only include the title of the first movement. -->
	<xsl:variable name="config.vorbis.movementTitles.concatenate">
		<xsl:call-template name="getStylesheetOptionValue">
			<xsl:with-param name="Stylesheet" select="'music2vc'"/>
			<xsl:with-param name="OptionName" select="'movement-titles-concatenate'"/>
			<xsl:with-param name="Boolean" select="true()"/>
		</xsl:call-template>
	</xsl:variable>
	<!--
	
	One or several characters which will be inserted between each movement title
	in multi-movement track titles. -->
	<xsl:variable name="config.movementTitles.delimiter">
		<xsl:call-template name="getStylesheetOptionValue">
			<xsl:with-param name="Stylesheet" select="'music2vc'"/>
			<xsl:with-param name="OptionName" select="'movement-titles-delimiter'"/>
			<xsl:with-param name="AllowEmptyValue" select="true()"/>
		</xsl:call-template>
	</xsl:variable>
	<!--
	
	One or several characters which will be inserted before the title of a
	movement. -->
	<xsl:variable name="config.movementTitles.prefix">
		<xsl:call-template name="getUmsOptionValue">
			<xsl:with-param name="OptionName" select="'movement-title-prefix'"/>
			<xsl:with-param name="AllowEmptyValue" select="true()"/>
		</xsl:call-template>
	</xsl:variable>
	<!--
	
	==============================================================================
	!
	!	Composers lists
	!
	==============================================================================
	
	One or serveral characters which will be inserted between each composer name
	in the list of composers. -->
	<xsl:variable name="config.composers.delimiter">
		<xsl:call-template name="getUmsOptionValue">
			<xsl:with-param name="OptionName" select="'composer-delimiter'"/>
			<xsl:with-param name="AllowEmptyValue" select="true()"/>
		</xsl:call-template>
	</xsl:variable>
	<!--
	
	Opening and closing characters surrounding the composer list
	in a dynamic album title. -->
	<xsl:variable name="config.composers.listPrefix">
		<xsl:call-template name="getUmsOptionValue">
			<xsl:with-param name="OptionName" select="'composer-list-prefix'"/>
			<xsl:with-param name="AllowEmptyValue" select="true()"/>
		</xsl:call-template>
	</xsl:variable>
	<xsl:variable name="config.composers.listSuffix">
		<xsl:call-template name="getUmsOptionValue">
			<xsl:with-param name="OptionName" select="'composer-list-suffix'"/>
			<xsl:with-param name="AllowEmptyValue" select="true()"/>
		</xsl:call-template>
	</xsl:variable>
	<!--
	
	==============================================================================
	!
	!	Lists of performers (dynamic album titles)
	!
	==============================================================================	
	
	One or several characters which will be inserted between each music performer
	in the list of music ensembles. -->
	<xsl:variable name="config.performers.delimiter">
		<xsl:call-template name="getUmsOptionValue">
			<xsl:with-param name="OptionName" select="'performer-delimiter'"/>
			<xsl:with-param name="AllowEmptyValue" select="true()"/>
		</xsl:call-template>
	</xsl:variable>	
	<!--
	
	Opening and closing characters surrounding the list of performers
	in dynamic album titles. -->
	<xsl:variable name="config.performers.listPrefix">
		<xsl:call-template name="getUmsOptionValue">
			<xsl:with-param name="OptionName" select="'performer-list-prefix'"/>
			<xsl:with-param name="AllowEmptyValue" select="true()"/>
		</xsl:call-template>
	</xsl:variable>
	<xsl:variable name="config.performers.listSuffix">
		<xsl:call-template name="getUmsOptionValue">
			<xsl:with-param name="OptionName" select="'performer-list-suffix'"/>
			<xsl:with-param name="AllowEmptyValue" select="true()"/>
		</xsl:call-template>
	</xsl:variable>
	<!--
	
	==============================================================================
	!
	!	TITLES OF MUSIC WORKS
	!_____________________________________________________________________________
	!
	!	Options below allow to control how titles of musical works are generated,
	!	and which pieces of information they include.
	!
	==============================================================================
	
	Whether we shall include the main musical key of a work in its title -->
	<xsl:variable name="config.workTitles.showKey">
		<xsl:call-template name="getStylesheetOptionValue">
			<xsl:with-param name="Stylesheet" select="'music2vc'"/>
			<xsl:with-param name="OptionName" select="'work-titles-show-key'"/>
			<xsl:with-param name="Boolean" select="true()"/>
		</xsl:call-template>
	</xsl:variable>
	<!--
	
	Whether we shall include the catalog IDs of a work in its title -->
	<xsl:variable name="config.workTitles.showCatalogIds">
		<xsl:call-template name="getStylesheetOptionValue">
			<xsl:with-param name="Stylesheet" select="'music2vc'"/>
			<xsl:with-param name="OptionName" select="'work-titles-show-catalog-ids'"/>
			<xsl:with-param name="Boolean" select="true()"/>
		</xsl:call-template>
	</xsl:variable>
	<!--
	
	Whether we shall include the year of inception, completion or premiere
	of a work in its title -->
	<xsl:variable name="config.workTitles.showYear">
		<xsl:call-template name="getStylesheetOptionValue">
			<xsl:with-param name="Stylesheet" select="'music2vc'"/>
			<xsl:with-param name="OptionName" select="'work-titles-show-year'"/>
			<xsl:with-param name="Boolean" select="true()"/>
		</xsl:call-template>
	</xsl:variable>
	<!--
	
	What kind of year should be included as a suffix to the work title?
	Possible values are:
		- 'inception', the year the composer started the composition the work
		- 'completion', the year the composer completed the composition of the work
		- 'premiere', the year of the première of the work -->
	<xsl:variable name="config.workTitles.yearType">
		<xsl:call-template name="getStylesheetOptionValue">
			<xsl:with-param name="Stylesheet" select="'music2vc'"/>
			<xsl:with-param name="OptionName" select="'work-titles-year-type'"/>
		</xsl:call-template>
	</xsl:variable>
	<!--
	
	Opening and closing characters surrounding year suffices -->
	<xsl:variable name="config.workTitles.yearPrefix">
		<xsl:call-template name="getStylesheetOptionValue">
			<xsl:with-param name="Stylesheet" select="'music2vc'"/>
			<xsl:with-param name="OptionName" select="'work-titles-year-prefix'"/>
			<xsl:with-param name="AllowEmptyValue" select="true()"/>
		</xsl:call-template>
	</xsl:variable>
	<xsl:variable name="config.workTitles.yearSuffix">
		<xsl:call-template name="getStylesheetOptionValue">
			<xsl:with-param name="Stylesheet" select="'music2vc'"/>
			<xsl:with-param name="OptionName" select="'work-titles-year-suffix'"/>
			<xsl:with-param name="AllowEmptyValue" select="true()"/>
		</xsl:call-template>
	</xsl:variable>	
	<!--
		
	==============================================================================
	!
	!	PERFORMER VORBIS COMMENTS
	!_____________________________________________________________________________
	!
	!	Options below control how PERFORMER Vorbis Comments are generated by the
	!	stylesheet.
	!
	==============================================================================
	
	Whether we want to include the performed instrument as a suffix to the name
	of an instrumentalist when is it rendered as a PERFORMER comment.-->
	<xsl:variable name="config.vorbis.performers.showInstrument">
		<xsl:call-template name="getStylesheetOptionValue">
			<xsl:with-param name="Stylesheet" select="'music2vc'"/>
			<xsl:with-param name="OptionName" select="'vorbis-performers-show-instrument'"/>
			<xsl:with-param name="Boolean" select="true()"/>
		</xsl:call-template>
	</xsl:variable>
	<!--
	
	==============================================================================
	!
	!	DYNAMIC ARTISTS
	!_____________________________________________________________________________
	!
	!	ARTIST Vorbis Comments may be automatically generated by the stylesheet
	!	from several sources of information, such as the names of
	!	instrumentalists, music ensembles, composers or conductors.
	!	Options below allow to control if and how dynamic ARTIST Vorbis Comments
	!	will be generated.
	!
	==============================================================================
	
	If set to true(), each instrumentalist will generate an ARTIST Vorbis Comment
	besides its regular tags. -->
	<xsl:variable name="config.vorbis.artists.includeInstrumentalists">
		<xsl:call-template name="getStylesheetOptionValue">
			<xsl:with-param name="Stylesheet" select="'music2vc'"/>
			<xsl:with-param name="OptionName" select="'vorbis-artists-include-instrumentalists'"/>
			<xsl:with-param name="Boolean" select="true()"/>
		</xsl:call-template>
	</xsl:variable>
	<!--
	
	If set to true(), each music ensemble will generate an ARTIST Vorbis Comment
	besides its regular tags. -->
	<xsl:variable name="config.vorbis.artists.includeEnsembles">
		<xsl:call-template name="getStylesheetOptionValue">
			<xsl:with-param name="Stylesheet" select="'music2vc'"/>
			<xsl:with-param name="OptionName" select="'vorbis-artists-include-ensembles'"/>
			<xsl:with-param name="Boolean" select="true()"/>
		</xsl:call-template>
	</xsl:variable>
	<!--
	
	If set to true(), each music composer will generate an ARTIST Vorbis Comment
	besides its regular tags. -->
	<xsl:variable name="config.vorbis.artists.includeComposers">
		<xsl:call-template name="getStylesheetOptionValue">
			<xsl:with-param name="Stylesheet" select="'music2vc'"/>
			<xsl:with-param name="OptionName" select="'vorbis-artists-include-composers'"/>
			<xsl:with-param name="Boolean" select="true()"/>
		</xsl:call-template>
	</xsl:variable>
	<!--
	
	If set to true(), each music conductor will generate an ARTIST Vorbis Comment
	besides its regular tags. -->
	<xsl:variable name="config.vorbis.artists.includeConductors">
		<xsl:call-template name="getStylesheetOptionValue">
			<xsl:with-param name="Stylesheet" select="'music2vc'"/>
			<xsl:with-param name="OptionName" select="'vorbis-artists-include-conductors'"/>
			<xsl:with-param name="Boolean" select="true()"/>
		</xsl:call-template>
	</xsl:variable>
	<!--
	
	==============================================================================
	!
	!	DYNAMIC GENRES
	!_____________________________________________________________________________
	!
	!	GENRE Vorbis Comments may be automatically generated by the stylesheet
	!	from several sources of information, such as musical styles or forms.
	!	Options below allow to control if and how dynamic GENRE Vorbis Comments
	!	will be generated.
	!
	==============================================================================
	
	If set to true(), each musical style will generate a GENRE Vorbis Comment
	besides its regular tags. -->
	<xsl:variable name="config.vorbis.genres.includeStyles">
		<xsl:call-template name="getStylesheetOptionValue">
			<xsl:with-param name="Stylesheet" select="'music2vc'"/>
			<xsl:with-param name="OptionName" select="'vorbis-genres-include-styles'"/>
			<xsl:with-param name="Boolean" select="true()"/>
		</xsl:call-template>
	</xsl:variable>
	<!--
	
	A prefix to insert before the style's name when it is registered as a genre.
	This option allows to group style names within the genre list. -->
	<xsl:variable name="config.vorbis.genres.stylePrefix">
		<xsl:call-template name="getStylesheetOptionValue">
			<xsl:with-param name="Stylesheet" select="'music2vc'"/>
			<xsl:with-param name="OptionName" select="'vorbis-genres-style-prefix'"/>
			<xsl:with-param name="AllowEmptyValue" select="true()"/>
		</xsl:call-template>
	</xsl:variable>
	<!--
	
	If set to true(), the sort-friendly variant of a musical style will be
	prefered when it is rendered as a genre. -->
	<xsl:variable name="config.vorbis.genres.preferStyleSortLabels">
		<xsl:call-template name="getStylesheetOptionValue">
			<xsl:with-param name="Stylesheet" select="'music2vc'"/>
			<xsl:with-param name="OptionName" select="'vorbis-genres-prefer-style-sort-labels'"/>
			<xsl:with-param name="Boolean" select="true()"/>
		</xsl:call-template>
	</xsl:variable>
	<!--
	
	If set to true(), each musical form will generate a GENRE Vorbis Comment
	besides its regular tags. -->
	<xsl:variable name="config.vorbis.genres.formAsGenre.enabled"
		select="true()"/>
	<xsl:variable name="config.vorbis.genres.includeForms">
		<xsl:call-template name="getStylesheetOptionValue">
			<xsl:with-param name="Stylesheet" select="'music2vc'"/>
			<xsl:with-param name="OptionName" select="'vorbis-genres-include-forms'"/>
			<xsl:with-param name="Boolean" select="true()"/>
		</xsl:call-template>
	</xsl:variable>	
	<!--
	
	A prefix to insert before the form's name when it is registered as a genre.
	This option allows to group form names within the genre list. -->
	<xsl:variable name="config.vorbis.genres.formPrefix">
		<xsl:call-template name="getStylesheetOptionValue">
			<xsl:with-param name="Stylesheet" select="'music2vc'"/>
			<xsl:with-param name="OptionName" select="'vorbis-genres-form-prefix'"/>
			<xsl:with-param name="AllowEmptyValue" select="true()"/>
		</xsl:call-template>
	</xsl:variable>	
	<!--
	
	If set to true(), the sort-friendly variant of a musical form will be
	prefered when it is rendered as a genre. -->
	<xsl:variable name="config.vorbis.genres.preferFormSortLabels">
		<xsl:call-template name="getStylesheetOptionValue">
			<xsl:with-param name="Stylesheet" select="'music2vc'"/>
			<xsl:with-param name="OptionName" select="'vorbis-genres-prefer-form-sort-labels'"/>
			<xsl:with-param name="Boolean" select="true()"/>
		</xsl:call-template>
	</xsl:variable>
	<!--
	
	==============================================================================
	!
	!	DYNAMIC TRACK TITLES
	!_____________________________________________________________________________
	!
	!	TITLE Vorbis Comments define the title of a single track. Track titles are
	!	automatically generated by the stylesheet from many sources of information,
	!	such as the title of the performed work, of the movement, the names of the
	!	characters, tempo indications, musical forms, musical keys, or even an
	!	incipit for sung parts. Options below allow to control which of those will
	!	be included in TITLE Vorbis Comments.
	!
	==============================================================================
	
	If set to true(), track titles will include the title of the parent work
	as a prefix. You may want to disable this if dynamic albums are enabled,
	as the album title would already include the title of the work. -->
	<xsl:variable name="config.vorbis.titles.showParentWork">
		<xsl:call-template name="getStylesheetOptionValue">
			<xsl:with-param name="Stylesheet" select="'music2vc'"/>
			<xsl:with-param name="OptionName" select="'vorbis-titles-show-parent-work'"/>
			<xsl:with-param name="Boolean" select="true()"/>
		</xsl:call-template>
	</xsl:variable>
	<!--
	
	One or several characters which will be inserted between the title
	of the parent work and the rest of the title of a track. -->
	<xsl:variable name="config.vorbis.titles.parentWorkDelimiter">
		<xsl:call-template name="getStylesheetOptionValue">
			<xsl:with-param name="Stylesheet" select="'music2vc'"/>
			<xsl:with-param name="OptionName" select="'vorbis-titles-parent-work-delimiter'"/>
			<xsl:with-param name="AllowEmptyValue" select="true()"/>
		</xsl:call-template>
	</xsl:variable>
	<!--
	
	If set to true(), track titles will include section numbering from the layout
	of the parent work. -->
	<xsl:variable name="config.vorbis.titles.showSectionNumbers">
		<xsl:call-template name="getStylesheetOptionValue">
			<xsl:with-param name="Stylesheet" select="'music2vc'"/>
			<xsl:with-param name="OptionName" select="'vorbis-titles-show-section-numbers'"/>
			<xsl:with-param name="Boolean" select="true()"/>
		</xsl:call-template>
	</xsl:variable>
	<!--
	
	One or several characters which will be inserted between each level
	of the section numbering when it is embedded in the title of a track. -->
	<xsl:variable name="config.vorbis.titles.sectionNumberDelimiter">
		<xsl:call-template name="getStylesheetOptionValue">
			<xsl:with-param name="Stylesheet" select="'music2vc'"/>
			<xsl:with-param name="OptionName" select="'vorbis-titles-section-number-delimiter'"/>
			<xsl:with-param name="AllowEmptyValue" select="true()"/>
		</xsl:call-template>
	</xsl:variable>
	<!--
	
	If set to true(), track titles will include a list of character names
	involved in the action. This is useful with opera or sung music. -->
	<xsl:variable name="config.vorbis.titles.showCharacterList">
		<xsl:call-template name="getStylesheetOptionValue">
			<xsl:with-param name="Stylesheet" select="'music2vc'"/>
			<xsl:with-param name="OptionName" select="'vorbis-titles-show-character-list'"/>
			<xsl:with-param name="Boolean" select="true()"/>
		</xsl:call-template>
	</xsl:variable>
	<!--
	
	If set to true(), track titles will include the name of the musical form
	of the movement. -->
	<xsl:variable name="config.vorbis.titles.showFormList">
		<xsl:call-template name="getStylesheetOptionValue">
			<xsl:with-param name="Stylesheet" select="'music2vc'"/>
			<xsl:with-param name="OptionName" select="'vorbis-titles-show-musical-form-list'"/>
			<xsl:with-param name="Boolean" select="true()"/>
		</xsl:call-template>
	</xsl:variable>
	<!--
	
	If set to true(), track titles will include the initial musical key
	of the movement. -->
	<xsl:variable name="config.vorbis.titles.showKey">
		<xsl:call-template name="getStylesheetOptionValue">
			<xsl:with-param name="Stylesheet" select="'music2vc'"/>
			<xsl:with-param name="OptionName" select="'vorbis-titles-show-key'"/>
			<xsl:with-param name="Boolean" select="true()"/>
		</xsl:call-template>
	</xsl:variable>
	<!--
	
	If set to true(), track titles will include tempo markings. -->
	<xsl:variable name="config.vorbis.titles.showTempoMarkings">
		<xsl:call-template name="getStylesheetOptionValue">
			<xsl:with-param name="Stylesheet" select="'music2vc'"/>
			<xsl:with-param name="OptionName" select="'vorbis-titles-show-tempo-markings'"/>
			<xsl:with-param name="Boolean" select="true()"/>
		</xsl:call-template>
	</xsl:variable>	
	<!--
	
	If set to true(), track titles will include the first words of the lyrics
	(incipit) in the context of sung music. -->
	<xsl:variable name="config.vorbis.titles.showIncipit">
		<xsl:call-template name="getStylesheetOptionValue">
			<xsl:with-param name="Stylesheet" select="'music2vc'"/>
			<xsl:with-param name="OptionName" select="'vorbis-titles-show-incipit'"/>
			<xsl:with-param name="Boolean" select="true()"/>
		</xsl:call-template>
	</xsl:variable>	
	<!--
	
	==============================================================================
	!
	!	DYNAMIC ALBUMS
	!_____________________________________________________________________________
	!
	!	This stylesheet may handle albums in two different modes. The first mode
	!	will generate album metadata which are similar to those defined in the
	!	source album element. This mode is known as 'static', since it re-uses
	!	metadata describing the source album.
	!
	!	The other mode is known as 'dynamic'. When enabled, this mode stores all
	!	metadata regarding the original album in a special set of Vorbis Comments
	!	such as ORIGINALALBUM or ORIGINALALBUMARTIST. In dynamic mode, standard
	!	album-related Vorbis Comments such as ALBUM or ALBUMARTIST are dynamically
	!	populated by the stylesheet by splitting the original album into several
	!	ones, at a rate of one dynamic album per performed work. This allows to
	!	move from physical albums to performance-centric albums.
	!
	!	Options below allow to enable dynamic albums, and select which units of
	!	information shall be included in their title.
	!
	==============================================================================
	 
	If set to true(), dynamic album titles will be enabled. -->
	<xsl:variable name="config.albumTitles.useDynamicTitle">
		<xsl:call-template name="getStylesheetOptionValue">
			<xsl:with-param name="Stylesheet" select="'music2vc'"/>
			<xsl:with-param name="OptionName" select="'vorbis-album-titles-use-dynamic-title'"/>
			<xsl:with-param name="Boolean" select="true()"/>
		</xsl:call-template>
	</xsl:variable>	
	<!--
	
	If set to true(), dynamic album titles will include the list of composers
	of a given work. -->
	<xsl:variable name="config.albumTitles.includeComposers">
		<xsl:call-template name="getStylesheetOptionValue">
			<xsl:with-param name="Stylesheet" select="'music2vc'"/>
			<xsl:with-param name="OptionName" select="'vorbis-album-titles-include-composers'"/>
			<xsl:with-param name="Boolean" select="true()"/>
		</xsl:call-template>
	</xsl:variable>	
	<!--
		
	If set to true(), dynamic album titles will include the list of performing
	music ensembles. -->
	<xsl:variable name="config.albumTitles.includePerformers">
		<xsl:call-template name="getStylesheetOptionValue">
			<xsl:with-param name="Stylesheet" select="'music2vc'"/>
			<xsl:with-param name="OptionName" select="'vorbis-album-titles-include-performers'"/>
			<xsl:with-param name="Boolean" select="true()"/>
		</xsl:call-template>
	</xsl:variable>		
	<!--
	
	If set to true(), the list of performers will include music ensembles. -->
	<xsl:variable name="config.albumTitles.includeEnsembles">
		<xsl:call-template name="getStylesheetOptionValue">
			<xsl:with-param name="Stylesheet" select="'music2vc'"/>
			<xsl:with-param name="OptionName" select="'vorbis-album-titles-include-ensembles'"/>
			<xsl:with-param name="Boolean" select="true()"/>
		</xsl:call-template>
	</xsl:variable>	
	<!--
	
	If set to true(), the list of performers will include soloists. -->
	<xsl:variable name="config.albumTitles.includeSoloists">
		<xsl:call-template name="getStylesheetOptionValue">
			<xsl:with-param name="Stylesheet" select="'music2vc'"/>
			<xsl:with-param name="OptionName" select="'vorbis-album-titles-include-soloists'"/>
			<xsl:with-param name="Boolean" select="true()"/>
		</xsl:call-template>
	</xsl:variable>	
	<!--
	
	If set to true(), the list of performers will include non-soloist
	instrumentalists. -->
	<xsl:variable name="config.albumTitles.includeInstrumentalists">
		<xsl:call-template name="getStylesheetOptionValue">
			<xsl:with-param name="Stylesheet" select="'music2vc'"/>
			<xsl:with-param name="OptionName" select="'vorbis-album-titles-include-instrumentalists'"/>
			<xsl:with-param name="Boolean" select="true()"/>
		</xsl:call-template>
	</xsl:variable>	
	<!--
	
	If set to true(), the list of performers will include conductors. -->
	<xsl:variable name="config.albumTitles.includeConductors">
		<xsl:call-template name="getStylesheetOptionValue">
			<xsl:with-param name="Stylesheet" select="'music2vc'"/>
			<xsl:with-param name="OptionName" select="'vorbis-album-titles-include-conductors'"/>
			<xsl:with-param name="Boolean" select="true()"/>
		</xsl:call-template>
	</xsl:variable>	
	<!--
	
	If set to true(), the list of performers will include the year
	of the performance as a suffix. -->
	<xsl:variable name="config.albumTitles.includePerformanceYear">
		<xsl:call-template name="getStylesheetOptionValue">
			<xsl:with-param name="Stylesheet" select="'music2vc'"/>
			<xsl:with-param name="OptionName" select="'vorbis-album-titles-include-performance-year'"/>
			<xsl:with-param name="Boolean" select="true()"/>
		</xsl:call-template>
	</xsl:variable>	
	<!--
	
	==============================================================================
	!
	!	VORBIS COMMENTS LABELS
	!_____________________________________________________________________________
	!
	!	This section defines Vorbis Comments labels generated by the stylesheet.
	!	Any particular label may be disabled by replacing the original value with
	!	an empty string.
	!
	==============================================================================
	
	-->
	<!--
	
	Album full title (ALBUM) -->
	<xsl:variable name="config.vorbis.labels.Album_Title_Full">
		<xsl:call-template name="getStylesheetOptionValue">
			<xsl:with-param name="Stylesheet" select="'music2vc'"/>
			<xsl:with-param name="OptionName" select="'vorbis-labels-album-title-full'"/>
			<xsl:with-param name="AllowEmptyValue" select="true()"/>
		</xsl:call-template>
	</xsl:variable>
	<!--
	
	Album sort title (ALBUMSORT) -->
	<xsl:variable name="config.vorbis.labels.Album_Title_Sort">
		<xsl:call-template name="getStylesheetOptionValue">
			<xsl:with-param name="Stylesheet" select="'music2vc'"/>
			<xsl:with-param name="OptionName" select="'vorbis-labels-album-title-sort'"/>
			<xsl:with-param name="AllowEmptyValue" select="true()"/>
		</xsl:call-template>
	</xsl:variable>	
	<!--
	
	Album subtitle (ALBUMSUBTITLE) -->
	<xsl:variable name="config.vorbis.labels.Album_Subtitle">
		<xsl:call-template name="getStylesheetOptionValue">
			<xsl:with-param name="Stylesheet" select="'music2vc'"/>
			<xsl:with-param name="OptionName" select="'vorbis-labels-album-subtitle'"/>
			<xsl:with-param name="AllowEmptyValue" select="true()"/>
		</xsl:call-template>
	</xsl:variable>
	<!--
	
	Artist full name (ARTIST) -->
	<xsl:variable name="config.vorbis.labels.Artist_Full">
		<xsl:call-template name="getStylesheetOptionValue">
			<xsl:with-param name="Stylesheet" select="'music2vc'"/>
			<xsl:with-param name="OptionName" select="'vorbis-labels-artist-name-full'"/>
			<xsl:with-param name="AllowEmptyValue" select="true()"/>
		</xsl:call-template>
	</xsl:variable>
	<!--
	
	Artist short name (ARTISTSHORT) -->
	<xsl:variable name="config.vorbis.labels.Artist_Short">
		<xsl:call-template name="getStylesheetOptionValue">
			<xsl:with-param name="Stylesheet" select="'music2vc'"/>
			<xsl:with-param name="OptionName" select="'vorbis-labels-artist-name-short'"/>
			<xsl:with-param name="AllowEmptyValue" select="true()"/>
		</xsl:call-template>
	</xsl:variable>	
	<!--
	
	Artist sort name (ARTISTSORT) -->
	<xsl:variable name="config.vorbis.labels.Artist_Sort">
		<xsl:call-template name="getStylesheetOptionValue">
			<xsl:with-param name="Stylesheet" select="'music2vc'"/>
			<xsl:with-param name="OptionName" select="'vorbis-labels-artist-name-sort'"/>
			<xsl:with-param name="AllowEmptyValue" select="true()"/>
		</xsl:call-template>
	</xsl:variable>
	<!--
	
	Character name (CHARACTER) -->
	<xsl:variable name="config.vorbis.labels.Character">
		<xsl:call-template name="getStylesheetOptionValue">
			<xsl:with-param name="Stylesheet" select="'music2vc'"/>
			<xsl:with-param name="OptionName" select="'vorbis-labels-character-name'"/>
			<xsl:with-param name="AllowEmptyValue" select="true()"/>
		</xsl:call-template>
	</xsl:variable>	
	<!--
	
	Composer full name (COMPOSER) -->
	<xsl:variable name="config.vorbis.labels.Composer_Full">
		<xsl:call-template name="getStylesheetOptionValue">
			<xsl:with-param name="Stylesheet" select="'music2vc'"/>
			<xsl:with-param name="OptionName" select="'vorbis-labels-composer-name-full'"/>
			<xsl:with-param name="AllowEmptyValue" select="true()"/>
		</xsl:call-template>
	</xsl:variable>
	<!--
	
	Composer short name (COMPOSERSHORT) -->
	<xsl:variable name="config.vorbis.labels.Composer_Short">
		<xsl:call-template name="getStylesheetOptionValue">
			<xsl:with-param name="Stylesheet" select="'music2vc'"/>
			<xsl:with-param name="OptionName" select="'vorbis-labels-composer-name-short'"/>
			<xsl:with-param name="AllowEmptyValue" select="true()"/>
		</xsl:call-template>
	</xsl:variable>	
	<!--
	
	Composer sort name (COMPOSERSORT) -->
	<xsl:variable name="config.vorbis.labels.Composer_Sort">
		<xsl:call-template name="getStylesheetOptionValue">
			<xsl:with-param name="Stylesheet" select="'music2vc'"/>
			<xsl:with-param name="OptionName" select="'vorbis-labels-composer-name-sort'"/>
			<xsl:with-param name="AllowEmptyValue" select="true()"/>
		</xsl:call-template>
	</xsl:variable>
	<!--
	
	Conductor full name (CONDUCTOR) -->
	<xsl:variable name="config.vorbis.labels.Conductor_Full">
		<xsl:call-template name="getStylesheetOptionValue">
			<xsl:with-param name="Stylesheet" select="'music2vc'"/>
			<xsl:with-param name="OptionName" select="'vorbis-labels-conductor-name-full'"/>
			<xsl:with-param name="AllowEmptyValue" select="true()"/>
		</xsl:call-template>
	</xsl:variable>
	<!--
	
	Conductor short name (CONDUCTORSHORT) -->
	<xsl:variable name="config.vorbis.labels.Conductor_Short">
		<xsl:call-template name="getStylesheetOptionValue">
			<xsl:with-param name="Stylesheet" select="'music2vc'"/>
			<xsl:with-param name="OptionName" select="'vorbis-labels-conductor-name-short'"/>
			<xsl:with-param name="AllowEmptyValue" select="true()"/>
		</xsl:call-template>
	</xsl:variable>	
	<!--
	
	Conductor sort name (CONDUCTORSORT) -->
	<xsl:variable name="config.vorbis.labels.Conductor_Sort">
		<xsl:call-template name="getStylesheetOptionValue">
			<xsl:with-param name="Stylesheet" select="'music2vc'"/>
			<xsl:with-param name="OptionName" select="'vorbis-labels-conductor-name-sort'"/>
			<xsl:with-param name="AllowEmptyValue" select="true()"/>
		</xsl:call-template>
	</xsl:variable>
	<!--
	
	Disc number (DISCNUMBER) -->
	<xsl:variable name="config.vorbis.labels.Disc_Number">
		<xsl:call-template name="getStylesheetOptionValue">
			<xsl:with-param name="Stylesheet" select="'music2vc'"/>
			<xsl:with-param name="OptionName" select="'vorbis-labels-disc-number'"/>
			<xsl:with-param name="AllowEmptyValue" select="true()"/>
		</xsl:call-template>
	</xsl:variable>
	<!--
	
	Disc total (DISCTOTAL) -->
	<xsl:variable name="config.vorbis.labels.Disc_Total">
		<xsl:call-template name="getStylesheetOptionValue">
			<xsl:with-param name="Stylesheet" select="'music2vc'"/>
			<xsl:with-param name="OptionName" select="'vorbis-labels-disc-total'"/>
			<xsl:with-param name="AllowEmptyValue" select="true()"/>
		</xsl:call-template>
	</xsl:variable>
	<!--
	
	Ensemble full name (ENSEMBLE) -->
	<xsl:variable name="config.vorbis.labels.Ensemble_Full">
		<xsl:call-template name="getStylesheetOptionValue">
			<xsl:with-param name="Stylesheet" select="'music2vc'"/>
			<xsl:with-param name="OptionName" select="'vorbis-labels-ensemble-label-full'"/>
			<xsl:with-param name="AllowEmptyValue" select="true()"/>
		</xsl:call-template>
	</xsl:variable>
	<!--
	
	Ensemble short name (ENSEMBLESHORT) -->
	<xsl:variable name="config.vorbis.labels.Ensemble_Short">
		<xsl:call-template name="getStylesheetOptionValue">
			<xsl:with-param name="Stylesheet" select="'music2vc'"/>
			<xsl:with-param name="OptionName" select="'vorbis-labels-ensemble-label-short'"/>
			<xsl:with-param name="AllowEmptyValue" select="true()"/>
		</xsl:call-template>
	</xsl:variable>	
	<!--
	
	Ensemble sort name (ENSEMBLESORT) -->
	<xsl:variable name="config.vorbis.labels.Ensemble_Sort">
		<xsl:call-template name="getStylesheetOptionValue">
			<xsl:with-param name="Stylesheet" select="'music2vc'"/>
			<xsl:with-param name="OptionName" select="'vorbis-labels-ensemble-label-sort'"/>
			<xsl:with-param name="AllowEmptyValue" select="true()"/>
		</xsl:call-template>
	</xsl:variable>
	<!--
	
	Genre label (GENRE) -->
	<xsl:variable name="config.vorbis.labels.Genre">
		<xsl:call-template name="getStylesheetOptionValue">
			<xsl:with-param name="Stylesheet" select="'music2vc'"/>
			<xsl:with-param name="OptionName" select="'vorbis-labels-genre'"/>
			<xsl:with-param name="AllowEmptyValue" select="true()"/>
		</xsl:call-template>
	</xsl:variable>
	<!--
	
	Instrument label (INSTRUMENT) -->
	<xsl:variable name="config.vorbis.labels.Instrument">
		<xsl:call-template name="getStylesheetOptionValue">
			<xsl:with-param name="Stylesheet" select="'music2vc'"/>
			<xsl:with-param name="OptionName" select="'vorbis-labels-instrument'"/>
			<xsl:with-param name="AllowEmptyValue" select="true()"/>
		</xsl:call-template>
	</xsl:variable>	
	<!--
	
	Instrumentalist full name (INSTRUMENTALIST) -->
	<xsl:variable name="config.vorbis.labels.Instrumentalist_Full">
		<xsl:call-template name="getStylesheetOptionValue">
			<xsl:with-param name="Stylesheet" select="'music2vc'"/>
			<xsl:with-param name="OptionName" select="'vorbis-labels-instrumentalist-name-full'"/>
			<xsl:with-param name="AllowEmptyValue" select="true()"/>
		</xsl:call-template>
	</xsl:variable>
	<!--
	
	Instrumentalist short name (INSTRUMENTALISTSHORT) -->
	<xsl:variable name="config.vorbis.labels.Instrumentalist_Short">
		<xsl:call-template name="getStylesheetOptionValue">
			<xsl:with-param name="Stylesheet" select="'music2vc'"/>
			<xsl:with-param name="OptionName" select="'vorbis-labels-instrumentalist-name-short'"/>
			<xsl:with-param name="AllowEmptyValue" select="true()"/>
		</xsl:call-template>
	</xsl:variable>	
	<!--
	
	Instrumentalist sort name (INSTRUMENTALISTSORT) -->
	<xsl:variable name="config.vorbis.labels.Instrumentalist_Sort">
		<xsl:call-template name="getStylesheetOptionValue">
			<xsl:with-param name="Stylesheet" select="'music2vc'"/>
			<xsl:with-param name="OptionName" select="'vorbis-labels-instrumentalist-name-sort'"/>
			<xsl:with-param name="AllowEmptyValue" select="true()"/>
		</xsl:call-template>
	</xsl:variable>
	<!--
	
	Musical form label (MUSICALFORM) -->
	<xsl:variable name="config.vorbis.labels.MusicalForm">
		<xsl:call-template name="getStylesheetOptionValue">
			<xsl:with-param name="Stylesheet" select="'music2vc'"/>
			<xsl:with-param name="OptionName" select="'vorbis-labels-musical-form'"/>
			<xsl:with-param name="AllowEmptyValue" select="true()"/>
		</xsl:call-template>
	</xsl:variable>
	<!--
	
	Musical key label (INITIALKEY) -->
	<xsl:variable name="config.vorbis.labels.MusicalKey">
		<xsl:call-template name="getStylesheetOptionValue">
			<xsl:with-param name="Stylesheet" select="'music2vc'"/>
			<xsl:with-param name="OptionName" select="'vorbis-labels-musical-key'"/>
			<xsl:with-param name="AllowEmptyValue" select="true()"/>
		</xsl:call-template>
	</xsl:variable>
	<!--
	
	Original album full title (ORIGINALALBUM) -->
	<xsl:variable name="config.vorbis.labels.OriginalAlbum_Title_Full">
		<xsl:call-template name="getStylesheetOptionValue">
			<xsl:with-param name="Stylesheet" select="'music2vc'"/>
			<xsl:with-param name="OptionName" select="'vorbis-labels-original-album-title-full'"/>
			<xsl:with-param name="AllowEmptyValue" select="true()"/>
		</xsl:call-template>
	</xsl:variable>
	<!--
	
	Original album sort title (ORIGINALALBUMSORT) -->
	<xsl:variable name="config.vorbis.labels.OriginalAlbum_Title_Sort">
		<xsl:call-template name="getStylesheetOptionValue">
			<xsl:with-param name="Stylesheet" select="'music2vc'"/>
			<xsl:with-param name="OptionName" select="'vorbis-labels-original-album-title-sort'"/>
			<xsl:with-param name="AllowEmptyValue" select="true()"/>
		</xsl:call-template>
	</xsl:variable>
	<!--
	
	Original album subtitle (ORIGINALALBUMSUBTITLE) -->
	<xsl:variable name="config.vorbis.labels.OriginalAlbum_Subtitle">
		<xsl:call-template name="getStylesheetOptionValue">
			<xsl:with-param name="Stylesheet" select="'music2vc'"/>
			<xsl:with-param name="OptionName" select="'vorbis-labels-original-album-subtitle'"/>
			<xsl:with-param name="AllowEmptyValue" select="true()"/>
		</xsl:call-template>
	</xsl:variable>
	<!--
	
	Style full label (STYLE) -->
	<xsl:variable name="config.vorbis.labels.Style_Full">
		<xsl:call-template name="getStylesheetOptionValue">
			<xsl:with-param name="Stylesheet" select="'music2vc'"/>
			<xsl:with-param name="OptionName" select="'vorbis-labels-style-label-full'"/>
			<xsl:with-param name="AllowEmptyValue" select="true()"/>
		</xsl:call-template>
	</xsl:variable>
	<!--
	
	Style short label (STYLESHORT) -->
	<xsl:variable name="config.vorbis.labels.Style_Short">
		<xsl:call-template name="getStylesheetOptionValue">
			<xsl:with-param name="Stylesheet" select="'music2vc'"/>
			<xsl:with-param name="OptionName" select="'vorbis-labels-style-label-short'"/>
			<xsl:with-param name="AllowEmptyValue" select="true()"/>
		</xsl:call-template>
	</xsl:variable>
	<!--
	
	Style sort label (STYLESORT) -->
	<xsl:variable name="config.vorbis.labels.Style_Sort">
		<xsl:call-template name="getStylesheetOptionValue">
			<xsl:with-param name="Stylesheet" select="'music2vc'"/>
			<xsl:with-param name="OptionName" select="'vorbis-labels-style-label-sort'"/>
			<xsl:with-param name="AllowEmptyValue" select="true()"/>
		</xsl:call-template>
	</xsl:variable>
	<!--
	
	Track number (TRACKNUMBER) -->
	<xsl:variable name="config.vorbis.labels.Track_Number">
		<xsl:call-template name="getStylesheetOptionValue">
			<xsl:with-param name="Stylesheet" select="'music2vc'"/>
			<xsl:with-param name="OptionName" select="'vorbis-labels-track-number'"/>
			<xsl:with-param name="AllowEmptyValue" select="true()"/>
		</xsl:call-template>
	</xsl:variable>
	<!--
	
	Track total (TRACKTOTAL) -->
	<xsl:variable name="config.vorbis.labels.Track_Total">
		<xsl:call-template name="getStylesheetOptionValue">
			<xsl:with-param name="Stylesheet" select="'music2vc'"/>
			<xsl:with-param name="OptionName" select="'vorbis-labels-track-total'"/>
			<xsl:with-param name="AllowEmptyValue" select="true()"/>
		</xsl:call-template>
	</xsl:variable>
	<!--
	
	Track title (TITLE) -->
	<xsl:variable name="config.vorbis.labels.Track_Title">
		<xsl:call-template name="getStylesheetOptionValue">
			<xsl:with-param name="Stylesheet" select="'music2vc'"/>
			<xsl:with-param name="OptionName" select="'vorbis-labels-title'"/>
			<xsl:with-param name="AllowEmptyValue" select="true()"/>
		</xsl:call-template>
	</xsl:variable>
	<!--
	
	Work catalog id (CATALOGID) -->
	<xsl:variable name="config.vorbis.labels.Work_CatalogId">
		<xsl:call-template name="getStylesheetOptionValue">
			<xsl:with-param name="Stylesheet" select="'music2vc'"/>
			<xsl:with-param name="OptionName" select="'vorbis-labels-work-catalog-id'"/>
			<xsl:with-param name="AllowEmptyValue" select="true()"/>
		</xsl:call-template>
	</xsl:variable>	
	<!--
	
	Work title full (WORK) -->
	<xsl:variable name="config.vorbis.labels.Work_Full">
		<xsl:call-template name="getStylesheetOptionValue">
			<xsl:with-param name="Stylesheet" select="'music2vc'"/>
			<xsl:with-param name="OptionName" select="'vorbis-labels-work-title-full'"/>
			<xsl:with-param name="AllowEmptyValue" select="true()"/>
		</xsl:call-template>
	</xsl:variable>
	<!--
	
	Work title sort (WORKSORT) -->
	<xsl:variable name="config.vorbis.labels.Work_Sort">
		<xsl:call-template name="getStylesheetOptionValue">
			<xsl:with-param name="Stylesheet" select="'music2vc'"/>
			<xsl:with-param name="OptionName" select="'vorbis-labels-work-title-sort'"/>
			<xsl:with-param name="AllowEmptyValue" select="true()"/>
		</xsl:call-template>
	</xsl:variable>
	<!--
	
	Work subtitle (WORKSUBTITLE) -->
	<xsl:variable name="config.vorbis.labels.Work_Subtitle">
		<xsl:call-template name="getStylesheetOptionValue">
			<xsl:with-param name="Stylesheet" select="'music2vc'"/>
			<xsl:with-param name="OptionName" select="'vorbis-labels-work-subtitle'"/>
			<xsl:with-param name="AllowEmptyValue" select="true()"/>
		</xsl:call-template>
	</xsl:variable>	
	<!--
	
	==============================================================================
	!
	!	ADVANCED SETTINGS
	!_____________________________________________________________________________
	!
	!	Settings below should not be modified unless you know what you are doing.
	!
	==============================================================================

	A sequence of characters representing the 'new line' sequence. -->
	<xsl:variable name="config.constants.newLineChar">
		<xsl:call-template name="getStylesheetOptionValue">
			<xsl:with-param name="Stylesheet" select="'music2vc'"/>
			<xsl:with-param name="OptionName" select="'constant-new-line'"/>
			<xsl:with-param name="AllowEmptyValue" select="true()"/>
		</xsl:call-template>
	</xsl:variable>	
	<!--
	
	Assignment character in Vorbis Comments. -->
	<xsl:variable name="config.constants.vorbisAssignmentChar">
		<xsl:call-template name="getStylesheetOptionValue">
			<xsl:with-param name="Stylesheet" select="'music2vc'"/>
			<xsl:with-param name="OptionName" select="'constant-vorbis-assignment'"/>
			<xsl:with-param name="AllowEmptyValue" select="true()"/>
		</xsl:call-template>
	</xsl:variable>	
	<!--
	
	The non-breakable space character. -->
	<xsl:variable name="config.constants.nonBreakableSpace">
		<xsl:call-template name="getStylesheetOptionValue">
			<xsl:with-param name="Stylesheet" select="'music2vc'"/>
			<xsl:with-param name="OptionName" select="'constant-non-breakable-space'"/>
			<xsl:with-param name="AllowEmptyValue" select="true()"/>
		</xsl:call-template>
	</xsl:variable>	
	<!--
	
	File extension of UMS files (needed for lookups to external catalogs) -->
	<xsl:variable name="config.fileExtensions.umsFile">
		<xsl:call-template name="getUmsOptionValue">
			<xsl:with-param name="OptionDomain" select="'system'"/>
			<xsl:with-param name="OptionName" select="'ums-file-extension'"/>
		</xsl:call-template>
	</xsl:variable>
</xsl:stylesheet>