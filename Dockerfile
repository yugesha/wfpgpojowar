# Base image and maintainer details
FROM jboss/wildfly:9.0.1.Final
MAINTAINER Enterprise AppsMaker mastercraft@tcs.com
USER root
# Copy config files
COPY Deployment/InitW1/TestInstallation/appserver/standalone-full.xml /opt/jboss/wildfly/standalone/configuration
COPY Deployment/InitW1/TestInstallation/scripts/startservers.sh /home
# Copy runtime libraries
COPY Deployment/InitW1/TestInstallation/database/org /opt/jboss/wildfly/modules/system/layers/base/org
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
# Specify container startup command
CMD /home/startservers.sh