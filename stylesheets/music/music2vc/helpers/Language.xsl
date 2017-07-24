<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="3.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:umsa="http://schemas.olivarim.com/ums/1.0/audio"
	xmlns:umsb="http://schemas.olivarim.com/ums/1.0/base"
	xmlns:umsm="http://schemas.olivarim.com/ums/1.0/music"><!--
	================================================================================================================================
	!
	!	TEMPLATE 'getLanguageDocument'
	!_______________________________________________________________________________________________________________________________
	!
	!	Retrieves and returns a language document from the language catalog.
	!
	================================================================================================================================
	-->
	<xsl:template name="getLanguageDocument">
		<!--
		=========================================================================
		!	Parameters
		=========================================================================
		-->
		<xsl:param name="Language"/>
		<!--
		=========================================================================
		!	Process
		=========================================================================
		-->
		<!-- Building the full path to the target document -->
		<xsl:variable name="_targetDocumentName" select="concat($Language, $config.fileExtensions.umsFile)"/>
		<xsl:variable name="_documentFullPath" select="concat($config.catalogs.languages, '/', $_targetDocumentName)"/>
		<!-- Trying to acquire the target document -->
		<xsl:variable name="_document" select="document($_documentFullPath)/umsb:language"/>
		<!-- Check document existence-->
		<xsl:if test="$_document = ''">
			<xsl:message terminate="yes" select="'Language document not found or invalid: ', $_documentFullPath"/>
		</xsl:if>
		<!--
		=========================================================================
		!	Return
		=========================================================================
		-->
		<xsl:value-of select="$_documentFullPath"/>
	</xsl:template>
	<!--
	
	================================================================================================================================
	!
	!	TEMPLATE 'getTypographicSign'
	!_______________________________________________________________________________________________________________________________
	!
	!	Returns the variant of a typographic sign in a specific language.
	!
	================================================================================================================================
	-->
	<xsl:template name="getTypographicSign">
		<!--======================================================================
		 !	Parameters
		 =========================================================================-->
		<!-- The name of the typographic sign to return -->
		<xsl:param name="SignName"/>
		<!-- The IETF code of the target language. This language must have an entry
			 in the language catalog. -->
		<xsl:param name="Language"/>
		<!--======================================================================
		 !	Retrieve language document
		 =========================================================================-->
		<xsl:variable name="_document">
			<xsl:call-template name="getLanguageDocument">
				<xsl:with-param name="Language" select="$Language"/>
			</xsl:call-template>
		</xsl:variable>
		<!--
		=========================================================================
		!	Typographic sign extraction
		=========================================================================
		-->
		<xsl:variable name="_typographicSign">
			<xsl:for-each select="document($_document)/umsb:language/umsb:typography/umsb:typographicSign">
				<xsl:if test="lower-case(@id) = lower-case($SignName)">
					<!-- Insert non-breakable space if needed -->
					<xsl:if test="@spacing = 'before' or @spacing = 'both'">
						<xsl:value-of select="$config.constants.nonBreakableSpace"/>
					</xsl:if>
					<!-- Insert typographic sign -->
					<xsl:value-of select="text()"/>
					<!-- Insert non-breakable space if needed -->
					<xsl:if test="@spacing = 'after' or @spacing = 'both'">
						<xsl:value-of select="$config.constants.nonBreakableSpace"/>
					</xsl:if>
				</xsl:if>
			</xsl:for-each>
		</xsl:variable>
		<xsl:if test="normalize-space($_typographicSign) = ''">
			<xsl:message terminate="yes" select="concat('Typographic sign variant ', $SignName, ' not found for language ', $Language)"/>
		</xsl:if>
		<!--
		=========================================================================
		!	Return
		=========================================================================
		 -->
		<xsl:value-of select="$_typographicSign"/>
	</xsl:template>
	<!--
	
	================================================================================================================================
	!
	!	TEMPLATE 'getTypographicSign'
	!_______________________________________________________________________________________________________________________________
	!
	!	Returns the variant of an idiom in a specific language. This template needs an access to a language catalog.
	!
	================================================================================================================================
	-->
	<xsl:template name="getIdiom">
		<!--
		=========================================================================
		!	Parameters
		=========================================================================
		-->
		<!-- The name of the idiom to return -->
		<xsl:param name="Idiom"/>
		<!-- The IETF code of the target language. This language must have an entry in the language catalog. -->
		<xsl:param name="Language"/>
		<!--
		=========================================================================
		!	Retrieve language document
		=========================================================================
		-->
		<xsl:variable name="_document">
			<xsl:call-template name="getLanguageDocument">
				<xsl:with-param name="Language" select="$Language"/>
			</xsl:call-template>
		</xsl:variable>
		<!--
		=========================================================================
		!	Idiom extraction
		=========================================================================
		-->
		<xsl:variable name="_idiomValue">
			<xsl:for-each select="document($_document)/umsb:language/umsb:idioms/umsb:idiom">
				<xsl:if test="lower-case(@id) = lower-case($Idiom)">
					<!-- Insert idiom -->
					<xsl:value-of select="text()"/>
				</xsl:if>
			</xsl:for-each>
		</xsl:variable>
		<xsl:if test="normalize-space($_idiomValue) = ''">
			<xsl:message terminate="yes" select="concat('Idiom variant ', $Idiom, ' not found for language ', $Language)"/>
		</xsl:if>
		<!--======================================================================
		 ! Output
		 =========================================================================-->
		<xsl:value-of select="$_idiomValue"/>
	</xsl:template>
</xsl:stylesheet>