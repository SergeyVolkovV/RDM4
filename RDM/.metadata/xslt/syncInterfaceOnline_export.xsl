<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:sf="http://www.ataccama.com/xslt/functions"
 xmlns:mrg="http://www.ataccama.com/dqc/plan-merge"	 
 xmlns:exsl="http://exslt.org/common" extension-element-prefixes="exsl sf">
<xsl:output method="xml" encoding="UTF-8" indent="yes"/>

<xsl:param name="rdmAppVariablesRef" select="document('param:rdmAppVariablesRef')/*"/>
<xsl:param name="logicalModel" select="document('param:logicalModel')/*"/>

<xsl:include href="constants_incl.xsl"/>

<xsl:template match="/*">
	<purity-config version="{$rdm_version}">

<!-- (Input Step) -->
		<step className="com.ataccama.dqc.tasks.common.usersteps.io.InputStep" id="in">
			<properties>
				<columns>
	                <xsl:choose>
		        		<xsl:when test="@useUrlResourcesForAuthentication='Use App Connection Credentials'">        			
		        		</xsl:when>
		        		<xsl:when test="@useUrlResourcesForAuthentication='Pass Credentials Manually'">
							<column name="username" type="STRING"/>
							<column name="password" type="STRING"/>
		        		</xsl:when>        		
		        		<xsl:otherwise>
		        			<xsl:choose>
		        				<xsl:when test="$rdmAppVariablesRef/@useUrlResourcesForAuthentication='Use App Connection Credentials'">        					
		        				</xsl:when>
		        				<xsl:otherwise>
									<column name="username" type="STRING"/>
									<column name="password" type="STRING"/>
		        				</xsl:otherwise>
		        			</xsl:choose>
		        		</xsl:otherwise>
		        	</xsl:choose> 				
					<column name="timestamp" type="DATETIME"/>
              		<xsl:if test="syncOnlineTaskTables/syncOnlineTaskTable/@history='true'">
						<column name="timestamp_increment" type="DATETIME"/>
					</xsl:if>
				</columns>
				<shadowColumns/>
			</properties>
			<visual-constraints bounds="48,50,-1,-1" layout="vertical"/>
		</step>

		<connection className="com.ataccama.dqc.model.elements.connections.StandardFlowConnection" disabled="false">
	        <source step="in" endpoint="out"/>
	        <target step="Multiplicator Input" endpoint="in"/>
	        <visual-constraints>
	            <bendpoints/>
	        </visual-constraints>
	    </connection>

<!-- (Multiplicator Input) -->
    <step id="Multiplicator Input" className="com.ataccama.dqc.tasks.flow.Multiplicator" disabled="false" mode="NORMAL">
        <properties/>
		<visual-constraints bounds="48,147,-1,-1" layout="vertical"/>
    </step>
    
<!-- (Output Step) -->			
		<step className="com.ataccama.dqc.tasks.common.usersteps.io.OutputStep" id="getRecords">
			<properties>
				<requiredColumns>
					<xsl:for-each select="syncOnlineTaskTables/syncOnlineTaskTable">
						<xsl:variable name="tableName" select="@name"/>
						<xsl:choose>
							<xsl:when test="@allColumns='true'">
								<xsl:for-each select="$logicalModel/tables/table[@name=$tableName]/columns/column">
									<xsl:variable name="columnName" select="@name"/>
									<xsl:variable name="columnType" select="if($logicalModel/domains/domain[@name=$logicalModel/tables/table[@name=$tableName]/columns/column[@name=$columnName]/@domain]/@type='MNREFERENCES') then 'STRING' else $logicalModel/domains/domain[@name=$logicalModel/tables/table[@name=$tableName]/columns/column[@name=$columnName]/@domain]/@type"/>
									<requiredColumn name="{@name}" type="{$columnType}"/>
								</xsl:for-each>
							</xsl:when>
							<xsl:otherwise>
								<xsl:for-each select="syncOnlineTaskTableColumns/syncOnlineTaskTableColumn">
									<xsl:variable name="columnName" select="@name"/>
									<xsl:variable name="columnType" select="if($logicalModel/domains/domain[@name=$logicalModel/tables/table[@name=$tableName]/columns/column[@name=$columnName]/@domain]/@type='MNREFERENCES') then 'STRING' else $logicalModel/domains/domain[@name=$logicalModel/tables/table[@name=$tableName]/columns/column[@name=$columnName]/@domain]/@type"/>
									<requiredColumn name="{@name}" type="{$columnType}"/>
								</xsl:for-each>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:for-each>
					<xsl:for-each select="syncOnlineTaskColumns/syncOnlineTaskColumn">
						<requiredColumn name="{@name}" type="{@type}"/>
					</xsl:for-each>				
					<requiredColumn name="change_type" type="STRING"/>
				</requiredColumns>			
			</properties>
			<visual-constraints bounds="48,366,-1,-1" layout="vertical"/>
		</step>

    	
	<modelComment bounds="216,0,532,100" borderColor="255,0,128" backgroundColor="255,128,255" foregroundColor="51,51,51">INSTRUCTIONS:
--------------------------------------------------------
1) insert input for parameters

2) place Incremental Timestamp column to the RDM Extended Reader step if you want to use History table
	</modelComment>

	<xsl:variable name="numTables" select="count(syncOnlineTaskTables/syncOnlineTaskTable)"/>
    <xsl:if test="$numTables > 1">
		<modelComment bounds="216,115,531,104" borderColor="183,183,0" backgroundColor="255,255,180" foregroundColor="51,51,51">WARNING:
-----------------------------------------------------------------
When exporting more than one table at once make sure all required output columns are correctly mapped to the columns from the data flow.

If there is a conflict in the names of output columns, adjust the configuration of export operation and generate .plan and .online files again.</modelComment>
	</xsl:if>
	
	<xsl:apply-templates select="syncOnlineTaskTables/syncOnlineTaskTable" mode="connection">
		<xsl:with-param name="numTables" select="$numTables"/>
		<xsl:with-param name="useUrlResourcesForAuthentication" select="@useUrlResourcesForAuthentication"/>
	</xsl:apply-templates>
	
</purity-config>
</xsl:template>

<xsl:template match="syncOnlineTaskTable" mode="connection">
	<xsl:param name="numTables"/>
	<xsl:param name="useUrlResourcesForAuthentication"/>
	<xsl:variable name="syncTableName" select="@name"/>
	
		<connection className="com.ataccama.dqc.model.elements.connections.StandardFlowConnection" disabled="false">
	        <source step="Multiplicator Input" endpoint="out"/>
	        <target step="{@name}" endpoint="parameters"/>
	        <visual-constraints>
	            <bendpoints/>
	        </visual-constraints>
	    </connection>

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
        		<xsl:variable name="logicalTableName" select="@name"/>
      				<columns>
      					<mrg:mergeChildren key="@name">
              				<xsl:apply-templates select="$logicalModel/tables/table[@name=$logicalTableName]/columns/column"/>
							<rdmStepColumn columnType="CHANGE_TYPE" name="change_type" type="STRING"/>
	  						<rdmStepColumn columnType="PRIMARY_KEY" name="primary_key" type="LONG_INTEGER"/>
	  						<rdmStepColumn columnType="HCN" name="hcn" type="LONG_INTEGER"/>
	  						<rdmStepColumn columnType="FROM" name="date_from" type="DATETIME"/>
							<rdmStepColumn columnType="TO" name="date_to" type="DATETIME"/>
						</mrg:mergeChildren>
          			</columns>
	        </properties>
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
        		<xsl:variable name="logicalTableName" select="@name"/>
     				<columns>
     					<mrg:mergeChildren key="@name">
	             			<xsl:apply-templates select="$logicalModel/tables/table[@name=$logicalTableName]/columns/column"/>
							<rdmStepColumn columnType="CHANGE_TYPE" name="change_type" type="STRING"/>
	 						<rdmStepColumn columnType="PRIMARY_KEY" name="primary_key" type="LONG_INTEGER"/>
	 						<rdmStepColumn columnType="HCN" name="hcn" type="LONG_INTEGER"/>
	 						<rdmStepColumn columnType="FROM" name="date_from" type="DATETIME"/>
							<rdmStepColumn columnType="TO" name="date_to" type="DATETIME"/>
						</mrg:mergeChildren>
         			</columns>
	        </properties>
  		</xsl:otherwise>
	</xsl:choose>
	      <visual-constraints layout="vertical">
			<xsl:attribute name="bounds">
				<xsl:value-of select="((position()-1)*120)+48"/><xsl:text>,271,-1,-1</xsl:text>
			</xsl:attribute>
		</visual-constraints>
    </step>
    <xsl:if test="$numTables = 1">
	    <connection className="com.ataccama.dqc.model.elements.connections.StandardFlowConnection" disabled="false">
	        <source step="{@name}" endpoint="out"/>
	        <target step="getRecords" endpoint="in"/>
	        <visual-constraints>
	            <bendpoints/>
	        </visual-constraints>
	    </connection>
	</xsl:if>	    
</xsl:template>
<xsl:template match="column">
	<xsl:variable name="tmpType">
        <xsl:if test="$logicalModel/domains/domain[@name=current()/@domain]/@type='LONG'">LONG_INTEGER</xsl:if>
        <xsl:if test="$logicalModel/domains/domain[@name=current()/@domain]/@type='MNREFERENCES'">STRING</xsl:if>
        <xsl:if test="$logicalModel/domains/domain[@name=current()/@domain]/@type!='LONG' and $logicalModel/domains/domain[@name=current()/@domain]/@type!='MNREFERENCES'"><xsl:value-of select="$logicalModel/domains/domain[@name=current()/@domain]/@type"/></xsl:if>
    </xsl:variable>
	<rdmStepColumn columnType="NORMAL" name="{@name}" type="{upper-case($tmpType)}" />
</xsl:template>
</xsl:stylesheet>