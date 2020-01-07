use worlddb;

select city.name, country.name, country.continent from city join country on city.countrycode = country.code;



create view if not exists city_country_continent as
select city.name, country.name as country, country.continent
from city join country on city.countrycode = country.code;

select * from city_country_continent;

SELECT lv.*
FROM   ( SELECT 0) t
lateral VIEW explode(array(1234567890,9876543210)) lv AS phone;

SELECT name, if(population > 150000, 'big city', 'small_city'), population FROM city;

SELECT name, population,
       CASE
           WHEN population > 1000000 THEN 'very big city'
           WHEN population <= 1000000 AND population > 250000 THEN 'big city'
           ELSE 'small city'
        END as size_description
from city;

select name, district, population from
    (
        select * from city where population > 500000
        ) t;

with t as (select * from city where population > 500000)
select name, district, population from t;

select distinct name, continent from country where code in (
    select city.countrycode from city where city.population > 500000
    );

-- 37 s.
select distinct cou.name from country cou
join city ci on if(ci.population > 5000000,  ci.countrycode, -1) = cou.code;

-- 36 s.
select distinct cou.name from country cou
join city ci on ci.countrycode = cou.code
where ci.population > 5000000;

-- 34 s.
select distinct cou.name from country cou
join city ci on (ci.countrycode = cou.code and cou.population > 5000000);

--
select  /*+ MAPJOIN(country, city) */  distinct cou.name from country cou
join city ci on (ci.countrycode = cou.code and cou.population > 5000000);


set hive.auto.convert.sortmerge.join=true;
set hive.optimize.bucketmapjoin = true;
set hive.optimize.bucketmapjoin.sortedmerge = true;