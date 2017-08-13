<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="3.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:umsa="http://schemas.olivarim.com/ums/1.0/audio"
	xmlns:umsb="http://schemas.olivarim.com/ums/1.0/base"
	xmlns:umsm="http://schemas.olivarim.com/ums/1.0/music">
	<!-- Renders performance data for a specific track -->
	<xsl:template name="RT_Performer">
		<!--======================================================================
		 !	Common performance data
		 =========================================================================-->
		<!-- Performed instruments -->
		<xsl:variable name="_instrumentListTmp">
			<xsl:for-each select="umsm:instruments/umsm:instrument">
				<xsl:call-template name="GT_Label_Full"/>
				<xsl:value-of select="$config.instruments.listDelimiter"/>
			</xsl:for-each>
		</xsl:variable>
		<!-- Remove last delimiter char from the list of instruments -->
		<xsl:variable name="_instrumentList" select="substring($_instrumentListTmp, 1, string-length($_instrumentListTmp) - string-length($config.instruments.listDelimiter))"/>
		<!-- Instrumentalists -->
		<xsl:for-each select="umsm:instrumentalist">
			<xsl:call-template name="RT_Instrumentalist">
				<xsl:with-param name="Instrument" select="$_instrumentList"/>
			</xsl:call-template>			
		</xsl:for-each>		
		<!-- Music ensembles -->
		<xsl:for-each select="umsm:ensemble">
			<xsl:call-template name="RT_Ensemble"/>			
		</xsl:for-each>
	</xsl:template>
</xsl:stylesheet>