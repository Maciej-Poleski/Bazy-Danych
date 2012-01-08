--ZAD1
SELECT * from zespoly ;
----
--ZAD2
SELECT * from pracownicy order by id_prac,nazwisko,imie,etat,id_szefa,zatrudniony,placa_pod,placa_dod,id_zesp;
----
--ZAD3
SELECT nazwisko,etat,placa_pod*12 as roczne_dochody from pracownicy order by nazwisko,etat,roczne_dochody;
----
--ZAD4
SELECT nazwisko,placa_pod+greatest(placa_dod,0) as miesieczne_dochody from pracownicy order by nazwisko,miesieczne_dochody;
----
--ZAD5
SELECT * from zespoly order by nazwa ;
----
--ZAD6
SELECT distinct etat from pracownicy order by etat ;
----
--ZAD7
SELECT * from pracownicy where etat='ASYSTENT' ;
----
--ZAD8
SELECT * from pracownicy where id_zesp=20 or id_zesp=30 order by placa_pod desc;
----
--ZAD9
SELECT * from pracownicy where placa_pod >=300 and placa_pod<=1800;
----
--ZAD10
SELECT * from pracownicy where right(nazwisko,3) ='ski' order by id_prac,nazwisko,imie,etat,id_szefa,zatrudniony,placa_pod,placa_dod,id_zesp;
----
--ZAD11
SELECT * from pracownicy where placa_pod>2000 and id_szefa is not null order by id_prac,nazwisko,imie,etat,id_szefa,zatrudniony,placa_pod,placa_dod,id_zesp;
----
--ZAD12
SELECT nazwisko,zatrudniony,etat from pracownicy where ((extract(year from zatrudniony)=1992 or extract(year from zatrudniony)=1993)) order by nazwisko,zatrudniony,etat;
----
--ZAD13
SELECT * from pracownicy where  greatest(placa_dod,0) >500 order by etat,nazwisko,id_prac,imie,id_szefa,zatrudniony,placa_pod,placa_dod,id_zesp;
----
--ZAD14
select nazwisko || ' pracuje od ' || zatrudniony || ' i zarabia ' || placa_pod  as "PROFESOROWIE" from pracownicy where etat='PROFESOR' order by placa_pod desc;
----
--ZAD15
SELECT nazwisko,round((placa_pod)*1.15,0) as "place" from pracownicy order by nazwisko,place;
----
--ZAD16
SELECT rpad(nazwisko,20,'.') || lpad(etat,20,'.') as "nazwisko i etat" from pracownicy order by id_prac ;
----
--ZAD17
select left(etat,2) || id_prac as "wygenerowany kod",id_prac,nazwisko,etat from pracownicy order by "wygenerowany kod",id_prac,nazwisko,etat;
----
--ZAD18
SELECT nazwisko,translate(nazwisko,'KkLlMm','XXXXXX') as zmienione_nazwisko from pracownicy order by nazwisko,zmienione_nazwisko ;
----
--ZAD19
SELECT nazwisko,to_char(zatrudniony,'Month, DD IYYY') as data_zatrudnienia from pracownicy where id_zesp =20 ;
----
--ZAD20
SELECT to_char(current_date,'Day') as dzis;
----
--ZAD21
select id_prac,case when placa_pod <1850 then 'mniej' when placa_pod = 1850 then 'rowna' else 'wiecej' end as pensja from pracownicy order by id_prac,pensja;
----
