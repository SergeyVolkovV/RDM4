<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:sf="http://www.ataccama.com/xslt/functions"
 xmlns:mrg="http://www.ataccama.com/dqc/plan-merge"	 
 xmlns:exsl="http://exslt.org/common" extension-element-prefixes="exsl sf">
<xsl:output method="xml" encoding="UTF-8" indent="yes"/>

<xsl:param name="logicalModel" select="document('param:logicalModel')/*"/>
<xsl:param name="domains" select="document('param:domains')/*"/>

<xsl:include href="constants_incl.xsl"/>

<xsl:template match="/*">
	<ServiceConfig version="{$rdm_version}">
		<services>
		    <serviceBean configFile="../plans/synchronization/onPublish/onPublishHandler.plan" maxPoolSize="5" name="{@name}" minPoolSize="1" parallelismLevel="0">
		      <additionalActions/>
		      <method location="/{@name}" soapAction="{@soapAction}" class="com.ataccama.dqc.online.cfg.SoapOverHttpMethod" soapVersion="{if(@soapVersion='SOAP_1_1') then 'SOAP11' else SOAP12}">
		        <inputFormat schemaValidation="false" namespace="{@soapEnvNamespace}">
		          <rootSection>
		            <columns/>
		            <sections>
		            	<xsl:for-each select="tables/table">
		            		<xsl:variable name="tableName" select="@name"/>		            		
							<xmlInputSection name="{@name}" strategy="MULTIPLE_OPTIONAL" stepId="in_{@name}">
							  <columns>
							    <xmlColumn name="gpk" strategy="NILLABLE_ELEM" type="LONG"/>
							    <xmlColumn name="edit_state" strategy="OPTIONAL_ELEM" type="STRING"/>
							    <!-- <xmlColumn name="d_from" strategy="NILLABLE_ELEM" type="DATETIME"/> -->
								<xsl:if test="@exportAllOldColumns='true'">
									<xsl:for-each select="$logicalModel/tables/table[@name=$tableName]/columns/column">
										<xsl:variable name="columnDomain" select="@domain"/>
										<xmlColumn name="old_{@name}" strategy="NILLABLE_ELEM" type="{$domains/domain[@name=$columnDomain]/dqcType/@dqcType}"/>									
									</xsl:for-each>
								</xsl:if>
								<xsl:if test="@exportAllNewColumns='true'">
									<xsl:for-each select="$logicalModel/tables/table[@name=$tableName]/columns/column">
										<xsl:variable name="columnDomain" select="@domain"/>
										<xmlColumn name="new_{@name}" strategy="NILLABLE_ELEM" type="{$domains/domain[@name=$columnDomain]/dqcType/@dqcType}"/>
									</xsl:for-each>
								</xsl:if>									
								<xsl:variable name="exportValues" select="exportValues"/>
								<xsl:for-each select="$logicalModel/tables/table[@name=$tableName]/columns/column[@name=$exportValues/exportValue/@name]">
									<xsl:variable name="columnDomain" select="@domain"/>
									<xsl:variable name="columnName" select="@name"/>
									<xsl:if test="$exportValues/exportValue[@name=$columnName]/@oldValue='true'">
										<xmlColumn name="old_{@name}" strategy="NILLABLE_ELEM" type="{$domains/domain[@name=$columnDomain]/dqcType/@dqcType}"/>
									</xsl:if>
									<xsl:if test="$exportValues/exportValue[@name=$columnName]/@newValue='true'">
										<xmlColumn name="new_{@name}" strategy="NILLABLE_ELEM" type="{$domains/domain[@name=$columnDomain]/dqcType/@dqcType}"/>
									</xsl:if>
								</xsl:for-each>
							  </columns>						    
							  <references/>
							  <sections/>
							</xmlInputSection>
						</xsl:for-each>
		            </sections>
		          </rootSection>
		        </inputFormat>
				<outputFormat namespace="{@soapEnvNamespace}">
					<rootSection>
						<columns/>
						<sections/>
					</rootSection>
				</outputFormat>
		      </method>
		    </serviceBean>
		  </services>
	</ServiceConfig>
</xsl:template>

</xsl:stylesheet>