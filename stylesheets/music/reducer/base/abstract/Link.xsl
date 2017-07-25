<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="3.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:umsa="http://schemas.olivarim.com/ums/1.0/audio"
	xmlns:umsb="http://schemas.olivarim.com/ums/1.0/base"
	xmlns:umsm="http://schemas.olivarim.com/ums/1.0/music">
	<!--
	=============================================================================
	!
	!	Abstract template for elements inheriting the Link abstract type 
	!____________________________________________________________________________
	!
	!	This template converts an element inheriting from the Link abstract
	!	type to XML or a simple string.
	!
	=============================================================================
	-->
	<xsl:template name="BAT_Link">
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
		<!-- Link url -->
		<xsl:variable name="_url">
			<xsl:value-of select="@href"/>
		</xsl:variable>
		<!--
		=============================================================================
		!	Building output
		=============================================================================
		-->
		<xsl:variable name="_output">
			<xsl:choose>
				<xsl:when test="lower-case($OutputFormat) = 'xml'">
					<xsl:element name="umsb:url">
						<xsl:value-of select="$_url"/>
					</xsl:element>
				</xsl:when>
				<xsl:when test="lower-case($OutputFormat) = 'string'">
					<xsl:value-of select="$_url"/>					
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