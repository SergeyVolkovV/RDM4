<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:sf="http://www.ataccama.com/xslt/functions"
	xmlns:fn="http://www.w3.org/2005/xpath-functions"
	exclude-result-prefixes="sf fn">
<xsl:output method="xml" encoding="UTF-8" indent="yes"/>	

<xsl:param name="fileName"/>  
  
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="workflow">
		<workflow xmlns:vis="http://www.ataccama.com/purity/visual" xmlns:mrg="http://www.ataccama.com/dqc/plan-merge" version="10.6.2">
			<continueOnFailure><xsl:value-of select="continueOnFailure|@continueOnFailure"/></continueOnFailure>
			<xsl:choose>
				<xsl:when test="multiplicity">
					<multiplicity><xsl:value-of select="multiplicity"/></multiplicity>
				</xsl:when>
				<xsl:when test="@multiplicity!=''">
					<multiplicity><xsl:value-of select="@multiplicity"/></multiplicity>
				</xsl:when>
				<xsl:otherwise>
					<multiplicity><xsl:value-of select="'0'"/></multiplicity>
				</xsl:otherwise>				 
			</xsl:choose>
			<name><xsl:value-of select="name|@name"/></name>
			<xsl:copy-of select="groups"/>
			<xsl:copy-of select="variables"/>
			<xsl:copy-of select="tasks"/>
			<xsl:copy-of select="links"/>
		</workflow>
    </xsl:template>
         	
</xsl:stylesheet>