use worlddb;

SET hive.exec.dynamic.partition=true;
SET hive.exec.dynamic.partition.mode=nonstrict;
SET hive.optimize.sort.dynamic.partition=true;
SET hive.exec.max.dynamic.partitions=500000;
SET hive.exec.max.dynamic.partitions.pernode=500000;
set hive.enforce.bucketing=true;

--
select * from city
distribute by rand() sort by rand() limit 10;

drop table if exists city_orc;
CREATE TABLE if not exists `city_orc`(
  `id` int,
  `name` string,
  `district` string,
  `population` int)
PARTITIONED BY (countrycode string)
stored as orc;
insert OVERWRITE TABLE city_orc partition (countrycode)
select id, name, district, population, countrycode from city;


select count(1) from city_orc where countrycode = 'ARG' or countrycode = 'BRA';

select count(1) from city where countrycode = 'ARG' or countrycode = 'BRA';

SET hive.exec.compress.intermediate=true;
SET hive.intermediate.compression.codec=org.apache.hadoop.io.compress.SnappyCodec;

select * from city_orc limit 10;
-- 24 s.
select sum(population) from city group by (countrycode);
-- 38/40 s.
select cr.name, sum(co.population), avg(co.population), count(*)
from city_orc as co join country cr on cr.code = co.countrycode
group by (cr.name)
order by cr.name;

-- 4.8 s.
select * from city order by population;

-- 2 s.
select * from (select * from city CLUSTER BY population) t order by population;


-- 36 s.
select distinct cou.name from country cou
join city ci on ci.countrycode = cou.code
where ci.population > 5000000;

-- 34 s.
select distinct cou.name from country cou
join city ci on (ci.countrycode = cou.code and cou.population > 5000000);
