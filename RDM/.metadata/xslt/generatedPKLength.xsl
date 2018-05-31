<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:sf="http://www.ataccama.com/xslt/functions"
 xmlns:exsl="http://exslt.org/common" extension-element-prefixes="exsl sf">
 <xsl:output method="xml" encoding="UTF-8" indent="yes"/>

<xsl:param name="rdmAppVariablesRef" select="document('param:rdmAppVariablesRef')"/>
<xsl:param name="rdmSetDatabaseRef" select="document('param:rdmSetDatabaseRef')"/>

 <xsl:template match="/">
 	<gpkLength>
 		<xsl:attribute name="gpkLength">
        	<xsl:value-of select="(setDatabase/@columnLength)-string-length($rdmAppVariablesRef/appVariables/@generatedPrimaryKeyName)-1"/>
    	</xsl:attribute>
   </gpkLength>
 </xsl:template>
 </xsl:stylesheet>

