<?xml version='1.0' encoding='UTF-8'?>
<table elemId="27497614" useUrlResourcesForAuthentication="Use global settings (from App Variables)" batchInterfaceHistory="false" showInAllTables="false" batchInterface="false" amountOfRecords="" name="COUNTRIES" label="COUNTRIES" amountOfChanges="">
	<description></description>
	<columns>
		<column elemId="27497615" generatedID="false" generated="false" domain="string" name="COUNTRY_ID" valuePresenter="" dbType="" label="COUNTRY_ID" displayMode="normal" required="false">
			<defaultValue></defaultValue>
			<description></description>
		</column>
		<column elemId="27497616" generatedID="false" generated="false" domain="string" name="COUNTRY_NAME" valuePresenter="" dbType="" label="COUNTRY_NAME" displayMode="normal" required="false">
			<defaultValue></defaultValue>
			<description></description>
		</column>
		<column elemId="27497617" generatedID="false" generated="false" domain="integer" name="REGION_ID" valuePresenter="" dbType="" label="REGION_ID" displayMode="normal" required="false">
			<defaultValue></defaultValue>
			<description></description>
		</column>
	</columns>
	<businessOwnerRoles/>
	<businessOwnerRolesAA/>
	<validations>
		<uniqueKeys>
			<uniqueKey elemId="27498069" name="COUNTRY_ID" primary="true">
				<uniqueKeyColumns>
					<uniqueKeyColumn elemId="27498070" name="COUNTRY_ID"/>
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