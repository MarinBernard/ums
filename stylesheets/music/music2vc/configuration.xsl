<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="3.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:umsc="http://schemas.olivarim.com/ums/1.0/common"
	xmlns:umsm="http://schemas.olivarim.com/ums/1.0/music">
	<!--
	==============================================================================
	!
	!	External catalogs
	!
	==============================================================================
	
	Path to the language catalog. -->
	<xsl:variable
		name="config.catalogs.languages"
		select="'file:///C:/Users/marin/Code/ums/catalogs/common/languages'"/>
	<!--
	
	==============================================================================
	!
	!	Name, title and label variants
	!
	==============================================================================
	
	A two-letter IETF language code describing the preferred language.
	All localized data will be rendered in this language, if available. -->
	<xsl:variable name="config.variants.preferredLanguage" select="'fr'"/>
	<!--
	
	A two-letter IETF language code describing the fallback language.
	Localized data will be rendered in this language if no variant is available
	in the prefered language. -->
	<xsl:variable name="config.variants.fallbackLanguage" select="'en'"/>
	<!--
	
	Whether we should use the default language variant when no variant is available
	in prefered or fallback language. -->
	<xsl:variable name="config.variants.useDefaultVariants" select="true()"/>
	<!--
	
	Whether we should use the original language variant when no variant is available
	in the prefered or fallback languages,
	and no default variant was available either. -->
	<xsl:variable name="config.variants.useOriginalVariants" select="false()"/>
	<!--
	
	If set to true(), a fake sort variant is created from the full variant
	when no sort variant is explicitely available. -->
	<xsl:variable name="config.variants.sort.fakeVariants" select="true()"/>
	<!--
	
	A character which will be inserted between the first and second parts
	of a sort-friendly name. -->
	<xsl:variable name="config.variants.sort.nameDelimiterChar" select="','" />
	<!--
	
	If set to true(), pseudonyms will be added as suffices to the full
	and sort-friendly variants of persons' names. -->
	<xsl:variable name="config.variants.pseudonymSuffix.enabled" select="true()"/>
	<!--
	
	Opening and closing characters surrounding pseudonym suffices. -->
	<xsl:variable
		name="config.variants.pseudonymSuffix.openingChar" select="'('''"/>
	<xsl:variable
		name="config.variants.pseudonymSuffix.closingChar" select="''')'"/>
	<!--
	
	If set to true(), common names will take precedence over full names. -->
	<xsl:variable name="config.variants.preferCommonNames" select="true()"/>
	<!--
	
	If set to true(), common labels will take precedence over full labels. -->
	<xsl:variable name="config.variants.preferCommonLabels" select="true()"/>
	<!--
	
	==============================================================================
	!
	!	Musical keys
	!
	==============================================================================
	
	If set to true(), musical keys will be rendered in their short forms. -->
	<xsl:variable name="config.musicalKeys.preferShortLabels" select="false()"/>
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
	<xsl:variable name="config.workTitles.musicalKey.enabled" select="true()" />
	<!--
	
	Whether we shall include the catalog IDs of a work in its title -->
	<xsl:variable name="config.workTitles.catalogId.enabled" select="true()" />
	<!--
	
	One or several chars which will be inserted between each catalog ID
	is a list of catalog IDs. -->
	<xsl:variable name="config.workTitles.catalogId.delimiterChar" select="', '" />
	<!--
	
	Opening and closing characters surrounding a list of catalog IDs
	when added to the title of a work. -->
	<xsl:variable name="config.workTitles.catalogId.openingChar" select="'['"/>
	<xsl:variable name="config.workTitles.catalogId.closingChar" select="']'"/>
	<!--
	
	Whether we shall include the year of inception, completion or premiere
	of a work in its title -->
	<xsl:variable name="config.workTitles.year.enabled" select="false()" />
	<!--
	
	What kind of year should be included as a suffix to the work title?
	Possible values are:
		- 'inception', the year the composer started the composition the work
		- 'completion', the year the composer completed the composition of the work
		- 'premiere', the year of the première of the work -->
	<xsl:variable name="config.workTitles.year.mode" select="'completion'" />
	<!--
	
	Opening and closing characters surrounding completion year suffices -->
	<xsl:variable name="config.workTitles.year.openingChar" select="'('"/>
	<xsl:variable name="config.workTitles.year.closingChar" select="')'"/>
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
	<xsl:variable name="config.vorbis.performers.instrumentSuffix.enabled" select="true()"/>
	<!--
	
	Opening and closing characters surrounding the name of an instrument as a suffix
	to a performer's name. -->
	<xsl:variable
		name="config.vorbis.performers.instrumentSuffix.openingChar" select="'['"/>
	<xsl:variable
		name="config.vorbis.performers.instrumentSuffix.closingChar" select="']'"/>
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
	<xsl:variable name="config.vorbis.artists.instrumentalistAsArtist"
		select="true()"/>
	<!--
	
	If set to true(), each music ensemble will generate an ARTIST Vorbis Comment
	besides its regular tags. -->
	<xsl:variable name="config.vorbis.artists.ensembleAsArtist" select="true()"/>
	<!--
	
	If set to true(), each music composer will generate an ARTIST Vorbis Comment
	besides its regular tags. -->
	<xsl:variable name="config.vorbis.artists.composerAsArtist" select="true()"/>
	<!--
	
	If set to true(), each music conductor will generate an ARTIST Vorbis Comment
	besides its regular tags. -->
	<xsl:variable name="config.vorbis.artists.conductorAsArtist" select="true()"/>
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
	<xsl:variable name="config.vorbis.genres.styleAsGenre.enabled"
		select="true()"/>
	<!--
	
	A prefix to insert before the style's name when it is registered as a genre.
	This option allows to group style names within the genre list. -->
	<xsl:variable name="config.vorbis.genres.styleAsGenre.prefix" select="'#'"/>
	<!--
	
	If set to true(), the sort-friendly variant of a musical style will be
	prefered when it is rendered as a genre. -->
	<xsl:variable name="config.vorbis.genres.styleAsGenre.preferSortVariant"
		select="true()"/>
	<!--
	
	If set to true(), each musical form will generate a GENRE Vorbis Comment
	besides its regular tags. -->
	<xsl:variable name="config.vorbis.genres.formAsGenre.enabled"
		select="true()"/>
	<!--
	
	A prefix to insert before the form's name when it is registered as a genre.
	This option allows to group form names within the genre list. -->
	<xsl:variable name="config.vorbis.genres.formAsGenre.prefix" select="'~'"/>
	<!--
	
	If set to true(), the sort-friendly variant of a musical form will be
	prefered when it is rendered as a genre. -->
	<xsl:variable name="config.vorbis.genres.formAsGenre.preferSortVariant"
		select="true()"/>
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
	<xsl:variable name="config.vorbis.trackTitles.parentWorkTitle.enabled"
		select="false()" />
	<!--
	
	One or several characters which will be inserted between the title
	of the parent work and the rest of the title of a track. -->
	<xsl:variable name="config.vorbis.trackTitles.parentWorkTitle.delimiterChar"
		select="'-'" />
	<!--
	
	If set to true(), track titles will include section numbering from the layout
	of the parent work. -->
	<xsl:variable name="config.vorbis.trackTitles.sectionNumbering.enabled"
		select="true()" />
	<!--
	
	One or several characters which will be inserted between each level
	of the section numbering when it is embedded in the title of a track. -->
	<xsl:variable name="config.vorbis.trackTitles.sectionNumbering.delimiterChar"
		select="'.'" />
	<!--
	
	If set to true(), track titles will include a list of character names
	involved in the action. This is useful with opera or sung music. -->
	<xsl:variable name="config.vorbis.trackTitles.characterList.enabled"
		select="true()" />
	<!--
	
	One or several characters which will be inserted between each character name
	in a character list embedded in the title of a track. -->
	<xsl:variable name="config.vorbis.trackTitles.characterList.delimiterChar"
		select="'/'" />
	<!--
	
	Opening and closing characters surrounding a list of characters. -->
	<xsl:variable name="config.vorbis.trackTitles.characterList.openingChar"
		select="'('"/>
	<xsl:variable name="config.vorbis.trackTitles.characterList.closingChar"
		select="')'"/>
	<!--
	
	If set to true(), track titles will include the name of the musical form
	of the movement. -->
	<xsl:variable name="config.vorbis.trackTitles.musicalForm.enabled"
		select="true()" />
	<!--
	
	One or several characters which will be inserted between each musical form
	label in the title of a track. -->
	<xsl:variable name="config.vorbis.trackTitles.musicalForm.delimiterChar"
		select="'/'" />
	<!--
	
	Opening and closing characters surrounding musical forms when embedded
	in the title of track. -->
	<xsl:variable name="config.vorbis.trackTitles.musicalForm.openingChar"
		select="''"/>
	<xsl:variable name="config.vorbis.trackTitles.musicalForm.closingChar"
		select="''"/>
	<!--
	
	If set to true(), track titles will include the initial musical key
	of the movement. -->
	<xsl:variable name="config.vorbis.trackTitles.musicalKey.enabled"
		select="true()" />
	<!--
	
	A word acting as a link between the musical form and the musical key.
	In english, we use the word 'in', like in 'Movement in E minor'. -->
	<xsl:variable name="config.vorbis.trackTitles.musicalForm.prefix"
		select="'en'"/>
	<!--
	
	Type of movement title inclusion into track titles. Possible values are:
		- 'all' to concatenate all movement titles to form the track title, or
		- 'single' to only show the title of the first movement.
	Single mode produces track titles easier to read and is recommended. -->
	<xsl:variable name="config.vorbis.trackTitles.movementList.mode"
		select="'single'" />
	<!--
	
	One or several characters which will be inserted between each movement title
	in multi-movement track titles. -->
	<xsl:variable name="config.vorbis.trackTitles.movementList.delimiterChar"
		select="' / '" />
	<!--
	
	If set to true(), track titles will include tempo markings. -->
	<xsl:variable name="config.vorbis.trackTitles.tempoMarkings.enabled"
		select="true()" />
	<!--
	
	If set to true(), track titles will include the first words of the lyrics
	(incipit) in the context of sung music. -->
	<xsl:variable name="config.vorbis.trackTitles.incipit.enabled"
		select="true()" />
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
	<xsl:variable name="config.vorbis.dynamicAlbums.enabled" select="true()"/>
	<!--
	
	If set to true(), dynamic album titles will include the list of composers
	of a given work. -->
	<xsl:variable name="config.vorbis.dynamicAlbums.composerList.enabled"
		select="true()"/>
	<!--
	
	One or serveral characters which will be inserted between each composer name
	in the list of composers. -->
	<xsl:variable name="config.vorbis.dynamicAlbums.composerList.delimiterChar"
		select="'/'"/>
	<!--
	
	Opening and closing characters surrounding the composer list
	in a dynamic album title. -->
	<xsl:variable name="config.vorbis.dynamicAlbums.composerList.openingChar"
		select="''"/>
	<xsl:variable name="config.vorbis.dynamicAlbums.composerList.closingChar"
		select="' -'"/>
	<!--
		
	If set to true(), dynamic album titles will include the list of performing
	music ensembles. -->
	<xsl:variable name="config.vorbis.dynamicAlbums.performerList.enabled"
		select="true()"/>
	<!--
	
	If set to true(), the list of performers will include music ensembles. -->
	<xsl:variable name="config.vorbis.dynamicAlbums.performerList.includeEnsembles"
		select="true()"/>
	<!--
	
	If set to true(), the list of performers will include soloists. -->
	<xsl:variable name="config.vorbis.dynamicAlbums.performerList.includeSoloists"
		select="true()"/>
	<!--
	
	If set to true(), the list of performers will include non-soloist
	instrumentalists. -->
	<xsl:variable
		name="config.vorbis.dynamicAlbums.performerList.includeInstrumentalists"
		select="false()"/>
	<!--
	
	If set to true(), the list of performers will include conductors. -->
	<xsl:variable
		name="config.vorbis.dynamicAlbums.performerList.includeConductors"
		select="true()"/>
	<!--
	
	If set to true(), the list of performers will include the year
	of the performance as a suffix. -->
	<xsl:variable
		name="config.vorbis.dynamicAlbums.performerList.includePerformanceYear"
		select="true()"/>
	<!--
	
	One or several characters which will be inserted between each music performer
	in the list of music ensembles. -->
	<xsl:variable name="config.vorbis.dynamicAlbums.performerList.delimiterChar"
		select="'/'"/>
	<!--
	
	Opening and closing characters surrounding the list of performers
	in dynamic album titles. -->
	<xsl:variable name="config.vorbis.dynamicAlbums.performerList.openingChar"
		select="'('"/>
	<xsl:variable name="config.vorbis.dynamicAlbums.performerList.closingChar"
		select="')'"/>
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
	<xsl:variable name="config.vorbis.labels.Album_Title_Full" select="'ALBUM'"/>
	<xsl:variable name="config.vorbis.labels.Album_Title_Sort" select="'ALBUMSORT'"/>
	<xsl:variable name="config.vorbis.labels.Album_Subtitle" select="'ALBUMSUBTITLE'"/>
	<xsl:variable name="config.vorbis.labels.Artist_Full" select="'ARTIST'"/>
	<xsl:variable name="config.vorbis.labels.Artist_Sort" select="'ARTISTSORT'"/>
	<xsl:variable name="config.vorbis.labels.Artist_Short" select="'ARTISTSHORT'"/>
	<xsl:variable name="config.vorbis.labels.Character" select="'CHARACTER'"/>
	<xsl:variable name="config.vorbis.labels.Composer_Full" select="'COMPOSER'"/>
	<xsl:variable name="config.vorbis.labels.Composer_Sort" select="'COMPOSERSORT'"/>
	<xsl:variable name="config.vorbis.labels.Composer_Short" select="'COMPOSERSHORT'"/>
	<xsl:variable name="config.vorbis.labels.Conductor_Full" select="'CONDUCTOR'"/>
	<xsl:variable name="config.vorbis.labels.Conductor_Sort" select="'CONDUCTORSORT'"/>
	<xsl:variable name="config.vorbis.labels.Conductor_Short" select="'CONDUCTORSHORT'"/>
	<xsl:variable name="config.vorbis.labels.Disc_Number" select="'DISCNUMBER'" />
	<xsl:variable name="config.vorbis.labels.Disc_Total" select="'DISCTOTAL'" />
	<xsl:variable name="config.vorbis.labels.Ensemble_Full" select="'ENSEMBLE'"/>
	<xsl:variable name="config.vorbis.labels.Ensemble_Sort" select="'ENSEMBLESORT'"/>
	<xsl:variable name="config.vorbis.labels.Ensemble_Short" select="'ENSEMBLESHORT'"/>
	<xsl:variable name="config.vorbis.labels.Genre" select="'GENRE'"/>
	<xsl:variable name="config.vorbis.labels.Instrument" select="'INSTRUMENT'"/>
	<xsl:variable name="config.vorbis.labels.Instrumentalist_Full" select="'PERFORMER'"/>
	<xsl:variable name="config.vorbis.labels.Instrumentalist_Sort" select="'PERFORMERSORT'"/>
	<xsl:variable name="config.vorbis.labels.Instrumentalist_Short" select="'PERFORMERSHORT'"/>
	<xsl:variable name="config.vorbis.labels.Lyrics" select="'LYRICS'"/>
	<xsl:variable name="config.vorbis.labels.MusicalForm" select="'MUSICALFORM'"/>
	<xsl:variable name="config.vorbis.labels.MusicalKey" select="'INITIALKEY'"/>
	<xsl:variable name="config.vorbis.labels.OriginalAlbum_Title_Full" select="'ORIGINALALBUM'"/>
	<xsl:variable name="config.vorbis.labels.OriginalAlbum_Title_Sort" select="'ORIGINALALBUMSORT'"/>
	<xsl:variable name="config.vorbis.labels.OriginalAlbum_Subtitle" select="'ORIGINALALBUMSUBTITLE'"/>
	<xsl:variable name="config.vorbis.labels.Style_Full" select="'STYLE'"/>
	<xsl:variable name="config.vorbis.labels.Style_Sort" select="'STYLESORT'"/>
	<xsl:variable name="config.vorbis.labels.Style_Short" select="'STYLESHORT'"/>
	<xsl:variable name="config.vorbis.labels.Track_Number" select="'TRACKNUMBER'"/>
	<xsl:variable name="config.vorbis.labels.Track_Total" select="'TRACKTOTAL'"/>
	<xsl:variable name="config.vorbis.labels.Track_Title" select="'TITLE'"/>
	<xsl:variable name="config.vorbis.labels.Work_CatalogId" select="'CATALOGID'"/>
	<xsl:variable name="config.vorbis.labels.Work_Full" select="'WORK'"/>
	<xsl:variable name="config.vorbis.labels.Work_Sort" select="'WORKSORT'"/>
	<xsl:variable name="config.vorbis.labels.Work_Subtitle" select="'WORKSUBTITLE'" />
	<!--
	
	==============================================================================
	!
	!	ADVANCED SETTINGS
	!_____________________________________________________________________________
	!
	!	Settings below should not be modified unless you know what you are doing.
	!
	==============================================================================
	
	If set to true(), debug info will be sent to the stderr. -->
	<xsl:variable name="config.debug.enabled" select="false()" />
	<!--
	
	If set to true(), all output will be sent to stdout.
	Tag and lyrics files will not be written. -->
	<xsl:variable name="config.debug.redirectToStdout" select="true()"/>
	<!--
	
	A sequence of characters representing the 'new line' sequence. -->
	<xsl:variable name="config.constants.newLineChar">
		<xsl:text>&#xa;</xsl:text>
	</xsl:variable>
	<!--
	
	Assignment character in Vorbis Comments. -->
	<xsl:variable name="config.constants.assignementChar" select="'='"/>
	<!--
	
	The non-breakable space character. -->
	<xsl:variable name="config.constants.nonBreakableSpace" select="'&#160;'"/>
	<!--
	
	The extension of the tag files generated by this stylesheet. -->
	<xsl:variable name="config.fileExtensions.tagFile" select="'.tags'"/>
	<!--
	
	The extension of the tag files generated by this stylesheet. -->
	<xsl:variable name="config.fileExtensions.lyricsFile" select="'.txt'"/>
	<!--
	
	File extension of UMS files (needed for lookups to external catalogs) -->
	<xsl:variable name="config.fileExtensions.umsFile" select="'.xml'"/>
</xsl:stylesheet>