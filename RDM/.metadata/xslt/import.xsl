<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="xml" encoding="UTF-8" indent="yes"/>
	
	<xsl:template match="relations">
	  <relationships>
	    <xsl:apply-templates select="relation"/>
	  </relationships>
	</xsl:template>
	
	<xsl:template match="relation">
	  <relationship parentTable="{//tables/table[@name=current()/@parentTable]/@code}" childTable="{//tables/table[@name=current()/@childTable]/@code}">
	    <xsl:attribute name="name"><xsl:value-of select="@code"/></xsl:attribute>
	    <xsl:attribute name="label"><xsl:value-of select="@name"/></xsl:attribute>
	    <representativeForeignKey>
	      <xsl:apply-templates select="foreignKeys/foreignKey"/>
	    </representativeForeignKey>
	  </relationship>
	</xsl:template>
	
	<xsl:template match="foreignKey">
	  <column>
	    <!--xsl:attribute name="parentColumn"><xsl:value-of select="/model/tables/table/columns/column[@id=current()/@parentId]/@name"></xsl:value-of></xsl:attribute-->
	    <xsl:attribute name="parentColumn"><xsl:value-of select="@parentColumn"></xsl:value-of></xsl:attribute>
	    <xsl:attribute name="childColumn"><xsl:value-of select="@childColumn"></xsl:value-of></xsl:attribute>
	  </column>
	</xsl:template>
	
	<!-- <xsl:template match="@columnType">
	  <xsl:attribute name="type"><xsl:value-of select="."/></xsl:attribute>
	</xsl:template>
	
	<xsl:template match="@databaseType">
	  <xsl:attribute name="domain"><xsl:value-of select="."/></xsl:attribute>
	</xsl:template>
	
	<xsl:template match="@code">
	  <xsl:attribute name="name"><xsl:value-of select="."/></xsl:attribute>
	</xsl:template>

	<xsl:template match="@name">
	  <xsl:attribute name="label"><xsl:value-of select="."/></xsl:attribute>
	</xsl:template>
	
	<xsl:template match="@comment">
	  <xsl:attribute name="description"><xsl:value-of select="."/></xsl:attribute>
	</xsl:template>
	
	<xsl:template match="@mandatory">
	  <xsl:attribute name="required"><xsl:value-of select="."/></xsl:attribute>
	</xsl:template>-->

	<xsl:template match="node()|@*">
		<xsl:copy>
			<xsl:apply-templates select="node()|@*"/>			
		</xsl:copy>			
	</xsl:template>
	
	<xsl:template match="model">
		<model>
			<xsl:apply-templates select="relations"/>	
			<xsl:apply-templates select="tables"/>	
			<xsl:call-template name="domains"/>		
		</model>
	</xsl:template>

	<xsl:template match="tables">	
		<tables>	
			<xsl:apply-templates select="table"/>
		</tables>				
	</xsl:template>
	
	<xsl:template match="table">
	  <table>
	    <xsl:attribute name="name"><xsl:value-of select="@code"/></xsl:attribute>
	    <xsl:attribute name="label"><xsl:value-of select="@name"/></xsl:attribute>
	    <xsl:attribute name="description"><xsl:value-of select="@comment"/></xsl:attribute>  
	    <xsl:apply-templates select="columns"/>
	    <xsl:apply-templates select="keys">
	    	<xsl:with-param name="tableName" select="@code"/>
	    </xsl:apply-templates>
	  </table>	  
	</xsl:template>
	
	<xsl:template match="columns">	
		<columns>	
			<xsl:apply-templates select="column"/>
		</columns>				
	</xsl:template>
	
	<xsl:template match="column">
	  <column>
	    <xsl:attribute name="name"><xsl:value-of select="@code"/></xsl:attribute>
	    <xsl:attribute name="type"><xsl:value-of select="@columnType"/></xsl:attribute>
	    <xsl:attribute name="domain"><xsl:value-of select="@databaseType"/></xsl:attribute>
	    <xsl:attribute name="label"><xsl:value-of select="@name"/></xsl:attribute>
	    <xsl:attribute name="description"><xsl:value-of select="@comment"/></xsl:attribute>
	    <xsl:attribute name="required"><xsl:value-of select="@mandatory"/></xsl:attribute>	    
	  </column>	  
	</xsl:template>

	<xsl:template match="keys">
		<xsl:param name="tableName"/>	
		<validations>	
			<uniqueKeys>
				<xsl:apply-templates select="key">
					<xsl:with-param name="tableName" select="$tableName"/>
				</xsl:apply-templates>
			</uniqueKeys>
		</validations>				
	</xsl:template>

	<xsl:template match="key">
		<xsl:param name="tableName"/>
		<uniqueKey>
			<xsl:attribute name="name">
				<xsl:value-of select="'pk'"/>
				<xsl:value-of select="'_'"/>
				<xsl:value-of select="lower-case($tableName)"/>
			</xsl:attribute>
		  	<xsl:attribute name="primary"><xsl:value-of select="'true'"/></xsl:attribute>
		  	<xsl:apply-templates select="columns" mode="pk"/>
		</uniqueKey>	  
	</xsl:template>
	
	<xsl:template match="columns" mode="pk">	
		<uniqueKeyColumns>	
			<xsl:apply-templates select="column" mode="pk"/>
		</uniqueKeyColumns>				
	</xsl:template>
	
	<xsl:template match="column" mode="pk">
	  <uniqueKeyColumn>
	    <xsl:attribute name="name"><xsl:value-of select="@code"/></xsl:attribute>
	  </uniqueKeyColumn>	  
	</xsl:template>

	<xsl:template name="domains">
		<domains>
			<xsl:for-each select="tables/table/columns/column[not(@databaseType=preceding::column/@databaseType)]">
				<xsl:call-template name="domain"/>
			</xsl:for-each>
		</domains>
	</xsl:template>
	
	<xsl:template name="domain">
		<domain>
			<xsl:attribute name="name"><xsl:value-of select="@databaseType"/></xsl:attribute>
			<xsl:attribute name="size">
				<xsl:if test="contains(@databaseType, '(') and (contains(upper-case(@databaseType),'CHAR') or contains(upper-case(@databaseType),'TEXT'))">
					<xsl:value-of select="replace(@databaseType,'(.*)\((.*)\)','$2')"/>
				</xsl:if>
			</xsl:attribute>
			<xsl:attribute name="type">
				<xsl:choose>
					<!-- boolean -->
					<xsl:when test="contains(upper-case(@databaseType),'BOOL') or contains(upper-case(@databaseType),'BIT')">				
						<xsl:value-of select="'BOOLEAN'"/>
					</xsl:when>	
					<!-- datetime -->
					<xsl:when test="contains(upper-case(@databaseType),'TIME') or contains(upper-case(@databaseType),'DATE')">				
						<xsl:value-of select="'DATETIME'"/>
					</xsl:when>						
					<!-- long -->
					<xsl:when test="contains(upper-case(@databaseType),'BIGINT')">				
						<xsl:value-of select="'LONG'"/>
					</xsl:when>	
					<!-- certain float-like types with only the precision parameter should be long or integer - this needs to be examined more -->
					<!-- at the moment the importer checks if there is only one parameter and uses INTEGER if it is less than 10 and uses LONG if it is bigger -->
					<xsl:when test="matches(@databaseType, '(.*)\(([^,]*)\)') and (contains(upper-case(@databaseType),'NUMBER') or contains(upper-case(@databaseType),'DEC') or contains(upper-case(@databaseType),'NUMERIC'))">	
						<xsl:variable name="precision" select="number(replace(@databaseType,'(.*)\(([^,]*)\)','$2'))" />
						<xsl:choose>
							<xsl:when test="$precision = null">				
								<xsl:value-of select="'FLOAT'"/>
							</xsl:when>	
							<xsl:when test="$precision &lt; 10">				
								<xsl:value-of select="'INTEGER'"/>
							</xsl:when>	
							<xsl:otherwise>
								<xsl:value-of select="'LONG'"/>
							</xsl:otherwise>			
						</xsl:choose>
					</xsl:when>
					<!-- integer -->
					<xsl:when test="contains(upper-case(@databaseType),'INT')">				
						<xsl:value-of select="'INTEGER'"/>
					</xsl:when>	
					<!-- float -->
					<xsl:when test="contains(upper-case(@databaseType),'DEC') or contains(upper-case(@databaseType),'REAL') or contains(upper-case(@databaseType),'FLOAT') or contains(upper-case(@databaseType),'DOUBLE') or contains(upper-case(@databaseType),'NUMERIC') or contains(upper-case(@databaseType),'NUMBER')">				
						<xsl:value-of select="'FLOAT'"/>
					</xsl:when>	
					<!-- string -->
					<xsl:when test="contains(upper-case(@databaseType),'CHAR') or contains(upper-case(@databaseType),'TEXT')">				
						<xsl:value-of select="'STRING'"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="''"/>
					</xsl:otherwise>			
				</xsl:choose>
			</xsl:attribute>
		</domain>
	</xsl:template>
		
</xsl:stylesheet>

