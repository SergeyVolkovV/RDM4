<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:sf="http://www.ataccama.com/xslt/functions"
	xmlns:fn="http://www.w3.org/2005/xpath-functions"
	exclude-result-prefixes="sf fn">
	<xsl:output method="xml" encoding="UTF-8" indent="yes"/>
	<xsl:param name="logicalModel" select="document('param:logicalModel')/*"/>
	<xsl:param name="relationship" select="document('param:relationship')/*"/>
	
<xsl:template match="/*">

<ccColumnDataTypes parent="{$logicalModel/domains/domain[@name = $logicalModel/tables/table[@name=$relationship/@parentTable]/columns/column[@name=current()/@parentColumn]/@domain]/dqcType/@dqcType}" child="{$logicalModel/domains/domain[@name = $logicalModel/tables/table[@name=$relationship/@childTable]/columns/column[@name=current()/@childColumn]/@domain]/dqcType/@dqcType}"/>

</xsl:template>

</xsl:stylesheet>