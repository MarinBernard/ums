<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="3.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:umsa="http://schemas.olivarim.com/ums/1.0/audio"
	xmlns:umsb="http://schemas.olivarim.com/ums/1.0/base"
	xmlns:umsm="http://schemas.olivarim.com/ums/1.0/music">
	<xsl:template name="RT_NameVariant">
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
		<!-- Full variant -->
		<xsl:variable name="_fullName">
			<xsl:choose>
				<!-- If the variant includes a common name and the configuration
					 is set to prefer commonNames, we use it. -->
				<xsl:when test="umsb:commonName and $config.variants.preferCommonNames = true()">
					<xsl:value-of select="umsb:commonName"/>
				</xsl:when>
				<!-- Else, we build the full name from each element -->
				<xsl:otherwise>
					<xsl:if test="umsb:firstName">
						<xsl:value-of select="umsb:firstName"/>
					</xsl:if>
					<xsl:if test="umsb:secondName">
						<xsl:text> </xsl:text>
						<xsl:value-of select="umsb:secondName"/>
					</xsl:if>
					<xsl:if test="umsb:thirdName">
						<xsl:text> </xsl:text>
						<xsl:value-of select="umsb:thirdName"/>
					</xsl:if>
					<xsl:if test="umsb:particle">
						<xsl:text> </xsl:text>
						<xsl:value-of select="umsb:particle"/>
					</xsl:if>
					<xsl:if test="umsb:lastName">
						<xsl:text> </xsl:text>
						<xsl:value-of select="umsb:lastName"/>
					</xsl:if>
					<xsl:if test="umsb:pseudonym">
						<xsl:if test="$config.variants.showPseudonyms = true()">
							<xsl:text> </xsl:text>
							<xsl:value-of select="$config.variants.pseudonymPrefix"/>
							<xsl:value-of select="umsb:pseudonym"/>
							<xsl:value-of select="$config.variants.pseudonymSuffix"/>
						</xsl:if>
					</xsl:if>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<!-- Sort-friendly variant -->
		<xsl:variable name="_sortName">
			<xsl:choose>
				<xsl:when test="umsb:lastName">
					<xsl:value-of select="umsb:lastName"/>
					<xsl:value-of select="$config.variants.sortNameDelimiter"/>
					<xsl:if test="umsb:firstName">
						<xsl:text> </xsl:text>
						<xsl:value-of select="umsb:firstName"/>
					</xsl:if>
					<xsl:if test="umsb:secondName">
						<xsl:text> </xsl:text>
						<xsl:value-of select="umsb:secondName"/>
					</xsl:if>
					<xsl:if test="umsb:thirdName">
						<xsl:text> </xsl:text>
						<xsl:value-of select="umsb:thirdName"/>
					</xsl:if>
					<xsl:if test="umsb:pseudonym">
						<xsl:if test="$config.variants.showPseudonyms = true()">
							<xsl:text> </xsl:text>
							<xsl:value-of select="$config.variants.pseudonymPrefix"/>
							<xsl:value-of select="umsb:pseudonym"/>
							<xsl:value-of select="$config.variants.pseudonymSuffix"/>
						</xsl:if>
					</xsl:if>
					<xsl:if test="umsb:particle">
						<xsl:text> </xsl:text>
						<xsl:value-of select="umsb:particle"/>
					</xsl:if>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$_fullName"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<!-- Short variant -->
		<xsl:variable name="_shortName">
			<xsl:choose>
				<xsl:when test="umsb:shortName">
					<xsl:value-of select="umsb:shortName"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="umsb:lastName"/>
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
						<xsl:value-of select="$_fullName"/>
					</xsl:when>
					<xsl:when test="upper-case($RawValue) = 'SORT'">
						<xsl:value-of select="$_sortName"/>
					</xsl:when>
					<xsl:when test="upper-case($RawValue) = 'SHORT'">
						<xsl:value-of select="$_shortName"/>
					</xsl:when>
				</xsl:choose>
			</xsl:when>
			<!-- Normal mode -->
			<xsl:otherwise>
				<!-- VC: Full name -->
				<xsl:call-template name="createVorbisComment">
					<xsl:with-param name="Label" select="$Label_Full"/>
					<xsl:with-param name="Value" select="concat($_fullName, $Suffix_Full)"/>
				</xsl:call-template>
				<!-- VC: Sort-friendly name -->
				<xsl:call-template name="createVorbisComment">
					<xsl:with-param name="Label" select="$Label_Sort"/>
					<xsl:with-param name="Value" select="concat($_sortName, $Suffix_Sort)"/>
				</xsl:call-template>
				<!-- VC: Short name -->
				<xsl:call-template name="createVorbisComment">
					<xsl:with-param name="Label" select="$Label_Short"/>
					<xsl:with-param name="Value" select="concat($_shortName, $Suffix_Short)"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>