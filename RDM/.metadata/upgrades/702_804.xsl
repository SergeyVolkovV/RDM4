<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:sf="http://www.ataccama.com/xslt/functions"
 xmlns:exsl="http://exslt.org/common" extension-element-prefixes="exsl sf">
 <xsl:output method="xml" encoding="UTF-8" indent="yes"/>

<xsl:template match="/metadata">
<metadata>
	<logicalModel>
		<hierarchies>
			<xsl:for-each select="logicalModel/hierarchies/hierarchy">
			<hierarchy name="{@name}" hierarchyName="{@hierarchyName}">
				<hierarchyChildTables>
					<xsl:for-each select="hierarchyChildTables/hierarchyChildTable">
					<hierarchyChildTable relationship="{@relationship}" name="{@name}" label="{@label}">
						<xsl:apply-templates select="." mode="hierarchyChildTableMode"/>
					</hierarchyChildTable>
					</xsl:for-each>
				</hierarchyChildTables>
				<hierarchyViews>
					<xsl:for-each select="hierarchyViews/hierarchyView">
					<hierarchyView name="{@name}"/>
					</xsl:for-each>
				</hierarchyViews>		
			</hierarchy>
			</xsl:for-each>
		</hierarchies>
		
		<tables>
			<xsl:for-each select="logicalModel/tables/table">
			<table batchInterfaceExport="{@batchInterfaceExport}" description="{@description|description}" name="{@name}" batchInterface="{@batchInterface}" onlineInterface="{@onlineInterface}" label="{@label}" amountOfChanges="{@amountOfChanges}" showInAllTables="{@showInAllTables}" amountOfRecords="{@amountOfRecords}">
				<columns>
					<xsl:for-each select="columns/column">
					<column generated="{@generated}" description="{@description}" name="{@name}" hyperlink="{@hyperlink}" generatedID="{@generatedID}" domain="{@domain}" displayMode="{@displayMode}" label="{@label}" required="{@required}" defaultValue="{@defaultValue}" dbType="{@dbType}"/>
					</xsl:for-each>
					<xsl:for-each select="systemColumns/systemColumn">
					<column generated="{@generated}" description="{@description}" name="{@name}" hyperlink="{@hyperlink}" generatedID="{@generatedID}" domain="{@domain}" displayMode="{@displayMode}" label="{@label}" required="{@required}" defaultValue="{@defaultValue}" dbType="{@dbType}"/>
					</xsl:for-each>
				</columns>
				<businessOwnerRoles>
					<xsl:for-each select="businessOwnerRoles/businessOwnerRole">
					<businessOwnerRole role="{@role}"/>
					</xsl:for-each>
				</businessOwnerRoles>
				<businessOwnerRolesAA>
					<xsl:for-each select="businessOwnerRolesAA/businessOwnerAA">
					<businessOwnerAA role="{@role}"/>
					</xsl:for-each>
				</businessOwnerRolesAA>

				
				<validations>
					<uniqueKeys>
						<xsl:for-each select="validations/uniqueKeys/uniqueKey">
						<uniqueKey primary="{@primary}" name="{@name}">
							<uniqueKeyColumns>
								<xsl:for-each select="uniqueKeyColumns/uniqueKeyColumn">
								<uniqueKeyColumn name="{@name}"/>
								</xsl:for-each>
							</uniqueKeyColumns>
						</uniqueKey>
						</xsl:for-each>
					</uniqueKeys>
					<expressionValidations>
					<xsl:for-each select="validations/expressionValidations/expressionValidation">
						<xsl:choose>
						<xsl:when test="string-length(@expression) > 0">
							<expressionValidation message="{@message}" expression="{@expression|expression}"/>
						</xsl:when>
						<xsl:otherwise>
							<expressionValidation message="{@message}" expression="{expression}"/>
						</xsl:otherwise>
						</xsl:choose>
					</xsl:for-each>
					</expressionValidations>
				<onlineValidations>
						<xsl:for-each select="validations/onlineValidations/onlineValidation">
							<xsl:choose>
							<xsl:when test="(@soapVersion = 'SOAP_1_1')">
								<onlineValidation soapEnvNamespace="{@soapEnvNamespace}" name="{@name}" soapAction="{@soapAction}" soapVersion="1.1" url="{@url}"/>
							</xsl:when>
							<xsl:when test="(@soapVersion = 'SOAP_1_2')">
								<onlineValidation soapEnvNamespace="{@soapEnvNamespace}" name="{@name}" soapAction="{@soapAction}" soapVersion="1.2" url="{@url}"/>
							</xsl:when>
							<xsl:otherwise>
								<onlineValidation soapEnvNamespace="{@soapEnvNamespace}" name="{@name}" soapAction="{@soapAction}" soapVersion="{@soapVersion}" url="{@url}"/>
							</xsl:otherwise>
							</xsl:choose>
						</xsl:for-each>
					</onlineValidations>
					<onlineEnrichers>
						<xsl:for-each select="validations/onlineEnrichers/onlineEnricher">
							<xsl:choose>
								<xsl:when test="(@soapVersion = 'SOAP_1_1')">
									<onlineEnricher soapEnvNamespace="{@soapEnvNamespace}" name="{@name}" soapAction="{@soapAction}" soapVersion="1.1" url="{@url}"/>
								</xsl:when>
								<xsl:when test="(@soapVersion = 'SOAP_1_2')">
									<onlineEnricher soapEnvNamespace="{@soapEnvNamespace}" name="{@name}" soapAction="{@soapAction}" soapVersion="1.2" url="{@url}"/>
								</xsl:when>
								<xsl:otherwise>
									<onlineEnricher soapEnvNamespace="{@soapEnvNamespace}" name="{@name}" soapAction="{@soapAction}" soapVersion="{@soapVersion}" url="{@url}"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:for-each>
					</onlineEnrichers>	
				</validations>
				
				<idGenerators>
					<xsl:for-each select="idGenerators/generator">
					<generator name="{@name}"/>
					</xsl:for-each>
				</idGenerators>
			</table>
			</xsl:for-each>
		</tables>

 		<relationships>
			<xsl:for-each select="logicalModel/relationships/relationship">
			<relationship name="{@name}" lookuptype="{@lookuptype}" sqlCondition="{@sqlCondition|sqlCondition}" label="{@label}" parentTable="{@parentTable}" childTable="{@childTable}">
				<representativeForeignKey>
					<xsl:for-each select="representativeForeignKey/column">
					<column parentColumn="{@parentColumn}" childColumn="{@childColumn}"/>
					</xsl:for-each>
				</representativeForeignKey>
			</relationship>
			</xsl:for-each>
		</relationships> 
		
		<domains>
			<xsl:for-each select="logicalModel/domains/domain">
			<domain min="{@min}" fkTable="{@fkTable}" validationMsg="{@validationMsg}" max="{@max}" name="{@name}" format="{@format}" regexp="{@regexp}" size="{@size}">
				<xsl:attribute name="type">
					<xsl:call-template name="upper">
                        <xsl:with-param name="input" select="@type"/>
            		</xsl:call-template>
				</xsl:attribute>
			</domain>
			</xsl:for-each>
		</domains>
		
		<views>
			<xsl:for-each select="logicalModel/views/view">
			<view description="{@description|description}" name="{@name}" sqlCondition="{@sqlCondition|sqlCondition}" onlineInterface="{@onlineInterface}" nameView="{@nameView}" showInAllTables="{@showInAllTables}" labelView="{@labelView}">
				<viewColumns>
					<xsl:for-each select="viewColumns/viewColumn">
					<viewColumn alias="{@alias}" name="{@name}" label="{@label}"/>
					</xsl:for-each>
				</viewColumns>
				<viewParentTables>
					<xsl:for-each select="viewParentTables/viewParentTable">
					<viewParentTable relationship="{@relationship}" name="{@name}" label="{@label}">
						<viewColumns>
							<xsl:for-each select="viewColumns/viewColumn">
							<viewColumn alias="{@alias}" name="{@name}" label="{@label}"/>
							</xsl:for-each>
						</viewColumns>
						
						<xsl:apply-templates select="." mode="viewParentTableMode"/>
						
					</viewParentTable>
					</xsl:for-each>
				</viewParentTables>
				
				<viewColumnsOrder>
					<xsl:for-each select="viewColumnsOrder/viewColumnOrder">
					<viewColumnOrder name="{@name}"/>
					</xsl:for-each>
				</viewColumnsOrder>
				
			</view>
			</xsl:for-each>
		</views>
		
		<categories>
			<xsl:for-each select="logicalModel/categories/category">
			<category name="{@name}">
				<categoryItemTables>
					<xsl:for-each select="categoryItemTables/categoryItemTable">
					<categoryItemTable name="{@name}"/>
					</xsl:for-each>
				</categoryItemTables>
				<categoryItemViews>
					<xsl:for-each select="categoryItemViews/categoryItemView">
					<categoryItemView name="{@name}"/>
					</xsl:for-each>
				</categoryItemViews>
				<categoryItemHierarchies>
					<xsl:for-each select="categoryItemHierarchies/categoryItemHierarchy">
					<categoryItemHierarchy name="{@name}"/>
					</xsl:for-each>
				</categoryItemHierarchies>
				<categoryItemsCategories>
					<xsl:for-each select="categoryItemsCategories/categoryItemCategory">
					<xsl:apply-templates select="." mode="categoryItemCategoryMode"/>
					</xsl:for-each>
				</categoryItemsCategories>
			</category>
			</xsl:for-each>
		</categories>
		
	</logicalModel>
	
	<systems>
		<xsl:for-each select="systems/system">
		<system description="{@description|description}" name="{@name}" dataSourceName="{@dataSourceName}">
			<tables>
				<xsl:for-each select="tables/table">
				<table synchronizeWith="{@synchronizeWith}" description="{@description|description}" name="{@name}" periodicity="{@periodicity}">
					<columns>
						<xsl:for-each select="columns/column">
						<column name="{@name}" type="{lower-case(@type)}" mappedColumn="{@mappedColumn}" required="{@required}" dbType="{@dbType}"/>
						</xsl:for-each>
					</columns>
					<rdmKey>
						<xsl:for-each select="rdmKey/rdmSystemRel">
						<rdmSystemRel rdmColumn="{@rdmColumn}" systemColumn="{@systemColumn}"/>
						</xsl:for-each>
					</rdmKey>
				</table>
				</xsl:for-each>
			</tables>
			<relationships>
				<xsl:for-each select="relationships/relationship">
				<relationship name="{@name}" parentTable="{@parentTable}" childTable="{@childTable}">
					<foreignKey>
						<xsl:for-each select="foreignKey/relationship">
						<relationship parentColumn="{@parentColumn}" childColumn="{@childColumn}"/>
						</xsl:for-each>
					</foreignKey>
				</relationship>
				</xsl:for-each>
			</relationships>
		</system>
		</xsl:for-each>
	</systems>
	
	<database/>
	<wfConfig>
		<entities>
			<xsl:for-each select="wfConfig/entities/entity">
			<entity name="{@name}">
			<xsl:variable name="workflowTable" select="@name"/>
				<publishNotifications>
					<createNotification>
						<xsl:for-each select="publishNotifications/createNotification/emailCreateNotification">
						<emailCreateNotification email="{@email}">
							<createRoles>
								<xsl:for-each select="createRoles/createRole">
								<createRole role="{@role}"/>
								</xsl:for-each>
							</createRoles>
						</emailCreateNotification>
						</xsl:for-each>
					</createNotification>
					
					<updateNotification>
						<xsl:for-each select="publishNotifications/updateNotification/emailUpdateNotification">
						<emailUpdateNotification email="{@email}">
							<updateRoles>
								<xsl:for-each select="updateRoles/updateRole">
								<updateRole role="{@role}"/>
								</xsl:for-each>
							</updateRoles>
						</emailUpdateNotification>
						</xsl:for-each>
					</updateNotification>
					
					<deleteNotification>
						<xsl:for-each select="publishNotifications/deleteNotification/emailDeleteNotification">
						<emailDeleteNotification email="{@email}">
							<deleteRoles>
								<xsl:for-each select="deleteRoles/deleteRole">
								<deleteRole role="{@role}"/>
								</xsl:for-each>
							</deleteRoles>
						</emailDeleteNotification>
						</xsl:for-each>
					</deleteNotification>
				 </publishNotifications>
				 
				 <confirmationNotifications>
					<createNotification>
						<xsl:for-each select="confirmationNotifications/createNotification/emailCreateNotification">
						<emailCreateNotification email="{@email}">
							<createRoles>
								<xsl:for-each select="createRoles/createRole">
								<createRole role="{@role}"/>
								</xsl:for-each>
							</createRoles>
						</emailCreateNotification>
						</xsl:for-each>
					</createNotification>
					
					<updateNotification>
						<xsl:for-each select="confirmationNotifications/updateNotification/emailUpdateNotification">
						<emailUpdateNotification email="{@email}">
							<updateRoles>
								<xsl:for-each select="updateRoles/updateRole">
								<updateRole role="{@role}"/>
								</xsl:for-each>
							</updateRoles>
						</emailUpdateNotification>
						</xsl:for-each>
					</updateNotification>
					
					<deleteNotification>
						<xsl:for-each select="confirmationNotifications/deleteNotification/emailDeleteNotification">
						<emailDeleteNotification email="{@email}">
							<deleteRoles>
								<xsl:for-each select="deleteRoles/deleteRole">
								<deleteRole role="{@role}"/>
								</xsl:for-each>
							</deleteRoles>
						</emailDeleteNotification>
						</xsl:for-each>
					</deleteNotification>
				 </confirmationNotifications>
				
				<workflows>
					<xsl:if test="tableWorkflows/@createWf != ''">
						<workflow id="{tableWorkflows/@createWf}" editOperation="Update">
						<steps>
							<xsl:for-each select="../../workflows/workflow[@id = current()/tableWorkflows/@createWf]/steps/step">
							<step id="{@id}" expiresAfterDays="{@expiresAfterDays}" transitionLabel="{transitions/transition/@label}" condition="{@condition|condition}" transitionTarget="{transitions/transition/@target}">
								<columns>
									<xsl:for-each select="/metadata/logicalModel/tables/table[@name = $workflowTable]/systemColumns/systemColumn">
									<column name="{@name}"/>
									</xsl:for-each>
								</columns>
								
								<statements>
									<xsl:for-each select="statements/statement">
									<statement condition="{@condition|condition}" emailNotification="{@emailNotification}">
										<roles>
											<xsl:for-each select="roles/role">
											<role name="{@name}"/>
											</xsl:for-each>
										</roles>
									</statement>
									</xsl:for-each>
								</statements>
								
								<emailNotifications>
									<xsl:for-each select="emailNotifications/emailNotification">
									<emailNotification emailNotification="{@emailNotification}">
										<roles>
											<xsl:for-each select="roles/role">
											<role name="{@name}"/>
											</xsl:for-each>
										</roles>
									</emailNotification>
									</xsl:for-each>
								</emailNotifications>
							</step>
							</xsl:for-each>
						</steps>
					</workflow>
					</xsl:if>
					
					<xsl:if test="tableWorkflows/@updateWf != ''">
						<workflow id="{tableWorkflows/@updateWf}" editOperation="Create">
						<steps>
							<xsl:for-each select="../../workflows/workflow[@id = current()/tableWorkflows/@updateWf]/steps/step">
							<step id="{@id}" expiresAfterDays="{@expiresAfterDays}" transitionLabel="{transitions/transition/@label}" condition="{@condition|condition}" transitionTarget="{transitions/transition/@target}">
								<columns>
									<xsl:for-each select="columns/column">
									<column name="{@name}"/>
									</xsl:for-each>
								</columns>
								
								<statements>
									<xsl:for-each select="statements/statement">
									<statement condition="{@condition|condition}" emailNotification="{@emailNotification}">
										<roles>
											<xsl:for-each select="roles/role">
											<role name="{@name}"/>
											</xsl:for-each>
										</roles>
									</statement>
									</xsl:for-each>
								</statements>
								
								<emailNotifications>
									<xsl:for-each select="emailNotifications/emailNotification">
									<emailNotification emailNotification="{@emailNotification}">
										<roles>
											<xsl:for-each select="roles/role">
											<role name="{@name}"/>
											</xsl:for-each>
										</roles>
									</emailNotification>
									</xsl:for-each>
								</emailNotifications>
							</step>
							</xsl:for-each>
						</steps>
					</workflow>
					</xsl:if>
					
					<xsl:if test="tableWorkflows/@deleteWf != ''">
						<workflow id="{tableWorkflows/@deleteWf}" editOperation="Delete">
						<steps>
							<xsl:for-each select="../../workflows/workflow[@id = current()/tableWorkflows/@deleteWf]/steps/step">
							<step id="{@id}" expiresAfterDays="{@expiresAfterDays}" transitionLabel="{transitions/transition/@label}" condition="{@condition|condition}" transitionTarget="{transitions/transition/@target}">
								<columns>
									<xsl:for-each select="columns/column">
									<column name="{@name}"/>
									</xsl:for-each>
								</columns>
								
								<statements>
									<xsl:for-each select="statements/statement">
									<statement condition="{@condition|condition}" emailNotification="{@emailNotification}">
										<roles>
											<xsl:for-each select="roles/role">
											<role name="{@name}"/>
											</xsl:for-each>
										</roles>
									</statement>
									</xsl:for-each>
								</statements>
								
								<emailNotifications>
									<xsl:for-each select="emailNotifications/emailNotification">
									<emailNotification emailNotification="{@emailNotification}">
										<roles>
											<xsl:for-each select="roles/role">
											<role name="{@name}"/>
											</xsl:for-each>
										</roles>
									</emailNotification>
									</xsl:for-each>
								</emailNotifications>
							</step>
							</xsl:for-each>
						</steps>
					</workflow>
					</xsl:if>
					
					<xsl:for-each select="workflows/workflow">
					<workflow id="{@id}" editOperation="{@editOperation}">
						<steps>
							<xsl:for-each select="steps/step">
							<step id="{@id}" expiresAfterDays="{@expiresAfterDays}" transitionLabel="{@transitionLabel}" condition="{@condition|condition}" transitionTarget="{@transitionTarget}">
								<columns>
									<xsl:for-each select="columns/column">
									<column name="{@name}"/>
									</xsl:for-each>
								</columns>
								
								<statements>
									<xsl:for-each select="statements/statement">
									<statement condition="{@condition|condition}" emailNotification="{@emailNotification}">
										<roles>
											<xsl:for-each select="roles/role">
											<role name="{@name}"/>
											</xsl:for-each>
										</roles>
									</statement>
									</xsl:for-each>
								</statements>
								
								<emailNotifications>
									<xsl:for-each select="emailNotifications/emailNotification">
									<emailNotification emailNotification="{@emailNotification}">
										<roles>
											<xsl:for-each select="roles/role">
											<role name="{@name}"/>
											</xsl:for-each>
										</roles>
									</emailNotification>
									</xsl:for-each>
								</emailNotifications>
							</step>
							</xsl:for-each>
						</steps>
					</workflow>
					</xsl:for-each>
				</workflows>
			</entity>
			</xsl:for-each>
			<summaryNotifs maxMessagePerSession="{wfConfig/entities/summaryNotifs/@maxMessagePerSession}" confirmSummaryMailRef="{wfConfig/entities/summaryNotifs/@genericSummaryMailRef}" genericSummaryMailRef="{wfConfig/entities/summaryNotifs/@genericSummaryMailRef}" moveSummaryMailRef="{wfConfig/entities/summaryNotifs/@moveSummaryMailRef}"/>	
		</entities>
		
		<emails>
			<xsl:for-each select="wfConfig/emails/email">
			<email subject="{@subject}" name="{@name}">
				<message><xsl:value-of select="message"/></message>
			</email>
			</xsl:for-each>
		</emails>
		<statuses>
			<xsl:for-each select="wfConfig/statuses/status">
			<status id="{@id}" label="{@label}"/>
			</xsl:for-each>
		</statuses>
		
		</wfConfig>
		
		<security userRepository="{security/@userRepository}">
		<fileRepository>
			<users>
				<xsl:for-each select="security/fileRepository/users/user">	
				<user email="{@email}" name="{@name}" permissionsAdministrator="{@permissionsAdministrator}"/>
				</xsl:for-each>
			</users>
			<roles>
				<xsl:for-each select="security/fileRepository/roles/role">
				<role description="{@description}" name="{@name}"/>
				</xsl:for-each>
			</roles>
		</fileRepository>
		<LDAPRepositories>
			<xsl:if test="security/LDAPRepositories/LDAPRepository/connection/@host != ''">
			<xsl:for-each select="security/LDAPRepositories/LDAPRepository">
			<LDAPRepository>
				<groupResolvers>
					<xsl:for-each select="groupResolvers/groupResolver">
					<groupResolver attribute="{@attribute}"/>
					</xsl:for-each>
				</groupResolvers>
				<connection userQuery="{connection/@userQuery}" port="{connection/@port}" basePath="{connection/@basePath}" host="{connection/@host}"/>
				<account authPass="{account/@authPass}" authUser="{account/@authUser}" authType="{account/@authType}"/>
				<administrativeRoles groupRegexFilter="{administrativeRoles/@groupRegexFilter}" appLoginRole="{administrativeRoles/@appLoginRole}" mailAttrName="{administrativeRoles/@mailAttrName}" systemGroupName="{administrativeRoles/@systemGroupName}"/>
			</LDAPRepository>
			</xsl:for-each>
			</xsl:if>
			<xsl:if test="security/LDAPRepository/connection/@host != ''">
			<xsl:for-each select="security/LDAPRepository">
			<LDAPRepository>
				<groupResolvers>
					<xsl:for-each select="groupResolvers/groupResolver">
					<groupResolver attribute="{@attribute}"/>
					</xsl:for-each>
				</groupResolvers>
				<connection userQuery="{connection/@userQuery}" port="{connection/@port}" basePath="{connection/@basePath}" host="{connection/@host}"/>
				<account authPass="{account/@authPass}" authUser="{account/@authUser}" authType="{account/@authType}"/>
				<administrativeRoles groupRegexFilter="{administrativeRoles/@groupRegexFilter}" appLoginRole="{administrativeRoles/@appLoginRole}" mailAttrName="{administrativeRoles/@mailAttrName}" systemGroupName="{administrativeRoles/@systemGroupName}"/>
			</LDAPRepository>
			</xsl:for-each>
			</xsl:if>
		</LDAPRepositories>
	</security>
	
	<syncTasks>
		<xsl:for-each select="syncTasks/syncTask">
		<syncTask name="{@name}">
			<syncTaskTables>
				<xsl:for-each select="syncTaskTables/syncTaskTable">
				<syncTaskTable system="{@system}" name="{@name}"/>
				</xsl:for-each>
			</syncTaskTables>
			<syncPlans/>
		</syncTask>
		</xsl:for-each>
	</syncTasks>
	
	<appVariables showGeneratedIdsInTables="{appVariables/@showGeneratedIdsInTables}" generatedPrimaryKeyName="{appVariables/@generatedPrimaryKeyName}" returnEmailAddress="{appVariables/@returnEmailAddress}" language="{appVariables/@language}" dbType="{appVariables/@dbType}" auditing="{appVariables/@auditing}" useInputs="{appVariables/@useInputs}" url="{appVariables/@url}" maxPageSize="{appVariables/@maxPageSize}"/>
	
	<appConfiguration>
		<configXml/>
		<helpXml/>
		<hierarchiesXml/>
		<inputsXml/>
		<loggingXml/>
		<modelXml/>
		<securityXml/>
		<systemsXml/>
		<tasksXml/>
		<validatorsXml/>
		<welcomeXml/>
		<workflowXml/>
	</appConfiguration>
	
	<setDatabases>
		<setDatabase tableLength="29" elemId="17334586" columnLength="29" dbType="Oracle"/>
		<setDatabase tableLength="127" elemId="17336286" columnLength="127" dbType="MS SQL"/>
		<setDatabase tableLength="62" elemId="17337152" columnLength="62" dbType="PostgreSQL"/>
		<setDatabase tableLength="29" elemId="17337153" columnLength="29" dbType="Teradata"/>
	</setDatabases>
	
	<taskScheduler>
		<xsl:for-each select="taskScheduler/task">
		<task description="{@description}" name="{@name}" enable="{@enable}" job="{@job}">
			<scheduling minute="{scheduling/@minute}" dayWeek="{scheduling/@dayWeek}" dayMonth="{scheduling/@dayMonth}" hour="{scheduling/@hour}"/>
		</task>
		</xsl:for-each>
	</taskScheduler>
</metadata>

</xsl:template>





<xsl:template match="hierarchyChildTable" mode="hierarchyChildTableMode">
	<xsl:if test="child::hierarchyChildTables/hierarchyChildTable/@name !=''">
	<hierarchyChildTables>
		<xsl:for-each select="child::hierarchyChildTables/hierarchyChildTable">
		<hierarchyChildTable relationship="{@relationship}" name="{@name}" label="{@label}">
			<xsl:apply-templates select="." mode="hierarchyChildTableMode"/>
		</hierarchyChildTable>
		</xsl:for-each>
	</hierarchyChildTables>
	</xsl:if>
	<hierarchyViews>
		<xsl:if test="child::hierarchyViews/hierarchyView/@name !=''">
		<xsl:for-each select="child::hierarchyViews/hierarchyView">
		<hierarchyView name="{@name}"/>
		</xsl:for-each>
		</xsl:if>
	</hierarchyViews>
	
</xsl:template>

<xsl:template match="hierarchyView" mode="hierarchyViewMode">
	<xsl:for-each select="child::hierarchyViews/hierarchyView">
	<hierarchyChildTables>
		<hierarchyChildTable relationship="{@relationship}" name="{@name}" label="{@label}">
			<xsl:apply-templates select="." mode="hierarchyViewMode"/>
		</hierarchyChildTable>
	</hierarchyChildTables>
	</xsl:for-each>
</xsl:template>

<xsl:template match="viewParentTable" mode="viewParentTableMode">
	<xsl:for-each select="child::viewParentTables/viewParentTable">
	<viewParentTables>
		<viewParentTable relationship="{@relationship}" name="{@name}" label="{@label}">
			<viewColumns>
				<xsl:for-each select="viewColumns/viewColumn">
					<viewColumn alias="{@alias}" name="{@name}" label="{@label}"/>
				</xsl:for-each>
			</viewColumns>
			<xsl:apply-templates select="." mode="viewParentTableMode"/>
		</viewParentTable>
	</viewParentTables>
	</xsl:for-each>
</xsl:template>

<xsl:template match="categoryItemCategory" mode="categoryItemCategoryMode">
	<categoryItemCategory name="{@name}">
		<categoryItemTables>
			<xsl:for-each select="child::categoryItemTables/categoryItemTable">
				<categoryItemTable name="{@name}"/>
			</xsl:for-each>
		</categoryItemTables>
		<categoryItemViews>
			<xsl:for-each select="child::categoryItemViews/categoryItemView">
				<categoryItemView name="{@name}"/>
			</xsl:for-each>
		</categoryItemViews>
		<categoryItemHierarchies>
			<xsl:for-each select="child::categoryItemHierarchies/categoryItemHierarchy">
				<categoryItemHierarchy name="{@name}"/>
			</xsl:for-each>
		</categoryItemHierarchies>
		<categoryItemsCategories>
			<xsl:for-each select="child::categoryItemsCategories/categoryItemCategory">
				<xsl:apply-templates select="." mode="categoryItemCategoryMode"/>
			</xsl:for-each>	
		</categoryItemsCategories>
	</categoryItemCategory>
</xsl:template>

<xsl:template name="upper">
	<xsl:param name="input"/>
  	<xsl:variable name="smallcase" select="'abcdefghijklmnopqrstuvwxyz'" />
	<xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'" />
	<xsl:value-of select="translate($input, $smallcase, $uppercase)" />
</xsl:template>

<xsl:template name="small">
	<xsl:param name="input"/>
  	<xsl:variable name="smallcase" select="'abcdefghijklmnopqrstuvwxyz'" />
	<xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'" />
	<xsl:value-of select="translate($input, $uppercase, $smallcase)" />
</xsl:template>

</xsl:stylesheet>