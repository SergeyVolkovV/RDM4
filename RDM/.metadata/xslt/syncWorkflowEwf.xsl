<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="xml" encoding="UTF-8" indent="yes"/>

<xsl:param name="rdmAppVariablesRef" select="document('param:rdmAppVariablesRef')"/>

<xsl:include href="constants_incl.xsl"/>

<xsl:template match="*">
	<workflow xmlns:vis="http://www.ataccama.com/purity/visual" version="{$rdm_version}">
	<continueOnFailure>false</continueOnFailure>
	<groups/>
	<multiplicity>0</multiplicity>
	<name><xsl:value-of select="@name"/><xsl:text> synchronization workflow</xsl:text></name>
	<variables/>
	<tasks>
		<task>
			<id>010</id>
			<name><xsl:value-of select="@name"/> step 1</name>
			<acceptMode>AT_LEAST_ONE</acceptMode>
			<executable class="com.ataccama.adt.task.exec.EwfDqcTask">
				<planFile>../plans/synchronization/databases/<xsl:value-of select="@name"/>_input.plan</planFile>
			</executable>
		</task>
		<task>
			<id>020</id>
			<name><xsl:value-of select="@name"/> step 2</name>
			<acceptMode>AT_LEAST_ONE</acceptMode>
			<executable class="com.ataccama.adt.task.exec.EwfDqcTask">
				<planFile>../plans/synchronization/databases/<xsl:value-of select="@name"/>_synchronization.plan</planFile>
			</executable>
		</task>
		
		<xsl:if test="@useInputs = 'true'">
		<task>
			<id>030</id>
			<name><xsl:value-of select="@name"/> step 3</name>
			<acceptMode>AT_LEAST_ONE</acceptMode>
			<executable class="com.ataccama.adt.task.exec.EwfDqcTask">
				<planFile>../plans/synchronization/databases/<xsl:value-of select="@name"/>_system_input.plan</planFile>
			</executable>
		</task>
		</xsl:if>
		
		<task>
			<id>040</id>
			<name><xsl:value-of select="@name"/> step 4</name>
			<acceptMode>AT_LEAST_ONE</acceptMode>
			<executable class="com.ataccama.adt.task.exec.EwfDqcTask">
				<planFile>../plans/synchronization/databases/<xsl:value-of select="@name"/>_output.plan</planFile>
			</executable>
		</task>
		
	</tasks>
	<links>
				<link to="020" from="010"/>
		<xsl:choose>
			<xsl:when test="@useInputs = 'true'">
				<link to="030" from="020"/>
				<link to="040" from="030"/>
			</xsl:when>
			<xsl:otherwise>
				<link to="040" from="020"/>
			</xsl:otherwise>
		</xsl:choose>
	</links>
</workflow>
</xsl:template>


</xsl:stylesheet>