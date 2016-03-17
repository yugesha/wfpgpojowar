#!/bin/sh

/etc/init.d/postgresql start
su - postgres && echo "host all  all    0.0.0.0/0  trust" >> /etc/postgresql/9.4/main/pg_hba.conf && sed -i -- 's/md5/trust/g' /etc/postgresql/9.4/main/pg_hba.conf && sed -i -- 's/peer/trust/g' /etc/postgresql/9.4/main/pg_hba.conf  && sed -i "/^#listen_addresses/i listen_addresses='*'" /etc/postgresql/9.4/main/postgresql.conf && export PGPASSWORD=p@ssw0rd && /etc/init.d/postgresql start && psql -U postgres -c "ALTER USER postgres WITH PASSWORD 'p@ssw0rd';" && /usr/lib/postgresql/9.4/bin/createdb -h localhost -p 5432 -U postgres -D pg_default --no-password -T template1 -O postgres eam5app && psql -U postgres -c "GRANT ALL ON DATABASE eam5app TO postgres;" && /usr/lib/postgresql/9.4/bin/pg_restore --host localhost --port 5432 --username "postgres" --dbname "eam5app" --no-password --verbose /tmp/eam43a.backup && sed -i -- 's/trust/md5/g' /etc/postgresql/9.4/main/pg_hba.conf && /etc/init.d/postgresql restart && exit
/opt/wildfly/bin/standalone.sh -b 0.0.0.0 -bmanagement 0.0.0.0 

