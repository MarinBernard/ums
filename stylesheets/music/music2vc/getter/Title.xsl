<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="3.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:umsa="http://schemas.olivarim.com/ums/1.0/audio"
	xmlns:umsb="http://schemas.olivarim.com/ums/1.0/base"
	xmlns:umsm="http://schemas.olivarim.com/ums/1.0/music">
	<!-- Gets the raw value of the full title of a Product -->
	<xsl:template name="GT_Title_Full">
		<xsl:for-each select="umsb:titleVariants">
			<xsl:call-template name="LT_TitleVariants">
				<xsl:with-param name="RawValue" select="'FULL'"/>
			</xsl:call-template>			
		</xsl:for-each>
	</xsl:template>
	<!-- Gets the raw value of the sort title of a Product -->
	<xsl:template name="GT_Title_Sort">
		<xsl:for-each select="umsb:titleVariants">
			<xsl:call-template name="LT_TitleVariants">
				<xsl:with-param name="RawValue" select="'SORT'"/>
			</xsl:call-template>			
		</xsl:for-each>
	</xsl:template>
	<!-- Gets the raw value of the subtitle of a Product -->
	<xsl:template name="GT_Title_Subtitle">
		<xsl:for-each select="umsb:titleVariants">
			<xsl:call-template name="LT_TitleVariants">
				<xsl:with-param name="RawValue" select="'SUB'"/>
			</xsl:call-template>			
		</xsl:for-each>
	</xsl:template>
</xsl:stylesheet>