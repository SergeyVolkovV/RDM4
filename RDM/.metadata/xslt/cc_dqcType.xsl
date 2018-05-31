<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:sf="http://www.ataccama.com/xslt/functions"
	xmlns:fn="http://www.w3.org/2005/xpath-functions"
	exclude-result-prefixes="sf fn">
	<xsl:output method="xml" encoding="UTF-8" indent="yes"/>
	
<xsl:template match="/*">

<dqcType dqcType="{if(@type='MNREFERENCES') then 'STRING' else @type}"/>

</xsl:template>

</xsl:stylesheet>