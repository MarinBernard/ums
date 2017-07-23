<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="3.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:umsc="http://schemas.olivarim.com/ums/1.0/common"
	xmlns:umsm="http://schemas.olivarim.com/ums/1.0/music">
	<xsl:template name="selectVariantLanguage">
		<!--======================================================================
		 !	Parameters
		 =========================================================================-->
		<xsl:param name="PreferedLanguageVariant"/>
		<xsl:param name="FallbackLanguageVariant"/>
		<xsl:param name="DefaultVariant"/>
		<xsl:param name="OriginalVariant"/>
		<!--======================================================================
		 !	Variant selection
		 =========================================================================-->
		<xsl:choose>
			<!-- If a variant was found in the prefered language, let's return it -->
			<xsl:when test="normalize-space($PreferedLanguageVariant) != ''">
				<xsl:value-of select="$PreferedLanguageVariant"/>
			</xsl:when>
			<!-- Else, let's try to find a suitable fallback -->
			<xsl:otherwise>
				<xsl:choose>
					<!-- If a variant exists in the fallback language, use it -->
					<xsl:when test="normalize-space($FallbackLanguageVariant) != ''">
						<xsl:value-of select="$FallbackLanguageVariant"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:choose>
							<!-- Else, we may end up returning a default variant -->
							<xsl:when test="normalize-space($DefaultVariant) != ''">
								<xsl:if test="$config.variants.useDefaultVariants = true()">
									<xsl:value-of select="$DefaultVariant"/>
								</xsl:if>
							</xsl:when>
							<!-- Or an original variant as a last resort -->
							<xsl:otherwise>
								<xsl:if test="$config.variants.useOriginalVariants = true()">
									<xsl:value-of select="$OriginalVariant"/>
								</xsl:if>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>