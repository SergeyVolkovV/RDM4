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

<html xmlns:exsl="http://exslt.org/common">
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

<h1>Table Specification</h1>


<!-- chapter data model -->
<h2>Master data repository schema</h2>
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
	<xsl:variable name="currentColumn" select="@name"/>
	<tr>
		<td class="cellAlignCenter">#A<xsl:value-of select="format-number((count(preceding::column)+1)*1,'00')"/></td>
		<td><xsl:value-of select="@name"/></td>
		<td><xsl:value-of select="@label"/></td>
		<td class="cellAlignCenter"><xsl:value-of select="$logicalModel/domains/domain[@name=current()/@domain]/@type"/></td>		
		<td class="cellAlignCenter"><xsl:value-of select="$logicalModel/domains/domain[@name=current()/@domain]/@size"/></td>
		<td class="cellAlignCenter"><xsl:value-of select="if($logicalModel/tables/table[@name=$currentTableName]/validations/uniqueKeys/uniqueKey/uniqueKeyColumns/uniqueKeyColumn/@name=$currentColumn) then '*' else ''"/></td>
		<td class="cellAlignCenter"><xsl:value-of select="if($logicalModel/relationships/relationship[@childTable=$currentTableName]/representativeForeignKey/column/@childColumn=$currentColumn) then '*' else ''"/></td>
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
		<td class="cellAlignCenter">#R<xsl:value-of select="format-number((count(preceding-sibling::relationship[@childTable=$currentTableName])+1)*1,'00')"/></td>
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
</p>
<br/>


<!--
<h2>Detailed description of interfaces</h2>
<p><i>Description of all related interfaces, including detailed specification of interface, connectivity parameters etc.
<ul>
<li>For table/ETL interfaces, provide table structures (ideally DDL scripts), connectives, protocols</li>
<li>For web services, provide WSDL schema, XSD, etc.</li>
</ul>
</i></p>

<p>
<pre>
 &lt;xsd:schema targetNamespace="http://www.cdcargo.cz/cca"&gt;
 	&lt;xsd:schema targetNamespace="http://www.cdcargo.cz/cca"&gt;
</pre>
</p>
<br/>
-->
</xsl:if>

</body>
</html>

</xsl:template>
</xsl:stylesheet>
