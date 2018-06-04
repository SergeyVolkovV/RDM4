<?xml version='1.0' encoding='UTF-8'?>
<metadata xmlns:ame="http://www.ataccama.com/ame/md">
	<logicalModel>
		<tables>
			<table ame:include="md/logical/tables/COUNTRIES.md"/>
			<table ame:include="md/logical/tables/DEPARTMENTS.md"/>
			<table ame:include="md/logical/tables/JOBS.md"/>
			<table ame:include="md/logical/tables/EMPLOYEES.md"/>
			<table ame:include="md/logical/tables/LOCATIONS.md"/>
			<table ame:include="md/logical/tables/REGIONS2.md"/>
		</tables>
		<relationships>
			<relationship ame:include="md/logical/relationships/COUNTR_REG_FK.md"/>
			<relationship ame:include="md/logical/relationships/EMP_JOB_FK.md"/>
			<relationship ame:include="md/logical/relationships/EMP_MANAGER_FK.md"/>
			<relationship ame:include="md/logical/relationships/LOC_C_ID_FK.md"/>
			<relationship ame:include="md/logical/relationships/EMP_DEPT_FK.md"/>
			<relationship ame:include="md/logical/relationships/DEPT_LOC_FK.md"/>
			<relationship ame:include="md/logical/relationships/DEPT_MGR_FK.md"/>
		</relationships>
		<domains ame:include="md/logical/domains.md"/>
		<valuePresenters ame:include="md/logical/valuePresenters.md"/>
		<hierarchies/>
		<views/>
		<categories/>
		<datasets/>
	</logicalModel>
	<systems>
		<databaseSystems>
			<databaseSystem elemId="27497367" name="HR" dataSourceName="HR">
				<description></description>
				<tables>
					<table elemId="27499305" synchronizeWith="REGIONS2" name="REGIONS" periodicity="">
						<description></description>
						<columns>
							<column elemId="27499306" name="REGION_ID" dbType="NUMBER(38,-1)" type="integer" required="false" mappedColumn="REGION_ID"/>
							<column elemId="27499307" name="REGION_NAME" dbType="VARCHAR2(25)" type="string" required="false" mappedColumn="REGION_NAME"/>
						</columns>
						<rdmKey>
							<rdmSystemRel elemId="27501325" systemColumn="REGION_ID" rdmColumn="REGION_ID"/>
						</rdmKey>
					</table>
					<table elemId="27499308" synchronizeWith="COUNTRIES" name="COUNTRIES" periodicity="">
						<description></description>
						<columns>
							<column elemId="27499309" name="COUNTRY_ID" dbType="CHAR(2)" type="string" required="false" mappedColumn="COUNTRY_ID"/>
							<column elemId="27499310" name="COUNTRY_NAME" dbType="VARCHAR2(40)" type="string" required="false" mappedColumn="COUNTRY_NAME"/>
							<column elemId="27499311" name="REGION_ID" dbType="NUMBER(38,-1)" type="integer" required="false" mappedColumn="REGION_ID"/>
						</columns>
						<rdmKey>
							<rdmSystemRel elemId="27500411" systemColumn="COUNTRY_ID" rdmColumn="COUNTRY_ID"/>
						</rdmKey>
					</table>
					<table elemId="27499312" synchronizeWith="LOCATIONS" name="LOCATIONS" periodicity="">
						<description></description>
						<columns>
							<column elemId="27499313" name="LOCATION_ID" dbType="NUMBER(4,0)" type="integer" required="false" mappedColumn="LOCATION_ID"/>
							<column elemId="27499314" name="STREET_ADDRESS" dbType="VARCHAR2(40)" type="string" required="false" mappedColumn="STREET_ADDRESS"/>
							<column elemId="27499315" name="POSTAL_CODE" dbType="VARCHAR2(12)" type="string" required="false" mappedColumn="POSTAL_CODE"/>
							<column elemId="27499316" name="CITY" dbType="VARCHAR2(30)" type="string" required="false" mappedColumn="CITY"/>
							<column elemId="27499317" name="STATE_PROVINCE" dbType="VARCHAR2(25)" type="string" required="false" mappedColumn="STATE_PROVINCE"/>
							<column elemId="27499318" name="COUNTRY_ID" dbType="CHAR(2)" type="string" required="false" mappedColumn="COUNTRY_ID"/>
						</columns>
						<rdmKey>
							<rdmSystemRel elemId="27500987" systemColumn="LOCATION_ID" rdmColumn="LOCATION_ID"/>
						</rdmKey>
					</table>
					<table elemId="27499319" synchronizeWith="EMPLOYEES" name="EMPLOYEES" periodicity="">
						<description></description>
						<columns>
							<column elemId="27499320" name="EMPLOYEE_ID" dbType="NUMBER(6,0)" type="integer" required="false" mappedColumn="EMPLOYEE_ID"/>
							<column elemId="27499321" name="FIRST_NAME" dbType="VARCHAR2(20)" type="string" required="false" mappedColumn="FIRST_NAME"/>
							<column elemId="27499322" name="LAST_NAME" dbType="VARCHAR2(25)" type="string" required="false" mappedColumn="LAST_NAME"/>
							<column elemId="27499323" name="EMAIL" dbType="VARCHAR2(25)" type="string" required="false" mappedColumn="EMAIL"/>
							<column elemId="27499324" name="PHONE_NUMBER" dbType="VARCHAR2(20)" type="string" required="false" mappedColumn="PHONE_NUMBER"/>
							<column elemId="27499325" name="HIRE_DATE" dbType="DATE" type="datetime" required="false" mappedColumn="HIRE_DATE"/>
							<column elemId="27499326" name="JOB_ID" dbType="VARCHAR2(10)" type="string" required="false" mappedColumn="JOB_ID"/>
							<column elemId="27499327" name="SALARY" dbType="NUMBER(8,2)" type="float" required="false" mappedColumn="SALARY"/>
							<column elemId="27499328" name="COMMISSION_PCT" dbType="NUMBER(2,2)" type="float" required="false" mappedColumn="COMMISSION_PCT"/>
							<column elemId="27499329" name="MANAGER_ID" dbType="NUMBER(6,0)" type="integer" required="false" mappedColumn="MANAGER_ID"/>
							<column elemId="27499330" name="DEPARTMENT_ID" dbType="NUMBER(4,0)" type="integer" required="false" mappedColumn="DEPARTMENT_ID"/>
						</columns>
						<rdmKey>
							<rdmSystemRel elemId="27500699" systemColumn="EMPLOYEE_ID" rdmColumn="EMPLOYEE_ID"/>
						</rdmKey>
					</table>
					<table elemId="27499331" synchronizeWith="DEPARTMENTS" name="DEPARTMENTS" periodicity="">
						<description></description>
						<columns>
							<column elemId="27499332" name="DEPARTMENT_ID" dbType="NUMBER(4,0)" type="integer" required="false" mappedColumn="DEPARTMENT_ID"/>
							<column elemId="27499333" name="DEPARTMENT_NAME" dbType="VARCHAR2(30)" type="string" required="false" mappedColumn="DEPARTMENT_NAME"/>
							<column elemId="27499334" name="MANAGER_ID" dbType="NUMBER(6,0)" type="integer" required="false" mappedColumn="MANAGER_ID"/>
							<column elemId="27499335" name="LOCATION_ID" dbType="NUMBER(4,0)" type="integer" required="false" mappedColumn="LOCATION_ID"/>
						</columns>
						<rdmKey>
							<rdmSystemRel elemId="27500555" systemColumn="DEPARTMENT_ID" rdmColumn="DEPARTMENT_ID"/>
						</rdmKey>
					</table>
					<table elemId="27499336" synchronizeWith="JOBS" name="JOBS" periodicity="">
						<description></description>
						<columns>
							<column elemId="27499337" name="JOB_ID" dbType="VARCHAR2(10)" type="string" required="false" mappedColumn="JOB_ID"/>
							<column elemId="27499338" name="JOB_TITLE" dbType="VARCHAR2(35)" type="string" required="false" mappedColumn="JOB_TITLE"/>
							<column elemId="27499339" name="MIN_SALARY" dbType="NUMBER(6,0)" type="integer" required="false" mappedColumn="MIN_SALARY"/>
							<column elemId="27499340" name="MAX_SALARY" dbType="NUMBER(6,0)" type="integer" required="false" mappedColumn="MAX_SALARY"/>
						</columns>
						<rdmKey>
							<rdmSystemRel elemId="27500843" systemColumn="JOB_ID" rdmColumn="JOB_ID"/>
						</rdmKey>
					</table>
				</tables>
				<relationships>
					<relationship childTable="DEPARTMENTS" elemId="27499341" name="DEPT_MGR_FK" parentTable="EMPLOYEES">
						<foreignKey>
							<relationship elemId="27499342" childColumn="MANAGER_ID" parentColumn="EMPLOYEE_ID"/>
						</foreignKey>
					</relationship>
					<relationship childTable="DEPARTMENTS" elemId="27499343" name="DEPT_LOC_FK" parentTable="LOCATIONS">
						<foreignKey>
							<relationship elemId="27499344" childColumn="LOCATION_ID" parentColumn="LOCATION_ID"/>
						</foreignKey>
					</relationship>
					<relationship childTable="EMPLOYEES" elemId="27499345" name="EMP_MANAGER_FK" parentTable="EMPLOYEES">
						<foreignKey>
							<relationship elemId="27499346" childColumn="MANAGER_ID" parentColumn="EMPLOYEE_ID"/>
						</foreignKey>
					</relationship>
					<relationship childTable="EMPLOYEES" elemId="27499347" name="EMP_JOB_FK" parentTable="JOBS">
						<foreignKey>
							<relationship elemId="27499348" childColumn="JOB_ID" parentColumn="JOB_ID"/>
						</foreignKey>
					</relationship>
					<relationship childTable="COUNTRIES" elemId="27499349" name="COUNTR_REG_FK" parentTable="REGIONS">
						<foreignKey>
							<relationship elemId="27499350" childColumn="REGION_ID" parentColumn="REGION_ID"/>
						</foreignKey>
					</relationship>
					<relationship childTable="EMPLOYEES" elemId="27499351" name="EMP_DEPT_FK" parentTable="DEPARTMENTS">
						<foreignKey>
							<relationship elemId="27499352" childColumn="DEPARTMENT_ID" parentColumn="DEPARTMENT_ID"/>
						</foreignKey>
					</relationship>
					<relationship childTable="LOCATIONS" elemId="27499353" name="LOC_C_ID_FK" parentTable="COUNTRIES">
						<foreignKey>
							<relationship elemId="27499354" childColumn="COUNTRY_ID" parentColumn="COUNTRY_ID"/>
						</foreignKey>
					</relationship>
				</relationships>
			</databaseSystem>
		</databaseSystems>
		<SFTPSystems/>
	</systems>
	<database/>
	<wfConfig>
		<entities/>
		<statuses>
			<status elemId="17416711" id="1" label="Editing"/>
			<status elemId="17416712" id="2" label="Under Review"/>
			<status elemId="17416713" id="3" label="Fill in"/>
			<status elemId="17416714" id="5" label="Published"/>
		</statuses>
		<emails>
			<email elemId="17419940" subject="New published record" name="email: publishing of created new record">
				<message>&lt;p&gt;Dear colleagues,&lt;p&gt;
			
&lt;p&gt;the new record has been created in the reference book $tableLabel$:&lt;br/&gt;
$changes:{item|$item.columnLabel$: &lt;i&gt;$item.value$&lt;/i&gt;&lt;br/&gt;}$&lt;/p&gt;
			
&lt;p&gt;You can see the new record in the system by clicking on this link:
&lt;a href=&quot;$detail_href$&quot;&gt;created record detail&lt;/a&gt;&lt;/p&gt;
			
&lt;p&gt;Best regards,&lt;br/&gt;
Reference Data Management System&lt;/p&gt;</message>
			</email>
			<email elemId="17419941" subject="Published edited record" name="email: publishing of updated record">
				<message>&lt;p&gt;Dear colleagues,&lt;/p&gt;
			
&lt;p&gt;the record has been updated in the reference book $tableLabel$:&lt;br/&gt;
$changes:{item|old value: &lt;i&gt;$item.oldValue$&lt;/i&gt; -&gt; new value: &lt;i&gt;$item.value$&lt;/i&gt; for column &lt;i&gt;$item.columnLabel$&lt;/i&gt;&lt;br/&gt;}$&lt;/i&gt;&lt;/p&gt;
			
&lt;p&gt;The changes are now available in the system by clicking on this link:
&lt;a href=&quot;$detail_href$&quot;&gt;updated record detail&lt;/a&gt;&lt;/p&gt;
			
&lt;p&gt;Best regards,&lt;br/&gt;
Reference Data Management System&lt;/p&gt;</message>
			</email>
			<email elemId="17419942" subject="Published deleted record" name="email: publishing of deleted record">
				<message>&lt;p&gt;Dear colleagues,&lt;p&gt;
			
&lt;p&gt;A record has been deleted in the reference book $tableLabel$:&lt;br/&gt;
$columns:{item|$item.columnLabel$: &lt;i&gt;$item.value$&lt;/i&gt;&lt;br/&gt;}$
username: $username$&lt;/p&gt;
			
&lt;p&gt;You can see the deleted record in the system by clicking on this link:
&lt;a href=&quot;$detail_href$&quot;&gt;deleted record detail&lt;/a&gt;&lt;/p&gt;

&lt;p&gt;Best regards,&lt;br/&gt;
Reference Data Management System&lt;/p&gt;</message>
			</email>
			<email elemId="17419943" subject="Rejecteded record" name="email: rejected record">
				<message>&lt;p&gt;Dear colleagues,&lt;p&gt;
			
&lt;p&gt;A record has been rejected in the reference book $tableLabel$:&lt;br/&gt;
$columns:{item|$item.columnLabel$: &lt;i&gt;$item.value$&lt;/i&gt;&lt;br/&gt;}$
username: $username$&lt;/p&gt;
			
&lt;p&gt;You can see the rejected record in the system by clicking on this link:
&lt;a href=&quot;$detail_href$&quot;&gt;rejected record detail&lt;/a&gt;&lt;/p&gt;

&lt;p&gt;Best regards,&lt;br/&gt;
Reference Data Management System&lt;/p&gt;</message>
			</email>
		</emails>
		<summaryNotifs maxMessagePerSession="" confirmSummaryMailRef="" genericSummaryMailRef="" moveSummaryMailRef=""/>
	</wfConfig>
	<security userRepository="File repository with fixed permissions" enableCustomDomains="false">
		<fileRepository>
			<users>
				<user elemId="17425314" name="admin" permissionsAdministrator="true" email="-"/>
				<user elemId="17425315" name="user" permissionsAdministrator="false" email="-"/>
				<user elemId="27502804" name="super" permissionsAdministrator="false" email="-"/>
				<user elemId="27503683" name="test" permissionsAdministrator="false" email="-"/>
				<user elemId="27504164" name="alice" permissionsAdministrator="false" email="-"/>
			</users>
			<roles>
				<role elemId="17426384" name="Admin" description="">
					<userRoles>
						<userRole elemId="27501636" user="admin"/>
						<userRole elemId="27502517" user="user"/>
					</userRoles>
					<roleEntities>
						<roleTables>
							<roleTable allColumnsModify="true" elemId="27501924" modify="true" view="true" allColumnsView="true" publish="true" name="COUNTRIES" create="true" delete="true">
								<viewRowsFilter></viewRowsFilter>
								<editRowsFilter></editRowsFilter>
								<publishRowsFilter></publishRowsFilter>
								<roleTableColumns/>
							</roleTable>
							<roleTable allColumnsModify="true" elemId="27502119" modify="true" view="true" allColumnsView="true" publish="true" name="DEPARTMENTS" create="true" delete="true">
								<viewRowsFilter></viewRowsFilter>
								<editRowsFilter></editRowsFilter>
								<publishRowsFilter></publishRowsFilter>
								<roleTableColumns/>
							</roleTable>
							<roleTable allColumnsModify="true" elemId="27502120" modify="true" view="true" allColumnsView="true" publish="true" name="EMPLOYEES" create="true" delete="true">
								<viewRowsFilter></viewRowsFilter>
								<editRowsFilter></editRowsFilter>
								<publishRowsFilter></publishRowsFilter>
								<roleTableColumns/>
							</roleTable>
							<roleTable allColumnsModify="true" elemId="27502121" modify="true" view="true" allColumnsView="true" publish="true" name="JOBS" create="true" delete="true">
								<viewRowsFilter></viewRowsFilter>
								<editRowsFilter></editRowsFilter>
								<publishRowsFilter></publishRowsFilter>
								<roleTableColumns/>
							</roleTable>
							<roleTable allColumnsModify="true" elemId="27502122" modify="true" view="true" allColumnsView="true" publish="true" name="LOCATIONS" create="true" delete="true">
								<viewRowsFilter></viewRowsFilter>
								<editRowsFilter></editRowsFilter>
								<publishRowsFilter></publishRowsFilter>
								<roleTableColumns/>
							</roleTable>
							<roleTable allColumnsModify="true" elemId="27502123" modify="true" view="true" allColumnsView="true" publish="true" name="REGIONS2" create="true" delete="true">
								<viewRowsFilter></viewRowsFilter>
								<editRowsFilter></editRowsFilter>
								<publishRowsFilter></publishRowsFilter>
								<roleTableColumns/>
							</roleTable>
						</roleTables>
						<roleViews/>
						<roleDatasets/>
					</roleEntities>
				</role>
				<role elemId="17426385" name="Supervisor" description="">
					<userRoles>
						<userRole elemId="27503191" user="super"/>
					</userRoles>
					<roleEntities>
						<roleTables>
							<roleTable allColumnsModify="true" elemId="27503335" modify="true" view="true" allColumnsView="true" publish="true" name="COUNTRIES" create="true" delete="true">
								<viewRowsFilter></viewRowsFilter>
								<editRowsFilter></editRowsFilter>
								<publishRowsFilter></publishRowsFilter>
								<roleTableColumns/>
							</roleTable>
							<roleTable allColumnsModify="true" elemId="27503336" modify="true" view="true" allColumnsView="true" publish="true" name="DEPARTMENTS" create="true" delete="true">
								<viewRowsFilter></viewRowsFilter>
								<editRowsFilter></editRowsFilter>
								<publishRowsFilter></publishRowsFilter>
								<roleTableColumns/>
							</roleTable>
							<roleTable allColumnsModify="true" elemId="27503337" modify="true" view="true" allColumnsView="true" publish="true" name="JOBS" create="true" delete="true">
								<viewRowsFilter></viewRowsFilter>
								<editRowsFilter></editRowsFilter>
								<publishRowsFilter></publishRowsFilter>
								<roleTableColumns/>
							</roleTable>
							<roleTable allColumnsModify="true" elemId="27503338" modify="true" view="true" allColumnsView="true" publish="true" name="EMPLOYEES" create="true" delete="true">
								<viewRowsFilter></viewRowsFilter>
								<editRowsFilter></editRowsFilter>
								<publishRowsFilter></publishRowsFilter>
								<roleTableColumns/>
							</roleTable>
							<roleTable allColumnsModify="true" elemId="27503339" modify="true" view="true" allColumnsView="true" publish="true" name="LOCATIONS" create="true" delete="true">
								<viewRowsFilter></viewRowsFilter>
								<editRowsFilter></editRowsFilter>
								<publishRowsFilter></publishRowsFilter>
								<roleTableColumns/>
							</roleTable>
							<roleTable allColumnsModify="true" elemId="27503340" modify="true" view="true" allColumnsView="true" publish="true" name="REGIONS2" create="true" delete="true">
								<viewRowsFilter></viewRowsFilter>
								<editRowsFilter></editRowsFilter>
								<publishRowsFilter></publishRowsFilter>
								<roleTableColumns/>
							</roleTable>
						</roleTables>
						<roleViews/>
						<roleDatasets/>
					</roleEntities>
				</role>
				<role elemId="17426386" name="User" description="">
					<userRoles>
						<userRole elemId="27501780" user="user"/>
						<userRole elemId="27503877" user="test"/>
						<userRole elemId="27504308" user="alice"/>
					</userRoles>
					<roleEntities>
						<roleTables>
							<roleTable allColumnsModify="true" elemId="27502322" modify="true" view="true" allColumnsView="true" publish="true" name="REGIONS2" create="true" delete="true">
								<viewRowsFilter></viewRowsFilter>
								<editRowsFilter></editRowsFilter>
								<publishRowsFilter></publishRowsFilter>
								<roleTableColumns/>
							</roleTable>
						</roleTables>
						<roleViews/>
						<roleDatasets/>
					</roleEntities>
				</role>
				<role elemId="17426389" name="Business Super User" description="">
					<userRoles/>
					<roleEntities>
						<roleTables/>
						<roleViews/>
						<roleDatasets/>
					</roleEntities>
				</role>
			</roles>
		</fileRepository>
		<LDAPRepositories/>
	</security>
	<syncTasks>
		<syncDatabaseTasks/>
		<syncSFTPTasks>
			<syncSFTPTasksE/>
			<syncSFTPTasksI/>
		</syncSFTPTasks>
		<syncOnlineTasks>
			<syncOnlineTasksE/>
			<syncOnlineTasksI/>
		</syncOnlineTasks>
		<syncOnPublishEvent soapEnvNamespace="http://www.example.com/ws" enable="false" name="rdmOnPublishHandler" soapAction="rdmOnPublishService" soapVersion="SOAP_1_1" url="">
			<tables/>
		</syncOnPublishEvent>
	</syncTasks>
	<appVariables showGeneratedIdsInTables="False" docLanguage="English" toInfinity="2099-12-31 00:00:00" maxPageSize="20" dbType="Apache Derby" auditing="False" language="English" returnEmailAddress="" initialRecursiveInEdit="true" generatedPrimaryKeyName="gpk" useUrlResourcesForAuthentication="Use App Connection Credentials" fromInfinity="1900-01-01 00:00:00" sendLongOperationToThreads="true" connectionName="rdmapp"/>
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
		<physicalAdjustmentsXml/>
		<onPublishXml/>
		<loginXml/>
	</appConfiguration>
	<documentations/>
	<taskScheduler>
		<task elemId="27505799" enable="true" name="LoadRegionWorkflow" description="LoadRegionWorkflow" job="LoadRegionWorkflow.ewf">
			<scheduling hour="*" dayWeek="*" dayMonth="*" minute="*"/>
		</task>
	</taskScheduler>
	<setDatabases>
		<setDatabase elemId="23653417" columnLength="127" dbType="Apache Derby" tableLength="127"/>
		<setDatabase elemId="17389944" columnLength="127" dbType="MS SQL" tableLength="127"/>
		<setDatabase elemId="17389943" columnLength="29" dbType="Oracle" tableLength="29"/>
		<setDatabase elemId="17389945" columnLength="62" dbType="PostgreSQL" tableLength="62"/>
	</setDatabases>
	<auditing>
		<appenders/>
	</auditing>
</metadata>