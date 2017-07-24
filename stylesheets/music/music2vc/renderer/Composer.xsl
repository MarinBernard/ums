<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="3.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:umsa="http://schemas.olivarim.com/ums/1.0/audio"
	xmlns:umsb="http://schemas.olivarim.com/ums/1.0/base"
	xmlns:umsm="http://schemas.olivarim.com/ums/1.0/music">
	<!-- Renders performance data for a specific track -->
	<xsl:template name="RT_Composer">
		<!--======================================================================
		 !	Composer name generation
		 =========================================================================-->
		<xsl:variable name="_VC_Name">
			<!-- Composer name -->
			<xsl:for-each select="umsb:nameVariants">
				<xsl:call-template name="LT_NameVariants">
					<xsl:with-param name="Label_Full" select="$config.vorbis.labels.Composer_Full"/>
					<xsl:with-param name="Label_Sort" select="$config.vorbis.labels.Composer_Sort"/>
					<xsl:with-param name="Label_Short" select="$config.vorbis.labels.Composer_Short"/>
				</xsl:call-template>
				<!-- Registering the composer as an artist, if enabled -->
				<xsl:if test="$config.vorbis.artists.includeComposers = true()">
					<xsl:call-template name="LT_NameVariants">
						<xsl:with-param name="Label_Full" select="$config.vorbis.labels.Artist_Full"/>
						<xsl:with-param name="Label_Sort" select="$config.vorbis.labels.Artist_Sort"/>
						<xsl:with-param name="Label_Short" select="$config.vorbis.labels.Artist_Short"/>
					</xsl:call-template>
				</xsl:if>
			</xsl:for-each>
		</xsl:variable>
		<!--======================================================================
		 !	VC output
		 =========================================================================-->
		<xsl:value-of select="$_VC_Name"/>
	</xsl:template>
</xsl:stylesheet>