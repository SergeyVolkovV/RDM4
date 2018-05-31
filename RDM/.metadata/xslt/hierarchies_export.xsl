<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:sf="http://www.ataccama.com/xslt/functions"
 xmlns:mrg="http://www.ataccama.com/dqc/plan-merge"	 
 xmlns:exsl="http://exslt.org/common" extension-element-prefixes="exsl sf">
<xsl:output method="xml" encoding="UTF-8" indent="yes" cdata-section-elements="description sqlSource" omit-xml-declaration="yes"/>

<xsl:param name="rdmAppVariablesRef" select="document('param:rdmAppVariablesRef')/*"/>
<xsl:param name="logicalModel" select="document('param:logicalModel')/*"/>

<xsl:include href="constants_incl.xsl"/>

<xsl:template match="*">
	<purity-config version="{$rdm_version}">
	
<!-- (Column Assigner) --><step mode="NORMAL" className="com.ataccama.dqc.tasks.expressions.ColumnAssigner" disabled="false" id="Column Assigner">
		<properties>
			<assignments>
				<assignment expression="now()" column="timestamp">
					<scorer>
						<scoringEntries>
							<scoringEntry explain="false" score="0" explainAs="CA_CHANGED" key="CA_CHANGED"/>
						</scoringEntries>
					</scorer>
				</assignment>
			</assignments>
		</properties>
		<visual-constraints layout="vertical" bounds="600,48,-1,-1"/>
	</step>
	<connection className="com.ataccama.dqc.model.elements.connections.StandardFlowConnection" disabled="false">
		<source endpoint="out" step="Column Assigner"/>
		<target endpoint="in" step="Multiplicator"/>
		<visual-constraints>
			<bendpoints/>
		</visual-constraints>
	</connection>

<!-- (Random Record Generator) --><step mode="NORMAL" className="com.ataccama.dqc.tasks.generator.RandomRecordGenerator" disabled="false" id="Random Record Generator">
		<properties recordCount="1">
			<columns>
				<iColumnGenerator name="timestamp" maximumDate="2017-11-13 11:58:14" type="DATETIME" class="com.ataccama.dqc.tasks.generator.generators.ColumnGeneratorDate" minimumDate="2017-09-13 11:58:14">
					<formats/>
				</iColumnGenerator>
			</columns>
			<shadowColumns/>
		</properties>
		<visual-constraints layout="vertical" bounds="600,-24,-1,-1"/>
	</step>
	<connection className="com.ataccama.dqc.model.elements.connections.StandardFlowConnection" disabled="false">
		<source endpoint="out" step="Random Record Generator"/>
		<target endpoint="in" step="Column Assigner"/>
		<visual-constraints>
			<bendpoints/>
		</visual-constraints>
	</connection>

<!-- (Multiplicator) -->
    <step id="Multiplicator" className="com.ataccama.dqc.tasks.flow.Multiplicator" disabled="false" mode="NORMAL">
        <properties/>
        <visual-constraints bounds="600,120,-1,-1" layout="vertical"/>
    </step>
    
	<connection className="com.ataccama.dqc.model.elements.connections.StandardFlowConnection" disabled="false">    
    	<source step="Multiplicator" endpoint="out"/>
    	<target step="root_{@name}" endpoint="parameters"/>
    	<visual-constraints>
    		<bendpoints/>
    	</visual-constraints>
 	</connection>
 	
 	<modelComment bounds="-144,0,532,121" borderColor="255,0,128" backgroundColor="255,128,255" foregroundColor="51,51,51">INSTRUCTIONS:
--------------------------------------------------------
1) insert input or configure Column Assigner and Random Record generator for parameters

2) place Incremental Timestamp column to the RDM Extended Reader step if you want to use History table
	</modelComment>
 
<!-- (Rdm Extended Reader) -->
	<step id="root_{@name}" className="com.ataccama.rdm.manager.steps.RdmSynchronizeStep" disabled="false" mode="NORMAL">
		<properties mrg:retainNodes="input,deduplicateIncrement,sqlFilter,ignoreBusinessDates" atDate="timestamp" tablename="{@name}" url="{$rdmAppVariablesRef/@connectionName}">
        	<xsl:variable name="logicalTableName" select="@name"/>
      		<columns>
       			<xsl:apply-templates select="$logicalModel/tables/table[@name=$logicalTableName]/columns/column"/>
				<rdmStepColumn columnType="CHANGE_TYPE" name="change_type" type="STRING"/>
  				<rdmStepColumn columnType="PRIMARY_KEY" name="primary_key" type="LONG_INTEGER"/>
  				<rdmStepColumn columnType="HCN" name="hcn" type="LONG_INTEGER"/>
  				<rdmStepColumn columnType="FROM" name="date_from" type="DATETIME"/>
				<rdmStepColumn columnType="TO" name="date_to" type="DATETIME"/>
       		</columns>
	    </properties>
	    <visual-constraints bounds="816,216,-1,-1" layout="vertical"/>
    </step>
	<connection className="com.ataccama.dqc.model.elements.connections.StandardFlowConnection" disabled="false">
		<source endpoint="out" step="root_{@name}"/>
		<target endpoint="insert_root_{@name}" step="Complex Xml Writer"/>
		<visual-constraints>
			<bendpoints/>
		</visual-constraints>
	</connection>
	<xsl:apply-templates mode="hierarchyChildTableMode"/>
	<xsl:apply-templates select="hierarchyViews/hierarchyView" mode="hierarchyViewsMode"/>
	
<!-- (Complex XML Writer) -->
	<step mode="NORMAL" className="com.ataccama.dqc.tasks.io.xml.writer.ComplexXmlWriter" disabled="false" id="Complex Xml Writer">
			<properties fileName="{@hierarchyName}_export.xml" maximumRecordsInMemory="10000" indenting="true" encoding="UTF-8">
			<dataFormatParameters falseValue="false" dateTimeFormat="yyyy-MM-dd HH:mm:ss" decimalSeparator="." dayFormat="yyyy-MM-dd" trueValue="true" dateFormatLocale="en_US" thousandsSeparator=""/>
			<objects>
				<complexXmlWriterObjectStreamCfg name="insert_root_{@name}">
					<subObjects>
						<xsl:if test="child::hierarchyChildTables/hierarchyChildTable/@name !=''">
							<xsl:for-each select="child::hierarchyChildTables/hierarchyChildTable">
								<xsl:variable name="insertNumber">
									<xsl:number level="any" format="1"/>
								</xsl:variable>
								<complexXmlWriterObjectSubstreamCfg columnBinding="{$logicalModel/relationships/relationship[@name=current()/@relationship]/representativeForeignKey/column/@parentColumn}={$logicalModel/relationships/relationship[@name=current()/@relationship]/representativeForeignKey/column/@childColumn}" name="insert_{$insertNumber}_{@name}">
									<subObjects>
										<xsl:apply-templates mode="hierarchyChildTableModeInXMLWriter"/>
										<xsl:apply-templates select="hierarchyViews/hierarchyView" mode="hierarchyViewsModeInXMLWriter"/>
									</subObjects>
									<template>&lt;<xsl:value-of select="@name"/>&gt;<xsl:for-each select="$logicalModel/tables/table[@name=current()/@name]/columns/column">&lt;<xsl:value-of select="@name"/>&gt;{<xsl:value-of select="@name"/>}&lt;/<xsl:value-of select="@name"/>&gt;</xsl:for-each><xsl:for-each select="hierarchyChildTables/hierarchyChildTable"><xsl:variable name="insertNumber"><xsl:number level="any" format="1"/></xsl:variable>&lt;insert_<xsl:value-of select="$insertNumber"/>_<xsl:value-of select="@name"/>/&gt;</xsl:for-each><xsl:for-each select="hierarchyViews/hierarchyView"><xsl:variable name="insertViewNumber"><xsl:number level="any" format="1"/></xsl:variable>&lt;insert_view_<xsl:value-of select="$insertViewNumber"/>_<xsl:value-of select="@name"/>/&gt;</xsl:for-each>&lt;/<xsl:value-of select="@name"/>&gt;</template>
								</complexXmlWriterObjectSubstreamCfg>
							</xsl:for-each>
						</xsl:if> 
					</subObjects>
					<template>&lt;<xsl:value-of select="@name"/>&gt;<xsl:for-each select="$logicalModel/tables/table[@name=current()/@name]/columns/column">&lt;<xsl:value-of select="@name"/>&gt;{<xsl:value-of select="@name"/>}&lt;/<xsl:value-of select="@name"/>&gt;</xsl:for-each><xsl:for-each select="hierarchyChildTables/hierarchyChildTable"><xsl:variable name="insertNumber"><xsl:number level="any" format="1"/></xsl:variable>&lt;insert_<xsl:value-of select="$insertNumber"/>_<xsl:value-of select="@name"/>/&gt;</xsl:for-each>&lt;/<xsl:value-of select="@name"/>&gt;</template>
				</complexXmlWriterObjectStreamCfg>
			</objects>
			<template>&lt;?xml version=&#39;1.0&#39; encoding=&#39;UTF-8&#39;?&gt;
&lt;hierarchy name=&quot;<xsl:value-of select="@hierarchyName"/>&quot;&gt;
	&lt;insert_root_<xsl:value-of select="@name"/>/&gt;
&lt;/hierarchy&gt;</template>
		</properties>
		<visual-constraints layout="vertical" bounds="600,432,-1,-1"/>
	</step>
	</purity-config>
</xsl:template>

<xsl:template match="hierarchyChildTable" mode="hierarchyChildTableMode">
	<xsl:variable name="readerPosition">
		<xsl:number level="any" format="1"/>
	</xsl:variable>
	<connection className="com.ataccama.dqc.model.elements.connections.StandardFlowConnection" disabled="false">    
    	<source step="Multiplicator" endpoint="out"/>
    	<target step="{$readerPosition}_{@name}" endpoint="parameters"/>
    	<visual-constraints>
    		<bendpoints/>
    	</visual-constraints>
 	</connection>
	
<!-- (Rdm Extended Reader) -->
	<step id="{$readerPosition}_{@name}" className="com.ataccama.rdm.manager.steps.RdmSynchronizeStep" disabled="false" mode="NORMAL">
		<properties mrg:retainNodes="input,deduplicateIncrement,sqlFilter,ignoreBusinessDates" atDate="timestamp" tablename="{@name}" url="{$rdmAppVariablesRef/@connectionName}">
        	<xsl:variable name="logicalTableName" select="@name"/>
      		<columns>
       			<xsl:apply-templates select="$logicalModel/tables/table[@name=$logicalTableName]/columns/column"/>
				<rdmStepColumn columnType="CHANGE_TYPE" name="change_type" type="STRING"/>
  				<rdmStepColumn columnType="PRIMARY_KEY" name="primary_key" type="LONG_INTEGER"/>
  				<rdmStepColumn columnType="HCN" name="hcn" type="LONG_INTEGER"/>
  				<rdmStepColumn columnType="FROM" name="date_from" type="DATETIME"/>
				<rdmStepColumn columnType="TO" name="date_to" type="DATETIME"/>
       		</columns>
	    </properties>
	    <visual-constraints bounds="{816-($readerPosition * 144)},216,-1,-1" layout="vertical"/>
    </step>
	<connection className="com.ataccama.dqc.model.elements.connections.StandardFlowConnection" disabled="false">
		<source endpoint="out" step="{$readerPosition}_{@name}"/>
		<target endpoint="insert_{$readerPosition}_{@name}" step="Complex Xml Writer"/>
		<visual-constraints>
			<bendpoints/>
		</visual-constraints>
	</connection>
	<xsl:apply-templates mode="hierarchyChildTableMode"/>
	<xsl:apply-templates select="hierarchyViews/hierarchyView" mode="hierarchyViewsMode"/>			
	<!-- <views></views> -->
</xsl:template>

<xsl:template match="hierarchyView" mode="hierarchyViewsMode">
	<xsl:variable name="viewReaderPosition">
		<xsl:number level="any" format="1"/>
	</xsl:variable>
	<connection className="com.ataccama.dqc.model.elements.connections.StandardFlowConnection" disabled="false">    
    	<source step="Multiplicator" endpoint="out"/>
    	<target step="view_{$viewReaderPosition}_{@name}" endpoint="parameters"/>
    	<visual-constraints>
    		<bendpoints/>
    	</visual-constraints>
 	</connection>
 	
<!-- (Rdm Extended Reader) -->
	<step id="view_{$viewReaderPosition}_{@name}" className="com.ataccama.rdm.manager.steps.RdmSynchronizeStep" disabled="false" mode="NORMAL">
		<properties mrg:retainNodes="input,deduplicateIncrement,sqlFilter,ignoreBusinessDates" atDate="timestamp" tablename="{@name}" url="{$rdmAppVariablesRef/@connectionName}">
        	<xsl:variable name="logicalViewName" select="@name"/>
      		<columns>
       			<xsl:apply-templates select="$logicalModel/views/view[@nameView=$logicalViewName]/viewColumns/viewColumn"/>
       			<xsl:apply-templates select="$logicalModel/views/view[@nameView=$logicalViewName]//viewParentTables/viewParentTable/viewColumns/viewColumn"/>
				<rdmStepColumn columnType="CHANGE_TYPE" name="change_type" type="STRING"/>
  				<rdmStepColumn columnType="PRIMARY_KEY" name="primary_key" type="LONG_INTEGER"/>
  				<rdmStepColumn columnType="HCN" name="hcn" type="LONG_INTEGER"/>
  				<rdmStepColumn columnType="FROM" name="date_from" type="DATETIME"/>
				<rdmStepColumn columnType="TO" name="date_to" type="DATETIME"/>
       		</columns>
	    </properties>
	    <visual-constraints bounds="{816+($viewReaderPosition * 144)},216,-1,-1" layout="vertical"/>
    </step>
	<connection className="com.ataccama.dqc.model.elements.connections.StandardFlowConnection" disabled="false">
		<source endpoint="out" step="view_{$viewReaderPosition}_{@name}"/>
		<target endpoint="insert_view_{$viewReaderPosition}_{@name}" step="Complex Xml Writer"/>
		<visual-constraints>
			<bendpoints/>
		</visual-constraints>
	</connection>
</xsl:template>

<xsl:template match="hierarchyChildTable" mode="hierarchyChildTableModeInXMLWriter">
	<xsl:variable name="insertNumber">
		<xsl:number level="any" format="1"/>
	</xsl:variable>
	<complexXmlWriterObjectSubstreamCfg columnBinding="{$logicalModel/relationships/relationship[@name=current()/@relationship]/representativeForeignKey/column/@parentColumn}={$logicalModel/relationships/relationship[@name=current()/@relationship]/representativeForeignKey/column/@childColumn}" name="insert_{$insertNumber}_{@name}">
		<subObjects>
			<xsl:apply-templates mode="hierarchyChildTableModeInXMLWriter"/>
			<xsl:apply-templates select="hierarchyViews/hierarchyView" mode="hierarchyViewsModeInXMLWriter"/>
		</subObjects>
		<template>&lt;<xsl:value-of select="@name"/>&gt;<xsl:for-each select="$logicalModel/tables/table[@name=current()/@name]/columns/column">&lt;<xsl:value-of select="@name"/>&gt;{<xsl:value-of select="@name"/>}&lt;/<xsl:value-of select="@name"/>&gt;</xsl:for-each><xsl:for-each select="hierarchyChildTables/hierarchyChildTable"><xsl:variable name="insertNumber"><xsl:number level="any" format="1"/></xsl:variable>&lt;insert_<xsl:value-of select="$insertNumber"/>_<xsl:value-of select="@name"/>/&gt;</xsl:for-each><xsl:for-each select="hierarchyViews/hierarchyView"><xsl:variable name="insertViewNumber"><xsl:number level="any" format="1"/></xsl:variable>&lt;insert_view_<xsl:value-of select="$insertViewNumber"/>_<xsl:value-of select="@name"/>/&gt;</xsl:for-each>&lt;/<xsl:value-of select="@name"/>&gt;</template>
	</complexXmlWriterObjectSubstreamCfg>
</xsl:template>

<xsl:template match="hierarchyView" mode="hierarchyViewsModeInXMLWriter">
	<xsl:variable name="insertViewNumber">
		<xsl:number level="any" format="1"/>
	</xsl:variable>
 	<complexXmlWriterObjectSubstreamCfg columnBinding="{$logicalModel/views/view[@nameView=current()/@name]/viewParentTables/viewParentTable[@name=current()/../../@name]/viewColumns/viewColumn[1]/@name}={$logicalModel/views/view[@nameView=current()/@name]/viewParentTables/viewParentTable[@name=current()/../../@name]/viewColumns/viewColumn[1]/@alias}" name="insert_view_{$insertViewNumber}_{@name}">
		<subObjects>
		</subObjects>
		<template>&lt;<xsl:value-of select="@name"/>&gt;<xsl:for-each select="$logicalModel/views/view[@nameView=current()/@name]/viewColumns/viewColumn">&lt;<xsl:value-of select="@alias"/>&gt;{<xsl:value-of select="@alias"/>}&lt;/<xsl:value-of select="@alias"/>&gt;</xsl:for-each><xsl:for-each select="$logicalModel/views/view[@nameView=current()/@name]//viewParentTables/viewParentTable/viewColumns/viewColumn">&lt;<xsl:value-of select="@alias"/>&gt;{<xsl:value-of select="@alias"/>}&lt;/<xsl:value-of select="@alias"/>&gt;</xsl:for-each>&lt;/<xsl:value-of select="@name"/>&gt;</template>
	</complexXmlWriterObjectSubstreamCfg>
</xsl:template>

<xsl:template match="column">
	<xsl:variable name="tmpType">
        <xsl:if test="$logicalModel/domains/domain[@name=current()/@domain]/@type='LONG'">LONG_INTEGER</xsl:if>
        <xsl:if test="$logicalModel/domains/domain[@name=current()/@domain]/@type='MNREFERENCES'">STRING</xsl:if>
        <xsl:if test="$logicalModel/domains/domain[@name=current()/@domain]/@type!='LONG' and $logicalModel/domains/domain[@name=current()/@domain]/@type!='MNREFERENCES'"><xsl:value-of select="$logicalModel/domains/domain[@name=current()/@domain]/@type"/></xsl:if>
    </xsl:variable>
	<rdmStepColumn name="{@name}" columnType="NORMAL" type="{upper-case($tmpType)}"/>
</xsl:template>

<xsl:template match="viewColumn">
	<xsl:variable name="varColumnDomain" select="$logicalModel/tables/table[@name=current()/../../@name]/columns/column[@name=current()/@name]/@domain"/>
	<xsl:variable name="tmpType">
        <xsl:if test="$logicalModel/domains/domain[@name=$varColumnDomain]/@type='LONG'">LONG_INTEGER</xsl:if>
        <xsl:if test="$logicalModel/domains/domain[@name=$varColumnDomain]/@type='MNREFERENCES'">STRING</xsl:if>
        <xsl:if test="$logicalModel/domains/domain[@name=$varColumnDomain]/@type!='LONG' and $logicalModel/domains/domain[@name=$varColumnDomain]/@type!='MNREFERENCES'"><xsl:value-of select="$logicalModel/domains/domain[@name=$varColumnDomain]/@type"/></xsl:if>
    </xsl:variable>
	<rdmStepColumn name="{@alias}" columnType="NORMAL" type="{upper-case($tmpType)}"/>
</xsl:template>

</xsl:stylesheet>