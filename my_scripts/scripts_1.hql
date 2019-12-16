create database IF NOT EXISTS my_test_db_2
comment 'komentarz'
-- location '/hdfs/test_dir_3'
with dbproperties ('creator'='kuba');

create schema if not exists my_test_db_2;

describe database my_test_db_2;

select current_database();

drop database if exists my_test_db_2;
drop schema if exists my_test_db_2;

use my_test_db_2;

create table if not exists test_table (
    name string  comment 'komentarz',
    id int comment 'id',
    internal_array array<string> comment 'internal stuff'
)