<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="xml" encoding="UTF-8" indent="yes"/>
<xsl:param name="servers" select="document('param:servers')/*"/>
<xsl:param name="appVariables" select="document('param:appVariables')/*"/>

<xsl:template match="*">
	
<rdm-config>
	<model 	
		hierarchiesConfigFile="hierarchies.xml"
		modelConfigFile="model.xml"
		tasksConfigFile="tasks.xml"
		validatorsConfigFile="validators.xml"
		workflowConfigFile="workflow.xml"
		systemsConfigFile="systems.xml"
		usersConfigFile="users.xml"
		inputsConfigFile="inputs.xml"
		
		appServer="{$servers/genericServer[@name=$appVariables/@connectionName]/@url}"
		pkColumnName="{/metadata/appVariables/@generatedPrimaryKeyName}"
		moveOperationToBackgroundIntervalSecs="10"
		>
		
		<!-- type of supported database -->
		<xsl:if test="/metadata/appVariables/@dbType = 'Apache Derby'">
			<xsl:attribute name="dbType">
				<xsl:text>DERBY</xsl:text>
			</xsl:attribute>	
		</xsl:if>
		<xsl:if test="/metadata/appVariables/@dbType = 'MS SQL'">
			<xsl:attribute name="dbType">
				<xsl:text>MSSQL2005</xsl:text>
			</xsl:attribute>	
		</xsl:if>
		<xsl:if test="/metadata/appVariables/@dbType = 'Oracle'">
			<xsl:attribute name="dbType">
				<xsl:text>ORACLE</xsl:text>
			</xsl:attribute>	
		</xsl:if>
		<xsl:if test="/metadata/appVariables/@dbType = 'PostgreSQL'">
			<xsl:attribute name="dbType">
				<xsl:text>POSTGRES</xsl:text>
			</xsl:attribute>	
		</xsl:if>
		<xsl:if test="/metadata/appVariables/@dbType = 'Teradata'">
			<xsl:attribute name="dbType">
				<xsl:text>TERADATA</xsl:text>
			</xsl:attribute>	
		</xsl:if>
		
		<!-- show input true/false option -->
		<xsl:choose>
			<xsl:when test="/metadata/appVariables/@useInputs = 'true'">
            	<xsl:attribute name="useInputs">
                	<xsl:text>true</xsl:text>
            	</xsl:attribute>  
        	</xsl:when>
        	<xsl:otherwise>
				<xsl:attribute name="useInputs">
                	<xsl:text>false</xsl:text>
            	</xsl:attribute>  
			</xsl:otherwise>
		</xsl:choose>
		      
        <!-- sendLongOperationToThreads true/false option -->
		<xsl:choose>
			<xsl:when test="/metadata/appVariables/@sendLongOperationToThreads = 'true'">
    			<xsl:attribute name="sendLongOperationToThreads">
        			<xsl:text>true</xsl:text>
       			</xsl:attribute> 
			</xsl:when>
			<xsl:otherwise>
				<xsl:attribute name="sendLongOperationToThreads">
        			<xsl:text>false</xsl:text>
       			</xsl:attribute> 
			</xsl:otherwise>
		</xsl:choose>
		
		<xsl:if test="/metadata/security/@enableCustomDomains='true'">
			<xsl:attribute name="loginConfigFile">
        		<xsl:text>login.xml</xsl:text>
       		</xsl:attribute> 
		</xsl:if>
	</model>	
		
	<customizations
		welcomePageConfigFile="welcome.xml"
		helpPageConfigFile="help.xml"
		maxPageSize="{/metadata/appVariables/@maxPageSize}"
		showGeneratedIdsInTables="{/metadata/appVariables/@showGeneratedIdsInTables}"
		initialRecursiveInEdit="{/metadata/appVariables/@initialRecursiveInEdit}"
		>
		<xsl:choose>
			<xsl:when test="/metadata/appVariables/@language = 'Czech'">
				<xsl:attribute name="guiLocale">
	                <xsl:text>cs</xsl:text>
	            </xsl:attribute>  
			</xsl:when>
			<xsl:when test="/metadata/appVariables/@language = 'English'">
				<xsl:attribute name="guiLocale">
	                <xsl:text>en</xsl:text>
	            </xsl:attribute>  
			</xsl:when>
			<xsl:when test="/metadata/appVariables/@language = 'German'">
				<xsl:attribute name="guiLocale">
	                <xsl:text>de</xsl:text>
	            </xsl:attribute>  
			</xsl:when>			
			<xsl:when test="/metadata/appVariables/@language = 'Russian'">
				<xsl:attribute name="guiLocale">
	                <xsl:text>ru</xsl:text>
	            </xsl:attribute>  
			</xsl:when>
			<xsl:otherwise>
				<xsl:attribute name="guiLocale">
	                <xsl:text>cs</xsl:text>
	            </xsl:attribute>  
			</xsl:otherwise>
		</xsl:choose>
      </customizations>
      
	<xsl:if test="/metadata/appVariables/@auditing = 'true'">
      	<audit>
			<writers>
				<writer class="com.ataccama.rdm.manager.audit.LoggerAuditWriter" id="loggerWriter">
					<loggerConfig>logging.xml</loggerConfig>
				</writer>
			</writers>
		</audit>
	</xsl:if>
</rdm-config>

</xsl:template>

</xsl:stylesheet>	
