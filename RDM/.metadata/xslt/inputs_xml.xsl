<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="xml" encoding="UTF-8" indent="yes"/>


<xsl:param name="rdmSystemRef" select="document('param:rdmSystemRef')"/>
<xsl:template match="*">
	
<inputs>
    <entities>
		<xsl:for-each select="logicalModel/tables/table">
       	<xsl:variable name="logicalTableName" select="@name"/>
       		<xsl:if test="$rdmSystemRef/systems/databaseSystems/databaseSystem/tables/table[@synchronizeWith = $logicalTableName]">
       		<entity name="{@name}">
				<inputs>					
					<xsl:for-each select="$rdmSystemRef/systems/databaseSystems/databaseSystem/tables/table[@synchronizeWith = $logicalTableName]">
			   			<!--<input name="{@name}s">-->
			   			<input name="{../../@name}_{@name}">
			      			<columns>
			         			<xsl:apply-templates select="columns/column" mode="mappedColumn"/>
			         			<xsl:apply-templates select="columns/column" mode="notMappedColumn"/>
			      			</columns>
			   			</input>
			   		</xsl:for-each>			   		
				</inputs>
			</entity>
			</xsl:if>
		</xsl:for-each>
    </entities>
</inputs>
</xsl:template>

<xsl:template match="column" mode="mappedColumn">
	<xsl:variable name="tmpType">
        <xsl:if test="@type ='long'">long_integer</xsl:if>
        <xsl:if test="@type!='long'"><xsl:value-of select="@type"/></xsl:if>
	</xsl:variable>
	<xsl:if test="@mappedColumn != ''">
	<column name="{@name}" type="{$tmpType}" mappedName="{@mappedColumn}"/>
	</xsl:if>
</xsl:template>

<xsl:template match="column" mode="notMappedColumn">
	<xsl:variable name="tmpType">
        <xsl:if test="@type ='long'">long_integer</xsl:if>
        <xsl:if test="@type!='long'"><xsl:value-of select="@type"/></xsl:if>
	</xsl:variable>
	<xsl:if test="@mappedColumn = ''">
	<column name="{@name}" type="{$tmpType}"/>
	</xsl:if>
</xsl:template>


</xsl:stylesheet>	
