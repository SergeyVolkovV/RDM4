<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="xml" encoding="UTF-8" indent="yes"/>

<xsl:template match="/*">
<login-config>
    <domains>
     	<domain label="" value=""/>
    	<xsl:for-each select="security/LDAPRepositories/LDAPRepository/LDAPDomain">
        	<domain label="{@label}" value="{@value}">
        		<xsl:if test="@defaultOption='true'">
		 			<xsl:attribute name="defaultOption">
		        		<xsl:text>true</xsl:text>
		       		</xsl:attribute>        			
        		</xsl:if>
        	</domain>
        </xsl:for-each>
    </domains>
</login-config>

</xsl:template>

</xsl:stylesheet>