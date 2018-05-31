<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:sf="http://www.ataccama.com/xslt/functions"
 xmlns:mrg="http://www.ataccama.com/dqc/plan-merge"	 
 xmlns:exsl="http://exslt.org/common" extension-element-prefixes="exsl sf">
<xsl:output method="xml" encoding="UTF-8" indent="yes"/>

<xsl:param name="rdmAppVariablesRef" select="document('param:rdmAppVariablesRef')/*"/>
<xsl:param name="logicalModel" select="document('param:logicalModel')/*"/>
<xsl:param name="syncSFTPTaskE" select="document('param:syncSFTPTaskE')/*"/>

<xsl:include href="constants_incl.xsl"/>

<xsl:template match="/*">
	<purity-config version="{$rdm_version}">

<!-- (Input Parameters) -->
    <!--
		<step id="Input Parameters" className="com.ataccama.dqc.tasks.io.text.read.TextFileReader" disabled="false" mode="NORMAL">
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
			<source endpoint="in" step="Input Parameters"/>
			<target endpoint="out" step="Multiplicator Output"/>
		</connection>
    -->

	<xsl:if test="@overridePlan='true'">

	<!-- (Multiplicator Output) -->
	    <step id="Multiplicator Output" className="com.ataccama.dqc.tasks.flow.Multiplicator" disabled="false" mode="NORMAL">
	        <properties/>
	        <visual-constraints bounds="-120,144,-1,-1" layout="vertical"/>
	    </step>
	    
	    <connection className="com.ataccama.dqc.model.elements.connections.StandardFlowConnection" disabled="false">
	        <source step="Multiplicator Output" endpoint="out"/>
	        <target step="{$syncSFTPTaskE/@name} Output Parameters" endpoint="in"/>
	        <visual-constraints>
	            <bendpoints/>
	        </visual-constraints>
	    </connection>
	
	
	<!-- (sort) -->
		<step id="sort [{@outputFileName}]" className="com.ataccama.dqc.tasks.identify.sort.SortEngine">
			<properties>
				<sort/>
			</properties>
	        <visual-constraints layout="vertical" bounds="-120,336,-1,-1"/>
		</step>
		<connection className="com.ataccama.dqc.model.elements.connections.StandardFlowConnection" disabled="false">
	        <source step="sort [{@outputFileName}]" endpoint="out"/>
	        <target step="extract [{@outputFileName}]" endpoint="in"/>
	        <visual-constraints>
	            <bendpoints/>
	        </visual-constraints>
	    </connection>
	
	
	<!-- (out) -->
	    <step id="extract [{@outputFileName}]" className="com.ataccama.dqc.tasks.io.text.write.TextFileWriter" disabled="false" mode="NORMAL">
	      <properties mrg:retainNodes="encoding,useStringQualifierOnAllColumns,writeAllColumns,stringQualifier,generateMetadata,stringQualifierEscape,compression" writeHeader="{@header}" lineSeparator="{@lineSeparator}" fieldSeparator="{@fieldSeparator}" fileName="../../../../../{@filePath}/{@outputFileName}">                    	
	          <columns mrg:retainNodes="textWriterColumn">
	          </columns>
	          <dataFormatParameters trueValue="true" falseValue="false" thousandsSeparator="" dateFormatLocale="en_US" dateTimeFormat="yyyy-MM-dd HH:mm:ss" decimalSeparator="." dayFormat="yyyy-MM-dd"/>
	      </properties>
	      <visual-constraints layout="vertical" bounds="-120,432,-1,-1"/>
	    </step>
	</xsl:if>
    	
	<modelComment bounds="-144,0,532,121" borderColor="255,0,128" backgroundColor="255,128,255" foregroundColor="51,51,51">INSTRUCTIONS:
--------------------------------------------------------
1) insert input for parameters

2) place Incremental Timestamp column to the RDM Extended Reader step if you want to use History table
	</modelComment>

	<xsl:variable name="numTables" select="count(syncSFTPTaskTables/syncSFTPTaskTable)"/>
    <xsl:if test="$numTables > 1">
		<modelComment bounds="216,122,531,109" borderColor="183,183,0" backgroundColor="255,255,180" foregroundColor="51,51,51">WARNING:
-----------------------------------------------------------------
When exporting more than one table at once make sure all required output columns are correctly mapped to the columns from the data flow.

If there is a conflict in the names of output columns, consider adjusting configuration and generating .plan and file again.</modelComment>
	</xsl:if>


	<xsl:apply-templates select="syncSFTPTaskTables/syncSFTPTaskTable" mode="connection">
		<xsl:with-param name="numTables" select="$numTables"/>

		<xsl:with-param name="useUrlResourcesForAuthentication" select="@useUrlResourcesForAuthentication"/>
	</xsl:apply-templates>
	
</purity-config>
</xsl:template>

<xsl:template match="syncSFTPTaskTable" mode="connection">
	<xsl:param name="numTables"/>

	<xsl:param name="useUrlResourcesForAuthentication"/>
	<xsl:variable name="syncName" select="../../@outputFileName"/>

	<xsl:variable name="syncTableName" select="@name"/>
	
	<xsl:if test="@overridePlan='true'">
		<connection className="com.ataccama.dqc.model.elements.connections.StandardFlowConnection" disabled="false">
	        <source step="Multiplicator Output" endpoint="out"/>
	        <target step="{@name}" endpoint="parameters"/>
	        <visual-constraints>
	            <bendpoints/>
	        </visual-constraints>
	    </connection>
	</xsl:if>

<!-- (Rdm Extended Reader) -->
	<step id="{@name}" className="com.ataccama.rdm.manager.steps.RdmSynchronizeStep" disabled="false" mode="NORMAL">
	<xsl:choose>
		<xsl:when test="@history='true'">
	        <properties mrg:retainNodes="input,deduplicateIncrement,sqlFilter,ignoreBusinessDates" atDate="timestamp" incDate="timestamp_increment" tablename="{@name}" url="{$rdmAppVariablesRef/@connectionName}">
        	<xsl:choose>
        		<xsl:when test="$useUrlResourcesForAuthentication='Use App Connection Credentials'">        			
        		</xsl:when>
        		<xsl:when test="$useUrlResourcesForAuthentication='Pass Credentials Manually'">
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
	        	<xsl:for-each select="$logicalModel/tables/table[@name=current()/@name]">
       				<columns>
       					<mrg:mergeChildren key="@name">
	               			<xsl:apply-templates select="columns/column"/>
							<rdmStepColumn columnType="CHANGE_TYPE" name="change_type" type="STRING"/>
	   						<rdmStepColumn columnType="PRIMARY_KEY" name="primary_key" type="LONG_INTEGER"/>
	   						<rdmStepColumn columnType="HCN" name="hcn" type="LONG_INTEGER"/>
	   						<rdmStepColumn columnType="FROM" name="date_from" type="DATETIME"/>
							<rdmStepColumn columnType="TO" name="date_to" type="DATETIME"/>
						</mrg:mergeChildren>
           			</columns>
           		</xsl:for-each>
	        </properties>
	        <visual-constraints bounds="{((position()-1)*120)-120},240,-1,-1" layout="vertical"/>
        </xsl:when>
  		<xsl:otherwise>
        	<properties mrg:retainNodes="input,deduplicateIncrement,sqlFilter,ignoreBusinessDates" atDate="timestamp" tablename="{@name}" url="{$rdmAppVariablesRef/@connectionName}">
	        	<xsl:choose>
	        		<xsl:when test="$useUrlResourcesForAuthentication='Use App Connection Credentials'">        			
	        		</xsl:when>
	        		<xsl:when test="$useUrlResourcesForAuthentication='Pass Credentials Manually'">
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
	        	<xsl:for-each select="$logicalModel/tables/table[@name=current()/@name]">
       				<columns>
       					<mrg:mergeChildren key="@name">
               				<xsl:apply-templates select="columns/column"/>
							<rdmStepColumn columnType="CHANGE_TYPE" name="change_type" type="STRING"/>
	   						<rdmStepColumn columnType="PRIMARY_KEY" name="primary_key" type="LONG_INTEGER"/>
	   						<rdmStepColumn columnType="HCN" name="hcn" type="LONG_INTEGER"/>
	   						<rdmStepColumn columnType="FROM" name="date_from" type="DATETIME"/>
							<rdmStepColumn columnType="TO" name="date_to" type="DATETIME"/>
						</mrg:mergeChildren>
           			</columns>
	            </xsl:for-each>
	        </properties>
	        <visual-constraints bounds="{((position()-1)*120)-120},240,-1,-1" layout="vertical"/>
  		</xsl:otherwise>
	</xsl:choose>
    </step>
    <xsl:if test="@overridePlan='true'">
	    <xsl:if test="$numTables = 1">
		    <connection className="com.ataccama.dqc.model.elements.connections.StandardFlowConnection" disabled="false">
		        <source step="{@name}" endpoint="out"/>
		        <!-- <target step="Transform/Mapping [{@name}]" endpoint="in"/> -->
		        <target step="sort [{$syncName}]" endpoint="in"/>
		        <visual-constraints>
		            <bendpoints/>
		        </visual-constraints>
		    </connection>
		</xsl:if>	
	</xsl:if>
</xsl:template>
<xsl:template match="column">
	<xsl:variable name="tmpType">
        <xsl:if test="$logicalModel/domains/domain[@name=current()/@domain]/@type='LONG'">LONG_INTEGER</xsl:if>
        <xsl:if test="$logicalModel/domains/domain[@name=current()/@domain]/@type='MNREFERENCES'">STRING</xsl:if>
        <xsl:if test="$logicalModel/domains/domain[@name=current()/@domain]/@type!='LONG' and $logicalModel/domains/domain[@name=current()/@domain]/@type!='MNREFERENCES'"><xsl:value-of select="$logicalModel/domains/domain[@name=current()/@domain]/@type"/></xsl:if>
    </xsl:variable>
	<rdmStepColumn name="{@name}" columnType="NORMAL" type="{upper-case($tmpType)}"/>
</xsl:template>
</xsl:stylesheet>