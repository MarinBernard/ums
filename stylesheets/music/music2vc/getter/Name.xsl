<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="3.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:umsc="http://schemas.olivarim.com/ums/1.0/common"
	xmlns:umsm="http://schemas.olivarim.com/ums/1.0/music">
	<!-- Gets the raw value of the full name of a Person -->
	<xsl:template name="GT_Name_Full">
		<xsl:for-each select="umsc:nameVariants">
			<xsl:call-template name="LT_NameVariants">
				<xsl:with-param name="RawValue" select="'FULL'"/>
			</xsl:call-template>			
		</xsl:for-each>
	</xsl:template>
	<!-- Gets the raw value of the sort name of a Person -->
	<xsl:template name="GT_Name_Sort">
		<xsl:for-each select="umsc:nameVariants">
			<xsl:call-template name="LT_NameVariants">
				<xsl:with-param name="RawValue" select="'SORT'"/>
			</xsl:call-template>			
		</xsl:for-each>
	</xsl:template>
	<!-- Gets the raw value of the short name of a Person -->
	<xsl:template name="GT_Name_Short">
		<xsl:for-each select="umsc:nameVariants">
			<xsl:call-template name="LT_NameVariants">
				<xsl:with-param name="RawValue" select="'SHORT'"/>
			</xsl:call-template>			
		</xsl:for-each>
	</xsl:template>
</xsl:stylesheet>