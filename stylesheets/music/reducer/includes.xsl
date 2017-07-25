<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="3.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:umsa="http://schemas.olivarim.com/ums/1.0/audio"
	xmlns:umsb="http://schemas.olivarim.com/ums/1.0/base"
	xmlns:umsm="http://schemas.olivarim.com/ums/1.0/music">
	<!-- Common helper templates -->
	<xsl:include href="../common/helpers/Paths.xsl"/>
	<xsl:include href="../common/helpers/Configuration.xsl"/>
	<!-- Helper templates -->
	<xsl:include href="helpers/ConfigurationMappings.xsl"/>
	<!-- Base templates -->
	<xsl:include href="base/abstract/Event.xsl"/>
	<xsl:include href="base/abstract/Item.xsl"/>
	<xsl:include href="base/abstract/Link.xsl"/>
	<xsl:include href="base/abstract/Person.xsl"/>
	<xsl:include href="base/helpers/SelectBestVariant.xsl"/>
	<xsl:include href="base/lists/LabelVariants.xsl"/>
	<xsl:include href="base/lists/Links.xsl"/>
	<xsl:include href="base/lists/NameVariants.xsl"/>
	<xsl:include href="base/renderers/Birth.xsl"/>
	<xsl:include href="base/renderers/City.xsl"/>
	<xsl:include href="base/renderers/Country.xsl"/>
	<xsl:include href="base/renderers/CountryState.xsl"/>
	<xsl:include href="base/renderers/Death.xsl"/>
	<xsl:include href="base/renderers/LabelVariant.xsl"/>
	<xsl:include href="base/renderers/NameVariant.xsl"/>
	<xsl:include href="base/renderers/Wikipedia.xsl"/>
	<!-- Music templates -->
	<xsl:include href="music/renderers/Composer.xsl"/>
	<xsl:include href="music/renderers/Conductor.xsl"/>
	<xsl:include href="music/renderers/Instrument.xsl"/>
	<xsl:include href="music/renderers/Key.xsl"/>
</xsl:stylesheet>