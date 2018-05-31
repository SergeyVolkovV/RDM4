<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:mrg="http://www.ataccama.com/dqc/plan-merge">
 <xsl:output method="xml" encoding="UTF-8" indent="yes"/>

<xsl:param name="rdmTableRef" select="document('param:rdmTableRef')"/>
<xsl:param name="rdmAppVariablesRef" select="document('param:rdmAppVariablesRef')/*"/>
<xsl:param name="rdmSystemRef" select="document('param:rdmSystemRef')"/>

<xsl:include href="constants_incl.xsl"/>

<xsl:template match="/*">
	<purity-config version="{$rdm_version}">

<!-- (Rdm Integration Output) -->
    <step id="Rdm Integration Output" className="com.ataccama.rdm.manager.steps.RdmFinishProcessStep" disabled="false" mode="NORMAL">
        <properties error="error" processId="id" url="{$rdmAppVariablesRef/@connectionName}">
        	<xsl:choose>
        		<xsl:when test="@useUrlResourcesForAuthentication='Use App Connection Credentials'">        			
        		</xsl:when>
        		<xsl:when test="@useUrlResourcesForAuthentication='Pass Credentials Manually'">
        			<credentials password="password" username="username"/>
        		</xsl:when>        		
        		<xsl:otherwise>
        			<xsl:choose>
        				<xsl:when test="$rdmAppVariablesRef/@useUrlResourcesForAuthentication='Use App Connection Credentials'">        					
        				</xsl:when>
        				<xsl:otherwise>
        					<credentials password="password" username="username"/>
        				</xsl:otherwise>
        			</xsl:choose>
        		</xsl:otherwise>
        	</xsl:choose>
        </properties>
        <visual-constraints bounds="96,120,-1,-1" layout="vertical"/>
    </step>



<!-- (getParametresDomains) -->
    <step id="{@name} Output Parameters" className="com.ataccama.dqc.tasks.io.text.read.TextFileReader" disabled="false" mode="NORMAL">
        <properties stringQualifier="&quot;" lineSeparator="\r\n" fieldSeparator=";" lineMaxReadLength="65536" numberOfLinesInHeader="1" fileName="{@name}_parameters.txt" encoding="UTF-8" numberOfLinesInFooter="0" stringQualifierEscape="&quot;">
            <columns>
                <textReaderColumn name="id" type="LONG" ignore="false">
                    <dataFormatParameters thousandsSeparator="" decimalSeparator="."/>
                </textReaderColumn>
                <textReaderColumn name="type" type="STRING" ignore="false"/>
                <xsl:choose>
	        		<xsl:when test="@useUrlResourcesForAuthentication='Use App Connection Credentials'">        			
		                <textReaderColumn name="username" type="STRING" ignore="true"/>
		                <textReaderColumn name="password" type="STRING" ignore="true"/>
	        		</xsl:when>
	        		<xsl:when test="@useUrlResourcesForAuthentication='Pass Credentials Manually'">
		                <textReaderColumn name="username" type="STRING" ignore="false"/>
		                <textReaderColumn name="password" type="STRING" ignore="false"/>
	        		</xsl:when>        		
	        		<xsl:otherwise>
	        			<xsl:choose>
	        				<xsl:when test="$rdmAppVariablesRef/@useUrlResourcesForAuthentication='Use App Connection Credentials'">        					
				                <textReaderColumn name="username" type="STRING" ignore="true"/>
				                <textReaderColumn name="password" type="STRING" ignore="true"/>	        				
	        				</xsl:when>
	        				<xsl:otherwise>
				                <textReaderColumn name="username" type="STRING" ignore="false"/>
				                <textReaderColumn name="password" type="STRING" ignore="false"/>
	        				</xsl:otherwise>
	        			</xsl:choose>
	        		</xsl:otherwise>
	        	</xsl:choose>                             
                <textReaderColumn name="timestamp" type="DATETIME" ignore="false">
                    <dataFormatParameters thousandsSeparator="" dateFormatLocale="en_US" dateTimeFormat="yyyy-MM-dd HH:mm:ss"/>
                </textReaderColumn>
            </columns>
            <dataFormatParameters trueValue="true" falseValue="false" thousandsSeparator="" dateFormatLocale="en_US" dateTimeFormat="yy-MM-dd HH:mm:ss" decimalSeparator="." dayFormat="yy-MM-dd"/>
            <errorHandlingStrategy rejectFileName="rejected.txt">
                <errorInstructions>
                    <errorInstruction putToLog="true" errorType="EXTRA_DATA" dataStrategy="READ_POSSIBLE" putToReject="false"/>
                    <errorInstruction putToLog="true" errorType="LONG_LINE" dataStrategy="STOP" putToReject="true"/>
                    <errorInstruction putToLog="true" errorType="PROCESSING_ERROR" dataStrategy="STOP" putToReject="false"/>
                    <errorInstruction putToLog="true" errorType="INVALID_DATE" dataStrategy="READ_POSSIBLE" putToReject="false"/>
                    <errorInstruction putToLog="true" errorType="SHORT_LINE" dataStrategy="READ_POSSIBLE" putToReject="true"/>
                    <errorInstruction putToLog="true" errorType="UNPARSABLE_FIELD" dataStrategy="NULL_VALUE" putToReject="false"/>
                </errorInstructions>
            </errorHandlingStrategy>
            <shadowColumns>
                <shadowColumnDef name="error" type="STRING"/>
            </shadowColumns>
        </properties>
        <visual-constraints bounds="96,24,32,32" layout="vertical"/>
    </step>
    <connection className="com.ataccama.dqc.model.elements.connections.StandardFlowConnection" disabled="false">
        <source step="{@name} Output Parameters" endpoint="out"/>
        <target step="Rdm Integration Output" endpoint="parameters"/>
        <visual-constraints>
            <bendpoints/>
        </visual-constraints>
    </connection>

	</purity-config>
</xsl:template>


</xsl:stylesheet>