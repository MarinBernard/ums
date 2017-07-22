<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="3.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:umsc="http://schemas.olivarim.com/ums/1.0/common"
	xmlns:umsm="http://schemas.olivarim.com/ums/1.0/music">
	<xsl:template name="LT_Media">
		<!--======================================================================
		 !	Template parameters
		 =========================================================================-->
		<!-- The number of the parent medium of the track for which metadata should
			 be generated. -->
		<xsl:param name="TargetMediumNumber"/>
		<!-- The side of the parent medium of the track for which metadata be
			 generated. -->
		<xsl:param name="TargetMediumSide"/>
		<!-- The number of the track for which metadata be generated. -->
		<xsl:param name="TargetTrackNumber"/>
		<!-- Template output mode. Possible value are:
			 - 'VORBIS' to generate Vorbis Comments
			 - 'RAWLYRICS' to generate lyrics as raw text. -->
		<xsl:param name="Mode" select="'VORBIS'"/>
		<!-- Title of the parent album -->
		<xsl:param name="ParentAlbumTitle"/>
		<!--======================================================================
		 !	Common to all modes: getting media count
		 =========================================================================-->
		<xsl:variable name="_totalMedia" select="count(umsm:medium)"/>		
		<!--======================================================================
		 !	Calling sub template for the targeted media
		 =========================================================================-->
		<xsl:for-each select="umsm:medium">
			<!-- Test medium number -->
			<xsl:if test="@number = $TargetMediumNumber">
				<!-- Test medium side, if present -->
				<xsl:if test="not(@side) or @side = $TargetMediumSide">
					<xsl:call-template name="RT_Medium">
						<xsl:with-param name="TargetTrackNumber" select="$TargetTrackNumber"/>
						<xsl:with-param name="Mode" select="$Mode"/>
						<xsl:with-param name="ParentAlbumTitle" select="$ParentAlbumTitle"/>
						<xsl:with-param name="TotalMedia" select="$_totalMedia"/>
					</xsl:call-template>
				</xsl:if>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>
</xsl:stylesheet>