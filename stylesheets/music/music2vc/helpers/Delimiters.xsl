<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="3.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:umsc="http://schemas.olivarim.com/ums/1.0/common"
	xmlns:umsm="http://schemas.olivarim.com/ums/1.0/music">
	<!-- Returns the special string used to explode a track title in movement titles -->
	<xsl:template name="getMovementTitleDelimiter">
		<xsl:value-of select="'50M3_R4ND0M_5TR1NG_M4RK3R!'"/>
	</xsl:template>
	<!-- Inserts a delimiter string between movement titles -->
	<xsl:template name="insertMovementTitleDelimiter">
		<xsl:if test="$config.vorbis.movementTitles.concatenate = false()">
			<xsl:variable name="_delimiter">
				<xsl:call-template name="getMovementTitleDelimiter"/>
			</xsl:variable>
			<xsl:value-of select="$_delimiter"/>
		</xsl:if>
		<xsl:value-of select="$config.movementTitles.delimiter"/>
	</xsl:template>
	<!-- Returns an horizontal delimiter surrounding the title of a movement in a lyrics file -->
	<xsl:template name="getLyricsTitleDelimiter">
		<xsl:value-of select="'------------------------------------------------------------------------------'"/>
	</xsl:template>
</xsl:stylesheet>