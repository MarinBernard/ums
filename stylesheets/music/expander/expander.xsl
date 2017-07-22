<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="3.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:umsc="http://schemas.olivarim.com/ums/1.0/common"
	xmlns:umsm="http://schemas.olivarim.com/ums/1.0/music">
	<!-- Common helper templates -->
	<xsl:include href="../common/helper/Paths.xsl"/>
	<!-- Includes -->
	<xsl:include href="configuration.xsl"/>
	<xsl:include href="Common.xsl"/>
	<xsl:include href="Music.xsl"/>
	<xsl:include href="Transcluder.xsl"/>
	<!-- This base template duplicates source XML by default -->
	<xsl:template match="text()|*|@*">
		<xsl:copy>
			<xsl:apply-templates select="text()|*|@*"/>
		</xsl:copy>
	</xsl:template>
	<!-- We copy the xml-model processing instruction -->
	<xsl:template match="processing-instruction('xml-model')">
		<xsl:copy/>
	</xsl:template>
	<!-- Main entry point -->
	<xsl:template match="umsm:fileset">
		<xsl:copy>
			<xsl:apply-templates select="text()|*|@*"/>
		</xsl:copy>
	</xsl:template>
</xsl:stylesheet>