<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:sf="http://www.ataccama.com/xslt/functions"
	xmlns:fn="http://www.w3.org/2005/xpath-functions"
	exclude-result-prefixes="sf fn">
<xsl:output method="xml" encoding="UTF-8" indent="yes"/>

<xsl:param name="logicalModel" select="document('param:logicalModel')/*"/>
<xsl:param name="rdmSecurityRef" select="document('param:rdmSecurityRef')/*"/>
<xsl:param name="rdmAppVariablesRef" select="document('param:rdmAppVariablesRef')"/>
<xsl:param name="rdmSystemRef" select="document('param:rdmSystemRef')/*"/>
<xsl:param name="rdmDataSourceRef" select="document('param:rdmDataSourceRef')/*"/>
<xsl:param name="rdmWorkflowRef" select="document('param:rdmWorkflowRef')/*"/>
<xsl:template match="/*">
<xsl:variable name="currentTableName" select="@name"/>
<html>
<head>
<META http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
<style type="text/css">
@media print {
h1{page-break-before:always;}}

<!-- classes -->
.footNote {
	font-size: 11px;
	}  
.tableVerticalHeader {
	text-align:left;
	}
.fixedVerticalHeader {
	width:160px;
	}
.cellAlignCenter {
	text-align:center;
	}
.border{
	border-bottom:1px solid #D9D9D9;
	}
.lowerCase {
	text-transform:lowercase;
	}
.embeddedTable {
	width:380px;
	border-width:0px;
	border-style:none;
	}
.embedded {
	border-width:0px;
	border-style:none;
	}
.embeddedFixed {
	width:240px;
	}

body {
    counter-reset: section_h1;
	}	
p   {font:13px Candara,Calibri,Seoge,Optima,Arial,sans-serif;
		}
h1  {font:100% Candara,Calibri,Seoge,Optima,Arial,sans-serif;
		font-weight:bold;
		font-size: 16px;
		margin-bottom:13px;
		padding-left:9px;
		background-color:#595959;
		color:white;
		text-transform:uppercase;
		counter-increment: section_h1;	
		counter-reset: sub-section_h2;
		page-break-after: avoid;
	}
h1:before {
        content: counter(section_h1) " ";
  }
h2	{font:100% Candara,Calibri,Seoge,Optima,Arial,sans-serif;
		font-weight:bold;
		font-size: 15px;
		margin-bottom:10px;
		text-transform:uppercase;
		border-bottom:1px solid #D9D9D9;
		counter-increment: sub-section_h2;
		counter-reset: sub-section_h3;
	}
h2:before {
        content: counter(section_h1) "." counter(sub-section_h2) " ";
  }
h3	{font:100% Candara,Calibri,Seoge,Optima,Arial,sans-serif;
		font-weight:bold;
		font-size: 14px;
		margin-bottom:10px;
		background-color:#F2F2F2;
		counter-increment: sub-section_h3;
		counter-reset: sub-section_h4;
	}
h3:before {
        content: counter(section_h1) "." counter(sub-section_h2) "." counter(sub-section_h3) " ";
  }	
h4  {font:100% Candara,Calibri,Seoge,Optima,Arial,sans-serif;
		font-weight:bold;
		font-size: 13px;
		margin-bottom:10px;
		counter-increment: sub-section_h4;
	}
h4:before {
        content: counter(section_h1) "." counter(sub-section_h2) "." counter(sub-section_h3) "." counter(sub-section_h4) " ";
  }
table {
		width:635px;
	}
table,tr,td {
		font-size:11px;
		border-width:1px;
		border-style:solid;
		border-color:#BFBFBF;
		padding:2px 5px 2px 5px;
		margin:0;
		border-collapse:collapse;
		text-decoration:none;
		background-color:transparent
	}
th	{font-size:11px;
		
		border-width:1px;
		border-style:solid;
		border-color:#BFBFBF;
		padding:2px 5px 2px 5px;
		margin:0;
		border-collapse:collapse;
		text-decoration:none;
		background-color:#D9D9D9;
	}
ul {
	font-size:12px;
	}
</style>
</head>

<body>
<!-- logo -->
<img src="../img/logo.png" alt="Logo" align="right"/>
<br/>
<br/>
<p class="border"></p>

<!-- documentation EN -->
<xsl:if test="$rdmAppVariablesRef/appVariables/@docLanguage='English'">
<!-- chapter table specification -->
<h1>Table specification</h1>
<p>Basic information about the table is shown below:</p>
<p>
<table class="tableVerticalHeader">
	<tr>
		<th class="fixedVerticalHeader">Table name</th>
		<td><xsl:value-of select="@label"/></td>
	</tr>
	<tr>
		<th class="fixedVerticalHeader">Table description</th>
		<td><xsl:value-of select="@description"/></td>
	</tr>
	<tr>
		<th class="fixedVerticalHeader">Table business owner</th>
		<td>
			<xsl:for-each select="businessOwnerRoles/businessOwnerRole">
         		<xsl:if test="position()!=last()">
         			<xsl:value-of select="@role"/><xsl:text>; </xsl:text>
         		</xsl:if>
         		<xsl:if test="position()=last()">
         			<xsl:value-of select="@role"/>
         		</xsl:if>
         	</xsl:for-each>
        </td>
	<tr>	
	</tr>	
		<th class="fixedVerticalHeader">Workflow required</th>
		<td>
		<xsl:choose>
		<xsl:when test="$rdmWorkflowRef/entities/entity[@name=$currentTableName]/workflows/workflow/@id != ''">
		<xsl:value-of select="'YES'"/>
		</xsl:when>
		<xsl:otherwise>
		<xsl:value-of select="'NO'"/>
		</xsl:otherwise>
		</xsl:choose>
		</td>
	</tr>
	<tr>		
		<th class="fixedVerticalHeader">Hierarchy required</th>
		<td>
	  	<xsl:choose>
		<xsl:when test="$logicalModel/hierarchies/hierarchy[@enable='true']//hierarchyChildTable/@name=$currentTableName or $logicalModel//hierarchy[@name=$currentTableName]/@enable = 'true'">
		<xsl:value-of select="'YES'"/>
		</xsl:when>
		<xsl:otherwise>
		<xsl:value-of select="'NO'"/>
		</xsl:otherwise>
		</xsl:choose>
		</td>
	</tr>
	<tr>		
		<th class="fixedVerticalHeader">Synchronization type</th>
		<td>
		<xsl:choose>
		<xsl:when test="$rdmSystemRef/systems/system/tables/table[@synchronizeWith=$currentTableName]/@name != ''">
		<xsl:value-of select="'YES'"/>
		</xsl:when>
		<xsl:otherwise>
		<xsl:value-of select="'NO'"/>
		</xsl:otherwise>
		</xsl:choose>
		</td>
	</tr>
</table>
</p>
<p>Content characteristics:</p>
<p>
<table class="tableVerticalHeader">
	<tr>		
		<th class="fixedVerticalHeader">Expected amount of data</th>
		<td><xsl:value-of select="@amountOfRecords"/></td>
	</tr>
	<tr>		
		<th class="fixedVerticalHeader">Expected amount of changes</th>
		<td><xsl:value-of select="@amountOfChanges"/></td>
	</tr>
</table>
</p>
<br/>
<p>Related documents:</p>
<p>
<table>
	<tr>
		<th>Document#</th>
		<th>Document name</th>
		<th>Description</th>
	</tr>
	<xsl:for-each select="$logicalModel/relationships/relationship[@childTable=$currentTableName]">
		<!-- first occurrence only -->					
		<tr>
			<td class="cellAlignCenter">#D<xsl:value-of select="format-number((count(preceding::relationship[@childTable=$currentTableName])+1)*1,'00')"/></td>
			<td class="lowerCase"><i><a href="doc_{@parentTable}.html"><xsl:value-of select="@parentTable"/></a></i></td>
			<td></td>
		</tr>
	</xsl:for-each>
	<xsl:variable name="cnt" select="count($logicalModel/relationships/relationship[@childTable=$currentTableName])"/>
	<xsl:for-each select="$logicalModel/relationships/relationship[@parentTable=$currentTableName]">	
		<tr>
			<td class="cellAlignCenter">#D<xsl:value-of select="format-number((count(preceding::relationship[@parentTable=$currentTableName])+$cnt+1)*1,'00')"/></td>
			<td class="lowerCase"><i><a href="doc_{@childTable}.html"><xsl:value-of select="@childTable"/></a></i></td>			
			<td></td>
		</tr>	
	</xsl:for-each>
</table>
</p>
<br/>

<!-- chapter data model -->
<h1>Data model architecture</h1>
<p><i>Detailed description of the data model, data structures, mapping, etc.</i></p>
<h2>Logical model</h2>
<p>[data model schema]</p>
<br/>
<h3>Master data repository schema</h3>
<p><i>Description of the table, including information such as the label for the table in the web application and further specification of its attributes, including validation rules, etc.</i></p>
<p>
<table>
	<tr>
		<th>Table #</th>
		<th>Table name</th>
		<th>Table label</th>
		<th>Table description</th>
		<th>Comment</th>
	</tr>
	<tr>
		<td class="cellAlignCenter">#T01</td>
		<td><xsl:value-of select="@name"/></td>
		<td><xsl:value-of select="@label"/></td>
		<td><xsl:value-of select="@description"/></td>
		<td></td>
	</tr>
</table>
</p>
<br/>
<p>
<table>
	<tr>
		<th>Attribute #</th>
		<th>Attribute name</th>
		<th>Attribute label</th>
		<th>Data type</th>
		<th>Length</th>
		<th>PK</th>
		<th>FK</th>
		<th>M</th>
		<th>Comment</th>
	</tr>
	<xsl:for-each select="columns/column">
	<xsl:variable name="columnName" select="@name"/>
	<tr>
		<td class="cellAlignCenter">#A<xsl:value-of select="format-number((count(preceding::column)+1)*1,'00')"/></td>
		<td><xsl:value-of select="@name"/></td>
		<td><xsl:value-of select="@label"/></td>
		<td class="cellAlignCenter"><xsl:value-of select="$logicalModel/domains/domain[@name=current()/@domain]/@type"/></td>		
		<td class="cellAlignCenter"><xsl:value-of select="$logicalModel/domains/domain[@name=current()/@domain]/@size"/></td>
		<td class="cellAlignCenter"><xsl:value-of select="if($logicalModel/tables/table[@name=$currentTableName]/validations/uniqueKeys/uniqueKey/uniqueKeyColumns/uniqueKeyColumn/@name=$columnName) then '*' else ''"/></td>
		<td class="cellAlignCenter"><xsl:value-of select="if($logicalModel/relationships/relationship[@childTable=$currentTableName]/representativeForeignKey/column/@childColumn=$columnName) then '*' else ''"/></td>
		<td class="cellAlignCenter"><xsl:value-of select="if(@required='true') then '*' else ''"/></td>
		<td><xsl:value-of select="@description"/></td>		
	</tr>
	</xsl:for-each>
</table>
</p>
<br/>
<p><i>Relationship specifications between tables (foreign keys)</i></p>
<p>
<table>
	<tr>
		<th>Relationship #</th>
		<th>Relationship name</th>
		<th>Relationship label</th>
		<th>Parent table.attribute</th>
		<th>Child table.attribute</th>
		<th>Lookup type</th>
		<th>Comment</th>
	</tr>
		
	<xsl:for-each select="$logicalModel/relationships/relationship[@childTable=$currentTableName]">					
	<tr>
		<td class="cellAlignCenter">#R<xsl:value-of select="format-number((count(preceding::relationship[@childTable=$currentTableName])+1)*1,'00')"/></td>
		<td><xsl:value-of select="@name"/></td>
		<td><xsl:value-of select="@label"/></td>
		<td>
		<xsl:for-each select="representativeForeignKey/column">
		<xsl:value-of select="current()/ancestor::relationship/@parentTable"/>.<br/><xsl:value-of select="@parentColumn"/>
		</xsl:for-each>
		</td>
		<td>
		<xsl:for-each select="representativeForeignKey/column">
		<xsl:value-of select="current()/ancestor::relationship/@childTable"/>.<br/><xsl:value-of select="@childColumn"/>
		</xsl:for-each>	
		</td>
		<td><xsl:value-of select="@lookuptype"/></td>
		<td></td>
	</tr>
	</xsl:for-each>		
	<xsl:variable name="cnt" select="count($logicalModel/relationships/relationship[@childTable=$currentTableName])"/>
	<xsl:for-each select="$logicalModel/relationships/relationship[@parentTable=$currentTableName]">					
	<tr>		
		<td class="cellAlignCenter">#R<xsl:value-of select="format-number((count(preceding::relationship[@parentTable=$currentTableName])+$cnt+1)*1,'00')"/></td>
		<td><xsl:value-of select="@name"/></td>
		<td><xsl:value-of select="@label"/></td>
		<td>
		<xsl:for-each select="representativeForeignKey/column">
		<xsl:value-of select="current()/ancestor::relationship/@parentTable"/>.<br/><xsl:value-of select="@parentColumn"/>
		</xsl:for-each>
		</td>
		<td>
		<xsl:for-each select="representativeForeignKey/column">
		<xsl:value-of select="current()/ancestor::relationship/@childTable"/>.<br/><xsl:value-of select="@childColumn"/>
		</xsl:for-each>	
		</td>
		<td><xsl:value-of select="@lookuptype"/></td>
		<td></td>
	</tr>
	</xsl:for-each>			

</table>
<i  class="footNote">* Combo - provides combo-box in application for value selection. Window - provides dialog window for value selection/lookup. Window is typically used for more complex tables or tables with a lot of records.</i>
</p>
<br/>

<!-- workflow -->
<h1>RDM workflow</h1>
<p>Detailed description of the relevant RDM processes - creation of data, update data, delete data (CRUD operations).</p>
<h2>User roles</h2>
<p>Description of user roles involved in the process and their access rights.</p>
<p><i>Following table enlists the defined user roles and access rights to the table:</i></p>
<p>
<table>
	<tr>
		<th>Role #</th>
		<th>User role name</th>
		<th>Role description</th>
		<th>CRUD</th>
		<th>Attribute</th>
		<th>Comment</th>
	</tr>
	
	<xsl:for-each select="$rdmWorkflowRef/entities/entity[@name=$currentTableName]/workflows/workflow[@editOperation = 'Create']/steps/step/statements/statement/roles/role">				
		<xsl:if test="not(preceding-sibling::role[@name=$currentTableName])">
		<tr>
			<td class="cellAlignCenter">#R<xsl:value-of select="format-number((count(preceding::role)+1)*1,'00')"/></td>
			<td><xsl:value-of select="@name"/></td>
			<td><xsl:value-of select="$rdmSecurityRef/security/fileRepository/roles/role[@name=$currentTableName]/@description"/></td>
			<td></td>
			<td></td>
			<td></td>
		</tr>
		</xsl:if>
	</xsl:for-each>
	<xsl:variable name="cnt" select="count($rdmWorkflowRef/entities/entity[@name=$currentTableName]/workflows/workflow[@editOperation = 'Create']/steps/step/statements/statement/roles/role)"/>
	<xsl:for-each select="$rdmWorkflowRef/entities/entity[@name=$currentTableName]/*/createNotification/emailCreateNotification/createRoles/createRole">				
		<xsl:if test="not(preceding-sibling::createRole[@role=current()/@role]) and @role!=$rdmWorkflowRef/entities/entity[@name=$currentTableName]/workflows/workflow[@editOperation = 'Create']/steps/step/statements/statement/roles/role/@name">
		<tr>
			<td class="cellAlignCenter">#R<xsl:value-of select="format-number((count(preceding::createRole)+$cnt+1)*1,'00')"/></td>
			<td><xsl:value-of select="@role"/></td>
			<td><xsl:value-of select="$rdmSecurityRef/security/fileRepository/roles/role[@name=current()/@role]/@description"/></td>
			<td></td>
			<td></td>
			<td></td>
		</tr>
		</xsl:if>
	</xsl:for-each>	
	<xsl:variable name="cnt2" select="count($rdmWorkflowRef/entities/entity[@name=$currentTableName]/*/createNotification/emailCreateNotification/createRoles/createRole)"/>			
	<xsl:for-each select="$rdmWorkflowRef/entities/entity[@name=$currentTableName]/workflows/workflow[@editOperation='Update']/steps/step/statements/statement/roles/role">
		<xsl:if test="not(preceding-sibling::role[@name=$currentTableName]) and @name!=$rdmWorkflowRef/entities/entity[@name=$currentTableName]/*/createNotification/emailCreateNotification/createRoles/createRole/@role and $rdmWorkflowRef/entities/entity[@name=$currentTableName]/workflows/workflow[@editOperation = 'Create']/steps/step/statements/statement/roles/role/@name">
		<tr>
			<td class="cellAlignCenter">#R<xsl:value-of select="format-number((count(preceding::role)+$cnt+$cnt2+1)*1,'00')"/></td>
			<td><xsl:value-of select="@name"/></td>
			<td><xsl:value-of select="$rdmSecurityRef/security/fileRepository/roles/role[@name=$currentTableName]/@description"/></td>
			<td></td>
			<td></td>
			<td></td>
		</tr>
		</xsl:if>
	</xsl:for-each>
	<xsl:variable name="cnt3" select="count($rdmWorkflowRef/entities/entity[@name=$currentTableName]/workflows/workflow[@editOperation='Update']/steps/step/statements/statement/roles/role)"/>				
	<xsl:for-each select="$rdmWorkflowRef/entities/entity[@name=$currentTableName]/*/updateNotification/emailUpdateNotification/updateRoles/updateRole">
		<xsl:if test="not(preceding-sibling::updateRole[@role=current()/@role]) and @role!=$rdmWorkflowRef/entities/entity[@name=$currentTableName]/workflows/workflow[@editOperation = 'Create' and @editOperation='Update']/steps/step/statements/statement/roles/role/@name and @name!=$rdmWorkflowRef/entities/entity[@name=$currentTableName]/*/createNotification/emailCreateNotification/createRoles/createRole/@role">
		<tr>
			<td class="cellAlignCenter">#R<xsl:value-of select="format-number((count(preceding::createRole)+$cnt+$cnt2+cnt3+1)*1,'00')"/></td>
			<td><xsl:value-of select="@role"/></td>
			<td><xsl:value-of select="$rdmSecurityRef/security/fileRepository/roles/role[@name=current()/@role]/@description"/></td>
			<td></td>
			<td></td>
			<td></td>
		</tr>
		</xsl:if>
	</xsl:for-each>
	<xsl:variable name="cnt4" select="count($rdmWorkflowRef/entities/entity[@name=$currentTableName]/*/updateNotification/emailUpdateNotification/updateRoles/updateRole)"/>
	<xsl:for-each select="$rdmWorkflowRef/entities/entity[@name=$currentTableName]/workflows/workflow[@editOperation = 'Delete']/steps/step/statements/statement/roles/role">
		<xsl:if test="not(preceding-sibling::role[@name=$currentTableName]) and @name!=$rdmWorkflowRef/entities/entity[@name=$currentTableName]/*/updateNotification/emailCreateNotification/updateRoles/updateRole/@role and @name!=$rdmWorkflowRef/entities/entity[@name=$currentTableName]/*/createNotification/emailCreateNotification/createRoles/createRole/@role and $rdmWorkflowRef/entities/entity[@name=$currentTableName]/workflows/workflow[@editOperation = 'Create' and @editOperation = 'Update']/steps/step/statements/statement/roles/role/@name">
		<tr>
			<td class="cellAlignCenter">#R<xsl:value-of select="format-number((count(preceding::role)+$cnt+$cnt2+$cnt3+$cnt4+1)*1,'00')"/></td>
			<td><xsl:value-of select="@name"/></td>
			<td><xsl:value-of select="$rdmSecurityRef/security/fileRepository/roles/role[@name=$currentTableName]/@description"/></td>
			<td></td>
			<td></td>
			<td></td>
		</tr>
		</xsl:if>
	</xsl:for-each>
	<xsl:variable name="cnt5" select="count($rdmWorkflowRef/entities/entity[@name=$currentTableName]/workflows/workflow[@editOperation = 'Delete']/steps/step/statements/statement/roles/role)"/>
	<xsl:for-each select="$rdmWorkflowRef/entities/entity[@name=$currentTableName]/*/deleteNotification/emailDeleteNotification/deleteRoles/deleteRole">
		<xsl:if test="not(preceding-sibling::deleteRole[@role=current()/@role]) and @role!=$rdmWorkflowRef/entities/entity[@name=$currentTableName]/workflows/workflow[@editOperation = 'Create' and @editOperation='Update' and @editOperation='Delete']/steps/step/statements/statement/roles/role/@name and @name!=$rdmWorkflowRef/entities/entity[@name=$currentTableName]/*/createNotification/emailCreateNotification/createRoles/createRole/@role and @name!=$rdmWorkflowRef/entities/entity[@name=$currentTableName]/*/updateNotification/emailCreateNotification/updateRoles/updateRole/@role">
		<tr>
			<td class="cellAlignCenter">#R<xsl:value-of select="format-number((count(preceding::createRole)+$cnt+$cnt2+$cnt3+$cnt4+$cnt5+1)*1,'00')"/></td>
			<td><xsl:value-of select="@role"/></td>
			<td><xsl:value-of select="$rdmSecurityRef/security/fileRepository/roles/role[@name=current()/@role]/@description"/></td>
			<td></td>
			<td></td>
			<td></td>
		</tr>
		</xsl:if>
	</xsl:for-each>
</table>
<i  class="footNote">* For more information about CRUD operations http://en.wikipedia.org/wiki/Create,_read,_update_and_delete;  </i>
<i  class="footNote">* If the rights are limited to certain attributes only, please list or reference the data model.</i>
</p>
<br/>

<h2>RDM workflow design</h2>
<h3>Create record</h3>
<p>Business process of a new record creation in reference table <xsl:value-of select="@label"/>.</p>
<p>[process schema]</p>
<br/>
<p>
<table>
	<tr>
		<th>Process step #</th>
		<th>Process step description</th>
		<th>Next step</th>
		<th>Role and notification</th>
		<th>Comment</th>
	</tr>
	<xsl:choose>
	<xsl:when test="$rdmWorkflowRef/entities/entity[@name=$currentTableName]/workflows/workflow[@editOperation = 'Create']/steps/step/@id != ''">
	<xsl:for-each select="$rdmWorkflowRef/entities/entity[@name=$currentTableName]/workflows/workflow[@editOperation = 'Create']/steps/step">
	<tr>
		<td class="cellAlignCenter">#P<xsl:value-of select="format-number((count(preceding-sibling::step)+1)*1,'00')"/></td>
		<td><xsl:value-of select="$rdmWorkflowRef/statuses/status[@id=current()/@id]/@label"/></td>
		<td><xsl:value-of select="$rdmWorkflowRef/statuses/status[@id=current()/@transitionTarget]/@label"/></td>
		<td>
			<table class="embeddedTable">
				<xsl:choose>
					<xsl:when test="$rdmWorkflowRef/statuses/status[@id=current()/@id]/@label != 'Publish'">
						<xsl:for-each select="statements/statement">
							<tr class="embedded">
								<td class="embedded embeddedFixed">
									<xsl:for-each select="roles/role">
										<xsl:if test="position()!=last()">
											<xsl:value-of select="@name"/><xsl:text>; </xsl:text>
										</xsl:if>
										<xsl:if test="position()=last()">
											<xsl:value-of select="@name"/>
										</xsl:if>
									</xsl:for-each>
								</td>					
								<td class="embedded">
									<xsl:value-of select="@emailNotification"/>
								</td>						
							</tr>
						</xsl:for-each>
					</xsl:when>
					<xsl:otherwise>
						<xsl:for-each select="ancestor::entity[@name=$currentTableName]/notifications/createNotification/emailCreateNotification">
							<tr class="embedded">
								<td class="embedded embeddedFixed">
									<xsl:for-each select="createRoles/createRole">
										<xsl:if test="position()!=last()">
											<xsl:value-of select="@role"/><xsl:text>; </xsl:text>
										</xsl:if>
										<xsl:if test="position()=last()">
											<xsl:value-of select="@role"/>
										</xsl:if>
									</xsl:for-each>
								</td>					
								<td class="embedded">
									<xsl:value-of select="@email"/>
								</td>						
							</tr>
						</xsl:for-each>
					</xsl:otherwise>
				</xsl:choose>																	
			</table>
		</td>
		<td></td>
	</tr>
	</xsl:for-each>	
	</xsl:when>
	<xsl:otherwise>
	<tr>
		<td class="cellAlignCenter">#P<xsl:value-of select="format-number((count(preceding-sibling::step)+1)*1,'00')"/></td>
		<td><xsl:value-of select="'Edit'"/></td>
		<td><xsl:value-of select="'Publish'"/></td>
		<td>
			<table class="embeddedTable">
			</table>
		</td>
		<td></td>
	</tr>
	<tr>
		<td class="cellAlignCenter">#P<xsl:value-of select="format-number((count(preceding-sibling::step)+2)*1,'00')"/></td>
		<td><xsl:value-of select="'Publish'"/></td>
		<td><xsl:value-of select="''"/></td>
		<td>
			<table class="embeddedTable">
				<xsl:for-each select="$rdmWorkflowRef/entities/entity[@name=$currentTableName]/notifications/createNotification/emailCreateNotification">
				<tr class="embedded">
					<td class="embedded embeddedFixed">
						<xsl:for-each select="createRoles/createRole">
							<xsl:if test="position()!=last()">
								<xsl:value-of select="@role"/><xsl:text>; </xsl:text>
							</xsl:if>
							<xsl:if test="position()=last()">
								<xsl:value-of select="@role"/>
							</xsl:if>
						</xsl:for-each>
					</td>
					<td class="embedded">
						<xsl:value-of select="@email"/>
					</td>					
				</tr>
				</xsl:for-each>
			</table>
		</td>
		<td></td>
	</tr>	
	</xsl:otherwise>
	</xsl:choose>							
</table>
</p>

<h3>Update record</h3>
<p>Business process of a record update in reference table <xsl:value-of select="@label"/>.</p>
<p>[process schema]</p>
<br/>
<p>
<table>
	<tr>
		<th>Process step #</th>
		<th>Process step description</th>
		<th>Next step</th>
		<th>Role and notification</th>
		<th>Comment</th>
	</tr>	
	<xsl:choose>
	<xsl:when test="$rdmWorkflowRef/entities/entity[@name=$currentTableName]/workflows/workflow[@editOperation = 'Update']/steps/step/@id != ''">
	<xsl:for-each select="$rdmWorkflowRef/entities/entity[@name=$currentTableName]/workflows/workflow[@editOperation = 'Update']/steps/step">
	<tr>
		<td class="cellAlignCenter">#P<xsl:value-of select="format-number((count(preceding-sibling::step)+1)*1,'00')"/></td>
		<td><xsl:value-of select="$rdmWorkflowRef/statuses/status[@id=current()/@id]/@label"/></td>
		<td><xsl:value-of select="$rdmWorkflowRef/statuses/status[@id=current()/@transitionTarget]/@label"/></td>
		<td>
			<table class="embeddedTable">
				<xsl:for-each select="statements/statement">
					<xsl:variable name="notification" select="@emailNotification"/>
					<tr class="embedded">
						<td class="embedded embeddedFixed">
							<xsl:for-each select="roles/role">
								<xsl:if test="position()!=last()">
									<xsl:value-of select="@name"/><xsl:text>; </xsl:text>
								</xsl:if>
								<xsl:if test="position()=last()">
									<xsl:value-of select="@name"/>
								</xsl:if>
							</xsl:for-each>
						</td>
						<td class="embedded">
							<xsl:value-of select="$notification"/>
						</td>						
					</tr>
				</xsl:for-each>
			</table>
		</td>
		<td></td>
	</tr>
	</xsl:for-each>
	</xsl:when>
	<xsl:otherwise>
	<tr>
		<td class="cellAlignCenter">#P<xsl:value-of select="format-number((count(preceding-sibling::step)+1)*1,'00')"/></td>
		<td><xsl:value-of select="'Edit'"/></td>
		<td><xsl:value-of select="'Publish'"/></td>
		<td>
			<table class="embeddedTable">
			</table>
		</td>
		<td></td>
	</tr>
	<tr>
		<td class="cellAlignCenter">#P<xsl:value-of select="format-number((count(preceding-sibling::step)+2)*1,'00')"/></td>
		<td><xsl:value-of select="'Publish'"/></td>
		<td><xsl:value-of select="''"/></td>
		<td>
			<table class="embeddedTable">
				<xsl:for-each select="$rdmWorkflowRef/entities/entity[@name=$currentTableName]/notifications/updateNotification/emailUpdateNotification">
				<tr class="embedded">
					<td class="embedded embeddedFixed">
						<xsl:for-each select="updateRoles/updateRole">
							<xsl:if test="position()!=last()">
								<xsl:value-of select="@role"/><xsl:text>; </xsl:text>
							</xsl:if>
							<xsl:if test="position()=last()">
								<xsl:value-of select="@role"/>
							</xsl:if>
						</xsl:for-each>
					</td>
					<td class="embedded">
						<xsl:value-of select="@email"/>
					</td>					
				</tr>
				</xsl:for-each>
			</table>
		</td>
		<td></td>
	</tr>	
	</xsl:otherwise>
	</xsl:choose>
</table>
</p>

<h3>Delete record</h3>
<p>Business process of a record delete in reference table <xsl:value-of select="@label"/>.</p>
<p>[process schema]</p>
<br/>
<p>
<table>
	<tr>
		<th>Process step #</th>
		<th>Process step description</th>
		<th>Next step</th>
		<th>Role and notification</th>
		<th>Comment</th>
	</tr>
	<xsl:choose>
	<xsl:when test="$rdmWorkflowRef/entities/entity[@name=$currentTableName]/workflows/workflow[@editOperation = 'Delete']/steps/step/@id != ''">
	<xsl:for-each select="$rdmWorkflowRef/entities/entity[@name=$currentTableName]/workflows/workflow[@editOperation = 'Delete']/steps/step">
	<tr>
		<td class="cellAlignCenter">#P<xsl:value-of select="format-number((count(preceding-sibling::step)+1)*1,'00')"/></td>
		<td><xsl:value-of select="$rdmWorkflowRef/statuses/status[@id=current()/@id]/@label"/></td>
		<td><xsl:value-of select="$rdmWorkflowRef/statuses/status[@id=current()/@transitionTarget]/@label"/></td>
		<td>
			<table class="embeddedTable">
				<xsl:for-each select="statements/statement">
					<xsl:variable name="notification" select="@emailNotification"/>
					<tr class="embedded">
						<td class="embedded embeddedFixed">
							<xsl:for-each select="roles/role">
								<xsl:if test="position()!=last()">
									<xsl:value-of select="@name"/><xsl:text>; </xsl:text>
								</xsl:if>
								<xsl:if test="position()=last()">
									<xsl:value-of select="@name"/>
								</xsl:if>
							</xsl:for-each>
						</td>
						<td class="embedded">
							<xsl:value-of select="$notification"/>
						</td>						
					</tr>
				</xsl:for-each>
			</table>
		</td>
		<td></td>
	</tr>
	</xsl:for-each>	
	</xsl:when>
	<xsl:otherwise>
	<tr>
		<td class="cellAlignCenter">#P<xsl:value-of select="format-number((count(preceding-sibling::step)+1)*1,'00')"/></td>
		<td><xsl:value-of select="'Edit'"/></td>
		<td><xsl:value-of select="'Publish'"/></td>
		<td>
			<table class="embeddedTable">
			</table>
		</td>
		<td></td>
	</tr>
	<tr>
		<td class="cellAlignCenter">#P<xsl:value-of select="format-number((count(preceding-sibling::step)+2)*1,'00')"/></td>
		<td><xsl:value-of select="'Publish'"/></td>
		<td><xsl:value-of select="''"/></td>
		<td>
			<table class="embeddedTable">
				<xsl:for-each select="$rdmWorkflowRef/entities/entity[@name=$currentTableName]/notifications/deleteNotification/emailDeleteNotification">
				<tr class="embedded">
					<td class="embedded embeddedFixed">
						<xsl:for-each select="createRoles/createRole">
							<xsl:if test="position()!=last()">
								<xsl:value-of select="@role"/><xsl:text>; </xsl:text>
							</xsl:if>
							<xsl:if test="position()=last()">
								<xsl:value-of select="@role"/>
							</xsl:if>
						</xsl:for-each>
					</td>
					<td class="embedded">
						<xsl:value-of select="@email"/>
					</td>					
				</tr>
				</xsl:for-each>
			</table>
		</td>
		<td></td>
	</tr>	
	</xsl:otherwise>
	</xsl:choose>
</table>
</p>

<h3>Notifications</h3>
<p><i>List of e-mail notifications and template specifications for e-mail communication.</i></p>
<p>
<table>
	<tr>
		<th>Notification #</th>
		<th>Notification</th>
		<th>Email text</th>
		<th>Comment</th>
	</tr>
	<xsl:for-each select="$rdmWorkflowRef/entities/entity[@name=$currentTableName]/workflows/workflow[@editOperation = 'Create']/steps/step/statements/statement[@emailNotification!='']">
	<tr>
		<td class="cellAlignCenter">#N<xsl:value-of select="format-number((count(preceding::statement)+2)*1,'00')"/></td>
		<td><xsl:value-of select="@emailNotification"/></td>
		<td>	
		<xsl:value-of select="$rdmWorkflowRef/emails/email[@name=current()/@emailNotification]/message|$rdmWorkflowRef//emails/email[@name=current()/@emailNotification]/@message"/></td>
		<td></td>
	</tr>
	</xsl:for-each>
	<xsl:variable name="cnt" select="count($rdmWorkflowRef/entities/entity[@name=$currentTableName]/workflows/workflow[@editOperation = 'Create']/steps/step/statements/statement)"/>		
	<xsl:for-each select="$rdmWorkflowRef/entities/entity[@name=$currentTableName]/notifications/createNotification/emailCreateNotification[@email!=$rdmWorkflowRef/entities/entity[@name=$currentTableName]/workflows/workflow[@editOperation = 'Create']/steps/step/statements/statement/@emailNotification and @email!='']">
	<tr>
		<td class="cellAlignCenter">#N<xsl:value-of select="format-number((count(preceding::statement)+$cnt+2)*1,'00')"/></td>
		<td><xsl:value-of select="@email"/></td>
		<td>	
		<xsl:value-of select="$rdmWorkflowRef/emails/email[@name=current()/@email]/message|$rdmWorkflowRef//emails/email[@name=current()/@email]/@message"/></td>
		<td></td>
	</tr>		
	</xsl:for-each>
	<xsl:variable name="cnt2" select="count($rdmWorkflowRef/entities/entity[@name=$currentTableName]/notifications/createNotification/emailCreateNotification[@email!=$rdmWorkflowRef/entities/entity[@name=$currentTableName]/workflows/workflow[@editOperation = 'Create']/steps/step/statements/statement/@emailNotification])"/>
	<xsl:for-each select="$rdmWorkflowRef/entities/entity[@name=$currentTableName]/workflows/workflow[@editOperation = 'Update']/steps/step/statements/statement[@emailNotification!=$rdmWorkflowRef/entities/entity[@name=$currentTableName]/workflows/workflow[@editOperation = 'Create']/steps/step/statements/statement/@emailNotification and @emailNotification!=$rdmWorkflowRef/entities/entity[@name=$currentTableName]/notifications/createNotification/emailCreateNotification/@email and @emailNotification!='']">
	<tr>
		<td class="cellAlignCenter">#N<xsl:value-of select="format-number((count(preceding::statement)+$cnt+cnt2+2)*1,'00')"/></td>
		<td><xsl:value-of select="@emailNotification"/></td>
		<td>	
		<xsl:value-of select="$rdmWorkflowRef/emails/email[@name=current()/@emailNotification]/message|$rdmWorkflowRef//emails/email[@name=current()/@emailNotification]/@message"/></td>
		<td></td>
	</tr>
	</xsl:for-each>
	<xsl:variable name="cnt3" select="count($rdmWorkflowRef/entities/entity[@name=$currentTableName]/workflows/workflow[@editOperation = 'Update']/steps/step/statements/statement)"/>
	<xsl:for-each select="$rdmWorkflowRef/entities/entity[@name=$currentTableName]/notifications/updateNotification/emailUpdateNotification[@email!=$rdmWorkflowRef/entities/entity[@name=$currentTableName]/workflows/workflow[@editOperation = 'Create']/steps/step/statements/statement/@emailNotification and @email!=$rdmWorkflowRef/entities/entity[@name=$currentTableName]/notifications/createNotification/emailCreateNotification/@email and @email!=$rdmWorkflowRef/entities/entity[@name=$currentTableName]/workflows/workflow[@editOperation = 'Update']/steps/step/statements/statement/@emailNotification and @email!='']">
	<tr>
		<td class="cellAlignCenter">#N<xsl:value-of select="format-number((count(preceding::statement)+$cnt+cnt2+cnt3+2)*1,'00')"/></td>
		<td><xsl:value-of select="@email"/></td>
		<td>	
		<xsl:value-of select="$rdmWorkflowRef/emails/email[@name=current()/@email]/message|$rdmWorkflowRef//emails/email[@name=current()/@email]/@message"/></td>
		<td></td>
	</tr>		
	</xsl:for-each>
	<xsl:variable name="cnt4" select="count($rdmWorkflowRef/entities/entity[@name=$currentTableName]/notifications/updateNotification/emailUpdateNotification)"/>	
	<xsl:for-each select="$rdmWorkflowRef/entities/entity[@name=$currentTableName]/workflows/workflow[@editOperation = 'Delete']/steps/step/statements/statement[@emailNotification!=$rdmWorkflowRef/entities/entity[@name=$currentTableName]/workflows/workflow[@editOperation = 'Create']/steps/step/statements/statement/@emailNotification and @emailNotification!=$rdmWorkflowRef/entities/entity[@name=$currentTableName]/notifications/createNotification/emailCreateNotification/@email and @emailNotification!=$rdmWorkflowRef/entities/entity[@name=$currentTableName]/workflows/workflow[@editOperation = 'Update']/steps/step/statements/statement/@emailNotification and @emailNotification!=$rdmWorkflowRef/entities/entity[@name=$currentTableName]/notifications/updateNotification/emailUpdateNotification/@email and @emailNotification!='']">
	<tr>
		<td class="cellAlignCenter">#N<xsl:value-of select="format-number((count(preceding::statement)+$cnt+$cnt2+$cnt3+$cnt4+2)*1,'00')"/></td>
		<td><xsl:value-of select="@emailNotification"/></td>
		<td>	
		<xsl:value-of select="$rdmWorkflowRef/emails/email[@name=current()/@emailNotification]/message|$rdmWorkflowRef//emails/email[@name=current()/@emailNotification]/@message"/></td>
		<td></td>
	</tr>
	</xsl:for-each>
	<xsl:variable name="cnt5" select="count($rdmWorkflowRef/entities/entity[@name=$currentTableName]/workflows/workflow[@editOperation = 'Delete']/steps/step/statements/statement)"/>	
	<xsl:for-each select="$rdmWorkflowRef/entities/entity[@name=$currentTableName]/notifications/deleteNotification/emailDeleteNotification[@email!=$rdmWorkflowRef/entities/entity[@name=$currentTableName]/workflows/workflow[@editOperation = 'Create']/steps/step/statements/statement/@emailNotification and @email!=$rdmWorkflowRef/entities/entity[@name=$currentTableName]/notifications/createNotification/emailCreateNotification/@email and @email!=$rdmWorkflowRef/entities/entity[@name=$currentTableName]/workflows/workflow[@editOperation = 'Update']/steps/step/statements/statement/@emailNotification and @email!=$rdmWorkflowRef/entities/entity[@name=$currentTableName]/notifications/updateNotification/emailUpdateNotification/@email and @email!=$rdmWorkflowRef/entities/entity[@name=$currentTableName]/workflows/workflow[@editOperation = 'Delete']/steps/step/statements/statement/@emailNotification and @email!='']">
	<tr>
		<td class="cellAlignCenter">#N<xsl:value-of select="format-number((count(preceding::statement)+$cnt+$cnt2+$cnt3+$cnt4+$cnt5+2)*1,'00')"/></td>
		<td><xsl:value-of select="@email"/></td>
		<td>	
		<xsl:value-of select="$rdmWorkflowRef/emails/email[@name=current()/@email]/message|$rdmWorkflowRef//emails/email[@name=current()/@email]/@message"/></td>
		<td></td>
	</tr>		
	</xsl:for-each>

</table>
</p>
<br/>

<!-- synchronization -->
<h1>Synchronization architecture</h1>
	<xsl:choose>
	<xsl:when test="$rdmSystemRef/databaseSystems/databaseSystem[tables/table/@synchronizeWith=$currentTableName]">
	<p><i>Description of synchronization/integration scenarios, participating systems, interfaces, etc.</i></p>
	<p>[architecture schema]</p>
	<br/>
	<p><i>The following table describes the components/systems that are part of an integration scenario:</i></p>
	<p>
	<table>
		<tr>
			<th>Component #</th>
			<th>Component/System name</th>
			<th>Component description</th>
			<th>Technical platform</th>
			<th>Comment</th>
		</tr>
		<xsl:for-each select="$rdmSystemRef/databaseSystems/databaseSystem[tables/table/@synchronizeWith=$currentTableName]">
		<tr>
			<td class="cellAlignCenter">#C<xsl:value-of select="format-number((count(preceding::notification)+1)*1,'00')"/></td>
			<td><xsl:value-of select="@name"/></td>
			<td><xsl:value-of select="@description"/></td>
			<td>
		 	<xsl:choose>
		 		<xsl:when test="$rdmDataSourceRef/dataSources/dataSource[@name = current()/@dataSourceName]/@driverClass = 'org.apache.derby.jdbc.ClientDriver'"> 
		 			<xsl:value-of select="'Apache Derby'"/>
		 		</xsl:when>
		 		<xsl:when test="$rdmDataSourceRef/dataSources/dataSource[@name = current()/@dataSourceName]/@driverClass = 'com.microsoft.sqlserver.jdbc.SQLServerDriver'"> 
		 			<xsl:value-of select="'MS SQL'"/>
		 		</xsl:when>
		 		<xsl:when test="$rdmDataSourceRef/dataSources/dataSource[@name = current()/@dataSourceName]/@driverClass = 'oracle.jdbc.OracleDriver'"> 
		 			<xsl:value-of select="'Oracle'"/>
		 		</xsl:when>
		 		<xsl:when test="$rdmDataSourceRef/dataSources/dataSource[@name = current()/@dataSourceName]/@driverClass = 'org.postgresql.Driver'"> 
		 			<xsl:value-of select="'PosgreSQL'"/>
		 		</xsl:when>
		 		<xsl:when test="$rdmDataSourceRef/dataSources/dataSource[@name = current()/@dataSourceName]/@driverClass = 'com.teradata.jdbc.TeraDriver'"> 
		 			<xsl:value-of select="'Teradata'"/>
		 		</xsl:when>
		 	</xsl:choose>
			</td>
			<td></td>
		</tr>
		</xsl:for-each>
	</table>
	</p>
	
	<h2>Data-flows description</h2>
	<p><i>Description of the expected flow of data between systems and RDM interface, including type and frequency.</i></p>
	<p>
	<table>
		<tr>
			<th>Interface #</th>
			<th>Provider</th>
			<th>Consumer</th>
			<th>Direction</th>
			<th>Interface type</th>
			<th>Frequency</th>
			<th>Comment</th>
		</tr>
		<xsl:for-each select="$rdmSystemRef/databaseSystems/databaseSystem[tables/table/@synchronizeWith=$currentTableName]">
		<tr>
			<td class="cellAlignCenter">#I<xsl:value-of select="format-number((count(preceding::notification)+1)*1,'00')"/></td>
			<td>RDM</td>
			<td><xsl:value-of select="@name"/></td>
			<td class="cellAlignCenter">--></td>
			<td>ETL</td>
			<td><xsl:value-of select="tables/table[@synchronizeWith = $currentTableName]/@periodicity"/></td>
			<td></td>
		</tr>
		</xsl:for-each>
	</table>
	</p>
	<br/>
	
	<h2>Detailed description of interfaces</h2>
	<p><i>Description of all related interfaces, including detailed specification of interface, connectivity parameters etc.
	<ul>
	<li>For table/ETL interfaces, provide table structures (ideally DDL scripts), connectives, protocols</li>
	<li>For web services, provide WSDL schema, XSD, etc.</li>
	</ul>
	</i></p>
	<br/>
	
	<h3>Source and target system data mappings</h3>
	<p><i>The following section should provide specification of source system data (snapshots). This section is only used in case the reference table is synchronized with other systems (either downloads or uploads data). </i></p>
	<br/>
	
	<xsl:for-each select="$rdmSystemRef/databaseSystems/databaseSystem[tables/table/@synchronizeWith=$currentTableName]">
	<h3>Source/target system mapping - <xsl:value-of select="@name"/></h3>
	<p>
	<table>
		<tr>
			<th>Table #</th>
			<th>Table name</th>
			<th>Table description</th>
			<th>Comment</th>
		</tr>
		<xsl:for-each select="$rdmSystemRef/databaseSystems/databaseSystemtables/table[@synchronizeWith=$currentTableName]">
		<tr>
			<td class="cellAlignCenter">#ST<xsl:value-of select="format-number((count(preceding::notification)+1)*1,'00')"/></td>
			<td><xsl:value-of select="@name"/></td>
			<td><xsl:value-of select="@description"/></td>
			<td></td>
		</tr>
		</xsl:for-each>
	</table>
	</p>
	<br/>
	<p>
	<table>
		<tr>
			<th>Attribute #</th>
			<th>Table name</th>
			<th>Attribute name</th>
			<th>Data type</th>
			<th>M</th>
			<th>Comment</th>
		</tr>
		<xsl:for-each select="$rdmSystemRef/databaseSystems/databaseSystemtables/table[@synchronizeWith=$currentTableName]/columns/column">
		<tr>
			<td class="cellAlignCenter">#SA<xsl:value-of select="format-number((count(preceding::notification)+1)*1,'00')"/></td>
			<td><xsl:value-of select="ancestor::table/@name"/></td>
			<td><xsl:value-of select="@name"/></td>
			<td class="cellAlignCenter"><xsl:value-of select="@dbType"/></td>
			<td class="cellAlignCenter"><xsl:value-of select="if(@required='true') then '*' else ''"/></td>
			<td></td>
		</tr>
		</xsl:for-each>
	</table>
	</p>
	<br/>
	<p>
	<table>
		<tr>
			<th>Attribute #</th>
			<th>RDM table.attribute</th>
			<th>Source/target table.attribute</th>
			<th>Mapping rule</th>
			<th>Comment</th>
		</tr>
		<xsl:for-each select="$rdmSystemRef/databaseSystems/databaseSystemtables/table[@synchronizeWith=$currentTableName]/columns/column">
		<tr>
			<td class="cellAlignCenter">#M<xsl:value-of select="format-number((count(preceding::notification)+1)*1,'00')"/></td>
			<td><xsl:value-of select="ancestor::table/@name"/>.<br/><xsl:value-of select="@mappedColumn"/></td>
			<td><xsl:value-of select="ancestor::table/@name"/>.<br/><xsl:value-of select="@name"/></td>
			<td>1:1</td>
			<td></td>
		</tr>
		</xsl:for-each>
	</table>
	</p>
	</xsl:for-each>
	</xsl:when>
	<xsl:otherwise>
	<p>No synchronization / integration scenarios have been defined.</p>
	</xsl:otherwise>
	</xsl:choose>
<br/>

<!-- footer -->
<p class="border"></p> 
<p>This document was generated based on metadata <xsl:value-of  select="current-date"/></p>
</xsl:if>


<!-- documentation CZ -->
<xsl:if test="$rdmAppVariablesRef/appVariables/@docLanguage='Czech'">
<!-- kapitola specifikace číselníku -->
<h1>Specifikace číselníku</h1>
<p>Základní informace k číselníku jsou uvedeny v tabulce níže:</p>
<p>
<table class="tableVerticalHeader">
	<tr>
		<th class="fixedVerticalHeader">Název číselníku</th>
		<td><xsl:value-of select="@label"/></td>
	</tr>
	<tr>
		<th class="fixedVerticalHeader">Popis číselníku</th>
		<td><xsl:value-of select="@description"/></td>
	</tr>
	<tr>
		<th class="fixedVerticalHeader">Kontakní osoba</th>
		<td>
			<xsl:for-each select="businessOwnerRoles/businessOwnerRole">
         		<xsl:if test="position()!=last()">
         			<xsl:value-of select="@role"/><xsl:text>; </xsl:text>
         		</xsl:if>
         		<xsl:if test="position()=last()">
         			<xsl:value-of select="@role"/>
         		</xsl:if>
         	</xsl:for-each>
        </td>
	<tr>	
	</tr>	
		<th class="fixedVerticalHeader">Požadováno workflow</th>
		<td>
		<xsl:choose>
		<xsl:when test="$rdmWorkflowRef/entities/entity[@name=$currentTableName]/workflows/workflow/@id != ''">
		<xsl:value-of select="'YES'"/>
		</xsl:when>
		<xsl:otherwise>
		<xsl:value-of select="'NO'"/>
		</xsl:otherwise>
		</xsl:choose>
		</td>
	</tr>
	<tr>		
		<th class="fixedVerticalHeader">Začlenění do hierarchie</th>
		<td>
	  	<xsl:choose>
		<xsl:when test="$logicalModel/hierarchies/hierarchy[@enable='true']//hierarchyChildTable/@name=$currentTableName or $logicalModel//hierarchy[@name=$currentTableName]/@enable = 'true'">
		<xsl:value-of select="'YES'"/>
		</xsl:when>
		<xsl:otherwise>
		<xsl:value-of select="'NO'"/>
		</xsl:otherwise>
		</xsl:choose>
		</td>
	</tr>
	<tr>		
		<th class="fixedVerticalHeader">Synchronizace</th>
		<td>
		<xsl:choose>
		<xsl:when test="$rdmSystemRef/systems/system/tables/table[@synchronizeWith=$currentTableName]/@name != ''">
		<xsl:value-of select="'YES'"/>
		</xsl:when>
		<xsl:otherwise>
		<xsl:value-of select="'NO'"/>
		</xsl:otherwise>
		</xsl:choose>
		</td>
	</tr>
</table>
</p>
<p>Objemové charakteristiky:</p>
<p>
<table class="tableVerticalHeader">
	<tr>		
		<th class="fixedVerticalHeader">Očekávaný počet záznamů</th>
		<td><xsl:value-of select="@amountOfRecords"/></td>
	</tr>
	<tr>		
		<th class="fixedVerticalHeader">Očekávaný počet změn</th>
		<td><xsl:value-of select="@amountOfChanges"/></td>
	</tr>
</table>
</p>
<br/>
<p>Související dokumenty:</p>
<p>
<table>
	<tr>
		<th>Dokument#</th>
		<th>Název dokumentu</th>
		<th>Popis</th>
	</tr>
	
	<xsl:for-each select="$logicalModel/relationships/relationship[@childTable=$currentTableName]">
		<!-- first occurrence only -->
		<xsl:if test="generate-id($logicalModel/relationships/relationship[@childTable=$currentTableName and @parentTable=current()/@parentTable][1])=generate-id(current())">			
		<tr>
			<td class="cellAlignCenter">#D<xsl:value-of select="format-number((count(preceding::document)+1)*1,'00')"/></td>
			<td class="lowerCase"><i><a href="doc_{@parentTable}.html"><xsl:value-of select="@parentTable"/></a></i></td>
			<td></td>
		</tr>
		</xsl:if>
	</xsl:for-each>
				
	<xsl:for-each select="$logicalModel/relationships/relationship[@parentTable=$currentTableName]">
		<!-- first occurrence only -->
		<xsl:if test="generate-id($logicalModel/relationships/relationship[@parentTable=$currentTableName and @childTable=current()/@childTable][1])=generate-id(current())">
		<tr>
			<td class="cellAlignCenter">#D<xsl:value-of select="format-number((count(preceding::document)+1)*1,'00')"/></td>
			<td class="lowerCase"><i><a href="doc_{@childTable}.html"><xsl:value-of select="@childTable"/></a></i></td>
			<td></td>
		</tr>	
		</xsl:if>
	</xsl:for-each>	
</table>
</p>
<br/>

<!-- kapitola data model -->
<h1>Data model - architektura</h1>
<p><i>Detailní popis datového modelu, datových struktur, mapování, atd.</i></p>
<h2>Logický datový model</h2>
<p>[schéma datového modelu]</p>
<br/>
<h3>Schéma master data úložiště</h3>
<p><i>Popis tabulky včetně informací jako je označení tabulky pro zobrazení v aplikaci a dále specifikace jednotlivých jejích atributů zahrnujících i validační pravidla, atd.</i></p>
<p>
<table>
	<tr>
		<th>Tabulka #</th>
		<th>Název tabulky</th>
		<th>Označení tabulky</th>
		<th>Popis tabulky</th>
		<th>Komentář</th>
	</tr>
	<tr>
		<td class="cellAlignCenter">#T01</td>
		<td><xsl:value-of select="@name"/></td>
		<td><xsl:value-of select="@label"/></td>
		<td><xsl:value-of select="@description"/></td>
		<td></td>
	</tr>
</table>
</p>
<br/>
<p>
<table>
	<tr>
		<th>Atribut #</th>
		<th>Název atributu</th>
		<th>Označení atributu</th>
		<th>Datový typ</th>
		<th>Délka</th>
		<th>PK</th>
		<th>FK</th>
		<th>M</th>
		<th>Komentář</th>
	</tr>
	<xsl:for-each select="columns/column">
	<xsl:variable name="columnName" select="@name"/>
	<tr>
		<td class="cellAlignCenter">#A<xsl:value-of select="format-number((count(preceding::column)+1)*1,'00')"/></td>
		<td><xsl:value-of select="@name"/></td>
		<td><xsl:value-of select="@label"/></td>
		<td class="cellAlignCenter"><xsl:value-of select="$logicalModel/domains/domain[@name=current()/@domain]/@type"/></td>		
		<td class="cellAlignCenter"><xsl:value-of select="$logicalModel/domains/domain[@name=current()/@domain]/@size"/></td>
		<td class="cellAlignCenter"><xsl:value-of select="if($logicalModel/table[@name=$currentTableName]/validations/uniqueKeys/uniqueKey/uniqueKeyColumns/uniqueKeyColumn/@name=$columnName) then '*' else ''"/></td>
		<td class="cellAlignCenter"><xsl:value-of select="if($logicalModel/relationships/relationship[@childTable=$currentTableName]/representativeForeignKey/column/@childColumn=$columnName) then '*' else ''"/></td>
		<td class="cellAlignCenter"><xsl:value-of select="if(@required='true') then '*' else ''"/></td>
		<td><xsl:value-of select="@description"/></td>		
	</tr>
	</xsl:for-each>
</table>
</p>
<br/>
<p><i>Specifikace vztahů mezi tabulkami (cizí klíče), resp. definování hierarchických pohledů.</i></p>
<p>
<table>
	<tr>
		<th>Vazba #</th>
		<th>Název vazby</th>
		<th>Označení vazby</th>
		<th>Parent tabulka.atribut</th>
		<th>Child tabulka.atribut</th>
		<th>Typ lookupu</th>
		<th>Komentář</th>
	</tr>
	<xsl:for-each select="$logicalModel/relationships/relationship[@childTable=$currentTableName or @parentTable=$currentTableName]">					
	<tr>
		<td class="cellAlignCenter">#R<xsl:value-of select="format-number((count(preceding::relation)+1)*1,'00')"/></td>
		<td><xsl:value-of select="@name"/></td>
		<td><xsl:value-of select="@label"/></td>
		<td>
		<xsl:for-each select="representativeForeignKey/column">
		<xsl:value-of select="current()/@parentTable"/>.<br/><xsl:value-of select="@parentColumn"/>
		</xsl:for-each>
		</td>
		<td>
		<xsl:for-each select="representativeForeignKey/column">
		<xsl:value-of select="current()/@childTable"/>.<br/><xsl:value-of select="@childTable"/>
		</xsl:for-each>	
		</td>
		<td><xsl:value-of select="@lookuptype"/></td>
		<td></td>
	</tr>
	</xsl:for-each>
</table>
<i  class="footNote">* Combo - provides combo-box in application for value selection. Window - provides dialog window for value selection/lookup. Window is typically used fot more complex tables or tables with a lot of records.</i>
</p>
<br/>

<!-- workflow -->
<h1>RDM workflow</h1>
<p>Detailní popis relevantních RDM procesů - zakladání dat, aktualizace dat, mazání/zneplatnění dat (CRUD operace).</p>
<h2>Uživatelské role</h2>
<p>Popis uživatelských rolí zapojených v procesech a jejich přístupová práva.</p>
<p><i>Následující tabulka poskytuje seznam definovaných rolí a prístupových práv k číselníku</i></p>
<p>
<table>
	<tr>
		<th>Role #</th>
		<th>Název uživatelské role</th>
		<th>Popis uživatelské role</th>
		<th>CRUD</th>
		<th>Atribut</th>
		<th>Komentář</th>
	</tr>
	<xsl:for-each select="$rdmWorkflowRef/entities/entity[@name=$currentTableName]/workflows/workflow[@editOperation = 'Create']/steps/step/statements/statement/roles/role">				
		<xsl:if test="not(preceding-sibling::role[@name=$currentTableName])">
		<tr>
			<td class="cellAlignCenter">#R<xsl:value-of select="format-number((count(preceding::role)+1)*1,'00')"/></td>
			<td><xsl:value-of select="@name"/></td>
			<td><xsl:value-of select="$rdmSecurityRef/security/fileRepository/roles/role[@name=$currentTableName]/@description"/></td>
			<td></td>
			<td></td>
			<td></td>
		</tr>
		</xsl:if>
	</xsl:for-each>
	<xsl:variable name="cnt" select="count($rdmWorkflowRef/entities/entity[@name=$currentTableName]/workflows/workflow[@editOperation = 'Create']/steps/step/statements/statement/roles/role)"/>
	<xsl:for-each select="$rdmWorkflowRef/entities/entity[@name=$currentTableName]/*/createNotification/emailCreateNotification/createRoles/createRole">				
		<xsl:if test="not(preceding-sibling::createRole[@role=current()/@role]) and @role!=$rdmWorkflowRef/entities/entity[@name=$currentTableName]/workflows/workflow[@editOperation = 'Create']/steps/step/statements/statement/roles/role/@name">
		<tr>
			<td class="cellAlignCenter">#R<xsl:value-of select="format-number((count(preceding::createRole)+$cnt+1)*1,'00')"/></td>
			<td><xsl:value-of select="@role"/></td>
			<td><xsl:value-of select="$rdmSecurityRef/security/fileRepository/roles/role[@name=current()/@role]/@description"/></td>
			<td></td>
			<td></td>
			<td></td>
		</tr>
		</xsl:if>
	</xsl:for-each>	
	<xsl:variable name="cnt2" select="count($rdmWorkflowRef/entities/entity[@name=$currentTableName]/*/createNotification/emailCreateNotification/createRoles/createRole)"/>			
	<xsl:for-each select="$rdmWorkflowRef/entities/entity[@name=$currentTableName]/workflows/workflow[@editOperation='Update']/steps/step/statements/statement/roles/role">
		<xsl:if test="not(preceding-sibling::role[@name=$currentTableName]) and @name!=$rdmWorkflowRef/entities/entity[@name=$currentTableName]/*/createNotification/emailCreateNotification/createRoles/createRole/@role and $rdmWorkflowRef/entities/entity[@name=$currentTableName]/workflows/workflow[@editOperation = 'Create']/steps/step/statements/statement/roles/role/@name">
		<tr>
			<td class="cellAlignCenter">#R<xsl:value-of select="format-number((count(preceding::role)+$cnt+$cnt2+1)*1,'00')"/></td>
			<td><xsl:value-of select="@name"/></td>
			<td><xsl:value-of select="$rdmSecurityRef/security/fileRepository/roles/role[@name=$currentTableName]/@description"/></td>
			<td></td>
			<td></td>
			<td></td>
		</tr>
		</xsl:if>
	</xsl:for-each>
	<xsl:variable name="cnt3" select="count($rdmWorkflowRef/entities/entity[@name=$currentTableName]/workflows/workflow[@editOperation='Update']/steps/step/statements/statement/roles/role)"/>				
	<xsl:for-each select="$rdmWorkflowRef/entities/entity[@name=$currentTableName]/*/updateNotification/emailUpdateNotification/updateRoles/updateRole">
		<xsl:if test="not(preceding-sibling::updateRole[@role=current()/@role]) and @role!=$rdmWorkflowRef/entities/entity[@name=$currentTableName]/workflows/workflow[@editOperation = 'Create' and @editOperation='Update']/steps/step/statements/statement/roles/role/@name and @name!=$rdmWorkflowRef/entities/entity[@name=$currentTableName]/*/createNotification/emailCreateNotification/createRoles/createRole/@role">
		<tr>
			<td class="cellAlignCenter">#R<xsl:value-of select="format-number((count(preceding::createRole)+$cnt+$cnt2+cnt3+1)*1,'00')"/></td>
			<td><xsl:value-of select="@role"/></td>
			<td><xsl:value-of select="$rdmSecurityRef/security/fileRepository/roles/role[@name=current()/@role]/@description"/></td>
			<td></td>
			<td></td>
			<td></td>
		</tr>
		</xsl:if>
	</xsl:for-each>
	<xsl:variable name="cnt4" select="count($rdmWorkflowRef/entities/entity[@name=$currentTableName]/*/updateNotification/emailUpdateNotification/updateRoles/updateRole)"/>
	<xsl:for-each select="$rdmWorkflowRef/entities/entity[@name=$currentTableName]/workflows/workflow[@editOperation = 'Delete']/steps/step/statements/statement/roles/role">
		<xsl:if test="not(preceding-sibling::role[@name=$currentTableName]) and @name!=$rdmWorkflowRef/entities/entity[@name=$currentTableName]/*/updateNotification/emailCreateNotification/updateRoles/updateRole/@role and @name!=$rdmWorkflowRef/entities/entity[@name=$currentTableName]/*/createNotification/emailCreateNotification/createRoles/createRole/@role and $rdmWorkflowRef/entities/entity[@name=$currentTableName]/workflows/workflow[@editOperation = 'Create' and @editOperation = 'Update']/steps/step/statements/statement/roles/role/@name">
		<tr>
			<td class="cellAlignCenter">#R<xsl:value-of select="format-number((count(preceding::role)+$cnt+$cnt2+$cnt3+$cnt4+1)*1,'00')"/></td>
			<td><xsl:value-of select="@name"/></td>
			<td><xsl:value-of select="$rdmSecurityRef/security/fileRepository/roles/role[@name=$currentTableName]/@description"/></td>
			<td></td>
			<td></td>
			<td></td>
		</tr>
		</xsl:if>
	</xsl:for-each>
	<xsl:variable name="cnt5" select="count($rdmWorkflowRef/entities/entity[@name=$currentTableName]/workflows/workflow[@editOperation = 'Delete']/steps/step/statements/statement/roles/role)"/>
	<xsl:for-each select="$rdmWorkflowRef/entities/entity[@name=$currentTableName]/*/deleteNotification/emailDeleteNotification/deleteRoles/deleteRole">
		<xsl:if test="not(preceding-sibling::deleteRole[@role=current()/@role]) and @role!=$rdmWorkflowRef/entities/entity[@name=$currentTableName]/workflows/workflow[@editOperation = 'Create' and @editOperation='Update' and @editOperation='Delete']/steps/step/statements/statement/roles/role/@name and @name!=$rdmWorkflowRef/entities/entity[@name=$currentTableName]/*/createNotification/emailCreateNotification/createRoles/createRole/@role and @name!=$rdmWorkflowRef/entities/entity[@name=$currentTableName]/*/updateNotification/emailCreateNotification/updateRoles/updateRole/@role">
		<tr>
			<td class="cellAlignCenter">#R<xsl:value-of select="format-number((count(preceding::createRole)+$cnt+$cnt2+$cnt3+$cnt4+$cnt5+1)*1,'00')"/></td>
			<td><xsl:value-of select="@role"/></td>
			<td><xsl:value-of select="$rdmSecurityRef/security/fileRepository/roles/role[@name=current()/@role]/@description"/></td>
			<td></td>
			<td></td>
			<td></td>
		</tr>
		</xsl:if>
	</xsl:for-each>
</table>
<i  class="footNote">* Více informaci o CRUD operacích http://en.wikipedia.org/wiki/Create,_read,_update_and_delete;  </i>
<i  class="footNote">* Jestliže jsou práva limitována pouze na určité atributy číselníku, je v tabulce uveden jejich výčet nebo reference na datový model.</i>
</p>
<br/>

<h2>RDM workflow desing</h2>
<h3>Výtvoření nového záznamu</h3>
<p>Byznys proces vytvoření nového záznamu v číselníku <xsl:value-of select="@label"/>.</p>
<p>[schéma procesu]</p>
<br/>
<p>
<table>
	<tr>
		<th>Krok procesu #</th>
		<th>Popis kroku procesu</th>
		<th>Následující krok</th>
		<th>Role a příslušné notifikace</th>
		<th>Komentář</th>
	</tr>
	<xsl:choose>
	<xsl:when test="$rdmWorkflowRef/entities/entity[@name=$currentTableName]/workflows/workflow[@editOperation = 'Create']/steps/step/@id != ''">
	<xsl:for-each select="$rdmWorkflowRef/entities/entity[@name=$currentTableName]/workflows/workflow[@editOperation = 'Create']/steps/step">
	<tr>
		<td class="cellAlignCenter">#P<xsl:value-of select="format-number((count(preceding-sibling::step)+1)*1,'00')"/></td>
		<td><xsl:value-of select="$rdmWorkflowRef/statuses/status[@id=current()/@id]/@label"/></td>
		<td><xsl:value-of select="$rdmWorkflowRef/statuses/status[@id=current()/@transitionTarget]/@label"/></td>
		<td>
			<table class="embeddedTable">
				<xsl:choose>
					<xsl:when test="$rdmWorkflowRef/statuses/status[@id=current()/@id]/@label != 'Publish'">
						<xsl:for-each select="statements/statement">
							<tr class="embedded">
								<td class="embedded embeddedFixed">
									<xsl:for-each select="roles/role">
										<xsl:if test="position()!=last()">
											<xsl:value-of select="@name"/><xsl:text>; </xsl:text>
										</xsl:if>
										<xsl:if test="position()=last()">
											<xsl:value-of select="@name"/>
										</xsl:if>
									</xsl:for-each>
								</td>					
								<td class="embedded">
									<xsl:value-of select="@emailNotification"/>
								</td>						
							</tr>
						</xsl:for-each>
					</xsl:when>
					<xsl:otherwise>
						<xsl:for-each select="ancestor::entity[@name=$currentTableName]/notifications/createNotification/emailCreateNotification">
							<tr class="embedded">
								<td class="embedded embeddedFixed">
									<xsl:for-each select="createRoles/createRole">
										<xsl:if test="position()!=last()">
											<xsl:value-of select="@role"/><xsl:text>; </xsl:text>
										</xsl:if>
										<xsl:if test="position()=last()">
											<xsl:value-of select="@role"/>
										</xsl:if>
									</xsl:for-each>
								</td>					
								<td class="embedded">
									<xsl:value-of select="@email"/>
								</td>						
							</tr>
						</xsl:for-each>
					</xsl:otherwise>
				</xsl:choose>																	
			</table>
		</td>
		<td></td>
	</tr>
	</xsl:for-each>	
	</xsl:when>
	<xsl:otherwise>
	<tr>
		<td class="cellAlignCenter">#P<xsl:value-of select="format-number((count(preceding-sibling::step)+1)*1,'00')"/></td>
		<td><xsl:value-of select="'Edit'"/></td>
		<td><xsl:value-of select="'Publish'"/></td>
		<td>
			<table class="embeddedTable">
			</table>
		</td>
		<td></td>
	</tr>
	<tr>
		<td class="cellAlignCenter">#P<xsl:value-of select="format-number((count(preceding-sibling::step)+2)*1,'00')"/></td>
		<td><xsl:value-of select="'Publish'"/></td>
		<td><xsl:value-of select="''"/></td>
		<td>
			<table class="embeddedTable">
				<xsl:for-each select="$rdmWorkflowRef/entities/entity[@name=$currentTableName]/notifications/createNotification/emailCreateNotification">
				<tr class="embedded">
					<td class="embedded embeddedFixed">
						<xsl:for-each select="createRoles/createRole">
							<xsl:if test="position()!=last()">
								<xsl:value-of select="@role"/><xsl:text>; </xsl:text>
							</xsl:if>
							<xsl:if test="position()=last()">
								<xsl:value-of select="@role"/>
							</xsl:if>
						</xsl:for-each>
					</td>
					<td class="embedded">
						<xsl:value-of select="@email"/>
					</td>					
				</tr>
				</xsl:for-each>
			</table>
		</td>
		<td></td>
	</tr>	
	</xsl:otherwise>
	</xsl:choose>	
</table>
</p>

<h3>Aktualizace existujícího záznamu</h3>
<p>Byznys proces aktualizace existujícího záznamu v číselníku <xsl:value-of select="@label"/>.</p>
<p>[schéma procesu]</p>
<br/>
<p>
<table>
	<tr>
		<th>Krok procesu #</th>
		<th>Popis kroku procesu</th>
		<th>Následující krok</th>
		<th>Role a příslušné notifikace</th>
		<th>Komentář</th>
	</tr>
	<xsl:choose>
	<xsl:when test="$rdmWorkflowRef/entities/entity[@name=$currentTableName]/workflows/workflow[@editOperation = 'Update']/steps/step/@id != ''">
	<xsl:for-each select="$rdmWorkflowRef/entities/entity[@name=$currentTableName]/workflows/workflow[@editOperation = 'Update']/steps/step">
	<tr>
		<td class="cellAlignCenter">#P<xsl:value-of select="format-number((count(preceding-sibling::step)+1)*1,'00')"/></td>
		<td><xsl:value-of select="$rdmWorkflowRef/statuses/status[@id=current()/@id]/@label"/></td>
		<td><xsl:value-of select="$rdmWorkflowRef/statuses/status[@id=current()/@transitionTarget]/@label"/></td>
		<td>
			<table class="embeddedTable">
				<xsl:for-each select="statements/statement">
					<xsl:variable name="notification" select="@emailNotification"/>
					<tr class="embedded">
						<td class="embedded embeddedFixed">
							<xsl:for-each select="roles/role">
								<xsl:if test="position()!=last()">
									<xsl:value-of select="@name"/><xsl:text>; </xsl:text>
								</xsl:if>
								<xsl:if test="position()=last()">
									<xsl:value-of select="@name"/>
								</xsl:if>
							</xsl:for-each>
						</td>
						<td class="embedded">
							<xsl:value-of select="$notification"/>
						</td>						
					</tr>
				</xsl:for-each>
			</table>
		</td>
		<td></td>
	</tr>
	</xsl:for-each>
	</xsl:when>
	<xsl:otherwise>
	<tr>
		<td class="cellAlignCenter">#P<xsl:value-of select="format-number((count(preceding-sibling::step)+1)*1,'00')"/></td>
		<td><xsl:value-of select="'Edit'"/></td>
		<td><xsl:value-of select="'Publish'"/></td>
		<td>
			<table class="embeddedTable">
			</table>
		</td>
		<td></td>
	</tr>
	<tr>
		<td class="cellAlignCenter">#P<xsl:value-of select="format-number((count(preceding-sibling::step)+2)*1,'00')"/></td>
		<td><xsl:value-of select="'Publish'"/></td>
		<td><xsl:value-of select="''"/></td>
		<td>
			<table class="embeddedTable">
				<xsl:for-each select="$rdmWorkflowRef/entities/entity[@name=$currentTableName]/notifications/updateNotification/emailUpdateNotification">
				<tr class="embedded">
					<td class="embedded embeddedFixed">
						<xsl:for-each select="updateRoles/updateRole">
							<xsl:if test="position()!=last()">
								<xsl:value-of select="@role"/><xsl:text>; </xsl:text>
							</xsl:if>
							<xsl:if test="position()=last()">
								<xsl:value-of select="@role"/>
							</xsl:if>
						</xsl:for-each>
					</td>
					<td class="embedded">
						<xsl:value-of select="@email"/>
					</td>					
				</tr>
				</xsl:for-each>
			</table>
		</td>
		<td></td>
	</tr>	
	</xsl:otherwise>
	</xsl:choose>
</table>
</p>

<h3>Mazání/zneplatnění existujícího záznamu</h3>
<p>Byznys proces mazání/zneplatnění existujícího záznamu v číselníku <xsl:value-of select="@label"/>.</p>
<p>[schéma procesu]</p>
<br/>
<p>
<table>
	<tr>
		<th>Krok procesu #</th>
		<th>Popis kroku procesu</th>
		<th>Následující krok</th>
		<th>Role a příslušné notifikace</th>
		<th>Komentář</th>
	</tr>
	<xsl:choose>
	<xsl:when test="$rdmWorkflowRef/entities/entity[@name=$currentTableName]/workflows/workflow[@editOperation = 'Delete']/steps/step/@id != ''">
	<xsl:for-each select="$rdmWorkflowRef/entities/entity[@name=$currentTableName]/workflows/workflow[@editOperation = 'Delete']/steps/step">
	<tr>
		<td class="cellAlignCenter">#P<xsl:value-of select="format-number((count(preceding-sibling::step)+1)*1,'00')"/></td>
		<td><xsl:value-of select="$rdmWorkflowRef/statuses/status[@id=current()/@id]/@label"/></td>
		<td><xsl:value-of select="$rdmWorkflowRef/statuses/status[@id=current()/@transitionTarget]/@label"/></td>
		<td>
			<table class="embeddedTable">
				<xsl:for-each select="statements/statement">
					<xsl:variable name="notification" select="@emailNotification"/>
					<tr class="embedded">
						<td class="embedded embeddedFixed">
							<xsl:for-each select="roles/role">
								<xsl:if test="position()!=last()">
									<xsl:value-of select="@name"/><xsl:text>; </xsl:text>
								</xsl:if>
								<xsl:if test="position()=last()">
									<xsl:value-of select="@name"/>
								</xsl:if>
							</xsl:for-each>
						</td>
						<td class="embedded">
							<xsl:value-of select="$notification"/>
						</td>						
					</tr>
				</xsl:for-each>
			</table>
		</td>
		<td></td>
	</tr>
	</xsl:for-each>	
	</xsl:when>
	<xsl:otherwise>
	<tr>
		<td class="cellAlignCenter">#P<xsl:value-of select="format-number((count(preceding-sibling::step)+1)*1,'00')"/></td>
		<td><xsl:value-of select="'Edit'"/></td>
		<td><xsl:value-of select="'Publish'"/></td>
		<td>
			<table class="embeddedTable">
			</table>
		</td>
		<td></td>
	</tr>
	<tr>
		<td class="cellAlignCenter">#P<xsl:value-of select="format-number((count(preceding-sibling::step)+2)*1,'00')"/></td>
		<td><xsl:value-of select="'Publish'"/></td>
		<td><xsl:value-of select="''"/></td>
		<td>
			<table class="embeddedTable">
				<xsl:for-each select="$rdmWorkflowRef/entities/entity[@name=$currentTableName]/notifications/deleteNotification/emailDeleteNotification">
				<tr class="embedded">
					<td class="embedded embeddedFixed">
						<xsl:for-each select="createRoles/createRole">
							<xsl:if test="position()!=last()">
								<xsl:value-of select="@role"/><xsl:text>; </xsl:text>
							</xsl:if>
							<xsl:if test="position()=last()">
								<xsl:value-of select="@role"/>
							</xsl:if>
						</xsl:for-each>
					</td>
					<td class="embedded">
						<xsl:value-of select="@email"/>
					</td>					
				</tr>
				</xsl:for-each>
			</table>
		</td>
		<td></td>
	</tr>	
	</xsl:otherwise>
	</xsl:choose>
</table>
</p>

<h3>Notifikace</h3>
<p><i>Seznam notifikací a specifikace emailových šablon pro emailovou komunikaci.</i></p>
<p>
<table>
	<tr>
		<th>Notifikace #</th>
		<th>Notifikace</th>
		<th>Text emailové notifikace</th>
		<th>Komentář</th>
	</tr>
	<xsl:for-each select="$rdmWorkflowRef/entities/entity[@name=$currentTableName]/workflows/workflow[@editOperation = 'Create']/steps/step/statements/statement">
	<tr>
		<td class="cellAlignCenter">#N<xsl:value-of select="format-number((count(preceding::statement)+1)*1,'00')"/></td>
		<td><xsl:value-of select="@emailNotification"/></td>
		<td>	
		<xsl:value-of select="$rdmWorkflowRef/emails/email[@name=current()/@emailNotification]/message|$rdmWorkflowRef//emails/email[@name=current()/@emailNotification]/@message"/></td>
		<td></td>
	</tr>
	</xsl:for-each>
	<xsl:variable name="cnt" select="count($rdmWorkflowRef/entities/entity[@name=$currentTableName]/workflows/workflow[@editOperation = 'Create']/steps/step/statements/statement)"/>		
	<xsl:for-each select="$rdmWorkflowRef/entities/entity[@name=$currentTableName]/notifications/createNotification/emailCreateNotification[@email!=$rdmWorkflowRef/entities/entity[@name=$currentTableName]/workflows/workflow[@editOperation = 'Create']/steps/step/statements/statement/@emailNotification]">
	<tr>
		<td class="cellAlignCenter">#N<xsl:value-of select="format-number((count(preceding::statement)+$cnt+1)*1,'00')"/></td>
		<td><xsl:value-of select="@email"/></td>
		<td>	
		<xsl:value-of select="$rdmWorkflowRef/emails/email[@name=current()/@email]/message|$rdmWorkflowRef//emails/email[@name=current()/@email]/@message"/></td>
		<td></td>
	</tr>		
	</xsl:for-each>
	<xsl:variable name="cnt2" select="count($rdmWorkflowRef/entities/entity[@name=$currentTableName]/notifications/createNotification/emailCreateNotification[@email!=$rdmWorkflowRef/entities/entity[@name=$currentTableName]/workflows/workflow[@editOperation = 'Create']/steps/step/statements/statement/@emailNotification])"/>
	<xsl:for-each select="$rdmWorkflowRef/entities/entity[@name=$currentTableName]/workflows/workflow[@editOperation = 'Update']/steps/step/statements/statement[@emailNotification!=$rdmWorkflowRef/entities/entity[@name=$currentTableName]/workflows/workflow[@editOperation = 'Create']/steps/step/statements/statement/@emailNotification and @emailNotification!=$rdmWorkflowRef/entities/entity[@name=$currentTableName]/notifications/createNotification/emailCreateNotification/@email]">
	<tr>
		<td class="cellAlignCenter">#N<xsl:value-of select="format-number((count(preceding::statement)+$cnt+cnt2+1)*1,'00')"/></td>
		<td><xsl:value-of select="@emailNotification"/></td>
		<td>	
		<xsl:value-of select="$rdmWorkflowRef/emails/email[@name=current()/@emailNotification]/message|$rdmWorkflowRef//emails/email[@name=current()/@emailNotification]/@message"/></td>
		<td></td>
	</tr>
	</xsl:for-each>
	<xsl:variable name="cnt3" select="count($rdmWorkflowRef/entities/entity[@name=$currentTableName]/workflows/workflow[@editOperation = 'Update']/steps/step/statements/statement)"/>
	<xsl:for-each select="$rdmWorkflowRef/entities/entity[@name=$currentTableName]/notifications/updateNotification/emailUpdateNotification[@email!=$rdmWorkflowRef/entities/entity[@name=$currentTableName]/workflows/workflow[@editOperation = 'Create']/steps/step/statements/statement/@emailNotification and @email!=$rdmWorkflowRef/entities/entity[@name=$currentTableName]/notifications/createNotification/emailCreateNotification/@email and @email!=$rdmWorkflowRef/entities/entity[@name=$currentTableName]/workflows/workflow[@editOperation = 'Update']/steps/step/statements/statement/@emailNotification]">
	<tr>
		<td class="cellAlignCenter">#N<xsl:value-of select="format-number((count(preceding::statement)+$cnt+cnt2+cnt3+1)*1,'00')"/></td>
		<td><xsl:value-of select="@email"/></td>
		<td>	
		<xsl:value-of select="$rdmWorkflowRef/emails/email[@name=current()/@email]/message|$rdmWorkflowRef//emails/email[@name=current()/@email]/@message"/></td>
		<td></td>
	</tr>		
	</xsl:for-each>
	<xsl:variable name="cnt4" select="count($rdmWorkflowRef/entities/entity[@name=$currentTableName]/notifications/updateNotification/emailUpdateNotification)"/>	
	<xsl:for-each select="$rdmWorkflowRef/entities/entity[@name=$currentTableName]/workflows/workflow[@editOperation = 'Delete']/steps/step/statements/statement[@emailNotification!=$rdmWorkflowRef/entities/entity[@name=$currentTableName]/workflows/workflow[@editOperation = 'Create']/steps/step/statements/statement/@emailNotification and @emailNotification!=$rdmWorkflowRef/entities/entity[@name=$currentTableName]/notifications/createNotification/emailCreateNotification/@email and @emailNotification!=$rdmWorkflowRef/entities/entity[@name=$currentTableName]/workflows/workflow[@editOperation = 'Update']/steps/step/statements/statement/@emailNotification and @emailNotification!=$rdmWorkflowRef/entities/entity[@name=$currentTableName]/notifications/updateNotification/emailUpdateNotification/@email]">
	<tr>
		<td class="cellAlignCenter">#N<xsl:value-of select="format-number((count(preceding::statement)+$cnt+$cnt2+$cnt3+$cnt4+1)*1,'00')"/></td>
		<td><xsl:value-of select="@emailNotification"/></td>
		<td>	
		<xsl:value-of select="$rdmWorkflowRef/emails/email[@name=current()/@emailNotification]/message|$rdmWorkflowRef//emails/email[@name=current()/@emailNotification]/@message"/></td>
		<td></td>
	</tr>
	</xsl:for-each>
	<xsl:variable name="cnt5" select="count($rdmWorkflowRef/entities/entity[@name=$currentTableName]/workflows/workflow[@editOperation = 'Delete']/steps/step/statements/statement)"/>	
	<xsl:for-each select="$rdmWorkflowRef/entities/entity[@name=$currentTableName]/notifications/deleteNotification/emailDeleteNotification[@email!=$rdmWorkflowRef/entities/entity[@name=$currentTableName]/workflows/workflow[@editOperation = 'Create']/steps/step/statements/statement/@emailNotification and @email!=$rdmWorkflowRef/entities/entity[@name=$currentTableName]/notifications/createNotification/emailCreateNotification/@email and @email!=$rdmWorkflowRef/entities/entity[@name=$currentTableName]/workflows/workflow[@editOperation = 'Update']/steps/step/statements/statement/@emailNotification and @email!=$rdmWorkflowRef/entities/entity[@name=$currentTableName]/notifications/updateNotification/emailUpdateNotification/@email and @email!=$rdmWorkflowRef/entities/entity[@name=$currentTableName]/workflows/workflow[@editOperation = 'Delete']/steps/step/statements/statement/@emailNotification]">
	<tr>
		<td class="cellAlignCenter">#N<xsl:value-of select="format-number((count(preceding::statement)+$cnt+$cnt2+$cnt3+$cnt4+$cnt5+1)*1,'00')"/></td>
		<td><xsl:value-of select="@email"/></td>
		<td>	
		<xsl:value-of select="$rdmWorkflowRef/emails/email[@name=current()/@email]/message|$rdmWorkflowRef//emails/email[@name=current()/@email]/@message"/></td>
		<td></td>
	</tr>		
	</xsl:for-each>
</table>
</p>
<br/>


<!-- synchronization -->
<h1>Architektura synchronizace</h1>
<xsl:choose>
<xsl:when test="$rdmSystemRef/databaseSystems/databaseSystem != ''">
<p><i>Popis synchronizačních/integračních scénářů, zúčastněných systémů, interfaců, atd.</i></p>
<p>[schéma architektury]</p>
<br/>
<p><i>Následující tabulka popisuje komponenty/systémy, které jsou součástí integračního scénáře</i></p>
<p>
<table>
	<tr>
		<th>Komponenta #</th>
		<th>Název systemu/komponenty</th>
		<th>Popis komponenty</th>
		<th>Technologická platforma</th>
		<th>Komentář</th>
	</tr>
	<xsl:for-each select="$rdmSystemRef/databaseSystems/databaseSystem[tables/table/@synchronizeWith=$currentTableName]">
	<tr>
		<td class="cellAlignCenter">#C<xsl:value-of select="format-number((count(preceding::notification)+1)*1,'00')"/></td>
		<td><xsl:value-of select="@name"/></td>
		<td><xsl:value-of select="@description"/></td>
		<td>
	 	<xsl:choose>
	 		<xsl:when test="$rdmDataSourceRef/dataSources/dataSource[@name = current()/@dataSourceName]/@driverClass = 'org.apache.derby.jdbc.ClientDriver'"> 
	 			<xsl:value-of select="'Apache Derby'"/>
	 		</xsl:when>
	 		<xsl:when test="$rdmDataSourceRef/dataSources/dataSource[@name = current()/@dataSourceName]/@driverClass = 'com.microsoft.sqlserver.jdbc.SQLServerDriver'"> 
	 			<xsl:value-of select="'MS SQL'"/>
	 		</xsl:when>
	 		<xsl:when test="$rdmDataSourceRef/dataSources/dataSource[@name = current()/@dataSourceName]/@driverClass = 'oracle.jdbc.OracleDriver'"> 
	 			<xsl:value-of select="'Oracle'"/>
	 		</xsl:when>
	 		<xsl:when test="$rdmDataSourceRef/dataSources/dataSource[@name = current()/@dataSourceName]/@driverClass = 'org.postgresql.Driver'"> 
	 			<xsl:value-of select="'PosgreSQL'"/>
	 		</xsl:when>
	 		<xsl:when test="$rdmDataSourceRef/dataSources/dataSource[@name = current()/@dataSourceName]/@driverClass = 'com.teradata.jdbc.TeraDriver'"> 
	 			<xsl:value-of select="'Teradata'"/>
	 		</xsl:when>
	 	</xsl:choose>
		</td>
		<td></td>
	</tr>
	</xsl:for-each>
</table>
</p>

<h2>Popis toku dat</h2>
<p><i>Popis očekávaného toku dat mezi systémy a RDM zahrnující typ interfacu a periodicitu.</i></p>
<p>
<table>
	<tr>
		<th>Interface #</th>
		<th>Poskytovatel</th>
		<th>Konzument</th>
		<th>Směr</th>
		<th>Typ interfacu</th>
		<th>Periodicita</th>
		<th>Komentář</th>
	</tr>
	<xsl:for-each select="$rdmSystemRef/databaseSystems/databaseSystem[tables/table/@synchronizeWith=$currentTableName]">
	<tr>
		<td class="cellAlignCenter">#I<xsl:value-of select="format-number((count(preceding::notification)+1)*1,'00')"/></td>
		<td>RDM</td>
		<td><xsl:value-of select="@name"/></td>
		<td class="cellAlignCenter">--></td>
		<td>ETL</td>
		<td><xsl:value-of select="tables/table[@synchronizeWith = $currentTableName]/@periodicity"/></td>
		<td></td>
	</tr>
	</xsl:for-each>
</table>
</p>
<br/>

<h2>Detailní popis interfaců</h2>
<p><i>Popis všech souvisejících interfaců zahrnující detailní specifikace interfacu, parametry připojení - např.
<ul>
<li>Pro tabulku/etl poskytnutí struktury tabulky (ideálně DDL skript), připojení, protokol</li>
<li>Pro webové servisy poskytnutí WSDL schématu, XSD, atd.</li>
</ul>
</i></p>
<br/>

<h3>Mapování mezi zdrojovými/cílovými systémy</h3>
<p><i>Následující sekce poskytuje specifikaci dat ze zdrojových systémů. Tato sekce je použita pouze v případě, že RDM číselník je synchronizován s ostatními systémy (jak pro download dat, tak pro upload dat).</i></p>
<br/>

<xsl:for-each select="$rdmSystemRef/databaseSystems/databaseSystem[tables/table/@synchronizeWith=$currentTableName]">
<h3>Mapování zdrojový/cílový systém - <xsl:value-of select="@name"/></h3>
<p>
<table>
	<tr>
		<th>Tabulka #</th>
		<th>Název tabulky</th>
		<th>Popis tabulky</th>
		<th>Komentář</th>
	</tr>
	<xsl:for-each select="$rdmSystemRef/databaseSystems/databaseSystemtables/table[@synchronizeWith=$currentTableName]">
	<tr>
		<td class="cellAlignCenter">#ST<xsl:value-of select="format-number((count(preceding::notification)+1)*1,'00')"/></td>
		<td><xsl:value-of select="@name"/></td>
		<td><xsl:value-of select="@description"/></td>
		<td></td>
	</tr>
	</xsl:for-each>
</table>
</p>
<br/>
<p>
<table>
	<tr>
		<th>Atribut #</th>
		<th>Název tabulky</th>
		<th>Název atributu</th>
		<th>Dotový typ</th>
		<th>M</th>
		<th>Komentář</th>
	</tr>
	<xsl:for-each select="$rdmSystemRef/databaseSystems/databaseSystemtables/table[@synchronizeWith=$currentTableName]/columns/column">
	<tr>
		<td class="cellAlignCenter">#SA<xsl:value-of select="format-number((count(preceding::notification)+1)*1,'00')"/></td>
		<td><xsl:value-of select="ancestor::table/@name"/></td>
		<td><xsl:value-of select="@name"/></td>
		<td class="cellAlignCenter"><xsl:value-of select="@dbType"/></td>
		<td class="cellAlignCenter"><xsl:value-of select="if(@required='true') then '*' else ''"/></td>
		<td></td>
	</tr>
	</xsl:for-each>
</table>
</p>
<br/>
<p>
<table>
	<tr>
		<th>Atribut #</th>
		<th>RDM tabulka.atribut</th>
		<th>Zdrojová/cílová tabulka.atribut</th>
		<th>Mapovací pravidlo</th>
		<th>Komentář</th>
	</tr>
	<xsl:for-each select="$rdmSystemRef/databaseSystems/databaseSystemtables/table[@synchronizeWith=$currentTableName]/columns/column">
	<tr>
		<td class="cellAlignCenter">#M<xsl:value-of select="format-number((count(preceding::notification)+1)*1,'00')"/></td>
		<td><xsl:value-of select="ancestor::table/@name"/>.<br/><xsl:value-of select="@mappedColumn"/></td>
		<td><xsl:value-of select="ancestor::table/@name"/>.<br/><xsl:value-of select="@name"/></td>
		<td>1:1</td>
		<td></td>
	</tr>
	</xsl:for-each>
</table>
</p>
</xsl:for-each>
</xsl:when>
<xsl:otherwise>
<p>Žádné synchronizační/integrační scénáře nebyly definovány.</p>
</xsl:otherwise>
</xsl:choose>
<br/>

<!-- footer -->
<p class="border"></p>
<p>Tento dokument byl vygenerován na základě metadat <xsl:value-of  select="current-date"/></p>
</xsl:if>

</body>
</html>

</xsl:template>


</xsl:stylesheet>
