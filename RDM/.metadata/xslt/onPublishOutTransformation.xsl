<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:ns1="http://www.example.com/ws">
<xsl:output method="xml" encoding="UTF-8" indent="yes"/>

    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>   
        </xsl:copy>
    </xsl:template>

	<xsl:template match="ns1:values">
		
		<xsl:for-each select="ns1:new/*">
			<xsl:element name="ns1:new_{local-name()}"><xsl:value-of select="."/></xsl:element>
		</xsl:for-each>	
		
		<xsl:for-each select="ns1:old/*">
			<xsl:element name="ns1:old_{local-name()}"><xsl:value-of select="."/></xsl:element>
		</xsl:for-each>				
	</xsl:template>

</xsl:stylesheet>	