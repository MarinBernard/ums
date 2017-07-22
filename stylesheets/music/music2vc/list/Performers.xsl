<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="3.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:umsc="http://schemas.olivarim.com/ums/1.0/common"
	xmlns:umsm="http://schemas.olivarim.com/ums/1.0/music">
	<xsl:template name="LT_Performers">
		<!--======================================================================
		 !	Template parameters
		 =========================================================================-->
		<!-- Templating mode. Possible values are:
			- 'VORBIS' for default mode, which outputs Vorbis Comments -->
		<xsl:param name="Mode" select="'VORBIS'"/>
		<!--======================================================================
		 !	Vorbis Comments mode: output Vorbis Comments
		 =========================================================================-->
		<xsl:choose>
			<xsl:when test="upper-case($Mode) = 'VORBIS'">
				<xsl:for-each select="umsm:performer">
					<xsl:call-template name="showDebugMessage">
						<xsl:with-param name="Template" select="'LT_Performers'"/>
						<xsl:with-param name="Message" select="'Processing a new performer.'"/>
					</xsl:call-template>
					<xsl:call-template name="RT_Performer"/>
				</xsl:for-each>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>