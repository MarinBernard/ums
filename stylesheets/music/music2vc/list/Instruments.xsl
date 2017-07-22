<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="3.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:umsc="http://schemas.olivarim.com/ums/1.0/common"
	xmlns:umsm="http://schemas.olivarim.com/ums/1.0/music">
	<xsl:template name="LT_Instruments">
		<!--======================================================================
		 !	Template parameters
		 =========================================================================-->
		<!-- VC label for character entries -->
		<xsl:param name="Label"/>
		<!-- Templating mode. Possible values are:
			- 'VORBIS' for default mode, which outputs Vorbis Comments
			- 'RAWINSTRUMENTLIST' to output a list of instruments as a raw string -->
		<xsl:param name="Mode" select="'VORBIS'"/>
		<!--======================================================================
		 !	Vorbis mode: output Vorbis Comments
		 =========================================================================-->
		<xsl:choose>
			<xsl:when test="upper-case($Mode) = 'VORBIS'">
				<xsl:variable name="_VC_Instruments">
					<xsl:for-each select="umsm:instrument">
						<xsl:call-template name="showDebugMessage">
							<xsl:with-param name="Template" select="'LT_Instruments'"/>
							<xsl:with-param name="Message" select="concat('Processing instrument with uid: ', @uid)"/>
						</xsl:call-template>
						<xsl:call-template name="RT_Instrument">
							<xsl:with-param name="Label" select="$Label"/>
						</xsl:call-template>
					</xsl:for-each>
				</xsl:variable>
				<xsl:value-of select="$_VC_Instruments"/>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>