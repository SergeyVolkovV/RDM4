<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="xml" encoding="UTF-8" indent="yes"/>

<xsl:template match="*">
	
<hierarchyRoot>
	<hierarchies>
		<xsl:for-each select="logicalModel/hierarchies/hierarchy[@enable='true']">
			<hierarchy name="{@hierarchyLabel}" rootEntityName="{@name}">
				<structure>
					<references>
						<xsl:for-each select="hierarchyChildTables/hierarchyChildTable">
						<reference name="{@relationship}">
							<xsl:if test="child::hierarchyChildTables/hierarchyChildTable/@name !='' or child::hierarchyViews/hierarchyView/@name !=''">
								<xsl:apply-templates select="." mode="hierarchyChildTableMode"/>
							</xsl:if>
							<xsl:if test="orderHierarchyChildTables/orderHierarchyChildTable">
		           				<orders>
		           					<xsl:for-each select="orderHierarchyChildTables/orderHierarchyChildTable">
					            		<order name="{@name}" desc="{@desc}"/>
					            	</xsl:for-each>
					        	</orders>
		           			</xsl:if>
						</reference>
						</xsl:for-each>
					</references>
					<views>
               			<xsl:for-each select="hierarchyViews/hierarchyView">
							<xsl:if test="ancestor::logicalModel/views/view[@nameView=current()/@name]/@enable='true'">
								<view name="{@name}">
								    <xsl:if test="orderViews/orderView">
				           				<orders>
				           					<xsl:for-each select="orderViews/orderView">
							            		<order name="{@name}" desc="{@desc}"/>
							            	</xsl:for-each>
							        	</orders>
				           			</xsl:if>
								</view>
							</xsl:if>
						</xsl:for-each>
           			</views>
           			<xsl:if test="orderHierarchies/orderHierarchy">
           				<orders>
           					<xsl:for-each select="orderHierarchies/orderHierarchy">
			            		<order name="{@name}" desc="{@desc}"/>
			            	</xsl:for-each>
			        	</orders>
           			</xsl:if>
				</structure>
			</hierarchy>
		</xsl:for-each>
	</hierarchies>
</hierarchyRoot>		
</xsl:template>

<xsl:template match="hierarchyChildTable" mode="hierarchyChildTableMode">
	<xsl:if test="child::hierarchyChildTables/hierarchyChildTable/@name !=''">
	<references>
		<xsl:for-each select="child::hierarchyChildTables/hierarchyChildTable">
		<reference name="{@relationship}">
			<xsl:if test="orderHierarchyChildTables/orderHierarchyChildTable">
         		<orders>
         			<xsl:for-each select="orderHierarchyChildTables/orderHierarchyChildTable">
	            		<order name="{@name}" desc="{@desc}"/>
	            	</xsl:for-each>
	        	</orders>
         	</xsl:if>
			<xsl:apply-templates select="." mode="hierarchyChildTableMode"/>
		</reference>
		</xsl:for-each>
	</references>
	</xsl:if>
	<views>
		<xsl:if test="child::hierarchyViews/hierarchyView/@name !=''">
			<xsl:for-each select="child::hierarchyViews/hierarchyView">
				<xsl:if test="ancestor::logicalModel/views/view[@nameView=current()/@name]/@enable='true'">
					<view name="{@name}">
					    <xsl:if test="orderViews/orderView">
		          			<orders>
		          				<xsl:for-each select="orderViews/orderView">
				            		<order name="{@name}" desc="{@desc}"/>
				            	</xsl:for-each>
				        	</orders>
		          		</xsl:if>		
					</view>
				</xsl:if>
			</xsl:for-each>
		</xsl:if>
	</views>
</xsl:template>

<!-- <xsl:template match="hierarchyView" mode="hierarchyViewMode">
	<xsl:for-each select="child::hierarchyViews/hierarchyView">
	<references>
		<reference name="{@name}">
			<xsl:apply-templates select="." mode="hierarchyViewMode"/>
		</reference>
	</references>
	</xsl:for-each>
</xsl:template> -->

</xsl:stylesheet>	
	
