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

	Target output format. -->
	<xsl:variable name="OutputFormat" select="'FLATXML'" />
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
	<xsl:output method="xml" indent="yes"/>
	<!--
	
	Disable all text output by default -->
	<xsl:template match="text()"/>
	<!--
	
	Processing starts at the composer element -->
	<xsl:template match="umsm:key">
		<xsl:call-template name="HT_FillDocumentContent">
			<xsl:with-param name="DocumentContent">
				<xsl:call-template name="MRT_Key"/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<!--
	
	Wraps content into a document element -->
	<xsl:template name="HT_FillDocumentContent">
		<xsl:param name="DocumentContent"/>
		<xsl:element name="{name()}"
			xmlns:umsa="http://schemas.olivarim.com/ums/1.0/audio"
			xmlns:umsb="http://schemas.olivarim.com/ums/1.0/base"
			xmlns:umsm="http://schemas.olivarim.com/ums/1.0/music">
			<xsl:copy-of select="$DocumentContent"/>
		</xsl:element>
	</xsl:template>
</xsl:stylesheet>