<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:sf="http://www.ataccama.com/xslt/functions"
 xmlns:exsl="http://exslt.org/common" extension-element-prefixes="exsl sf">
 <xsl:output method="xml" encoding="UTF-8" indent="yes"/>

<xsl:template match="/metadata">
<metadata>
	<xsl:copy-of select="logicalModel"/>
	<xsl:copy-of select="systems"/> 	
	<xsl:copy-of select="database"/>
	<xsl:copy-of select="wfConfig"/>
	<xsl:copy-of select="security"/>
  <syncTasks>
  	<syncDatabaseTasks>
    <xsl:for-each select="syncTasks/syncDatabaseTasks/syncDatabaseTask">
  		<syncDatabaseTask useUrlResourcesForAuthentication="{@useUrlResourcesForAuthentication}" useInputs="{lower-case(@useInputs)}" name="{@name}">
        <xsl:copy-of select="syncTaskTables"/>
  		</syncDatabaseTask>
    </xsl:for-each>
  	</syncDatabaseTasks>
  	<syncSFTPTasks>
  		<syncSFTPTasksE>
      <xsl:for-each select="syncTasks/syncSFTPTasks/syncSFTPTasksE/syncSFTPTaskE">
  			<syncSFTPTaskE fileName="{@fileName}" filePath="{@filePath}" targetDirectory="{@targetDirectory}" name="{@name}" compression="{@compression}" suffix="{@suffix}" SFTPserver="{@SFTPserver}">
  				<syncSFTPTaskExports>
          <xsl:for-each select="syncSFTPTaskExports/syncSFTPTaskExport">
  					<syncSFTPTaskExport useUrlResourcesForAuthentication="{@useUrlResourcesForAuthentication}" fieldSeparator="{@fieldSeparator}" outputFileName="{@outputFileName}" filePath="{@filePath}" overridePlan="{@overridePlan}" targetDirectory="{@targetDirectory}" header="{lower-case(@header)}" lineSeparator="{@lineSeparator}">
  						<syncSFTPTaskTables>
              <xsl:for-each select="syncSFTPTaskTables/syncSFTPTaskTable">
  							<syncSFTPTaskTable name="{@name}" history="{lower-case(@history)}"/>
              </xsl:for-each>
  						</syncSFTPTaskTables>
  					</syncSFTPTaskExport>
          </xsl:for-each>
  				</syncSFTPTaskExports>
  			</syncSFTPTaskE>
      </xsl:for-each>
  		</syncSFTPTasksE>
  		<syncSFTPTasksI>
      <xsl:for-each select="syncTasks/syncSFTPTasks/syncSFTPTasksI/syncSFTPTaskI">
  			<syncSFTPTaskI deleteFile="{lower-case(@deleteFile)}" fileName="{@fileName}" useUrlResourcesForAuthentication="{@useUrlResourcesForAuthentication}" filePath="{@filePath}" targetDirectory="{@targetDirectory}" name="{@name}" compression="{@compression}" suffix="{@suffix}" SFTPserver="{@SFTPserver}">
  				<xsl:copy-of select="syncSFTPTaskImports"/>
  			</syncSFTPTaskI>
      </xsl:for-each>
  		</syncSFTPTasksI>
  	</syncSFTPTasks>
  	<syncOnlineTasks>
  		<syncOnlineTasksE>
      <xsl:for-each select="syncTasks/syncOnlineTasks/syncOnlineTasksE/syncOnlineTaskE">
  			<syncOnlineTaskE name="{@name}">
  				<syncOnlineTaskExports>
          <xsl:for-each select="syncOnlineTaskExports/syncOnlineTaskExport">
  					<syncOnlineTaskExport useUrlResourcesForAuthentication="{@useUrlResourcesForAuthentication}" outputFileName="{@outputFileName}">
  						<syncOnlineTaskTables>
              <xsl:for-each select="syncOnlineTaskTables/syncOnlineTaskTable">
  							<syncOnlineTaskTable name="{@name}" allColumns="{lower-case(@allColumns)}" history="{lower-case(@history)}">
  								<xsl:copy-of select="syncOnlineTaskTableColumns"/>
  							</syncOnlineTaskTable>
              </xsl:for-each>
  						</syncOnlineTaskTables>
  						<xsl:copy-of select="syncOnlineTaskColumns"/>
  					</syncOnlineTaskExport>
          </xsl:for-each>
  				</syncOnlineTaskExports>
  			</syncOnlineTaskE>
      </xsl:for-each>
      </syncOnlineTasksE>
  		<xsl:copy-of select="syncTasks/syncOnlineTasks/syncOnlineTasksI"/>
  	</syncOnlineTasks>
  	<xsl:copy-of select="syncTasks/syncOnPublishEvent"/>
  </syncTasks>
  <appVariables showGeneratedIdsInTables="{appVariables/@showGeneratedIdsInTables}" docLanguage="{appVariables/@docLanguage}" toInfinity="{appVariables/@toInfinity}" maxPageSize="{appVariables/@maxPageSize}" dbType="{appVariables/@dbType}" auditing="{lower-case(appVariables/@auditing)}" language="{appVariables/@language}" returnEmailAddress="{appVariables/@returnEmailAddress}" initialRecursiveInEdit="{appVariables/@initialRecursiveInEdit}" generatedPrimaryKeyName="{appVariables/@generatedPrimaryKeyName}" useUrlResourcesForAuthentication="{appVariables/@useUrlResourcesForAuthentication}" fromInfinity="{appVariables/@fromInfinity}" sendLongOperationToThreads="{lower-case(appVariables/@sendLongOperationToThreads)}" connectionName="{appVariables/@connectionName}"/>
  <xsl:copy-of select="appConfiguration"/>
	<xsl:copy-of select="setDatabases"/>
	<xsl:copy-of select="taskScheduler"/>
	<auditing>
		<appenders>
			<appender dataRead="{auditing/auditableActions/@dataRead}" count="{auditing/@count}" limit="{auditing/@limit}" name="rotate" pattern="{auditing/@pattern}" dataModification="{auditing/auditableActions/@dataModification}" systemEvent="{auditing/auditableActions/@systemEvent}" securityModification="{auditing/auditableActions/@securityModification}" workflowAction="{auditing/auditableActions/@workflowAction}" append="{lower-case(auditing/@append)}" dataExport="{auditing/auditableActions/@dataExport}"/>
		</appenders>
	</auditing>	
</metadata>

</xsl:template>

</xsl:stylesheet>