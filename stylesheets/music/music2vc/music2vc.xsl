<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="3.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:umsc="http://schemas.olivarim.com/ums/1.0/common"
	xmlns:umsm="http://schemas.olivarim.com/ums/1.0/music">
	<!-- Parameters -->
	<!-- Default value redirects the output to the console -->
	<xsl:param name="OutputDirectory" select="''"/>
	<!-- Output mode. Possible values are 'VORBIS' and 'RAWLYRICS'. -->
	<xsl:param name="OutputMode" select="'VORBIS'"/>
	<!-- Dependencies -->
	<xsl:include href="configuration.xsl"/>
	<xsl:include href="includes.xsl"/>
	<!-- Output method is text since we're producing Vorbis Comments -->
	<xsl:output method="text" indent="no"/>
	<!-- Disable all text output by default -->
	<xsl:template match="text()"/>
	<!-- Processing starts at the files element -->
	<xsl:template match="umsm:fileset/umsm:files">
		<xsl:call-template name="LT_Files"/>
	</xsl:template>
</xsl:stylesheet>