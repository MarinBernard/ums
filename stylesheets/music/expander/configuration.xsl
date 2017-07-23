<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="3.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:umsc="http://schemas.olivarim.com/ums/1.0/common"
	xmlns:umsm="http://schemas.olivarim.com/ums/1.0/music">
	<xsl:output method="xml" indent="yes"/>
	<!-- Extension of UMS files -->
	<xsl:variable name="CFG_UMSFileExtension" select="'.xml'"/>
	<!-- Paths to catalogs -->	
	<xsl:variable name="CAT_Root" 	select="'file:///C:/Users/marin/Code/ums/catalogs'"/>
	<xsl:variable name="CAT_Common" select="concat($CAT_Root, '/common')"/>
	<xsl:variable name="CAT_Music" 	select="concat($CAT_Root, '/music')"/>
	<xsl:variable name="CAT_Common_Cities" 				select="concat($CAT_Common, '/', 'cities')"/>
	<xsl:variable name="CAT_Common_Countries" 			select="concat($CAT_Common, '/', 'cities')"/>
	<xsl:variable name="CAT_Common_CountryStates" 		select="concat($CAT_Common, '/', 'cities')"/>
	<xsl:variable name="CAT_Music_Catalogs" 			select="concat($CAT_Music, '/', 'catalogs')"/>
	<xsl:variable name="CAT_Music_Composers" 			select="concat($CAT_Music, '/', 'composers')"/>
	<xsl:variable name="CAT_Music_Conductors" 			select="concat($CAT_Music, '/', 'conductors')"/>
	<xsl:variable name="CAT_Music_Ensembles" 			select="concat($CAT_Music, '/', 'ensembles')"/>
	<xsl:variable name="CAT_Music_Forms" 				select="concat($CAT_Music, '/', 'forms')"/>
	<xsl:variable name="CAT_Music_Instrumentalists" 	select="concat($CAT_Music, '/', 'instrumentalists')"/>
	<xsl:variable name="CAT_Music_Instruments" 			select="concat($CAT_Music, '/', 'instruments')"/>
	<xsl:variable name="CAT_Music_Keys" 				select="concat($CAT_Music, '/', 'keys')"/>
	<xsl:variable name="CAT_Music_Labels" 				select="concat($CAT_Music, '/', 'labels')"/>
	<xsl:variable name="CAT_Music_Lyricists"			select="concat($CAT_Music, '/', 'lyricists')"/>
	<xsl:variable name="CAT_Music_Lyrics" 				select="concat($CAT_Music, '/', 'compositions')"/>
	<xsl:variable name="CAT_Music_Movements"			select="concat($CAT_Music, '/', 'compositions')"/>
	<xsl:variable name="CAT_Music_Styles"				select="concat($CAT_Music, '/', 'styles')"/>
	<xsl:variable name="CAT_Music_Venues" 				select="concat($CAT_Music, '/', 'venues')"/>
	<xsl:variable name="CAT_Music_Works" 				select="concat($CAT_Music, '/', 'compositions')"/>
</xsl:stylesheet>