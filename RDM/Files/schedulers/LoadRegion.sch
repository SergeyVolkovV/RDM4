<?xml version='1.0' encoding='UTF-8'?>
<scheduleDefinition>
	<description>LoadRegion</description>
	<enabled>true</enabled>
	<job class="com.ataccama.adt.scheduler.job.WorkflowJob">
		<workflow>RDM:LRW.ewf</workflow>
	</job>
	<scheduling>1 * * *</scheduling>
</scheduleDefinition>