<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
 <xsl:output method="xml" encoding="UTF-8" indent="yes"/>

<xsl:param name="rdmTableRef" select="document('param:rdmTableRef')"/>
<xsl:param name="rdmAppVariablesRef" select="document('param:rdmAppVariablesRef')"/>
<xsl:param name="rdmSystemRef" select="document('param:rdmSystemRef')"/>

<xsl:include href="constants_incl.xsl"/>

<xsl:template match="/*">
	<purity-config version="{$rdm_version}">
		<xsl:variable name="tableName" select="@name"/>

		<!-- (table_rdm) -->
		<step className="com.ataccama.dqc.tasks.io.jdbc.read.JdbcReader" id="{@name}_rdm">
			<properties queryString="select * from {@name}" dataSourceName="{$rdmAppVariablesRef/appVariables/appVariable[@name='dataSourceName']/@value}"> <!-- to do generic -->
				<columns>
					<xsl:for-each select="$rdmTableRef/logicalModel/tables/table[@name=$tableName]/columns/column">   
						<column name="{@name}" type="{ancestor::logicalModel/domains/domain[@name=current()/@domain]/@type}"/>
					</xsl:for-each>
					<column name="generatedpk" type="INTEGER"/>
				</columns>
				<shadowColumns>
				</shadowColumns>
			</properties>
			<visual-constraints bounds="336,24,-1,-1" layout="vertical"/>
		</step>
		<connection className="com.ataccama.dqc.model.elements.connections.StandardFlowConnection" disabled="false">
        	<source step="{@name}_rdm" endpoint="out"/>
	        <target step="Alter Format" endpoint="in"/>
        	<visual-constraints>
            	<bendpoints/>
        	</visual-constraints>
    	</connection>

		<!-- (table_system) -->
		<!-- <step className="com.ataccama.dqc.tasks.io.jdbc.read.JdbcReader" id="{@name}_system">
			<properties queryString="select * from {@name}" dataSourceName="oracle">
				<columns>
					<xsl:apply-templates select="inputSystem" mode="system"/>
				</columns>
				<shadowColumns>
				</shadowColumns>
			</properties>
		</step>  -->
		
		<!-- (Alter Format) -->
    	<step id="Mapping" className="com.ataccama.dqc.tasks.flow.AlterFormat" disabled="false" mode="NORMAL">
        	<properties>
            	<addedColumns>
					<xsl:apply-templates select="inputSystem" mode="systemAdd"/>
				</addedColumns>
            	<removedColumns/>
        	</properties>
        	<visual-constraints bounds="336,120,-1,-1" layout="vertical"/>
        </step>
        <connection className="com.ataccama.dqc.model.elements.connections.StandardFlowConnection" disabled="false">
        	<source step="Alter Format" endpoint="out"/>
        	<target step="out" endpoint="in"/>
	    </connection>
		
		<!-- (out) -->
    	<step id="out" className="com.ataccama.dqc.tasks.io.text.write.TextFileWriter" disabled="false" mode="NORMAL">
        	<properties useStringQualifierOnAllColumns="false" stringQualifier="&quot;" lineSeparator="\r\n" fieldSeparator=";" generateMetadata="true" fileName="../../data/src_lookup/{$rdmSystemRef/systems/system/tables/table[@name=$tableName]/ancestor::system/@name}_{@name}.txt" encoding="UTF-8" writeHeader="true" writeAllColumns="false" stringQualifierEscape="&quot;">
            	<columns>
                	<xsl:apply-templates select="inputSystem" mode="systemOut"/>
            	</columns>
            <dataFormatParameters trueValue="true" falseValue="false" thousandsSeparator="" dateFormatLocale="en_US" dateTimeFormat="yyyy-MM-dd HH:mm:ss" decimalSeparator="." dayFormat="yyyy-MM-dd"/>
        	</properties>
        	<visual-constraints bounds="336,216,-1,-1" layout="vertical"/>
    	</step>

		<modelComment bounds="24,24,241,121" borderColor="255,0,128" backgroundColor="255,128,255" foregroundColor="51,51,51">INSTRUCTIONS:

1) place your mapping into Alter Format step
		</modelComment>
		
	</purity-config>
</xsl:template>

<xsl:template match="column" mode="system">
	<column name="{@name}" type="{@type}"/>
</xsl:template>

<xsl:template match="column" mode="systemOut">
	<column name="{@name}" expression="{@name}"/>
</xsl:template>

<xsl:template match="column" mode="systemAdd">
	<addedColumn name="{@name}" type="{@type}"/>
</xsl:template>

</xsl:stylesheet>