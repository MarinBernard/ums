<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="3.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:umsc="http://schemas.olivarim.com/ums/1.0/common"
	xmlns:umsm="http://schemas.olivarim.com/ums/1.0/music">
	<!--======================================================================
	 !	Main template
	 =========================================================================-->
	<xsl:template name="RT_Lyrics">
		<!--======================================================================
		 !	Template parameters
		 =========================================================================-->
		<!-- VC label for lyrics entries -->
		<xsl:param name="Label"/>
		<!-- Templating mode. Possible values are:
			- 'RAWTEXT' to output lyrics in raw text mode -->
		<xsl:param name="Mode" select="'RAWTEXT'"/>
		<!--======================================================================
		 !	Common to all mode: generate lyrics
		 =========================================================================-->
		<xsl:variable name="_lyrics">
			<xsl:for-each select="umsm:stanza">
				<!-- Process singer sub elements -->
				<xsl:for-each select="umsm:singer">
					<!-- Retrieve and output singer names and verse content -->
					<xsl:call-template name="RT_Singer"/>
				</xsl:for-each>
				<!-- Blank line between each stanza-->
				<xsl:value-of select="$config.constants.newLineChar"/>				
			</xsl:for-each>
		</xsl:variable>
		<!--======================================================================
		 !	Output
		 =========================================================================-->
		<xsl:choose>
			<xsl:when test="upper-case($Mode) = 'RAWTEXT'">
				<xsl:value-of select="$_lyrics"/>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<!--======================================================================
	 !	Sub templates only used in lyrics context
	 =========================================================================-->
	<!-- Returns the character or instrument name of a singer in a stanza context -->
	<xsl:template name="RT_Singer">
		<xsl:choose>
			<xsl:when test="@character">
				<xsl:variable name="_targetCharacter" select="@character"/>
				<!-- Get localized character name-->
				<xsl:variable name="_characterName">
					<xsl:for-each select="ancestor::umsm:movement/umsc:characters/umsc:character[@uid = $_targetCharacter]">
						<xsl:call-template name="RT_Character">
							<xsl:with-param name="Mode" select="'RAWFULLNAME'"/>
						</xsl:call-template>
					</xsl:for-each>
				</xsl:variable>
				<!-- Get upper-cased character name or fallback -->
				<xsl:variable name="_characterNameUpper">
					<xsl:choose>
						<!-- Output localized character name -->
						<xsl:when test="normalize-space($_characterName) != ''">
							<xsl:value-of select="upper-case($_characterName)"/>
						</xsl:when>
						<!-- Reference to an unknown character: use raw name -->
						<xsl:otherwise>
							<xsl:message select="concat('WARNING: The lyrics include a reference to a character with id ', @character, ' who does not exist. Using raw name instead.')"/>
							<xsl:value-of select="upper-case(@character)"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<!-- Output character name -->
				<xsl:value-of select="$_characterNameUpper"/>
			</xsl:when>
			<xsl:when test="@instrument">
				<xsl:variable name="_targetInstrument" select="@instrument"/>
				<!-- Get localized instrument name-->
				<xsl:variable name="_instrumentName">
					<xsl:for-each select="ancestor::umsm:movement/umsm:instruments/umsm:instrument[@uid = $_targetInstrument]">
						<xsl:call-template name="RT_Instrument">
							<xsl:with-param name="Mode" select="'RAWFULLLABEL'"/>
						</xsl:call-template>
					</xsl:for-each>
				</xsl:variable>
				<!-- Get upper-cased instrument name or fallback -->
				<xsl:variable name="_instrumentNameUpper">
					<xsl:choose>
						<!-- Output localized character name -->
						<xsl:when test="normalize-space($_instrumentName) != ''">
							<xsl:value-of select="upper-case($_instrumentName)"/>
						</xsl:when>
						<!-- Reference to an unknown instrument: use raw name -->
						<xsl:otherwise>
							<xsl:message select="concat('WARNING: The lyrics include a reference to an instrument with id ', @instrument, ' which does not exist. Using raw name instead.')"/>
							<xsl:value-of select="upper-case(@instrument)"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<!-- Output instrument name -->
				<xsl:value-of select="$_instrumentNameUpper"/>
			</xsl:when>
		</xsl:choose>
		<!-- Handle subsequent singers -->
		<xsl:for-each select="umsm:singer">
			<xsl:value-of select="', '"/>
			<xsl:call-template name="RT_Singer"/>			
		</xsl:for-each>
		<!-- Handle verses -->
		<xsl:for-each select="umsm:verse">
			<xsl:value-of select="$config.constants.newLineChar"/>
			<xsl:value-of select="text()"/>
		</xsl:for-each>
		<xsl:value-of select="$config.constants.newLineChar"/>
	</xsl:template>
</xsl:stylesheet>