<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="3.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:umsa="http://schemas.olivarim.com/ums/1.0/audio"
	xmlns:umsb="http://schemas.olivarim.com/ums/1.0/base"
	xmlns:umsm="http://schemas.olivarim.com/ums/1.0/music">
	<xsl:template name="RT_CatalogId">
		<!--======================================================================
		 !	Template parameters
		 =========================================================================-->
		<!-- VC label for catalog id entries -->
		<xsl:param name="Label"/>
		<!-- If set to true, returns the raw catalog id string instead of a VC -->
		<xsl:param name="Raw" select="false()"/>
		<!--======================================================================
		 !	Gathering raw values
		 =========================================================================-->
		<!-- Catalog name is retrieved as a raw value -->
		<xsl:variable name="_catalogShortLabel">
			<xsl:for-each select="umsm:catalog">
				<xsl:call-template name="GT_Label_Short"/>
			</xsl:for-each>
		</xsl:variable>
		<xsl:call-template name="showDebugMessage">
			<xsl:with-param name="Template" select="'RT_CatalogId'"/>
			<xsl:with-param name="Message" select="concat('Catalog short label is: ', $_catalogShortLabel)"/>
		</xsl:call-template>
		<!--======================================================================
		 !	Building catalog id string
		 =========================================================================-->
		<!-- Sort catalog ids by level -->
		<xsl:variable name="_sortedCatalogIds">
			<xsl:for-each select="umsb:segments/umsb:segment">
				<xsl:sort data-type="number" select="@level"/>
				<xsl:copy-of select="."/>
			</xsl:for-each>
		</xsl:variable>
		<!-- Build catalog id string -->
		<xsl:variable name="_catalogId">
			<xsl:value-of select="$_catalogShortLabel"/>
			<xsl:value-of select="$config.constants.nonBreakableSpace"/>
			<xsl:for-each select="$_sortedCatalogIds/umsb:segment">
				<xsl:variable name="_segmentLevel" select="@level"/>
				<xsl:for-each select="$_sortedCatalogIds/umsm:catalog/umsb:segments/umsb:segment[@order = $_segmentLevel]">
					<xsl:choose>
						<xsl:when test="lower-case(@delimiter) = 'dash'">
							<xsl:value-of select="'-'"/>
						</xsl:when>
						<xsl:when test="lower-case(@delimiter) = 'dot'">
							<xsl:value-of select="'.'"/>
						</xsl:when>
						<xsl:when test="lower-case(@delimiter) = 'none'"/>					
						<xsl:when test="lower-case(@delimiter) = 'numero'">
							<xsl:call-template name="getTypographicSign">
								<xsl:with-param name="SignName" select="'numero'"/>
								<xsl:with-param name="Language" select="$config.variants.preferredLanguage"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:when test="lower-case(@delimiter) = 'space'">
							<xsl:value-of select="$config.constants.nonBreakableSpace"/>
						</xsl:when>
						<xsl:otherwise/>					
					</xsl:choose>
				</xsl:for-each>
				<xsl:value-of select="text()"/>
			</xsl:for-each>
		</xsl:variable>
		<xsl:call-template name="showDebugMessage">
			<xsl:with-param name="Template" select="'RT_CatalogId'"/>
			<xsl:with-param name="Message" select="concat('Catalog id full string is: ', $_catalogId)"/>
		</xsl:call-template>
		<!--======================================================================
		 !	Returning the result
		 =========================================================================-->
		<xsl:choose>
			<xsl:when test="$Raw = true()">
				<xsl:value-of select="$_catalogId"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="createVorbisComment">
					<xsl:with-param name="Label" select="$Label"/>
					<xsl:with-param name="Value" select="$_catalogId"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>