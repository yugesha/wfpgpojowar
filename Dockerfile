# Base image and maintainer details
FROM tcseamdocker/wildfly-9.0.1.final
MAINTAINER Enterprise AppsMaker masterCraft.support@tcs.com
USER root
# Copy config files
COPY Deployment/InitW1/TestInstallation/appserver/standalone-full.xml /opt/jboss/wildfly/standalone/configuration
COPY Deployment/InitW1/TestInstallation/scripts/startservers.sh /home
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