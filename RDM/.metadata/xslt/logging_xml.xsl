<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
 <xsl:output method="xml" encoding="UTF-8" indent="yes"/>

<xsl:template match="*">

<loggingConfig class='com.ataccama.dqc.commons.logging.config.LoggingConfigImpl'>
    <appenders>
        <iLogAppenderFactory name="stdout" class="com.ataccama.dqc.commons.logging.factories.StdOutLogAppenderFactory" useStdErr="false"/> 
        <xsl:for-each select="/metadata/auditing/appenders/appender">
	        <iLogAppenderFactory name="{@name}" class='com.ataccama.dqc.commons.logging.factories.JDKHandledLogAppenderFactory'>
	            <handler class='com.ataccama.dqc.commons.logging.handlers.FileHandlerInfo'>
	                <pattern><xsl:value-of select="@pattern"/></pattern>
	                <limit><xsl:value-of select="@limit"/></limit>
	                <count><xsl:value-of select="@count"/></count>
	                <append><xsl:value-of select="@append"/></append>
	                <formatter class='com.ataccama.dqc.commons.logging.handlers.SimpleFormatterInfo'/>
	            </handler>
	        </iLogAppenderFactory>
		</xsl:for-each>	        
    </appenders>
    <loggingRules>
		<xsl:for-each select="/metadata/auditing/appenders/appender">   
			<xsl:if test="@dataRead = 'true'">
				<loggingRule level="INFO" appender="{@name}">
					<trace>
						<item><xsl:text>Data read</xsl:text></item>
					</trace>
				</loggingRule>
			</xsl:if>
			<xsl:if test="@dataModification = 'true'">
				<loggingRule level="INFO" appender="{@name}">
					<trace>     
						<item><xsl:text>Data modification</xsl:text></item>
					</trace>
				</loggingRule>
			</xsl:if>
			<xsl:if test="@dataExport = 'true'">     
				<loggingRule level="INFO" appender="{@name}">
					<trace>    
						<item><xsl:text>Data export</xsl:text></item>
					</trace>
				</loggingRule>
			</xsl:if>
			<xsl:if test="@securityModification = 'true'">      
				<loggingRule level="INFO" appender="{@name}">
					<trace>   
						<item><xsl:text>Security modification</xsl:text></item>
					</trace>
				</loggingRule>
			</xsl:if>
			<xsl:if test="@workflowAction = 'true'">      
				<loggingRule level="INFO" appender="{@name}">
					<trace>   
						<item><xsl:text>Workflow action</xsl:text></item>
					</trace>
				</loggingRule>
			</xsl:if>
			<xsl:if test="@systemEvent = 'true'">      
				<loggingRule level="INFO" appender="{@name}">
					<trace>   
						<item><xsl:text>System event</xsl:text></item>
					</trace>
				</loggingRule>
			</xsl:if>
		</xsl:for-each>
		<loggingRule level="INFO" appender="stdout">
		    <trace>
		    	<item><xsl:text>System event</xsl:text></item>
		    </trace>
		</loggingRule>
    </loggingRules>        
</loggingConfig>

</xsl:template>
</xsl:stylesheet>	
