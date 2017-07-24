<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="3.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:umsa="http://schemas.olivarim.com/ums/1.0/audio"
	xmlns:umsb="http://schemas.olivarim.com/ums/1.0/base"
	xmlns:umsm="http://schemas.olivarim.com/ums/1.0/music">
	<xsl:template name="LT_Forms">
		<!--======================================================================
		 !	Template parameters
		 =========================================================================-->
		<!-- VC label for musical form entries -->
		<xsl:param name="Label"/>
		<!-- Templating mode. Possible values are:
			- 'VORBIS' for default mode, which outputs Vorbis Comments
			- 'RAWFORMLIST' to output a list of musical forms as a raw string -->
		<xsl:param name="Mode" select="'VORBIS'"/>
		<!--======================================================================
		 !	Raw form list mode: output a list of musical forms as a single string
		 =========================================================================-->
		<xsl:choose>
			<xsl:when test="upper-case($Mode) = 'RAWFORMLIST'">
				<xsl:variable name="_formsTmp">
					<xsl:for-each select="umsm:form">
						<xsl:call-template name="showDebugMessage">
							<xsl:with-param name="Template" select="'LT_Forms'"/>
							<xsl:with-param name="Message" select="concat('Processing musical form with uid:', @uid)"/>
						</xsl:call-template>
						<xsl:call-template name="RT_Form">
							<xsl:with-param name="Mode" select="'RAWFULLLABEL'"/>
						</xsl:call-template>
						<xsl:value-of select="$config.musicalForms.delimiter"/>
					</xsl:for-each>
				</xsl:variable>
				<xsl:variable name="_forms" select="substring($_formsTmp, 1, string-length($_formsTmp) - string-length($config.musicalForms.delimiter) )"/>
				<xsl:call-template name="showDebugMessage">
					<xsl:with-param name="Template" select="'LT_Forms'"/>
					<xsl:with-param name="Message" select="concat('Single string of musical forms is: ', $_forms)"/>
				</xsl:call-template>
				<!-- Output value -->
				<xsl:value-of select="$_forms"/>
			</xsl:when>
		<!--======================================================================
		 !	Vorbis mode: output Vorbis Comments
		 =========================================================================-->
			<xsl:when test="upper-case($Mode) = 'VORBIS'">
				<xsl:variable name="_VC_Forms">
					<xsl:for-each select="umsm:form">
						<xsl:call-template name="showDebugMessage">
							<xsl:with-param name="Template" select="'LT_Forms'"/>
							<xsl:with-param name="Message" select="concat('Processing musical form with uid:', @uid)"/>
						</xsl:call-template>
						<xsl:call-template name="RT_Form">
							<xsl:with-param name="Label" select="$Label"/>
						</xsl:call-template>
					</xsl:for-each>
				</xsl:variable>
				<!-- Output value -->
				<xsl:value-of select="$_VC_Forms"/>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>