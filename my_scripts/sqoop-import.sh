sqoop import --connect jdbc:postgresql://osboxes.local:5432/chinook --username postgres --password cloudera --table Album --m 4 --hive-import --hive-overwrite --hive-database=chinook   --hive-table=Album
sqoop import --connect jdbc:postgresql://osboxes.local:5432/chinook --username postgres --password cloudera --table Artist --m 4 --hive-import --hive-overwrite --hive-database=chinook  --hive-table=Artist
sqoop import --connect jdbc:postgresql://osboxes.local:5432/chinook --username postgres --password cloudera --table Customer --m 4 --hive-import --hive-overwrite --hive-database=chinook  --hive-table=Customer
sqoop import --connect jdbc:postgresql://osboxes.local:5432/chinook --username postgres --password cloudera --table Employee --m 4 --hive-import --hive-overwrite --hive-database=chinook  --hive-table=Employee
sqoop import --connect jdbc:postgresql://osboxes.local:5432/chinook --username postgres --password cloudera --table Genre --m 4 --hive-import --hive-overwrite --hive-database=chinook  --hive-table=Genre
sqoop import --connect jdbc:postgresql://osboxes.local:5432/chinook --username postgres --password cloudera --table Invoice --m 4 --hive-import --hive-overwrite --hive-database=chinook  --hive-table=Invoice
sqoop import --connect jdbc:postgresql://osboxes.local:5432/chinook --username postgres --password cloudera --table InvoiceLine --m 4 --hive-import --hive-overwrite --hive-database=chinook  --hive-table=InvoiceLine
sqoop import --connect jdbc:postgresql://osboxes.local:5432/chinook --username postgres --password cloudera --table MediaType --m 4 --hive-import --hive-overwrite --hive-database=chinook  --hive-table=MediaType
sqoop import --connect jdbc:postgresql://osboxes.local:5432/chinook --username postgres --password cloudera --table Playlist --m 4 --hive-import --hive-overwrite --hive-database=chinook  --hive-table=Playlist
sqoop import --connect jdbc:postgresql://osboxes.local:5432/chinook --username postgres --password cloudera --table PlaylistTrack --m 4 --hive-import --hive-overwrite --hive-database=chinook  --hive-table=PlaylistTrack
sqoop import --connect jdbc:postgresql://osboxes.local:5432/chinook --username postgres --password cloudera --table Track --m 4 --hive-import --hive-overwrite --hive-database=chinook  --hive-table=Track


sqoop import --connect jdbc:postgresql://osboxes.local:5432/worldDB --username postgres --password cloudera --table city --m 4 --hive-import --hive-database=worlddb  --hive-overwrite --hive-database=chinook  --hive-table=city
sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" --connect jdbc:postgresql://osboxes.local:5432/worldDB --username postgres --password cloudera --table country --m 4 --hive-import --hive-database=worlddb --hive-overwrite --hive-database=chinook  --hive-table=country
sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" --connect jdbc:postgresql://osboxes.local:5432/worldDB --username postgres --password cloudera --table countrylanguage --m 4 --hive-import --hive-database=worlddb --hive-overwrite --hive-database=chinook  --hive-table=countrylanguage

sqoop import-all-tables "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
--connect jdbc:postgresql://osboxes.local:5432/chinook \
--username postgres --password cloudera \
--m 1 \
--warehouse-dir /user/sqoop/chinook_external

sqoop import-all-tables "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" \
--connect jdbc:postgresql://osboxes.local:5432/worldDB \
--username postgres --password cloudera \
--m 4 \
--warehouse-dir /user/sqoop/worldDB_external

