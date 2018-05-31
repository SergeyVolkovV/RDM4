<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
 <xsl:output method="xml" encoding="UTF-8" indent="yes"/>
<xsl:param name="logicalModel" select="document('param:logicalModel')/*"/>


<xsl:template match="*">
	
<users-config>
	
	<xsl:if test="security/@userRepository ='File repository'">
		<usersProvider class="com.ataccama.rdm.manager.config.RdmXmlFileUsersProviderConfig">
		<users>
			<xsl:for-each select="security/fileRepository/users/user">
				<user name="{@name}" email="{@email}" system="{@permissionsAdministrator}"/>
			</xsl:for-each>
		</users>
		</usersProvider>
	</xsl:if>
	
	<xsl:if test="security/@userRepository ='LDAP repository'">
		<xsl:variable name="countLdap" select="count(security/LDAPRepositories/LDAPRepository)"/>
		<xsl:choose>
			<xsl:when test="$countLdap=1">
				<xsl:for-each select="security/LDAPRepositories/LDAPRepository">
					<usersProvider class="com.ataccama.rdm.manager.config.RdmLdapUsersProviderConfig">
						<xsl:choose>
						<xsl:when test="connection/@port!=''">
							<urls>
								<url><xsl:text>ldap://</xsl:text><xsl:value-of select="connection/@host"/><xsl:text>:</xsl:text><xsl:value-of select="connection/@port"/></url>
							</urls>
						</xsl:when>
						<xsl:otherwise>
							<urls>
								<url><xsl:text>ldap://</xsl:text><xsl:value-of select="connection/@host"/></url>
							</urls>
						</xsl:otherwise>
						</xsl:choose>
						<basePath><xsl:value-of select="connection/@basePath"/></basePath>
						<userQuery><xsl:value-of select="connection/@userQuery"/></userQuery>
						<authType><xsl:value-of select="account/@authType"/></authType>
						<authUser><xsl:value-of select="account/@authUser"/></authUser>
						<authPass><xsl:value-of select="account/@authPass"/></authPass>
						<xsl:if test="administrativeRoles/@systemGroupName != '' ">
							<systemGroupName><xsl:value-of select="administrativeRoles/@systemGroupName"/></systemGroupName>
						</xsl:if>
						<xsl:if test="administrativeRoles/@appLoginRole != '' ">
							<appLoginRole><xsl:value-of select="administrativeRoles/@appLoginRole"/></appLoginRole>
						</xsl:if>
						<xsl:if test="administrativeRoles/@mailAttrName != ''">
						<mailNameAttrName><xsl:value-of select="administrativeRoles/@mailAttrName"/></mailNameAttrName>
						</xsl:if>	
						<xsl:if test="administrativeRoles/@userNameAttrName != ''">
							<userNameAttrName><xsl:value-of select="administrativeRoles/@userNameAttrName"/></userNameAttrName>
						</xsl:if>		
						<xsl:if test="administrativeRoles/@groupRegexFilter != ''">
						<groupRegexFilter><xsl:value-of select="administrativeRoles/@groupRegexFilter"/></groupRegexFilter>
						</xsl:if>
						<debug><xsl:value-of select="administrativeRoles/@debug"/></debug>
						<pageSize><xsl:value-of select="administrativeRoles/@pageSize"/></pageSize>		
						<groupResolvers>
						<xsl:choose>
							<xsl:when test="groupResolvers/@resolverType='RdmMemberAttributeResolver'">
								<groupResolver class="com.ataccama.rdm.manager.config.ldap.RdmMemberAttributeResolver">
									<attribute><xsl:value-of select="groupResolvers/RdmMemberAttributeResolver/@attribute"/></attribute>
								</groupResolver>
							</xsl:when>
							<xsl:when test="groupResolvers/@resolverType='RdmGroupByMemberResolver'">
								<groupResolver class="com.ataccama.rdm.manager.config.ldap.RdmGroupByMemberResolver">
									<attribute><xsl:value-of select="groupResolvers/RdmGroupByMemberResolver/@attribute"/></attribute>
									<basePath><xsl:value-of select="groupResolvers/RdmGroupByMemberResolver/@basePath"/></basePath>
								</groupResolver>
							</xsl:when>
						</xsl:choose>
						</groupResolvers>
					</usersProvider>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<usersProvider class="com.ataccama.rdm.manager.config.RdmCombinedUsersProviderConfig">
					<providers>	
						<xsl:for-each select="security/LDAPRepositories/LDAPRepository">
							<provider class="com.ataccama.rdm.manager.config.RdmLdapUsersProviderConfig">
								<xsl:choose>
								<xsl:when test="connection/@port!=''">
									<urls>
										<url><xsl:text>ldap://</xsl:text><xsl:value-of select="connection/@host"/><xsl:text>:</xsl:text><xsl:value-of select="connection/@port"/></url>
									</urls>
								</xsl:when>
								<xsl:otherwise>
									<urls>
										<url><xsl:text>ldap://</xsl:text><xsl:value-of select="connection/@host"/></url>
									</urls>
								</xsl:otherwise>
								</xsl:choose>
								<basePath><xsl:value-of select="connection/@basePath"/></basePath>
								<userQuery><xsl:value-of select="connection/@userQuery"/></userQuery>
								<authType><xsl:value-of select="account/@authType"/></authType>
								<authUser><xsl:value-of select="account/@authUser"/></authUser>
								<authPass><xsl:value-of select="account/@authPass"/></authPass>
								<xsl:if test="administrativeRoles/@systemGroupName != '' ">
									<systemGroupName><xsl:value-of select="administrativeRoles/@systemGroupName"/></systemGroupName>
								</xsl:if>
								<xsl:if test="administrativeRoles/@appLoginRole != '' ">
									<appLoginRole><xsl:value-of select="administrativeRoles/@appLoginRole"/></appLoginRole>
								</xsl:if>
								<xsl:if test="administrativeRoles/@mailAttrName != ''">
								<mailNameAttrName><xsl:value-of select="administrativeRoles/@mailAttrName"/></mailNameAttrName>
								</xsl:if>	
								<xsl:if test="administrativeRoles/@userNameAttrName != ''">
									<userNameAttrName><xsl:value-of select="administrativeRoles/@userNameAttrName"/></userNameAttrName>
								</xsl:if>		
								<xsl:if test="administrativeRoles/@groupRegexFilter != ''">
								<groupRegexFilter><xsl:value-of select="administrativeRoles/@groupRegexFilter"/></groupRegexFilter>
								</xsl:if>
								<debug><xsl:value-of select="administrativeRoles/@debug"/></debug>
								<pageSize><xsl:value-of select="administrativeRoles/@pageSize"/></pageSize>		
								<groupResolvers>
								<xsl:choose>
									<xsl:when test="groupResolvers/@resolverType='RdmMemberAttributeResolver'">
										<groupResolver class="com.ataccama.rdm.manager.config.ldap.RdmMemberAttributeResolver">
											<attribute><xsl:value-of select="groupResolvers/RdmMemberAttributeResolver/@attribute"/></attribute>
										</groupResolver>
									</xsl:when>
									<xsl:when test="groupResolvers/@resolverType='RdmGroupByMemberResolver'">
										<groupResolver class="com.ataccama.rdm.manager.config.ldap.RdmGroupByMemberResolver">
											<attribute><xsl:value-of select="groupResolvers/RdmGroupByMemberResolver/@attribute"/></attribute>
											<basePath><xsl:value-of select="groupResolvers/RdmGroupByMemberResolver/@basePath"/></basePath>
										</groupResolver>
									</xsl:when>
								</xsl:choose>
								</groupResolvers>
							</provider>
						</xsl:for-each>	
					</providers>
				</usersProvider>	
			</xsl:otherwise>
		</xsl:choose>
	</xsl:if>
	
	<xsl:if test="security/@userRepository ='Federated repository'">
	<usersProvider class="com.ataccama.rdm.manager.config.RdmCombinedUsersProviderConfig">
	<providers>	
		<xsl:for-each select="security/LDAPRepositories/LDAPRepository">
		<provider class="com.ataccama.rdm.manager.config.RdmLdapUsersProviderConfig">
			<xsl:choose>
			<xsl:when test="connection/@port!=''">
				<urls>
					<url><xsl:text>ldap://</xsl:text><xsl:value-of select="connection/@host"/><xsl:text>:</xsl:text><xsl:value-of select="connection/@port"/></url>
				</urls>
			</xsl:when>
			<xsl:otherwise>
				<urls>
					<url><xsl:text>ldap://</xsl:text><xsl:value-of select="connection/@host"/></url>
				</urls>
			</xsl:otherwise>
			</xsl:choose>
			<basePath><xsl:value-of select="connection/@basePath"/></basePath>
			<userQuery><xsl:value-of select="connection/@userQuery"/></userQuery>
			<authType><xsl:value-of select="account/@authType"/></authType>
			<authUser><xsl:value-of select="account/@authUser"/></authUser>
			<authPass><xsl:value-of select="account/@authPass"/></authPass>
			<xsl:if test="administrativeRoles/@systemGroupName != '' ">
				<systemGroupName><xsl:value-of select="administrativeRoles/@systemGroupName"/></systemGroupName>
			</xsl:if>
			<xsl:if test="administrativeRoles/@appLoginRole != '' ">
				<appLoginRole><xsl:value-of select="administrativeRoles/@appLoginRole"/></appLoginRole>
			</xsl:if>
			<xsl:if test="administrativeRoles/@mailAttrName != ''">
			<mailNameAttrName><xsl:value-of select="administrativeRoles/@mailAttrName"/></mailNameAttrName>
			</xsl:if>	
			<xsl:if test="administrativeRoles/@userNameAttrName != ''">
				<userNameAttrName><xsl:value-of select="administrativeRoles/@userNameAttrName"/></userNameAttrName>
			</xsl:if>		
			<xsl:if test="administrativeRoles/@groupRegexFilter != ''">
			<groupRegexFilter><xsl:value-of select="administrativeRoles/@groupRegexFilter"/></groupRegexFilter>
			</xsl:if>
			<debug><xsl:value-of select="administrativeRoles/@debug"/></debug>
			<pageSize><xsl:value-of select="administrativeRoles/@pageSize"/></pageSize>		
			<groupResolvers>
			<xsl:choose>
				<xsl:when test="groupResolvers/@resolverType='RdmMemberAttributeResolver'">
					<groupResolver class="com.ataccama.rdm.manager.config.ldap.RdmMemberAttributeResolver">
						<attribute><xsl:value-of select="groupResolvers/RdmMemberAttributeResolver/@attribute"/></attribute>
					</groupResolver>
				</xsl:when>
				<xsl:when test="groupResolvers/@resolverType='RdmGroupByMemberResolver'">
					<groupResolver class="com.ataccama.rdm.manager.config.ldap.RdmGroupByMemberResolver">
						<attribute><xsl:value-of select="groupResolvers/RdmGroupByMemberResolver/@attribute"/></attribute>
						<basePath><xsl:value-of select="groupResolvers/RdmGroupByMemberResolver/@basePath"/></basePath>
					</groupResolver>
				</xsl:when>
			</xsl:choose>
			</groupResolvers>
		</provider>
		</xsl:for-each>

		<provider class="com.ataccama.rdm.manager.config.RdmXmlFileUsersRolesProviderConfig">
			<users>
				<xsl:for-each select="security/fileRepository/users/user">
					<user name="{@name}" email="{@email}" system="{@permissionsAdministrator}"/>
				</xsl:for-each>
			</users>
			<userRoles>
			<xsl:for-each select="security/fileRepository/roles/role">
				<xsl:variable name="roleName" select="@name"/>
				<xsl:for-each select="userRoles/userRole">
				<userRole rolename="{$roleName}" username="{@user}"/>
				</xsl:for-each>
			</xsl:for-each>
			</userRoles>
		</provider>
	
	</providers>
	</usersProvider>
	</xsl:if>
		
	<xsl:if test="security/@userRepository ='File repository with fixed permissions'">
	<usersProvider class="com.ataccama.rdm.manager.config.RdmXmlFileUsersRolesProviderConfig">
		<users>
			<xsl:for-each select="security/fileRepository/users/user">
				<user name="{@name}" email="{@email}" system="{@permissionsAdministrator}"/>
			</xsl:for-each>
		</users>
		<userRoles>
		<xsl:for-each select="security/fileRepository/roles/role">
			<xsl:variable name="roleName" select="@name"/>
			<xsl:for-each select="userRoles/userRole">
			<userRole rolename="{$roleName}" username="{@user}"/>
			</xsl:for-each>
		</xsl:for-each>		
		</userRoles>
	</usersProvider>
	<rolesDefinitionsProvider class="com.ataccama.rdm.manager.config.security.RdmRolesProviderBean">
		<roles>
		<xsl:for-each select="security/fileRepository/roles/role">
			<role name="{@name}">
				<entities>
				<xsl:for-each select="roleEntities/roleTables/roleTable">
				<xsl:if test="@view='true'">
					<entity name="{@name}" delete="" type="V" create="">
						<columns>
						<xsl:choose>
							<xsl:when test="@allColumnsView='true'">
								<xsl:for-each select="$logicalModel/tables/table[@name=current()/@name]/columns/column">
									<column name="{@name}"/>
								</xsl:for-each>
							</xsl:when>
							<xsl:otherwise>
								<xsl:for-each select="roleTableColumns/roleTableColumn">
								<xsl:if test="@view='true'">
									<column name="{@name}"/>
								</xsl:if>
								</xsl:for-each>
							</xsl:otherwise>
						</xsl:choose>
						</columns>
						<xsl:if test="viewRowsFilter !=''">
							<sqlRestriction><xsl:value-of select="viewRowsFilter"/>
							</sqlRestriction>
						</xsl:if>
					</entity>
				</xsl:if>
				<xsl:if test="@modify='true'">
					<entity name="{@name}" delete="{@delete}" type="E" create="{@create}">
						<columns>
						<xsl:choose>
							<xsl:when test="@allColumnsModify='true'">
								<xsl:for-each select="$logicalModel/tables/table[@name=current()/@name]/columns/column">
									<column name="{@name}"/>
								</xsl:for-each>
							</xsl:when>
							<xsl:otherwise>
								<xsl:for-each select="roleTableColumns/roleTableColumn">
								<xsl:if test="@modify='true'">
									<column name="{@name}"/>
								</xsl:if>
								</xsl:for-each>
							</xsl:otherwise>
						</xsl:choose>
						</columns>
						<xsl:if test="editRowsFilter !=''">
							<sqlRestriction><xsl:value-of select="editRowsFilter"/>
							</sqlRestriction>
						</xsl:if>
					</entity>
				</xsl:if>
				<xsl:if test="@publish='true'">
					<entity name="{@name}" delete="" type="C" create="">
						<xsl:if test="publishRowsFilter !=''">
							<sqlRestriction><xsl:value-of select="publishRowsFilter"/>
							</sqlRestriction>
						</xsl:if>
					</entity>
				</xsl:if>
				</xsl:for-each>
				<xsl:for-each select="roleEntities/roleViews/roleView">
				<xsl:if test="$logicalModel/views/view[@nameView=current()/@name]/@enable='true'">
					<xsl:if test="@view='true'">
						<entity name="{@name}" delete="" type="V" create="">
							<columns>
							<xsl:choose>
								<xsl:when test="@allColumnsView='true'">
									<xsl:for-each select="$logicalModel/views/view[@nameView=current()/@name]/viewColumns/viewColumn">
										<column name="{@alias}"/>
									</xsl:for-each>
									<xsl:for-each select="$logicalModel/views/view[@nameView=current()/@name]//viewParentTables/viewParentTable/viewColumns/viewColumn">
										<column name="{@alias}"/>
									</xsl:for-each>
								</xsl:when>
								<xsl:otherwise>
									<xsl:for-each select="roleViewColumns/roleViewColumn">
									<xsl:if test="@view='true'">
										<column name="{@name}"/>
									</xsl:if>
									</xsl:for-each>
								</xsl:otherwise>
							</xsl:choose>
							</columns>
							<xsl:if test="viewRowsFilter !=''">
								<sqlRestriction><xsl:value-of select="viewRowsFilter"/>
								</sqlRestriction>
							</xsl:if>
						</entity>
					</xsl:if>
					<xsl:if test="@modify='true'">
						<entity name="{@name}" delete="{@delete}" type="E" create="{@create}">
							<columns>
							<xsl:choose>
								<xsl:when test="@allColumnsModify='true'">
									<xsl:for-each select="$logicalModel/views/view[@nameView=current()/@name]/viewColumns/viewColumn">
										<column name="{@alias}"/>
									</xsl:for-each>
									<xsl:for-each select="$logicalModel/views/view[@nameView=current()/@name]//viewParentTables/viewParentTable/viewColumns/viewColumn">
										<column name="{@alias}"/>
									</xsl:for-each>
								</xsl:when>
								<xsl:otherwise>
									<xsl:for-each select="roleViewColumns/roleViewColumn">
									<xsl:if test="@modify='true'">
										<column name="{@name}"/>
									</xsl:if>
									</xsl:for-each>
								</xsl:otherwise>
							</xsl:choose>
							</columns>
							<xsl:if test="editRowsFilter !=''">
								<sqlRestriction><xsl:value-of select="editRowsFilter"/>
								</sqlRestriction>
							</xsl:if>
						</entity>
					</xsl:if>
					<xsl:if test="@publish='true'">
						<entity name="{@name}" delete="" type="C" create="">
							<xsl:if test="publishRowsFilter !=''">
								<sqlRestriction><xsl:value-of select="publishRowsFilter"/>
								</sqlRestriction>
							</xsl:if>
						</entity>
					</xsl:if>
				</xsl:if>
				</xsl:for-each>
				<xsl:for-each select="roleEntities/roleDatasets/roleDataset">
				<xsl:if test="$logicalModel/datsets/dataset[@name=current()/@name]/@enable='true'">
					<xsl:if test="@view='true'">
						<entity name="{@name}" delete="" type="V" create="">
							<columns>
							<xsl:choose>
								<xsl:when test="@allColumnsView='true'">
									<xsl:for-each select="$logicalModel/datasets/dataset[@name=current()/@name]/columns/datasetColumn">
										<column name="{@name}"/>
									</xsl:for-each>
								</xsl:when>
								<xsl:otherwise>
									<xsl:for-each select="roleDatasetColumns/roleDatasetColumn">
									<xsl:if test="@view='true'">
										<column name="{@name}"/>
									</xsl:if>
									</xsl:for-each>
								</xsl:otherwise>
							</xsl:choose>
							</columns>
							<xsl:if test="viewRowsFilter !=''">
								<sqlRestriction><xsl:value-of select="viewRowsFilter"/>
								</sqlRestriction>
							</xsl:if>
						</entity>
					</xsl:if>
				</xsl:if>
				</xsl:for-each>
				</entities>
			</role>
		</xsl:for-each>
		</roles>
	</rolesDefinitionsProvider>
	</xsl:if>
		
</users-config>

</xsl:template>

</xsl:stylesheet>