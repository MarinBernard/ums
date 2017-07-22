<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="3.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:umsc="http://schemas.olivarim.com/ums/1.0/common"
	xmlns:umsm="http://schemas.olivarim.com/ums/1.0/music">
	<!-- Renders performance data for a specific track -->
	<xsl:template name="RT_Performer">
		<!--======================================================================
		 !	Common performance data
		 =========================================================================-->
		<!-- Performed instrument -->
		<xsl:variable name="_instrument">
			<xsl:for-each select="umsm:instrument">
				<xsl:call-template name="GT_Label_Full"/>			
			</xsl:for-each>
		</xsl:variable>
		<!-- Instrumentalists -->
		<xsl:for-each select="umsm:instrumentalist">
			<xsl:call-template name="RT_Instrumentalist">
				<xsl:with-param name="Instrument" select="$_instrument"/>
			</xsl:call-template>			
		</xsl:for-each>		
		<!-- Music ensembles -->
		<xsl:for-each select="umsm:ensemble">
			<xsl:call-template name="RT_Ensemble"/>			
		</xsl:for-each>
	</xsl:template>
</xsl:stylesheet>