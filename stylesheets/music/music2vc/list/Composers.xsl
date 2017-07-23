<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="3.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:umsc="http://schemas.olivarim.com/ums/1.0/common"
	xmlns:umsm="http://schemas.olivarim.com/ums/1.0/music">
	<xsl:template name="LT_Composers">
		<!--======================================================================
		 !	Template parameters
		 =========================================================================-->
		<!-- Templating mode. Possible values are:
			- 'VORBIS' for default mode, which outputs Vorbis Comments
			- 'RAWCOMPOSERLIST' to output a list of music composers. -->
		<xsl:param name="Mode" select="'VORBIS'"/>
		<!--======================================================================
		 !	Raw mode: building a list of composers with short names
		 =========================================================================-->
		<xsl:choose>
			<xsl:when test="upper-case($Mode) = 'RAWCOMPOSERLIST'">
				<!-- Building the list of composers -->
				<xsl:variable name="_composerListTmp">
					<xsl:for-each select="umsm:composer">
						<xsl:call-template name="showDebugMessage">
							<xsl:with-param name="Template" select="'LT_Composers'"/>
							<xsl:with-param name="Message" select="concat('Processing composer with uid: ', @uid)"/>
						</xsl:call-template>
						<xsl:call-template name="GT_Name_Short"/>
						<xsl:value-of select="$config.composers.delimiter"/>
					</xsl:for-each>
				</xsl:variable>
				<!-- Remove last delimiter char from the list of composers -->
				<xsl:variable name="_composerList" select="substring($_composerListTmp, 1, string-length($_composerListTmp) - string-length($config.composers.delimiter))"/>
				<!-- Returning the list -->
				<xsl:value-of select="$_composerList"/>
			</xsl:when>
		<!--======================================================================
		 !	Standard mode: generating Vorbis Comments
		 =========================================================================-->
			<xsl:when test="upper-case($Mode) = 'VORBIS'">
				<xsl:variable name="_VC_Composers">
					<xsl:for-each select="umsm:composer">
						<xsl:call-template name="showDebugMessage">
							<xsl:with-param name="Template" select="'LT_Composers'"/>
							<xsl:with-param name="Message" select="concat('Processing composer with uid: ', @uid)"/>
						</xsl:call-template>
						<xsl:call-template name="RT_Composer"/>
					</xsl:for-each>
				</xsl:variable>
				<xsl:value-of select="$_VC_Composers"/>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>