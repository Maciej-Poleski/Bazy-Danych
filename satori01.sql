SELECT nazwisko,etat from pracownicy where id_zesp = (select id_zesp from pracownicy where nazwisko='Nowak') order by nazwisko,etat;
SELECT * from pracownicy where etat='PROFESOR' order by zatrudniony,id_prac limit (select count(*) from pracownicy where etat='PROFESOR' group by zatrudniony order by zatrudniony limit 1);
SELECT a.imie,a.nazwisko,a.id_zesp from pracownicy a where a.id_prac in (select id_prac from pracownicy where a.id_zesp=id_zesp order by zatrudniony desc limit 1) order by zatrudniony,id_prac;
SELECT * from zespoly z where not exists (select * from pracownicy where id_zesp=z.id_zesp) order by id_zesp;
SELECT nazwisko from pracownicy p where p.etat='PROFESOR' and not exists (select * from pracownicy where p.id_prac=id_szefa and etat='ASYSTENT' ) order by nazwisko;
SELECT id_zesp from pracownicy group by id_zesp order by sum(placa_pod+placa_dod) desc,id_zesp limit (select count(*) from (select sum(placa_pod+placa_dod) from pracownicy group by id_zesp order by sum(placa_pod+placa_dod) desc) ddd group by sum order by sum desc limit 1);
select nazwa from zespoly where id_zesp=( SELECT id_zesp from pracownicy group by id_zesp order by count(*) desc limit 1) order by id_zesp;
SELECT p.nazwisko,p.imie from pracownicy p where p.placa_pod>0.5*(select max(placa_pod) from pracownicy where id_zesp=p.id_zesp) and p.id_zesp is not null order by nazwisko,imie;