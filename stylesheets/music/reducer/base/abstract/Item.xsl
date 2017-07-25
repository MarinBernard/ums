<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="3.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:umsa="http://schemas.olivarim.com/ums/1.0/audio"
	xmlns:umsb="http://schemas.olivarim.com/ums/1.0/base"
	xmlns:umsm="http://schemas.olivarim.com/ums/1.0/music">
	<!--
	=============================================================================
	!
	!	Abstract template for elements inheriting the Item abstract type 
	!____________________________________________________________________________
	!
	!	This template converts an element inheriting from the Item abstract
	!	type to XML or a simple string.
	!
	=============================================================================
	-->
	<xsl:template name="BAT_Item">
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
		<!-- Label of the item -->
		<xsl:variable name="_labels">
			<xsl:for-each select="umsb:labelVariants">
				<xsl:call-template name="BLT_LabelVariants"/>
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
					<xsl:copy-of select="$_labels"/>
					<xsl:copy-of select="$_links"/>
				</xsl:when>
				<xsl:when test="lower-case($OutputFormat) = 'string'">
					<xsl:value-of select="$_labels/umsb:fullLabel"/>					
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