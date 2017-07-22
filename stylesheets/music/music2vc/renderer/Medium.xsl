<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="3.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:umsc="http://schemas.olivarim.com/ums/1.0/common"
	xmlns:umsm="http://schemas.olivarim.com/ums/1.0/music">
	<xsl:template name="RT_Medium">
		<!--======================================================================
		 !	Template parameters
		 =========================================================================-->
		<!-- The number of the track for which metadata be generated. -->
		<xsl:param name="TargetTrackNumber"/>
		<!-- Template output mode. Possible value are:
			 - 'VORBIS' to generate Vorbis Comments
			 - 'RAWLYRICS' to generate lyrics as raw text. -->
		<xsl:param name="Mode" select="'VORBIS'"/>
		<!-- Title of the parent album -->
		<xsl:param name="ParentAlbumTitle"/>
		<!-- Total number of media in the publication -->
		<xsl:param name="TotalMedia"/>
		<!--======================================================================
		 !	Common to all modes: gathring internal data
		 =========================================================================-->
		<!-- Medium number -->
		<xsl:variable name="_number" select="@number"/>
		<!-- Medium side -->
		<xsl:variable name="_side">
			<xsl:choose>
				<xsl:when test="@side">
					<xsl:value-of select="@side"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="1"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="_realMediumNumber" select="count(current()/preceding::umsm:medium) + 1"/>
		<!--======================================================================
		 !	Store common medium information
		 =========================================================================-->
		<!-- Vorbis comments common to all tracks of the medium must be available 
			 on track enumeration. We thus need to store them in a variable now. -->
		<xsl:variable name="_CommonVC_Medium">
			<!-- VC: Disc number -->
			<xsl:call-template name="createVorbisComment">
				<xsl:with-param name="Label" select="$config.vorbis.labels.Disc_Number"/>
				<xsl:with-param name="Value" select="$_realMediumNumber"/>
			</xsl:call-template>
			<!-- VC: Disc total -->
			<xsl:call-template name="createVorbisComment">
				<xsl:with-param name="Label" select="$config.vorbis.labels.Disc_Total"/>
				<xsl:with-param name="Value" select="$TotalMedia"/>
			</xsl:call-template>
		</xsl:variable>
		<!--======================================================================
		 !	Calling sub template to process track list
		 =========================================================================-->
		<xsl:for-each select="umsm:tracks">
			<xsl:call-template name="LT_Tracks">
				<xsl:with-param name="TargetTrackNumber" select="$TargetTrackNumber"/>
				<xsl:with-param name="Mode" select="$Mode"/>
				<xsl:with-param name="CommonVC_Medium" select="$_CommonVC_Medium"/>
				<xsl:with-param name="ParentAlbumTitle" select="$ParentAlbumTitle"/>
				<xsl:with-param name="TotalMedia" select="$TotalMedia"/>
				<xsl:with-param name="ParentMediumNumber" select="$_realMediumNumber"/>
			</xsl:call-template>
		</xsl:for-each>
	</xsl:template>
</xsl:stylesheet>