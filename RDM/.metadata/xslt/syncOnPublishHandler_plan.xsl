<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:sf="http://www.ataccama.com/xslt/functions"
 xmlns:mrg="http://www.ataccama.com/dqc/plan-merge"	 
 xmlns:exsl="http://exslt.org/common" extension-element-prefixes="exsl sf">
<xsl:output method="xml" encoding="UTF-8" indent="yes"/>

<xsl:param name="logicalModel" select="document('param:logicalModel')/*"/>
<xsl:param name="domains" select="document('param:domains')/*"/>

<xsl:include href="constants_incl.xsl"/>

<xsl:template match="/*">
	<purity-config version="{$rdm_version}">
		<xsl:apply-templates select="tables/table"/>
		<modelComment bounds="24,0,385,49" borderColor="183,183,0" backgroundColor="255,255,180" foregroundColor="51,51,51">If you are going to use a Text File Writer (or any other file writer), we recommend to parametrize them with timestamp: 1. Create a shadow column timestamp in one of the steps 2. Use that column in curly brackets when defining the name of the output file, for example, onPublishOutput_{timestamp}.csv</modelComment>
	</purity-config>
</xsl:template>

<xsl:template match="table">
	<xsl:variable name="tableName" select="@name"/>			
	<step id="in_{@name}" className="com.ataccama.dqc.tasks.common.usersteps.io.InputStep" disabled="false" mode="NORMAL">
		<properties>
			<columns>
				<columnDef name="gpk" type="LONG"/>
				<columnDef name="edit_state" type="STRING"/>
				<!-- <columnDef name="d_from" type="DATETIME"/> -->
				<xsl:if test="@exportAllOldColumns='true'">
					<xsl:for-each select="$logicalModel/tables/table[@name=$tableName]/columns/column">
						<xsl:variable name="columnDomain" select="@domain"/>
						<columnDef name="old_{@name}" type="{$domains/domain[@name=$columnDomain]/dqcType/@dqcType}"/>
					</xsl:for-each>
				</xsl:if>
				<xsl:if test="@exportAllNewColumns='true'">
					<xsl:for-each select="$logicalModel/tables/table[@name=$tableName]/columns/column">
						<xsl:variable name="columnDomain" select="@domain"/>
						<columnDef name="new_{@name}" type="{$domains/domain[@name=$columnDomain]/dqcType/@dqcType}"/>
					</xsl:for-each>
				</xsl:if>					
				<xsl:variable name="exportValues" select="exportValues"/>
				<xsl:for-each select="$logicalModel/tables/table[@name=$tableName]/columns/column[@name=$exportValues/exportValue/@name]">
					<xsl:variable name="columnDomain" select="@domain"/>
					<xsl:variable name="columnName" select="@name"/>	
					<xsl:if test="$exportValues/exportValue[@name=$columnName]/@oldValue='true'">
						<columnDef name="old_{@name}" type="{$domains/domain[@name=$columnDomain]/dqcType/@dqcType}"/>
					</xsl:if>
					<xsl:if test="$exportValues/exportValue[@name=$columnName]/@newValue='true'">
						<columnDef name="new_{@name}" type="{$domains/domain[@name=$columnDomain]/dqcType/@dqcType}"/>
					</xsl:if>							
				</xsl:for-each>
			</columns>
			<shadowColumns/>
		</properties>
		<visual-constraints layout="vertical">
			<xsl:attribute name="bounds">
				<xsl:value-of select="((position()-1)*200)+48"/><xsl:text>,72,-1,-1</xsl:text>
			</xsl:attribute>
		</visual-constraints>
	</step>
	
    <connection className="com.ataccama.dqc.model.elements.connections.StandardFlowConnection" disabled="false">
        <source endpoint="out" step="in_{@name}"/>
        <target endpoint="in" step="add_columns_{@name}"/>
        <visual-constraints>
            <bendpoints/>
        </visual-constraints>
    </connection>

<!-- (Alter Format) --><step mode="NORMAL" className="com.ataccama.dqc.tasks.flow.AlterFormat" disabled="false" id="add_columns_{@name}">
        <properties>
            <addedColumns>
                <addedColumn expression="gpk" name="PRIMARY_KEY" type="LONG"/>
                <addedColumn expression="edit_state" name="CHANGE_TYPE" type="STRING"/>
                <!-- <addedColumn expression="d_from" name="FROM" type="DATETIME"/> -->                             				                          
            </addedColumns>
            <removedColumns>
				<columnRef name="gpk"/>
				<columnRef name="edit_state"/>
				<!-- <columnRef name="d_from"/> -->				
			</removedColumns>
        </properties>
		<visual-constraints layout="vertical">
			<xsl:attribute name="bounds">
				<xsl:value-of select="((position()-1)*200)+48"/><xsl:text>,192,-1,-1</xsl:text>
			</xsl:attribute>
		</visual-constraints>
    </step>

</xsl:template>

</xsl:stylesheet>