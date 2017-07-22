<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="3.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:umsc="http://schemas.olivarim.com/ums/1.0/common"
	xmlns:umsm="http://schemas.olivarim.com/ums/1.0/music">
	
	<!-- Transclusion of references to <city> elements -->
	<xsl:template match="umsc:city[@uid][not(*)]">
		<xsl:call-template name="Transcluder">
			<xsl:with-param name="CatalogRoot" select="$CAT_Common_Cities"/>
			<xsl:with-param name="TargetElement" select="'city'"/>
		</xsl:call-template>
	</xsl:template>
	
	<!-- Transclusion of references to <country> elements -->
	<xsl:template match="umsc:country[@uid][not(*)]">
		<xsl:call-template name="Transcluder">
			<xsl:with-param name="CatalogRoot" select="$CAT_Common_Countries"/>
			<xsl:with-param name="TargetElement" select="'country'"/>
		</xsl:call-template>
	</xsl:template>
	
	<!-- Transclusion of references to <countryState> elements -->
	<xsl:template match="umsc:countryState[@uid][not(*)]">
		<xsl:call-template name="Transcluder">
			<xsl:with-param name="CatalogRoot" select="$CAT_Common_CountryStates"/>
			<xsl:with-param name="TargetElement" select="'countryState'"/>
		</xsl:call-template>
	</xsl:template>

</xsl:stylesheet>