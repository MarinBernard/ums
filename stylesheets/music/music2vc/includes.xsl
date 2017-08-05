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
	<xsl:include href="helpers/Debug.xsl"/>
	<xsl:include href="helpers/Delimiters.xsl"/>
	<xsl:include href="helpers/Language.xsl"/>
	<xsl:include href="helpers/Variants.xsl"/>
	<xsl:include href="helpers/VorbisComment.xsl"/>
	<!-- Binding templates -->
	<xsl:include href="bindings/AudioBinding.xsl"/>
	<!-- Raw value getters -->
	<xsl:include href="getter/Label.xsl"/>
	<xsl:include href="getter/Name.xsl"/>
	<xsl:include href="getter/Title.xsl"/>
	<!-- List templates -->
	<xsl:include href="list/CatalogIds.xsl"/>
	<xsl:include href="list/Characters.xsl"/>
	<xsl:include href="list/Composers.xsl"/>
	<xsl:include href="list/Conductors.xsl"/>
	<xsl:include href="list/Forms.xsl"/>
	<xsl:include href="list/Instruments.xsl"/>
	<xsl:include href="list/LabelVariants.xsl"/>
	<xsl:include href="list/Media.xsl"/>
	<xsl:include href="list/Movements.xsl"/>
	<xsl:include href="list/NameVariants.xsl"/>
	<xsl:include href="list/Performers.xsl"/>
	<xsl:include href="list/Sections.xsl"/>
	<xsl:include href="list/Tracks.xsl"/>
	<xsl:include href="list/TitleVariants.xsl"/>
	<!-- Rendering templates -->
	<xsl:include href="renderer/Album.xsl"/>
	<xsl:include href="renderer/CatalogId.xsl"/>
	<xsl:include href="renderer/Character.xsl"/>
	<xsl:include href="renderer/Composer.xsl"/>
	<xsl:include href="renderer/Conductor.xsl"/>
	<xsl:include href="renderer/Ensemble.xsl"/>
	<xsl:include href="renderer/Key.xsl"/>
	<xsl:include href="renderer/Form.xsl"/>
	<xsl:include href="renderer/Instrument.xsl"/>
	<xsl:include href="renderer/Instrumentalist.xsl"/>
	<xsl:include href="renderer/LabelVariant.xsl"/>
	<xsl:include href="renderer/Lyrics.xsl"/>
	<xsl:include href="renderer/Medium.xsl"/>
	<xsl:include href="renderer/Movement.xsl"/>
	<xsl:include href="renderer/NameVariant.xsl"/>
	<xsl:include href="renderer/Performance.xsl"/>
	<xsl:include href="renderer/Performer.xsl"/>
	<xsl:include href="renderer/Section.xsl"/>
	<xsl:include href="renderer/Style.xsl"/>
	<xsl:include href="renderer/TitleVariant.xsl"/>
	<xsl:include href="renderer/Track.xsl"/>
	<xsl:include href="renderer/Work.xsl"/>
</xsl:stylesheet>