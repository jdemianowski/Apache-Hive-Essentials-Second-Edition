sqoop import --connect jdbc:postgresql://osboxes.local:5432/chinook --username postgres --password cloudera --table Album --m 4 --hive-import --hive-overwrite --hive-table=chinook.Album
sqoop import --connect jdbc:postgresql://osboxes.local:5432/chinook --username postgres --password cloudera --table Artist --m 4 --hive-import --hive-overwrite --hive-table=chinook.Artist
sqoop import --connect jdbc:postgresql://osboxes.local:5432/chinook --username postgres --password cloudera --table Customer --m 4 --hive-import --hive-overwrite --hive-table=chinook.Customer
sqoop import --connect jdbc:postgresql://osboxes.local:5432/chinook --username postgres --password cloudera --table Employee --m 4 --hive-import --hive-overwrite --hive-table=chinook.Employee
sqoop import --connect jdbc:postgresql://osboxes.local:5432/chinook --username postgres --password cloudera --table Genre --m 4 --hive-import --hive-overwrite --hive-table=chinook.Genre
sqoop import --connect jdbc:postgresql://osboxes.local:5432/chinook --username postgres --password cloudera --table Invoice --m 4 --hive-import --hive-overwrite --hive-table=chinook.Invoice
sqoop import --connect jdbc:postgresql://osboxes.local:5432/chinook --username postgres --password cloudera --table InvoiceLine --m 4 --hive-import --hive-overwrite --hive-table=chinook.InvoiceLine
sqoop import --connect jdbc:postgresql://osboxes.local:5432/chinook --username postgres --password cloudera --table MediaType --m 4 --hive-import --hive-overwrite --hive-table=chinook.MediaType
sqoop import --connect jdbc:postgresql://osboxes.local:5432/chinook --username postgres --password cloudera --table Playlist --m 4 --hive-import --hive-overwrite --hive-table=chinook.Playlist
sqoop import --connect jdbc:postgresql://osboxes.local:5432/chinook --username postgres --password cloudera --table PlaylistTrack --m 4 --hive-import --hive-overwrite --hive-table=chinook.PlaylistTrack
sqoop import --connect jdbc:postgresql://osboxes.local:5432/chinook --username postgres --password cloudera --table Track --m 4 --hive-import --hive-overwrite --hive-table=chinook.Track


sqoop import --connect jdbc:postgresql://osboxes.local:5432/worldDB --username postgres --password cloudera --table city --m 4 --hive-import --hive-overwrite --hive-table=worldDB.city
sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" --connect jdbc:postgresql://osboxes.local:5432/worldDB --username postgres --password cloudera --table country --m 4 --hive-import --hive-overwrite --hive-table=worldDB.country
sqoop import "-Dorg.apache.sqoop.splitter.allow_text_splitter=true" --connect jdbc:postgresql://osboxes.local:5432/worldDB --username postgres --password cloudera --table countrylanguage --m 4 --hive-import --hive-overwrite --hive-table=worldDB.countrylanguage

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

