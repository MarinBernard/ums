<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="3.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:umsa="http://schemas.olivarim.com/ums/1.0/audio"
	xmlns:umsb="http://schemas.olivarim.com/ums/1.0/base"
	xmlns:umsm="http://schemas.olivarim.com/ums/1.0/music">
	<!-- Renders performance data for a specific track -->
	<xsl:template name="RT_Performance">
		<!--======================================================================
		 !	Template parameters
		 =========================================================================-->
		<!-- Multi-level path pointing to a specific section of the performed work -->
		<xsl:param name="TargetSection"/>
		<!-- Templating mode. Possible values are:
			- 'VORBIS' for default mode, which outputs Vorbis Comments
			- 'RAWTRACKTITLE' to output a raw track title
			- 'RAWLYRICS' to output lyrics as raw text
			- 'RAWCOMPOSERLIST' to output a list of music composers.
			- 'RAWWORKTITLE' to output the raw title of the performed work.
			- 'RAWPERFORMERLIST' to output a list of performers. -->
		<xsl:param name="Mode" select="'VORBIS'"/>
		<!--======================================================================
		 !	Track title mode: output track title
		 =========================================================================-->
		<xsl:choose>
			<xsl:when test="upper-case($Mode) = 'RAWTRACKTITLE'">
				<!-- Asking for track title -->
				<xsl:variable name="_trackTitle">
					<xsl:for-each select="umsm:work">
						<xsl:call-template name="RT_Work">
							<xsl:with-param name="TargetSection" select="$TargetSection"/>
							<xsl:with-param name="Mode" select="'RAWTRACKTITLE'"/>
						</xsl:call-template>
					</xsl:for-each>
				</xsl:variable>
				<!-- Returning track title -->
				<xsl:value-of select="$_trackTitle"/>
			</xsl:when>
		<!--======================================================================
		 !	Lyrics mode: output raw lyrics
		 =========================================================================-->
			<xsl:when test="upper-case($Mode) = 'RAWLYRICS'">
				<!-- Asking for lyrics -->
				<xsl:variable name="_lyrics">
					<xsl:for-each select="umsm:work">
						<xsl:call-template name="RT_Work">
							<xsl:with-param name="TargetSection" select="$TargetSection"/>
							<xsl:with-param name="Mode" select="'RAWLYRICS'"/>
						</xsl:call-template>
					</xsl:for-each>
				</xsl:variable>
				<!-- Returning lyrics -->
				<xsl:value-of select="$_lyrics"/>
			</xsl:when>
		<!--======================================================================
		 !	Track work title mode: output raw work title
		 =========================================================================-->
			<xsl:when test="upper-case($Mode) = 'RAWWORKTITLE'">
				<!-- Asking for work title -->
				<xsl:variable name="_workTitle">
					<xsl:for-each select="umsm:work">
						<xsl:call-template name="RT_Work">
							<xsl:with-param name="TargetSection" select="$TargetSection"/>
							<xsl:with-param name="Mode" select="'RAWWORKTITLE'"/>
						</xsl:call-template>
					</xsl:for-each>
				</xsl:variable>
				<!-- Returning work title-->
				<xsl:value-of select="$_workTitle"/>
			</xsl:when>
		<!--======================================================================
		 !	Composer list mode: output raw list of composers
		 =========================================================================-->
			<xsl:when test="upper-case($Mode) = 'RAWCOMPOSERLIST'">
				<!-- Asking for composer list -->
				<xsl:variable name="_composerList">
					<xsl:for-each select="umsm:work">
						<xsl:call-template name="RT_Work">
							<xsl:with-param name="TargetSection" select="$TargetSection"/>
							<xsl:with-param name="Mode" select="'RAWCOMPOSERLIST'"/>
						</xsl:call-template>
					</xsl:for-each>
				</xsl:variable>
				<!-- Returning track title-->
				<xsl:value-of select="$_composerList"/>
			</xsl:when>
		<!--======================================================================
		 !	Performer list mode: output raw list of performers
		 =========================================================================-->
			<xsl:when test="upper-case($Mode) = 'RAWPERFORMERLIST'">
				<!-- Building the list of music ensembles with short names -->
				<xsl:variable name="_performerListTmp">
					<!-- Music ensembles -->
					<xsl:if test="$config.albumTitles.includeEnsembles = true()">
						<xsl:for-each select="umsm:performers/umsm:performer/umsm:ensemble">
							<xsl:call-template name="GT_Label_Short"/>
							<xsl:value-of select="$config.performers.delimiter"/>
						</xsl:for-each>
					</xsl:if>
					<!-- Soloists -->
					<xsl:if test="$config.albumTitles.includeSoloists = true()">
						<xsl:for-each select="umsm:performers/umsm:performer[@soloist = true()]/umsm:instrumentalist">
							<xsl:call-template name="GT_Name_Short"/>
							<xsl:value-of select="$config.performers.delimiter"/>
						</xsl:for-each>
					</xsl:if>					
					<!-- Non-soloist instrumentalists -->
					<xsl:if test="$config.albumTitles.includeInstrumentalists = true()">
						<xsl:for-each select="umsm:performers/umsm:performer[@soloist = false() or @soloist = '']/umsm:instrumentalist">
							<xsl:call-template name="GT_Name_Short"/>
							<xsl:value-of select="$config.performers.delimiter"/>
						</xsl:for-each>
					</xsl:if>
					<!-- Conductors -->
					<xsl:if test="$config.albumTitles.includeConductors = true()">
						<xsl:for-each select="umsm:conductors/umsm:conductor">
							<xsl:call-template name="GT_Name_Short"/>
							<xsl:value-of select="$config.performers.delimiter"/>
						</xsl:for-each>
					</xsl:if>
				</xsl:variable>
				<!-- Remove last delimiter char from the list of ensembles -->
				<xsl:variable name="_performerList">
					<!-- Remove last delimiter char from the list of ensembles -->
					<xsl:value-of select="substring($_performerListTmp, 1, string-length($_performerListTmp) - string-length($config.performers.delimiter))"/>
					<!-- Add optional year of performance -->
					<xsl:if test="$config.albumTitles.includePerformanceYear = true()">
						<xsl:if test="umsm:date or umsm:year">
							<xsl:value-of select="concat(',', $config.constants.nonBreakableSpace)"/>
							<xsl:choose>
								<xsl:when test="umsm:year">
									<xsl:value-of select="umsm:year"/>
								</xsl:when>
								<xsl:when test="umsm:date">
									<xsl:value-of select="substring(umsm:date, 1, 4)"/>
								</xsl:when>
							</xsl:choose>
						</xsl:if>
					</xsl:if>
				</xsl:variable>
				<!-- Returning the list -->
				<xsl:value-of select="$_performerList"/>
			</xsl:when>
		<!--======================================================================
		 !	Vorbis mode: output Vorbis Comments
		 =========================================================================-->
			<xsl:when test="upper-case($Mode) = 'VORBIS'">
				<!-- VC: Conductors -->
				<xsl:variable name="_VC_Conductors">
					<xsl:for-each select="umsm:conductors">
						<xsl:call-template name="showDebugMessage">
							<xsl:with-param name="Template" select="'RT_Performance'"/>
							<xsl:with-param name="Message" select="'Beginning to process conductors.'"/>
						</xsl:call-template>
						<xsl:call-template name="LT_Conductors"/>
						<xsl:call-template name="showDebugMessage">
							<xsl:with-param name="Template" select="'RT_Performance'"/>
							<xsl:with-param name="Message" select="'Finished processing conductors.'"/>
						</xsl:call-template>
					</xsl:for-each>
				</xsl:variable>
				<!-- VC: Performers -->
				<xsl:variable name="_VC_Performers">
					<xsl:for-each select="umsm:performers">
						<xsl:call-template name="showDebugMessage">
							<xsl:with-param name="Template" select="'RT_Performance'"/>
							<xsl:with-param name="Message" select="'Beginning to process performers.'"/>
						</xsl:call-template>
						<xsl:call-template name="LT_Performers"/>
						<xsl:call-template name="showDebugMessage">
							<xsl:with-param name="Template" select="'RT_Performance'"/>
							<xsl:with-param name="Message" select="'Finished processing performers.'"/>
						</xsl:call-template>
					</xsl:for-each>
				</xsl:variable>
				<!-- VC: Performed work -->
				<xsl:variable name="_VC_Work">
					<xsl:for-each select="umsm:work">
						<xsl:call-template name="RT_Work">
							<xsl:with-param name="TargetSection" select="$TargetSection"/>
						</xsl:call-template>
					</xsl:for-each>
				</xsl:variable>
				<!-- Outputing VC -->
				<xsl:value-of select="$_VC_Conductors"/>
				<xsl:value-of select="$_VC_Performers"/>
				<xsl:value-of select="$_VC_Work"/>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>