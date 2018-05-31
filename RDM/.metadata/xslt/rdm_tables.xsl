<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="xml" encoding="UTF-8" indent="yes"/>

<xsl:template match="/">
	<tables>
		<xsl:for-each select="logicalModel/tables/table">
			<physicalTable entity="{@name}" name="{@name}" elemId="{@elemId}_data" role="data" gpk="true">
				<columns>
					<column name="generatedpk" type="integer" role="internal" dbType="NUMBER"/>
					<xsl:apply-templates select="columns/column"/>
					<xsl:apply-templates mode="generatedFkColumns" select="ancestor::logicalModel/relationships/relationship[@childTable=current()/@name]" />
				</columns>
			</physicalTable>


			<physicalTable entity="{@name}" name="{@name}e" elemId="{@elemId}_edit" role="internal" edit="true">
				<columns>
					<column name="generatedpk" type="integer" role="internal" dbType="NUMBER"/>
					<xsl:apply-templates select="columns/column"/>
					<xsl:apply-templates mode="generatedFkColumns" select="ancestor::logicalModel/relationships/relationship[@childTable=current()/@name]" />
					<column name="username" type="string" role="internal" dbType="VARCHAR(255)"/>
					<column name="deleted" type="integer" role="internal" dbType="NUMBER"/>
					<column name="AC#STATE" type="string" role="internal" dbType="VARCHAR(100)"/>
					<column name="AC#STATEMENTS" type="string" role="internal" dbType="VARCHAR(4000)"/>
				</columns>
			</physicalTable>

			<physicalTable entity="{@name}" name="{@name}h" elemId="{@elemId}_history" role="internal" gpk="true">
				<columns>
					<column name="generatedpk" type="integer" role="internal" dbType="NUMBER"/>
					<xsl:apply-templates select="columns/column"/>
					<xsl:apply-templates mode="generatedFkColumns" select="ancestor::logicalModel/relationships/relationship[@childTable=current()/@name]" />
					<column name="d_from" type="date" role="internal" dbType="DATE"/>
					<column name="d_to" type="date" role="internal" dbType="DATE"/>
					<column name="username" type="string" role="internal" dbType="VARCHAR(255)"/>
					<column name="AC#STATEMENTS" type="string" role="internal" dbType="VARCHAR(4000)"/>
				</columns>
			</physicalTable>
			
			<physicalTable entity="{@name}" name="{@name}v" elemId="{@elemId}_validation" role="internal" edit="true">
				<columns>
					<column name="generatedpk" type="integer" role="internal" dbType="NUMBER"/>
					<column name="AC#VALIDATION_RESULT" type="string" role="internal" dbType="VARCHAR(4000)"/>
					<column name="AC#VALIDATION_UK_RESULT" type="string" role="internal" dbType="VARCHAR(4000)"/>
					<column name="AC_VALIDATION_NAME_RESULT" type="string" role="internal" dbType="VARCHAR(4000)"/>
				</columns>
			</physicalTable>
		</xsl:for-each>

	</tables>
</xsl:template>

<xsl:template match="column">
	 <column name="{@name}" type="{ancestor::logicalModel/domains/domain[@name=current()/@domain]/@type}"/>
</xsl:template>

<xsl:template match="relationships/relationship" mode="generatedFkColumns">
	 <column name="generatedpk_{@name}" type="integer" dbType="NUMBER" role="internal"/>
</xsl:template>
</xsl:stylesheet>

