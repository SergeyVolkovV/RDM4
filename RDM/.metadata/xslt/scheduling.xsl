<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:sf="http://www.ataccama.com/xslt/functions"
 xmlns:exsl="http://exslt.org/common" extension-element-prefixes="exsl sf">
  <xsl:output method="xml" encoding="UTF-8" indent="yes"/>

<xsl:template match="/*">


	<scheduleDefinition>
   		<description><xsl:value-of select="@name"/></description>
   		<enabled><xsl:value-of select="@enable"/></enabled>
   		<job class="com.ataccama.adt.scheduler.job.WorkflowJob">
			<workflow>RDM:<xsl:value-of select="@job"/></workflow> 
        		<!--
        		<variables>
	   				<variable name="command1" value="notepad"/>
	   				<variable name="command2" value="notepad"/>
        		</variables>
        		-->
   		</job>
   		<scheduling>
   			<xsl:value-of select="scheduling/@minute"/><xsl:text> </xsl:text>
   			<xsl:value-of select="scheduling/@hour"/><xsl:text> </xsl:text>
   			<xsl:value-of select="scheduling/@dayWeek"/><xsl:text> </xsl:text>
   			<xsl:value-of select="scheduling/@dayMonth"/>
   		</scheduling>
	</scheduleDefinition>

</xsl:template>
</xsl:stylesheet>
