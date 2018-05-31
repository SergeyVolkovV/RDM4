<?xml version='1.0' encoding='UTF-8'?>
<table elemId="27497618" useUrlResourcesForAuthentication="Use global settings (from App Variables)" batchInterfaceHistory="false" showInAllTables="false" batchInterface="false" amountOfRecords="" name="DEPARTMENTS" label="DEPARTMENTS" amountOfChanges="">
	<description></description>
	<columns>
		<column elemId="27497619" generatedID="false" generated="false" domain="integer" name="DEPARTMENT_ID" valuePresenter="" dbType="" label="DEPARTMENT_ID" displayMode="normal" required="false">
			<defaultValue></defaultValue>
			<description></description>
		</column>
		<column elemId="27497620" generatedID="false" generated="false" domain="integer" name="DEPARTMENT_NAME" valuePresenter="" dbType="" label="DEPARTMENT_NAME" displayMode="normal" required="false">
			<defaultValue></defaultValue>
			<description></description>
		</column>
		<column elemId="27497621" generatedID="false" generated="false" domain="integer" name="MANAGER_ID" valuePresenter="" dbType="" label="MANAGER_ID" displayMode="normal" required="false">
			<defaultValue></defaultValue>
			<description></description>
		</column>
		<column elemId="27497622" generatedID="false" generated="false" domain="integer" name="LOCATION_ID" valuePresenter="" dbType="" label="LOCATION_ID" displayMode="normal" required="false">
			<defaultValue></defaultValue>
			<description></description>
		</column>
	</columns>
	<businessOwnerRoles/>
	<businessOwnerRolesAA/>
	<validations>
		<uniqueKeys>
			<uniqueKey elemId="27498172" name="DEPARTMENT_ID" primary="true">
				<uniqueKeyColumns>
					<uniqueKeyColumn elemId="27498173" name="DEPARTMENT_ID"/>
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