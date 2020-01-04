create database IF NOT EXISTS ecommerce
comment 'ecommerce transactions';
create schema if not exists ecommerce;

use ecommerce;

show tables in ecommerce;

show columns in ts_external;

drop table if exists ts_external;
create external table ts_external(
    invocie_no int,
    stock_code string,
    description string,
    quantity int,
    invoice_date string,
    unit_price float,
    customer_id int,
    country string
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
WITH SERDEPROPERTIES (
   "separatorChar" = ",",
   "quoteChar"     = "\""
)
stored as textfile
location 'hdfs:/tmp/ecommerce/'
tblproperties ("skip.header.line.count"="1");

select * from ts_external;

drop table if exists ts;
create table ts
row format delimited
stored as orc
TBLPROPERTIES(
"orc.compress"="ZLIB",
"orc.create.index"="true",
"orc.bloom.filter.columns"="invocie_no,unit_price,quantity")
as select
    invocie_no,
    stock_code,
    description,
    quantity,
    cast(from_unixtime(unix_timestamp(invoice_date, 'MM/dd/yyyy HH:mm')) as timestamp) as invoice_date,
    unit_price,
    customer_id,
--     (unit_price * quantity) as price,
    country
from ts_external;


select * from ts where quantity > 10;


select min(invoice_date), max(invoice_date) from ts;
select avg(price) as avg_price, avg(quantity) as avg_quantity, avg(unit_price) as avg_unit_price from ts;
select count(DISTINCT stock_code) as unique_stock_codes, count(DISTINCT customer_id) as unique_customers from ts;

select count(distinct country) from ts;
select count(distinct country) from ts_external;

select count(DISTINCT stock_code) as unique_stock_codes, count(DISTINCT customer_id) as unique_customers from ts
WHERE country='United Kingdom';

select count(DISTINCT stock_code) as unique_stock_codes, count(DISTINCT customer_id) as unique_customers from ts_partitioned
WHERE country='United Kingdom';

SET hive.exec.dynamic.partition=true;
SET hive.exec.dynamic.partition.mode=nonstrict;
SET hive.optimize.sort.dynamic.partition=true;
SET hive.exec.max.dynamic.partitions=500000;
SET  hive.exec.max.dynamic.partitions.pernode=500000;

drop table if exists ts_partitioned;
create table ts_partitioned(
    invocie_no string,
    stock_code string,
    description string,
    quantity string,
    invoice_date string,
    unit_price string,
    customer_id string
)
partitioned by (country string)
row format delimited
fields terminated by ';'
stored as orc
location 'hdfs:/tmp/partitioned_table/';

insert into table ts_partitioned partition(country) select
    invocie_no,
    stock_code,
    description,
    quantity,
    invoice_date,
    unit_price,
    customer_id,
    country
 from ts_external;

select * from ts_partitioned;

select * from ts_external;

show create table ts_external;

show tblproperties ts_external;