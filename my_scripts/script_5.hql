create database if not exists external_files;
use external_files;

create table if not exists external_files.city like worlddb.city;
create table if not exists external_files.country like worlddb.country;
create table if not exists external_files.countrylanguage like worlddb.countrylanguage;

ALTER TABLE city SET TBLPROPERTIES ("skip.header.line.count"="1");

drop table city;

CREATE TABLE `city`(
  `id` int,
  `name` string,
  `countrycode` string,
  `district` string,
  `population` int)
ROW FORMAT DELIMITED
fields terminated by ','
TBLPROPERTIES ('skip.header.line.count'='1');

select * from city;

load data inpath 'hdfs:///user/sqoop/worldDB_external/city/part-m-*' into table city;

create table city2 like city;
show create table city2;

select * from city2;

insert OVERWRITE TABLE city2 select * from city where population > 650000;

select count(*) from city2;

with t as (select * from city where population > 650000)
from t insert into city2 select *;

with t as (select * from city where population > 650000)
from t insert overwrite table city2 select *;

drop table city3;
CREATE TABLE if not exists `city3`(
  `id` int,
  `name` string,
  `countrycode` string,
  `district` string,
  `population` int)
ROW FORMAT DELIMITED
fields terminated by ','
stored as parquet;
insert OVERWRITE TABLE city3 select * from city;


drop table if exists city4;
CREATE TABLE if not exists `city4`(
  `id` int,
  `name` string,
  `countrycode` string,
  `district` string,
  `population` int)
ROW FORMAT DELIMITED
fields terminated by ','
stored as orc;
insert OVERWRITE TABLE city4 select * from city;


-- 22 s.
select sum(population) from city;
-- 23 s.
select sum(population) from city3;
-- 22 s.
select sum(population) from city4;



describe city3;

SET hive.exec.dynamic.partition=true;
SET hive.exec.dynamic.partition.mode=nonstrict;

insert overwrite directory 'hdfs:///user/sqoop/worldDB_external/city/'
row format delimited
fields terminated by ','
stored as parquet
select * from city;

export table city to 'hdfs:/tmp/city_tmp5';
import table city6 from 'hdfs:/tmp/city_tmp5';

select * from city6;

import external table city7 from 'hdfs:/tmp/city_tmp5' location 'hdfs:/tmp/city_tmp6';

select * from city sort by population;

-- 31 s.
SET mapred.reduce.tasks = 4;
select * from city sort by population;

select * from city  where countrycode = 'NLD' or countrycode = 'AUS' or countrycode = 'BRA'
distribute by countrycode sort by population limit 10;

select * from  city where countrycode = 'NLD' or countrycode = 'AUS' or countrycode = 'BRA' cluster by population;

select * from city where countrycode = 'NLD' or countrycode = 'AUS' or countrycode = 'BRA' sort by population;

select * from city order by population limit 10;

-- 24 s.
select * from (select * from city CLUSTER BY population) t order by population;


select *, split(name, 't') from city;

select *, split(name, 't')[0] from city;

select countrycode, collect_list(name) from city group by countrycode;

select countrycode, collect_set(name) from city group by countrycode;

select name, INPUT__FILE__NAME, BLOCK__OFFSET__INSIDE__FILE from city;


SET hive.exec.dynamic.partition=true;
SET hive.exec.dynamic.partition.mode=nonstrict;
SET hive.optimize.sort.dynamic.partition=true;
SET hive.exec.max.dynamic.partitions=500000;
SET  hive.exec.max.dynamic.partitions.pernode=500000;
set hive.enforce.bucketing=true;

create table city_acid like city


CREATE TABLE if not exists `city_acid`(
  `id` int,
  `name` string,
  `countrycode` string,
  `district` string,
  `population` int)
clustered by (countrycode) into 16 buckets
stored as orc
TBLPROPERTIES ('transactional'='true');


select * from city;



SET hive.support.concurrency=false;
SET hive.txn.manager=org.apache.hadoop.hive.ql.lockmgr.DummyTxnManager;
SET hive.enforce.bucketing=false;
SET hive.exec.dynamic.partition.mode=strict;
SET hive.compactor.initiator.on=false;
SET hive.compactor.worker.threads=0;


update city2 set name = '%..%..test' where name = 'Haag';

