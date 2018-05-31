<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:sf="http://www.ataccama.com/xslt/functions"
 xmlns:exsl="http://exslt.org/common" extension-element-prefixes="exsl sf">
 <xsl:output method="xml" encoding="UTF-8" indent="yes"/>

<xsl:template match="/metadata">
<metadata>
	<xsl:copy-of select="logicalModel"/>
	<xsl:copy-of select="systems"/> 	
	<xsl:copy-of select="database"/>
	<xsl:copy-of select="wfConfig"/>
	<xsl:copy-of select="security"/>
	<xsl:copy-of select="syncTasks"/>	
	<appVariables showGeneratedIdsInTables="{appVariables/@showGeneratedIdsInTables}" docLanguage="{appVariables/@docLanguage}" generatedPrimaryKeyName="{appVariables/@generatedPrimaryKeyName}" toInfinity="{appVariables/@toInfinity}" fromInfinity="{appVariables/@fromInfinity}" sendLongOperationToThreads="{appVariables/@sendLongOperationToThreads}" maxPageSize="{appVariables/@maxPageSize}" dbType="{appVariables/@dbType}" auditing="{appVariables/@auditing}" language="{appVariables/@language}" returnEmailAddress="{appVariables/@returnEmailAddress}" connectionName="rdmapp" useUrlResourcesForAuthentication="Pass Credentials Manually"/>
	<xsl:copy-of select="appConfiguration"/>
	<xsl:copy-of select="setDatabases"/>
	<xsl:copy-of select="taskScheduler"/>
	<xsl:copy-of select="auditing"/>
</metadata>

</xsl:template>

</xsl:stylesheet>