<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="3.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:umsc="http://schemas.olivarim.com/ums/1.0/common"
	xmlns:umsm="http://schemas.olivarim.com/ums/1.0/music">
	<!-- Renders VC describing an instrumentalist -->
	<xsl:template name="RT_Ensemble">
		<!--======================================================================
		 !	Building the name of the ensemble
		 =========================================================================-->
		<xsl:variable name="_VC_Name">
			<xsl:for-each select="umsc:labelVariants">
				<xsl:call-template name="showDebugMessage">
					<xsl:with-param name="Template" select="'RT_Ensemble'"/>
					<xsl:with-param name="Message" select="'Processing labelVariants.'"/>
				</xsl:call-template>
				<xsl:call-template name="LT_LabelVariants">
					<xsl:with-param name="Label_Full" select="$config.vorbis.labels.Ensemble_Full"/>
					<xsl:with-param name="Label_Sort" select="$config.vorbis.labels.Ensemble_Sort"/>
					<xsl:with-param name="Label_Short" select="$config.vorbis.labels.Ensemble_Short"/>
				</xsl:call-template>
				<!-- Registering the ensemble as an artist, if enabled -->
				<xsl:if test="$config.vorbis.artists.includeEnsembles = true()">
					<xsl:call-template name="LT_LabelVariants">
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