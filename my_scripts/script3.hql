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

create table select_tb as select * from city;

create table like_tb like city;

show columns in city;

show create table city;

show tblproperties city;

create table test_tb_3  stored as parquet as select * from city;

show create table city;

SET hive.exec.dynamic.partition=true;
SET hive.exec.dynamic.partition.mode=nonstrict;
SET hive.optimize.sort.dynamic.partition=true;
SET hive.exec.max.dynamic.partitions=500000;
SET  hive.exec.max.dynamic.partitions.pernode=500000;
set hive.enforce.bucketing=true;


insert into table test_tb_4 partition(countrycode)
select id, name, district, population, countrycode from city;

select name, population from test_tb_4 where countrycode = 'ARG';

select name, population from city where countrycode = 'ARG';

select name, population from test_tb_buckets where countrycode = 'ARG';

drop table if exists test_tb_buckets;
CREATE TABLE `test_tb_buckets`(
  `id` int,
  `name` string,
  `district` string,
  `population` int,
  countrycode string)
  clustered by (countrycode) sorted by (countrycode) into 128 buckets
row format delimited
stored as parquet;

insert into table test_tb_buckets
select id, name, district, population, countrycode from city;

drop table if exists test_tb_4;
CREATE TABLE `test_tb_4`(
  `id` int,
  `name` string,
  `district` string,
  `population` int)
  partitioned by (countrycode string)
row format delimited
stored as parquet;


create database if not exists adventureworks;
create database if not exists chinook;
create database if not exists usda;
create database if not exists worldDB;
