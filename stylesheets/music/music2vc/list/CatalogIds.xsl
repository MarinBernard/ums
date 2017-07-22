<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="3.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:umsc="http://schemas.olivarim.com/ums/1.0/common"
	xmlns:umsm="http://schemas.olivarim.com/ums/1.0/music">
	<xsl:template name="LT_CatalogIds">
		<!--======================================================================
		 !	Template parameters
		 =========================================================================-->
		<!-- VC label for catalog id entries -->
		<xsl:param name="Label"/>
		<!-- If set to true, returns the raw catalog id string instead of a VC -->
		<xsl:param name="Raw" select="false()"/>
		<!--======================================================================
		 !	Generating catalog ids as Vorbis Comments
		 =========================================================================-->
		<xsl:variable name="_VC_CatalogIds">
			<xsl:for-each select="umsm:catalogId">
				<xsl:call-template name="showDebugMessage">
					<xsl:with-param name="Template" select="'LT_CatalogId'"/>
					<xsl:with-param name="Message" select="'Processing a new catalogId'"/>
				</xsl:call-template>
				<xsl:call-template name="RT_CatalogId">
					<xsl:with-param name="Label" select="$Label"/>
				</xsl:call-template>
			</xsl:for-each>
		</xsl:variable>
		<!--======================================================================
		 !	Generating catalog ids as a single string
		 =========================================================================-->
		<xsl:variable name="_catalogIdsTmp">
			<xsl:for-each select="umsm:catalogId">
				<xsl:call-template name="showDebugMessage">
					<xsl:with-param name="Template" select="'LT_CatalogIds'"/>
					<xsl:with-param name="Message" select="'Processing a new catalogId'"/>
				</xsl:call-template>
				<xsl:call-template name="RT_CatalogId">
					<xsl:with-param name="Raw" select="true()"/>
				</xsl:call-template>
				<xsl:value-of select="$config.workTitles.catalogId.delimiterChar"/>
			</xsl:for-each>
		</xsl:variable>
		<xsl:variable name="_catalogIds" select="substring($_catalogIdsTmp, 1, string-length($_catalogIdsTmp) - string-length($config.workTitles.catalogId.delimiterChar) )"/>
		<xsl:call-template name="showDebugMessage">
			<xsl:with-param name="Template" select="'LT_CatalogIds'"/>
			<xsl:with-param name="Message" select="concat('Catalog id single string is: ', $_catalogIds)"/>
		</xsl:call-template>
		<!--======================================================================
		 !	Returning results
		 =========================================================================-->
		<xsl:choose>
			<!-- Raw value -->
			<xsl:when test="$Raw = true()">
				<xsl:value-of select="$_catalogIds"/>
			</xsl:when>
			<!-- Vorbis Comments -->
			<xsl:otherwise>
				<xsl:value-of select="$_VC_CatalogIds"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>