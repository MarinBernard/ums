<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="3.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:umsc="http://schemas.olivarim.com/ums/1.0/common"
	xmlns:umsm="http://schemas.olivarim.com/ums/1.0/music">
	<xsl:template name="LT_Characters">
		<!--======================================================================
		 !	Template parameters
		 =========================================================================-->
		<!-- VC label for character entries -->
		<xsl:param name="Label"/>
		<!-- Templating mode. Possible values are:
			- 'VORBIS' for default mode, which outputs Vorbis Comments
			- 'RAWCHARACTERLIST' to output a list of characters as a raw string -->
		<xsl:param name="Mode" select="'VORBIS'"/>
		<!--======================================================================
		 !	Raw character list mode: output a list of characters as a raw string
		 =========================================================================-->
		<xsl:choose>
			<xsl:when test="upper-case($Mode) = 'RAWCHARACTERLIST'">
				<xsl:variable name="_charactersTmp">
					<xsl:for-each select="umsc:character">
						<xsl:call-template name="showDebugMessage">
							<xsl:with-param name="Template" select="'LT_Characters'"/>
							<xsl:with-param name="Message" select="concat('Processing character with uid: ', @uid)"/>
						</xsl:call-template>
						<xsl:call-template name="RT_Character">
							<xsl:with-param name="Mode" select="'RAWSHORTNAME'"/>
						</xsl:call-template>
						<xsl:value-of select="$config.vorbis.trackTitles.characterList.delimiterChar"/>
					</xsl:for-each>
				</xsl:variable>
				<xsl:variable name="_characters" select="substring($_charactersTmp, 1, string-length($_charactersTmp) - string-length($config.vorbis.trackTitles.characterList.delimiterChar) )"/>
				<xsl:call-template name="showDebugMessage">
					<xsl:with-param name="Template" select="'LT_Characters'"/>
					<xsl:with-param name="Message" select="concat('Characters in single string is: ', $_characters)"/>
				</xsl:call-template>
				<xsl:value-of select="$_characters"/>
			</xsl:when>
			<!--======================================================================
			!	Vorbis mode: output Vorbis Comments
			=========================================================================-->
			<xsl:when test="upper-case($Mode) = 'VORBIS'">
				<xsl:variable name="_VC_Characters">
					<xsl:for-each select="umsc:character">
						<xsl:call-template name="showDebugMessage">
							<xsl:with-param name="Template" select="'LT_Characters'"/>
							<xsl:with-param name="Message" select="concat('Processing character with uid: ', @uid)"/>
						</xsl:call-template>
						<xsl:call-template name="RT_Character">
							<xsl:with-param name="Label" select="$Label"/>
						</xsl:call-template>
					</xsl:for-each>
				</xsl:variable>
				<xsl:value-of select="$_VC_Characters"/>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>