<?xml version='1.0' encoding='UTF-8'?>
<table elemId="27497628" useUrlResourcesForAuthentication="Use global settings (from App Variables)" batchInterfaceHistory="false" showInAllTables="false" batchInterface="false" amountOfRecords="" name="EMPLOYEES" label="EMPLOYEES" amountOfChanges="">
	<description></description>
	<columns>
		<column elemId="27497629" generatedID="false" generated="false" domain="integer" name="EMPLOYEE_ID" valuePresenter="" dbType="" label="EMPLOYEE_ID" displayMode="normal" required="false">
			<defaultValue></defaultValue>
			<description></description>
		</column>
		<column elemId="27497630" generatedID="false" generated="false" domain="string" name="FIRST_NAME" valuePresenter="" dbType="" label="FIRST_NAME" displayMode="normal" required="false">
			<defaultValue></defaultValue>
			<description></description>
		</column>
		<column elemId="27497631" generatedID="false" generated="false" domain="string" name="LAST_NAME" valuePresenter="" dbType="" label="LAST_NAME" displayMode="normal" required="false">
			<defaultValue></defaultValue>
			<description></description>
		</column>
		<column elemId="27497632" generatedID="false" generated="false" domain="string" name="EMAIL" valuePresenter="" dbType="" label="EMAIL" displayMode="normal" required="false">
			<defaultValue></defaultValue>
			<description></description>
		</column>
		<column elemId="27497633" generatedID="false" generated="false" domain="string" name="PHONE_NUMBER" valuePresenter="" dbType="" label="PHONE_NUMBER" displayMode="normal" required="false">
			<defaultValue></defaultValue>
			<description></description>
		</column>
		<column elemId="27497634" generatedID="false" generated="false" domain="datetime" name="HIRE_DATE" valuePresenter="" dbType="" label="HIRE_DATE" displayMode="normal" required="false">
			<defaultValue></defaultValue>
			<description></description>
		</column>
		<column elemId="27497635" generatedID="false" generated="false" domain="string" name="JOB_ID" valuePresenter="" dbType="" label="JOB_ID" displayMode="normal" required="false">
			<defaultValue></defaultValue>
			<description></description>
		</column>
		<column elemId="27497636" generatedID="false" generated="false" domain="float" name="SALARY" valuePresenter="" dbType="" label="SALARY" displayMode="normal" required="false">
			<defaultValue></defaultValue>
			<description></description>
		</column>
		<column elemId="27497637" generatedID="false" generated="false" domain="float" name="COMMISSION_PCT" valuePresenter="" dbType="" label="COMMISSION_PCT" displayMode="normal" required="false">
			<defaultValue></defaultValue>
			<description></description>
		</column>
		<column elemId="27497638" generatedID="false" generated="false" domain="integer" name="MANAGER_ID" valuePresenter="" dbType="" label="MANAGER_ID" displayMode="normal" required="false">
			<defaultValue></defaultValue>
			<description></description>
		</column>
		<column elemId="27497639" generatedID="false" generated="false" domain="integer" name="DEPARTMENT_ID" valuePresenter="" dbType="" label="DEPARTMENT_ID" displayMode="normal" required="false">
			<defaultValue></defaultValue>
			<description></description>
		</column>
	</columns>
	<businessOwnerRoles/>
	<businessOwnerRolesAA/>
	<validations>
		<uniqueKeys>
			<uniqueKey elemId="27498472" name="EMPLOYEE_ID" primary="true">
				<uniqueKeyColumns>
					<uniqueKeyColumn elemId="27498473" name="EMPLOYEE_ID"/>
				</uniqueKeyColumns>
			</uniqueKey>
		</uniqueKeys>
		<expressionValidations/>
		<sqlValidations/>
		<onlineValidations/>
		<onlineEnrichers/>
	</validations>
	<idGenerators/>
	<businessDateColumns bdFromColumn="" bdToColumn=""/>
</table>