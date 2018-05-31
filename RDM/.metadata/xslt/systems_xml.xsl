<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
 <xsl:output method="xml" encoding="UTF-8" indent="yes"/>

<xsl:template match="*">
	
<system-config>
<systems>

	<xsl:for-each select="systems/databaseSystems/databaseSystem">
		<system name="{@name}">
			<tables>
				<xsl:for-each select="tables/table">
					<xsl:choose>
					<xsl:when test="columns/column/@name != ''">
					<table name="{@name}" input="{../../@name}_{@name}">
						<depends>
							<xsl:for-each select="rdmTables/rdmTable">
								<table name="{@name}"/>
							</xsl:for-each>
						</depends>
					</table>
					</xsl:when>
					
					<xsl:otherwise>
					<table name="{@name}" input="">
						<depends>
							<xsl:for-each select="rdmTables/rdmTable">
								<table name="{@name}"/>
							</xsl:for-each>
						</depends>
					</table>
					</xsl:otherwise>
					</xsl:choose>
				</xsl:for-each>
			</tables>
			<users>
			</users>
		</system>
		
	</xsl:for-each>
	
</systems>
</system-config>

</xsl:template>

</xsl:stylesheet>
