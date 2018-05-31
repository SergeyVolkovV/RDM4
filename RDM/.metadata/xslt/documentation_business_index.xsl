<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:sf="http://www.ataccama.com/xslt/functions"
	xmlns:fn="http://www.w3.org/2005/xpath-functions"
	exclude-result-prefixes="sf fn">
<xsl:output method="xml" encoding="UTF-8" indent="yes"/>

<xsl:param name="security" select="document('param:rdmSecurityRef')"/>
<xsl:param name="rdmAppVariablesRef" select="document('param:rdmAppVariablesRef')"/>

<xsl:template match="/*">
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
.tableCellWidth {
	width:300px;
	}
.border{
	border-bottom:1px solid #D9D9D9;
	}
.lowerCase {
	text-transform:lowercase;
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
		font-size:12px;
		border-width:1px;
		border-style:solid;
		border-color:#BFBFBF;
		padding:2px 5px 2px 5px;
		margin:0;
		border-collapse:collapse;
		text-decoration:none;
		background-color:transparent
	}
th	{font-size:12px;
		
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
<img src="img/logo.png" alt="Logo" align="right"/>
<br/>
<br/>
<p class="border"></p>

<!-- documentation EN -->
<xsl:if test="$rdmAppVariablesRef/appVariables/@docLanguage='English'">
<h1>Reference Data Manager - Content</h1>
<h2>Tables</h2>
<p>Following table enlists reference tables</p>
<p>
<table width="100%">
<tr>
	<th>Label</th>
	<th class="tableCellWidth">Documentation</th>
</tr>
<xsl:for-each select="tables/table">
<xsl:sort select="@label" data-type="text"/>
<tr>
	<td><xsl:value-of select="@label"/></td>
	<td class="tableCellWidth lowerCase"><i><a href="bus/doc_{@name}.html"><xsl:value-of select="@label"/></a></i></td>
</tr>
</xsl:for-each>

</table> 
</p>
<br/>

<h2>Views</h2>
<p>Following table enlists reference tables views</p>
<p>
<table>
<tr>
	<th>Label</th>
	<th class="tableCellWidth">Documentation</th>
</tr>
<xsl:for-each select="views/view[@enable='true']">
<xsl:sort select="@labelView" data-type="text"/>
<tr>
	<td><xsl:value-of select="@labelView"/></td>
	<td class="tableCellWidth lowerCase"><i><a href="bus/doc_{@nameView}.html"><xsl:value-of select="@nameView"/></a></i></td>
</tr>
</xsl:for-each>

</table> 
</p>
</xsl:if>


<!-- documentation CZ -->
<xsl:if test="$rdmAppVariablesRef/appVariables/@docLanguage='Czech'">
<h1>Správa číselníků - seznam číselníků</h1>
<h2>Tabulky</h2>
<p>Následující tabulka obsahuje seznam číselníků</p>
<p>
<table width="100%">
<tr>
	<th>Označení</th>
	<th class="tableCellWidth">Dokumentace</th>
</tr>
<xsl:for-each select="tables/table">
<xsl:sort select="@label" data-type="text"/>
<tr>
	<td><xsl:value-of select="@label"/></td>
	<td class="tableCellWidth lowerCase"><i><a href="bus/doc_{@name}.html"><xsl:value-of select="@label"/></a></i></td>
</tr>
</xsl:for-each>

</table> 
</p>
<br/>

<h2>Views</h2>
<p>Následující tabulka obsahuje seznam číselníkových pohledů</p>
<p>
<table>
<tr>
	<th>Označení</th>
	<th class="tableCellWidth">Dokumentace</th>
</tr>
<xsl:for-each select="views/view[@enable='true']">
<xsl:sort select="@labelView" data-type="text"/>
<tr>
	<td><xsl:value-of select="@labelView"/></td>
	<td class="tableCellWidth lowerCase"><i><a href="bus/doc_{@nameView}.html"><xsl:value-of select="@nameView"/></a></i></td>
</tr>
</xsl:for-each>

</table> 
</p>
</xsl:if>
</body>


</html>
</xsl:template>

</xsl:stylesheet>
