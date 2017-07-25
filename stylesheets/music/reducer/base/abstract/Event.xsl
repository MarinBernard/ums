<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="3.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:umsa="http://schemas.olivarim.com/ums/1.0/audio"
	xmlns:umsb="http://schemas.olivarim.com/ums/1.0/base"
	xmlns:umsm="http://schemas.olivarim.com/ums/1.0/music">
	<!--
	=============================================================================
	!
	!	Abstract template for elements inheriting the Event abstract type 
	!____________________________________________________________________________
	!
	!	This template converts an element inheriting from the Event abstract
	!	type to XML or a simple string.
	!
	=============================================================================
	-->
	<xsl:template name="BAT_Event">
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
		<!-- Event time -->
		<xsl:variable name="_date">
			<xsl:choose>
				<xsl:when test="umsb:date">
					<xsl:value-of select="umsb:date"/>
				</xsl:when>
				<xsl:when test="umsb:year and umsb:month">
					<xsl:value-of select="umsb:date"/>
					<xsl:value-of select="'-'"/>
					<xsl:value-of select="umsb:month"/>
				</xsl:when>
				<xsl:when test="umsb:year and not(umsb:month)">
					<xsl:value-of select="umsb:month"/>
				</xsl:when>
			</xsl:choose>
		</xsl:variable>
		<!--
		
		Event place -->
		<xsl:variable name="_place">
			<xsl:if test="umsb:place">
				<xsl:value-of select="umsb:place"/>
			</xsl:if>
		</xsl:variable>
		<!--
		
		Event country, countryState or city -->
		<xsl:variable name="_administrativePlace">
			<xsl:for-each select="umsb:city">
				<xsl:call-template name="BRT_City">
					<xsl:with-param name="OutputFormat" select="'string'"/>
				</xsl:call-template>
			</xsl:for-each>					
			<xsl:for-each select="umsb:countryState">
				<xsl:value-of select="', '"/>
				<xsl:call-template name="BRT_CountryState">
					<xsl:with-param name="OutputFormat" select="'string'"/>
				</xsl:call-template>
			</xsl:for-each>
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
			<xsl:element name="umsb:date">
				<xsl:value-of select="$_date"/>
			</xsl:element>
			<xsl:element name="umsb:place">
				<xsl:if test="$_place != ''">
					<xsl:value-of select="$_place"/>
					<xsl:if test="$_administrativePlace != ''">
						<xsl:value-of select="', '"/>
					</xsl:if>
				</xsl:if>
				<xsl:if test="$_administrativePlace != ''">
					<xsl:value-of select="$_administrativePlace"/>
				</xsl:if>				
			</xsl:element>
		</xsl:variable>
		<!--
		=============================================================================
		!	Post-processing
		=============================================================================
		-->
		<xsl:copy-of select="$_output"/>
	</xsl:template>
</xsl:stylesheet>