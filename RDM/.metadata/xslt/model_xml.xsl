<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
 <xsl:output method="xml" encoding="UTF-8" indent="yes" cdata-section-elements="description sqlSource"/>
 
<xsl:template match="*">
	<model>
		<entities>
			<xsl:for-each select="logicalModel/tables/table">
				<entity name="{@name}" showInAllTables="{@showInAllTables}">
					<xsl:if test="@label = ''"><xsl:attribute name="label"><xsl:value-of select="@name"/></xsl:attribute></xsl:if>
					<xsl:if test="@label != ''"><xsl:attribute name="label"><xsl:value-of select="@label"/></xsl:attribute></xsl:if>
					<xsl:choose>
						<xsl:when test="@description !=''">
							<xsl:attribute name="description" >
								<xsl:value-of select="@description"/>
							</xsl:attribute>
						</xsl:when>
						<xsl:otherwise>
							<xsl:attribute name="description" >
								<xsl:value-of select="description"/>
							</xsl:attribute>
						</xsl:otherwise>
					</xsl:choose>
					<businessOwners>
						<roles>
		    				<xsl:for-each select="businessOwnerRoles/businessOwnerRole">
		    					<role><xsl:value-of select="@role"/></role>
		    				</xsl:for-each>
						</roles>
					</businessOwners>
					<additionalOwners>
						<roles>
		    				<xsl:for-each select="businessOwnerRolesAA/businessOwnerAA">
		    					<role><xsl:value-of select="@role"/></role>
		    				</xsl:for-each>
						</roles>
					</additionalOwners>
					<columns>
               			<xsl:for-each select="./columns/column">
               				<column name="{@name}" domain="{@domain}" displayMode="{@displayMode}" required="{@required}" generated="{@generated}">
               				<xsl:if test="@label = ''">
               					<xsl:attribute name="label"><xsl:value-of select="@name"/></xsl:attribute>
               				</xsl:if>
							<xsl:if test="@label != ''">
								<xsl:attribute name="label"><xsl:value-of select="@label"/></xsl:attribute>
							</xsl:if>
               				<xsl:if test="defaultValue!=''">
                 				<xsl:attribute name="defaultValue" ><xsl:value-of select="defaultValue"/></xsl:attribute>
                			</xsl:if>
                			
                			<xsl:choose>
								<xsl:when test="@description !=''">
									<xsl:attribute name="description" >
										<xsl:value-of select="@description"/>
									</xsl:attribute>
								</xsl:when>
								<xsl:otherwise>
									<xsl:attribute name="description" >
										<xsl:value-of select="description"/>
									</xsl:attribute>
								</xsl:otherwise>
							</xsl:choose>

                			<xsl:if test="../../idGenerators/generator/@name = @name">
               					<generator class="com.ataccama.rdm.manager.config.generators.RdmMaxDbNumberGeneratorConfig" increment="1"/>
               				</xsl:if>
               				<xsl:if test="@valuePresenter|valuePresenter !=''">
               					<xsl:attribute name="valuePresenter"><xsl:value-of select="@valuePresenter"/></xsl:attribute>
               				</xsl:if>
                			</column>
               			</xsl:for-each>
               			<xsl:for-each select="./systemColumns/systemColumn">
               				<column name="{@name}" domain="{@domain}" displayMode="{@displayMode}" label="{@label}" system="{@system}" required="{@required}" generated="{@generated}">
               				<xsl:if test="defaultValue!=''">
                 				<xsl:attribute name="defaultValue" ><xsl:value-of select="defaultValue"/></xsl:attribute>
                			</xsl:if>
                			</column>
                		</xsl:for-each>
					</columns>
					
					<xsl:if test="./businessDateColumns/@bdFromColumn != '' and ./businessDateColumns/@bdToColumn != ''">
					<businessDatesColumns fromInfinity="{../../../appVariables/@fromInfinity}" toInfinity="{../../../appVariables/@toInfinity}">
						<fromColumn><xsl:value-of select="./businessDateColumns/@bdFromColumn"/></fromColumn>
						<toColumn><xsl:value-of select="./businessDateColumns/@bdToColumn"/></toColumn>
					</businessDatesColumns>
					</xsl:if>
					
					<systems>
						<xsl:for-each select="./systems/system">
               				<system name="{@name}"></system>
               			</xsl:for-each>
					</systems>
				</entity>
			</xsl:for-each>
		</entities>
		<valuePresenters>
			<xsl:for-each select="logicalModel/valuePresenters/valuePresenter">		
				<presenter name="{@name}" class="com.ataccama.rdm.config.valuePresenter.RdmHTMLPresenterConfig" template="{template}"/>
			</xsl:for-each>			
		</valuePresenters>
		<uniqueKeys>
			<xsl:for-each select="logicalModel/tables/table/validations/uniqueKeys/uniqueKey">
				<xsl:choose>
				<xsl:when test="@name !='' and @primary = 'false'" >
					<key entity="{ancestor::table/@name}" name="{@name}">
						<columns>
							<xsl:for-each select="uniqueKeyColumns/uniqueKeyColumn">
							<column name="{@name}"/>
							</xsl:for-each>
						</columns>
					</key>
				</xsl:when>
				<xsl:otherwise>
					<key entity="{ancestor::table/@name}" name="{@name}" primary="{@primary}">
						<columns>
							<xsl:for-each select="uniqueKeyColumns/uniqueKeyColumn">
							<column name="{@name}"/>
							</xsl:for-each>
						</columns>
					</key>
				</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
		</uniqueKeys>
		
		<views>
			<xsl:for-each select="logicalModel/views/view[@enable='true']">
			<view name="{@nameView}" label="{@labelView}" rootEntity="{@name}" showInAllTables="{@showInAllTables}">
            	<xsl:choose>
					<xsl:when test="@description !=''">
						<xsl:attribute name="description" >
							<xsl:value-of select="@description"/>
						</xsl:attribute>
					</xsl:when>
					<xsl:otherwise>
						<xsl:attribute name="description" >
							<xsl:value-of select="description"/>
						</xsl:attribute>
					</xsl:otherwise>
				</xsl:choose>
				<columns>
					<xsl:for-each select="viewColumns/viewColumn">
						<xsl:apply-templates select="." mode="viewColumnMode"/>
					</xsl:for-each>
				</columns>
				<joinedColumns>
					<xsl:for-each select="viewParentTables/viewParentTable">
				    <join relation="{@relationship}">
					<columns>
							<xsl:for-each select="viewColumns/viewColumn">
							<xsl:apply-templates select="." mode="viewColumnMode"/>
							</xsl:for-each>
						</columns>
						  
						<xsl:if test="child::viewParentTables/viewParentTable/@name !=''">
							<xsl:apply-templates select="." mode="viewParentTableMode"/>
						</xsl:if>
					</join>
					</xsl:for-each>
				</joinedColumns>
				<columnOrder>
					<xsl:for-each select="viewColumnsOrder/viewColumnOrder">
						<xsl:apply-templates select="."/>
					</xsl:for-each>
				</columnOrder>
					<xsl:if test="sqlCondition !=''">
						<filter>
							<nativeSql>
								<xsl:value-of select="sqlCondition"/>
							</nativeSql>
						</filter>
					</xsl:if>	
			</view>
			</xsl:for-each>		
		</views>
		
		<relationships>
			<xsl:for-each select="logicalModel/relationships/relationship">
				<relationship name="{@name}" label="{@label}" childEntity="{@childTable}" parentEntity="{@parentTable}" lookupType="{@lookuptype}">
					<xsl:if test="sqlCondition !=''">
						<filter>
							<nativeSql>
								<xsl:value-of select="sqlCondition"/>
							</nativeSql>
						</filter>
					</xsl:if>	
					<columns>
						<xsl:for-each select="representativeForeignKey/column">
							<reference parentKeyColumn="{@parentColumn}" childKeyColumn="{@childColumn}" />
						</xsl:for-each>
					</columns>
					<xsl:if test="@lookuptype='combo' and orderRelationships/orderRelationship">
						<orders>
							<xsl:for-each select="orderRelationships/orderRelationship">
								<column desc="{@desc}" name="{@name}"/>
							</xsl:for-each>
						</orders>
					</xsl:if>
				</relationship>
			</xsl:for-each>	 
		</relationships>
		
		<domains>
			<xsl:for-each select="logicalModel/domains/domain">
				<xsl:choose>
          
		            <xsl:when test="@type='STRING' and @rowsCount!='' and @size!=''">
		            	<domain name="{@name}" type="{@type}" size="{@size}">
			            	<xsl:choose>
								<xsl:when test="@validationMsg !=''">
									<xsl:attribute name="errorMsg" >
										<xsl:value-of select="@validationMsg"/>
									</xsl:attribute>
								</xsl:when>
								<xsl:otherwise>
									<xsl:attribute name="errorMsg" >
										<xsl:value-of select="validationMsg"/>
									</xsl:attribute>
								</xsl:otherwise>
							</xsl:choose>
		            		
		            		<xsl:attribute name="format"><xsl:text>rows=</xsl:text><xsl:value-of select="@rowsCount"/><xsl:text>;multiline=true</xsl:text></xsl:attribute>
		            	</domain>
		            </xsl:when>
				          

 					<xsl:when test="@type='STRING' and @regexp='' and @size!=''">
		            	<domain name="{@name}" type="{@type}" size="{@size}">
				            <xsl:choose>
								<xsl:when test="@validationMsg !=''">
									<xsl:attribute name="errorMsg" >
										<xsl:value-of select="@validationMsg"/>
									</xsl:attribute>
								</xsl:when>
								<xsl:otherwise>
									<xsl:attribute name="errorMsg" >
										<xsl:value-of select="validationMsg"/>
									</xsl:attribute>
								</xsl:otherwise>
							</xsl:choose>
		            		<xsl:if test="@format!=''">
                 				<xsl:attribute name="format" ><xsl:value-of select="@format"/></xsl:attribute>
                			</xsl:if>
		            	</domain>
		            </xsl:when>
		              		            
		            <xsl:when test="@type='STRING' and @regexp!='' and @size!=''">
		            	<domain name="{@name}" type="{@type}" size="{@size}" regex="{@regexp}">
				            <xsl:choose>
								<xsl:when test="@validationMsg !=''">
									<xsl:attribute name="errorMsg" >
										<xsl:value-of select="@validationMsg"/>
									</xsl:attribute>
								</xsl:when>
								<xsl:otherwise>
									<xsl:attribute name="errorMsg" >
										<xsl:value-of select="validationMsg"/>
									</xsl:attribute>
								</xsl:otherwise>
							</xsl:choose>>
		            		<xsl:if test="@format!=''">
                 				<xsl:attribute name="format" ><xsl:value-of select="@format" /></xsl:attribute>
                			</xsl:if>
		            	</domain>
		            </xsl:when>
		            
		            <xsl:when test="@type='STRING' and @regexp='' and @size=''">
		            	<domain name="{@name}" type="{@type}" size="{255}">
			            	<xsl:choose>
								<xsl:when test="@validationMsg !=''">
									<xsl:attribute name="errorMsg" >
										<xsl:value-of select="@validationMsg"/>
									</xsl:attribute>
								</xsl:when>
								<xsl:otherwise>
									<xsl:attribute name="errorMsg" >
										<xsl:value-of select="validationMsg"/>
									</xsl:attribute>
								</xsl:otherwise>
							</xsl:choose>
		            		<xsl:if test="@format!=''">
                 				<xsl:attribute name="format" ><xsl:value-of select="@format" /></xsl:attribute>
                			</xsl:if>
		            	</domain>
		            </xsl:when>
		            
		            <xsl:when test="@type='STRING' and @regexp!='' and @size=''">
		            	<domain name="{@name}" type="{@type}" size="{255}" regex="{@regexp}">
			            	<xsl:choose>
								<xsl:when test="@validationMsg !=''">
									<xsl:attribute name="errorMsg" >
										<xsl:value-of select="@validationMsg"/>
									</xsl:attribute>
								</xsl:when>
								<xsl:otherwise>
									<xsl:attribute name="errorMsg" >
										<xsl:value-of select="validationMsg"/>
									</xsl:attribute>
								</xsl:otherwise>
							</xsl:choose>
		            		<xsl:if test="@format!=''">
                 				<xsl:attribute name="format" ><xsl:value-of select="@format" /></xsl:attribute>
                			</xsl:if>
		            	</domain>
		            </xsl:when>

		            
		            
		            <xsl:when test="(@type='INTEGER' or @type='FLOAT') and @min='' and @max=''">
		            	<domain name="{@name}" type="{@type}">
		            	<xsl:if test="@format!=''">
                 				<xsl:attribute name="format" ><xsl:value-of select="@format" /></xsl:attribute>
                		</xsl:if>
                		</domain>
		            </xsl:when>
		            
		            <xsl:when test="(@type='INTEGER' or @type='FLOAT') and @min!='' and @max=''">
		            	<domain name="{@name}" type="{@type}" min="{@min}">
		            	<xsl:if test="@format!=''">
                 				<xsl:attribute name="format" ><xsl:value-of select="@format" /></xsl:attribute>
                		</xsl:if>
                		</domain>
		            </xsl:when>
		            
		            <xsl:when test="(@type='INTEGER' or @type='FLOAT') and @min='' and @max!=''">
		            	<domain name="{@name}" type="{@type}" max="{@max}">
		            	<xsl:if test="@format!=''">
                 				<xsl:attribute name="format" ><xsl:value-of select="@format" /></xsl:attribute>
                		</xsl:if>
                		</domain>
		            </xsl:when>
		            
		             <xsl:when test="(@type='INTEGER' or @type='FLOAT') and @min!='' and @max!=''">
		            	<domain name="{@name}" type="{@type}" min="{@min}" max="{@max}">
		            	<xsl:if test="@format!=''">
                 				<xsl:attribute name="format" ><xsl:value-of select="@format" /></xsl:attribute>
                		</xsl:if>
                		</domain>
		            </xsl:when>
		            
		            <xsl:when test="(@type='LONG') and @min='' and @max=''">
		            	<domain name="{@name}" type="{@type}_INTEGER">
		            	<xsl:if test="@format!=''">
                 				<xsl:attribute name="format" ><xsl:value-of select="@format" /></xsl:attribute>
                		</xsl:if>
                		</domain>
		            </xsl:when>
		            
		            <xsl:when test="(@type='LONG') and @min!='' and @max=''">
		            	<domain name="{@name}" type="{@type}_INTEGER" min="{@min}">
		            	<xsl:if test="@format!=''">
                 				<xsl:attribute name="format" ><xsl:value-of select="@format" /></xsl:attribute>
                		</xsl:if>
                		</domain>
		            </xsl:when>
		            
		            <xsl:when test="(@type='LONG') and @min='' and @max!=''">
		            	<domain name="{@name}" type="{@type}_INTEGER" max="{@max}">
		            	<xsl:if test="@format!=''">
                 				<xsl:attribute name="format" ><xsl:value-of select="@format" /></xsl:attribute>
                		</xsl:if>
                		</domain>
		            </xsl:when>
		            
		             <xsl:when test="(@type='LONG') and @min!='' and @max!=''">
		            	<domain name="{@name}" type="{@type}_INTEGER" min="{@min}" max="{@max}">
		            	<xsl:if test="@format!=''">
                 				<xsl:attribute name="format" ><xsl:value-of select="@format" /></xsl:attribute>
                		</xsl:if>
                		</domain>
		            </xsl:when>
		            
		            <xsl:when test="@type='DATETIME' or @type='DATE' or @type='BOOLEAN'">
		            	<domain name="{@name}" type="{@type}">
		            	<xsl:if test="@format!=''">
                 				<xsl:attribute name="format" ><xsl:value-of select="@format" /></xsl:attribute>
                		</xsl:if>
                		</domain>
		            </xsl:when>
		            
		            <xsl:when test="@type='MNREFERENCES'">
		            	<domain name="{@name}" type="{@type}">
		            		<fkTable>
		            			<name><xsl:value-of select="@fkTable"/></name>
		            		</fkTable>
		            	</domain>
		            </xsl:when>
				</xsl:choose>
				
			</xsl:for-each>
		</domains>
		
		<categoryModel>
			<items>
				<xsl:for-each select="logicalModel/categories/category">
					<item>
						<category name="{@label}">
							<items>
								<xsl:for-each select="categoryItemTables/categoryItemTable">
								<item>
									<table name="{@name}"/>
								</item>
								</xsl:for-each>
								<xsl:for-each select="categoryItemViews/categoryItemView">
								<xsl:if test="ancestor::logicalModel/views/view[@nameView=current()/@name]/@enable='true'">
									<item>
										<view name="{@name}"/>
									</item>
								</xsl:if>
								</xsl:for-each>
								<xsl:for-each select="categoryItemHierarchies/categoryItemHierarchy">
								<xsl:if test="ancestor::logicalModel/hierarchies/hierarchy[@hierarchyName=current()/@name]/@enable='true'">
									<item>
										<hierarchy name="{@name}"/>
									</item>
								</xsl:if>
								</xsl:for-each>
								<xsl:for-each select="categoryItemsCategories/categoryItemCategory">
								<item>
									<xsl:apply-templates select="." mode="categoryItemCategoryMode"/>
								</item>
								</xsl:for-each>
							</items>
						</category>
					</item>
				</xsl:for-each>
			</items>
		</categoryModel>
	
		<dataSets>
			<xsl:for-each select="logicalModel/datasets/dataset[@enable='true']">
				<dataSet name="{@name}" label="{@label}" >
					<description>
						<xsl:value-of select="@description|description" disable-output-escaping='no'/>
<xsl:text disable-output-escaping='no'>				
SQL source:
</xsl:text>
<xsl:value-of select="source/sqlSource" disable-output-escaping='no'/>
					</description>
					<columns>
						<xsl:apply-templates select="columns/datasetColumn" />
					</columns>
					<xsl:if test="orderColumns/column/@name != ''">
						<orderColumns>
							<xsl:for-each select="orderColumns/column">						
								<column name="{@name}" desc="{@orderDescending}" />
							</xsl:for-each>
						</orderColumns>
					</xsl:if>
					<source class="com.ataccama.rdm.manager.config.datasets.RdmSqlDataSetConfig" supportsIncremental="{@supportsIncremental}">
						<sqlSource>
<xsl:value-of select="source/sqlSource" disable-output-escaping='no'/>
						</sqlSource>						
					</source>
				</dataSet>
			</xsl:for-each>
		</dataSets>
	</model>
</xsl:template>

<xsl:template match="datasetColumn">
	<xsl:variable name="tmpType">
		<xsl:choose>
			<xsl:when test="@type='long'">LONG_INTEGER</xsl:when>
			<xsl:otherwise><xsl:value-of select="@type"/></xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<column name="{@name}" label="{@label}" type="{upper-case($tmpType)}">
		<xsl:if test="string-length(@format) > 0">
        	<xsl:attribute name="format"><xsl:value-of select="@format"/></xsl:attribute>
        </xsl:if>
    </column>	
</xsl:template>  

<xsl:template match="viewColumn" mode="viewColumnMode">
	<column>
		<xsl:attribute name="name"><xsl:value-of select="@name"/></xsl:attribute>
		<xsl:if test="@label !=''">
		<xsl:attribute name="label"><xsl:value-of select="@label"/></xsl:attribute>
		</xsl:if>
		<xsl:if test="@alias !=''">
		<xsl:attribute name="alias"><xsl:value-of select="@alias"/></xsl:attribute>
		</xsl:if>
	</column>
</xsl:template>

<xsl:template match="viewParentTable" mode="viewParentTableMode">
	<joinedColumns>
	<xsl:for-each select="child::viewParentTables/viewParentTable">

		<join relation="{ancestor::logicalModel/relationships/relationship[@parentTable=current()/@name and @childTable=current()/../../@name]/@name}">
			<columns>
				<xsl:for-each select="viewColumns/viewColumn">
					<xsl:apply-templates select="." mode="viewColumnMode"/>
				</xsl:for-each>
			</columns>
			<xsl:if test="child::viewParentTables/viewParentTable/@name !=''">
				<xsl:apply-templates select="." mode="viewParentTableMode"/>
			</xsl:if>
		</join>
	</xsl:for-each>
</joinedColumns>
</xsl:template>

<xsl:template match="viewColumnOrder">
	<column>
		<xsl:value-of select="@name"/>
	</column>
</xsl:template>

<xsl:template match="categoryItemCategory" mode="categoryItemCategoryMode">
	<category name="{@name}">
		<items>
			<xsl:for-each select="child::categoryItemTables/categoryItemTable">
				<item>
					<table name="{@name}"/>
				</item>
			</xsl:for-each>
			<xsl:for-each select="child::categoryItemViews/categoryItemView">
			<xsl:if test="ancestor::logicalModel/views/view[@nameView=current()/@name]/@enable='true'">
				<item>
					<view name="{@name}"/>
				</item>
			</xsl:if>
			</xsl:for-each>
			<xsl:for-each select="child::categoryItemHierarchies/categoryItemHierarchy">
			<xsl:if test="ancestor::logicalModel/hierarchies/hierarchy[@hierarchyName=current()/@name]/@enable='true'">
				<item>
					<hierarchy name="{@name}"/>
				</item>
			</xsl:if>
			</xsl:for-each>
			<xsl:for-each select="child::categoryItemsCategories/categoryItemCategory">
				<item>
					<xsl:apply-templates select="." mode="categoryItemCategoryMode"/>
				</item>
			</xsl:for-each>
		</items>
	</category>
</xsl:template>
</xsl:stylesheet>

