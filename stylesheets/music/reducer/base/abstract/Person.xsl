<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="3.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:umsa="http://schemas.olivarim.com/ums/1.0/audio"
	xmlns:umsb="http://schemas.olivarim.com/ums/1.0/base"
	xmlns:umsm="http://schemas.olivarim.com/ums/1.0/music">
	<!--
	=============================================================================
	!
	!	Abstract template for elements inheriting the Person abstract type 
	!____________________________________________________________________________
	!
	!	This template converts an element inheriting from the Person abstract
	!	type to XML or a simple string.
	!
	=============================================================================
	-->
	<xsl:template name="BAT_Person">
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
		<!-- Naming data of the person -->
		<xsl:variable name="_names">
			<xsl:for-each select="umsb:nameVariants">
				<xsl:call-template name="BLT_NameVariants"/>
			</xsl:for-each>
		</xsl:variable>
		<!--
		
		Birth event -->
		<xsl:variable name="_birth">
			<xsl:for-each select="umsb:birth">
				<xsl:call-template name="BRT_Birth"/>
			</xsl:for-each>
		</xsl:variable>
		<!--
		
		Death event -->
		<xsl:variable name="_death">
			<xsl:for-each select="umsb:death">
				<xsl:call-template name="BRT_Death"/>
			</xsl:for-each>
		</xsl:variable>
		<!--
		
		Link collection -->
		<xsl:variable name="_links">
			<xsl:for-each select="umsb:links">
				<xsl:call-template name="BLT_Links"/>
			</xsl:for-each>
		</xsl:variable>
		<!--
		=============================================================================
		!	Building output
		=============================================================================
		-->
		<xsl:variable name="_output">
			<xsl:choose>
				<xsl:when test="lower-case($OutputFormat) = 'xml'">
					<xsl:copy-of select="$_names"/>
					<xsl:copy-of select="$_birth"/>
					<xsl:copy-of select="$_death"/>
					<xsl:copy-of select="$_links"/>
				</xsl:when>
				<xsl:when test="lower-case($OutputFormat) = 'string'">
					<xsl:value-of select="$_names/umsb:fullName"/>					
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