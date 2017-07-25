<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="3.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:umsa="http://schemas.olivarim.com/ums/1.0/audio"
	xmlns:umsb="http://schemas.olivarim.com/ums/1.0/base"
	xmlns:umsm="http://schemas.olivarim.com/ums/1.0/music">
	<!--
	=============================================================================
	!
	!	Rendering template for umsb:nameVariant base elements
	!____________________________________________________________________________
	!
	!	This template converts a single umsb:nameVariant element to a localized
	!	XML document or simple string.
	!
	=============================================================================
	-->
	<xsl:template name="BRT_NameVariant">
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
		Building full name variant -->
		<xsl:variable name="_fullName">
			<xsl:choose>
				<!-- If the variant includes a common name and the configuration
					 is set to prefer commonNames, we use it. -->
				<xsl:when test="umsb:commonName and $config.ums.variants.preferCommonNames = true()">
					<xsl:value-of select="umsb:commonName"/>
				</xsl:when>
				<!-- Else, we build the full name from each element -->
				<xsl:otherwise>
					<xsl:if test="umsb:firstName">
						<xsl:value-of select="umsb:firstName"/>
					</xsl:if>
					<xsl:if test="umsb:secondName">
						<xsl:text> </xsl:text>
						<xsl:value-of select="umsb:secondName"/>
					</xsl:if>
					<xsl:if test="umsb:thirdName">
						<xsl:text> </xsl:text>
						<xsl:value-of select="umsb:thirdName"/>
					</xsl:if>
					<xsl:if test="umsb:lastName">
						<xsl:text> </xsl:text>
						<xsl:value-of select="umsb:lastName"/>
					</xsl:if>
					<xsl:if test="umsb:pseudonym">
						<xsl:if test="$config.ums.variants.showPseudonyms = true()">
							<xsl:text> </xsl:text>
							<xsl:value-of select="$config.ums.variants.pseudonymPrefix"/>
							<xsl:value-of select="umsb:pseudonym"/>
							<xsl:value-of select="$config.ums.variants.pseudonymSuffix"/>
						</xsl:if>
					</xsl:if>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<!--
		
		Building Sort-friendly variant -->
		<xsl:variable name="_sortName">
			<xsl:choose>
				<xsl:when test="umsb:lastName">
					<xsl:value-of select="umsb:lastName"/>
					<xsl:value-of select="$config.ums.variants.sortNameDelimiter"/>
					<xsl:if test="umsb:firstName">
						<xsl:text> </xsl:text>
						<xsl:value-of select="umsb:firstName"/>
					</xsl:if>
					<xsl:if test="umsb:secondName">
						<xsl:text> </xsl:text>
						<xsl:value-of select="umsb:secondName"/>
					</xsl:if>
					<xsl:if test="umsb:thirdName">
						<xsl:text> </xsl:text>
						<xsl:value-of select="umsb:thirdName"/>
					</xsl:if>
					<xsl:if test="umsb:pseudonym">
						<xsl:if test="$config.ums.variants.showPseudonyms = true()">
							<xsl:text> </xsl:text>
							<xsl:value-of select="$config.ums.variants.pseudonymPrefix"/>
							<xsl:value-of select="umsb:pseudonym"/>
							<xsl:value-of select="$config.ums.variants.pseudonymSuffix"/>
						</xsl:if>
					</xsl:if>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$_fullName"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<!--
		
		Building short name variant -->
		<xsl:variable name="_shortName">
			<xsl:choose>
				<xsl:when test="umsb:shortName">
					<xsl:value-of select="umsb:shortName"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="umsb:lastName"/>
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
					<xsl:element name="umsb:fullName">
						<xsl:value-of select="$_fullName"/>
					</xsl:element>
					<xsl:element name="umsb:sortName">
						<xsl:value-of select="$_sortName"/>
					</xsl:element>
					<xsl:element name="umsb:shortName">
						<xsl:value-of select="$_shortName"/>
					</xsl:element>
				</xsl:when>
				<!-- Output a raw string -->
				<xsl:when test="lower-case($OutputFormat) = 'string'">
					<xsl:value-of select="$_fullName"/>
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