<?xml version='1.0' encoding='UTF-8'?>
<table elemId="27497647" useUrlResourcesForAuthentication="Use global settings (from App Variables)" batchInterfaceHistory="false" showInAllTables="false" batchInterface="false" amountOfRecords="" name="REGIONS" label="REGIONS" amountOfChanges="">
	<description></description>
	<columns>
		<column elemId="27497648" generatedID="false" generated="false" domain="integer" name="REGION_ID" valuePresenter="" dbType="" label="REGION_ID" displayMode="normal" required="false">
			<defaultValue></defaultValue>
			<description></description>
		</column>
		<column elemId="27497649" generatedID="false" generated="false" domain="string" name="REGION_NAME" valuePresenter="" dbType="" label="REGION_NAME" displayMode="normal" required="false">
			<defaultValue></defaultValue>
			<description></description>
		</column>
	</columns>
	<businessOwnerRoles/>
	<businessOwnerRolesAA/>
	<validations>
		<uniqueKeys>
			<uniqueKey elemId="27498940" name="REGION_ID" primary="true">
				<uniqueKeyColumns>
					<uniqueKeyColumn elemId="27498941" name="REGION_ID"/>
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