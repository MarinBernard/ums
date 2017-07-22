<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="3.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:umsc="http://schemas.olivarim.com/ums/1.0/common"
	xmlns:umsm="http://schemas.olivarim.com/ums/1.0/music">
	<!-- Renders VC describing an instrumentalist -->
	<xsl:template name="RT_Instrumentalist">
		<!--======================================================================
		 !	Template parameters
		 =========================================================================-->
		<!-- The name of the instrument played by the instrumentalist -->
		<xsl:param name="Instrument"/>
		<!--======================================================================
		 !	Building the name of the instrumentalist
		 =========================================================================-->
		<xsl:variable name="_VC_Name">
			<xsl:for-each select="umsc:nameVariants">
				<xsl:call-template name="showDebugMessage">
					<xsl:with-param name="Template" select="'RT_Instrumentalist'"/>
					<xsl:with-param name="Message" select="'Processing nameVariants.'"/>
				</xsl:call-template>
				<xsl:choose>
					<!-- If the performed instrument must be added as a suffix -->
					<xsl:when test="$config.vorbis.performers.instrumentSuffix.enabled = true()">
						<!-- Building instrument suffix -->
						<xsl:variable name="_instrumentSuffix" select="concat(' ', $config.vorbis.performers.instrumentSuffix.openingChar, $Instrument, $config.vorbis.performers.instrumentSuffix.closingChar)"/>
						<xsl:call-template name="showDebugMessage">
							<xsl:with-param name="Template" select="'RT_Instrumentalist'"/>
							<xsl:with-param name="Message" select="concat('Instrument suffix is: ', $_instrumentSuffix)"/>
						</xsl:call-template>
						<!-- Generating the name variant of the instrumentalist -->
						<xsl:call-template name="LT_NameVariants">
							<xsl:with-param name="Label_Full" select="$config.vorbis.labels.Instrumentalist_Full"/>
							<xsl:with-param name="Label_Sort" select="$config.vorbis.labels.Instrumentalist_Sort"/>
							<xsl:with-param name="Label_Short" select="$config.vorbis.labels.Instrumentalist_Short"/>
							<xsl:with-param name="Suffix_Full" select="$_instrumentSuffix"/>
							<xsl:with-param name="Suffix_Sort" select="$_instrumentSuffix"/>
							<xsl:with-param name="Suffix_Short" select="$_instrumentSuffix"/>
						</xsl:call-template>
					</xsl:when>
					<!-- If the performed instrument must not be added as a suffix -->
					<xsl:otherwise>
						<xsl:call-template name="LT_NameVariants">
							<xsl:with-param name="Label_Full" select="$config.vorbis.labels.Instrumentalist_Full"/>
							<xsl:with-param name="Label_Sort" select="$config.vorbis.labels.Instrumentalist_Sort"/>
							<xsl:with-param name="Label_Short" select="$config.vorbis.labels.Instrumentalist_Short"/>
						</xsl:call-template>
					</xsl:otherwise>
				</xsl:choose>
				<!-- Registering the instrumentalist as an artist, if enabled -->
				<xsl:if test="$config.vorbis.artists.instrumentalistAsArtist = true()">
					<xsl:call-template name="LT_NameVariants">
						<xsl:with-param name="Label_Full" select="$config.vorbis.labels.Artist_Full"/>
						<xsl:with-param name="Label_Sort" select="$config.vorbis.labels.Artist_Sort"/>
						<xsl:with-param name="Label_Short" select="$config.vorbis.labels.Artist_Short"/>
					</xsl:call-template>
				</xsl:if>
			</xsl:for-each>
		</xsl:variable>
		<!--======================================================================
		 !	VC output
		 =========================================================================-->
		<xsl:value-of select="$_VC_Name"/>
	</xsl:template>
</xsl:stylesheet>