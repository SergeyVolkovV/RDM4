<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
 <xsl:output method="xml" encoding="UTF-8" indent="yes"/>

<xsl:output method='xml' indent='yes' />


<xsl:template match="/*">
<workflow>
	<xsl:if test="wfConfig/summaryNotifs/@maxMessagePerSession != ''">
		<confirmSummaryMailRef><xsl:value-of select="wfConfig/summaryNotifs/@confirmSummaryMailRef"/></confirmSummaryMailRef>
		<genericSummaryMailRef><xsl:value-of select="wfConfig/summaryNotifs/@genericSummaryMailRef"/></genericSummaryMailRef>
		<rejectSummaryMailRef><xsl:value-of select="wfConfig/summaryNotifs/@rejectSummaryMailRef"/></rejectSummaryMailRef>		
		<moveSummaryMailRef><xsl:value-of select="wfConfig/summaryNotifs/@moveSummaryMailRef"/></moveSummaryMailRef>
		<maxMessagesPerSession><xsl:value-of select="wfConfig/summaryNotifs/@maxMessagePerSession"/></maxMessagesPerSession>
	</xsl:if>

	<entities>
		<xsl:for-each select="wfConfig/entities/entity">
			<entity name="{@name}">			
				<xsl:variable name="entityName"><xsl:value-of select="@name"/></xsl:variable>

		<editActions>
			<xsl:if test="confirmationNotifications/createNotification/emailCreateNotification/createRoles/createRole/@role != '' or publishNotifications/createNotification/emailCreateNotification/createRoles/createRole/@role != '' or rejectNotifications/createNotification/emailCreateNotification/createRoles/createRole/@role != '' or workflows/workflow/@editOperation = 'Create'">
			<editAction type="new">
		    	
		    	<waitingForConfirmNotifications>
		    		<xsl:if test="confirmationNotifications/createNotification/emailCreateNotification/createRoles/createRole/@role != ''">
		    		<xsl:for-each select="confirmationNotifications/createNotification/emailCreateNotification">
		    			<notification newEmailRef="{@email}">
							<users>
								<roles>
                    			<xsl:for-each select="createRoles/createRole">
                    				<role><xsl:value-of select="@role"/></role>
                    			</xsl:for-each>
                   				</roles>
                   			</users>
                		</notification>
                	</xsl:for-each>
                	</xsl:if>
                </waitingForConfirmNotifications>
		    	
		    	<publishedNotifications>
		    		<xsl:if test="publishNotifications/createNotification/emailCreateNotification/createRoles/createRole/@role != ''">
		    		<xsl:for-each select="publishNotifications/createNotification/emailCreateNotification">
		    			<notification newEmailRef="{@email}">
							<users>
								<roles>
                    			<xsl:for-each select="createRoles/createRole">
                    				<role><xsl:value-of select="@role"/></role>
                    			</xsl:for-each>
                   				</roles>
                   			</users>
                		</notification>
                	</xsl:for-each>
                	</xsl:if>
                </publishedNotifications>
                
                <rejectedNotifications>
		    		<xsl:if test="rejectNotifications/createNotification/emailCreateNotification/createRoles/createRole/@role != ''">
		    		<xsl:for-each select="rejectNotifications/createNotification/emailCreateNotification">
		    			<notification newEmailRef="{@email}">
							<users>
								<roles>
                    			<xsl:for-each select="createRoles/createRole">
                    				<role><xsl:value-of select="@role"/></role>
                    			</xsl:for-each>
                   				</roles>
                   			</users>
                		</notification>
                	</xsl:for-each>
                	</xsl:if>
                </rejectedNotifications>
           		
           		<statementSteps>
           			
					<xsl:for-each select="workflows/workflow[@editOperation = 'Create']/steps/step">
						<xsl:if test="not(position()=1 or position()=last())">
							<statementStep>
								<xsl:attribute name="name">
									<xsl:value-of select="ancestor::metadata/wfConfig/statuses/status[@id=current()/@id]/@label"/>
								</xsl:attribute>								  
									<xsl:if test="condition !=''">
										<xsl:attribute name="condition">
											<xsl:value-of select="condition"/>
										</xsl:attribute>
									</xsl:if>								
								<xsl:if test="@expiresAfterDays !=''">
								<xsl:attribute name="expiresAfterDays">
									<xsl:value-of select="@expiresAfterDays"/>
								</xsl:attribute>
								</xsl:if>
								
								<xsl:if test="emailNotifications/emailNotification/@emailNotification !=''">
								<xsl:for-each select="emailNotifications/emailNotification">
								<finishEmails>
									<xsl:attribute name="emailRef">
										<xsl:value-of select="@emailNotification"/>
									</xsl:attribute>
									<users>
										<roles>
											<xsl:for-each select="roles/role">
											<role><xsl:value-of select="@name"/></role>
											</xsl:for-each>
										</roles>
									</users>
								</finishEmails>
								</xsl:for-each>
								</xsl:if>
								
								<xsl:if test="rejectEmailNotifications/rejectEmailNotification/@emailNotification !=''">
								<xsl:for-each select="rejectEmailNotifications/rejectEmailNotification">
								<rejectEmails>
									<xsl:attribute name="emailRef">
										<xsl:value-of select="@emailNotification"/>
									</xsl:attribute>
									<users>
										<roles>
											<xsl:for-each select="roles/role">
											<role><xsl:value-of select="@name"/></role>
											</xsl:for-each>
										</roles>
									</users>
								</rejectEmails>
								</xsl:for-each>
								</xsl:if>
								
								<columns>
									<xsl:for-each select="columns/column">
										<column>
											<xsl:attribute name="name">
												<xsl:value-of select="@name"/>
											</xsl:attribute>
										</column>
									</xsl:for-each>
								</columns>
								
								<statements>
									<xsl:for-each select="statements/statement">
									<statement>
									<xsl:if test="condition !=''">
										<xsl:attribute name="condition">
											<xsl:value-of select="condition"/>
										</xsl:attribute>
									</xsl:if>	
										<users>
										<xsl:if test="@emailNotification !=''">
						        			<xsl:attribute name="emailRef">
												<xsl:value-of select="@emailNotification"/>
											</xsl:attribute>
						        		</xsl:if>
											<users>
												<roles>
													<xsl:for-each select="roles/role">
													<role><xsl:value-of select="@name"/></role>
													</xsl:for-each>
												</roles>
											</users>
										</users>
									</statement>
									</xsl:for-each>
								</statements>
								
							</statementStep>
						</xsl:if>
					</xsl:for-each>
					
					
				</statementSteps>
			</editAction>
			</xsl:if>
			
			
			<xsl:if test="confirmationNotifications/updateNotification/emailUpdateNotification/updateRoles/updateRole/@role !='' or publishNotifications/updateNotification/emailUpdateNotification/updateRoles/updateRole/@role !='' or rejectNotifications/createNotification/emailCreateNotification/createRoles/createRole/@role != '' or workflows/workflow/@editOperation = 'Update'">
			<editAction type="edit">
		    	
		    	<waitingForConfirmNotifications>
		    	<xsl:if test="confirmationNotifications/updateNotification/emailUpdateNotification/updateRoles/updateRole/@role !=''">
		    	<xsl:for-each select="confirmationNotifications/updateNotification/emailUpdateNotification">
		    	<notification editedEmailRef="{@email}">
					<users>
					<roles>
                    	<xsl:for-each select="updateRoles/updateRole">
                    	<role><xsl:value-of select="@role"/></role>
                    	</xsl:for-each>
                   	</roles>
                   	</users>
                </notification>
                </xsl:for-each>
                </xsl:if>
                </waitingForConfirmNotifications>
		    	
		    	<publishedNotifications>
		    	<xsl:if test="publishNotifications/updateNotification/emailUpdateNotification/updateRoles/updateRole/@role !=''">
		    	<xsl:for-each select="publishNotifications/updateNotification/emailUpdateNotification">
		    	<notification editedEmailRef="{@email}">
					<users>
					<roles>
                    	<xsl:for-each select="updateRoles/updateRole">
                    	<role><xsl:value-of select="@role"/></role>
                    	</xsl:for-each>
                   	</roles>
                   	</users>
                </notification>
                </xsl:for-each>
                </xsl:if>
                </publishedNotifications>
           		
           		<rejectedNotifications>
		    	<xsl:if test="rejectNotifications/updateNotification/emailUpdateNotification/updateRoles/updateRole/@role !=''">
		    	<xsl:for-each select="rejectNotifications/updateNotification/emailUpdateNotification">
		    	<notification editedEmailRef="{@email}">
					<users>
					<roles>
                    	<xsl:for-each select="updateRoles/updateRole">
                    	<role><xsl:value-of select="@role"/></role>
                    	</xsl:for-each>
                   	</roles>
                   	</users>
                </notification>
                </xsl:for-each>
                </xsl:if>
                </rejectedNotifications>
				
				<statementSteps>
					
					<xsl:for-each select="workflows/workflow[@editOperation = 'Update']/steps/step">
						<xsl:if test="not(position()=1 or position()=last())">
							<statementStep>
								<xsl:attribute name="name">
									<xsl:value-of select="ancestor::metadata/wfConfig/statuses/status[@id=current()/@id]/@label"/>
								</xsl:attribute>
									<xsl:if test="condition !=''">
										<xsl:attribute name="condition">
											<xsl:value-of select="condition"/>
										</xsl:attribute>
									</xsl:if>
								<xsl:if test="@expiresAfterDays !=''">
								<xsl:attribute name="expiresAfterDays">
									<xsl:value-of select="@expiresAfterDays"/>
								</xsl:attribute>
								</xsl:if>
								
								<xsl:if test="emailNotifications/emailNotification/@emailNotification !=''">
								<xsl:for-each select="emailNotifications/emailNotification">
								<finishEmails>
									<xsl:attribute name="emailRef">
										<xsl:value-of select="@emailNotification"/>
									</xsl:attribute>
									<users>
										<roles>
											<xsl:for-each select="roles/role">
											<role><xsl:value-of select="@name"/></role>
											</xsl:for-each>
										</roles>
									</users>
								</finishEmails>
								</xsl:for-each>
								</xsl:if>
								
								<xsl:if test="rejectEmailNotifications/rejectEmailNotification/@emailNotification !=''">
								<xsl:for-each select="rejectEmailNotifications/rejectEmailNotification">
								<rejectEmails>
									<xsl:attribute name="emailRef">
										<xsl:value-of select="@emailNotification"/>
									</xsl:attribute>
									<users>
										<roles>
											<xsl:for-each select="roles/role">
											<role><xsl:value-of select="@name"/></role>
											</xsl:for-each>
										</roles>
									</users>
								</rejectEmails>
								</xsl:for-each>
								</xsl:if>
								
								<columns>
									<xsl:for-each select="columns/column">
										<column>
											<xsl:attribute name="name">
												<xsl:value-of select="@name"/>
											</xsl:attribute>
										</column>
									</xsl:for-each>
								</columns>
								
								<statements>
									<xsl:for-each select="statements/statement">
									<statement>
									<xsl:if test="condition !=''">
										<xsl:attribute name="condition">
											<xsl:value-of select="condition"/>
										</xsl:attribute>
									</xsl:if>	
										<users>
										<xsl:if test="@emailNotification !=''">
						        			<xsl:attribute name="emailRef">
												<xsl:value-of select="@emailNotification"/>
											</xsl:attribute>
						        		</xsl:if>
											<users>
												<roles>
													<xsl:for-each select="roles/role">
													<role><xsl:value-of select="@name"/></role>
													</xsl:for-each>
												</roles>
											</users>
										</users>
									</statement>
									</xsl:for-each>
								</statements>
							</statementStep>
						</xsl:if>
					</xsl:for-each>
				</statementSteps>
			</editAction>
			</xsl:if>
			
			<xsl:if test="confirmationNotifications/deleteNotification/emailDeleteNotification/deleteRoles/deleteRole/@role !='' or publishNotifications/deleteNotification/emailDeleteNotification/deleteRoles/deleteRole/@role !='' or rejectNotifications/createNotification/emailCreateNotification/createRoles/createRole/@role != '' or workflows/workflow/@editOperation = 'Delete'">
			<editAction type="delete">
		    	
		    	<waitingForConfirmNotifications>
		    	<xsl:if test="confirmationNotifications/deleteNotification/emailDeleteNotification/deleteRoles/deleteRole/@role !=''">
		    	<xsl:for-each select="confirmationNotifications/deleteNotification/emailDeleteNotification">
		    	<notification deletedEmailRef="{@email}"> 
					<users>
					<roles>
                    	<xsl:for-each select="deleteRoles/deleteRole">
                    	<role><xsl:value-of select="@role"/></role>
                    	</xsl:for-each>
                   	</roles>
                   	</users>
                </notification>
                </xsl:for-each>
                </xsl:if>
                </waitingForConfirmNotifications>
		    	
		    	<publishedNotifications>
		    	<xsl:if test="publishNotifications/deleteNotification/emailDeleteNotification/deleteRoles/deleteRole/@role !=''">
		    	<xsl:for-each select="publishNotifications/deleteNotification/emailDeleteNotification">
		    	<notification deletedEmailRef="{@email}"> 
					<users>
					<roles>
                    	<xsl:for-each select="deleteRoles/deleteRole">
                    	<role><xsl:value-of select="@role"/></role>
                    	</xsl:for-each>
                   	</roles>
                   	</users>
                </notification>
                </xsl:for-each>
                </xsl:if>
                </publishedNotifications>
                
                <rejectedNotifications>
		    	<xsl:if test="rejectNotifications/deleteNotification/emailDeleteNotification/deleteRoles/deleteRole/@role !=''">
		    	<xsl:for-each select="rejectNotifications/deleteNotification/emailDeleteNotification">
		    	<notification deletedEmailRef="{@email}"> 
					<users>
					<roles>
                    	<xsl:for-each select="deleteRoles/deleteRole">
                    	<role><xsl:value-of select="@role"/></role>
                    	</xsl:for-each>
                   	</roles>
                   	</users>
                </notification>
                </xsl:for-each>
                </xsl:if>
                </rejectedNotifications>
           		
				<statementSteps>
					<xsl:for-each select="workflows/workflow[@editOperation = 'Delete']/steps/step">
						<xsl:if test="not(position()=1 or position()=last())">
							<statementStep>
								<xsl:attribute name="name">
									<xsl:value-of select="ancestor::metadata/wfConfig/statuses/status[@id=current()/@id]/@label"/>
								</xsl:attribute>
									<xsl:if test="condition !=''">
										<xsl:attribute name="condition">
											<xsl:value-of select="condition"/>
										</xsl:attribute>
									</xsl:if>
								<xsl:if test="@expiresAfterDays !=''">
								<xsl:attribute name="expiresAfterDays">
									<xsl:value-of select="@expiresAfterDays"/>
								</xsl:attribute>
								</xsl:if>
								
								<xsl:if test="emailNotifications/emailNotification/@emailNotification !=''">
								<xsl:for-each select="emailNotifications/emailNotification">
								<finishEmails>
									<xsl:attribute name="emailRef">
										<xsl:value-of select="@emailNotification"/>
									</xsl:attribute>
									<users>
										<roles>
											<xsl:for-each select="roles/role">
											<role><xsl:value-of select="@name"/></role>
											</xsl:for-each>
										</roles>
									</users>
								</finishEmails>
								</xsl:for-each>
								</xsl:if>
								
								<xsl:if test="rejectEmailNotifications/rejectEmailNotification/@emailNotification !=''">
								<xsl:for-each select="rejectEmailNotifications/rejectEmailNotification">
								<rejectEmails>
									<xsl:attribute name="emailRef">
										<xsl:value-of select="@emailNotification"/>
									</xsl:attribute>
									<users>
										<roles>
											<xsl:for-each select="roles/role">
											<role><xsl:value-of select="@name"/></role>
											</xsl:for-each>
										</roles>
									</users>
								</rejectEmails>
								</xsl:for-each>
								</xsl:if>
								
								<columns>
									<xsl:for-each select="columns/column">
										<column>
											<xsl:attribute name="name">
												<xsl:value-of select="@name"/>
											</xsl:attribute>
										</column>
									</xsl:for-each>
								</columns>
								
								<statements>
									<xsl:for-each select="statements/statement">
									<statement>
									<xsl:if test="condition !=''">
										<xsl:attribute name="condition">
											<xsl:value-of select="condition"/>
										</xsl:attribute>
									</xsl:if>	
										<users>
										<xsl:if test="@emailNotification !=''">
						        			<xsl:attribute name="emailRef">
												<xsl:value-of select="@emailNotification"/>
											</xsl:attribute>
						        		</xsl:if>
											<users>
												<roles>
													<xsl:for-each select="roles/role">
													<role><xsl:value-of select="@name"/></role>
													</xsl:for-each>
												</roles>
											</users>
										</users>
									</statement>
									</xsl:for-each>
								</statements>
							</statementStep>
						</xsl:if>
					</xsl:for-each>
				</statementSteps>
			</editAction>
			</xsl:if>

		</editActions>
	</entity> 
	</xsl:for-each>
	</entities>

	
	<emails fromAddress="{appVariables/@returnEmailAddress}">
	<emails>
		<xsl:for-each select="wfConfig/emails/email">
	    	<email subject="{@subject}" name="{@name}">
	    		<template> 
					<xsl:value-of select="current()/@message"/>
					<xsl:value-of select="current()/message"/>
				</template>
			</email>
		</xsl:for-each>
	</emails>
	</emails>

	
</workflow>
</xsl:template>


<xsl:template match="role">
	 <role><xsl:value-of select="@name"/></role>
</xsl:template>
</xsl:stylesheet>