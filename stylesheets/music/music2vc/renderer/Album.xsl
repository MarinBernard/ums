<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="3.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:umsa="http://schemas.olivarim.com/ums/1.0/audio"
	xmlns:umsb="http://schemas.olivarim.com/ums/1.0/base"
	xmlns:umsm="http://schemas.olivarim.com/ums/1.0/music">
	<xsl:template name="RT_Album">
		<!--======================================================================
		 !	Template parameters
		 =========================================================================-->
		<!-- The number of the parent medium of the track for which metadata should
			 be generated. -->
		<xsl:param name="TargetMediumNumber"/>
		<!-- The side of the parent medium of the track for which metadata be
			 generated. -->
		<xsl:param name="TargetMediumSide"/>
		<!-- The number of the track for which metadata be generated. -->
		<xsl:param name="TargetTrackNumber"/>
		<!-- Template output mode. Possible value are:
			 - 'VORBIS' to generate Vorbis Comments
			 - 'RAWLYRICS' to generate lyrics as raw text. -->
		<xsl:param name="Mode" select="'VORBIS'"/>
		<!--======================================================================
		 !	Common to all modes: gathering internal data
		 =========================================================================-->
		<!-- Album title-->
		<xsl:variable name="_albumTitle">
			<xsl:call-template name="GT_Title_Full"/>
		</xsl:variable>
		<xsl:call-template name="showDebugMessage">
			<xsl:with-param name="Template" select="'RT_Album'"/>
			<xsl:with-param name="Message" select="concat('Album title is: ', $_albumTitle)"/>
		</xsl:call-template>
		<!--======================================================================
		 !	Call sub templates for album media
		 =========================================================================-->
		<xsl:call-template name="showDebugMessage">
			<xsl:with-param name="Template" select="'RT_Album'"/>
			<xsl:with-param name="Message" select="'Beginning album media enumeration'"/>
		</xsl:call-template>
		<xsl:for-each select="umsa:media">
			<xsl:call-template name="LT_Media">
				<xsl:with-param name="TargetMediumNumber" select="$TargetMediumNumber"/>
				<xsl:with-param name="TargetMediumSide" select="$TargetMediumSide"/>
				<xsl:with-param name="TargetTrackNumber" select="$TargetTrackNumber"/>
				<xsl:with-param name="Mode" select="$Mode"/>
				<xsl:with-param name="ParentAlbumTitle" select="$_albumTitle"/>
			</xsl:call-template>
		</xsl:for-each>
		<xsl:call-template name="showDebugMessage">
			<xsl:with-param name="Template" select="'RT_Album'"/>
			<xsl:with-param name="Message" select="'Finished album media enumeration'"/>
		</xsl:call-template>		
	</xsl:template>
</xsl:stylesheet>