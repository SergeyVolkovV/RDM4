<?xml version='1.0' encoding='UTF-8'?>
<metadata>
	<logicalModel>
		<tables/>
		<relationships/>
		<domains>
			<domain rowsCount="" min="" fkTable="" validationMsg="" max="" name="string" elemId="17379659" format="" type="STRING" regexp="" size="255"/>
			<domain rowsCount="" min="" fkTable="" validationMsg="" max="" name="datetime" elemId="17379660" format="" type="DATETIME" regexp="" size=""/>
			<domain rowsCount="" min="" fkTable="" validationMsg="" max="" name="integer" elemId="17379661" format="" type="INTEGER" regexp="" size=""/>
			<domain rowsCount="" min="" fkTable="" validationMsg="" max="" name="long" elemId="17379662" format="" type="LONG" regexp="" size=""/>
			<domain rowsCount="" min="" fkTable="" validationMsg="" max="" name="boolean" elemId="17379663" format="" type="BOOLEAN" regexp="" size=""/>
			<domain rowsCount="" min="" fkTable="" validationMsg="" max="" name="float" elemId="17379664" format="" type="FLOAT" regexp="" size=""/>
		</domains>
		<valuePresenters/>
		<hierarchies/>
		<views/>
		<categories/>
		<datasets/>
	</logicalModel>
	<systems>
		<databaseSystems/>
		<SFTPSystems/>
	</systems>
	<database/>
	<wfConfig>
		<entities/>
		<statuses>
			<status id="1" elemId="17416711" label="Editing"/>
			<status id="2" elemId="17416712" label="Under Review"/>
			<status id="3" elemId="17416713" label="Fill in"/>
			<status id="5" elemId="17416714" label="Published"/>
		</statuses>
		<emails>
			<email subject="New published record" name="email: publishing of created new record" elemId="17419940">
				<message>&lt;p&gt;Dear colleagues,&lt;p&gt;
			
&lt;p&gt;the new record has been created in the reference book $tableLabel$:&lt;br/&gt;
$changes:{item|$item.columnLabel$: &lt;i&gt;$item.value$&lt;/i&gt;&lt;br/&gt;}$&lt;/p&gt;
			
&lt;p&gt;You can see the new record in the system by clicking on this link:
&lt;a href=&quot;$detail_href$&quot;&gt;created record detail&lt;/a&gt;&lt;/p&gt;
			
&lt;p&gt;Best regards,&lt;br/&gt;
Reference Data Management System&lt;/p&gt;</message>
			</email>
			<email subject="Published edited record" name="email: publishing of updated record" elemId="17419941">
				<message>&lt;p&gt;Dear colleagues,&lt;/p&gt;
			
&lt;p&gt;the record has been updated in the reference book $tableLabel$:&lt;br/&gt;
$changes:{item|old value: &lt;i&gt;$item.oldValue$&lt;/i&gt; -&gt; new value: &lt;i&gt;$item.value$&lt;/i&gt; for column &lt;i&gt;$item.columnLabel$&lt;/i&gt;&lt;br/&gt;}$&lt;/i&gt;&lt;/p&gt;
			
&lt;p&gt;The changes are now available in the system by clicking on this link:
&lt;a href=&quot;$detail_href$&quot;&gt;updated record detail&lt;/a&gt;&lt;/p&gt;
			
&lt;p&gt;Best regards,&lt;br/&gt;
Reference Data Management System&lt;/p&gt;</message>
			</email>
			<email subject="Published deleted record" name="email: publishing of deleted record" elemId="17419942">
				<message>&lt;p&gt;Dear colleagues,&lt;p&gt;
			
&lt;p&gt;A record has been deleted in the reference book $tableLabel$:&lt;br/&gt;
$columns:{item|$item.columnLabel$: &lt;i&gt;$item.value$&lt;/i&gt;&lt;br/&gt;}$
username: $username$&lt;/p&gt;
			
&lt;p&gt;You can see the deleted record in the system by clicking on this link:
&lt;a href=&quot;$detail_href$&quot;&gt;deleted record detail&lt;/a&gt;&lt;/p&gt;

&lt;p&gt;Best regards,&lt;br/&gt;
Reference Data Management System&lt;/p&gt;</message>
			</email>
			<email subject="Rejecteded record" name="email: rejected record" elemId="17419943">
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
	<security userRepository="File repository">
		<fileRepository>
			<users>
				<user email="-" name="admin" elemId="17425314" permissionsAdministrator="true"/>
				<user email="-" name="user" elemId="17425315" permissionsAdministrator="false"/>
			</users>
			<roles>
				<role description="" name="Admin" elemId="17426384">
					<userRoles/>
				</role>
				<role description="" name="Supervisor" elemId="17426385">
					<userRoles/>
				</role>
				<role description="" name="User" elemId="17426386">
					<userRoles/>
				</role>
				<role description="" name="Business Super User" elemId="17426389">
					<userRoles/>
				</role>
			</roles>
		</fileRepository>
		<LDAPRepositories/>
	</security>
	<syncTasks>
		<syncDatabaseTasks/>
		<syncSFTPTasks/>
		<syncOnlineTasks/>
	</syncTasks>
	<appVariables toInfinity="2099-12-31 00:00:00" generatedPrimaryKeyName="gpk" returnEmailAddress="" docLanguage="English" maxPageSize="20" sendLongOperationToThreads="true" showGeneratedIdsInTables="False" fromInfinity="1900-01-01 00:00:00" language="English" auditing="False" dbType="Apache Derby"/>
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
	</appConfiguration>
	<documentations/>
	<taskScheduler/>
	<setDatabases>
		<setDatabase tableLength="127" elemId="23653417" columnLength="127" dbType="Apache Derby"/>
		<setDatabase tableLength="127" elemId="17389944" columnLength="127" dbType="MS SQL"/>
		<setDatabase tableLength="29" elemId="17389943" columnLength="29" dbType="Oracle"/>
		<setDatabase tableLength="62" elemId="17389945" columnLength="62" dbType="PostgreSQL"/>
	</setDatabases>
	<auditing>
		<appenders/>
	</auditing>
</metadata>