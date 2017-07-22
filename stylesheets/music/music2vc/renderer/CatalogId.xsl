<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="3.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:umsc="http://schemas.olivarim.com/ums/1.0/common"
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
			<xsl:for-each select="umsm:id">
				<xsl:sort data-type="number" select="@level"/>
				<xsl:copy-of select="."/>
			</xsl:for-each>
		</xsl:variable>
		<!-- Build catalog id string -->
		<xsl:variable name="_catalogIdTmp">
			<xsl:value-of select="$_catalogShortLabel"/>
			<xsl:value-of select="' '"/>
			<xsl:for-each select="$_sortedCatalogIds/umsm:id">
				<xsl:choose>
					<xsl:when test="lower-case(@qualifier) = 'numero'">
						<xsl:call-template name="getTypographicSign">
							<xsl:with-param name="SignName" select="'numero'"/>
							<xsl:with-param name="Language" select="$config.variants.preferredLanguage"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:otherwise/>					
				</xsl:choose>
				<xsl:value-of select="text()"/>
				<xsl:value-of select="' '"/>
			</xsl:for-each>
		</xsl:variable>
		<!-- Remove trailing space character -->
		<xsl:variable name="_catalogId" select="substring($_catalogIdTmp, 1, string-length($_catalogIdTmp) - 1)"/>
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