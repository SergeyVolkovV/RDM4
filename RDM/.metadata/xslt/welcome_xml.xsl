<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
 <xsl:output method="xml" encoding="UTF-8" indent="yes"/>

<xsl:template match="*">

<welcome-config enabled="false">
	<header>
		<div style="font-size: 20px; color: red; margin: 20px 5px 20px 20px;">Welcome to the Reference Data Management site</div>
		<div style="margin: 5px 10px 5px 10px">Here you may find reference books taken on the centralized maintenance in our bank.</div>
		<div style="margin: 10px 10px 0px 10px;">List of supported reference books:</div>
	</header>
	<footer>
		<div style="margin: 10px">If you have any questions related to the system, please contact Data Quality Group team via mail<br/>
			 </div>
	</footer>
</welcome-config>


</xsl:template>

</xsl:stylesheet>	
