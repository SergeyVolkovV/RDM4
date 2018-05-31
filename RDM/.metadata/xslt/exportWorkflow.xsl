<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:param name="rdmRelationshipRef" select="document('param:rdmRelationshipRef')"/>
<xsl:param name="rdmSystemRef" select="document('param:rdmSystemRef')"/>
<xsl:output method="xml" encoding="UTF-8" indent="yes"/>

<xsl:template match="*">

	<workflow continueOnFailure="false" name="export load" version="1">
		<variables/>
		<tasks>
			<xsl:for-each select="$rdmRelationshipRef/logicalModel/tables/table">
    			<xsl:if test="@batchInterfaceExport='true'">
					<task>
						<id><xsl:value-of select="format-number((count(preceding::table[@batchInterfaceExport='true'])+1)*10,'000')"/></id>
						<name><xsl:value-of select="@name"/></name>
						<acceptMode><xsl:text>AT_LEAST_ONE</xsl:text></acceptMode>
						<executable class="com.ataccama.adt.task.exec.EwfDqcTask">
							<planFile><xsl:text>../plans/batchInterfacesExport/</xsl:text><xsl:value-of select="@name"/><xsl:text>.plan</xsl:text></planFile>
						</executable>
					</task>
				</xsl:if>
			</xsl:for-each>
		</tasks>
		<links>
			<xsl:for-each select="$rdmRelationshipRef/logicalModel/tables/table">
    			<xsl:variable name="next_table" select="following-sibling::table[@batchInterfaceExport='true']/@name"/>
    			
    			<xsl:if test="$next_table != '' and @batchInterfaceExport='true'">
					<link>
						<xsl:attribute name="from"><xsl:value-of select="format-number((count(preceding::table[@batchInterfaceExport='true'])+1)*10,'000')" ></xsl:value-of></xsl:attribute>
						<xsl:attribute name="to"><xsl:value-of select="format-number((count(preceding::table[@batchInterfaceExport='true'])+2)*10,'000')" ></xsl:value-of></xsl:attribute>
					</link> 
				</xsl:if>
			</xsl:for-each>
		</links>	
	</workflow>

</xsl:template>

<xsl:template match="column">
	 <column name="{@name}" type="{ancestor::logicalModel/domains/domain[@name=current()/@domain]/@type}"/>
</xsl:template>

</xsl:stylesheet>

