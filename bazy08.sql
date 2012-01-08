--ZAD1
--ZAD10
CREATE TABLE zwierzeta (gatunek varchar(100) not null, jajorodny char(1) not null check(jajorodny='T' or jajorodny='N'), liczba_konczyn numeric(2) not null,data_odkrycia date not null);
----
--ZAD2
CREATE table klienci (pesel char(11) primary key,adres varchar(100),wiek numeric(2) ,wspolpraca_od date);
----
--ZAD3
CREATE table uczelnie (id_uczelni numeric(4) primary key,nazwa varchar(100) unique,adres varchar(100),budzet numeric(10,2),zalozona date);
----
--ZAD4
CREATE table ksiazki (id_ksiazki numeric(10) primary key,tytul varchar(100) not null,autorzy varchar(100), cena numeric(6,2),data_wydania date);
----
--ZAD5
create table pokoje(numer_pokoju numeric(3) primary key,id_zesp numeric(2) references zespoly,liczba_okien numeric(1));
----
--ZAD6
--ZAD8
--ZAD9
CREATE table plyty_cd(kompozytor varchar(100) not null,tytul_albumu varchar(100) not null,data_nagrania date,data_wydania date,czas_trwania interval check(czas_trwania < interval '82 minutes'), constraint un_ko_ty unique(kompozytor,tytul_albumu), check(data_nagrania<data_wydania));
----
--ZAD7
CREATE table szef_podwladny as select a.nazwisko as szef,b.nazwisko as podwladny from pracownicy a,pracownicy b where b.id_szefa is not null and a.id_prac=b.id_szefa;
----
--ZAD8
--ZAD9
alter table plyty_cd drop constraint un_ko_ty;
alter table plyty_cd add constraint un_ko_ty  primary key(kompozytor,tytul_albumu);
----
--ZAD9
alter table plyty_cd drop constraint un_ko_ty;
insert into plyty_cd values ('a','b',null,null,null);
insert into plyty_cd values ('a','b',null,null,null);
alter table plyty_cd add constraint un_ko_ty  primary key(kompozytor,tytul_albumu);
----
--ZAD10
alter table zwierzeta rename to gatunki;
drop table gatunki ;
----
--ZAD11
--ZAD12
--ZAD13
--ZAD15
create table projekty(id_projektu numeric(4) primary key,opis_projektu char(20) not null unique,data_rozpoczecia date default(now()),data_zakonczenia date,fundusz numeric(7,2),check(data_rozpoczecia<data_zakonczenia));
----
--ZAD12
--ZAD13
create table przydzialy(id_projektu numeric(4) references projekty,id_prac numeric(4) references pracownicy,od date default(now()),"do" date,stawka numeric(7,2),rola char(20) check(rola='KIERUJACY' or rola='ANALITYK' or rola='PROGRAMISTA'),primary key(id_projektu,id_prac), check(od<"do"));
----
--ZAD13
alter table przydzialy add godziny numeric;
----
--ZAD14
----
--ZAD15
alter table projekty alter opis_projektu type char(30);
----
--ZAD16
insert into pracownicy values (1000,'Kowalski');
alter table pracownicy add unique(nazwisko);
----
--ZAD17
alter table pracownicy drop imie;
----
--ZAD18
create table pracownicy_zespoly as select nazwisko,etat,placa_pod*12 as roczna_placa,nazwa as zespol,adres as adres_pracy from pracownicy join zespoly using(id_zesp);
----