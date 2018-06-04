<?xml version='1.0' encoding='UTF-8'?>
<scheduleDefinition>
	<description>LoadRegionWorkflow</description>
	<enabled>true</enabled>
	<job class="com.ataccama.adt.scheduler.job.WorkflowJob">
		<workflow>RDM:LoadRegionWorkflow.ewf</workflow>
	</job>
	<scheduling>* * * *</scheduling>
</scheduleDefinition>