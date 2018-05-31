<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:sf="http://www.ataccama.com/xslt/functions"
 xmlns:exsl="http://exslt.org/common" extension-element-prefixes="exsl sf">
 <xsl:output method="xml" encoding="UTF-8" indent="yes"/>

<xsl:template match="/metadata">
<metadata>
	<logicalModel>

		<xsl:copy-of select="logicalModel/tables"/> 
		<xsl:copy-of select="logicalModel/relationships"/> 
		<xsl:copy-of select="logicalModel/domains"/> 

    	<valuePresenters>
			<xsl:for-each select="logicalModel/valuePresenters/valuePresenter">
				<valuePresenter template="{@template|template}" name="{@name}" />
			</xsl:for-each>
		</valuePresenters>		

		<xsl:copy-of select="logicalModel/hierarchies"/> 
		<xsl:copy-of select="logicalModel/views"/> 
		<xsl:copy-of select="logicalModel/categories"/> 
		<xsl:copy-of select="logicalModel/datasets"/> 
		
	</logicalModel>

	<xsl:copy-of select="systems"/> 	
	<xsl:copy-of select="database"/>
	<xsl:copy-of select="wfConfig"/>
	<xsl:copy-of select="security"/>
	<syncTasks>
		<syncDatabaseTasks>
			<xsl:for-each select="//syncTasks/syncDatabaseTasks/syncDatabaseTask">
				<syncDatabaseTask name="{@name}" useInputs="{@useInputs}">
					<syncTaskTables>
						<xsl:for-each select="syncTaskTables/syncTaskTable">
							<syncTaskTable system="{@system}" name="{@name}"/>
						</xsl:for-each>
					</syncTaskTables>
				</syncDatabaseTask>
			</xsl:for-each>
		</syncDatabaseTasks>		
		<syncSFTPTasks>
			<syncSFTPTasksE>
				<xsl:for-each select="//syncTasks/syncSFTPTasks/syncSFTPTasksE/syncSFTPTaskE">
					<syncSFTPTaskE filePath="{@filePath}" name="{@name}" fileName="{@fileName}" compression="{@compression}" targetDirectory="{@targetDirectory}" SFTPserver="{@SFTPserver}">
						<syncSFTPTaskExports>
							<xsl:for-each select="syncSFTPTaskExports/SyncSFTPTaskExport">
								<syncSFTPTaskExport lineSeparator="{@lineSeparator}" outputFileName="{@outputFileName}" fieldSeparator="{@fieldSeparator}" filePath="{@filePath}" targetDirectory="{@targetDirectory}" header="{@header}">
									<syncSFTPTaskTables>
										<xsl:for-each select="syncSFTPTaskTables/syncSFTPTaskTable">
											<syncSFTPTaskTable history="{@history}" name="{@name}"/>
										</xsl:for-each>
									</syncSFTPTaskTables>
								</syncSFTPTaskExport>
							</xsl:for-each>
						</syncSFTPTaskExports>
					</syncSFTPTaskE>
				</xsl:for-each>
			</syncSFTPTasksE>
			<xsl:copy-of select="//syncTasks/syncSFTPTasks/syncSFTPTasksI"/>
		</syncSFTPTasks>
		<syncOnlineTasks>
			<syncOnlineTasksE>
				<xsl:for-each select="//syncTasks/syncOnlineTasks/syncOnlineTasksE/syncOnlineTaskE">
					<syncOnlineTaskE name="{@name}">
						<syncOnlineTaskExports>
							<xsl:for-each select="syncOnlineTaskExports/SyncOnlineTaskExport">
								<syncOnlineTaskExport outputFileName="{@outputFileName}">
									<syncOnlineTaskTables>
										<xsl:for-each select="syncOnlineTaskTables/syncOnlineTaskTable">
											<syncOnlineTaskTable history="{@history}" allColumns="{@allColumns}" name="{@name}">
												<syncOnlineTaskTableColumns>
													<xsl:for-each select="syncOnlineTaskTableColumns/syncOnlineTaskTableColumn">
														<syncOnlineTaskTableColumn name="{@name}"/>
													</xsl:for-each>
												</syncOnlineTaskTableColumns>
											</syncOnlineTaskTable>
										</xsl:for-each>
									</syncOnlineTaskTables>
									<syncOnlineTaskColumns>
										<xsl:for-each select="syncOnlineTaskColumns/syncOnlineTaskColumn">											
											<syncOnlineTaskColumn name="{@name}" type="{@type}"/>
										</xsl:for-each>
									</syncOnlineTaskColumns>
								</syncOnlineTaskExport>
							</xsl:for-each>
						</syncOnlineTaskExports>
					</syncOnlineTaskE>
				</xsl:for-each>
			</syncOnlineTasksE>
			<xsl:copy-of select="//syncTasks/syncOnlineTasks/syncOnlineTasksI"/>
		</syncOnlineTasks>
	</syncTasks>
	<xsl:copy-of select="appVariables"/>
	<xsl:copy-of select="appConfiguration"/>
	<xsl:copy-of select="setDatabases"/>
	<xsl:copy-of select="taskScheduler"/>
	<xsl:copy-of select="auditing"/>

</metadata>

</xsl:template>

</xsl:stylesheet>