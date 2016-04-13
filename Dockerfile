# Base image and maintainer details
# Base image and maintainer details
FROM yugeshdocker1/postgres94wildfly9
MAINTAINER EnterpriseAppsMaker mastercraft@tcs.com
USER yugeshdocker1/postgres94wildfly9
# Copy EAM generated deployable
COPY Deployment/InitW1/TestInstallation/appserver/TestInstallation.ear /opt/wildfly-9.0.1.Final/standalone/deployments
# Copy config files
COPY Deployment/InitW1/TestInstallation/appserver/standalone.xml /opt/wildfly-9.0.1.Final/standalone/configuration
COPY Deployment/InitW1/TestInstallation/scripts/startservers.sh /home
# Copy database dump
COPY Deployment/InitW1/TestInstallation/scripts/database.sql /home
# Copy runtime libraries
COPY Deployment/InitW1/TestInstallation/database/org /opt/wildfly-9.0.1.Final/modules/system/layers/base/org
# Create volumes
VOLUME /var/lib/postgresql/9.4/main
VOLUME /etc/postgresql/9.4/main
# Create necessary directories and set permissions
ADD Deployment/InitW1/TestInstallation/runtimeconfig/ConfigDir1 /home/ConfigDir
RUN chmod 555 /home/startservers.sh && \
 chmod 777 /home/ConfigDir && \
 mkdir  /home/logs && \
 chmod 777 /home/logs && \
 mkdir  /tmp/MasterCraftFileManager && \
 chmod 777 /tmp/MasterCraftFileManager
# Expose the http, database and administration ports
EXPOSE 5432 8080 9990
# Specify container startup command
CMD /home/startservers.sh