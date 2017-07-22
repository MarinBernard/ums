<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="3.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:umsc="http://schemas.olivarim.com/ums/1.0/common"
	xmlns:umsm="http://schemas.olivarim.com/ums/1.0/music">
	<xsl:template name="RT_Key">
		<!--======================================================================
		 !	Template parameters
		 =========================================================================-->
		<!-- VC label for musical key entries -->
		<xsl:param name="Label"/>
		<!-- Templating mode. Possible values are:
			- 'VORBIS' for default mode, which outputs Vorbis Comments
			- 'RAWFULLLABEL' to output the full label of a musical key
			- 'RAWSHORTLABEL' to output the short label of a musical key -->
		<xsl:param name="Mode" select="'VORBIS'"/>
		<!--======================================================================
		 !	Common to all modes: gathering raw values
		 =========================================================================-->
		<!-- Full label of the musical key -->
		<xsl:variable name="_keyLabelFull">
				<xsl:call-template name="GT_Label_Full"/>
		</xsl:variable>
		<xsl:call-template name="showDebugMessage">
			<xsl:with-param name="Template" select="'RT_Key'"/>
			<xsl:with-param name="Message" select="concat('Musical key full label is: ', $_keyLabelFull)"/>
		</xsl:call-template>
		<!-- Short label of the musical key -->
		<xsl:variable name="_keyLabelShort">
				<xsl:call-template name="GT_Label_Short"/>
		</xsl:variable>
		<xsl:call-template name="showDebugMessage">
			<xsl:with-param name="Template" select="'RT_Key'"/>
			<xsl:with-param name="Message" select="concat('Musical key short label is: ', $_keyLabelShort)"/>
		</xsl:call-template>
		<!--======================================================================
		 !	Raw full label mode: return the full label of the musical key
		 =========================================================================-->
		<xsl:choose>
			<xsl:when test="upper-case($Mode) = 'RAWFULLLABEL'">
				<xsl:value-of select="$_keyLabelFull"/>
			</xsl:when>
		<!--======================================================================
		 !	Raw short label mode: return the short label of the musical key
		 =========================================================================-->
			<xsl:when test="upper-case($Mode) = 'RAWSHORTLABEL'">
				<xsl:value-of select="$_keyLabelShort"/>
			</xsl:when>
		<!--======================================================================
		 !	Vorbis mode: return Vorbis Comments
		 =========================================================================-->
			<xsl:when test="upper-case($Mode) = 'VORBIS'">
				<!-- VC: Musical form -->
				<xsl:call-template name="createVorbisComment">
					<xsl:with-param name="Label" select="$Label"/>
					<xsl:with-param name="Value" select="$_keyLabelFull"/>
				</xsl:call-template>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>