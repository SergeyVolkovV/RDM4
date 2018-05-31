<?xml version='1.0' encoding='UTF-8'?>
<table elemId="27497640" useUrlResourcesForAuthentication="Use global settings (from App Variables)" batchInterfaceHistory="false" showInAllTables="false" batchInterface="false" amountOfRecords="" name="LOCATIONS" label="LOCATIONS" amountOfChanges="">
	<description></description>
	<columns>
		<column elemId="27497641" generatedID="false" generated="false" domain="integer" name="LOCATION_ID" valuePresenter="" dbType="" label="LOCATION_ID" displayMode="normal" required="false">
			<defaultValue></defaultValue>
			<description></description>
		</column>
		<column elemId="27497642" generatedID="false" generated="false" domain="string" name="STREET_ADDRESS" valuePresenter="" dbType="" label="STREET_ADDRESS" displayMode="normal" required="false">
			<defaultValue></defaultValue>
			<description></description>
		</column>
		<column elemId="27497643" generatedID="false" generated="false" domain="string" name="POSTAL_CODE" valuePresenter="" dbType="" label="POSTAL_CODE" displayMode="normal" required="false">
			<defaultValue></defaultValue>
			<description></description>
		</column>
		<column elemId="27497644" generatedID="false" generated="false" domain="string" name="CITY" valuePresenter="" dbType="" label="CITY" displayMode="normal" required="false">
			<defaultValue></defaultValue>
			<description></description>
		</column>
		<column elemId="27497645" generatedID="false" generated="false" domain="string" name="STATE_PROVINCE" valuePresenter="" dbType="" label="STATE_PROVINCE" displayMode="normal" required="false">
			<defaultValue></defaultValue>
			<description></description>
		</column>
		<column elemId="27497646" generatedID="false" generated="false" domain="string" name="COUNTRY_ID" valuePresenter="" dbType="" label="COUNTRY_ID" displayMode="normal" required="false">
			<defaultValue></defaultValue>
			<description></description>
		</column>
	</columns>
	<businessOwnerRoles/>
	<businessOwnerRolesAA/>
	<validations>
		<uniqueKeys>
			<uniqueKey elemId="27498783" name="LOCATION_ID" primary="true">
				<uniqueKeyColumns>
					<uniqueKeyColumn elemId="27498784" name="LOCATION_ID"/>
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