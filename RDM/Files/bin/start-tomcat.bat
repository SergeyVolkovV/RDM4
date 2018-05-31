@echo off

set CATALINA_HOME=%DQC_HOME%\..\tomcat
set JRE_HOME=%DQC_HOME%\..\jre
set JAVA_HOME=

if not exist "%DQC_HOME%\..\tomcat\webapps\rdm\WEB-INF\web.xml" (
    copy "%DQC_HOME%\..\tomcat\webapps\rdm\WEB-INF\web.template.xml" "%DQC_HOME%\..\tomcat\webapps\rdm\WEB-INF\web.xml"
)
"%DQC_HOME%\..\tomcat\bin\startup.bat"