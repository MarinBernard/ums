<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="3.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:umsc="http://schemas.olivarim.com/ums/1.0/common"
	xmlns:umsm="http://schemas.olivarim.com/ums/1.0/music">
	<xsl:template name="RT_Instrument">
		<!--======================================================================
		 !	Template parameters
		 =========================================================================-->
		<!-- VC label for instrument entries -->
		<xsl:param name="Label"/>
		<!-- Templating mode. Possible values are:
			- 'VORBIS' for default mode, which outputs Vorbis Comments
			- 'RAWFULLLABEL' to output the full label of an instrument as a raw string
			- 'RAWSHORTLABEL' to output the short label of an instrument as a raw string -->
		<xsl:param name="Mode" select="'VORBIS'"/>
		<!--======================================================================
		 !	Common to all modes: getting instrument names
		 =========================================================================-->
		<xsl:variable name="_instrumentFull">
			<xsl:call-template name="GT_Label_Full"/>
		</xsl:variable>
		<xsl:call-template name="showDebugMessage">
			<xsl:with-param name="Template" select="'RT_Character'"/>
			<xsl:with-param name="Message" select="concat('Retrieved instrument full label is: ', $_instrumentFull)"/>
		</xsl:call-template>
		<xsl:variable name="_instrumentSort">
			<xsl:call-template name="GT_Label_Sort"/>
		</xsl:variable>
		<xsl:call-template name="showDebugMessage">
			<xsl:with-param name="Template" select="'RT_Character'"/>
			<xsl:with-param name="Message" select="concat('Retrieved instrument sort label is: ', $_instrumentSort)"/>
		</xsl:call-template>		
		<xsl:variable name="_instrumentShort">
			<xsl:call-template name="GT_Label_Short"/>
		</xsl:variable>		
		<xsl:call-template name="showDebugMessage">
			<xsl:with-param name="Template" select="'RT_Character'"/>
			<xsl:with-param name="Message" select="concat('Retrieved instrument short label is: ', $_instrumentShort)"/>
		</xsl:call-template>
		<!--======================================================================
		 !	Returning the result
		 =========================================================================-->
		<xsl:choose>
			<xsl:when test="upper-case($Mode) = 'RAWFULLLABEL'">
				<xsl:value-of select="$_instrumentFull"/>
			</xsl:when>
			<xsl:when test="upper-case($Mode) = 'RAWSHORTLABEL'">
				<xsl:value-of select="$_instrumentShort"/>
			</xsl:when>
			<xsl:when test="upper-case($Mode) = 'VORBIS'">
				<xsl:call-template name="createVorbisComment">
					<xsl:with-param name="Label" select="$Label"/>
					<xsl:with-param name="Value" select="$_instrumentFull"/>
				</xsl:call-template>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>