<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="3.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:umsc="http://schemas.olivarim.com/ums/1.0/common"
	xmlns:umsm="http://schemas.olivarim.com/ums/1.0/music">
	<xsl:template name="RT_LabelVariant">
		<!--======================================================================
		 !	Template parameters
		 =========================================================================-->
		<!-- Labels -->
		<xsl:param name="Label_Full"/>
		<xsl:param name="Label_Sort"/>
		<xsl:param name="Label_Short"/>
		<!-- Suffixes -->
		<xsl:param name="Suffix_Full"/>
		<xsl:param name="Suffix_Sort"/>
		<xsl:param name="Suffix_Short"/>
		<!-- Raw value -->
		<xsl:param name="RawValue"/>
		<!--======================================================================
		 !	String builders
		 =========================================================================-->
		<!-- Full label -->
		<xsl:variable name="_fullLabel">
			<xsl:choose>
				<!-- If the variant includes a common label and the configuration is
					 set to prefer them to full labels, we use it. -->
				<xsl:when test="umsc:commonLabel and $config.variants.preferCommonLabels = true()">
					<xsl:value-of select="umsc:commonLabel"/>
				</xsl:when>
				<!-- Else, we just use the full label. -->
				<xsl:otherwise>
					<xsl:value-of select="umsc:fullLabel"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<!-- Sort-friendly variant of the label -->
		<xsl:variable name="_sortLabel">
			<xsl:choose>
				<xsl:when test="umsc:sortLabel">
					<xsl:value-of select="umsc:sortLabel"/>
				</xsl:when>
				<xsl:otherwise>
				<xsl:if test="$config.variants.sort.fakeVariants = true()">
					<xsl:value-of select="$_fullLabel"/>
				</xsl:if>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<!-- Short variant of the label -->
		<xsl:variable name="_shortLabel">
			<xsl:choose>
				<xsl:when test="umsc:shortLabel">
					<xsl:value-of select="umsc:shortLabel"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$_fullLabel"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<!--======================================================================
		 !	Output builders
		 =========================================================================-->
		<xsl:choose>
			<!-- Raw value mode -->
			<xsl:when test="normalize-space($RawValue) != ''">
				<xsl:choose>
					<xsl:when test="upper-case($RawValue) = 'FULL'">
						<xsl:value-of select="$_fullLabel"/>
					</xsl:when>
					<xsl:when test="upper-case($RawValue) = 'SORT'">
						<xsl:value-of select="$_sortLabel"/>
					</xsl:when>
					<xsl:when test="upper-case($RawValue) = 'SHORT'">
						<xsl:value-of select="$_shortLabel"/>
					</xsl:when>
				</xsl:choose>
			</xsl:when>
			<!-- Normal mode -->
			<xsl:otherwise>
				<!-- VC: Full label -->
				<xsl:call-template name="createVorbisComment">
					<xsl:with-param name="Label" select="$Label_Full"/>
					<xsl:with-param name="Value" select="concat($_fullLabel, $Suffix_Full)"/>
				</xsl:call-template>
				<!-- VC: Sort-friendly label -->
				<xsl:call-template name="createVorbisComment">
					<xsl:with-param name="Label" select="$Label_Sort"/>
					<xsl:with-param name="Value" select="concat($_sortLabel, $Suffix_Sort)"/>
				</xsl:call-template>
				<!-- VC: Short label -->
				<xsl:call-template name="createVorbisComment">
					<xsl:with-param name="Label" select="$Label_Short"/>
					<xsl:with-param name="Value" select="concat($_shortLabel, $Suffix_Short)"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>