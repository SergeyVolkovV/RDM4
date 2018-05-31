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

    <xsl:template match="step[@id='parameters']">
		<step className="com.ataccama.dqc.tasks.common.usersteps.io.InputStep" id="in_parameters">
			<xsl:copy-of select="properties"/>
			<xsl:copy-of select="visual-constraints"/>
		</step>
    </xsl:template>

    <xsl:template match="connection[source/@step='parameters']">
		<connection className="com.ataccama.dqc.model.elements.connections.StandardFlowConnection" disabled="false">
	        <source step="in_parameters" endpoint="out"/>
	        <xsl:copy-of select="target"/>
	        <xsl:copy-of select="visual-constraints"/>
	    </connection>
    </xsl:template>
         	
</xsl:stylesheet>