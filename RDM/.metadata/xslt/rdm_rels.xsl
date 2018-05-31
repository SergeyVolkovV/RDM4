<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="xml" encoding="UTF-8" indent="yes"/>

<xsl:template match="/">
	<rels>
		<xsl:for-each select="logicalModel/relationships/relationship">
		
			<rel name="fkg_{@name}" elemId="{@elemId}_rel" childTable="{@childTable}" parentTable="{@parentTable}" gfk="true">
				<columns>
					<column childColumn="generatedpk_{@name}" parentColumn="generatedpk" elemId="{@elemId}_gpk" />
   				 </columns>
			</rel>
		
			<rel name="fk_{@name}" elemId="{@elemId}_rel" childTable="{@childTable}" parentTable="{@parentTable}">
				<columns>
					<xsl:apply-templates>
	      				<xsl:with-param name="relName" select="./@name" />
	    			</xsl:apply-templates>
   				 </columns>
			</rel>
		</xsl:for-each>

	</rels>
</xsl:template>



<xsl:template match="relationships/relationship/representativeForeignKey/column">
	<xsl:param name="relName" />
	<column childColumn="{@childColumn}" parentColumn="{@parentColumn}" elemId="{@elemId}_rel" />
</xsl:template>

</xsl:stylesheet>
