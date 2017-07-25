<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="3.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:umsa="http://schemas.olivarim.com/ums/1.0/audio"
	xmlns:umsb="http://schemas.olivarim.com/ums/1.0/base"
	xmlns:umsm="http://schemas.olivarim.com/ums/1.0/music">
	<!--
	=============================================================================
	!
	!	Helper template for umsb:(name|label|title)Variants base lists
	!____________________________________________________________________________
	!
	!	This template returns the best variant available from four possible ones.
	!	It checks which variants are available, and uses configuration data to
	!	the best one according to preferences. The elected variant is returned
	!	unmodified.
	!	The four possible variants must be passed as parameters at call time.
	!
	=============================================================================
	-->	
	<xsl:template name="BHT_SelectBestVariant">
		<!--
		=============================================================================
		!	Template parameters
		=============================================================================
		-->
		<xsl:param name="PreferedVariant" select="false()"/>
		<xsl:param name="FallbackVariant" select="false()"/>
		<xsl:param name="DefaultVariant" select="false()"/>
		<xsl:param name="OriginalVariant" select="false()"/>
		<!--
		=============================================================================
		!	Building output
		=============================================================================
		-->
		<xsl:variable name="_output">
			<xsl:choose>
				<!-- If a variant was found in the prefered language, let's return it -->
				<xsl:when test="normalize-space($PreferedVariant) != ''">
					<xsl:copy-of select="$PreferedVariant"/>
				</xsl:when>
				<!-- Else, let's try to find a suitable fallback -->
				<xsl:otherwise>
					<xsl:choose>
						<!-- If a variant exists in the fallback language, use it -->
						<xsl:when test="normalize-space($FallbackVariant) != ''">
							<xsl:copy-of select="$FallbackVariant"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:choose>
								<!-- Else, we may end up returning a default variant -->
								<xsl:when test="normalize-space($DefaultVariant) != ''">
									<xsl:if test="$config.ums.variants.useDefaultVariants = true()">
										<xsl:copy-of select="$DefaultVariant"/>
									</xsl:if>
								</xsl:when>
								<!-- Or an original variant as a last resort -->
								<xsl:otherwise>
									<xsl:if test="$config.ums.variants.useOriginalVariants = true()">
										<xsl:copy-of select="$OriginalVariant"/>
									</xsl:if>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<!--
		=============================================================================
		!	Post-processing
		=============================================================================
		-->
		<xsl:copy-of select="$_output"/>
	</xsl:template>
</xsl:stylesheet>