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
		<xsl:copy-of select="syncTasks/syncDatabaseTasks"/>
		<xsl:copy-of select="syncTasks/syncSFTPTasks"/>
		<syncOnlineTasks>
			<syncOnlineTasksE>				
				<xsl:for-each select="syncTasks/syncOnlineTasks/syncOnlineTasksE/syncOnlineTaskE">
				<syncOnlineTaskE name="{@name}">
					<syncOnlineTaskExports>
						<xsl:for-each select="syncOnlineTaskExports/SyncOnlineTaskExport">
							<SyncOnlineTaskExport outputFileName="{@outputFileName}">
								<xsl:variable name="syncOnlineTaskColumns" select="syncOnlineTaskColumns"/>
								<xsl:choose>
									<xsl:when test="count(syncOnlineTaskTables/syncOnlineTaskTable)=1">	
										<xsl:variable name="oneTableName" select="syncOnlineTaskTables/syncOnlineTaskTable/@name"/>					
										<syncOnlineTaskTables>																																												
											<xsl:for-each select="syncOnlineTaskTables/syncOnlineTaskTable">
												<xsl:variable name="syncOnlineTaskTableName" select="@name"/>
												<xsl:variable name="cntLogicalModelCols" select="count(//logicalModel/tables/table[@name=$syncOnlineTaskTableName]/columns/column)"/>																													
												<xsl:variable name="cntOutputCols" select="count(for $x in //logicalModel/tables/table[@name=$syncOnlineTaskTableName]/columns/column return $syncOnlineTaskColumns/syncOnlineTaskColumn[@name=$x/@name and (@type=//logicalModel/domains/domain[@name=$x/@domain]/@type or (@type='STRING' and //logicalModel/domains/domain[@name=$x/@domain]/@type='MNREFERENCES'))])"/>																																						
												<syncOnlineTaskTable history="{@history}" name="{@name}">													
													<xsl:attribute name="allColumns">
														<xsl:choose>											
															<xsl:when test="format-number($cntLogicalModelCols,'0')=format-number($cntOutputCols,'0')">
																<xsl:value-of select="'true'"/>
															</xsl:when>
															<xsl:otherwise>
																<xsl:value-of select="'false'"/>
															</xsl:otherwise>
														</xsl:choose>
													</xsl:attribute>
													<syncOnlineTaskTableColumns>
														<xsl:if test="format-number($cntLogicalModelCols,'0')!=format-number($cntOutputCols,'0')">							
															<xsl:for-each select="$syncOnlineTaskColumns/syncOnlineTaskColumn">
																<xsl:variable name="taskColumnName" select="@name"/>
																<xsl:variable name="taskColumnType" select="@type"/>
																<xsl:variable name="lmColumnDomainType" select="//logicalModel/domains/domain[@name=//logicalModel/tables/table[@name=$oneTableName]/columns/column[@name=$taskColumnName]/@domain]/@type"/>
																<xsl:variable name="lmColumnDqcType" select="if($lmColumnDomainType='MNREFERENCES') then 'STRING' else $lmColumnDomainType"/>
																<xsl:if test="@name=//logicalModel/tables/table[@name=$oneTableName]/columns/column/@name and lower-case(@type)=lower-case($lmColumnDqcType)">																											
																	<syncOnlineTaskTableColumn name="{@name}" type="{@type}"/>
																</xsl:if>																
															</xsl:for-each>
														</xsl:if>
													</syncOnlineTaskTableColumns>
												</syncOnlineTaskTable>																							
											</xsl:for-each>
										</syncOnlineTaskTables>
										<syncOnlineTaskColumns>
											<xsl:for-each select="$syncOnlineTaskColumns/syncOnlineTaskColumn">
												<xsl:variable name="taskColumnName" select="@name"/>
												<xsl:variable name="taskColumnType" select="@type"/>
												<xsl:variable name="lmColumnDomainType" select="//logicalModel/domains/domain[@name=//logicalModel/tables/table[@name=$oneTableName]/columns/column[@name=$taskColumnName]/@domain]/@type"/>
												<xsl:variable name="lmColumnDqcType" select="if($lmColumnDomainType='MNREFERENCES') then 'STRING' else $lmColumnDomainType"/>
												<xsl:if test="not(@name=//logicalModel/tables/table[@name=$oneTableName]/columns/column/@name)">											
													<syncOnlineTaskColumn name="{@name}" type="{@type}"/>
												</xsl:if>
												<xsl:if test="@name=//logicalModel/tables/table[@name=$oneTableName]/columns/column/@name and not(lower-case(@type)=lower-case($lmColumnDqcType))">											
													<syncOnlineTaskColumn name="{@name}" type="{@type}"/>
												</xsl:if>											
											</xsl:for-each>
										</syncOnlineTaskColumns>
									</xsl:when>
									<xsl:otherwise>
										<syncOnlineTaskTables>								
											<xsl:for-each select="syncOnlineTaskTables/syncOnlineTaskTable">
												<syncOnlineTaskTable history="{@history}" name="{@name}" allColumns="false" />
											</xsl:for-each>
										</syncOnlineTaskTables>	
										<syncOnlineTaskColumns>
											<xsl:for-each select="syncOnlineTaskColumns/syncOnlineTaskColumn">
												<syncOnlineTaskColumn name="{@name}" type="{@type}"/>
											</xsl:for-each>
										</syncOnlineTaskColumns>																		
									</xsl:otherwise>
								</xsl:choose>								
							</SyncOnlineTaskExport>
						</xsl:for-each>
					</syncOnlineTaskExports>
				</syncOnlineTaskE>
				</xsl:for-each>
			</syncOnlineTasksE>		
			<xsl:copy-of select="syncTasks/syncOnlineTasks/syncOnlineTasksI"/>
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
