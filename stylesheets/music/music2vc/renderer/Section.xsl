<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="3.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:umsc="http://schemas.olivarim.com/ums/1.0/common"
	xmlns:umsm="http://schemas.olivarim.com/ums/1.0/music">
	<!-- Renders performance data for a specific track. If we land here, we assume
		 that the current <part> element is in the scope of the original TargetPath
		 expression and may be fully rendered as VC tags. -->
	<xsl:template name="RT_Section">
		<!--======================================================================
		 !	Template parameters
		 =========================================================================-->
		<!-- The full title of the parent work -->
		<xsl:param name="WorkTitle"/>
		<!-- Multi-level path pointing to a specific section of the hierarchy.
			 This information must be available through the recursive call chain. -->
		<xsl:param name="TargetSection"/>
		<!-- The numbering info from the parent section. -->
		<xsl:param name="ParentSectionNumbering"/>
		<!-- If true(), the whole call chain will only return the raw value of the
			 track title. -->
		<!-- Templating mode. Possible values are:
			- 'VORBIS' for default mode, which outputs Vorbis Comments
			- 'RAWTRACKTITLE' to output a raw track title
			- 'RAWLYRICS' to output lyrics as raw text -->
		<xsl:param name="Mode" select="'VORBIS'"/>
		<!--======================================================================
		 !	Section numbering
		 =========================================================================-->
		<!-- Numbering info for the current section -->
		<xsl:variable name="_numbering" select="@numbering"/>
		<!-- Full numbering info for the current section -->
		<xsl:variable name="_numberingFull" select="concat($ParentSectionNumbering, $_numbering, $config.vorbis.titles.sectionNumberDelimiter)"/>		
		<!--======================================================================
		 !	Variable dumps for debugging
		 =========================================================================-->
		<xsl:call-template name="showDebugMessage">
			<xsl:with-param name="Template" select="'RT_Section'"/>
			<xsl:with-param name="Message" select="concat('Value of $TargetSection: ', $TargetSection)"/>
		</xsl:call-template>
		<!--======================================================================
		 !	Child templates
		 =========================================================================-->
		<xsl:variable name="_VC_Section">
			<!-- <section> may have a <sections> or a <movements> child, but never both. -->
			<xsl:choose>
				<!-- If the part includes other parts, we make a recursive call -->
				<xsl:when test="umsm:sections">
					<xsl:call-template name="showDebugMessage">
						<xsl:with-param name="Template" select="'RT_Section'"/>
						<xsl:with-param name="Message" select="'The section includes a list of sections.'"/>
					</xsl:call-template>
					<xsl:for-each select="umsm:sections">
						<xsl:call-template name="LT_Sections">
							<xsl:with-param name="WorkTitle" select="$WorkTitle"/>
							<xsl:with-param name="TargetSection" select="$TargetSection"/>
							<xsl:with-param name="ParentSectionNumbering" select="$_numberingFull"/>
							<xsl:with-param name="Mode" select="$Mode"/>
						</xsl:call-template>
					</xsl:for-each>
				</xsl:when>
				<!-- If the part includes movements, let's render them -->
				<xsl:when test="umsm:movements">
					<xsl:call-template name="showDebugMessage">
						<xsl:with-param name="Template" select="'RT_Section'"/>
						<xsl:with-param name="Message" select="'The section includes a list of movements.'"/>
					</xsl:call-template>
					<xsl:for-each select="umsm:movements">
						<xsl:call-template name="LT_Movements">
							<xsl:with-param name="WorkTitle" select="$WorkTitle"/>
							<xsl:with-param name="ParentSectionNumbering" select="$_numberingFull"/>
							<xsl:with-param name="Mode" select="$Mode"/>
						</xsl:call-template>
					</xsl:for-each>
				</xsl:when>
			</xsl:choose>
		</xsl:variable>
		<!--======================================================================
		 !	Output
		 =========================================================================-->
		<!-- Returning Vorbis Comments (or TrackTitle data) -->
		<xsl:value-of select="$_VC_Section"/>
	</xsl:template>
</xsl:stylesheet>