<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="3.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:umsc="http://schemas.olivarim.com/ums/1.0/common"
	xmlns:umsm="http://schemas.olivarim.com/ums/1.0/music">
	<xsl:template name="showStdoutFileDelimiter">
		<!--======================================================================
		 !	Parameters
		 =========================================================================-->
		<xsl:param name="File"/>
		<xsl:param name="Mode"/>
		<!--======================================================================
		 ! Output
		 =========================================================================-->
		<xsl:variable name="_modeLabel">
			<xsl:choose>
				<xsl:when test="upper-case($Mode) = 'VORBIS'">
					<xsl:value-of select="'Vorbis Comments'"/>
				</xsl:when>
				<xsl:when test="upper-case($Mode) = 'RAWLYRICS'">
					<xsl:value-of select="'Lyrics'"/>
				</xsl:when>
			</xsl:choose>
		</xsl:variable>
		<xsl:value-of select="'##############################################################################'"/>
		<xsl:value-of select="$config.constants.newLineChar"/>
		<xsl:value-of select="concat('#   File: ', $File, ' - ', $_modeLabel )"/>
		<xsl:value-of select="$config.constants.newLineChar"/>
		<xsl:value-of select="'##############################################################################'"/>
		<xsl:value-of select="$config.constants.newLineChar"/>
	</xsl:template>
</xsl:stylesheet>