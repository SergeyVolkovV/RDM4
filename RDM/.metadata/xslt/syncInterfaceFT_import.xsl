<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:sf="http://www.ataccama.com/xslt/functions"
 xmlns:mrg="http://www.ataccama.com/dqc/plan-merge"
 xmlns:exsl="http://exslt.org/common" extension-element-prefixes="exsl sf">
<xsl:output method="xml" encoding="UTF-8" indent="yes"/>

<xsl:param name="rdmTableRef" select="document('param:rdmTableRef')"/>
<xsl:param name="rdmAppVariablesRef" select="document('param:rdmAppVariablesRef')/*"/>
<xsl:param name="logicalModel" select="document('param:logicalModel')/*"/>
<xsl:param name="syncSFTPTaskI" select="document('param:syncSFTPTaskI')/*"/>

<xsl:include href="constants_incl.xsl"/>

<xsl:template match="/*">
	<purity-config version="{$rdm_version}">

<xsl:variable name="tableName" select="@tableName"/>

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
			<source endpoint="in" step="Parameters"/>
			<target endpoint="out" step="Multiplicator Input Parameters"/>
		</connection>
    -->
    
	<!-- (Rdm Import) -->
    <step id="Rdm Importer" className="com.ataccama.rdm.manager.steps.RdmImportStep" disabled="false" mode="NORMAL">
    	<properties mrg:retainNodes="importTable,moveToEditAction,incremental,allowedEditStates" tablename="{$tableName}" url="{$rdmAppVariablesRef/@connectionName}">
        	<xsl:choose>
        		<xsl:when test="$syncSFTPTaskI/@useUrlResourcesForAuthentication='Use App Connection Credentials'">        			
        		</xsl:when>
        		<xsl:when test="$syncSFTPTaskI/@useUrlResourcesForAuthentication='Pass Credentials Manually'">
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
            <allowedEditStates>
            	<rdmEditedState>CHANGED</rdmEditedState>
				<rdmEditedState>DELETED</rdmEditedState>
				<rdmEditedState>NEW</rdmEditedState>
			</allowedEditStates>            
            <xsl:for-each select="$logicalModel/tables/table[@name=$tableName]">
            	<xsl:variable name="idGenerators" select="idGenerators"/>
           		<columns>           			
           			<mrg:mergeChildren key="@name">
               			<xsl:apply-templates select="columns/column[not(@name=$idGenerators/generator/@name)]" mode="rdmStepColumnMapping"/>
               		</mrg:mergeChildren>
           		</columns>
            </xsl:for-each>        
        </properties>
        <visual-constraints bounds="408,192,-1,-1" layout="vertical"/>
    </step>
    <connection className="com.ataccama.dqc.model.elements.connections.StandardFlowConnection" disabled="false">
        <source step="Rdm Importer" endpoint="err"/>
        <target step="Errors" endpoint="in"/>
        <visual-constraints>
            <bendpoints/>
        </visual-constraints>
    </connection>


	<!-- (Errors) -->
    <step id="Errors" className="com.ataccama.dqc.tasks.io.text.write.TextFileWriter" disabled="false" mode="NORMAL">
        <properties useStringQualifierOnAllColumns="false" stringQualifier="&quot;" lineSeparator="\n" fieldSeparator=";" generateMetadata="true" fileName="errors/{$syncSFTPTaskI/@name}_{@tableName}.txt" encoding="UTF-8" writeHeader="true" writeAllColumns="true" stringQualifierEscape="&quot;">
            <columns/>
            <dataFormatParameters trueValue="true" falseValue="false" thousandsSeparator="" dateFormatLocale="en_US" dateTimeFormat="yyyy-MM-dd HH:mm:ss" decimalSeparator="." dayFormat="yyyy-MM-dd"/>
        </properties>
        <visual-constraints bounds="408,288,-1,-1" layout="vertical"/>
    </step>


		
	<modelComment bounds="20,24,245,121" borderColor="255,0,128" backgroundColor="255,128,255" foregroundColor="51,51,51">INSTRUCTIONS:
--------------------------------------------------------
1) insert input step for the source data
 
2) insert input for parameters

3) place your mapping into the RDM Import step
	</modelComment>
		
	
	</purity-config>
</xsl:template>	
	
<xsl:template match="column" mode="rdmStepColumnMapping">
	<xsl:variable name="tmpType">
        <xsl:if test="$logicalModel/domains/domain[@name=current()/@domain]/@type='LONG'">LONG_INTEGER</xsl:if>
        <xsl:if test="$logicalModel/domains/domain[@name=current()/@domain]/@type='MNREFERENCES'">STRING</xsl:if>
        <xsl:if test="$logicalModel/domains/domain[@name=current()/@domain]/@type!='LONG' and $logicalModel/domains/domain[@name=current()/@domain]/@type!='MNREFERENCES'"><xsl:value-of select="$logicalModel/domains/domain[@name=current()/@domain]/@type"/></xsl:if>
    </xsl:variable>
	<rdmImportStepColumnMapping columnType="NORMAL" inColumn="{@name}" name="{@name}" type="{upper-case($tmpType)}" mrg:retainNodes="inColumn"/>
</xsl:template>


</xsl:stylesheet>

    	
        	