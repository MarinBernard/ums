<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="3.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:umsa="http://schemas.olivarim.com/ums/1.0/audio"
	xmlns:umsb="http://schemas.olivarim.com/ums/1.0/base"
	xmlns:umsm="http://schemas.olivarim.com/ums/1.0/music">
	<xsl:template name="LT_LabelVariants">
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
		 !	Variable dump for debugging purposes
		 =========================================================================-->
		<xsl:call-template name="showDebugMessage">
			<xsl:with-param name="Template" select="'LT_LabelVariants'"/>
			<xsl:with-param name="Message" select="concat('Parameter $Label_Full has value: ', $Label_Full)"/>
		</xsl:call-template>
		<xsl:call-template name="showDebugMessage">
			<xsl:with-param name="Template" select="'LT_LabelVariants'"/>
			<xsl:with-param name="Message" select="concat('Parameter $Label_Sort has value: ', $Label_Sort)"/>
		</xsl:call-template>
		<xsl:call-template name="showDebugMessage">
			<xsl:with-param name="Template" select="'LT_LabelVariants'"/>
			<xsl:with-param name="Message" select="concat('Parameter $Label_Short has value: ', $Label_Short)"/>
		</xsl:call-template>
		<xsl:call-template name="showDebugMessage">
			<xsl:with-param name="Template" select="'LT_LabelVariants'"/>
			<xsl:with-param name="Message" select="concat('Parameter $Suffix_Full has value: ', $Suffix_Full)"/>
		</xsl:call-template>
		<xsl:call-template name="showDebugMessage">
			<xsl:with-param name="Template" select="'LT_LabelVariants'"/>
			<xsl:with-param name="Message" select="concat('Parameter $Suffix_Sort has value: ', $Suffix_Sort)"/>
		</xsl:call-template>
		<xsl:call-template name="showDebugMessage">
			<xsl:with-param name="Template" select="'LT_LabelVariants'"/>
			<xsl:with-param name="Message" select="concat('Parameter $Suffix_Short has value: ', $Suffix_Short)"/>
		</xsl:call-template>
		<xsl:call-template name="showDebugMessage">
			<xsl:with-param name="Template" select="'LT_LabelVariants'"/>
			<xsl:with-param name="Message" select="concat('Parameter $RawValue has value: ', $RawValue)"/>
		</xsl:call-template>
		<!--======================================================================
		 !	Variant rendering
		 =========================================================================-->
		<!-- Rendering variants in prefered language -->
		<xsl:variable name="_preferedLanguageVariant">
			<xsl:for-each select="umsb:labelVariant[@lang = $config.variants.preferredLanguage]">
				<xsl:call-template name="RT_LabelVariant">
					<xsl:with-param name="Label_Full" select="$Label_Full"/>
					<xsl:with-param name="Label_Sort" select="$Label_Sort"/>
					<xsl:with-param name="Label_Short" select="$Label_Short"/>
					<xsl:with-param name="Suffix_Full" select="$Suffix_Full"/>
					<xsl:with-param name="Suffix_Sort" select="$Suffix_Sort"/>
					<xsl:with-param name="Suffix_Short" select="$Suffix_Short"/>
					<xsl:with-param name="RawValue" select="$RawValue"/>
				</xsl:call-template>
			</xsl:for-each>
		</xsl:variable>
		<!-- Rendering variants in fallback language -->
		<xsl:variable name="_fallbackLanguageVariant">
			<xsl:for-each select="umsb:labelVariant[@lang = $config.variants.fallbackLanguage]">
				<xsl:call-template name="RT_LabelVariant">
					<xsl:with-param name="Label_Full" select="$Label_Full"/>
					<xsl:with-param name="Label_Sort" select="$Label_Sort"/>
					<xsl:with-param name="Label_Short" select="$Label_Short"/>
					<xsl:with-param name="Suffix_Full" select="$Suffix_Full"/>
					<xsl:with-param name="Suffix_Sort" select="$Suffix_Sort"/>
					<xsl:with-param name="Suffix_Short" select="$Suffix_Short"/>
					<xsl:with-param name="RawValue" select="$RawValue"/>
				</xsl:call-template>
			</xsl:for-each>
		</xsl:variable>
		<!-- Rendering default variants -->
		<xsl:variable name="_defaultVariant">
			<xsl:for-each select="umsb:labelVariant[@default = true()]">
				<xsl:call-template name="RT_LabelVariant">
					<xsl:with-param name="Label_Full" select="$Label_Full"/>
					<xsl:with-param name="Label_Sort" select="$Label_Sort"/>
					<xsl:with-param name="Label_Short" select="$Label_Short"/>
					<xsl:with-param name="Suffix_Full" select="$Suffix_Full"/>
					<xsl:with-param name="Suffix_Sort" select="$Suffix_Sort"/>
					<xsl:with-param name="Suffix_Short" select="$Suffix_Short"/>
					<xsl:with-param name="RawValue" select="$RawValue"/>
				</xsl:call-template>
			</xsl:for-each>
		</xsl:variable>
		<!-- Rendering original variants -->
		<xsl:variable name="_originalVariant">
			<xsl:for-each select="umsb:labelVariant[@original = true()]">
				<xsl:call-template name="RT_LabelVariant">
					<xsl:with-param name="Label_Full" select="$Label_Full"/>
					<xsl:with-param name="Label_Sort" select="$Label_Sort"/>
					<xsl:with-param name="Label_Short" select="$Label_Short"/>
					<xsl:with-param name="Suffix_Full" select="$Suffix_Full"/>
					<xsl:with-param name="Suffix_Sort" select="$Suffix_Sort"/>
					<xsl:with-param name="Suffix_Short" select="$Suffix_Short"/>
					<xsl:with-param name="RawValue" select="$RawValue"/>
				</xsl:call-template>
			</xsl:for-each>
		</xsl:variable>
		<!--======================================================================
		 !	Variant selection
		 =========================================================================-->
		<xsl:call-template name="selectVariantLanguage">
			<xsl:with-param name="PreferedLanguageVariant" select="$_preferedLanguageVariant"/>
			<xsl:with-param name="FallbackLanguageVariant" select="$_fallbackLanguageVariant"/>
			<xsl:with-param name="DefaultVariant" select="$_defaultVariant"/>
			<xsl:with-param name="OriginalVariant" select="$_originalVariant"/>
		</xsl:call-template>
	</xsl:template>
</xsl:stylesheet>