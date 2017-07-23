<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="3.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:umsc="http://schemas.olivarim.com/ums/1.0/common"
	xmlns:umsm="http://schemas.olivarim.com/ums/1.0/music">
	<xsl:template name="createVorbisComment">
		<!--======================================================================
		 !	Parameters
		 =========================================================================-->
		<xsl:param name="Label"/>
		<xsl:param name="Value"/>
		<!--======================================================================
		 ! Output
		 =========================================================================-->
		<xsl:if test="$Label and normalize-space(string($Label)) != ''">
			<xsl:if test="$Value and normalize-space(string($Value)) != ''">
				<xsl:value-of select="$Label"/>
				<xsl:value-of select="$config.constants.vorbisAssignmentChar"/>
				<xsl:value-of select="$Value"/>
				<xsl:value-of select="$config.constants.newLineChar"/>
			</xsl:if>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>