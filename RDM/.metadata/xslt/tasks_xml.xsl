<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
 <xsl:output method="xml" encoding="UTF-8" indent="yes"/>

<xsl:template match="*">

<tasks-config>
	<tasks>
	<xsl:for-each select="syncTasks/syncDatabaseTasks/syncDatabaseTask">
		<task name="{@name}">
			<tables>
				<xsl:for-each select="syncTaskTables/syncTaskTable">
					<table table="{@name}" system="{@system}"/>
				</xsl:for-each>
			</tables>
		</task>
	</xsl:for-each>
	</tasks>
</tasks-config>

</xsl:template>
</xsl:stylesheet>