# Base image and maintainer details
FROM tomcat:8-jre7
MAINTAINER Enterprise AppsMaker mastercraft@tcs.com
USER root
# Copy config files
COPY Deployment/InitW1/TestInstallation/appserver/server.xml /usr/local/tomcat/conf
COPY Deployment/InitW1/TestInstallation/appserver/context.xml /usr/local/tomcat/conf
COPY Deployment/InitW1/TestInstallation/scripts/startservers.sh /home
# Copy runtime libraries
COPY Deployment/InitW1/TestInstallation/dependencies/postgresql-8.4-702.jdbc3.jar /usr/local/tomcat/lib
# Create necessary directories and set permissions
ADD Deployment/InitW1/TestInstallation/runtimeconfig/ConfigDir /home/ConfigDir
RUN chmod 555 /home/startservers.sh && \
 chmod 777 /home/ConfigDir && \
 mkdir  /home/logs && \
 chmod 777 /home/logs && \
 mkdir  /tmp/MasterCraftFileManager && \
 chmod 777 /tmp/MasterCraftFileManager
# Expose the http, database and administration ports
EXPOSE 8080 9990
