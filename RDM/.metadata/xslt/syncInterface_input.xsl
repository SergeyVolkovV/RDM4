<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:sf="http://www.ataccama.com/xslt/functions"
 xmlns:mrg="http://www.ataccama.com/dqc/plan-merge"	
 xmlns:exsl="http://exslt.org/common" extension-element-prefixes="exsl sf">
  <xsl:output method="xml" encoding="UTF-8" indent="yes"/>

<xsl:param name="rdmTableRef" select="document('param:rdmTableRef')"/>
<xsl:param name="rdmAppVariablesRef" select="document('param:rdmAppVariablesRef')/*"/>
<xsl:param name="rdmSystemRef" select="document('param:rdmSystemRef')"/>

<xsl:include href="constants_incl.xsl"/>

<xsl:template match="/*">
	<purity-config version="{$rdm_version}">
	
	<xsl:variable name="systemName" select="syncTaskTables/syncTaskTable/@system"/>
	<xsl:variable name="tableName" select="syncTaskTables/syncTaskTable/@name"/>

<!-- (Add Key) -->
    <step id="Add Key" className="com.ataccama.dqc.tasks.flow.AlterFormat" disabled="false" mode="NORMAL">
        <properties>
            <addedColumns>
                <addedColumn expression="1" name="key" type="INTEGER"/>
            </addedColumns>
            <removedColumns/>
        </properties>
        <visual-constraints bounds="240,240,-1,-1" layout="vertical"/>
    </step>
    <connection className="com.ataccama.dqc.model.elements.connections.StandardFlowConnection" disabled="false">
        <source step="Add Key" endpoint="out"/>
        <target step="Join" endpoint="in_left"/>
        <visual-constraints>
            <bendpoints>
                <point location="263,312"/>
            </bendpoints>
        </visual-constraints>
    </connection>



<!-- (Input Parameters) -->
    <!--  
    <step id="Input Parameters" className="com.ataccama.dqc.tasks.io.text.read.TextFileReader" disabled="false" mode="NORMAL">
        <properties stringQualifier="" lineSeparator="\r\n" fieldSeparator=";" lineMaxReadLength="65536" numberOfLinesInHeader="1" fileName="parameters.txt" encoding="ISO-8859-1" numberOfLinesInFooter="0" stringQualifierEscape="">
            <columns>
                <textReaderColumn name="username" type="STRING" ignore="false"/>
                <textReaderColumn name="password" type="STRING" ignore="false"/>
                <textReaderColumn name="type" type="STRING" ignore="false"/>
                <textReaderColumn name="timestamp" type="DATETIME" ignore="false"/>
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
                <shadowColumnDef name="key" defaultExpression="1" type="INTEGER"/>
            </shadowColumns>
        </properties>
        <visual-constraints bounds="240,24,-1,-1" layout="vertical"/>
    </step>
    <connection className="com.ataccama.dqc.model.elements.connections.StandardFlowConnection" disabled="false">
        <source step="Input Parameters" endpoint="out"/>
        <target step="Multiplicator Input Parameters" endpoint="in"/>
        <visual-constraints>
            <bendpoints/>
        </visual-constraints>
    </connection>
	-->

<!-- (Join) -->
    <step id="Join" className="com.ataccama.dqc.tasks.merge.Join" disabled="false" mode="NORMAL">
        <properties leftKey="key" mrg:retainNodes="rightKey" matchStrategy="MERGE" joinType="LEFT">
            <columnDefinitions>
                <columnDefinition expression="in_left.id" name="id"/>
                <columnDefinition expression="in_right.timestamp" name="timestamp"/>
                <columnDefinition expression="in_right.type" name="type"/>
                <columnDefinition expression="in_right.username" name="username"/>
                <columnDefinition expression="in_right.password" name="password"/>
            </columnDefinitions>
        </properties>
        <visual-constraints bounds="336,312,-1,-1" layout="vertical"/>
    </step>
    <connection className="com.ataccama.dqc.model.elements.connections.StandardFlowConnection" disabled="false">
        <source step="Join" endpoint="out"/>
        <target step="Multiplicator Output Parameters" endpoint="in"/>
        <visual-constraints>
            <bendpoints/>
        </visual-constraints>
    </connection>

<!-- (Multiplicator Input Parameters) -->
    <step id="Multiplicator Input Parameters" className="com.ataccama.dqc.tasks.flow.Multiplicator" disabled="false" mode="NORMAL">
        <properties/>
        <visual-constraints bounds="240,96,-1,-1" layout="vertical"/>
    </step>
    <connection className="com.ataccama.dqc.model.elements.connections.StandardFlowConnection" disabled="false">
        <source step="Multiplicator Input Parameters" endpoint="out"/>
        <target step="Join" endpoint="in_right"/>
        <visual-constraints>
            <bendpoints>
                <point location="429,144"/>
                <point location="429,312"/>
            </bendpoints>
        </visual-constraints>
    </connection>
    <connection className="com.ataccama.dqc.model.elements.connections.StandardFlowConnection" disabled="false">
        <source step="Multiplicator Input Parameters" endpoint="out"/>
        <target step="Rdm Integration Input" endpoint="parameters"/>
        <visual-constraints>
            <bendpoints/>
        </visual-constraints>
    </connection>



<!-- (Multiplicator Output Parameters) -->
    <step id="Multiplicator Output Parameters" className="com.ataccama.dqc.tasks.flow.Multiplicator" disabled="false" mode="NORMAL">
        <properties/>
        <visual-constraints bounds="336,384,-1,-1" layout="vertical"/>
    </step>
    <connection className="com.ataccama.dqc.model.elements.connections.StandardFlowConnection" disabled="false">
        <source step="Multiplicator Output Parameters" endpoint="out"/>
        <target step="Rdm Reader" endpoint="parameters"/>
        <visual-constraints>
            <bendpoints/>
        </visual-constraints>
    </connection>
    <connection className="com.ataccama.dqc.model.elements.connections.StandardFlowConnection" disabled="false">
        <source step="Multiplicator Output Parameters" endpoint="out"/>
        <target step="{@name} Output Parameters" endpoint="in"/>
        <visual-constraints>
            <bendpoints/>
        </visual-constraints>
    </connection>


<!-- (Output Parameters) -->
    <step id="{@name} Output Parameters" className="com.ataccama.dqc.tasks.io.text.write.TextFileWriter" disabled="false" mode="NORMAL">
        <properties useStringQualifierOnAllColumns="false" stringQualifier="&quot;" lineSeparator="\r\n" fieldSeparator=";" generateMetadata="true" fileName="{@name}_parameters.txt" encoding="UTF-8" writeHeader="true" writeAllColumns="false" stringQualifierEscape="&quot;">
            <columns>
                <textWriterColumn name="id"/>
                <textWriterColumn name="type"/>                
                <xsl:choose>
	        		<xsl:when test="@useUrlResourcesForAuthentication='Use App Connection Credentials'">    	        		    			
	        		</xsl:when>
	        		<xsl:when test="@useUrlResourcesForAuthentication='Pass Credentials Manually'">
		                <textWriterColumn name="username"/>
		                <textWriterColumn name="password"/>
	        		</xsl:when>        		
	        		<xsl:otherwise>
	        			<xsl:choose>
	        				<xsl:when test="$rdmAppVariablesRef/@useUrlResourcesForAuthentication='Use App Connection Credentials'">        					
	        				</xsl:when>
	        				<xsl:otherwise>
	        					<textWriterColumn name="username"/>
                				<textWriterColumn name="password"/>
	        				</xsl:otherwise>
	        			</xsl:choose>
	        		</xsl:otherwise>
	        	</xsl:choose>                           
                <textWriterColumn name="timestamp"/>
            </columns>
            <dataFormatParameters trueValue="true" falseValue="false" thousandsSeparator="" dateFormatLocale="en_US" dateTimeFormat="yyyy-MM-dd HH:mm:ss" decimalSeparator="." dayFormat="yyyy-MM-dd"/>
        </properties>
        <visual-constraints bounds="504,432,-1,-1" layout="vertical"/>
    </step>

<!-- (Rdm Integration Input) -->
    <step id="Rdm Integration Input" className="com.ataccama.rdm.manager.steps.RdmStartProcessStep" disabled="false" mode="NORMAL">
        <properties mrg:retainNodes="type" atDate="timestamp" name="{@name}" type="type" url="{$rdmAppVariablesRef/@connectionName}">
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
        </properties>
        <visual-constraints bounds="240,168,-1,-1" layout="vertical"/>
    </step>
    <connection className="com.ataccama.dqc.model.elements.connections.StandardFlowConnection" disabled="false">
        <source step="Rdm Integration Input" endpoint="id"/>
        <target step="Add Key" endpoint="in"/>
        <visual-constraints>
            <bendpoints/>
        </visual-constraints>
    </connection>



<!-- (Rdm Reader) -->
    <step id="Rdm Reader" className="com.ataccama.rdm.manager.steps.RdmGetDataStep" disabled="false" mode="NORMAL">
        <properties idColumn="id" url="{$rdmAppVariablesRef/@connectionName}">
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
            <data>
            	<mrg:mergeChildren key="@name">
	                <xsl:for-each select="$rdmTableRef/logicalModel/tables/table[@name=$rdmSystemRef/systems/databaseSystems/databaseSystem[@name=$systemName]/tables/table[@name=$tableName]/@synchronizeWith]">
	               		<rdmGetDataStepData name="{@name}">
							<columns>
								<xsl:apply-templates select="columns/column"/>
								<rdmStepColumn columnType="CHANGE_TYPE" name="change_type" type="STRING"/>
	   							<rdmStepColumn columnType="PRIMARY_KEY" name="primary_key" type="LONG_INTEGER"/>
	   							<rdmStepColumn columnType="HCN" name="hcn" type="LONG_INTEGER"/>
							</columns>
						</rdmGetDataStepData> 					
					</xsl:for-each>
				</mrg:mergeChildren>
            </data>
        </properties>
        <visual-constraints bounds="336,456,-1,-1" layout="vertical"/>
    </step>
    		
<!-- (Multiplicator Rdm Reader) -->
	<xsl:for-each select="$rdmTableRef/logicalModel/tables/table[@name=$rdmSystemRef/systems/databaseSystems/databaseSystem[@name=$systemName]/tables/table[@name=$tableName]/@synchronizeWith]">
		<connection className="com.ataccama.dqc.model.elements.connections.StandardFlowConnection" disabled="false">
        	<source step="Rdm Reader" endpoint="{@name}"/>
        	<target step="Multiplicator [{@name}]" endpoint="in"/>
    	</connection>
		
		<step id="Multiplicator [{@name}]" className="com.ataccama.dqc.tasks.flow.Multiplicator" disabled="false" mode="NORMAL">
        	<properties/>
    	</step>
	</xsl:for-each>	
	<xsl:apply-templates select="syncTaskTables/syncTaskTable" mode="connection"/>
		
	
</purity-config>
</xsl:template>

<xsl:template match="syncTaskTable" mode="rdmTableMapping">
	<rdmGetDataStepData name="{@name}">
		<columns>
			<xsl:for-each select="column">
			<rdmStepColumn name="{@name}" type="{@type}"/>
			</xsl:for-each>
			<rdmStepColumn columnType="CHANGE_TYPE" name="change_type" type="STRING"/>
    		<rdmStepColumn columnType="PRIMARY_KEY" name="primary_key" type="LONG_INTEGER"/>
    		<rdmStepColumn columnType="HCN" name="hcn" type="LONG_INTEGER"/>
		</columns>
	</rdmGetDataStepData> 
</xsl:template>

<xsl:template match="syncTaskTable" mode="connection">
	<xsl:variable name="tableName" select="@name"/>
	<xsl:variable name="systemName" select="@system"/>
	<xsl:variable name="synchronizeWith" select="$rdmTableRef/logicalModel/tables/table[@name=$rdmSystemRef/systems/databaseSystems/databaseSystem[@name=$systemName]/tables/table[@name=$tableName]/@synchronizeWith]/@name"/>
	<connection className="com.ataccama.dqc.model.elements.connections.StandardFlowConnection" disabled="false">
		<source step="Multiplicator [{$synchronizeWith}]" endpoint="out"/>
    	<target step="Transform/Mapping [{@system} {@name}]" endpoint="in"/>
    </connection>
    
    <!-- (Transform/Mapping Domain Directories) -->
    <step id="Transform/Mapping [{@system} {@name}]" className="com.ataccama.dqc.tasks.expressions.ColumnAssigner" disabled="false" mode="NORMAL">
        <properties>
            <assignments/>
        </properties>
        <visual-constraints bounds="528,480,-1,-1" layout="vertical"/>
    </step>
    <connection className="com.ataccama.dqc.model.elements.connections.StandardFlowConnection" disabled="false">
        <source step="Transform/Mapping [{@system} {@name}]" endpoint="out"/>
        <target step="extract [{@system} {@name}]" endpoint="in"/>
        <visual-constraints>
            <bendpoints/>
        </visual-constraints>
    </connection>
    
    <!-- (out) -->
    <step id="extract [{@system} {@name}]" className="com.ataccama.dqc.tasks.io.text.write.TextFileWriter" disabled="false" mode="NORMAL">
        <properties useStringQualifierOnAllColumns="false" stringQualifier="&quot;" lineSeparator="\r\n" fieldSeparator=";" generateMetadata="true" fileName="extract_{@name}.txt" encoding="UTF-8" writeHeader="true" writeAllColumns="true" stringQualifierEscape="&quot;">
            <columns/>
            <dataFormatParameters trueValue="true" falseValue="false" thousandsSeparator="" dateFormatLocale="en_US" dateTimeFormat="yyyy-MM-dd HH:mm:ss" decimalSeparator="." dayFormat="yyyy-MM-dd"/>
        </properties>
    </step>
</xsl:template>
<xsl:template match="column">
	<xsl:variable name="tmpType">
        <xsl:if test="$rdmTableRef/logicalModel/domains/domain[@name=current()/@domain]/@type='LONG'">LONG_INTEGER</xsl:if>
        <xsl:if test="$rdmTableRef/logicalModel/domains/domain[@name=current()/@domain]/@type='MNREFERENCES'">STRING</xsl:if>
        <xsl:if test="$rdmTableRef/logicalModel/domains/domain[@name=current()/@domain]/@type!='LONG' and $rdmTableRef/logicalModel/domains/domain[@name=current()/@domain]/@type!='MNREFERENCES'"><xsl:value-of select="$rdmTableRef/logicalModel/domains/domain[@name=current()/@domain]/@type"/></xsl:if>
    </xsl:variable>
	<column name="{@name}" type="{upper-case($tmpType)}"/>
</xsl:template>


</xsl:stylesheet>