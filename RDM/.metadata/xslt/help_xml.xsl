<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="xml" encoding="UTF-8" indent="yes"/>

<xsl:template match="*">

<help-config>
	<header>
<style type="text/css">
@media print {
h1{page-break-before:always;}}


.footNote {
	font-size: 11px;
	}  
.tableVerticalHeader {
	text-align:left;
	}
.tableVerticalHeader {
	text-align:left;
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
		width:655px;
		text-align:justify;
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
ul {font:100% Candara,Calibri,Seoge,Optima,Arial,sans-serif;
	font-size:12px;
	}
ul.square {list-style-type:square;}
ol {font:100% Candara,Calibri,Seoge,Optima,Arial,sans-serif;
	font-size:12px;
	}
li {font:100% Candara,Calibri,Seoge,Optima,Arial,sans-serif;
	font-size:12px;
	width:615px;
	text-align:justify;
	}
#page {
	width: 655px;
	margin-top: 30px;
	margin-bottom: 30px;
	margin-left: auto;
	margin-right: auto;
	padding: 15px;
	}
p.title  {font:100% Candara,Calibri,Seoge,Optima,Arial,sans-serif;
		font-weight:bold;
		font-size: 22px;
		margin-bottom:13px;
		padding-left:9px;
	}
</style>

<div id="page">
<img src="doc/img/logo.png" alt="Logo" align="right"/><br/>
<br/>
<p class="border"></p>
<p>Browse topics in the Contents. Click on a topic to have it displayed. Use the Back and Forward buttons to navigate within the history of viewed topics.</p>

<p class="title">Reference Data Manager - Help Contents</p>
	<ol>
		<li><a href="doc/usersGuide/introduction.html">Introduction</a></li>
		<li><a href="doc/usersGuide/getting_started.html">Getting Started</a></li>
		<li><a href="doc/usersGuide/data.html">Data</a></li>
		<li><a href="doc/usersGuide/workflows.html">Workflows</a></li>
		<li><a href="doc/usersGuide/publish.html">Publish</a></li>
		<li><a href="doc/usersGuide/synchronization.html">Synchronization</a></li>
		<li><a href="doc/usersGuide/change_log.html">Change Log</a></li>
		<li><a href="doc/usersGuide/system.html">System</a></li>
	</ol>
<br/>

<p class="title">Reference Data Manager - Documentation Contents</p>
	<ul class="square">
		<li><a href="doc/documentation_business_index.html">Business Documentation</a></li>
		<li><a href="doc/documentation_technical_index.html">Technical Documentation</a></li>
	</ul>
</div>

	</header>
	<footer>
	</footer>
</help-config>


</xsl:template>

</xsl:stylesheet>	
