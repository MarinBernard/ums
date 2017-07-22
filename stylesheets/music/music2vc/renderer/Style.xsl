<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="3.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:umsc="http://schemas.olivarim.com/ums/1.0/common"
	xmlns:umsm="http://schemas.olivarim.com/ums/1.0/music">
	<!-- Renders the style of a work -->
	<xsl:template name="RT_Style">
		<!--======================================================================
		 !	Template parameters
		 =========================================================================-->
		<!-- Vorbis Comment label for the full variant of a style's name -->
		<xsl:param name="Label_Full"/>
		<!-- Vorbis Comment label for the sort-friendly variant of a style's name -->
		<xsl:param name="Label_Sort"/>
		<!-- Vorbis Comment label for the short variant of a style's name -->
		<xsl:param name="Label_Short"/>
		<!--======================================================================
		 !	Style name generation
		 =========================================================================-->
		<!-- Full variant of a style's name -->
		<xsl:variable name="_labelFull">
			<xsl:call-template name="GT_Label_Full"/>
		</xsl:variable>
		<!-- Sort-friendly variant of a style's name -->
		<xsl:variable name="_labelSort">
			<xsl:call-template name="GT_Label_Sort"/>
		</xsl:variable>
		<!-- Short variant of a style's name -->
		<xsl:variable name="_labelShort">
			<xsl:call-template name="GT_Label_Short"/>
		</xsl:variable>
		<!--======================================================================
		 !	VC output generation
		 =========================================================================-->
		<xsl:variable name="_VC_Style">
			<!-- VC: Full variant of a style's name -->
			<xsl:if test="normalize-space($Label_Full) != ''">
				<xsl:call-template name="createVorbisComment">
					<xsl:with-param name="Label" select="$Label_Full"/>
					<xsl:with-param name="Value" select="$_labelFull"/>
				</xsl:call-template>
			</xsl:if>
			<!-- VC: Sort-friendly variant of a style's name -->
			<xsl:if test="normalize-space($Label_Sort) != ''">
				<xsl:call-template name="createVorbisComment">
					<xsl:with-param name="Label" select="$Label_Sort"/>
					<xsl:with-param name="Value" select="$_labelSort"/>
				</xsl:call-template>
			</xsl:if>
			<!-- VC: Short variant of a style's name -->
			<xsl:if test="normalize-space($Label_Short) != ''">
				<xsl:call-template name="createVorbisComment">
					<xsl:with-param name="Label" select="$Label_Short"/>
					<xsl:with-param name="Value" select="$_labelShort"/>
				</xsl:call-template>
			</xsl:if>
			<!-- VC: Style's name as GENRE comment -->
			<xsl:if test="$config.vorbis.genres.styleAsGenre.enabled = true()">
				<xsl:choose>
					<xsl:when test="$config.vorbis.genres.styleAsGenre.preferSortVariant = true()">
						<xsl:call-template name="createVorbisComment">
							<xsl:with-param name="Label" select="$config.vorbis.labels.Genre"/>
							<xsl:with-param name="Value" select="concat($config.vorbis.genres.styleAsGenre.prefix, $_labelSort)"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="createVorbisComment">
							<xsl:with-param name="Label" select="$config.vorbis.labels.Genre"/>
							<xsl:with-param name="Value" select="concat($config.vorbis.genres.styleAsGenre.prefix, $_labelFull)"/>
						</xsl:call-template>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:if>
		</xsl:variable>
		<!--======================================================================
		 !	Output
		 =========================================================================-->
		<xsl:value-of select="$_VC_Style"/>
	</xsl:template>
</xsl:stylesheet>