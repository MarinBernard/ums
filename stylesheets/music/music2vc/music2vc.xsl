<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="3.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:umsa="http://schemas.olivarim.com/ums/1.0/audio"
	xmlns:umsb="http://schemas.olivarim.com/ums/1.0/base"
	xmlns:umsm="http://schemas.olivarim.com/ums/1.0/music">
	<!--
	==============================================================================
	!
	!	Parameters
	!
	==============================================================================

	Path to the common configuration file -->
	<xsl:param name="ConfigFile" select="'file:///C:/Users/marin/Code/ums/configuration.xml'"/>
	<!--
	
	Output mode. Possible values are 'VORBIS' and 'RAWLYRICS'. -->
	<xsl:param name="OutputMode" select="'VORBIS'"/>
	<!--
	
	If set to true(), debug info will be sent to the stderr. -->
	<xsl:variable name="Debug" select="false()" />
	<!--
	
	==============================================================================
	!
	!	Inclusions
	!
	==============================================================================
	-->
	<xsl:include href="includes.xsl"/>
	<!--
	
	==============================================================================
	!
	!	Base templates
	!
	==============================================================================
	
	Output method is text since we're producing Vorbis Comments -->
	<xsl:output method="text" indent="no"/>
	<!--
	
	Disable all text output by default -->
	<xsl:template match="text()"/>
	<!--
	
	Processing starts at the files element -->
	<xsl:template match="umsa:binding">
		<xsl:call-template name="BT_AudioBinding"/>
	</xsl:template>
</xsl:stylesheet>