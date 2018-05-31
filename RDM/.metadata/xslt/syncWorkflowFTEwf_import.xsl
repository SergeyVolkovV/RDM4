<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:sf="http://www.ataccama.com/xslt/functions"
 xmlns:mrg="http://www.ataccama.com/dqc/plan-merge"
 xmlns:exsl="http://exslt.org/common" extension-element-prefixes="exsl sf">
<xsl:output method="xml" encoding="UTF-8" indent="yes"/>

<xsl:param name="systems" select="document('param:systems')/*"/>
<xsl:include href="constants_incl.xsl"/>

<xsl:template match="/*">
	<xsl:variable name="countImports" select="count(syncSFTPTaskImports/syncSFTPTaskImport)"/>

	<workflow xmlns:vis="http://www.ataccama.com/purity/visual" xmlns:mrg="http://www.ataccama.com/dqc/plan-merge"  version="{$rdm_version}">
	<continueOnFailure>false</continueOnFailure>
	<groups/>
	<multiplicity>0</multiplicity>
	<name><xsl:value-of select="@name"/><xsl:text>_import import</xsl:text></name>
	<variables/>
	
	<xsl:variable name="tmpSystem" select="$systems/SFTPSystems/SFTPSystem[@name=current()/@SFTPserver]"/>
	<xsl:choose>
		<xsl:when test="@filePath != ''">
		<tasks>
			<xsl:if test="$tmpSystem != ''">
				<task>
					<id>010</id>
					<name>Download file(s)</name>
					<acceptMode><xsl:text>ALL_VALID</xsl:text></acceptMode>
					<executable class="com.ataccama.adt.task.exec.SFTPDownloadFile">
						<urlResource><xsl:value-of select="@SFTPserver"/></urlResource>
						<knownHostsPath><xsl:value-of select="$systems/SFTPSystems/SFTPSystem[@name=ancestor::syncSFTPTaskE/@SFTPserver]"/></knownHostsPath>
						<file><xsl:value-of select="@filePath"/>/<xsl:value-of select="SFTPPlanInput/SFTPPlanExports/@fileName"/></file>
						<targetDirectory><xsl:value-of select="@targetDirectory"/></targetDirectory>
					</executable>
				</task>
			</xsl:if>
		
			<xsl:choose>
  				<xsl:when test="@compression != 'NONE'">
  					<task>
						<id>020</id> 
						<name>Extract compressed file(s)</name>
						<executable expectedReturnCodes="0" class="com.ataccama.adt.task.exec.EwfShellScriptTask">
							<command>unzip -o "<xsl:value-of select="@targetDirectory"/>/<xsl:value-of select="@fileName"/>" -d "<xsl:value-of select="SFTPPlanInput/SFTPPlanExports/@targetDirectory"/>"</command>
							<workingDir/>
							<waitFor>true</waitFor>
							<logStartStop>true</logStartStop>
						</executable>
					</task>
  					
  					<xsl:for-each select="syncSFTPTaskImports/syncSFTPTaskImport">
						<task>
							<id><xsl:value-of select="format-number((count(preceding::syncSFTPTaskImport)+3)*10,'000')"/></id>
							<name><xsl:value-of select="ancestor::syncSFTPTaskI/@fileName"/></name>
							<acceptMode><xsl:text>AT_LEAST_ONE</xsl:text></acceptMode>
							<executable class="com.ataccama.adt.task.exec.EwfDqcTask">
								<planFile><xsl:text>../plans/synchronization/FTs/imports/</xsl:text><xsl:value-of select="ancestor::syncSFTPTaskI/@name"/><xsl:text>_</xsl:text><xsl:value-of select="@tableName"/><xsl:text>_import.plan</xsl:text></planFile>
							</executable>
						</task>
					</xsl:for-each>
					
					<xsl:if test="ancestor::syncSFTPTaskI/@deleteFile = 'true'">
						<task>
							<id><xsl:value-of select="format-number((count(syncSFTPTaskImports/syncSFTPTaskImport)+3)*10,'000')"/></id>
							<name>Remove file(s)</name>
							<executable expectedReturnCodes="0" class="com.ataccama.adt.task.exec.EwfShellScriptTask">
								<command>rm -r "<xsl:value-of select="@targetDirectory"/>"/*</command>
								<workingDir/>
								<waitFor>true</waitFor>
								<logStartStop>true</logStartStop>
							</executable>
						</task>
					</xsl:if>
				</xsl:when>
  				<xsl:otherwise>
					<xsl:for-each select="syncSFTPTaskImports/syncSFTPTaskImport">
						<task>
							<id><xsl:value-of select="format-number((count(preceding::syncSFTPTaskImport)+2)*10,'000')"/></id>
							<name><xsl:value-of select="@tableName"/></name>
							<acceptMode><xsl:text>AT_LEAST_ONE</xsl:text></acceptMode>
							<executable class="com.ataccama.adt.task.exec.EwfDqcTask">
								<planFile><xsl:text>../plans/synchronization/FTs/imports/</xsl:text><xsl:value-of select="ancestor::syncSFTPTaskI/@name"/><xsl:text>_</xsl:text><xsl:value-of select="@tableName"/><xsl:text>_import.plan</xsl:text></planFile>
							</executable>
						</task>
					</xsl:for-each>
					
					<xsl:if test="@deleteFile = 'true'">
						<task>
							<id><xsl:value-of select="format-number((count(syncSFTPTaskImports/syncSFTPTaskImport)+2)*10,'000')"/></id>
							<name>Remove file(s)</name>
							<executable expectedReturnCodes="0" class="com.ataccama.adt.task.exec.EwfShellScriptTask">
								<command>rm -r "<xsl:value-of select="@targetDirectory"/>"/*</command>
								<workingDir/>
								<waitFor>true</waitFor>
								<logStartStop>true</logStartStop>
							</executable>
						</task>
					</xsl:if>
  				</xsl:otherwise>
			</xsl:choose>
			
	</tasks>
	
	<links>
		<xsl:choose>
  				<xsl:when test="@compression != 'NONE'">
  					<link to="020" from="010"/>
  					<link to="030" from="020"/>
					
					<xsl:for-each select="syncSFTPTaskImports/syncSFTPTaskImport">
    				<xsl:variable name="nextPlanImport" select="following-sibling::syncSFTPTaskImport/@tableName"/>
    					<xsl:if test="$nextPlanImport != ''">
							<link>
								<xsl:attribute name="from"><xsl:value-of select="format-number((count(preceding::syncSFTPTaskImport)+3)*10,'000')" ></xsl:value-of></xsl:attribute>
								<xsl:attribute name="to"><xsl:value-of select="format-number((count(preceding::syncSFTPTaskImport)+4)*10,'000')" ></xsl:value-of></xsl:attribute>
							</link> 
						</xsl:if>
					</xsl:for-each>
					
					<xsl:if test="@deleteFile = 'true'">
						<link>
							<xsl:attribute name="from"><xsl:value-of select="format-number((count(syncSFTPTaskImports/syncSFTPTaskImport)+2)*10,'000')" ></xsl:value-of></xsl:attribute>
							<xsl:attribute name="to"><xsl:value-of select="format-number((count(syncSFTPTaskImports/syncSFTPTaskImport)+3)*10,'000')" ></xsl:value-of></xsl:attribute>
						</link>
					</xsl:if>
				</xsl:when>
  				
  				<xsl:otherwise>
					<link to="020" from="010"/>
					
					<xsl:for-each select="syncSFTPTaskImports/syncSFTPTaskImport">
    				<xsl:variable name="nextPlanExport" select="following-sibling::syncSFTPTaskImport/@tableName"/>
    					<xsl:if test="$nextPlanExport != ''">
							<link>
								<xsl:attribute name="from"><xsl:value-of select="format-number((count(preceding::syncSFTPTaskImport)+2)*10,'000')" ></xsl:value-of></xsl:attribute>
								<xsl:attribute name="to"><xsl:value-of select="format-number((count(preceding::syncSFTPTaskImport)+3)*10,'000')" ></xsl:value-of></xsl:attribute>
							</link> 
						</xsl:if>
					</xsl:for-each>
					
					<xsl:if test="@deleteFile = 'true'">
						<link>
							<xsl:attribute name="from"><xsl:value-of select="format-number((count(syncSFTPTaskImports/syncSFTPTaskImport)+1)*10,'000')" ></xsl:value-of></xsl:attribute>
							<xsl:attribute name="to"><xsl:value-of select="format-number((count(syncSFTPTaskImports/syncSFTPTaskImport)+2)*10,'000')" ></xsl:value-of></xsl:attribute>
						</link>
					</xsl:if>
  				</xsl:otherwise>
			</xsl:choose>
	</links>	
		</xsl:when>

		<xsl:otherwise>
			<tasks>
			<xsl:choose>
  				<xsl:when test="@compression != 'NONE'">
  					<task>
						<id>010</id> 
						<name>Extract compressed file(s)</name>
						<executable expectedReturnCodes="0" class="com.ataccama.adt.task.exec.EwfShellScriptTask">
							<command>unzip -o "<xsl:value-of select="@targetDirectory"/>/<xsl:value-of select="@fileName"/>" -d "<xsl:value-of select="@targetDirectory"/>"</command>
							<workingDir/>
							<waitFor>true</waitFor>
							<logStartStop>true</logStartStop>
						</executable>
					</task>
  					
  					<xsl:for-each select="syncSFTPTaskImports/syncSFTPTaskImport">
						<task>
							<id><xsl:value-of select="format-number((count(preceding::syncSFTPTaskImport)+2)*10,'000')"/></id>
							<name><xsl:value-of select="ancestor::syncSFTPTaskI/@fileName"/></name>
							<acceptMode><xsl:text>AT_LEAST_ONE</xsl:text></acceptMode>
							<executable class="com.ataccama.adt.task.exec.EwfDqcTask">
								<planFile><xsl:text>../plans/synchronization/FTs/imports/</xsl:text><xsl:value-of select="ancestor::syncSFTPTaskI/@name"/><xsl:text>_</xsl:text><xsl:value-of select="@tableName"/><xsl:text>_import.plan</xsl:text></planFile>
							</executable>
						</task>
					</xsl:for-each>
				</xsl:when>
  				<xsl:otherwise>
					<xsl:for-each select="syncSFTPTaskImports/syncSFTPTaskImport">
						<task>
							<id><xsl:value-of select="format-number((count(preceding::syncSFTPTaskImport)+1)*10,'000')"/></id>
							<name><xsl:value-of select="@tableName"/></name>
							<acceptMode><xsl:text>AT_LEAST_ONE</xsl:text></acceptMode>
							<executable class="com.ataccama.adt.task.exec.EwfDqcTask">
								<planFile><xsl:text>../plans/synchronization/FTs/imports/</xsl:text><xsl:value-of select="ancestor::syncSFTPTaskI/@name"/><xsl:text>_</xsl:text><xsl:value-of select="@tableName"/><xsl:text>_import.plan</xsl:text></planFile>
							</executable>
						</task>
					</xsl:for-each>
  				</xsl:otherwise>
			</xsl:choose>
			
			<xsl:choose>
				<xsl:when test="@deleteFile = 'true' and @compression = 'NONE'">
				<task>
					<id><xsl:value-of select="format-number((count(syncSFTPTaskImports/syncSFTPTaskImport)+1)*10,'000')"/></id>
					<name>Remove file(s)</name>
					<executable expectedReturnCodes="0" class="com.ataccama.adt.task.exec.EwfShellScriptTask">
						<command>rm -r "<xsl:value-of select="ancestor::syncSFTPTaskI/@targetDirectory"/>"/*</command>
						<workingDir/>
						<waitFor>true</waitFor>
						<logStartStop>true</logStartStop>
					</executable>
				</task>
				</xsl:when>
				<xsl:otherwise>
					<xsl:if test="@deleteFile = 'true'">
						<task>
							<id><xsl:value-of select="format-number((count(syncSFTPTaskImports/syncSFTPTaskImport)+2)*10,'000')"/></id>
							<name>Remove file(s)</name>
							<executable expectedReturnCodes="0" class="com.ataccama.adt.task.exec.EwfShellScriptTask">
								<command>rm -r "<xsl:value-of select="ancestor::syncSFTPTaskI/@targetDirectory"/>"/*</command>
								<workingDir/>
								<waitFor>true</waitFor>
								<logStartStop>true</logStartStop>
							</executable>
						</task>	
					</xsl:if>			
				</xsl:otherwise>
			</xsl:choose>
	</tasks>
	
	<links>
		<xsl:choose>
  				<xsl:when test="@compression != 'NONE'">
  					<link to="020" from="010"/>
					
					<xsl:for-each select="syncSFTPTaskImports/syncSFTPTaskImport">
    				<xsl:variable name="nextPlanImport" select="following-sibling::syncSFTPTaskImport/@tableName"/>
    					<xsl:if test="$nextPlanImport != ''">
							<link>
								<xsl:attribute name="from"><xsl:value-of select="format-number((count(preceding::SFTPPlanExport)+2)*10,'000')" ></xsl:value-of></xsl:attribute>
								<xsl:attribute name="to"><xsl:value-of select="format-number((count(preceding::SFTPPlanExport)+3)*10,'000')" ></xsl:value-of></xsl:attribute>
							</link> 
						</xsl:if>
					</xsl:for-each>
					
					<xsl:if test="@deleteFile = 'true'">
						<link>
							<xsl:attribute name="from"><xsl:value-of select="format-number((count(syncSFTPTaskImports/syncSFTPTaskImport)+1)*10,'000')" ></xsl:value-of></xsl:attribute>
							<xsl:attribute name="to"><xsl:value-of select="format-number((count(syncSFTPTaskImports/syncSFTPTaskImport)+2)*10,'000')" ></xsl:value-of></xsl:attribute>
						</link>
					</xsl:if>
				</xsl:when>
  				
  				<xsl:otherwise>
					<xsl:for-each select="syncSFTPTaskImports/syncSFTPTaskImport">
    				<xsl:variable name="nextPlanExport" select="following-sibling::syncSFTPTaskImport/@tableName"/>
    					<xsl:if test="$nextPlanExport != ''">
							<link>
								<xsl:attribute name="from"><xsl:value-of select="format-number((count(preceding::syncSFTPTaskImport)+1)*10,'000')" ></xsl:value-of></xsl:attribute>
								<xsl:attribute name="to"><xsl:value-of select="format-number((count(preceding::syncSFTPTaskImport)+2)*10,'000')" ></xsl:value-of></xsl:attribute>
							</link> 
						</xsl:if>
					</xsl:for-each>
					
					<xsl:if test="@deleteFile = 'true'">
						<link>
							<xsl:attribute name="from"><xsl:value-of select="format-number((count(syncSFTPTaskImports/syncSFTPTaskImport))*10,'000')" ></xsl:value-of></xsl:attribute>
							<xsl:attribute name="to"><xsl:value-of select="format-number((count(syncSFTPTaskImports/syncSFTPTaskImport)+1)*10,'000')" ></xsl:value-of></xsl:attribute>
						</link>
					</xsl:if>
  				</xsl:otherwise>
			</xsl:choose>
	</links>		
		</xsl:otherwise>
		</xsl:choose>	
</workflow>
</xsl:template>


</xsl:stylesheet>