<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="3.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:umsc="http://schemas.olivarim.com/ums/1.0/common"
	xmlns:umsm="http://schemas.olivarim.com/ums/1.0/music">
	<xsl:template name="RT_Track">
		<!--======================================================================
		 !	Template parameters
		 =========================================================================-->
		<!-- Common Vorbis Comments from the parent medium -->
		<xsl:param name="CommonVC_Medium"/>
		<!-- Title of the parent album -->
		<xsl:param name="ParentAlbumTitle"/>	
		<!-- Total number of tracks on the medium -->
		<xsl:param name="TotalTracks"/>
		<!-- Output mode of the template. Possible values are:
			 - 'VORBIS' to output all Vorbis Comments for the current track.
			 - 'RAWLYRICS' to output all lyrics for the current track. -->
		<xsl:param name="Mode" select="'VORBIS'"/>		
		<!--======================================================================
		 !	Internal variables
		 =========================================================================-->
		<!-- Track number -->
		<xsl:variable name="_number" select="@number"/>
		<!-- Linked performance -->
		<xsl:variable name="_performance" select="@performance"/>
		<!-- Part id expression pointing to a part of the work -->
		<xsl:variable name="_section" select="@section"/>
		<!--======================================================================
		 !	Retrieving target performance
		 =========================================================================-->		
		<xsl:variable name="_targetPerformance" select="ancestor::umsm:album/umsm:performances/umsm:performance[@uid = $_performance]"/>
		<xsl:if test="not($_targetPerformance)">
			<xsl:message terminate="yes" select="concat('Performance with id ', $_performance, ' was not found.')"/>
		</xsl:if>
		<!--======================================================================
		 !	Building track title
		 =========================================================================-->
		<xsl:call-template name="showDebugMessage">
			<xsl:with-param name="Template" select="'RT_Track'"/>
			<xsl:with-param name="Message" select="'Beginning to build track title.'"/>
		</xsl:call-template>
		<xsl:variable name="_trackTitle">
			<xsl:for-each select="$_targetPerformance">
				<xsl:call-template name="RT_Performance">
					<xsl:with-param name="TargetSection" select="$_section"/>
					<xsl:with-param name="Mode" select="'RAWTRACKTITLE'"/>
				</xsl:call-template>
			</xsl:for-each>
		</xsl:variable>
		<xsl:call-template name="showDebugMessage">
			<xsl:with-param name="Template" select="'RT_Track'"/>
			<xsl:with-param name="Message" select="concat('Finished building track title. Result is: ', $_trackTitle)"/>
		</xsl:call-template>
		<!--======================================================================
		 !	Building lyrics
		 =========================================================================-->
		<xsl:call-template name="showDebugMessage">
			<xsl:with-param name="Template" select="'RT_Track'"/>
			<xsl:with-param name="Message" select="'Beginning to build track lyrics.'"/>
		</xsl:call-template>
		<xsl:variable name="_lyrics">
			<xsl:for-each select="$_targetPerformance">
				<xsl:call-template name="RT_Performance">
					<xsl:with-param name="TargetSection" select="$_section"/>
					<xsl:with-param name="Mode" select="'RAWLYRICS'"/>
				</xsl:call-template>
			</xsl:for-each>
		</xsl:variable>
		<xsl:call-template name="showDebugMessage">
			<xsl:with-param name="Template" select="'RT_Track'"/>
			<xsl:with-param name="Message" select="'Finished building track lyrics.'"/>
		</xsl:call-template>
		<!--======================================================================
		 !	Building (dynamic) album title
		 =========================================================================-->
		<xsl:call-template name="showDebugMessage">
			<xsl:with-param name="Template" select="'RT_Track'"/>
			<xsl:with-param name="Message" select="'Beginning to build album title.'"/>
		</xsl:call-template>
		<xsl:variable name="_albumTitle">
			<xsl:choose>
				<!-- If dynamic album titles are disabled, we just use the title of the current album -->
				<xsl:when test="$config.vorbis.dynamicAlbums.enabled = false()">
					<xsl:value-of select="$ParentAlbumTitle"/>
				</xsl:when>
				<!-- If dynamic album titles are enabled, we begin to build album title -->
				<xsl:when test="$config.vorbis.dynamicAlbums.enabled = true()">
					<!-- Getting composer list -->
					<xsl:variable name="_composerList">
						<xsl:if test="$config.vorbis.dynamicAlbums.composerList.enabled = true()">
							<xsl:value-of select="$config.vorbis.dynamicAlbums.composerList.openingChar"/>
							<xsl:for-each select="$_targetPerformance">
								<xsl:call-template name="RT_Performance">
									<xsl:with-param name="TargetSection" select="$_section"/>
									<xsl:with-param name="Mode" select="'RAWCOMPOSERLIST'"/>
								</xsl:call-template>
							</xsl:for-each>
							<xsl:value-of select="$config.vorbis.dynamicAlbums.composerList.closingChar"/>
							<xsl:value-of select="$config.constants.nonBreakableSpace"/>
						</xsl:if>
					</xsl:variable>
					<!-- Getting raw work title -->
					<xsl:variable name="_workTitle">
						<xsl:for-each select="$_targetPerformance">
							<xsl:call-template name="RT_Performance">
								<xsl:with-param name="TargetSection" select="$_section"/>
								<xsl:with-param name="Mode" select="'RAWWORKTITLE'"/>
							</xsl:call-template>
						</xsl:for-each>
						<xsl:value-of select="$config.constants.nonBreakableSpace"/>
					</xsl:variable>
					<!-- Getting the list of performers -->
					<xsl:variable name="_performerList">
						<xsl:if test="$config.vorbis.dynamicAlbums.performerList.enabled = true()">
							<xsl:value-of select="$config.vorbis.dynamicAlbums.performerList.openingChar"/>
							<xsl:for-each select="$_targetPerformance">
								<xsl:call-template name="RT_Performance">
									<xsl:with-param name="TargetSection" select="$_section"/>
									<xsl:with-param name="Mode" select="'RAWPERFORMERLIST'"/>
								</xsl:call-template>
							</xsl:for-each>
							<xsl:value-of select="$config.vorbis.dynamicAlbums.performerList.closingChar"/>
							<xsl:value-of select="$config.constants.nonBreakableSpace"/>
						</xsl:if>
					</xsl:variable>
					<!-- Composer list -->
					<xsl:value-of select="$_composerList"/>
					<!-- Work title -->
					<xsl:value-of select="$_workTitle"/>
					<!-- Performer title -->
					<xsl:value-of select="$_performerList"/>
				</xsl:when>
			</xsl:choose>
		</xsl:variable>
		<xsl:call-template name="showDebugMessage">
			<xsl:with-param name="Template" select="'RT_Track'"/>
			<xsl:with-param name="Message" select="concat('Finished building album title. Result is: ', $_albumTitle)"/>
		</xsl:call-template>		
		<!--======================================================================
		 !	Generating Vorbis Comments
		 =========================================================================-->
		<!-- VC: Track number -->
		<xsl:variable name="_VC_TrackNumbers">
			<!-- VC: Track number -->
			<xsl:call-template name="createVorbisComment">
				<xsl:with-param name="Label" select="$config.vorbis.labels.Track_Number"/>
				<xsl:with-param name="Value" select="$_number"/>
			</xsl:call-template>
			<!-- VC: Total tracks -->
			<xsl:call-template name="createVorbisComment">
				<xsl:with-param name="Label" select="$config.vorbis.labels.Track_Total"/>
				<xsl:with-param name="Value" select="$TotalTracks"/>
			</xsl:call-template>
		</xsl:variable>
		<!-- VC: Track title -->
		<xsl:variable name="_VC_TrackTitle">
			<xsl:call-template name="createVorbisComment">
				<xsl:with-param name="Label" select="$config.vorbis.labels.Track_Title"/>
				<xsl:with-param name="Value" select="$_trackTitle"/>
			</xsl:call-template>
		</xsl:variable>
		<!-- VC: Album title -->
		<xsl:variable name="_VC_AlbumTitle">
			<xsl:call-template name="createVorbisComment">
				<xsl:with-param name="Label" select="$config.vorbis.labels.Album_Title_Full"/>
				<xsl:with-param name="Value" select="$_albumTitle"/>
			</xsl:call-template>
		</xsl:variable>
		<!-- VC: Original album title -->
		<xsl:variable name="_VC_OriginalAlbumTitle">
			<!-- Only when dynamic album titles are enabled -->
			<xsl:if test="$config.vorbis.dynamicAlbums.enabled = true()">
				<xsl:call-template name="createVorbisComment">
					<xsl:with-param name="Label" select="$config.vorbis.labels.OriginalAlbum_Title_Full"/>
					<xsl:with-param name="Value" select="$ParentAlbumTitle"/>
				</xsl:call-template>
			</xsl:if>
		</xsl:variable>
		<!--VC: Performance call chain -->
		<xsl:call-template name="showDebugMessage">
			<xsl:with-param name="Template" select="'RT_Track'"/>
			<xsl:with-param name="Message" select="'Beginning of the performance call chain.'"/>
		</xsl:call-template>
		<xsl:variable name="_VC_Performance">
			<xsl:for-each select="$_targetPerformance">
				<xsl:call-template name="RT_Performance">
					<xsl:with-param name="TargetSection" select="$_section"/>
				</xsl:call-template>
			</xsl:for-each>
		</xsl:variable>
		<xsl:call-template name="showDebugMessage">
			<xsl:with-param name="Template" select="'RT_Track'"/>
			<xsl:with-param name="Message" select="'End of the performance call chain.'"/>
		</xsl:call-template>
		<!--======================================================================
		 !	Output
		 =========================================================================-->
		<xsl:choose>
			<xsl:when test="upper-case($Mode) = 'VORBIS'">
				<!--VC: Parent medium common VC -->
				<xsl:value-of select="$CommonVC_Medium"/>
				<!-- VC: Album title -->
				<xsl:value-of select="$_VC_AlbumTitle"/>
				<!-- VC: Original album title -->
				<xsl:value-of select="$_VC_OriginalAlbumTitle"/>
				<!-- VC: Track number -->
				<xsl:value-of select="$_VC_TrackNumbers"/>
				<!-- VC: Track title -->
				<xsl:value-of select="$_VC_TrackTitle"/>
				<!-- VC: Performance data -->
				<xsl:value-of select="$_VC_Performance"/>
			</xsl:when>
			<xsl:when test="upper-case($Mode) = 'RAWLYRICS'">
				<xsl:value-of select="$_lyrics"/>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>