scp -i /home/gziegan/.ssh/guillermo.pem root@54.82.96.71:/var/backup/postgresql/eviction_tracker.sql.gz .
gzip -d eviction_tracker.sql.gz
psql -U postgres -c 'drop database eviction_tracker'
psql -U postgres -c 'create database eviction_tracker'
psql -U postgres eviction_tracker < eviction_tracker.sql
