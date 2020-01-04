use default;

drop table if exists test_tb;

create table test_tb(
id int,
arr array<string>,
mp map<string, string>,
st struct<name:string, surname:string>
)
row format delimited
fields terminated by ';'
stored as parquet
location 'hdfs:/tmp/test_2';

insert into table test_tb (id, arr, mp, st)
select 1,
       array('aa', 'bb', 'cc'),
       map('k','v'),
       named_struct('name', 'Imie', 'surname', 'nazwisko')
;

select * from test_tb;

select cast(id as float), arr[0], mp['k'] from test_tb;

drop database if exists test_db_2;

create database if not exists test_db_2
comment 'to moja testowa baza danych'
location '/usr/hive/warehouse/test_location_db_2'
with dbproperties ('creator'='kuba');

create schema if not exists test_db_2;

describe database test_db_2;

use test_db_2;

select current_database();

alter database test_db_2
set location 'hdfs:///usr/hive/warehouse/test_location_db_3/';

create external table test_ext (id int)
row format delimited
fields terminated by '|'
map keys terminated by ':'
    stored as parquet
location 'usr/hive/metadane_tabeli'
;

use default;

load data inpath 'sciekza' overwrite into table test_tb;

create database if not exists test_db_3
comment 'komentarz'
location '/usr/hive/test_db_3'
with dbproperties ('prop1'='val1')
;

describe database google;

select current_database();

alter database test_db_2 set location 'new location';

