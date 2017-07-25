<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="3.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:umsa="http://schemas.olivarim.com/ums/1.0/audio"
	xmlns:umsb="http://schemas.olivarim.com/ums/1.0/base"
	xmlns:umsm="http://schemas.olivarim.com/ums/1.0/music">
	<!--
	=============================================================================
	!
	!	Rendering template for umsb:labelVariant base elements
	!____________________________________________________________________________
	!
	!	This template converts a single umsb:labelVariant element to a localized
	!	XML document or simple string.
	!
	=============================================================================
	-->
	<xsl:template name="BRT_LabelVariant">
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
		Building full label variant -->
		<xsl:variable name="_fullLabel">
			<xsl:choose>
				<!-- If the variant includes a common label and the configuration is
					 set to prefer them to full labels, we use it. -->
				<xsl:when test="umsb:commonLabel and $config.ums.variants.preferCommonLabels = true()">
					<xsl:value-of select="umsb:commonLabel"/>
				</xsl:when>
				<!-- Else, we just use the full label. -->
				<xsl:otherwise>
					<xsl:value-of select="umsb:fullLabel"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<!--
		
		Building sort-friendly label variant -->
		<xsl:variable name="_sortLabel">
			<xsl:choose>
				<xsl:when test="umsb:sortLabel">
					<xsl:value-of select="umsb:sortLabel"/>
				</xsl:when>
				<xsl:otherwise>
				<xsl:if test="$config.ums.variants.useFakeSortVariants = true()">
					<xsl:value-of select="$_fullLabel"/>
				</xsl:if>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<!--
		
		Building short label variant -->
		<xsl:variable name="_shortLabel">
			<xsl:choose>
				<xsl:when test="umsb:shortLabel">
					<xsl:value-of select="umsb:shortLabel"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$_fullLabel"/>
				</xsl:otherwise>
			</xsl:choose>
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
					<xsl:element name="umsb:fullLabel">
						<xsl:value-of select="$_fullLabel"/>
					</xsl:element>
					<xsl:element name="umsb:sortLabel">
						<xsl:value-of select="$_sortLabel"/>
					</xsl:element>
					<xsl:element name="umsb:shortLabel">
						<xsl:value-of select="$_shortLabel"/>
					</xsl:element>
				</xsl:when>
				<!-- Output a raw string -->
				<xsl:when test="lower-case($OutputFormat) = 'string'">
					<xsl:value-of select="$_fullLabel"/>
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