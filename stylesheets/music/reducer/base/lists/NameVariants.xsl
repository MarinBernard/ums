<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="3.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:umsa="http://schemas.olivarim.com/ums/1.0/audio"
	xmlns:umsb="http://schemas.olivarim.com/ums/1.0/base"
	xmlns:umsm="http://schemas.olivarim.com/ums/1.0/music">
	<!--
	=============================================================================
	!
	!	List template for umsb:nameVariants base lists
	!____________________________________________________________________________
	!
	!	This template converts a list of name variants to a localized XML
	!	document or simple string.
	!
	=============================================================================
	-->
	<xsl:template name="BLT_NameVariants">
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
		
		Rendering prefered variant -->
		<xsl:variable name="_preferedVariant">
			<xsl:for-each select="umsb:nameVariant[@lang = $config.ums.variants.preferredLanguage]">
				<xsl:call-template name="BRT_NameVariant">
					<xsl:with-param name="OutputFormat" select="$OutputFormat"/>
				</xsl:call-template>
			</xsl:for-each>
		</xsl:variable>
		<!--
		
		Rendering fallback variant -->
		<xsl:variable name="_fallbackVariant">
			<xsl:for-each select="umsb:nameVariant[@lang = $config.ums.variants.fallbackLanguage]">
				<xsl:call-template name="BRT_NameVariant">
					<xsl:with-param name="OutputFormat" select="$OutputFormat"/>
				</xsl:call-template>
			</xsl:for-each>
		</xsl:variable>
		<!--
		
		Rendering default variant -->
		<xsl:variable name="_defaultVariant">
			<xsl:for-each select="umsb:nameVariant[@default = true()]">
				<xsl:call-template name="BRT_NameVariant">
					<xsl:with-param name="OutputFormat" select="$OutputFormat"/>
				</xsl:call-template>
			</xsl:for-each>
		</xsl:variable>
		<!--
		
		Rendering original variant -->
		<xsl:variable name="_originalVariant">
			<xsl:for-each select="umsb:nameVariant[@original = true()]">
				<xsl:call-template name="BRT_NameVariant">
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
			<xsl:call-template name="BHT_SelectBestVariant">
				<xsl:with-param name="PreferedVariant" select="$_preferedVariant"/>
				<xsl:with-param name="FallbackVariant" select="$_fallbackVariant"/>
				<xsl:with-param name="DefaultVariant" select="$_defaultVariant"/>
				<xsl:with-param name="OriginalVariant" select="$_originalVariant"/>
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