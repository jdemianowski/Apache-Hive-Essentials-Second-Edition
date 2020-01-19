sudo /opt/cloudera/installer/uninstall-cloudera-manager.sh
sudo rm -rf /opt/cloudera/
sudo rm -rf /etc/yum.repos.d/cloudera-manager.repo*

sudo wget https://archive.cloudera.com/cm7/7.0.3/redhat7/yum/cloudera-manager-trial.repo -P /etc/yum.repos.d/
sudo rpm --import https://archive.cloudera.com/cm7/7.0.3/redhat7/yum/RPM-GPG-KEY-cloudera
sudo yum makecache
sudo yum update

wget https://archive.cloudera.com/cm7/7.0.3/cloudera-manager-installer.bin
wget https://archive.cloudera.com/cm6/6.3.2/cloudera-manager-installer.bin


chmod u+x cloudera-manager-installer.bin
sudo ./cloudera-manager-installer.bin

netstat -tulnp | grep 7180

sudo groupadd supergroup
sudo usermod -a -G supergroup mapred
sudo usermod -a -G supergroup hdfs
sudo usermod -a -G supergroup kuba
sudo -u hdfs hdfs dfs -chmod 775 /
# sudo hdfs dfs -chmod 775 /
sudo usermod -a -G supergroup hive

sudo -u hdfs hadoop fs -mkdir /user/root
sudo -u hdfs hadoop fs -mkdir /user/kuba
sudo -u hdfs hadoop fs -mkdir /user/hue
sudo -u hdfs hadoop fs -chown root /user/root
sudo -u hdfs hadoop fs -chown kuba /user/kuba
sudo -u hdfs hadoop fs -chown hue /user/hue

yarn.nodemanager.resource.memory-mb=8096
yarn.scheduler.minimum-allocation-mb: 2048
yarn.scheduler.maximum-allocation-mb: 8096
yarn.scheduler.minimum-allocation-vcores=1
yarn.scheduler.maximum-allocation-vcores=4


how to store user & pass for beeline:

# https://community.cloudera.com/t5/Support-Questions/Sqoop-stuck-What-should-I-do/td-p/229726

sudo vim /etc/hive/conf/beeline-hs2-connection.xml

<?xml version="1.0"?>
<configuration>
<property>
  <name>beeline.hs2.connection.user</name>
  <value>kuba</value>
</property>
<property>
  <name>beeline.hs2.connection.password</name>
  <value>cloudera</value>
</property>
</configuration>

yarn.scheduler.capacity.maximum-am-resource-percent = 0.8

hdfs dfs -rm -f -r  hdfs://osboxes.local:8020/user/osboxes/*

sudo yum install stress-ng -y
sudo stress-ng --cpu 4 --perf -t 60

# install sample databases
sudo yum install postgres* -y
sudo postgresql-setup initdb
sudo systemctl start postgresql
sudo systemctl enable postgresql

sudo -u postgres -i
createdb kuba -O kuba
psql
alter user kuba createdb;
ALTER USER kuba WITH SUPERUSER;
alter user kuba with password 'cloudera';
exit

psql -d template1
createdb
exit

sudo systemctl restart postgresql

git clone https://github.com/morenoh149/postgresDBSamples.git
cd postgresDBSamples/
cd adventureworks
unzip data.zip
psql -c "CREATE DATABASE \"adventureworks\";"
psql -d Adventureworks < install.sql
cd ..
cd worldDB-1.0/
psql -c "CREATE DATABASE worlddb;" < world.sql
cd ..
cd usda-r18-1.0/
createdb usda
psql -f usda.sql usda
cd ..
cd iso-3166/
createdb iso-3166
psql -f iso-3166.sql iso-3166
cd ..
cd chinook-1.4/
createdb -E UTF8 chinook
psql -f Chinook_PostgreSql_utf8.sql -d chinook

sudo vim /var/lib/pgsql/data/postgresql.conf
# add at the end of the file:
listen_addresses = '*'

sudo vim /var/lib/pgsql/data/pg_hba.conf
# add at the end of the file:
host    all             all              0.0.0.0/0                       md5
host    all             all              ::/0                            md5

sudo  systemctl restart postgresql

# check
netstat -nlt | grep 5432


# problem - metastore z hive nie chce wystartować, name node wszedł w safe mode
sudo -u hdfs hdfs fsck /
sudo -u hdfs hdfs fsck -list-corruptfileblocks
sudo -u hdfs hdfs fsck / -delete
sudo -u hdfs hdfs dfsadmin -safemode leave