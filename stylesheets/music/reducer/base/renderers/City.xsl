<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="3.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:umsa="http://schemas.olivarim.com/ums/1.0/audio"
	xmlns:umsb="http://schemas.olivarim.com/ums/1.0/base"
	xmlns:umsm="http://schemas.olivarim.com/ums/1.0/music">
	<!--
	=============================================================================
	!
	!	Rendering template for umsb:city base elements
	!____________________________________________________________________________
	!
	!	This template converts a single umsb:city element to a localized
	!	XML document or simple string.
	!
	=============================================================================
	-->
	<xsl:template name="BRT_City">
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
		-->
		<!--
		Gathering XML elements inherited from the parent Item abstract type. -->
		<xsl:variable name="_itemInheritedElements">
			<xsl:call-template name="BAT_Item"/>
		</xsl:variable>
		<!--
		
		Building fully qualified label with country state and country info -->
		<xsl:variable name="_fullyQualifiedName">
			<xsl:value-of select="$_itemInheritedElements/umsb:fullLabel"/>
			<!-- Parent city -->
			<xsl:for-each select="umsb:countryState">
				<xsl:value-of select="', '"/>
				<xsl:call-template name="BRT_CountryState">
					<xsl:with-param name="OutputFormat" select="'string'"/>
				</xsl:call-template>
			</xsl:for-each>
			<!-- Parent country -->
			<xsl:for-each select="umsb:country">
				<xsl:value-of select="', '"/>
				<xsl:call-template name="BRT_Country">
					<xsl:with-param name="OutputFormat" select="'string'"/>
				</xsl:call-template>
			</xsl:for-each>
		</xsl:variable>
		<!--
		=============================================================================
		!	Building output
		=============================================================================
		-->
		<xsl:variable name="_output">
			<xsl:choose>
				<!-- Output XML elements -->
				<xsl:when test="lower-case($OutputFormat) = 'xml'">
					<xsl:copy-of select="$_itemInheritedElements"/>
				</xsl:when>
				<!-- Output a raw string -->
				<xsl:when test="lower-case($OutputFormat) = 'string'">
					<xsl:value-of select="$_fullyQualifiedName"/>
				</xsl:when>
			</xsl:choose>
		</xsl:variable>
		<!--
		=============================================================================
		!	Post-processing
		=============================================================================
		-->
		<xsl:copy-of select="$_output"/>
	</xsl:template>
</xsl:stylesheet>