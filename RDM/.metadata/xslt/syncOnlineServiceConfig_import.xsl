<?xml version='1.0' encoding='UTF-8'?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:sf="http://www.ataccama.com/xslt/functions"
 xmlns:exsl="http://exslt.org/common" extension-element-prefixes="exsl sf">
  <xsl:output method="xml" encoding="UTF-8" indent="yes"/>

<xsl:param name="logicalModel" select="document('param:logicalModel')/*"/>
<xsl:param name="appVariables" select="document('param:appVariables')/*"/>
<xsl:include href="constants_incl.xsl"/>

<xsl:template match="/*">

<xsl:variable name="collectionName" select="@name"/>
	<ServiceConfig version="{$rdm_version}">
  		<services>
    		<xsl:variable name="useUrlResourcesForAuthentication" select="@useUrlResourcesForAuthentication"/>
    		<xsl:for-each select="syncOnlineTaskImports/syncOnlineTaskImport">
    		<xsl:variable name="tableName" select="@tableName"/>
        	<serviceBean configFile="../plans/synchronization/onlines/imports/{ancestor::syncOnlineTaskI/@name}_{@tableName}_import.plan" maxPoolSize="5" name="{@tableName}" minPoolSize="1" parallelismLevel="0">
      			<additionalActions/>
      			<method location="/{ancestor::syncOnlineTaskI/@name}_import" soapAction="{ancestor::syncOnlineTaskI/@name}_import_{@tableName}" class="com.ataccama.dqc.online.cfg.SoapOverHttpMethod" soapVersion="SOAP11" >
       			<inputFormat  schemaValidation="false" namespace="http://www.example.com/ws">
       			<rootSection>
            	<columns/>
            	<sections>
       				<xmlInputSection stepId="in" name="in" strategy="MULTIPLE_REQUIRED">
         				<columns>         				
							<xsl:for-each select="$logicalModel/tables/table">
				        		<xsl:variable name="logicalTableName" select="@name"/>
				        		<xsl:if test="$tableName = $logicalTableName">
				                	<xsl:apply-templates select="columns/column"/>
				            	</xsl:if>
				            </xsl:for-each>
         				</columns>
         				<sections/>
       				</xmlInputSection>
       				<xsl:if test="$useUrlResourcesForAuthentication!='Use App Connection Credentials'">
       					<xsl:if test="$appVariables/@useUrlResourcesForAuthentication='Pass Credentials Manually' or $useUrlResourcesForAuthentication='Pass Credentials Manually'">
		       				<xmlInputSection stepId="in_parameters" name="in_parameters" strategy="MULTIPLE_REQUIRED">
		         				<columns>         				
		      				        <xsl:choose>
						        		<xsl:when test="$useUrlResourcesForAuthentication='Use App Connection Credentials'">        			
						        		</xsl:when>
						        		<xsl:when test="$useUrlResourcesForAuthentication='Pass Credentials Manually'">
				           					<xmlColumn name="username" strategy="NILLABLE_ELEM" type="STRING"/>
				           					<xmlColumn name="password" strategy="NILLABLE_ELEM" type="STRING"/>
						        		</xsl:when>        		
						        		<xsl:otherwise>
						        			<xsl:choose>
						        				<xsl:when test="$appVariables/@useUrlResourcesForAuthentication='Use App Connection Credentials'">        					
						        				</xsl:when>
						        				<xsl:otherwise>
						           					<xmlColumn name="username" strategy="NILLABLE_ELEM" type="STRING"/>
					           						<xmlColumn name="password" strategy="NILLABLE_ELEM" type="STRING"/>
						        				</xsl:otherwise>
						        			</xsl:choose>
						        		</xsl:otherwise>
						        	</xsl:choose>
		         				</columns>
		         				<sections/>
		       				</xmlInputSection>
		       			</xsl:if>
	       			</xsl:if>
			        </sections>
			        </rootSection>       				
        			</inputFormat>
       				<outputFormat namespace="http://www.example.com/ws">
            			<rootSection>
              				<columns/>
              				<sections>
                				<xmlOutputSection name="Error" strategy="MULTIPLE_OPTIONAL" stepId="Errors">
                  					<columns>
                  						<xmlOutputColumn nullHandling="ERROR" name="lineNo" strategy="NILLABLE_ELEM" type="INTEGER"/>
                  						<xmlOutputColumn nullHandling="ERROR" name="error" strategy="NILLABLE_ELEM" type="STRING"/>
                  					</columns>
                  					<sections/>
                				</xmlOutputSection>
              				</sections>
            			</rootSection>
          			</outputFormat>   			
      
 
     			</method>
    		</serviceBean>
    		</xsl:for-each>
  		</services>
</ServiceConfig>

</xsl:template>

<xsl:template match="column">
	<xsl:variable name="tmpType">
        <xsl:if test="$logicalModel/domains/domain[@name=current()/@domain]/@type='MNREFERENCES'">STRING</xsl:if>
        <xsl:if test="$logicalModel/domains/domain[@name=current()/@domain]/@type!='MNREFERENCES'"><xsl:value-of select="$logicalModel/domains/domain[@name=current()/@domain]/@type"/></xsl:if>
    </xsl:variable>
	<xmlColumn name="{@name}" type="{upper-case($tmpType)}" />
</xsl:template>
</xsl:stylesheet>