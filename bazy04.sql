--ZAD1
select nazwa,nazwisko from etaty,pracownicy where left(nazwa,1)='A' and left(nazwisko,1)='N' order by nazwa,nazwisko;
----
--ZAD2
select nazwisko,placa_pod,placa_od,placa_do from pracownicy join etaty on nazwa=etat where etat='DYREKTOR' or etat='SEKRETARKA' order by nazwisko,placa_pod,placa_od,placa_dod;
----
--ZAD3
select nazwisko,etat from pracownicy join etaty on nazwa='ASYSTENT' where placa_pod+greatest(placa_dod,0)>=placa_od and placa_pod+greatest(placa_dod,0)<=placa_do order by nazwisko,etat;
----
--ZAD4
select nazwa,count(nullif(nazwisko,null)) as count from pracownicy join zespoly using(id_zesp) group by nazwa order by nazwa,count;
select nazwa,count(nullif(nazwisko,null)) as count from pracownicy right outer join zespoly using(id_zesp) group by nazwa order by nazwa,count;
----
--ZAD5
select a.nazwisko from pracownicy a join pracownicy p on p.nazwisko='Nowicki' where a.placa_pod> p.placa_pod order by a.nazwisko;
----
--ZAD6
select a.nazwisko as pracownik1,b.nazwisko as szef1,c.adres as pracownik2,d.adres as szef2 from pracownicy a left outer join pracownicy b on a.id_szefa=b.id_prac left outer join zespoly c on a.id_zesp=c.id_zesp left outer join zespoly d on b.id_zesp=d.id_zesp order by pracownik1,szef1,pracownik2,szef2;
----
--ZAD7
SELECT nazwisko,etat,id_zesp,nazwa from pracownicy left outer join zespoly using(id_zesp) order by nazwisko,etat,id_zesp;
----
--ZAD8
SELECT nazwisko from pracownicy join zespoly using(id_zesp) where adres='PIOTROWO 3A' order by nazwisko;
----
--ZAD9
SELECT nazwisko,adres,nazwa from pracownicy join zespoly using(id_zesp) where placa_pod>1000 order by nazwisko,adres,nazwa;
----
--ZAD10
SELECT nazwisko,etat,placa_od,placa_do from pracownicy left outer join etaty on etat=nazwa order by nazwisko, etat,placa_od,placa_dod;
SELECT nazwisko,nazwa,placa_od,placa_do from pracownicy left outer join etaty on placa_od<=placa_pod and placa_pod<=placa_do order by nazwisko, nazwa,placa_od,placa_dod;
----
--ZAD11
SELECT nazwisko,etat,placa_pod+greatest(placa_dod,0) as placa,placa_od,placa_do,c.nazwa from pracownicy left join etaty on etat=nazwa left join zespoly c using(id_zesp) where (etat!='ASYSTENT' or etat is null) order by placa desc,nazwisko,etat,placa_od,placa_do,c.nazwa;
----
--ZAD12
SELECT nazwisko,etat,placa_pod+greatest(placa_dod,0) as dochody,c.nazwa,x.nazwa from pracownicy left join etaty on etat=nazwa left join zespoly c using(id_zesp) cross join etaty x where (etat='ASYSTENT' or etat='ADIUNKT') and placa_pod+greatest(placa_dod,0) > 2000 and placa_pod+greatest(placa_dod,0)<=x.placa_do and x.placa_od<=placa_pod+greatest(placa_dod,0) order by nazwisko,etat,dochody,c.nazwa,x.nazwa;
----
--ZAD13
select b.nazwisko,b.id_prac,a.id_prac,a.nazwisko from pracownicy b join pracownicy a on b.id_szefa=a.id_prac order by b.nazwisko,b.id_prac,a.nazwisko,a.id_prac;
----
--ZAD14
select b.nazwisko,b.id_prac,a.id_prac,a.nazwisko from pracownicy b left join pracownicy a on b.id_szefa=a.id_prac order by b.nazwisko,b.id_prac,a.nazwisko,a.id_prac;
----
--ZAD15
select b.nazwa,count(a.placa_pod),round(avg(a.placa_pod),2) from pracownicy a right outer join zespoly b on a.id_zesp=b.id_zesp group by b.id_zesp order by b.nazwa,count,round;
----
--ZAD16
select b.nazwisko,count(*) from pracownicy a join pracownicy b on a.id_szefa=b.id_prac group by b.id_prac order by count desc;
----
--ZAD17
select a.nazwisko,a.zatrudniony from pracownicy a join pracownicy b on a.id_szefa=b.id_prac where extract(year from age(a.zatrudniony,b.zatrudniony))<10 order by a.nazwisko,a.zatrudniony;
----
