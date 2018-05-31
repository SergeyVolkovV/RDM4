<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:sf="http://www.ataccama.com/xslt/functions"
 xmlns:mrg="http://www.ataccama.com/dqc/plan-merge"	
 xmlns:exsl="http://exslt.org/common" extension-element-prefixes="sf">
<xsl:output method="xml" encoding="UTF-8" indent="yes"/>
 
<xsl:param name="logicalModel" select="document('param:logicalModel')/*"/>
<xsl:param name="rdmAppVariablesRef" select="document('param:rdmAppVariablesRef')/*"/>

<xsl:include href="constants_incl.xsl"/>

<xsl:template match="/*">
	<purity-config version="{$rdm_version}">
		<xsl:variable name="tableName" select="@name"/>

 <!-- (parameters) -->
    <!--
		<step id="Parameters" className="com.ataccama.dqc.tasks.io.text.read.TextFileReader" disabled="false" mode="NORMAL">
        	<properties stringQualifier="" lineSeparator="\r\n" fieldSeparator=";" lineMaxReadLength="65536" numberOfLinesInHeader="1" fileName="parameters.txt" encoding="UTF-8" numberOfLinesInFooter="0" compression="NONE" stringQualifierEscape="">
            	<columns>
                	<textReaderColumn name="username" type="STRING" ignore="false"/>
                	<textReaderColumn name="password" type="STRING" ignore="false"/>
                	<textReaderColumn name="timestamp" type="DATETIME" ignore="false"><dataFormatParameters thousandsSeparator="" dateFormatLocale="en" dateTimeFormat="yyyy-MM-dd HH:mm:ss"/></textReaderColumn>
                	<textReaderColumn name="timestamp_increment" type="DATETIME" ignore="false"><dataFormatParameters thousandsSeparator="" dateFormatLocale="en" dateTimeFormat="yyyy-MM-dd HH:mm:ss"/></textReaderColumn>
            	</columns>
            	<dataFormatParameters trueValue="true" falseValue="false" thousandsSeparator="" dateFormatLocale="en_US" dateTimeFormat="yy-MM-dd HH:mm:ss" decimalSeparator="." dayFormat="yy-MM-dd"/>
            	<errorHandlingStrategy rejectFileName="rejected.txt">
                	<errorInstructions>
                    	<errorInstruction putToLog="true" errorType="EXTRA_DATA" dataStrategy="READ_POSSIBLE" putToReject="false"/>
                    	<errorInstruction putToLog="true" errorType="LONG_LINE" dataStrategy="STOP" putToReject="true"/>
                    	<errorInstruction putToLog="true" errorType="PROCESSING_ERROR" dataStrategy="STOP" putToReject="false"/>
                    	<errorInstruction putToLog="true" errorType="INVALID_DATE" dataStrategy="READ_POSSIBLE" putToReject="false"/>
                    	<errorInstruction putToLog="true" errorType="SHORT_LINE" dataStrategy="READ_POSSIBLE" putToReject="true"/>
                    	<errorInstruction putToLog="true" errorType="UNPARSABLE_FIELD" dataStrategy="NULL_VALUE" putToReject="false"/>
                	</errorInstructions>
            	</errorHandlingStrategy>
            	<shadowColumns/>
        	</properties>
        	<visual-constraints bounds="24,24,-1,-1" layout="vertical"/>
    	</step>
		
		<connection className="com.ataccama.dqc.model.elements.connections.StandardFlowConnection">
			<source endpoint="out" step="Parameters"/>
			<target endpoint="parameters" step="Rdm History Importer"/>
		</connection>
    -->

	<!-- (Rdm History Import) -->
    <step id="Rdm History Importer" className="com.ataccama.rdm.manager.steps.RdmImportHistoryStep" disabled="false" mode="NORMAL">
        <properties tablename="{@name}" url="{$rdmAppVariablesRef/@connectionName}">
        	<xsl:choose>
        		<xsl:when test="@useUrlResourcesForAuthentication='Use App Connection Credentials'">        			
        		</xsl:when>
        		<xsl:when test="@useUrlResourcesForAuthentication='Pass Credentials Manually'">
        			<credentials password="password" username="username"/>
        		</xsl:when>        		
        		<xsl:otherwise>
        			<xsl:choose>
        				<xsl:when test="$rdmAppVariablesRef/@useUrlResourcesForAuthentication='Use App Connection Credentials'">        					
        				</xsl:when>
        				<xsl:otherwise>
        					<credentials password="password" username="username"/>
        				</xsl:otherwise>
        			</xsl:choose>
        		</xsl:otherwise>
        	</xsl:choose>
            <columns>
            	<mrg:mergeChildren key="@name">   
	                <xsl:for-each select="columns/column">
	                   	<xsl:variable name="tmpType">
					        <xsl:if test="$logicalModel/domains/domain[@name=current()/@domain]/@type='LONG'">LONG_INTEGER</xsl:if>
					        <xsl:if test="$logicalModel/domains/domain[@name=current()/@domain]/@type='MNREFERENCES'">STRING</xsl:if>
					        <xsl:if test="$logicalModel/domains/domain[@name=current()/@domain]/@type!='LONG' and $logicalModel/domains/domain[@name=current()/@domain]/@type!='MNREFERENCES'"><xsl:value-of select="$logicalModel/domains/domain[@name=current()/@domain]/@type"/></xsl:if>
					    </xsl:variable>				   
						<rdmHistoryImportStepColumnMapping mrg:retainNodes="fromColumn,groupingColumn,inColumn,toColumn" name="{@name}" type="{upper-case($tmpType)}" inColumn="{@name}"/>	
					</xsl:for-each>
	               	<rdmHistoryImportStepColumnMapping columnType="NORMAL" name="d_from" fromColumn="true" toColumn="false" groupingColumn="false" type="DATETIME" mrg:retainNodes="inColumn"/>
	               	<rdmHistoryImportStepColumnMapping columnType="NORMAL" name="d_to" fromColumn="false" toColumn="true" groupingColumn="false" type="DATETIME" mrg:retainNodes="inColumn"/>
	        	</mrg:mergeChildren>
            </columns>
        </properties>
        <visual-constraints layout="vertical" bounds="72,192,-1,-1"/>
    </step>
    <connection className="com.ataccama.dqc.model.elements.connections.StandardFlowConnection" disabled="false">
        <source step="Rdm History Importer" endpoint="err"/>
        <target step="Errors" endpoint="in"/>
        <visual-constraints>
            <bendpoints/>
        </visual-constraints>
    </connection>


	<!-- (errors) -->
    <step id="Errors" className="com.ataccama.dqc.tasks.io.text.write.TextFileWriter" disabled="false" mode="NORMAL">
        <properties useStringQualifierOnAllColumns="false" stringQualifier="&quot;" lineSeparator="\n" fieldSeparator=";" generateMetadata="true" fileName="errors/{@name}_history.txt" encoding="UTF-8" writeHeader="true" writeAllColumns="true" stringQualifierEscape="&quot;">
            <columns/>
            <dataFormatParameters trueValue="true" falseValue="false" thousandsSeparator="" dateFormatLocale="en_US" dateTimeFormat="yyyy-MM-dd HH:mm:ss" decimalSeparator="." dayFormat="yyyy-MM-dd"/>
        </properties>
       <visual-constraints layout="vertical" bounds="72,288,-1,-1"/>
    </step>


		
	<modelComment bounds="20,24,245,121" borderColor="255,0,128" backgroundColor="255,128,255" foregroundColor="51,51,51">INSTRUCTIONS:
--------------------------------------------------------
1) insert input step for the source data
 
2) insert input for parameters

3) place your mapping into the RDM History Import step, plus specify unique key
	</modelComment>
		
		
	</purity-config>
</xsl:template>

</xsl:stylesheet>