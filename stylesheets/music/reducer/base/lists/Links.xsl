<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="3.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:umsa="http://schemas.olivarim.com/ums/1.0/audio"
	xmlns:umsb="http://schemas.olivarim.com/ums/1.0/base"
	xmlns:umsm="http://schemas.olivarim.com/ums/1.0/music">
	<!--
	=============================================================================
	!
	!	List template for umsb:links base lists
	!____________________________________________________________________________
	!
	!	This template converts a list of internet links to a localized XML
	!	document or simple string.
	!
	=============================================================================
	-->
	<xsl:template name="BLT_Links">
		<!--
		=============================================================================
		!	Template parameters
		=============================================================================
		-->
		<xsl:param name="OutputFormat" select="'xml'"/>
		<!--
		=============================================================================
		!	Collecting data
		=============================================================================
		
		Rendering prefered wikipedia variant -->
		<xsl:variable name="_wikipediaPreferedVariant">
			<xsl:for-each select="umsb:wikipedia[@lang = $config.ums.variants.preferredLanguage]">
				<xsl:call-template name="BRT_Wikipedia">
					<xsl:with-param name="OutputFormat" select="$OutputFormat"/>
				</xsl:call-template>
			</xsl:for-each>
		</xsl:variable>
		<!--
		
		Rendering wikipedia fallback variant -->
		<xsl:variable name="_wikipediaFallbackVariant">
			<xsl:for-each select="umsb:wikipedia[@lang = $config.ums.variants.fallbackLanguage]">
				<xsl:call-template name="BRT_Wikipedia">
					<xsl:with-param name="OutputFormat" select="$OutputFormat"/>
				</xsl:call-template>
			</xsl:for-each>
		</xsl:variable>
		<!--
		
		Rendering wikipedia default variant -->
		<xsl:variable name="_wikipediaDefaultVariant">
			<xsl:for-each select="umsb:wikipedia[@default = true()]">
				<xsl:call-template name="BRT_Wikipedia">
					<xsl:with-param name="OutputFormat" select="$OutputFormat"/>
				</xsl:call-template>
			</xsl:for-each>
		</xsl:variable>
		<!--
		
		Rendering wikipedia original variant -->
		<xsl:variable name="_wikipediaOriginalVariant">
			<xsl:for-each select="umsb:wikipedia[@original = true()]">
				<xsl:call-template name="BRT_Wikipedia">
					<xsl:with-param name="OutputFormat" select="$OutputFormat"/>
				</xsl:call-template>
			</xsl:for-each>
		</xsl:variable>
		<!--
		=============================================================================
		!	Building output
		=============================================================================
		-->
		<xsl:variable name="_output">
			<!-- Wikipedia link variants -->
			<xsl:call-template name="BHT_SelectBestVariant">
				<xsl:with-param name="PreferedVariant" select="$_wikipediaPreferedVariant"/>
				<xsl:with-param name="FallbackVariant" select="$_wikipediaFallbackVariant"/>
				<xsl:with-param name="DefaultVariant" select="$_wikipediaDefaultVariant"/>
				<xsl:with-param name="OriginalVariant" select="$_wikipediaOriginalVariant"/>
			</xsl:call-template>
		</xsl:variable>
		<!--
		=============================================================================
		!	Post-processing
		=============================================================================
		-->
		<xsl:copy-of select="$_output"/>
	</xsl:template>	
</xsl:stylesheet>