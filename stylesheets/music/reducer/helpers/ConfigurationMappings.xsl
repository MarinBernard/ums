<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="3.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:umsa="http://schemas.olivarim.com/ums/1.0/audio"
	xmlns:umsb="http://schemas.olivarim.com/ums/1.0/base"
	xmlns:umsm="http://schemas.olivarim.com/ums/1.0/music">
	<!--
	==============================================================================
	!
	!	Load configuration
	!
	==============================================================================
	-->
	<!-- Load configuration -->
	<xsl:variable name="ConfigData">
		<xsl:if test="not(document($ConfigFile))">
			<xsl:message terminate="yes" select="concat('Failed to load config file: ', $ConfigFile)"/>
		</xsl:if>
		<xsl:copy-of select="document($ConfigFile)/configuration/*"/>
	</xsl:variable>
	<!--
	==============================================================================
	!
	!	Main UMS options
	!
	==============================================================================
	
	Extension of UMS files -->
	<xsl:variable name="config.ums.fileExtension">
		<xsl:call-template name="getUmsOptionValue">
			<xsl:with-param name="OptionName" select="'ums-local-file-extension'"/>
		</xsl:call-template>
	</xsl:variable>
	<!--
	
	==============================================================================
	!
	!	Variant options
	!
	==============================================================================	
	
	Prefered variant langage -->
	<xsl:variable name="config.ums.variants.preferredLanguage">
		<xsl:call-template name="getUmsOptionValue">
			<xsl:with-param name="OptionName" select="'ums-variants-preferred-language'"/>
		</xsl:call-template>
	</xsl:variable>
	<!--
	
	Fallback variant langage -->
	<xsl:variable name="config.ums.variants.fallbackLanguage">
		<xsl:call-template name="getUmsOptionValue">
			<xsl:with-param name="OptionName" select="'ums-variants-fallback-language'"/>
		</xsl:call-template>
	</xsl:variable>
	<!--
	
	Whether common labels are prefered -->
	<xsl:variable name="config.ums.variants.preferCommonLabels">
		<xsl:call-template name="getUmsOptionValue">
			<xsl:with-param name="OptionName" select="'ums-variants-prefer-common-labels'"/>
			<xsl:with-param name="Boolean" select="true()"/>
		</xsl:call-template>
	</xsl:variable>	
	<!--
	
	Whether common names are prefered -->
	<xsl:variable name="config.ums.variants.preferCommonNames">
		<xsl:call-template name="getUmsOptionValue">
			<xsl:with-param name="OptionName" select="'ums-variants-prefer-common-names'"/>
			<xsl:with-param name="Boolean" select="true()"/>
		</xsl:call-template>
	</xsl:variable>
	<!--
	
	Whether people pseudonyms should be shown -->
	<xsl:variable name="config.ums.variants.showPseudonyms">
		<xsl:call-template name="getUmsOptionValue">
			<xsl:with-param name="OptionName" select="'ums-variants-show-pseudonyms'"/>
			<xsl:with-param name="Boolean" select="true()"/>
		</xsl:call-template>
	</xsl:variable>
	<!--
	
	Prefix inserted before pseudonyms -->
	<xsl:variable name="config.ums.variants.pseudonymPrefix">
		<xsl:call-template name="getUmsOptionValue">
			<xsl:with-param name="OptionName" select="'ums-variants-pseudonym-prefix'"/>
			<xsl:with-param name="AllowEmptyValue" select="true()"/>
		</xsl:call-template>
	</xsl:variable>
	<!--
	
	Suffix inserted after pseudonyms -->
	<xsl:variable name="config.ums.variants.pseudonymSuffix">
		<xsl:call-template name="getUmsOptionValue">
			<xsl:with-param name="OptionName" select="'ums-variants-pseudonym-suffix'"/>
			<xsl:with-param name="AllowEmptyValue" select="true()"/>
		</xsl:call-template>
	</xsl:variable>
	<!--
	
	A string inserted between the main and least parts of a sort name -->
	<xsl:variable name="config.ums.variants.sortNameDelimiter">
		<xsl:call-template name="getUmsOptionValue">
			<xsl:with-param name="OptionName" select="'ums-variants-sort-name-delimiter'"/>
			<xsl:with-param name="AllowEmptyValue" select="true()"/>
		</xsl:call-template>
	</xsl:variable>
	<!--
	
	Whether default variants should be used if no variant is available in
	prefered or fallback languages. -->
	<xsl:variable name="config.ums.variants.useDefaultVariants">
		<xsl:call-template name="getUmsOptionValue">
			<xsl:with-param name="OptionName" select="'ums-variants-use-default-variants'"/>
			<xsl:with-param name="Boolean" select="true()"/>
		</xsl:call-template>
	</xsl:variable>
	<!--
	
	Whether original variants should be used if no variant is available in
	prefered or fallback languages and no default variant is available either. -->
	<xsl:variable name="config.ums.variants.useOriginalVariants">
		<xsl:call-template name="getUmsOptionValue">
			<xsl:with-param name="OptionName" select="'ums-variants-use-original-variants'"/>
			<xsl:with-param name="Boolean" select="true()"/>
		</xsl:call-template>
	</xsl:variable>
	<!--
	
	Whether fake sort variants should be created even when no sort-friendly
	variant was defined. -->
	<xsl:variable name="config.ums.variants.useFakeSortVariants">
		<xsl:call-template name="getUmsOptionValue">
			<xsl:with-param name="OptionName" select="'ums-variants-use-fake-sort-variants'"/>
			<xsl:with-param name="Boolean" select="true()"/>
		</xsl:call-template>
	</xsl:variable>
	<!--	
	
	==============================================================================
	!
	!	Stylesheet options
	!
	==============================================================================
	-->
</xsl:stylesheet>