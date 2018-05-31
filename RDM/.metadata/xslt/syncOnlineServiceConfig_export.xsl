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
    
    		<xsl:for-each select="syncOnlineTaskExports/syncOnlineTaskExport">
        	<serviceBean configFile="../plans/synchronization/onlines/exports/{ancestor::syncOnlineTaskE/@name}_{@outputFileName}_export.plan" maxPoolSize="5" name="{@outputFileName}" minPoolSize="1" parallelismLevel="0">
      			<additionalActions/>
      			<method location="/{ancestor::syncOnlineTaskE/@name}_export" soapAction="{ancestor::syncOnlineTaskE/@name}_export_{@outputFileName}" class="com.ataccama.dqc.online.cfg.SoapOverHttpMethod" soapVersion="SOAP11" >
       			<inputFormat  schemaValidation="false" namespace="http://www.example.com/ws">
          				<rootSection stepId="in" schemaTypeName="in">
            				<columns>
	      				        <xsl:choose>
					        		<xsl:when test="@useUrlResourcesForAuthentication='Use App Connection Credentials'">        			
					        		</xsl:when>
					        		<xsl:when test="@useUrlResourcesForAuthentication='Pass Credentials Manually'">
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
              					<xmlColumn name="timestamp" strategy="NILLABLE_ELEM" type="DATETIME"/>
              					<xsl:if test="syncOnlineTaskTables/syncOnlineTaskTable/@history='true'">
              						<xmlColumn name="timestamp_increment" strategy="NILLABLE_ELEM" type="DATETIME"/>
              					</xsl:if>
            				</columns>
            				<sections/>
          				</rootSection>
        			</inputFormat>
       				<outputFormat namespace="http://www.example.com/ws">
            			<rootSection>
              				<columns/>
              				<sections>
                				<xmlOutputSection name="getRecord" strategy="MULTIPLE_OPTIONAL" stepId="getRecords">
                  					<columns>
                    					<xsl:for-each select="syncOnlineTaskTables/syncOnlineTaskTable">    

						<xsl:variable name="tableName" select="@name"/>
						<xsl:choose>
							<xsl:when test="@allColumns='true'">
								<xsl:for-each select="$logicalModel/tables/table[@name=$tableName]/columns/column">
									<xsl:variable name="columnName" select="@name"/>
									<xsl:variable name="columnType" select="if($logicalModel/domains/domain[@name=$logicalModel/tables/table[@name=$tableName]/columns/column[@name=$columnName]/@domain]/@type='MNREFERENCES') then 'STRING' else $logicalModel/domains/domain[@name=$logicalModel/tables/table[@name=$tableName]/columns/column[@name=$columnName]/@domain]/@type"/>
									
									<xmlOutputColumn nullHandling="ERROR" name="{@name}" strategy="NILLABLE_ELEM" type="{$columnType}"/>
								</xsl:for-each>
							</xsl:when>
							<xsl:otherwise>
								<xsl:for-each select="syncOnlineTaskTableColumns/syncOnlineTaskTableColumn">
									<xsl:variable name="columnName" select="@name"/>
									<xsl:variable name="columnType" select="if($logicalModel/domains/domain[@name=$logicalModel/tables/table[@name=$tableName]/columns/column[@name=$columnName]/@domain]/@type='MNREFERENCES') then 'STRING' else $logicalModel/domains/domain[@name=$logicalModel/tables/table[@name=$tableName]/columns/column[@name=$columnName]/@domain]/@type"/>
									
										<xmlOutputColumn nullHandling="ERROR" name="{@name}" strategy="NILLABLE_ELEM" type="{$columnType}"/>
								</xsl:for-each>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:for-each>              						
                    					
                  						                 					
                    					<xsl:for-each select="syncOnlineTaskColumns/syncOnlineTaskColumn">                    						
                    						<xmlOutputColumn nullHandling="ERROR" name="{@name}" strategy="NILLABLE_ELEM" type="{@type}"/>
                  						</xsl:for-each>
                  						<xmlOutputColumn nullHandling="ERROR" name="change_type" strategy="NILLABLE_ELEM" type="STRING"/>
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
</xsl:stylesheet>