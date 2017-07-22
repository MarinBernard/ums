<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="3.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:umsc="http://schemas.olivarim.com/ums/1.0/common"
	xmlns:umsm="http://schemas.olivarim.com/ums/1.0/music">
	<xsl:template name="LT_Movements">
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
			- 'RAWLYRICS' to only output lyrics as raw text -->
		<xsl:param name="Mode" select="'VORBIS'"/>
		<!--======================================================================
		 !	Raw track title mode: Merging titles from submovements
		 =========================================================================-->
		<xsl:choose>
			<xsl:when test="upper-case($Mode) ='RAWTRACKTITLE'">
				<xsl:variable name="_consolidatedTrackTitle">
					<xsl:for-each select="umsm:movement">
						<xsl:call-template name="showDebugMessage">
							<xsl:with-param name="Template" select="'LT_Movements'"/>
							<xsl:with-param name="Message" select="concat('Extracting the title of movement with uid: ', @uid)"/>
						</xsl:call-template>
						<xsl:call-template name="RT_Movement">
							<xsl:with-param name="WorkTitle" select="$WorkTitle"/>
							<xsl:with-param name="ParentSectionNumbering" select="$ParentSectionNumbering"/>
							<xsl:with-param name="Mode" select="'RAWTRACKTITLE'"/>
						</xsl:call-template>
						<!-- Insert delimiter between movement titles -->
						<xsl:call-template name="insertMovementTitleDelimiter"/>
					</xsl:for-each>
				</xsl:variable>
				<xsl:call-template name="showDebugMessage">
					<xsl:with-param name="Template" select="'LT_Movements'"/>
					<xsl:with-param name="Message" select="concat('Consolidated track title is: ', $_consolidatedTrackTitle)"/>
				</xsl:call-template>
				<!-- Return consolidated track title -->
				<xsl:value-of select="$_consolidatedTrackTitle"/>
			</xsl:when>
		<!--======================================================================
		 !	Raw lyrics mode: Merging lyrics from submovements
		 =========================================================================-->
			<xsl:when test="upper-case($Mode) ='RAWLYRICS'">
				<xsl:variable name="_consolidatedLyrics">
					<xsl:for-each select="umsm:movement">
						<xsl:call-template name="RT_Movement">
							<xsl:with-param name="WorkTitle" select="$WorkTitle"/>
							<xsl:with-param name="ParentSectionNumbering" select="$ParentSectionNumbering"/>
							<xsl:with-param name="Mode" select="'RAWLYRICS'"/>
						</xsl:call-template>
					</xsl:for-each>
				</xsl:variable>
				<!-- Return consolidated lyrics -->
				<xsl:value-of select="$_consolidatedLyrics"/>
			</xsl:when>
		<!--======================================================================
		 !	Vorbis mode: Output Vorbis Comments for all submovements
		 =========================================================================-->
			<xsl:when test="upper-case($Mode) ='VORBIS'">
				<xsl:variable name="_VC_Movement">
					<xsl:for-each select="umsm:movement">
						<xsl:call-template name="showDebugMessage">
							<xsl:with-param name="Template" select="'LT_Movements'"/>
							<xsl:with-param name="Message" select="concat('Rendering movement with uid: ', @uid)"/>
						</xsl:call-template>
						<xsl:call-template name="RT_Movement">
							<xsl:with-param name="WorkTitle" select="$WorkTitle"/>
							<xsl:with-param name="ParentSectionNumbering" select="$ParentSectionNumbering"/>
						</xsl:call-template>
					</xsl:for-each>
				</xsl:variable>
				<!-- Return Vorbis Comments -->
				<xsl:value-of select="$_VC_Movement"/>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>