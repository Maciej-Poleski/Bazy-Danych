--ZAD1
select id_zesp,sum(placa_pod) from pracownicy group by id_zesp order by id_zesp;
----
--ZAD2
SELECT round(avg(placa_pod),2) from pracownicy having count(*) >12;
----
--ZAD3a
select id_zesp,count(*) from pracownicy where (etat != 'PROFESOR' ) and (id_zesp is not null) group by id_zesp having avg(placa_pod)>1000 order by sum(placa_pod);
----
--ZAD3b
select id_zesp,count(case when etat!='PROFESOR' then 1 else null end) from pracownicy where (id_zesp is not null) group by id_zesp having avg(placa_pod)>2000 order by sum(placa_pod);
----
--ZAD4
select id_zesp,min(placa_pod),max(placa_pod),max(placa_pod)-min(placa_pod) as diff from pracownicy group by id_zesp order by id_zesp;
----
--ZAD5
select etat,round(avg(placa_pod),2) from pracownicy group by etat order by avg(placa_pod) desc;
----
--ZAD6
select count(*) from pracownicy where etat='PROFESOR';
----
--ZAD7
select id_zesp,sum(placa_pod+greatest(placa_dod,0)) from pracownicy group by id_zesp order by id_zesp;
----
--ZAD8
SELECT id_szefa,min(placa_pod) from pracownicy where id_szefa is not null group by id_szefa order by min(placa_pod) desc,id_szefa desc;
----
--ZAD9
select case when count(*)-count(distinct nazwisko) = 0 then 'unikalne' else 'nieunikalne' end from pracownicy where nazwisko is not null;
----
--ZAD10
SELECT id_zesp from pracownicy where id_zesp is not null group by id_zesp having count(*)>2 order by id_zesp;
----
--ZAD11
select etat,round(avg(placa_pod),2),count(*) from pracownicy where extract(year from zatrudniony)<=1990 group by etat order by etat;
----

