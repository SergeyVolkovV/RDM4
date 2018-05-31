<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:sf="http://www.ataccama.com/xslt/functions"
 xmlns:exsl="http://exslt.org/common" extension-element-prefixes="exsl sf">
 <xsl:output method="xml" encoding="UTF-8" indent="yes"/>

<xsl:template match="/metadata">
<metadata>
	<logicalModel>
		<xsl:copy-of select="logicalModel/tables"/>
		<xsl:copy-of select="logicalModel/relationships"/>
		<xsl:copy-of select="logicalModel/domains"/>
		<xsl:copy-of select="logicalModel/valuePresenters"/>
		<hierarchies>
			<xsl:for-each select="logicalModel/hierarchies/hierarchy">
				<hierarchy name="{@name}" hierarchyLabel="{@hierarchyName}" hierarchyName="{replace(@hierarchyName,'\s','_')}">
					<xsl:copy-of select="hierarchyChildTables"/>
					<xsl:copy-of select="hierarchyViews"/>
				</hierarchy>
			</xsl:for-each>
		</hierarchies>		
		<xsl:copy-of select="logicalModel/views"/>
		<categories>
			<xsl:for-each select="logicalModel/categories/category">
				<category name="{replace(@name,'\s','_')}" label="{@name}">
					<xsl:copy-of select="categoryItemTables"/>
					<xsl:copy-of select="categoryItemViews"/>
					<xsl:copy-of select="categoryItemHierarchies"/>
					<xsl:copy-of select="categoryItemsCategories"/>
				</category>
			</xsl:for-each>
		</categories>
		<xsl:copy-of select="logicalModel/datasets"/>
	</logicalModel>
	<xsl:copy-of select="systems"/> 	
	<xsl:copy-of select="database"/>
	<xsl:copy-of select="wfConfig"/>
	<xsl:copy-of select="security"/>
	<xsl:copy-of select="syncTasks"/>	
	<appVariables showGeneratedIdsInTables="{appVariables/@showGeneratedIdsInTables}" docLanguage="{appVariables/@docLanguage}" generatedPrimaryKeyName="{appVariables/@generatedPrimaryKeyName}" toInfinity="{appVariables/@toInfinity}" fromInfinity="{appVariables/@fromInfinity}" sendLongOperationToThreads="{appVariables/@sendLongOperationToThreads}" maxPageSize="{appVariables/@maxPageSize}" dbType="{appVariables/@dbType}" auditing="{appVariables/@auditing}" language="{appVariables/@language}" returnEmailAddress="{appVariables/@returnEmailAddress}" connectionName="rdmapp" useUrlResourcesForAuthentication="{appVariables/@useUrlResourcesForAuthentication}"/>
	<xsl:copy-of select="appConfiguration"/>
	<xsl:copy-of select="setDatabases"/>
	<xsl:copy-of select="taskScheduler"/>
	<xsl:copy-of select="auditing"/>
</metadata>

</xsl:template>

</xsl:stylesheet>