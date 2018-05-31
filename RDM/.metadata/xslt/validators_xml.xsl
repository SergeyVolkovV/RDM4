<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
 <xsl:output method="xml" encoding="UTF-8" indent="yes"/>
<xsl:param name="syncOnPublishEvent" select="document('param:syncOnPublishEvent')/*"/>
<xsl:param name="servers" select="document('param:servers')/*"/>

<xsl:template match="/*">
<validators>

	<xsl:if test="$syncOnPublishEvent/@enable='true' and $syncOnPublishEvent/@soapEnvNamespace!='' and $syncOnPublishEvent/@name!='' and $syncOnPublishEvent/@soapAction!='' and $syncOnPublishEvent/@url!=''">
	    <confirmFinalValidations>
	    	<xsl:variable name="tmpUrl" select="$servers/genericServer[@name=$syncOnPublishEvent/@url]/@url"/>
		    <validator 
		       class="com.ataccama.rdm.manager.config.validations.RdmSoapCallConfirmFinalValidationConfig"
		         url="{replace($tmpUrl, '/$', '')}/{$syncOnPublishEvent/@name}"
		         soapAction="{$syncOnPublishEvent/@soapAction}" 
		         soapEnvNamespace="{$syncOnPublishEvent/@soapEnvNamespace}"
		         name="{$syncOnPublishEvent/@name}" 
		         soapVersion="{$syncOnPublishEvent/@soapVersion}"  
		         inputXsltTransformationFile="onPublishOutTransformation.xsl"		                   
		         >
		         <xsl:if test="$servers/genericServer[@name=$syncOnPublishEvent/@url]/@user!=''">
		         	<xsl:attribute name="username"><xsl:value-of select="$servers/genericServer[@name=$syncOnPublishEvent/@url]/@user"/></xsl:attribute>
		         </xsl:if>
		         <xsl:if test="$servers/genericServer[@name=$syncOnPublishEvent/@url]/@password!=''">
		         	<xsl:attribute name="password"><xsl:value-of select="$servers/genericServer[@name=$syncOnPublishEvent/@url]/@password"/></xsl:attribute>
		         </xsl:if>     
		         </validator>
	    </confirmFinalValidations> 
	</xsl:if>

	<entities>
		<xsl:for-each select="logicalModel/tables/table">
		<xsl:variable name="tmpTableName" select="@name"/>	
			<xsl:if test="(validations/expressionValidations/expressionValidation/expression !='' and validations/expressionValidations/expressionValidation/@enable='true') or (validations/sqlValidations/sqlValidation/sqlexpression != '' and validations/sqlValidations/sqlValidation/@enable='true') or (validations/onlineValidations/onlineValidation/@name !='' and validations/onlineValidations/onlineValidation/@enable='true') or (validations/onlineEnrichers/onlineEnricher/@name !='')">
			<entity name="{$tmpTableName}">
				<validators>
					<!-- expression validation -->
					<xsl:if test="(validations/expressionValidations/expressionValidation/expression !='' and validations/expressionValidations/expressionValidation/@enable='true')">
						<validator class="com.ataccama.rdm.manager.validations.RdmDqcExpressionsValidator">
							<validations>
								<xsl:for-each select="validations/expressionValidations/expressionValidation">
								<validation>
										<xsl:if test="@column != ''">
											<xsl:attribute name="columnName"><xsl:value-of select="@column"/></xsl:attribute>
										</xsl:if>									
										<xsl:if test="expression !=''">
											<dqcExpression>
												<xsl:value-of select="expression"/>
											</dqcExpression>
										</xsl:if>
									<message><xsl:value-of select="@message"/></message>
								</validation>
								</xsl:for-each>
							</validations>
						</validator>
					</xsl:if>
					<!-- online validation -->
					<xsl:if test="(validations/onlineValidations/onlineValidation/@name !='' and validations/onlineValidations/onlineValidation/@enable='true')">
						<xsl:for-each select="validations/onlineValidations/onlineValidation">
						<xsl:if test="(@soapVersion = '1.1')">
						<validator class="com.ataccama.rdm.manager.validations.RdmDqcOnlineValidator" url="{@url}" 
							soapAction="{@soapAction}" soapEnvNamespace="{@soapEnvNamespace}" name="{@name}" soapVersion="SOAP_1_1"/>
						</xsl:if>
						<xsl:if test="(@soapVersion = '1.2')">
						<validator class="com.ataccama.rdm.manager.validations.RdmDqcOnlineValidator" url="{@url}" 
							soapAction="{@soapAction}" soapEnvNamespace="{@soapEnvNamespace}" name="{@name}" soapVersion="SOAP_1_2"/>
						</xsl:if>
						</xsl:for-each>
					</xsl:if>
					
				</validators>
				
				<!-- sql validation -->
				<xsl:if test="validations/sqlValidations/sqlValidation/sqlexpression !='' and validations/sqlValidations/sqlValidation/@enable='true'"> <!-- existuje alespon jeden sql validator ? -->
					<tableValidators>
						<xsl:for-each select="validations/sqlValidations/sqlValidation">
							<xsl:variable name="tmpValidationNode" select="."/>					
							<xsl:variable name="tmpSqlValidationExpression" select="$tmpValidationNode/@sqlexpression|$tmpValidationNode/sqlexpression"/>
							<xsl:variable name="tmpCount" select="position()"/>
							<xsl:variable name ="tmpSeq" select="format-number($tmpCount,'0000')"/>
							<tv class="com.ataccama.rdm.manager.validations.RdmSqlSelectValidator">
								<tablesInSql>
									<tn><xsl:value-of select="$tmpTableName"/></tn><!-- aktualni ciselnik, ten musi byt do sql validace zahrnut vzdy -->
										<xsl:for-each select="$tmpValidationNode/InvolvedTables/InvolvedTable">
											<tn><xsl:value-of select="@tablename"/></tn>
										</xsl:for-each>
								</tablesInSql>
								<name>sqlValidation_<xsl:value-of select="$tmpTableName"/>_<xsl:value-of select="$tmpSeq"/></name> <!-- musi byt unikatni napric modelem -->
								<changes>
									<change>
										<name><xsl:value-of select="$tmpTableName"/></name>
										<type>ALL</type>
									</change>
									<xsl:for-each select="$tmpValidationNode/InvolvedTables/InvolvedTable">
										<change>
											<name><xsl:value-of select="@tablename"/></name>
											<type>ALL</type>
										</change>
									</xsl:for-each>
								</changes>
								<sqlTemplate>
									select s.generatedPk, '<xsl:value-of select="$tmpValidationNode/@message"/>' as message, s.name from(<xsl:value-of select="$tmpSqlValidationExpression"/>) s
								</sqlTemplate>
							</tv>
						</xsl:for-each>
					</tableValidators>		
				</xsl:if>				
				
				<enrichers>
					<xsl:if test="(validations/onlineEnrichers/onlineEnricher/@name !='')">
					<xsl:for-each select="validations/onlineEnrichers/onlineEnricher">
					<xsl:if test="(@soapVersion = '1.1')">
					<validator class="com.ataccama.rdm.manager.validations.RdmDqcOnlineRecordEnricher" url="{@url}" 
						soapAction="{@soapAction}" soapEnvNamespace="{@soapEnvNamespace}" name="{@name}" soapVersion="SOAP_1_1"/>
					</xsl:if>
					<xsl:if test="(@soapVersion = '1.2')">
					<validator class="com.ataccama.rdm.manager.validations.RdmDqcOnlineRecordEnricher" url="{@url}" 
						soapAction="{@soapAction}" soapEnvNamespace="{@soapEnvNamespace}" name="{@name}" soapVersion="SOAP_1_2"/>
					</xsl:if>
					</xsl:for-each>
					</xsl:if>
				</enrichers>
						
			</entity>
			</xsl:if>
		</xsl:for-each>
	</entities>
</validators>


</xsl:template>
</xsl:stylesheet>
