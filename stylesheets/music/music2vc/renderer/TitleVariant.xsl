<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="3.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:umsc="http://schemas.olivarim.com/ums/1.0/common"
	xmlns:umsm="http://schemas.olivarim.com/ums/1.0/music">
	<xsl:template name="RT_TitleVariant">
		<!--======================================================================
		 !	Template parameters
		 =========================================================================-->
		<!-- Labels -->
		<xsl:param name="Label_Full"/>
		<xsl:param name="Label_Sort"/>
		<xsl:param name="Label_Subtitle"/>
		<!-- Suffixes -->
		<xsl:param name="Suffix_Full"/>
		<xsl:param name="Suffix_Sort"/>
		<xsl:param name="Suffix_Subtitle"/>
		<!-- Raw value -->
		<xsl:param name="RawValue"/>
		<!--======================================================================
		 !	String builders
		 =========================================================================-->
		<!-- Full title -->
		<xsl:variable name="_fullTitle">
			<xsl:value-of select="umsc:fullTitle"/>
		</xsl:variable>
		<!-- Sort-friendly variant of the title -->
		<xsl:variable name="_sortTitle">
			<xsl:choose>
				<xsl:when test="umsc:sortTitle">
					<xsl:value-of select="umsc:sortTitle"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:if test="$config.variants.useFakeSortVariants = true()">
						<xsl:value-of select="$_fullTitle"/>
					</xsl:if>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<!-- Subtitle -->
		<xsl:variable name="_subtitle">
			<xsl:value-of select="umsc:subtitle"/>
		</xsl:variable>
		<!--======================================================================
		 !	Output builders
		 =========================================================================-->
		<xsl:choose>
			<!-- Raw value mode -->
			<xsl:when test="normalize-space($RawValue) != ''">
				<xsl:choose>
					<xsl:when test="upper-case($RawValue) = 'FULL'">
						<xsl:value-of select="$_fullTitle"/>
					</xsl:when>
					<xsl:when test="upper-case($RawValue) = 'SORT'">
						<xsl:value-of select="$_sortTitle"/>
					</xsl:when>
					<xsl:when test="upper-case($RawValue) = 'SUB'">
						<xsl:value-of select="$_subtitle"/>
					</xsl:when>
				</xsl:choose>
			</xsl:when>
			<!-- Normal mode -->
			<xsl:otherwise>
				<!-- VC: Full title -->
				<xsl:call-template name="createVorbisComment">
					<xsl:with-param name="Label" select="$Label_Full"/>
					<xsl:with-param name="Value" select="concat($_fullTitle, $Suffix_Full)"/>
				</xsl:call-template>
				<!-- VC: Sort-friendly title -->
				<xsl:call-template name="createVorbisComment">
					<xsl:with-param name="Label" select="$Label_Sort"/>
					<xsl:with-param name="Value" select="concat($_sortTitle, $Suffix_Sort)"/>
				</xsl:call-template>
				<!-- VC: Subtitle -->
				<xsl:call-template name="createVorbisComment">
					<xsl:with-param name="Label" select="$Label_Subtitle"/>
					<xsl:with-param name="Value" select="concat($_subtitle, $Suffix_Subtitle)"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>