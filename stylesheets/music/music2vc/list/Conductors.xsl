<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="3.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:umsa="http://schemas.olivarim.com/ums/1.0/audio"
	xmlns:umsb="http://schemas.olivarim.com/ums/1.0/base"
	xmlns:umsm="http://schemas.olivarim.com/ums/1.0/music">
	<xsl:template name="LT_Conductors">
		<!--======================================================================
		 !	Rendering child conductors
		 =========================================================================-->
		<xsl:variable name="_VC_Conductors">
			<xsl:for-each select="umsm:conductor">
				<xsl:call-template name="showDebugMessage">
					<xsl:with-param name="Template" select="'LT_Conductors'"/>
					<xsl:with-param name="Message" select="concat('Processing conductor with uid: ', @uid)"/>
				</xsl:call-template>
				<xsl:call-template name="RT_Conductor"/>
			</xsl:for-each>
		</xsl:variable>
		<!--======================================================================
		 !	VC output
		 =========================================================================-->
		<xsl:value-of select="$_VC_Conductors"/>
	</xsl:template>
</xsl:stylesheet>