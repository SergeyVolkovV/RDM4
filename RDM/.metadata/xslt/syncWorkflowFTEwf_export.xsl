<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:sf="http://www.ataccama.com/xslt/functions"
 xmlns:mrg="http://www.ataccama.com/dqc/plan-merge"	 
 xmlns:exsl="http://exslt.org/common" extension-element-prefixes="exsl sf">
<xsl:output method="xml" encoding="UTF-8" indent="yes"/>

<xsl:param name="systems" select="document('param:systems')/*"/>
<xsl:include href="constants_incl.xsl"/>

<xsl:template match="/*">
	<workflow xmlns:vis="http://www.ataccama.com/purity/visual" version="{$rdm_version}">
	<continueOnFailure>false</continueOnFailure>
	<groups/>
	<multiplicity>0</multiplicity>
	<name><xsl:value-of select="@name"/><xsl:text>_export export</xsl:text></name>
	<variables/>
	
	<xsl:variable name="countExports" select="count(syncSFTPTaskExports/syncSFTPTaskExport)"/>
	
	<tasks>
		<xsl:for-each select="syncSFTPTaskExports/syncSFTPTaskExport">
			<task>
				<id><xsl:value-of select="format-number((count(preceding::syncSFTPTaskExport)+1)*10,'000')"/></id>
				<name><xsl:value-of select="@outputFileName"/></name>
				<acceptMode><xsl:text>ALL_VALID</xsl:text></acceptMode>
				<executable class="com.ataccama.adt.task.exec.EwfDqcTask">
					<planFile><xsl:text>../plans/synchronization/FTs/exports/</xsl:text><xsl:value-of select="ancestor::syncSFTPTaskE/@name"/><xsl:text>_</xsl:text><xsl:value-of select="@outputFileName"/><xsl:text>_export.plan</xsl:text></planFile>
				</executable>
			</task>
		</xsl:for-each>
		
		<xsl:if test="@compression = 'NONE' and @SFTPserver != ''">
		<xsl:for-each select="syncSFTPTaskExports/syncSFTPTaskExport">
			<task>
				<id><xsl:value-of select="format-number(($countExports+count(preceding::syncSFTPTaskExport)+1)*10,'000')"/></id>
				<name><xsl:text>Upload </xsl:text><xsl:value-of select="@outputFileName"/></name>
				<acceptMode><xsl:text>ALL_VALID</xsl:text></acceptMode>
				<executable class="com.ataccama.adt.task.exec.SFTPUploadFile">
					<file><xsl:text>../../</xsl:text><xsl:value-of select="@filePath"/><xsl:text>/</xsl:text><xsl:value-of select="@outputFileName"/></file>
					<urlResource><xsl:value-of select="ancestor::syncSFTPTaskE/@SFTPserver"/></urlResource>
					<knownHostsPath><xsl:value-of select="$systems/SFTPSystems/SFTPSystem[@name=current()/ancestor::syncSFTPTaskE/@SFTPserver]/@knownHosts"/></knownHostsPath>
					<targetDirectory><xsl:value-of select="@targetDirectory"/></targetDirectory>
				</executable>
			</task>
		</xsl:for-each>
		</xsl:if>
		
		<xsl:if test="@compression = 'ZIP'">
			<task>
				<id><xsl:value-of select="format-number(($countExports+1)*10,'000')"/></id>
				<name><xsl:text>Compress file(s)</xsl:text></name>
				<executable expectedReturnCodes="0" class="com.ataccama.adt.task.exec.EwfShellScriptTask">
					<command>zip -9 -y -r -q <xsl:value-of select="@fileName"/> ./*</command>
					<workingDir>../../<xsl:value-of select="@filePath"/></workingDir>
					<waitFor>true</waitFor>
					<logStartStop>true</logStartStop>
				</executable>
			</task>
			<xsl:if test="@SFTPserver != ''">
				<task>
					<id><xsl:value-of select="format-number(($countExports+2)*10,'000')"/></id>
					<name><xsl:text>Upload </xsl:text><xsl:value-of select="@fileName"/></name>
					<executable class="com.ataccama.adt.task.exec.SFTPUploadFile">
						<file><xsl:text>../../</xsl:text><xsl:value-of select="@filePath"/><xsl:text>/</xsl:text><xsl:value-of select="@fileName"/></file>
						<urlResource><xsl:value-of select="@SFTPserver"/></urlResource>
						<knownHostsPath><xsl:value-of select="$systems/SFTPSystems/SFTPSystem[@name=current()/@SFTPserver]/@knownHosts"/></knownHostsPath>
						<targetDirectory><xsl:value-of select="@targetDirectory"/></targetDirectory>
					</executable>
				</task>
			</xsl:if>
		</xsl:if>
		
		<xsl:if test="@compression = 'GZIP'">
			<task>
				<id><xsl:value-of select="format-number(($countExports+count(preceding::syncSFTPTaskExport)+1)*10,'000')"/></id>
				<name><xsl:text>Compress file(s)</xsl:text></name>
				<executable expectedReturnCodes="0" class="com.ataccama.adt.task.exec.EwfShellScriptTask">
					<command>gzip -9 -y -r -q <xsl:value-of select="@fileName"/> ./*</command>
					<workingDir>../../<xsl:value-of select="@filePath"/></workingDir>
					<waitFor>true</waitFor>
					<logStartStop>true</logStartStop>
				</executable>
			</task>
			<xsl:if test="@SFTPserver != ''">			
				<task>
					<id><xsl:value-of select="format-number(($countExports+count(preceding::syncSFTPTaskExport)+2)*10,'000')"/></id>
					<name><xsl:text>Upload </xsl:text><xsl:value-of select="ancestor::syncSFTPTaskE/@fileName"/></name>
					<executable class="com.ataccama.adt.task.exec.SFTPUploadFile">
						<file><xsl:text>../../</xsl:text><xsl:value-of select="@filePath"/><xsl:text>/</xsl:text><xsl:value-of select="@fileName"/></file>
						<urlResource><xsl:value-of select="@SFTPserver"/></urlResource>
						<knownHostsPath><xsl:value-of select="$systems/SFTPSystems/SFTPSystem[@name=current()/@SFTPserver]/@knownHosts"/></knownHostsPath>
						<targetDirectory><xsl:value-of select="@targetDirectory"/></targetDirectory>
					</executable>
				</task>
			</xsl:if>
		</xsl:if>
				
	</tasks>
	
	<links>
		<xsl:for-each select="syncSFTPTaskExports/syncSFTPTaskExport">
    		<xsl:variable name="nextPlanExport" select="following-sibling::syncSFTPTaskExport/@outputFileName"/>
    			<xsl:if test="$nextPlanExport != ''">
					<link>
						<xsl:attribute name="from"><xsl:value-of select="format-number((count(preceding::syncSFTPTaskExport)+1)*10,'000')" ></xsl:value-of></xsl:attribute>
						<xsl:attribute name="to"><xsl:value-of select="format-number((count(preceding::syncSFTPTaskExport)+2)*10,'000')" ></xsl:value-of></xsl:attribute>
					</link> 
				</xsl:if>
		</xsl:for-each>
		
		<xsl:if test="@compression = 'NONE' and @SFTPserver != ''">
		<xsl:for-each select="syncSFTPTaskExports/syncSFTPTaskExport">
			<link>
				<xsl:attribute name="from"><xsl:value-of select="format-number(($countExports+count(preceding::syncSFTPTaskExport))*10,'000')" ></xsl:value-of></xsl:attribute>
				<xsl:attribute name="to"><xsl:value-of select="format-number(($countExports+count(preceding::syncSFTPTaskExport)+1)*10,'000')" ></xsl:value-of></xsl:attribute>
			</link> 
		</xsl:for-each>
		</xsl:if>
		
		<xsl:if test="@compression = 'ZIP' or @compression = 'GZIP'">
			<link>
				<xsl:attribute name="from"><xsl:value-of select="format-number(($countExports+count(preceding::syncSFTPTaskExport))*10,'000')" ></xsl:value-of></xsl:attribute>
				<xsl:attribute name="to"><xsl:value-of select="format-number(($countExports+count(preceding::syncSFTPTaskExport)+1)*10,'000')" ></xsl:value-of></xsl:attribute>
			</link> 
			<xsl:if test="@SFTPserver != ''">
				<link>
					<xsl:attribute name="from"><xsl:value-of select="format-number(($countExports+count(preceding::syncSFTPTaskExport)+1)*10,'000')" ></xsl:value-of></xsl:attribute>
					<xsl:attribute name="to"><xsl:value-of select="format-number(($countExports+count(preceding::syncSFTPTaskExport)+2)*10,'000')" ></xsl:value-of></xsl:attribute>
				</link> 
			</xsl:if>
		</xsl:if>
		
		
	</links>	
	
</workflow>
</xsl:template>


</xsl:stylesheet>