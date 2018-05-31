@echo off

set CATALINA_HOME=%DQC_HOME%\..\tomcat
set JRE_HOME=%DQC_HOME%\..\jre
set JAVA_HOME=

call "%DQC_HOME%\..\tomcat\bin\shutdown.bat"