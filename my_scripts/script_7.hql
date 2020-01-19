use worlddb;

SET hive.exec.dynamic.partition=true;
SET hive.exec.dynamic.partition.mode=nonstrict;
SET hive.optimize.sort.dynamic.partition=true;
SET hive.exec.max.dynamic.partitions=500000;
SET hive.exec.max.dynamic.partitions.pernode=500000;
set hive.enforce.bucketing=true;

select sum(population) from city group by (countrycode);

select cr.name, sum(co.population), avg(co.population), count(*)
from city as co join country cr on cr.code = co.countrycode
group by (cr.name)
order by cr.name;

select * from city order by population;

select * from (select * from city CLUSTER BY population) t order by population;

select distinct cou.name from country cou
join city ci on (ci.countrycode = cou.code);

use default;

drop table if exists example_1;
create table if not exists example_1
(
 id int,
 arr array<string>,
 mp map<string, int>,
 str struct<name:string, age:int>
)
row format delimited
stored as parquet;

insert into table example_1
select 1, array('aa', 'bb', 'ce'), map('jeden', 1, 'dwa', 2), named_struct('name', 'Jan', 'age', 46);

select id, arr[0], mp['jeden'], str.name from example_1;