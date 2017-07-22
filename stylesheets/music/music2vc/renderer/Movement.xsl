<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="3.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:umsc="http://schemas.olivarim.com/ums/1.0/common"
	xmlns:umsm="http://schemas.olivarim.com/ums/1.0/music">
	<xsl:template name="RT_Movement">
		<!--======================================================================
		 !	Template parameters
		 =========================================================================-->
		<!-- The full title of the parent work -->
		<xsl:param name="WorkTitle"/>
		<!-- The numbering info from the parent section. -->
		<xsl:param name="ParentSectionNumbering"/>
		<!-- Templating mode. Possible values are:
			- 'VORBIS' for default mode, which outputs Vorbis Comments
			- 'RAWTRACKTITLE' to output a raw track title
			- 'RAWLYRICS' to output only the lyrics of the movement as raw text -->
		<xsl:param name="Mode" select="'VORBIS'"/>
		<!--======================================================================
		 !	Gathering raw values
		 =========================================================================-->
		<!-- Movement title -->
		<xsl:variable name="_movementTitle">
			<xsl:call-template name="GT_Title_Full"/>
		</xsl:variable>
		<!-- Tempo marking -->
		<xsl:variable name="_tempoMarking">
			<xsl:value-of select="umsm:tempoMarking"/>
		</xsl:variable>	
		<!-- Movement incipit -->
		<xsl:variable name="_movementIncipit">
			<xsl:value-of select="umsm:incipit"/>
		</xsl:variable>
		<!-- List of character names -->
		<xsl:variable name="_characters">
			<xsl:for-each select="umsc:characters">
				<xsl:call-template name="LT_Characters">
					<xsl:with-param name="Mode" select="'RAWCHARACTERLIST'"/>
				</xsl:call-template>
			</xsl:for-each>
		</xsl:variable>
		<!-- Key of the movement -->
		<xsl:variable name="_musicalKey">
			<xsl:for-each select="umsm:key">
				<xsl:choose>
					<xsl:when test="$config.musicalKeys.preferShortLabels = true()">
						<xsl:call-template name="RT_Key">
							<xsl:with-param name="Mode" select="'RAWSHORTLABEL'"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="RT_Key">
							<xsl:with-param name="Mode" select="'RAWFULLLABEL'"/>
						</xsl:call-template>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
		</xsl:variable>
		<!-- List of musical forms -->
		<xsl:variable name="_musicalForms">
			<xsl:for-each select="umsm:forms">
				<xsl:call-template name="LT_Forms">
					<xsl:with-param name="Mode" select="'RAWFORMLIST'"/>
				</xsl:call-template>
			</xsl:for-each>
		</xsl:variable>
		<!-- Lyrics of the movement -->
		<xsl:variable name="_lyrics">
			<xsl:for-each select="umsm:lyrics">
				<xsl:call-template name="RT_Lyrics"/>				
			</xsl:for-each>
		</xsl:variable>
		<!--======================================================================
		 !	Building track title prefix
		 =========================================================================-->
		<!-- Track title prefix -->
		<xsl:variable name="_trackTitlePrefix">
			<!-- Work title prefix. Only shown if dynamic albums are disabled. -->
			<xsl:if test="$config.vorbis.trackTitles.parentWorkTitle.enabled = true()">
				<xsl:value-of select="$WorkTitle"/>
				<xsl:value-of select="' '"/>
				<xsl:if test="normalize-space($config.vorbis.trackTitles.parentWorkTitle.delimiterChar) != ''">
					<xsl:value-of select="$config.vorbis.trackTitles.parentWorkTitle.delimiterChar"/>
					<xsl:value-of select="' '"/>
				</xsl:if>
			</xsl:if>
			<!-- Section numbering prefix -->
			<xsl:if test="$config.vorbis.trackTitles.sectionNumbering.enabled = true()">
				<xsl:value-of select="$ParentSectionNumbering"/>
				<xsl:value-of select="$config.constants.nonBreakableSpace"/>
			</xsl:if>
			<!-- Musical form -->
			<xsl:if test="$config.vorbis.trackTitles.musicalForm.enabled = true() and normalize-space($_musicalForms) != ''">
				<xsl:value-of select="$config.vorbis.trackTitles.musicalForm.openingChar"/>
				<xsl:value-of select="$_musicalForms"/>
				<xsl:value-of select="$config.vorbis.trackTitles.musicalForm.closingChar"/>
				<xsl:value-of select="$config.constants.nonBreakableSpace"/>
			</xsl:if>
			<!-- Musical key -->
			<xsl:if test="$config.vorbis.trackTitles.musicalKey.enabled = true() and normalize-space($_musicalKey) != ''">
				<xsl:variable name="_introducer">
					<xsl:call-template name="getIdiom">
						<xsl:with-param name="Language" select="$config.variants.preferredLanguage"/>
						<xsl:with-param name="Idiom" select="'musical-key-introducer'"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:if test="normalize-space($_introducer) != ''">
					<xsl:value-of select="$_introducer"/>
					<xsl:value-of select="$config.constants.nonBreakableSpace"/>
				</xsl:if>
				<xsl:value-of select="$_musicalKey"/>
				<xsl:value-of select="$config.constants.nonBreakableSpace"/>
			</xsl:if>
			<!-- Character list prefix -->
			<xsl:if test="$config.vorbis.trackTitles.characterList.enabled = true() and normalize-space($_characters) != ''">
				<xsl:value-of select="$config.vorbis.trackTitles.characterList.openingChar"/>
				<xsl:value-of select="$_characters"/>
				<xsl:value-of select="$config.vorbis.trackTitles.characterList.closingChar"/>
				<xsl:value-of select="$config.constants.nonBreakableSpace"/>
			</xsl:if>
		</xsl:variable>
		<!--======================================================================
		 !	Building rich movement title
		 =========================================================================-->
		<xsl:variable name="_richMovementTitle">
			<!-- Movement title, if available -->
			<xsl:if test="normalize-space($_movementTitle) != ''">
				<xsl:value-of select="$_movementTitle"/>
				<xsl:value-of select="$config.constants.nonBreakableSpace"/>
			</xsl:if>
			<!-- Tempo marking, if enabled and available -->
			<xsl:if test="$config.vorbis.trackTitles.tempoMarkings.enabled = true()">
				<xsl:if test="normalize-space($_tempoMarking) != ''">
					<xsl:value-of select="$_tempoMarking"/>
					<xsl:value-of select="$config.constants.nonBreakableSpace"/>
				</xsl:if>
			</xsl:if>
			<!-- Movement incipit, if enabled and available -->
			<xsl:if test="$config.vorbis.trackTitles.incipit.enabled = true()">
				<xsl:if test="normalize-space($_movementIncipit) != ''">
					<xsl:call-template name="getTypographicSign">
						<xsl:with-param name="SignName" select="'opening-quotation-mark'"/>
						<xsl:with-param name="Language" select="$config.variants.preferredLanguage"/>
					</xsl:call-template>
					<xsl:value-of select="$_movementIncipit"/>
					<xsl:call-template name="getTypographicSign">
						<xsl:with-param name="SignName" select="'closing-quotation-mark'"/>
						<xsl:with-param name="Language" select="$config.variants.preferredLanguage"/>
					</xsl:call-template>
				</xsl:if>
			</xsl:if>
		</xsl:variable>
		<!--======================================================================
		 !	Building full track title
		 =========================================================================-->
		<!-- Full track title -->
		<xsl:variable name="_trackTitle">
			<!-- Track title prefix -->
			<xsl:value-of select="substring($_trackTitlePrefix, 1, string-length($_trackTitlePrefix) - 1)"/>
			<!-- Delimiter -->
			<xsl:value-of select="':'"/>
			<xsl:value-of select="$config.constants.nonBreakableSpace"/>
			<!-- Rich movement title -->
			<xsl:value-of select="$_richMovementTitle"/>
		</xsl:variable>		
		<!--======================================================================
		 !	VC generation
		 =========================================================================-->
		<!-- VC: Character -->
		<xsl:variable name="_VC_Characters">
			<xsl:for-each select="umsc:characters">
				<xsl:call-template name="LT_Characters">
					<xsl:with-param name="Label" select="$config.vorbis.labels.Character"/>
				</xsl:call-template>
			</xsl:for-each>
		</xsl:variable>
		<!-- VC: Musical key -->
		<xsl:variable name="_VC_MusicalKey">
			<xsl:for-each select="umsm:key">
				<xsl:call-template name="RT_Key">
					<xsl:with-param name="Label" select="$config.vorbis.labels.MusicalKey"/>
				</xsl:call-template>
			</xsl:for-each>
		</xsl:variable>		
		<!-- VC: Musical forms -->
		<xsl:variable name="_VC_MusicalForms">
			<xsl:for-each select="umsm:forms">
				<xsl:call-template name="LT_Forms">
					<xsl:with-param name="Label" select="$config.vorbis.labels.MusicalForm"/>
				</xsl:call-template>
			</xsl:for-each>
		</xsl:variable>
		<!-- VC: Instruments -->
		<xsl:variable name="_VC_Instruments">
			<xsl:for-each select="umsm:instruments">
				<xsl:call-template name="LT_Instruments">
					<xsl:with-param name="Label" select="$config.vorbis.labels.Instrument"/>
				</xsl:call-template>
			</xsl:for-each>
		</xsl:variable>
		<!--======================================================================
		 !	Data return
		 =========================================================================-->
		<xsl:choose>
			<!-- RawTrackTitle mode -->
			<xsl:when test="upper-case($Mode) = 'RAWTRACKTITLE'">
				<xsl:value-of select="$_trackTitle"/>
			</xsl:when>
			<!-- RawLyrics mode -->
			<xsl:when test="upper-case($Mode) = 'RAWLYRICS'">
				<xsl:call-template name="getLyricsTitleDelimiter"/>
				<xsl:value-of select="$config.constants.newLineChar"/>
				<xsl:value-of select="$_richMovementTitle"/>
				<xsl:value-of select="$config.constants.newLineChar"/>
				<xsl:call-template name="getLyricsTitleDelimiter"/>
				<xsl:value-of select="$config.constants.newLineChar"/>
				<xsl:value-of select="$config.constants.newLineChar"/>
				<xsl:value-of select="$_lyrics"/>
				<xsl:value-of select="$config.constants.newLineChar"/>
			</xsl:when>
			<!-- Vorbis mode -->
			<xsl:when test="upper-case($Mode) = 'VORBIS'">
				<!-- Characters of the movement -->
				<xsl:value-of select="$_VC_Characters"/>
				<!-- Musical key -->
				<xsl:value-of select="$_VC_MusicalKey"/>
				<!-- Musical forms -->
				<xsl:value-of select="$_VC_MusicalForms"/>
				<!-- Instruments -->
				<xsl:value-of select="$_VC_Instruments"/>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>