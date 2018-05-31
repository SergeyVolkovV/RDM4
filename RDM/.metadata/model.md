<?xml version='1.0' encoding='UTF-8'?>
<metadata xmlns:ame="http://www.ataccama.com/ame/md">
	<logicalModel>
		<tables>
			<table ame:include="md/logical/tables/COUNTRIES.md"/>
			<table ame:include="md/logical/tables/DEPARTMENTS.md"/>
			<table ame:include="md/logical/tables/JOBS.md"/>
			<table ame:include="md/logical/tables/EMPLOYEES.md"/>
			<table ame:include="md/logical/tables/LOCATIONS.md"/>
			<table ame:include="md/logical/tables/REGIONS.md"/>
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
				<tables/>
				<relationships/>
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
	<security userRepository="File repository" enableCustomDomains="false">
		<fileRepository>
			<users>
				<user elemId="17425314" name="admin" permissionsAdministrator="true" email="-"/>
				<user elemId="17425315" name="user" permissionsAdministrator="false" email="-"/>
			</users>
			<roles>
				<role elemId="17426384" name="Admin" description="">
					<userRoles/>
					<roleEntities>
						<roleTables/>
						<roleViews/>
						<roleDatasets/>
					</roleEntities>
				</role>
				<role elemId="17426385" name="Supervisor" description="">
					<userRoles/>
					<roleEntities>
						<roleTables/>
						<roleViews/>
						<roleDatasets/>
					</roleEntities>
				</role>
				<role elemId="17426386" name="User" description="">
					<userRoles/>
					<roleEntities>
						<roleTables/>
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
	<taskScheduler/>
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