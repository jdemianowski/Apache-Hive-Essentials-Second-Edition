create database IF NOT EXISTS google
comment 'google play store stats';
create schema if not exists google;

use google;

drop table if exists playstore_external;

create external table playstore_external(
    app string,
    category string,
    rating float,
    reviews float,
    size string,
    installs string,
    type string,
    price string,
    content_rating string,
    genres string,
    last_update date,
    current_ver string,
    android_ver string
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
WITH SERDEPROPERTIES (
   "separatorChar" = ",",
   "quoteChar"     = "\""
)
stored as textfile
location 'hdfs:/tmp/google/'
tblproperties ("skip.header.line.count"="1");

-- load data inpath '/tmp/googleplaystore.csv'
--     overwrite into table playstore_external;

select * from playstore_external;

drop table if exists playstore;
create table playstore
row format delimited
stored as orc
as select * from playstore_external;

select * from playstore;

select count(DISTINCT category) from playstore;