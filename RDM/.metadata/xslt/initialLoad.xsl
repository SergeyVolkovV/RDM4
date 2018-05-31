<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:sf="http://www.ataccama.com/xslt/functions"
 xmlns:exsl="http://exslt.org/common" extension-element-prefixes="exsl sf">
 <xsl:output method="xml" encoding="UTF-8" indent="yes"/>

<xsl:template match="/*">

	<workflow continueOnFailure="false" name="initial load" version="1">
		<variables/>
		<tasks>
			<xsl:for-each select="/metadata/batchInterfaces/plans">
			<task>
				<id><xsl:value-of select="format-number((count(preceding::plans)+1)*10,'000')"/></id>
				<name><xsl:value-of select="@name"/></name>
				<acceptMode><xsl:text>AT_LEAST_ONE</xsl:text></acceptMode>
				<executable class="com.ataccama.adt.task.exec.EwfDqcTask">
					<planFile><xsl:text>../plans/batchLoadPlans/</xsl:text><xsl:value-of select="@name"/><xsl:text>.plan</xsl:text></planFile>
				</executable>
			</task>
			</xsl:for-each>
		</tasks>
		<links>
			<xsl:for-each select="/metadata/batchInterfaces/plans">
				<xsl:if test="position()!=last()">
					<link>
						<xsl:attribute name="from"><xsl:value-of select="format-number((count(preceding::plans)+1)*10,'000')" ></xsl:value-of></xsl:attribute>
						<xsl:attribute name="to"><xsl:value-of select="format-number((count(preceding::plans)+2)*10,'000')" ></xsl:value-of></xsl:attribute>
					</link> 
				</xsl:if>
			</xsl:for-each>
		</links>
	</workflow>

</xsl:template>
</xsl:stylesheet>

