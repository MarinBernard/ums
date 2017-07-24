<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="3.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:umsa="http://schemas.olivarim.com/ums/1.0/audio"
	xmlns:umsb="http://schemas.olivarim.com/ums/1.0/base"
	xmlns:umsm="http://schemas.olivarim.com/ums/1.0/music">
	<xsl:template name="BT_AudioContentBinding">
		<!--======================================================================
		 !	Processing file list
		 =========================================================================-->
		<xsl:for-each select="umsa:albumTrackBinding">
			<xsl:variable name="_targetMediumNumber" select="@medium"/>
			<xsl:variable name="_targetMediumSide" select="@side"/>
			<xsl:variable name="_targetTrackNumber" select="@track"/>
			<!-- Checking whether an album element is available -->
			<xsl:if test="not(umsa:album)">
				<xsl:message terminate="yes" select="'ERROR: The album track binding requires an album element!'"/>
			</xsl:if>
			<!--======================================================================
			 !	Generation Vorbis Comments and lyrics
			 =========================================================================-->
			<xsl:for-each select="umsa:album">
				<!-- Generating Vorbis Comments or Lyrics-->
				<xsl:call-template name="RT_Album">
					<xsl:with-param name="TargetMediumNumber" select="$_targetMediumNumber"/>
					<xsl:with-param name="TargetMediumSide" select="$_targetMediumSide"/>
					<xsl:with-param name="TargetTrackNumber" select="$_targetTrackNumber"/>
					<xsl:with-param name="Mode" select="$OutputMode"/>
				</xsl:call-template>
			</xsl:for-each><!-- End of VC / Lyrics generation -->
		</xsl:for-each><!-- End of processing for the current file -->
	</xsl:template>
</xsl:stylesheet>