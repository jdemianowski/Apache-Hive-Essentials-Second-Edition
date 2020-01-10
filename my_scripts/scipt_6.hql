use worlddb;

SET hive.exec.dynamic.partition=true;
SET hive.exec.dynamic.partition.mode=nonstrict;
SET hive.optimize.sort.dynamic.partition=true;
SET hive.exec.max.dynamic.partitions=500000;
SET  hive.exec.max.dynamic.partitions.pernode=500000;
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

create index idx_countrycode
    on table city (countrycode)
    as 'COMPACT' with deferred rebuild;
ALTER INDEX idx_countrycode ON city REBUILD;

SHOW INDEX ON city;


explain select count(1) from city_orc where countrycode = 'ARG' or countrycode = 'BRA';
explain select count(1) from city where countrycode = 'ARG' or countrycode = 'BRA';

SET hive.exec.compress.intermediate=true;
SET hive.intermediate.compression.codec=org.apache.hadoop.io.compress.SnappyCodec;

select * from city_orc limit 10;
-- 24 s.
select sum(population) from city_orc group by (countrycode);
-- 38/40 s.
select country.name, sum(city_orc.population), avg(city_orc.population), count(*)
from city_orc join country on country.code = city_orc.countrycode
group by (country.name);


 select * from city_orc where countrycode = 'ARG' or countrycode = 'BRA';
 select * from city where countrycode = 'ARG' or countrycode = 'BRA';

analyze table city_orc partition(countrycode) compute statistics;

DESCRIBE FORMATTED city_orc;

SET hive.optimize.reducededuplication.min.reducer=4;
SET hive.optimize.reducededuplication=true;
SET hive.merge.mapfiles=true;
SET hive.merge.mapredfiles=false;
SET hive.merge.smallfiles.avgsize=16000000;
SET hive.merge.size.per.task=256000000;
SET hive.merge.sparkfiles=true;
SET hive.auto.convert.join=true;
SET hive.auto.convert.join.noconditionaltask=true;
SET hive.optimize.bucketmapjoin.sortedmerge=false;
SET hive.map.aggr.hash.percentmemory=0.5;
SET hive.map.aggr=true;
SET hive.optimize.sort.dynamic.partition=false;
SET hive.stats.autogather=true;
SET hive.stats.fetch.column.stats=true;
SET hive.compute.query.using.stats=true;
SET hive.limit.pushdown.memory.usage=0.4;
SET hive.optimize.index.filter=true;
SET hive.exec.reducers.bytes.per.reducer=67108864;
SET hive.smbjoin.cache.rows=10000;
SET hive.fetch.task.conversion=more;
SET hive.fetch.task.conversion.threshold=1073741824;
SET hive.optimize.ppd=true;
