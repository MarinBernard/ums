<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="3.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:umsc="http://schemas.olivarim.com/ums/1.0/common"
	xmlns:umsm="http://schemas.olivarim.com/ums/1.0/music">
	<!-- Renders performance data for a specific track -->
	<xsl:template name="LT_Sections">
		<!--======================================================================
		 !	Template parameters
		 =========================================================================-->
		<!-- The full title of the parent work -->
		<xsl:param name="WorkTitle"/>		
		<!-- Multi-level path pointing to a specific section of the hierarchy -->
		<xsl:param name="TargetSection"/>
		<!-- The numbering info from the parent section. -->
		<xsl:param name="ParentSectionNumbering"/>
		<!-- Templating mode. Possible values are:
			- 'VORBIS' for default mode, which outputs Vorbis Comments
			- 'RAWTRACKTITLE' to output a raw track title
			- 'RAWLYRICS' to output all lyrics of sections as raw text -->
		<xsl:param name="Mode" select="'VORBIS'"/>
		<!--======================================================================
		 !	Gathering raw values
		 =========================================================================-->
		<!-- Extracting the most significant element from the $TargetPath expression -->
		<xsl:variable name="_currentTargetSection">
			<xsl:choose>
				<!-- When $TargetSection is multi-level, extract the first one -->
				<xsl:when test="contains($TargetSection, '/')">
					<xsl:value-of select="substring-before($TargetSection, '/')"/>
				</xsl:when>
				<!-- When $TargetSection is flat, we extract it raw -->
				<xsl:otherwise>
					<xsl:value-of select="$TargetSection"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="_remainingTargetSections" select="substring-after($TargetSection, '/')"/>
		<!--======================================================================
		 !	Variable dumps for debugging
		 =========================================================================-->
		<xsl:call-template name="showDebugMessage">
			<xsl:with-param name="Template" select="'LT_Sections'"/>
			<xsl:with-param name="Message" select="concat('Value of $TargetSection: ', $TargetSection)"/>
		</xsl:call-template>
		<xsl:call-template name="showDebugMessage">
			<xsl:with-param name="Template" select="'LT_Sections'"/>
			<xsl:with-param name="Message" select="concat('Value of $_currentTargetSection: ', $_currentTargetSection)"/>
		</xsl:call-template>
		<xsl:call-template name="showDebugMessage">
			<xsl:with-param name="Template" select="'LT_Sections'"/>
			<xsl:with-param name="Message" select="concat('Value of $_remainingTargetSections: ', $_remainingTargetSections)"/>
		</xsl:call-template>
		<!--======================================================================
		 !	Process sub sections
		 =========================================================================-->
		<xsl:if test="not(umsm:section[@id = $_currentTargetSection])">
			<xsl:message terminate="yes" select="concat('WARNING: Target section ', $_currentTargetSection, ' does not exist!')"/>
		</xsl:if>
		<xsl:for-each select="umsm:section">
			<xsl:call-template name="showDebugMessage">
				<xsl:with-param name="Template" select="'LT_Sections'"/>
				<xsl:with-param name="Message" select="concat('Processing section with id ', @id)"/>
			</xsl:call-template>
			<xsl:choose>
				<!-- If there is no more TargetSection, the section may be rendered -->
				<xsl:when test="normalize-space($_currentTargetSection) = ''">
					<xsl:call-template name="showDebugMessage">
						<xsl:with-param name="Template" select="'LT_Sections'"/>
						<xsl:with-param name="Message" select="'Target section filter is empty. Processing.'"/>
					</xsl:call-template>
					<xsl:call-template name="RT_Section">
						<xsl:with-param name="WorkTitle" select="$WorkTitle"/>
						<xsl:with-param name="TargetSection" select="$_remainingTargetSections"/>
						<xsl:with-param name="ParentSectionNumbering" select="$ParentSectionNumbering"/>
						<xsl:with-param name="Mode" select="$Mode"/>
					</xsl:call-template>
					<!-- Add title delimiter if track title mode is enabled -->
					<xsl:if test="upper-case($Mode) = 'RAWTRACKTITLE'">
						<xsl:call-template name="insertMovementTitleDelimiter"/>
					</xsl:if>
				</xsl:when>
				<xsl:otherwise>
					<xsl:choose>
						<!-- If the id of the current section element matches our filter,
							 the part may also be rendered -->
						<xsl:when test="@id = $_currentTargetSection">
							<xsl:call-template name="showDebugMessage">
								<xsl:with-param name="Template" select="'LT_Sections'"/>
								<xsl:with-param name="Message" select="'Id of the section matches. Processing.'"/>
							</xsl:call-template>
							<xsl:call-template name="RT_Section">
								<xsl:with-param name="WorkTitle" select="$WorkTitle"/>
								<xsl:with-param name="TargetSection" select="$_remainingTargetSections"/>
								<xsl:with-param name="ParentSectionNumbering" select="$ParentSectionNumbering"/>
								<xsl:with-param name="Mode" select="$Mode"/>
							</xsl:call-template>
							<!-- Add title delimiter if RawTrackTitle mode is enabled -->
							<xsl:if test="upper-case($Mode) = 'RAWTRACKTITLE'">
								<xsl:call-template name="insertMovementTitleDelimiter"/>
							</xsl:if>
						</xsl:when>
						<!-- Else, the section does not match and is ignored -->
						<xsl:otherwise>
							<xsl:call-template name="showDebugMessage">
								<xsl:with-param name="Template" select="'LT_Sections'"/>
								<xsl:with-param name="Message" select="'Id of the section mismatches. Ignoring.'"/>
							</xsl:call-template>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
	</xsl:template>
</xsl:stylesheet>