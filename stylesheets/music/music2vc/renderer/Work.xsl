<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="3.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:umsa="http://schemas.olivarim.com/ums/1.0/audio"
	xmlns:umsb="http://schemas.olivarim.com/ums/1.0/base"
	xmlns:umsm="http://schemas.olivarim.com/ums/1.0/music">
	<!-- Renders performance data for a specific track -->
	<xsl:template name="RT_Work">
		<!--======================================================================
		 !	Template parameters
		 =========================================================================-->
		<!-- Multi-level path pointing to a specific section of the work -->
		<xsl:param name="TargetSection"/>
		<!-- Templating mode. Possible values are:
			- 'VORBIS' for default mode, which outputs Vorbis Comments
			- 'RAWTRACKTITLE' to output a raw track title
			- 'RAWCOMPOSERLIST' to output a list of music composers.
			- 'RAWWORKTITLE' to output the raw title of the performed work.
			- 'RAWLYRICS' to output lyrics as raw text-->
		<xsl:param name="Mode" select="'VORBIS'"/>
		<!--======================================================================
		 !	Variable dumps for debugging purposes
		 =========================================================================-->
		<xsl:call-template name="showDebugMessage">
			<xsl:with-param name="Template" select="'RT_Work'"/>
			<xsl:with-param name="Message" select="concat('Parameter TargetSection has value: ', $TargetSection)"/>
		</xsl:call-template>
		<xsl:call-template name="showDebugMessage">
			<xsl:with-param name="Template" select="'RT_Work'"/>
			<xsl:with-param name="Message" select="concat('Parameter Mode has value: ', $Mode)"/>
		</xsl:call-template>
		<!--======================================================================
		 !	Common to all modes: gathering raw values
		 =========================================================================-->
		<xsl:call-template name="showDebugMessage">
			<xsl:with-param name="Template" select="'RT_Work'"/>
			<xsl:with-param name="Message" select="'Beginning gathering of raw values.'"/>
		</xsl:call-template>
		<!-- Raw catalog Ids-->
		<xsl:variable name="_catalogIds">
			<xsl:for-each select="umsm:catalogIds">
				<xsl:call-template name="LT_CatalogIds">
					<xsl:with-param name="Raw" select="true()"/>
				</xsl:call-template>
			</xsl:for-each>
		</xsl:variable>
		<!-- Year of inception -->
		<xsl:variable name="_inceptionYear">
			<xsl:for-each select="umsm:inception">
				<xsl:choose>
					<xsl:when test="umsb:year">
						<xsl:value-of select="umsb:year"/>
					</xsl:when>
					<xsl:when test="umsb:date">
						<xsl:value-of select="substring(umsb:date, 1, 4)"/>
					</xsl:when>
				</xsl:choose>
			</xsl:for-each>
		</xsl:variable>
		<!-- Year of completion -->
		<xsl:variable name="_completionYear">
			<xsl:for-each select="umsm:completion">
				<xsl:choose>
					<xsl:when test="umsb:year">
						<xsl:value-of select="umsb:year"/>
					</xsl:when>
					<xsl:when test="umsb:date">
						<xsl:value-of select="substring(umsb:date, 1, 4)"/>
					</xsl:when>
				</xsl:choose>
			</xsl:for-each>
		</xsl:variable>
		<!-- Year of premiere -->
		<xsl:variable name="_premiereYear">
			<xsl:for-each select="umsm:premiere">
				<xsl:choose>
					<xsl:when test="umsb:year">
						<xsl:value-of select="umsb:year"/>
					</xsl:when>
					<xsl:when test="umsb:date">
						<xsl:value-of select="substring(umsb:date, 1, 4)"/>
					</xsl:when>
				</xsl:choose>
			</xsl:for-each>
		</xsl:variable>		
		<!-- Work full title -->
		<xsl:variable name="_workTitleFull">
				<xsl:call-template name="GT_Title_Full"/>
		</xsl:variable>
		<!-- Work sort title -->
		<xsl:variable name="_workTitleSort">
				<xsl:call-template name="GT_Title_Sort"/>
		</xsl:variable>
		<!-- Work subtitle -->
		<xsl:variable name="_workSubtitle">
				<xsl:call-template name="GT_Title_Subtitle"/>
		</xsl:variable>
		<xsl:call-template name="showDebugMessage">
			<xsl:with-param name="Template" select="'RT_Work'"/>
			<xsl:with-param name="Message" select="'Finished gathering of raw values.'"/>
		</xsl:call-template>
		<!-- Main key of the work -->
		<xsl:variable name="_musicalKey">
			<xsl:for-each select="umsm:key">
				<xsl:choose>
					<xsl:when test="$config.keys.preferShortLabels = true()">
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
		<!--======================================================================
		 !	Common to all modes: building work title suffix
		 =========================================================================-->
		<xsl:variable name="_workTitleSuffix">
			<!-- Musical key suffix -->
			<xsl:if test="$config.workTitles.showKey = true() and normalize-space($_musicalKey) != ''">
				<xsl:value-of select="$config.constants.nonBreakableSpace"/>
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
			</xsl:if>
			<!-- Catalog ID suffix -->
			<xsl:if test="$config.workTitles.showCatalogIds = true()">
				<xsl:value-of select="$config.constants.nonBreakableSpace"/>
				<xsl:value-of select="$config.catalogIds.listPrefix"/>
				<xsl:value-of select="$_catalogIds"/>
				<xsl:value-of select="$config.catalogIds.listSuffix"/>
			</xsl:if>
			<!-- Year suffix -->
			<xsl:if test="$config.workTitles.showYear = true()">
				<xsl:choose>
					<xsl:when test="upper-case($config.workTitles.yearType) = 'INCEPTION' and normalize-space($_inceptionYear) != ''">
						<xsl:value-of select="$config.constants.nonBreakableSpace"/>
						<xsl:value-of select="$config.workTitles.yearPrefix"/>
						<xsl:value-of select="$_inceptionYear"/>
						<xsl:value-of select="$config.workTitles.yearSuffix"/>
					</xsl:when>
					<xsl:when test="upper-case($config.workTitles.yearType) = 'COMPLETION' and normalize-space($_completionYear) != ''">
						<xsl:value-of select="$config.constants.nonBreakableSpace"/>
						<xsl:value-of select="$config.workTitles.yearPrefix"/>
						<xsl:value-of select="$_completionYear"/>
						<xsl:value-of select="$config.workTitles.yearSuffix"/>
					</xsl:when>
					<xsl:when test="upper-case($config.workTitles.yearType) = 'PREMIERE' and normalize-space($_premiereYear) != ''">
						<xsl:value-of select="$config.constants.nonBreakableSpace"/>
						<xsl:value-of select="$config.workTitles.yearPrefix"/>
						<xsl:value-of select="$_premiereYear"/>
						<xsl:value-of select="$config.workTitles.yearSuffix"/>
					</xsl:when>
				</xsl:choose>
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="_workTitleFullWithSuffix" select="concat($_workTitleFull, $_workTitleSuffix)"/>
		<!--======================================================================
		 !	Raw track title mode: output raw track title
		 =========================================================================-->
		<xsl:choose>
			<xsl:when test="upper-case($Mode) = 'RAWTRACKTITLE'">
				<!-- Asking for track title -->
				<xsl:variable name="_trackTitleTmp">
					<xsl:for-each select="umsm:sections">
						<xsl:call-template name="LT_Sections">
							<xsl:with-param name="WorkTitle" select="$_workTitleFull"/>
							<xsl:with-param name="TargetSection" select="$TargetSection"/>
							<xsl:with-param name="Mode" select="'RAWTRACKTITLE'"/>
						</xsl:call-template>
					</xsl:for-each>
				</xsl:variable>
				<xsl:variable name="_trackTitle">
					<xsl:choose>
						<!-- If single mode is on, we only keep the first movement title -->
						<xsl:when test="$config.vorbis.movementTitles.concatenate = false()">
							<xsl:variable name="_delimiter">
								<xsl:call-template name="getMovementTitleDelimiter"/>
							</xsl:variable>
							<xsl:value-of select="substring-before($_trackTitleTmp, $_delimiter)"/>
						</xsl:when>
						<!-- Else, we only remove the last delimiter -->
						<xsl:otherwise>
							<xsl:value-of select="substring($_trackTitleTmp, 1, string-length($_trackTitleTmp) - string-length($config.movementTitles.delimiter))"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<!-- Returning track title -->
				<xsl:value-of select="$_trackTitle"/>
			</xsl:when>
		<!--======================================================================
		 !	Raw work title mode: output raw work title
		 =========================================================================-->
			<xsl:when test="upper-case($Mode) = 'RAWWORKTITLE'">
				<!-- Returning work full title with suffix -->
				<xsl:value-of select="$_workTitleFullWithSuffix"/>
			</xsl:when>		
		<!--======================================================================
		 !	RawComposerList mode: output raw composer list
		 =========================================================================-->
			<xsl:when test="upper-case($Mode) = 'RAWCOMPOSERLIST'">
				<!-- Building the list of composers-->
				<xsl:variable name="_composerList">
					<xsl:for-each select="umsm:composers">
						<xsl:call-template name="LT_Composers">
							<xsl:with-param name="Mode" select="'RAWCOMPOSERLIST'"/>
						</xsl:call-template>
					</xsl:for-each>
				</xsl:variable>
				<!-- Returning composer list -->
				<xsl:value-of select="$_composerList"/>
			</xsl:when>
		<!--======================================================================
		 !	RawLyrics mode: output raw lyrics
		 =========================================================================-->
			<xsl:when test="upper-case($Mode) = 'RAWLYRICS'">
				<!-- Gathering lyrics -->
				<xsl:variable name="_lyrics">
					<xsl:for-each select="umsm:sections">
						<xsl:call-template name="LT_Sections">
							<xsl:with-param name="WorkTitle" select="$_workTitleFull"/>
							<xsl:with-param name="TargetSection" select="$TargetSection"/>
							<xsl:with-param name="Mode" select="'RAWLYRICS'"/>
						</xsl:call-template>
					</xsl:for-each>
				</xsl:variable>
				<!-- Returning lyrics -->
				<xsl:value-of select="$_lyrics"/>
			</xsl:when>
		<!--======================================================================
		 !	Vorbis mode: output Vorbis Comments
		 =========================================================================-->
			<xsl:when test="upper-case($Mode) = 'VORBIS'">
				<xsl:call-template name="showDebugMessage">
					<xsl:with-param name="Template" select="'RT_Work'"/>
					<xsl:with-param name="Message" select="'Beginning the generation of Vorbis Comments.'"/>
				</xsl:call-template>
				<!-- VC: Catalog Ids -->
				<xsl:variable name="_VC_CatalogIds">
					<xsl:for-each select="umsm:catalogIds">
						<xsl:call-template name="LT_CatalogIds">
							<xsl:with-param name="Label" select="$config.vorbis.labels.Work_CatalogId"/>
						</xsl:call-template>
					</xsl:for-each>
				</xsl:variable>
				<!-- VC: Style of the work -->
				<xsl:variable name="_VC_Style">
					<xsl:for-each select="umsm:style">
						<xsl:call-template name="RT_Style">
							<xsl:with-param name="Label_Full" select="$config.vorbis.labels.Style_Full"/>
							<xsl:with-param name="Label_Sort" select="$config.vorbis.labels.Style_Sort"/>
							<xsl:with-param name="Label_Short" select="$config.vorbis.labels.Style_Short"/>
						</xsl:call-template>
					</xsl:for-each>
				</xsl:variable>
				<!-- VC: Composers of the work -->
				<xsl:variable name="_VC_Composers">
					<xsl:for-each select="umsm:composers">
						<xsl:call-template name="LT_Composers"/>
					</xsl:for-each>
				</xsl:variable>
				<!-- VC: Full Title of the work -->
				<xsl:variable name="_VC_WorkTitleFull">
					<xsl:call-template name="createVorbisComment">
						<xsl:with-param name="Label" select="$config.vorbis.labels.Work_Full"/>
						<xsl:with-param name="Value" select="$_workTitleFullWithSuffix"/>
					</xsl:call-template>
				</xsl:variable>
				<!-- VC: Sort Title of the work -->
				<xsl:variable name="_VC_WorkTitleSort">
					<xsl:call-template name="createVorbisComment">
						<xsl:with-param name="Label" select="$config.vorbis.labels.Work_Sort"/>
						<xsl:with-param name="Value" select="$_workTitleSort"/>
					</xsl:call-template>
				</xsl:variable>
				<!-- VC: Subtitle of the work -->
				<xsl:variable name="_VC_WorkSubtitle">
					<xsl:call-template name="createVorbisComment">
						<xsl:with-param name="Label" select="$config.vorbis.labels.Work_Subtitle"/>
						<xsl:with-param name="Value" select="$_workSubtitle"/>
					</xsl:call-template>
				</xsl:variable>
				<!-- VC: Musical form of the work -->
				<xsl:variable name="_VC_MusicalForms">
					<xsl:for-each select="umsm:form">
						<xsl:call-template name="RT_Form">
							<xsl:with-param name="Label" select="$config.vorbis.labels.MusicalForm"/>
						</xsl:call-template>
					</xsl:for-each>
				</xsl:variable>
				<!-- VC: Work sections-->
				<xsl:variable name="_VC_Sections">
					<xsl:for-each select="umsm:sections">
						<xsl:call-template name="LT_Sections">
							<xsl:with-param name="WorkTitle" select="$_workTitleFull"/>
							<xsl:with-param name="TargetSection" select="$TargetSection"/>
						</xsl:call-template>
					</xsl:for-each>
				</xsl:variable>
				<xsl:call-template name="showDebugMessage">
					<xsl:with-param name="Template" select="'RT_Work'"/>
					<xsl:with-param name="Message" select="'Finished the generation of Vorbis Comments.'"/>
				</xsl:call-template>
				<!-- Vorbis Comments output -->
				<xsl:value-of select="$_VC_WorkTitleFull"/>
				<xsl:value-of select="$_VC_WorkTitleSort"/>
				<xsl:value-of select="$_VC_WorkSubtitle"/>
				<xsl:value-of select="$_VC_MusicalForms"/>
				<xsl:value-of select="$_VC_CatalogIds"/>
				<xsl:value-of select="$_VC_Style"/>
				<xsl:value-of select="$_VC_Composers"/>
				<xsl:value-of select="$_VC_Sections"/>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>