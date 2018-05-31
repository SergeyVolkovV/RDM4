<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:sf="http://www.ataccama.com/xslt/functions"
 xmlns:mrg="http://www.ataccama.com/dqc/plan-merge"	 
 xmlns:exsl="http://exslt.org/common" extension-element-prefixes="exsl sf">
  <xsl:output method="xml" encoding="UTF-8" indent="yes"/>

<xsl:param name="rdmTableRef" select="document('param:rdmTableRef')"/>
<xsl:param name="rdmAppVariablesRef" select="document('param:rdmAppVariablesRef')/*"/>
<xsl:param name="rdmSystemRef" select="document('param:rdmSystemRef')"/>
<xsl:param name="rdmDataSourceRef" select="document('param:rdmDataSourceRef')"/>

<xsl:include href="constants_incl.xsl"/>

<xsl:template match="/*">
	<purity-config version="{$rdm_version}">
	<xsl:variable name="syncTaskName" select="@name"/> 
	<xsl:variable name="useUrlResourcesForAuthentication" select="@useUrlResourcesForAuthentication"/>

	<xsl:for-each select="syncTaskTables/syncTaskTable">
	
		<xsl:variable name="tmpDataSource" select="$rdmDataSourceRef/dataSources/dataSource[@name = $rdmSystemRef/systems/databaseSystems/databaseSystem[@name = current()/@system]/@dataSourceName]"/>
		<xsl:variable name="tmpDBSchema">
			<select>
				<xsl:choose>
					<xsl:when test="contains(upper-case($tmpDataSource/@driverClass),'TERADATA')">						
						<xsl:text></xsl:text>
					</xsl:when>					
					<xsl:when test="contains(upper-case($tmpDataSource/@url),'INTEGRATEDSECURITY')">
						<xsl:text></xsl:text>
					</xsl:when>										
					<xsl:otherwise>
						<xsl:value-of select="$tmpDataSource/@user"/>
						<xsl:text>.</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</select>
		</xsl:variable>
		
		
<!-- (SystemTable) -->
    <step id="JDBC Reader [{@system} {@name}]" className="com.ataccama.dqc.tasks.io.jdbc.read.JdbcReader" disabled="false" mode="NORMAL">
        <properties queryString="select * from {$tmpDBSchema}{@name}" dataSourceName="{$rdmSystemRef/systems/databaseSystems/databaseSystem[@name=current()/@system]/@dataSourceName}">
            <columns>
                <xsl:for-each select="$rdmSystemRef/systems/databaseSystems/databaseSystem/tables/table[@name = current()/@name]/columns/column">
					<jdbcReaderColumn name="{@name}" type="{upper-case(@type)}"/>
				</xsl:for-each>
            </columns>
            <shadowColumns>
                <shadowColumnDef name="keySystemTable" type="STRING"/>
            </shadowColumns>
        </properties>
        <visual-constraints bounds="524,44,-1,-1" layout="vertical"/>
    </step>
    <connection className="com.ataccama.dqc.model.elements.connections.StandardFlowConnection" disabled="false">
        <source step="JDBC Reader [{@system} {@name}]" endpoint="out"/>
        <target step="Key [{@system} {@name}]" endpoint="in"/>
    </connection>



<!-- (extract {@name}) -->
    <step id="Extract [{@system} {@name}]" className="com.ataccama.dqc.tasks.io.text.read.TextFileReader" disabled="false" mode="NORMAL">
        <properties stringQualifier="&quot;" lineSeparator="\r\n" fieldSeparator=";" lineMaxReadLength="65536" numberOfLinesInHeader="1" fileName="extract_{@name}.txt" encoding="UTF-8" numberOfLinesInFooter="0" stringQualifierEscape="&quot;">
            <columns>
                <xsl:for-each select="$rdmTableRef/logicalModel/tables/table[@name=$rdmSystemRef/systems/databaseSystems/databaseSystem[@name=current()/@system]/tables/table[@name=current()/@name]/@synchronizeWith]/columns/column">
					<xsl:apply-templates select="." mode="dqcStepMapping"/>
				</xsl:for-each>
					<textReaderColumn name="change_type" type="STRING" ignore="false"/>
    				<textReaderColumn name="primary_key" type="LONG" ignore="false"/>
    				<textReaderColumn name="hcn" type="LONG" ignore="false"/>
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
            <shadowColumns>
                <shadowColumnDef name="id_rdm" type="LONG"/>
                <shadowColumnDef name="id_rdm2" type="LONG"/>
                <shadowColumnDef name="keyRdmTable" type="STRING"/>
            </shadowColumns>
        </properties>
    </step>
    <connection className="com.ataccama.dqc.model.elements.connections.StandardFlowConnection" disabled="false">
        <source step="Extract [{@system} {@name}]" endpoint="out"/>
        <target step="Key Rdm [{@system} {@name}]" endpoint="in"/>
    </connection>



<!-- (Key Rdm) --><step id="Key Rdm [{@system} {@name}]" className="com.ataccama.dqc.tasks.expressions.ColumnAssigner" disabled="false" mode="NORMAL">
        <properties>
            <assignments>
            	<assignment column="keyRdmTable">
            	
            	<xsl:attribute name="expression">
             	<xsl:for-each select="$rdmSystemRef/systems/databaseSystems/databaseSystem/tables/table[@name = current()/@name]/rdmKey/rdmSystemRel">
             		<xsl:if test="position()!=last()">
             			<xsl:text>toString(</xsl:text><xsl:value-of select="@rdmColumn"/><xsl:text>) + '#' + </xsl:text>
             		</xsl:if>
             		<xsl:if test="position()=last()">
             			<xsl:text>toString(</xsl:text><xsl:value-of select="@rdmColumn"/><xsl:text>)</xsl:text>
             		</xsl:if>
             	</xsl:for-each>
             	</xsl:attribute>
                    <scorer>
                        <scoringEntries>
                            <scoringEntry score="0" explainAs="CA_CHANGED" explain="false" key="CA_CHANGED"/>
                        </scoringEntries>
                    </scorer>
                </assignment>
            </assignments>
        </properties>
    </step>
    <connection className="com.ataccama.dqc.model.elements.connections.StandardFlowConnection" disabled="false">
        <source step="Key Rdm [{@system} {@name}]" endpoint="out"/>
        <target step="Join [{@system} {@name}]" endpoint="in_left"/>
        <visual-constraints>
            <bendpoints/>
        </visual-constraints>
    </connection>



<!-- (Key [{@system} {@name}]) --><step id="Key [{@system} {@name}]" className="com.ataccama.dqc.tasks.expressions.ColumnAssigner" disabled="false" mode="NORMAL">
        <properties>
            <assignments>
            	<assignment column="keySystemTable">
                    <xsl:attribute name="expression">
             		<xsl:for-each select="$rdmSystemRef/systems/databaseSystems/databaseSystem/tables/table[@name = current()/@name]/rdmKey/rdmSystemRel">
             			<xsl:if test="position()!=last()">
             				<xsl:text>toString(</xsl:text><xsl:value-of select="@systemColumn"/><xsl:text>) + '#' + </xsl:text>
             			</xsl:if>
             			<xsl:if test="position()=last()">
             				<xsl:text>toString(</xsl:text><xsl:value-of select="@systemColumn"/><xsl:text>)</xsl:text>
             			</xsl:if>
             		</xsl:for-each>
             		</xsl:attribute>
                    <scorer>
                        <scoringEntries>
                            <scoringEntry score="0" explainAs="CA_CHANGED" explain="false" key="CA_CHANGED"/>
                        </scoringEntries>
                    </scorer>
                </assignment>
            </assignments>
        </properties>
    </step>
    <connection className="com.ataccama.dqc.model.elements.connections.StandardFlowConnection" disabled="false">
        <source step="Key [{@system} {@name}]" endpoint="out"/>
        <target step="Join [{@system} {@name}]" endpoint="in_right"/>
        <visual-constraints>
            <bendpoints/>
        </visual-constraints>
    </connection>


<!-- (Join) -->
    <step id="Join [{@system} {@name}]" className="com.ataccama.dqc.tasks.merge.Join" disabled="false" mode="NORMAL">
        <properties leftKey="keyRdmTable" matchStrategy="MERGE" rightKey="keySystemTable" joinType="OUTER">
            <columnDefinitions>
                <xsl:for-each select="$rdmTableRef/logicalModel/tables/table[@name=$rdmSystemRef/systems/databaseSystems/databaseSystem[@name=current()/@system]/tables/table[@name=current()/@name]/@synchronizeWith]/columns/column">
					<columnDefinition expression="in_left.{@name}" name="rdm_{@name}"/>
				</xsl:for-each>
					<columnDefinition expression="in_left.change_type" name="rdm_change_type"/>
    				<columnDefinition expression="in_left.primary_key" name="rdm_primary_key"/>
    				<columnDefinition expression="in_left.hcn" name="rdm_hcn"/>
                
                	<xsl:for-each select="$rdmSystemRef/systems/databaseSystems/databaseSystem/tables/table[@name = current()/@name]/columns/column">
					<columnDefinition expression="in_right.{@name}" name="{@name}"/>
				</xsl:for-each>
            </columnDefinitions>
        </properties>
    </step>
    <connection className="com.ataccama.dqc.model.elements.connections.StandardFlowConnection" disabled="false">
        <source step="Join [{@system} {@name}]" endpoint="out"/>
        <target step="Rdm Merge Importer [{@system} {@name}]" endpoint="in"/>
    </connection>


<!-- (Rdm Merge Importer) -->
    <step id="Rdm Merge Importer [{@system} {@name}]" className="com.ataccama.rdm.manager.steps.RdmMergeInputDataStep" disabled="false" mode="NORMAL">
        <properties tablename="{$rdmSystemRef/systems/databaseSystems/databaseSystem[@name=current()/@system]/tables/table[@name=current()/@name]/@synchronizeWith}" inputName="{@system}_{@name}" url="{$rdmAppVariablesRef/@connectionName}">
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
            <columns>
            	<mrg:mergeChildren key="@name">
	                <xsl:for-each select="$rdmSystemRef/systems/databaseSystems/databaseSystem/tables/table[@name = current()/@name]/columns/column">
	                	<xsl:if test="@mappedColumn !=''">
	                		<xsl:apply-templates select="." mode="rdmStepMapping"/>
	                	</xsl:if>
	                	<xsl:if test="string-length(@mappedColumn) = 0">
	                		<xsl:apply-templates select="." mode="rdmStepMappingNull"/>
	                	</xsl:if>
	                </xsl:for-each>
	                <rdmMergeInputDataStepColumnMapping columnType="PRIMARY_KEY" name="generatedPk" type="LONG_INTEGER" inColumn="rdm_primary_key"/>
                </mrg:mergeChildren>
            </columns>
        </properties>
    </step>
    
    <connection className="com.ataccama.dqc.model.elements.connections.StandardFlowConnection" disabled="false">
        <source step="Multiplicator Parameter" endpoint="out"/>
        <target step="Rdm Merge Importer [{@system} {@name}]" endpoint="parameters"/>
        <visual-constraints>
            <bendpoints/>
        </visual-constraints>
    </connection>
		
	</xsl:for-each>
	
	<xsl:if test="$useUrlResourcesForAuthentication='Pass Credentials Manually' or ($useUrlResourcesForAuthentication='Use global settings (from App Variables)' and $rdmAppVariablesRef/@useUrlResourcesForAuthentication='Pass Credentials Manually')">
		<!-- (getParametresDomains) -->
	    <step id="{$syncTaskName} Output Parameters" className="com.ataccama.dqc.tasks.io.text.read.TextFileReader" disabled="false" mode="NORMAL">
	        <properties stringQualifier="&quot;" lineSeparator="\r\n" fieldSeparator=";" lineMaxReadLength="65536" numberOfLinesInHeader="1" fileName="{$syncTaskName}_parameters.txt" encoding="UTF-8" numberOfLinesInFooter="0" stringQualifierEscape="&quot;">
	            <columns>
	                <textReaderColumn name="id" type="LONG" ignore="false">
	                    <dataFormatParameters thousandsSeparator="" decimalSeparator="."/>
	                </textReaderColumn>
	                <textReaderColumn name="type" type="STRING" ignore="false"/> 
		        	<xsl:choose>
		        		<xsl:when test="@useUrlResourcesForAuthentication='Use App Connection Credentials'">  
				        	<textReaderColumn name="username" type="STRING" ignore="true"/>
							<textReaderColumn name="password" type="STRING" ignore="true"/>		        		      			
		        		</xsl:when>
		        		<xsl:when test="@useUrlResourcesForAuthentication='Pass Credentials Manually'">
				        	<textReaderColumn name="username" type="STRING" ignore="false"/>
							<textReaderColumn name="password" type="STRING" ignore="false"/>
		        		</xsl:when>        		
		        		<xsl:otherwise>
		        			<xsl:choose>
		        				<xsl:when test="$rdmAppVariablesRef/@useUrlResourcesForAuthentication='Use App Connection Credentials'">        					
						        	<textReaderColumn name="username" type="STRING" ignore="true"/>
									<textReaderColumn name="password" type="STRING" ignore="true"/>		        				
		        				</xsl:when>
		        				<xsl:otherwise>
						        	<textReaderColumn name="username" type="STRING" ignore="false"/>
									<textReaderColumn name="password" type="STRING" ignore="false"/>
		        				</xsl:otherwise>
		        			</xsl:choose>
		        		</xsl:otherwise>
		        	</xsl:choose>	                         
	                <textReaderColumn name="timestamp" type="DATETIME" ignore="false">
	                    <dataFormatParameters thousandsSeparator="" dateFormatLocale="en_US" dateTimeFormat="yyyy-MM-dd HH:mm:ss"/>
	                </textReaderColumn>
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
	        </properties>
	    </step>
	    
	    <connection className="com.ataccama.dqc.model.elements.connections.StandardFlowConnection" disabled="false">
	        <source step="{$syncTaskName} Output Parameters" endpoint="out"/>
	        <target step="Multiplicator Parameter" endpoint="in"/>
	        <visual-constraints>
	            <bendpoints/>
	        </visual-constraints>
	    </connection>
	
	<!-- (Multiplicator Param) -->
	    <step id="Multiplicator Parameter" className="com.ataccama.dqc.tasks.flow.Multiplicator" disabled="false" mode="NORMAL" create="false">
	        <properties/>
	        <visual-constraints bounds="336,384,-1,-1" layout="vertical"/>
	    </step>
	</xsl:if>

	</purity-config>
</xsl:template>

<xsl:template match="column" mode="dqcStepMapping">
	<xsl:variable name="tmpType">
        <xsl:if test="$rdmTableRef/logicalModel/domains/domain[@name=current()/@domain]/@type='MNREFERENCES'">STRING</xsl:if>
        <xsl:if test="$rdmTableRef/logicalModel/domains/domain[@name=current()/@domain]/@type!='MNREFERENCES'"><xsl:value-of select="$rdmTableRef/logicalModel/domains/domain[@name=current()/@domain]/@type"/></xsl:if>
    </xsl:variable>
	<textReaderColumn name="{@name}" type="{upper-case($tmpType)}" ignore="false"/>
</xsl:template>

<xsl:template match="column" mode="rdmStepMapping">
	<xsl:variable name="tmpType">
        <xsl:choose>
	        <xsl:when test="$rdmTableRef/logicalModel/domains/domain[@name=$rdmTableRef/logicalModel/tables/table[@name=current()/../../@synchronizeWith]/columns/column[@name=current()/@mappedColumn]/@domain]/@type='LONG'">LONG_INTEGER</xsl:when>
	        <xsl:when test="$rdmTableRef/logicalModel/domains/domain[@name=$rdmTableRef/logicalModel/tables/table[@name=current()/../../@synchronizeWith]/columns/column[@name=current()/@mappedColumn]/@domain]/@type='MNREFERENCES'">STRING</xsl:when>
	        <xsl:otherwise><xsl:value-of select="$rdmTableRef/logicalModel/domains/domain[@name=$rdmTableRef/logicalModel/tables/table[@name=current()/../../@synchronizeWith]/columns/column[@name=current()/@mappedColumn]/@domain]/@type"/></xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<rdmMergeInputDataStepColumnMapping mrg:retainNodes="@inColumn" columnType="NORMAL" name="{@mappedColumn}" type="{upper-case($tmpType)}" inColumn="{@name}"/>
</xsl:template>

<xsl:template match="column" mode="rdmStepMappingNull">
	<xsl:variable name="tmpType">
        <xsl:choose>
	        <xsl:when test="$rdmTableRef/logicalModel/domains/domain[@name=$rdmTableRef/logicalModel/tables/table[@name=current()/../../@synchronizeWith]/columns/column[@name=current()/@mappedColumn]/@domain]/@type='LONG'">LONG_INTEGER</xsl:when>
	        <xsl:when test="$rdmTableRef/logicalModel/domains/domain[@name=$rdmTableRef/logicalModel/tables/table[@name=current()/../../@synchronizeWith]/columns/column[@name=current()/@mappedColumn]/@domain]/@type='MNREFERENCES'">STRING</xsl:when>
	        <xsl:otherwise><xsl:value-of select="$rdmTableRef/logicalModel/domains/domain[@name=$rdmTableRef/logicalModel/tables/table[@name=current()/../../@synchronizeWith]/columns/column[@name=current()/@mappedColumn]/@domain]/@type"/></xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
    <rdmMergeInputDataStepColumnMapping mrg:retainNodes="@inColumn" columnType="NORMAL" name="{@name}" type="{upper-case($tmpType)}" inColumn="{@name}"/>
</xsl:template>

<!--  
<xsl:template match="column" mode="rdmStepMappingNull">
	<xsl:variable name="tmpType">
        <xsl:if test="@type='long'">LONG_INTEGER</xsl:if>
        <xsl:if test="@type!='long'"><xsl:value-of select="@type"/></xsl:if>
    </xsl:variable>
	<rdmMergeInputDataStepColumnMapping columnType="NORMAL" name="''" type="{upper-case($tmpType)}" inColumn="{@name}"/>
</xsl:template>
-->

</xsl:stylesheet>