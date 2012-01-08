--ZAD1
--ZAD2
CREATE SEQUENCE myseq start 70 maxvalue 99 increment 1;
----
--ZAD2
INSERT INTO zespoly VALUES (nextval('myseq'));
INSERT INTO zespoly VALUES (nextval('myseq'));
----
--ZAD3
--ZAD4
CREATE UNIQUE INDEX on pracownicy (nazwisko);
----
--ZAD4
INSERT INTO pracownicy (id_prac,nazwisko) VALUES (666,'Nowak');
----
--ZAD5
CREATE VIEW zespoly_sklad as SELECT nazwa,count(id_prac) as sklad from pracownicy right join zespoly using(id_zesp) group by id_zesp;
----
--ZAD6
--ZAD7
--ZAD8
CREATE SEQUENCE myseq start 300 increment 10;
----
--ZAD7
--ZAD8
INSERT INTO pracownicy (id_prac,nazwisko,etat,placa_dod) VALUES (nextval('myseq'),'Trąbczyński','ASYSTENT',null);
----
--ZAD8
UPDATE pracownicy set placa_dod =currval('myseq') where id_prac=currval('myseq');
----
--ZAD9
CREATE view asystenci AS SELECT id_prac,nazwisko,placa_pod as placa,2012-extract(year from zatrudniony)-1 as lata from pracownicy where etat='ASYSTENT';
----
--ZAD10
--ZAD11
CREATE view place as SELECT id_zesp,round(avg(placa_pod+greatest(placa_dod,0)),2) as srednia_placa,min(placa_pod+greatest(placa_dod,0)) as minimalna_placa, max(placa_pod+greatest(placa_dod,0)) as maksymalna_placa,sum(placa_pod+greatest(placa_dod,0)) as fundusz,count(placa_pod)+count(placa_dod) as liczba_wyplat from pracownicy join zespoly using(id_zesp) where id_zesp is not null group by id_zesp;
----
--ZAD11
SELECT nazwisko,placa_pod+greatest(placa_dod,0) as placa from pracownicy join place using(id_zesp) where placa_pod+greatest(placa_dod,0)<srednia_placa order by nazwisko,placa;
----
--ZAD12
CREATE SEQUENCE studenci_seq start 1 increment 1;
CREATE table studenci (id numeric primary key default(nextval('studenci_seq')),imie varchar(100) not null,nazwisko varchar(100) not null,data_ur date not null);
----
