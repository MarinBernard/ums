<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="3.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:umsc="http://schemas.olivarim.com/ums/1.0/common"
	xmlns:umsm="http://schemas.olivarim.com/ums/1.0/music">
	<xsl:template name="LT_Files">
		<!--======================================================================
		 !	Processing file list
		 =========================================================================-->
		<xsl:for-each select="umsm:file">
			<xsl:variable name="_targetAlbum" select="@album"/>
			<xsl:variable name="_targetMediumNumber" select="@medium"/>
			<xsl:variable name="_targetMediumSide" select="@side"/>
			<xsl:variable name="_targetTrackNumber" select="@track"/>
			<xsl:variable name="_audioFileFullName" select="@path"/>
			<!-- Error checking for bad references -->
			<xsl:if test="not(ancestor::*/umsm:albums/umsm:album[@uid = $_targetAlbum])">
				<xsl:message terminate="yes" select="concat('ERROR: Invalid reference to album ', $_targetAlbum, ' !')"/>
			</xsl:if>
			<!--======================================================================
			 !	Building file path and file names
			 =========================================================================-->
			<!-- Extracting file path -->
			<xsl:variable name="_audioFilePath">
				<xsl:call-template name="getFilePath">
					<xsl:with-param name="Path" select="$_audioFileFullName"/>
				</xsl:call-template>
			</xsl:variable>
			<!-- Extracting file radical -->
			<xsl:variable name="_audioFileRadical">
				<xsl:call-template name="getFileRadical">
					<xsl:with-param name="Path" select="$_audioFileFullName"/>
				</xsl:call-template>
			</xsl:variable>
			<!-- Building tag file full name -->
			<xsl:variable name="_tagFileFullName">
				<xsl:value-of select="normalize-space($OutputDirectory)"/>
				<xsl:value-of select="'/'"/>
				<xsl:value-of select="$_audioFileRadical"/>
				<xsl:value-of select="$config.fileExtensions.tagFile"/>
			</xsl:variable>
			<xsl:call-template name="showDebugMessage">
				<xsl:with-param name="Template" select="'RT_Files'"/>
				<xsl:with-param name="Message" select="concat('Tag file full name is: ', $_tagFileFullName)"/>
			</xsl:call-template>
			<!-- Building lyrics file full name -->
			<xsl:variable name="_lyricsFileFullName">
				<xsl:value-of select="normalize-space($OutputDirectory)"/>
				<xsl:value-of select="'/'"/>
				<xsl:value-of select="$_audioFileRadical"/>
				<xsl:value-of select="$config.fileExtensions.lyricsFile"/>
			</xsl:variable>
			<xsl:call-template name="showDebugMessage">
				<xsl:with-param name="Template" select="'RT_Files'"/>
				<xsl:with-param name="Message" select="concat('Lyrics file full name is: ', $_lyricsFileFullName)"/>
			</xsl:call-template>
			<!--======================================================================
			 !	Generation Vorbis Comments and lyrics
			 =========================================================================-->
			<xsl:for-each select="ancestor::*/umsm:albums/umsm:album[@uid = $_targetAlbum]">
				<xsl:choose>
					<!-- Dump mode: dump to stdout if no OutputDirectory was specified -->
					<xsl:when test="normalize-space($OutputDirectory) = ''">
						<!-- Generating Vorbis Comments or Lyrics-->
						<xsl:call-template name="showStdoutFileDelimiter">
							<xsl:with-param name="File" select="$_audioFileFullName"/>
							<xsl:with-param name="Mode" select="$OutputMode"/>
						</xsl:call-template>
						<xsl:call-template name="RT_Album">
							<xsl:with-param name="TargetMediumNumber" select="$_targetMediumNumber"/>
							<xsl:with-param name="TargetMediumSide" select="$_targetMediumSide"/>
							<xsl:with-param name="TargetTrackNumber" select="$_targetTrackNumber"/>
							<xsl:with-param name="Mode" select="$OutputMode"/>
						</xsl:call-template>
					</xsl:when>
					<!-- Standard mode: output to files -->
					<xsl:otherwise>
						<xsl:choose>
							<!-- Generating Vorbis Comments -->
							<xsl:when test="normalize-space(upper-case($OutputMode)) = 'VORBIS'">
								<xsl:result-document href="{$_tagFileFullName}" method="text" indent="no">
									<xsl:call-template name="RT_Album">
										<xsl:with-param name="TargetMediumNumber" select="$_targetMediumNumber"/>
										<xsl:with-param name="TargetMediumSide" select="$_targetMediumSide"/>
										<xsl:with-param name="TargetTrackNumber" select="$_targetTrackNumber"/>
										<xsl:with-param name="Mode" select="'VORBIS'"/>
									</xsl:call-template>
								</xsl:result-document>
							</xsl:when>
							<!-- Generating lyrics -->
							<xsl:when test="normalize-space(upper-case($OutputMode)) = 'RAWLYRICS'">
								<xsl:result-document href="{$_lyricsFileFullName}" method="text" indent="no">
									<xsl:call-template name="RT_Album">
										<xsl:with-param name="TargetMediumNumber" select="$_targetMediumNumber"/>
										<xsl:with-param name="TargetMediumSide" select="$_targetMediumSide"/>
										<xsl:with-param name="TargetTrackNumber" select="$_targetTrackNumber"/>
										<xsl:with-param name="Mode" select="'RAWLYRICS'"/>
									</xsl:call-template>
								</xsl:result-document>
							</xsl:when>
						</xsl:choose>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each><!-- End of VC / Lyrics generation -->
		</xsl:for-each><!-- End of processing for the current file -->
	</xsl:template>
</xsl:stylesheet>