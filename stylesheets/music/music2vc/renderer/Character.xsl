<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="3.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:umsa="http://schemas.olivarim.com/ums/1.0/audio"
	xmlns:umsb="http://schemas.olivarim.com/ums/1.0/base"
	xmlns:umsm="http://schemas.olivarim.com/ums/1.0/music">
	<xsl:template name="RT_Character">
		<!--======================================================================
		 !	Template parameters
		 =========================================================================-->
		<!-- VC label for character entries -->
		<xsl:param name="Label"/>
		<!-- Templating mode. Possible values are:
			- 'VORBIS' for default mode, which outputs Vorbis Comments
			- 'RAWFULLNAME' to output the full name of a character as a raw string
			- 'RAWSHORTNAME' to output the short name of a character as a raw string -->
		<xsl:param name="Mode" select="'VORBIS'"/>
		<!--======================================================================
		 !	Common to all modes: getting character names
		 =========================================================================-->
		<xsl:variable name="_characterFull">
			<xsl:call-template name="GT_Name_Full"/>
		</xsl:variable>
		<xsl:call-template name="showDebugMessage">
			<xsl:with-param name="Template" select="'RT_Character'"/>
			<xsl:with-param name="Message" select="concat('Retrieved character full name is: ', $_characterFull)"/>
		</xsl:call-template>
		<xsl:variable name="_characterSort">
			<xsl:call-template name="GT_Name_Sort"/>
		</xsl:variable>
		<xsl:call-template name="showDebugMessage">
			<xsl:with-param name="Template" select="'RT_Character'"/>
			<xsl:with-param name="Message" select="concat('Retrieved character sort name is: ', $_characterSort)"/>
		</xsl:call-template>		
		<xsl:variable name="_characterShort">
			<xsl:call-template name="GT_Name_Short"/>
		</xsl:variable>		
		<xsl:call-template name="showDebugMessage">
			<xsl:with-param name="Template" select="'RT_Character'"/>
			<xsl:with-param name="Message" select="concat('Retrieved character short name is: ', $_characterShort)"/>
		</xsl:call-template>
		<!--======================================================================
		 !	Returning the result
		 =========================================================================-->
		<xsl:choose>
			<xsl:when test="upper-case($Mode) = 'RAWFULLNAME'">
				<xsl:value-of select="$_characterFull"/>
			</xsl:when>
			<xsl:when test="upper-case($Mode) = 'RAWSHORTNAME'">
				<xsl:value-of select="$_characterShort"/>
			</xsl:when>
			<xsl:when test="upper-case($Mode) = 'VORBIS'">
				<xsl:call-template name="createVorbisComment">
					<xsl:with-param name="Label" select="$Label"/>
					<xsl:with-param name="Value" select="$_characterFull"/>
				</xsl:call-template>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>