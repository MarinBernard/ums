<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="3.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:umsa="http://schemas.olivarim.com/ums/1.0/audio"
	xmlns:umsb="http://schemas.olivarim.com/ums/1.0/base"
	xmlns:umsm="http://schemas.olivarim.com/ums/1.0/music">
	<xsl:template name="LT_Tracks">
		<!--======================================================================
		 !	Template parameters
		 =========================================================================-->
		<!-- The number of the track for which metadata be generated. -->
		<xsl:param name="TargetTrackNumber"/>
		<!-- Template output mode. Possible value are:
			 - 'VORBIS' to generate Vorbis Comments
			 - 'RAWLYRICS' to generate lyrics as raw text. -->
		<xsl:param name="Mode" select="'VORBIS'"/>		
		<!-- Common Vorbis Comments from the parent medium -->
		<xsl:param name="CommonVC_Medium"/>
		<!-- Title of the parent album -->
		<xsl:param name="ParentAlbumTitle"/>	
		<!-- Total number of media in the publication -->
		<xsl:param name="TotalMedia"/>
		<!-- Disc number of the parent medium -->
		<xsl:param name="ParentMediumNumber"/>
		<!--======================================================================
		 !	Processing
		 =========================================================================-->
		<!-- Computing total number of tracks -->
		<xsl:variable name="_totalTracks" select="count(umsa:track)"/>
		<!--======================================================================
		 !	General output
		 =========================================================================-->
		<xsl:for-each select="umsa:track">
			<!-- Test target track number -->
			<xsl:if test="@number = $TargetTrackNumber">
				<!-- Get particular data of this single track -->
				<xsl:call-template name="RT_Track">
					<xsl:with-param name="ParentAlbumTitle" select="$ParentAlbumTitle"/>
					<xsl:with-param name="TotalTracks" select="$_totalTracks"/>
					<xsl:with-param name="CommonVC_Medium" select="$CommonVC_Medium"/>
					<xsl:with-param name="Mode" select="$Mode"/>
				</xsl:call-template>	
			</xsl:if>
		</xsl:for-each>
	</xsl:template>
</xsl:stylesheet>