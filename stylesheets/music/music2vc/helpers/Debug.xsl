<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="3.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:umsa="http://schemas.olivarim.com/ums/1.0/audio"
	xmlns:umsb="http://schemas.olivarim.com/ums/1.0/base"
	xmlns:umsm="http://schemas.olivarim.com/ums/1.0/music">
	<xsl:template name="showDebugMessage">
		<!--======================================================================
		 !	Parameters
		 =========================================================================-->
		<xsl:param name="Message"/>
		<xsl:param name="Template"/>
		<!--======================================================================
		 ! Output
		 =========================================================================-->
		<xsl:if test="$config.debug.enabled = true()">
			<xsl:if test="$Message and normalize-space(string($Message)) != ''">
				<xsl:message select="concat('[DEBUG] (', $Template, ') ', $Message)"/>
			</xsl:if>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>