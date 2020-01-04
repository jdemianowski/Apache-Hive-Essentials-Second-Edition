use ecommerce;

drop table if exists array_ex;
truncate table if exists array_ex;
create table array_ex(
    id int,
    arr array<string>,
    mp map<string, string>,
    st struct<name:string, age:int>
)
row format delimited
fields terminated by ';'
stored as orc
location 'hdfs:/tmp/array_ex/';

insert into table array_ex
    select 1,
    array('aa', 'bb', 'ccc'),
    map('key','value'),
    named_struct('name', 'Jan', 'age', 24)
;

select * from array_ex;

select arr[0], mp['key'], st.name from array_ex;

create table tst (
    id string
)
comment 'komentarz'
row format delimited
fields terminated by ';'
stored as orc
location '/tmp/test'
;


insert into tst values ('a');
insert into tst values ('b');

select * from tst;

describe database ecommerce;
