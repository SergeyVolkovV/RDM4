<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:sf="http://www.ataccama.com/xslt/functions"
 xmlns:mrg="http://www.ataccama.com/dqc/plan-merge"
 xmlns:exsl="http://exslt.org/common" extension-element-prefixes="exsl sf">
<xsl:output method="xml" encoding="UTF-8" indent="yes"/>

<xsl:param name="rdmAppVariablesRef" select="document('param:rdmAppVariablesRef')/*"/>
<xsl:param name="logicalModel" select="document('param:logicalModel')/*"/>
<xsl:param name="syncOnlineTaskI" select="document('param:syncOnlineTaskI')/*"/>

<xsl:include href="constants_incl.xsl"/>

<xsl:template match="/*">
	<purity-config version="{$rdm_version}">

<xsl:variable name="tableName" select="@tableName"/>

		<xsl:if test="$syncOnlineTaskI/@useUrlResourcesForAuthentication!='Use App Connection Credentials'">
			<xsl:if test="$syncOnlineTaskI/@useUrlResourcesForAuthentication='Pass Credentials Manually' or $rdmAppVariablesRef/@useUrlResourcesForAuthentication='Pass Credentials Manually'">		
				<step className="com.ataccama.dqc.tasks.common.usersteps.io.InputStep" id="in_parameters">
					<properties>
						<columns>
			                <xsl:choose>
				        		<xsl:when test="$syncOnlineTaskI/@useUrlResourcesForAuthentication='Use App Connection Credentials'">        			
				        		</xsl:when>
				        		<xsl:when test="$syncOnlineTaskI/@useUrlResourcesForAuthentication='Pass Credentials Manually'">
									<columnDef name="username" type="STRING"/>
									<columnDef name="password" type="STRING"/>
				        		</xsl:when>        		
				        		<xsl:otherwise>
				        			<xsl:choose>
				        				<xsl:when test="$rdmAppVariablesRef/@useUrlResourcesForAuthentication='Use App Connection Credentials'">        					
				        				</xsl:when>
				        				<xsl:otherwise>
											<columnDef name="username" type="STRING"/>
											<columnDef name="password" type="STRING"/>		        				
										</xsl:otherwise>
				        			</xsl:choose>
				        		</xsl:otherwise>
				        	</xsl:choose> 													
						</columns>
						<shadowColumns/>
					</properties>
					<visual-constraints layout="vertical" bounds="24,24,-1,-1"/>
				</step>
				<connection className="com.ataccama.dqc.model.elements.connections.StandardFlowConnection" disabled="false">
			        <source step="in_parameters" endpoint="out"/>
			        <target step="Rdm Importer" endpoint="parameters"/>
			        <visual-constraints>
			            <bendpoints/>
			        </visual-constraints>
			    </connection>
			</xsl:if>
		</xsl:if>
		
		<!-- (Input Step) -->
		<step className="com.ataccama.dqc.tasks.common.usersteps.io.InputStep" id="in">
			<properties>
				<columns>			
		        	<xsl:for-each select="$logicalModel/tables/table">
		        		<xsl:variable name="logicalTableName" select="@name"/>
		        		<xsl:if test="$tableName = $logicalTableName">
		                	<xsl:apply-templates select="columns/column" mode="inputStepColumnMapping"/>
		            	</xsl:if>
		            </xsl:for-each>										
				</columns>
				<shadowColumns/>
			</properties>
			<visual-constraints layout="vertical" bounds="216,24,-1,-1"/>
		</step>
		
		<connection className="com.ataccama.dqc.model.elements.connections.StandardFlowConnection" disabled="false">
	        <source step="in" endpoint="out"/>
	        <target step="Rdm Importer" endpoint="in"/>
	        <visual-constraints>
	            <bendpoints/>
	        </visual-constraints>
	    </connection>
 
	<!-- (Rdm Import) -->
    <step id="Rdm Importer" className="com.ataccama.rdm.manager.steps.RdmImportStep" disabled="false" mode="NORMAL">
        <properties mrg:retainNodes="importTable,moveToEditAction,allowedEditStates" tablename="{$tableName}" incremental="{@incremental}" url="{$rdmAppVariablesRef/@connectionName}">
	        	<xsl:choose>
	        		<xsl:when test="$syncOnlineTaskI/@useUrlResourcesForAuthentication='Use App Connection Credentials'">        			
	        		</xsl:when>
	        		<xsl:when test="$syncOnlineTaskI/@useUrlResourcesForAuthentication='Pass Credentials Manually'">
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
	            <xsl:for-each select="$logicalModel/tables/table">
	            	<xsl:variable name="logicalTableName" select="@name"/>
	            	<xsl:if test="$tableName = $logicalTableName">
		            	<xsl:variable name="idGenerators" select="idGenerators"/>
		           		<columns>
		           			<mrg:mergeChildren key="@name">
		               			<xsl:apply-templates select="columns/column[not(@name=$idGenerators/generator/@name)]" mode="rdmStepColumnMapping"/>
		               		</mrg:mergeChildren>
		           		</columns>
	            	</xsl:if>
	            </xsl:for-each>	            
        </properties>
        <visual-constraints layout="vertical" bounds="120,120,-1,-1"/>
    </step>
    <connection className="com.ataccama.dqc.model.elements.connections.StandardFlowConnection" disabled="false">
        <source step="Rdm Importer" endpoint="err"/>
        <target step="Errors" endpoint="in"/>
        <visual-constraints>
            <bendpoints/>
        </visual-constraints>
    </connection> 
  
<!-- (Output Step) -->			
		<step className="com.ataccama.dqc.tasks.common.usersteps.io.OutputStep" id="Errors">
			<properties>
				<requiredColumns>
					<requiredColumn name="lineNo" type="INTEGER"/>
					<requiredColumn name="error" type="STRING"/>
				</requiredColumns>		
			</properties>
			<visual-constraints layout="vertical" bounds="120,216,-1,-1"/>
		</step>

	</purity-config>
</xsl:template>	
	
<xsl:template match="column" mode="rdmStepColumnMapping">
	<xsl:variable name="tmpType">
        <xsl:if test="$logicalModel/domains/domain[@name=current()/@domain]/@type='LONG'">LONG_INTEGER</xsl:if>
        <xsl:if test="$logicalModel/domains/domain[@name=current()/@domain]/@type='MNREFERENCES'">STRING</xsl:if>
        <xsl:if test="$logicalModel/domains/domain[@name=current()/@domain]/@type!='LONG' and $logicalModel/domains/domain[@name=current()/@domain]/@type!='MNREFERENCES'"><xsl:value-of select="$logicalModel/domains/domain[@name=current()/@domain]/@type"/></xsl:if>
    </xsl:variable>
	<rdmImportStepColumnMapping columnType="NORMAL" name="{@name}" type="{upper-case($tmpType)}" inColumn="{@name}"/>
</xsl:template>

<xsl:template match="column" mode="inputStepColumnMapping">
	<xsl:variable name="tmpType">
        <xsl:if test="$logicalModel/domains/domain[@name=current()/@domain]/@type='MNREFERENCES'">STRING</xsl:if>
        <xsl:if test="$logicalModel/domains/domain[@name=current()/@domain]/@type!='MNREFERENCES'"><xsl:value-of select="$logicalModel/domains/domain[@name=current()/@domain]/@type"/></xsl:if>
    </xsl:variable>
	<columnDef name="{@name}" type="{upper-case($tmpType)}"/>
</xsl:template>


</xsl:stylesheet>

    	
        	