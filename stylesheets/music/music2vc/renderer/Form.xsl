<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="3.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:umsa="http://schemas.olivarim.com/ums/1.0/audio"
	xmlns:umsb="http://schemas.olivarim.com/ums/1.0/base"
	xmlns:umsm="http://schemas.olivarim.com/ums/1.0/music">
	<xsl:template name="RT_Form">
		<!--======================================================================
		 !	Template parameters
		 =========================================================================-->
		<!-- VC label for musical form entries -->
		<xsl:param name="Label"/>
		<!-- Templating mode. Possible values are:
			- 'VORBIS' for default mode, which outputs Vorbis Comments
			- 'RAWFULLLABEL' to output the full label of a musical form
			- 'RAWSORTLABEL' to output the sort label of a musical form
			- 'RAWSHORTLABEL' to output the short label of a musical form -->
		<xsl:param name="Mode" select="'VORBIS'"/>
		<!--======================================================================
		 !	Common to all modes: gathering raw values
		 =========================================================================-->
		<!-- Full label of the musical form -->
		<xsl:variable name="_formLabelFull">
				<xsl:call-template name="GT_Label_Full"/>
		</xsl:variable>
		<xsl:call-template name="showDebugMessage">
			<xsl:with-param name="Template" select="'RT_Form'"/>
			<xsl:with-param name="Message" select="concat('Musical form full label is: ', $_formLabelFull)"/>
		</xsl:call-template>
		<!-- Sort label of the musical form -->
		<xsl:variable name="_formLabelSort">
				<xsl:call-template name="GT_Label_Sort"/>
		</xsl:variable>
		<xsl:call-template name="showDebugMessage">
			<xsl:with-param name="Template" select="'RT_Form'"/>
			<xsl:with-param name="Message" select="concat('Musical form sort label is: ', $_formLabelSort)"/>
		</xsl:call-template>
		<!-- Short label of the musical form -->
		<xsl:variable name="_formLabelShort">
				<xsl:call-template name="GT_Label_Short"/>
		</xsl:variable>
		<xsl:call-template name="showDebugMessage">
			<xsl:with-param name="Template" select="'RT_Form'"/>
			<xsl:with-param name="Message" select="concat('Musical form short label is: ', $_formLabelShort)"/>
		</xsl:call-template>
		<!--======================================================================
		 !	Raw full label mode: return the full label of the musical form
		 =========================================================================-->
		<xsl:choose>
			<xsl:when test="upper-case($Mode) = 'RAWFULLLABEL'">
				<xsl:value-of select="$_formLabelFull"/>
			</xsl:when>
		<!--======================================================================
		 !	Raw sort label mode: return the sort label of the musical form
		 =========================================================================-->
			<xsl:when test="upper-case($Mode) = 'RAWSORTLABEL'">
				<xsl:value-of select="$_formLabelSort"/>
			</xsl:when>
		<!--======================================================================
		 !	Raw short label mode: return the short label of the musical form
		 =========================================================================-->
			<xsl:when test="upper-case($Mode) = 'RAWSHORTLABEL'">
				<xsl:value-of select="$_formLabelShort"/>
			</xsl:when>
		<!--======================================================================
		 !	Vorbis mode: return Vorbis Comments
		 =========================================================================-->
			<xsl:when test="upper-case($Mode) = 'VORBIS'">
				<!-- VC: Musical form -->
				<xsl:call-template name="createVorbisComment">
					<xsl:with-param name="Label" select="$Label"/>
					<xsl:with-param name="Value" select="$_formLabelFull"/>
				</xsl:call-template>
				<!-- VC: Musical form as GENRE comment -->
				<xsl:if test="$config.vorbis.genres.includeForms = true()">
					<xsl:choose>
						<xsl:when test="$config.vorbis.genres.preferFormSortLabels = true()">
							<xsl:call-template name="createVorbisComment">
								<xsl:with-param name="Label" select="$config.vorbis.labels.Genre"/>
								<xsl:with-param name="Value" select="concat($config.vorbis.genres.formPrefix, $_formLabelSort)"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:otherwise>
							<xsl:call-template name="createVorbisComment">
								<xsl:with-param name="Label" select="$config.vorbis.labels.Genre"/>
								<xsl:with-param name="Value" select="concat($config.vorbis.genres.formPrefix, $_formLabelFull)"/>
							</xsl:call-template>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>