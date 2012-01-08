--ZAD1
select case when name is not null then name else 'unknown' end as language,count(*) as submits from submits left outer join jezyk j on language= j.id group by j.id order by j.id;
----
--ZAD2
select shortname as name, nullif(count(nullif(status=8,False)),0) as OK, nullif(count(nullif(status=7,False)),0) as ANS, nullif(count(nullif(status=5,False)),0) as TLE, nullif(count(nullif(status=4,False)),0) as RTE, nullif(count(nullif(status=14,False)),0) as RTE, nullif(count(nullif(status=3,False)),0) as RTE, nullif(count(nullif(status=2,False)),0) as CMP, nullif(count(nullif(status=10,False)),0) as RUL, nullif(count(nullif(status=11,False)),0) as HEA, nullif(count(nullif(status=6,False)),0) as INT, count(*) as all from submits full outer join problems p on p.id=problemsid where p.id!=28 group by p.id order by p.name;
----
--ZAD3
select shortname as name,
nullif(count(nullif(ocena=10,False)),0) as "100",
nullif(count(nullif(ocena<10 and ocena>=9,False)),0) as "100-90",
nullif(count(nullif(ocena<9 and ocena>=8,False)),0) as "90-80",
nullif(count(nullif(ocena<8 and ocena>=7,False)),0) as "80-70",
nullif(count(nullif(ocena<7 and ocena>=6,False)),0) as "70-60",
nullif(count(nullif(ocena<6 and ocena>=5,False)),0) as "60-50",
nullif(count(nullif(ocena<5 and ocena>=4,False)),0) as "50-40",
nullif(count(nullif(ocena<4 and ocena>=3,False)),0) as "40-30",
nullif(count(nullif(ocena<3 and ocena>=2,False)),0) as "30-20",
nullif(count(nullif(ocena<2 and ocena>=1,False)),0) as "20-10",
nullif(count(nullif(ocena<1 and ocena>=0,False)),0) as "10-0",
count(*) as all from (select floor(max(ocena)*10+0.1) as ocena,problemsid from submits group by problemsid,usersid) s full outer join problems p on p.id=problemsid where p.id!=28 group by p.id order by p.name;
----