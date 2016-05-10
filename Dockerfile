# Base image and maintainer details
# Base image and maintainer details
FROM yugeshdocker1/postgres94wildfly9
MAINTAINER Enterprise AppsMaker mastercraft@tcs.com
USER root
# Copy config files
COPY Deployment/InitW1/TestInstallation/appserver/standalone-full.xml /opt/wildfly-9.0.1.Final/standalone/configuration
COPY Deployment/InitW1/TestInstallation/scripts/startservers.sh /home
# Copy runtime libraries
COPY Deployment/InitW1/TestInstallation/database/org /opt/wildfly-9.0.1.Final/modules/system/layers/base/org
# Create volumes
VOLUME /var/lib/postgresql/9.4/main
VOLUME /etc/postgresql/9.4/main
# Create necessary directories and set permissions
ADD Deployment/InitW1/TestInstallation/runtimeconfig/ConfigDir /home/ConfigDir
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