#!/bin/sh
#  Is user specifies INSTALL_DB then create a new DB
# If user specifies DB_USER, then a user will be created
#	DB_NAME
#  DB_USER
# 	DB_PASS
# if the flag INSTALL_DB is specified and true
	# install db
export DB_SCRIPT=/etc/postgresql/9.4/main/eam43a.sql
export PGPASSFILE=/etc/postgresql/9.4/main/.pgpass && \
if ! [ -f ${PGPASSFILE} ] ; then  && \
	touch ${PGPASSFILE} && \
fi		&& \

chmod 600 ${PGPASSFILE} && \

if [ -n ${INSTALL_DB} ] ; then && \
	echo "host all  all    0.0.0.0/0  trust" >> /etc/postgresql/9.4/main/pg_hba.conf && \
	sed -i -- 's/md5/trust/g' /etc/postgresql/9.4/main/pg_hba.conf && \
	sed -i -- 's/peer/trust/g' /etc/postgresql/9.4/main/pg_hba.conf  && \
	sed -i "/^#listen_addresses/i listen_addresses='*'" /etc/postgresql/9.4/main/postgresql.conf && \
	su - postgres && \
		export PGPASSWORD=p@ssw0rd && \
		/etc/init.d/postgresql start && \
		psql -U postgres -c "ALTER USER postgres WITH PASSWORD '${PGPASSWORD}';" && \
		echo "*:*:*:postgres:${PGPASSWORD}" >> ${PGPASSFILE} && \
		if [ -n ${DB_NAME} ] ; then && \
			/usr/lib/postgresql/9.4/bin/createdb -h localhost -p 5432 -U postgres -D pg_default --no-password -T template1 -O postgres ${DB_NAME} && \
			psql -U postgres -c "GRANT ALL ON DATABASE ${DB_NAME} TO postgres;" && \
			/usr/lib/postgresql/9.4/bin/psql -U postgres  "${DB_NAME}" < "${DB_SCRIPT}"  && \
			# /usr/lib/postgresql/9.4/bin/pg_restore --host localhost --port 5432 --username "postgres" --dbname "${DB_NAME}" --no-password --verbose /tmp/eam43a.backup
		else
			psql -U postgres -c "GRANT ALL ON DATABASE postgres TO postgres;" && \
			/usr/lib/postgresql/9.4/bin/psql -U postgres  "postgres" < "${DB_SCRIPT}" && \
			# /usr/lib/postgresql/9.4/bin/pg_restore --host localhost --port 5432 --username "postgres" --dbname "postgres" --no-password --verbose /tmp/eam43a.backup
		fi 
		if 	[ -n ${DB_USER} ] ; then  && \
			if [ -n ${DB_PASS} ] ; then && \
				psql -U postgres -c "CREATE USER ${DB_USER} WITH PASSWORD '${DB_PASS}';" && \
				export PGPASSWORD=${DB_PASS} && \
			else
				psql -U postgres -c "CREATE USER ${DB_USER} WITH PASSWORD '${DB_USER}';" && \
				export PGPASSWORD=${DB_USER} && \
			fi && \
			psql -U postgres -c "GRANT ALL ON DATABASE ${DB_NAME} TO ${DB_USER};" && \
			echo "*:*:*:${DB_USER}:${DB_PASS}" >> ${PGPASSFILE} && \
		else
			psql -U postgres -c "CREATE USER ${DB_NAME} WITH PASSWORD '${DB_NAME}';" && \
			export PGPASSWORD=${DB_NAME} && \
		fi		&& \
		sed -i -- 's/trust/md5/g' /etc/postgresql/9.4/main/pg_hba.conf && \
		/etc/init.d/postgresql restart && \				
	exit && \
fi  && \
	
/opt/wildfly/bin/standalone.sh -b 0.0.0.0 -bmanagement 0.0.0.0 
	#
# start db
nohup su -c '/opt/rh/rh-postgresql94/root/usr/bin/postgres -D /var/lib/pgsql/data/data -c config_file=/var/lib/pgsql/data/data/postgresql.conf' - postgres &
# start server
nohup /opt/jboss-as-7.2.0.Final/bin/standalone.sh -Djboss.server.base.dir=IAREP -b 0.0.0.0 -c standalone.xml >/IAREP.log 2>&1 & 
nohup /opt/jboss-as-7.2.0.Final/bin/standalone.sh -Djboss.server.base.dir=IAAPP -b 0.0.0.0 -c standalone.xml >/IAAPP.log  2>&1 &
sleep 2