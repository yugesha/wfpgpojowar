FROM yugeshdocker1/postgres94wildfly9
MAINTAINER Yugesh yugesh.a@tcs.com;
# Ensure that web.xml points to /home/ConfigDir
# Ensure log4j.xml refers to logfile in /home/logs/EAMLog.log
# Ensure that rtConf.properties:temp directory points to /tmp/MasterCraftFileManager
# Ensure that all artifacts are available in current directory
# Ensure that postgres server postgres user has password (re)set ALTER USER postgres WITH password "postgres"
USER root
# Copy artifacts from EAM env into server

# Copy ear into /opt/wildfly-9.0.1.Final/standalone/deployments
COPY DeploymentSetup/car-service.war /opt/wildfly-9.0.1.Final/standalone/deployments
# Backup the standalone.xml files and copy generated ones
RUN rm -rf /opt/wildfly-9.0.1.Final/standalone/configuration/standalone.xml_backup
RUN mv /opt/wildfly-9.0.1.Final/standalone/configuration/standalone.xml /opt/wildfly-9.0.1.Final/standalone/configuration/standalone.xml_backup
RUN rm -rf /opt/wildfly-9.0.1.Final/standalone/configuration/standalone-full.xml_backup
RUN mv /opt/wildfly-9.0.1.Final/standalone/configuration/standalone-full.xml /opt/wildfly-9.0.1.Final/standalone/configuration/standalone-full.xml_backup
COPY DeploymentSetup/standalone.xml /opt/wildfly-9.0.1.Final/standalone/configuration
COPY DeploymentSetup/standalone-full.xml /opt/wildfly-9.0.1.Final/standalone/configuration
COPY DeploymentSetup/startservers.sh /home/ 
RUN chmod 555 /home/startservers.sh

# Copy module related xmls and jars into /opt/wildfly-9.0.1.Final/standalone/lib/ext
COPY DeploymentSetup/RuntimeLibs/jboss-logging-3.3.0.Final.jar /opt/wildfly-9.0.1.Final/standalone/lib/ext
COPY DeploymentSetup/RuntimeLibs/module.xml /opt/wildfly-9.0.1.Final/standalone/lib/ext
COPY DeploymentSetup/RuntimeLibs/module_ForJBossLogging.xml /opt/wildfly-9.0.1.Final/standalone/lib/ext
COPY DeploymentSetup/RuntimeLibs/postgresql-8.4-702.jdbc3.jar /opt/wildfly-9.0.1.Final/standalone/lib/ext
COPY DeploymentSetup/RuntimeLibs/postgresql-9.4-1201-jdbc4.jar /opt/wildfly-9.0.1.Final/standalone/lib/ext
COPY DeploymentSetup/RuntimeLibs/xstream-1.0.1.jar /opt/wildfly-9.0.1.Final/standalone/lib/ext
COPY DeploymentSetup/RuntimeLibs/xstream-1.2.jar /opt/wildfly-9.0.1.Final/standalone/lib/ext
ADD DeploymentSetup/postgresql /opt/wildfly-9.0.1.Final/modules/system/layers/base/org/postgresql

# Copy ConfigDir into /home
ADD DeploymentSetup/ConfigDir /home/ConfigDir
RUN chmod 777 /home/ConfigDir

# Create logs and MasterCraftFileManager directories and give 777 permissions
RUN mkdir /home/logs && chmod 777 /home/logs && mkdir /tmp/MasterCraftFileManager && chmod 777 /tmp/MasterCraftFileManager

# Create database from backup
RUN su - postgres
COPY DeploymentSetup/eam43a.backup /tmp
# RUN touch ~/.pgpass && chmod 0600 ~/.pgpass && echo "*:*:eam5app:postgres:md5f77edd461cb7b9ae3db5932148051ac8" >> ~/.pgpass && echo "*:*:postgres:postgres:md5f77edd461cb7b9ae3db5932148051ac8" >> ~/.pgpass
COPY DeploymentSetup/.pgpass ~/

RUN echo "host all  all    0.0.0.0/0  trust" >> /etc/postgresql/9.4/main/pg_hba.conf && sed -i -- 's/md5/trust/g' /etc/postgresql/9.4/main/pg_hba.conf && sed -i -- 's/peer/trust/g' /etc/postgresql/9.4/main/pg_hba.conf  && sed -i "/^#listen_addresses/i listen_addresses='*'" /etc/postgresql/9.4/main/postgresql.conf && export PGPASSWORD=p@ssw0rd && /etc/init.d/postgresql start && psql -U postgres -c "ALTER USER postgres WITH PASSWORD 'p@ssw0rd';" && /usr/lib/postgresql/9.4/bin/createdb -h localhost -p 5432 -U postgres -D pg_default --no-password -T template1 -O postgres eam5app && psql -U postgres -c "GRANT ALL ON DATABASE eam5app TO postgres;" && /usr/lib/postgresql/9.4/bin/pg_restore --host localhost --port 5432 --username "postgres" --dbname "eam5app" --no-password --verbose /tmp/eam43a.backup && sed -i -- 's/trust/md5/g' /etc/postgresql/9.4/main/pg_hba.conf && /etc/init.d/postgresql restart
#Switch back to root 
RUN exit

# Expose the ports we're interested in
EXPOSE 5432 8080 9990
 
# Set the default command to run on boot
# This will boot WildFly in the standalone mode and bind to all interface - docker run -p 9080:8080 -p 9090:9990 -p 5432:5432 wp
CMD ["/home/startservers.sh"]
