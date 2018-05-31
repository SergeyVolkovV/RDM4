<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:sf="http://www.ataccama.com/xslt/functions"
 xmlns:exsl="http://exslt.org/common" extension-element-prefixes="exsl sf">
  <xsl:output method="xml" encoding="UTF-8" indent="yes"/>

<xsl:param name="rdmTableRef" select="document('param:rdmTableRef')"/>
<xsl:param name="rdmAppVariablesRef" select="document('param:rdmAppVariablesRef')/*"/>
<xsl:param name="rdmSystemRef" select="document('param:rdmSystemRef')"/>
<xsl:param name="rdmDataSourceRef" select="document('param:rdmDataSourceRef')"/>

<xsl:include href="constants_incl.xsl"/>

<xsl:template match="/*">
	<purity-config version="{$rdm_version}">
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
		
	<!-- (Condition change_type = 'CHANGED') -->
	    <step id="Condition change_type = CHANGED [{@system} {@name}]" className="com.ataccama.dqc.tasks.conditions.Condition" disabled="false" mode="NORMAL">
	        <properties condition="rdm_change_type = &#39;CHANGED&#39;"/>
	        <visual-constraints bounds="116,284,-1,-1" layout="vertical"/>
	    </step>
	    <connection className="com.ataccama.dqc.model.elements.connections.StandardFlowConnection" disabled="false">
	        <source step="Condition change_type = CHANGED [{@system} {@name}]" endpoint="out_true"/>
	        <target step="Condition increment change_type = CHANGED - not in system [{@system} {@name}]" endpoint="in"/>
	    </connection>
	    <connection className="com.ataccama.dqc.model.elements.connections.StandardFlowConnection" disabled="false">
	        <source step="Condition change_type = CHANGED [{@system} {@name}]" endpoint="out_false"/>
	        <target step="Condition increment change_type = DELETED [{@system} {@name}]" endpoint="in"/>
	    </connection>
	
	
	
	<!-- (Condition change_type = 'NEW') -->
	    <step id="Condition change_type = NEW [{@system} {@name}]" className="com.ataccama.dqc.tasks.conditions.Condition" disabled="false" mode="NORMAL">
	        <properties condition="rdm_change_type = &#39;NEW&#39;"/>
	        <visual-constraints bounds="260,212,-1,-1" layout="vertical"/>
	    </step>
	    <connection className="com.ataccama.dqc.model.elements.connections.StandardFlowConnection" disabled="false">
	        <source step="Condition change_type = NEW [{@system} {@name}]" endpoint="out_false"/>
	        <target step="Condition change_type = CHANGED [{@system} {@name}]" endpoint="in"/>
	    </connection>
	    <connection className="com.ataccama.dqc.model.elements.connections.StandardFlowConnection" disabled="false">
	        <source step="Condition change_type = NEW [{@system} {@name}]" endpoint="out_true"/>
	        <target step="Filter increment change_type = NEW [{@system} {@name}]" endpoint="in"/>
	    </connection>
	
	
	
	<!-- (Condition increment change_type = 'CHANGED' not in system) -->
	    <step id="Condition increment change_type = CHANGED - not in system [{@system} {@name}]" className="com.ataccama.dqc.tasks.conditions.Condition" disabled="false" mode="NORMAL">
	        <properties condition="keySystemTable is null"/>
	        <visual-constraints bounds="260,356,-1,-1" layout="vertical"/>
	    </step>
	    <connection className="com.ataccama.dqc.model.elements.connections.StandardFlowConnection" disabled="false">
	        <source step="Condition increment change_type = CHANGED - not in system [{@system} {@name}]" endpoint="out_false"/>
	        <target step="Filter increment change_type = CHANGED [{@system} {@name}]" endpoint="in"/>
	    </connection>
	    <connection className="com.ataccama.dqc.model.elements.connections.StandardFlowConnection" disabled="false">
	        <source step="Condition increment change_type = CHANGED - not in system [{@system} {@name}]" endpoint="out_true"/>
	        <target step="Insert change_type = CHANGED [{@system} {@name}]" endpoint="in"/>
	    </connection>
	
	
	
	<!-- (Condition increment change_type = 'DELETED' ) -->
	    <step id="Condition increment change_type = DELETED [{@system} {@name}]" className="com.ataccama.dqc.tasks.conditions.Condition" disabled="false" mode="NORMAL">
	        <properties condition="rdm_change_type = &#39;DELETED&#39;"/>
	    </step>
	    <connection className="com.ataccama.dqc.model.elements.connections.StandardFlowConnection" disabled="false">
	        <source step="Condition increment change_type = DELETED [{@system} {@name}]" endpoint="out_false"/>
	        <target step="Join parameters type [{@system} {@name}]" endpoint="in_right"/>
	    </connection>
	    <connection className="com.ataccama.dqc.model.elements.connections.StandardFlowConnection" disabled="false">
	        <source step="Condition increment change_type = DELETED [{@system} {@name}]" endpoint="out_true"/>
	        <target step="Delete increment change_type = DELETED [{@system} {@name}]" endpoint="in"/>
	    </connection>
	
	<!-- (Filter increment change_type = 'CHANGE') -->
	    <step id="Filter increment change_type = CHANGED [{@system} {@name}]" className="com.ataccama.dqc.tasks.conditions.Filter" disabled="false" mode="NORMAL">
	        <properties>
	            <condition>
	            	<xsl:for-each select="$rdmSystemRef/systems/databaseSystems/databaseSystem[@name = current()/@system]/tables/table[@name = current()/@name]/columns/column[@mappedColumn != '']">
	            		<xsl:variable name="next_column" select="following-sibling::column[@mappedColumn != ''][1]/@name"/>
	            		<xsl:if test="($next_column != '')">    
	            			<xsl:value-of select="@name"/><xsl:text> != rdm_</xsl:text><xsl:value-of select="@mappedColumn"/><xsl:text> or </xsl:text>
	            		</xsl:if>
	            		<xsl:if test="not($next_column != '')">    
	            			<xsl:value-of select="@name"/><xsl:text> != rdm_</xsl:text><xsl:value-of select="@mappedColumn"/><xsl:text></xsl:text>
	            		</xsl:if>
	            	</xsl:for-each>
	            </condition>
	        </properties>
	    </step>
	    <connection className="com.ataccama.dqc.model.elements.connections.StandardFlowConnection" disabled="false">
	        <source step="Filter increment change_type = CHANGED [{@system} {@name}]" endpoint="out"/>
	        <target step="Update change_type = CHANGED [{@system} {@name}]" endpoint="in"/>
	    </connection>
	
	
	
	<!-- (Filter increment change_type = 'NEW') -->
	    <step id="Filter increment change_type = NEW [{@system} {@name}]" className="com.ataccama.dqc.tasks.conditions.Filter" disabled="false" mode="NORMAL">
	        <properties condition="keySystemTable is null"/>
	    </step>
	    <connection className="com.ataccama.dqc.model.elements.connections.StandardFlowConnection" disabled="false">
	        <source step="Filter increment change_type = NEW [{@system} {@name}]" endpoint="out"/>
	        <target step="Insert change_type = NEW [{@system} {@name}]" endpoint="in"/>
	    </connection>
	
	
	
	<!-- (Filter parameters type= 'FULL') -->
	    <step id="Filter parameters type = FULL [{@system} {@name}]" className="com.ataccama.dqc.tasks.conditions.Filter" disabled="false" mode="NORMAL">
	        <properties condition="parameters_type = &#39;FULL&#39;"/>
	    </step>
	    <connection className="com.ataccama.dqc.model.elements.connections.StandardFlowConnection" disabled="false">
	        <source step="Filter parameters type = FULL [{@system} {@name}]" endpoint="out"/>
	        <target step="Delete change_type = DELETED [{@system} {@name}]" endpoint="in"/>
	    </connection>
	    
	    
	
	
	<!-- (SystemTable) -->
	    <step id="JDBC Reader [{@system} {@name}]" className="com.ataccama.dqc.tasks.io.jdbc.read.JdbcReader" disabled="false" mode="NORMAL">
	        <properties queryString="select * from {$tmpDBSchema}{@name}" dataSourceName="{$rdmSystemRef/systems/databaseSystems/databaseSystem[@name=current()/@system]/@dataSourceName}">
	            <columns>
	                <xsl:for-each select="$rdmSystemRef/systems/databaseSystems/databaseSystem[@name=current()/@system]/tables/table[@name=current()/@name]/columns/column">
						
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
	
	
	
	<!-- (Output Parameters {@name}) -->
	    <step id="{$rdmTableRef/logicalModel/tables/table[@name = $rdmSystemRef/systems/databaseSystems/databaseSystem[@name = current()/@system]/tables/table[@name = current()/@name]/@synchronizeWith]/@name} sync Output Parameters [{@system} {@name}]" className="com.ataccama.dqc.tasks.io.text.read.TextFileReader" disabled="false" mode="NORMAL">
	        <properties stringQualifier="&quot;" lineSeparator="\r\n" fieldSeparator=";" lineMaxReadLength="65536" numberOfLinesInHeader="1" fileName="{ancestor::syncDatabaseTask/@name}_parameters.txt" encoding="UTF-8" numberOfLinesInFooter="0" stringQualifierEscape="&quot;">
	            <columns>
    				<textReaderColumn name="id" type="LONG" ignore="true"/>
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
    				<textReaderColumn name="timestamp" type="DATETIME" ignore="falstrue"/>
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
	            </shadowColumns>
	        </properties>
	    </step>
	    <connection className="com.ataccama.dqc.model.elements.connections.StandardFlowConnection" disabled="false">
	        <source step="{$rdmTableRef/logicalModel/tables/table[@name = $rdmSystemRef/systems/databaseSystems/databaseSystem[@name = current()/@system]/tables/table[@name = current()/@name]/@synchronizeWith]/@name} sync Output Parameters [{@system} {@name}]" endpoint="out"/>
	        <target step="Join parameters type [{@system} {@name}]" endpoint="in_left"/>
	    </connection>
	
	
	
	<!-- (Key Rdm) --><step id="Key Rdm [{@system} {@name}]" className="com.ataccama.dqc.tasks.expressions.ColumnAssigner" disabled="false" mode="NORMAL">
	        <properties>
	            <assignments>
	            	<assignment column="keyRdmTable">
	            	
	            	<xsl:attribute name="expression">
	             	<xsl:for-each select="$rdmSystemRef/systems/databaseSystems/databaseSystem/tables/table[@name = current()/@name]/rdmKey/rdmSystemRel">
	             		<xsl:if test="position()!=last()">
	             			<xsl:text>toString(</xsl:text><xsl:value-of select="(@rdmColumn)"/><xsl:text>) + '#' + </xsl:text>
	             		</xsl:if>
	             		<xsl:if test="position()=last()">
	             			<xsl:text>toString(</xsl:text><xsl:value-of select="(@rdmColumn)"/><xsl:text>)</xsl:text>
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
	             				<xsl:text>toString(</xsl:text><xsl:value-of select="(@systemColumn)"/><xsl:text>) + '#' + </xsl:text>
	             			</xsl:if>
	             			<xsl:if test="position()=last()">
	             				<xsl:text>toString(</xsl:text><xsl:value-of select="(@systemColumn)"/><xsl:text>)</xsl:text>
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
	                	<columnDefinition expression="in_right.keySystemTable" name="keySystemTable"/>
						<columnDefinition expression="in_left.keyRdmTable" name="keyRdmTable"/>
	                <xsl:for-each select="$rdmTableRef/logicalModel/tables/table[@name=$rdmSystemRef/systems/databaseSystems/databaseSystem[@name=current()/@system]/tables/table[@name=current()/@name]/@synchronizeWith]/columns/column">
						<columnDefinition expression="in_left.{@name}" name="rdm_{@name}"/>
					</xsl:for-each>
						<columnDefinition expression="in_left.change_type" name="rdm_change_type"/>
	    				<columnDefinition expression="in_left.primary_key" name="rdm_primary_key"/>
	    				<columnDefinition expression="in_left.hcn" name="rdm_hcn"/>	                
	                <xsl:for-each select="$rdmSystemRef/systems/databaseSystems/databaseSystem[@name = current()/@system]/tables/table[@name = current()/@name]/columns/column">
						<columnDefinition expression="in_right.{@name}" name="{@name}"/>
					</xsl:for-each>
	            </columnDefinitions>
	        </properties>
	    </step>
	    <connection className="com.ataccama.dqc.model.elements.connections.StandardFlowConnection" disabled="false">
	        <source step="Join [{@system} {@name}]" endpoint="out"/>
	        <target step="Condition change_type = NEW [{@system} {@name}]" endpoint="in"/>
	    </connection>
	
	
	
	<!-- (Join type) -->
	    <step id="Join parameters type [{@system} {@name}]" className="com.ataccama.dqc.tasks.merge.Join" disabled="false" mode="NORMAL">
	        <properties leftKey="true" matchStrategy="HASH_LEFT" rightKey="true" joinType="RIGHT">
	            <columnDefinitions>
	                	<columnDefinition expression="in_left.type" name="parameters_type"/>                
	                <xsl:for-each select="$rdmSystemRef/systems/databaseSystems/databaseSystem[@name = current()/@system]/tables/table[@name = current()/@name]/columns/column">
						<columnDefinition expression="in_right.{@name}" name="{@name}"/>
					</xsl:for-each>
	            </columnDefinitions>
	        </properties>
	    </step>
	    <connection className="com.ataccama.dqc.model.elements.connections.StandardFlowConnection" disabled="false">
	        <source step="Join parameters type [{@system} {@name}]" endpoint="out"/>
	        <target step="Filter parameters type = FULL [{@system} {@name}]" endpoint="in"/>
	    </connection>
	
	
	
	<!-- (delete change_type = DELETE) -->
	    <step id="Delete change_type = DELETED [{@system} {@name}]" className="com.ataccama.dqc.tasks.jdbc.execute.SQLExecute" disabled="false" mode="NORMAL">
	        <properties commitSize="0" batchSize="1000"  dataSourceName="{$rdmSystemRef/systems/databaseSystems/databaseSystem[@name = current()/@system]/@dataSourceName}">
	            <query>
	            	<xsl:text>delete from </xsl:text>
	            	<xsl:value-of select="$tmpDBSchema"/>
	            	<xsl:value-of select="@name"/>
	            	<xsl:text> where </xsl:text>
	            		<xsl:for-each select="$rdmSystemRef/systems/databaseSystems/databaseSystem[@name = current()/@system]/tables/table[@name = current()/@name]/rdmKey/rdmSystemRel">
	            		<xsl:if test="position()!=last()">
	            			<xsl:value-of select="@systemColumn"/><xsl:text> = ${</xsl:text><xsl:value-of select="@systemColumn"/><xsl:text>} and </xsl:text>
	            		</xsl:if>
	            		<xsl:if test="position()=last()">
	            			<xsl:value-of select="@systemColumn"/><xsl:text> = ${</xsl:text><xsl:value-of select="@systemColumn"/><xsl:text>}</xsl:text>
	            		</xsl:if>
	            		</xsl:for-each>           	
	            </query>    
	        </properties>
	    </step>
	
	<!-- (delete increment change_type = DELETE) -->
	    <step id="Delete increment change_type = DELETED [{@system} {@name}]" className="com.ataccama.dqc.tasks.jdbc.execute.SQLExecute" disabled="false" mode="NORMAL">
	        <properties commitSize="0" batchSize="1000"  dataSourceName="{$rdmSystemRef/systems/databaseSystems/databaseSystem[@name = current()/@system]/@dataSourceName}">
	            <query>
	            	<xsl:text>delete from </xsl:text>
	            	<xsl:value-of select="$tmpDBSchema"/>
	            	<xsl:value-of select="@name"/>
	            	<xsl:text> where </xsl:text>
	            		<xsl:for-each select="$rdmSystemRef/systems/databaseSystems/databaseSystem[@name = current()/@system]/tables/table[@name = current()/@name]/rdmKey/rdmSystemRel">
	            		<xsl:if test="position()!=last()">
	            			<xsl:value-of select="@systemColumn"/><xsl:text> = ${rdm_</xsl:text><xsl:value-of select="@rdmColumn"/><xsl:text>} and </xsl:text>
	            		</xsl:if>
	            		<xsl:if test="position()=last()">
	            			<xsl:value-of select="@systemColumn"/><xsl:text> = ${rdm_</xsl:text><xsl:value-of select="@rdmColumn"/><xsl:text>}</xsl:text>
	            		</xsl:if>
	            		</xsl:for-each>           	
	            </query>    
	        </properties>
	    </step>
	
	
	<!-- (update change_type = 'CHANGED') -->
	    <step id="Update change_type = CHANGED [{@system} {@name}]" className="com.ataccama.dqc.tasks.jdbc.execute.SQLExecute" disabled="false" mode="NORMAL">
	        <properties commitSize="0" batchSize="1000"  dataSourceName="{$rdmSystemRef/systems/databaseSystems/databaseSystem[@name = current()/@system]/@dataSourceName}">
	            <query>
	            	<xsl:text>update </xsl:text><xsl:value-of select="$tmpDBSchema"/><xsl:value-of select="@name"/><xsl:text> set </xsl:text>
	            		<xsl:for-each select="$rdmSystemRef/systems/databaseSystems/databaseSystem[@name = current()/@system]/tables/table[@name = current()/@name]/columns/column[@mappedColumn != '']">
	            			<xsl:variable name="next_column" select="following-sibling::column[@mappedColumn != ''][1]/@name"/>             		
	             				<xsl:if test="($next_column != '')">
	             					<xsl:value-of select="@name"/><xsl:text> = ${rdm_</xsl:text><xsl:value-of select="@mappedColumn"/><xsl:text>}, </xsl:text>
	             				</xsl:if>
	             				<xsl:if test="not($next_column != '')"> 
	             					<xsl:value-of select="@name"/><xsl:text> = ${rdm_</xsl:text><xsl:value-of select="@mappedColumn"/><xsl:text>}</xsl:text>
	             				</xsl:if>
	             		</xsl:for-each>
	             	
	             	<xsl:text> where </xsl:text>
	            		<xsl:for-each select="$rdmSystemRef/systems/databaseSystems/databaseSystem[@name = current()/@system]/tables/table[@name = current()/@name]/rdmKey/rdmSystemRel">
	            		<xsl:if test="position()!=last()">
	            			<xsl:value-of select="@systemColumn"/><xsl:text> = ${rdm_</xsl:text><xsl:value-of select="@rdmColumn"/><xsl:text>} and </xsl:text>
	            		</xsl:if>
	            		<xsl:if test="position()=last()">
	            			<xsl:value-of select="@systemColumn"/><xsl:text> = ${rdm_</xsl:text><xsl:value-of select="@rdmColumn"/><xsl:text>}</xsl:text>
	            		</xsl:if>
	            		</xsl:for-each> 
	            </query>
	        </properties>
	    </step> 
	    
	    
	    
	<!-- (insert change_type = 'CHANGED') -->
	    <step id="Insert change_type = CHANGED [{@system} {@name}]" className="com.ataccama.dqc.tasks.jdbc.execute.SQLExecute" disabled="false" mode="NORMAL">
	        <properties commitSize="0" batchSize="1000"  dataSourceName="{$rdmSystemRef/systems/databaseSystems/databaseSystem[@name = current()/@system]/@dataSourceName}">
	            <query>
	            	<xsl:text>insert into </xsl:text><xsl:value-of select="$tmpDBSchema"/><xsl:value-of select="@name"/><xsl:text> (</xsl:text>
	            		<xsl:for-each select="$rdmSystemRef/systems/databaseSystems/databaseSystem[@name = current()/@system]/tables/table[@name = current()/@name]/columns/column[@mappedColumn != '']">
	            			<xsl:variable name="next_column" select="following-sibling::column[@mappedColumn != ''][1]/@name"/>
	            				<xsl:if test="($next_column != '')">    
	            					<xsl:value-of select="@name"/><xsl:text>, </xsl:text>
	            				</xsl:if>
	            				<xsl:if test="not($next_column != '')">    
	            					<xsl:value-of select="@name"/><xsl:text></xsl:text>
	            				</xsl:if>
	            		</xsl:for-each>
	            	
	            	<xsl:text> ) values (</xsl:text>
	            		<xsl:for-each select="$rdmSystemRef/systems/databaseSystems/databaseSystem[@name = current()/@system]/tables/table[@name = current()/@name]/columns/column[@mappedColumn != '']">
	            			<xsl:variable name="next_column" select="following-sibling::column[@mappedColumn != ''][1]/@name"/>
	             			<xsl:if test="($next_column != '')">
	             				<xsl:text>${rdm_</xsl:text><xsl:value-of select="@mappedColumn"/><xsl:text>}, </xsl:text>
	             			</xsl:if>
	             			<xsl:if test="not($next_column != '')">
	             				<xsl:text>${rdm_</xsl:text><xsl:value-of select="@mappedColumn"/><xsl:text>}</xsl:text>
	             			</xsl:if>
	             		</xsl:for-each>
	            	<xsl:text> )</xsl:text>
				</query>
	        </properties>
	    </step>
	
	
	
	<!-- (insert change_type = 'NEW') -->
	    <step id="Insert change_type = NEW [{@system} {@name}]" className="com.ataccama.dqc.tasks.jdbc.execute.SQLExecute" disabled="false" mode="NORMAL">
	        <properties commitSize="0" batchSize="1000"  dataSourceName="{$rdmSystemRef/systems/databaseSystems/databaseSystem[@name = current()/@system]/@dataSourceName}">
	        	<query>
	            	<xsl:text>insert into </xsl:text><xsl:value-of select="$tmpDBSchema"/><xsl:value-of select="@name"/><xsl:text> (</xsl:text>
	            		<xsl:for-each select="$rdmSystemRef/systems/databaseSystems/databaseSystem[@name = current()/@system]/tables/table[@name = current()/@name]/columns/column[@mappedColumn != '']">
	            			<xsl:variable name="next_column" select="following-sibling::column[@mappedColumn != ''][1]/@name"/>
	            				<xsl:if test="($next_column != '')">    
	            					<xsl:value-of select="@name"/><xsl:text>, </xsl:text>
	            				</xsl:if>
	            				<xsl:if test="not($next_column != '')">    
	            					<xsl:value-of select="@name"/><xsl:text></xsl:text>
	            				</xsl:if>
	            		</xsl:for-each>
	            	
	            	<xsl:text> ) values (</xsl:text>
	            		<xsl:for-each select="$rdmSystemRef/systems/databaseSystems/databaseSystem[@name = current()/@system]/tables/table[@name = current()/@name]/columns/column[@mappedColumn != '']">
	            			<xsl:variable name="next_column" select="following-sibling::column[@mappedColumn != ''][1]/@name"/>
	             			<xsl:if test="($next_column != '')">
	             				<xsl:text>${rdm_</xsl:text><xsl:value-of select="@mappedColumn"/><xsl:text>}, </xsl:text>
	             			</xsl:if>
	             			<xsl:if test="not($next_column != '')">
	             				<xsl:text>${rdm_</xsl:text><xsl:value-of select="@mappedColumn"/><xsl:text>}</xsl:text>
	             			</xsl:if>
	             		</xsl:for-each>
	            	<xsl:text> )</xsl:text>
				</query>    
	        </properties>
	    </step>   
	
	
	<!-- (in) -->
		<step id="in [{@system} {@name}]" className="com.ataccama.dqc.tasks.common.usersteps.io.InputStep" disabled="false" mode="NORMAL">
	        <properties>
	            <columns>
	                <columnDef name="in" type="STRING"/>
	            </columns>
	            <shadowColumns/>
	        </properties>
	    </step>
	    <connection className="com.ataccama.dqc.model.elements.connections.StandardFlowConnection" disabled="false">
	        <source step="in [{@system} {@name}]" endpoint="out"/>
	        <target step="out [{@system} {@name}]" endpoint="in"/>
	        <visual-constraints>
	            <bendpoints/>
	        </visual-constraints>
	    </connection>
	
	
	
	<!-- (out) -->
		<step id="out [{@system} {@name}]" className="com.ataccama.dqc.tasks.common.usersteps.io.OutputStep" disabled="false" mode="NORMAL">
	        <properties>
	            <requiredColumns/>
	        </properties>
	    </step>
	
	

</xsl:for-each>
	</purity-config>
</xsl:template>

<xsl:template match="column" mode="dqcStepMapping">
	<xsl:variable name="tmpType">
        <xsl:if test="$rdmTableRef/logicalModel/domains/domain[@name=current()/@domain]/@type='MNREFERENCES'">STRING</xsl:if>
        <xsl:if test="$rdmTableRef/logicalModel/domains/domain[@name=current()/@domain]/@type!='MNREFERENCES'"><xsl:value-of select="$rdmTableRef/logicalModel/domains/domain[@name=current()/@domain]/@type"/></xsl:if>
    </xsl:variable>
	<textReaderColumn name="{@name}" type="{upper-case($tmpType)}" ignore="false"/>
</xsl:template>
</xsl:stylesheet>