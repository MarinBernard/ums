<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:ums="http://schemas.olivarim.com/ums/1.0/music"
    xpath-default-namespace="ums">
    
    <xsl:output method="xml" indent="yes"/>
    <xsl:variable name="filter" select="document('rules.xml')" />
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="ums:partGroups/ums:partGroup">
        <xsl:variable name="partGroup_id" select="@id"/>
        <xsl:if test="boolean($filter/ums:filter//ums:partGroup[@id = $partGroup_id])">
            <xsl:copy>
                <xsl:apply-templates select="@*|node()"/>
            </xsl:copy>
        </xsl:if>
    </xsl:template>
</xsl:stylesheet>