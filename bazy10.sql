--ZAD1
create or replace function dodaj(a numeric, b numeric)
	returns numeric as
$$
begin
	return a + b;
end;
$$
language plpgsql;
----
--ZAD2
create or replace function kolo(r numeric)
returns varchar(100) as
$$
declare
c_pi constant numeric = 3.14;
begin
return 'Pole kola wynosi ' || cast(round(c_pi*r*r,3) as varchar(100)) || '. Obwod kola wynosi ' || cast(round(2*c_pi*r,3) as varchar(100)) || '.';
end;
$$
language plpgsql;
----
--ZAD3
create or replace function kolo(r numeric)
returns record as
$$
declare
c_pi constant numeric = 3.14;
result record;
begin
select round(c_pi*r*r,3) as pole,round(2*c_pi*r,3) as obwod into result; 
return result;  
end;
$$               
language plpgsql;
----
--ZAD4
create or replace function najlepszy_pracownik()
returns SETOF varchar(200) as
$$
declare p varchar(200);
begin
for p in select 'Najlepiej zarabia '||imie||' '||nazwisko||'. Pracuje on jako '||etat||'.' from (select imie,nazwisko,placa_pod+greatest(placa_dod,0) as placa,etat from pracownicy where placa_pod+greatest(placa_dod,0)=(select max(placa_pod+greatest(placa_dod,0)) from pracownicy ) order by etat) as foo loop
return next p;
end loop;
end;
$$
language plpgsql;
----
--ZAD5
create or replace function silnia(n numeric)
returns numeric as
$$
declare
it numeric;
result numeric =1;
begin
for it in 2 .. n loop
select result*it into result;
end loop;
return result;
end;
$$
language plpgsql;
----
--ZAD6
create or replace function placa_netto(placa numeric,podatek numeric default 0.2)
returns numeric as
$$
begin
return placa*(1-podatek);
end;
$$
language plpgsql;
----
--ZAD7
create or replace function podwyzka(id_z pracownicy.id_zesp%type, pod numeric default 0.15)
returns void as
$$
begin
update pracownicy set placa_pod =placa_pod*(1+pod) where id_zesp=id_z;
end;
$$
language plpgsql;
----
--ZAD8
create or replace function podwyzka(id_z pracownicy.id_zesp%type, pod numeric default 0.15)
returns void as
$$
declare
cnt int;
begin
select count(*) from zespoly where id_zesp=id_z into cnt;
if cnt = 0 then 
raise exception 'Zespol nie istnieje';
end if;
update pracownicy set placa_pod =placa_pod*(1+pod) where id_zesp=id_z;
end;
$$
language plpgsql;
----
--ZAD9
create or replace function staz(d date)
  returns int as
$$
begin
  return extract(year from age(now(),d));
end;
$$
  language plpgsql;
----
--ZAD10
update pracownicy set placa_pod=(select placa_od from etaty where nazwa=etat) where placa_pod<(select placa_od from etaty where nazwa=etat);
update pracownicy set placa_pod=(select placa_do from etaty where nazwa=etat) where placa_pod>(select placa_do from etaty where nazwa=etat);
create or replace function qqq(e pracownicy.etat%type, p pracownicy.placa_pod%type)
  returns boolean as
$$
declare
  min_ etaty.placa_od%type;
  max_ etaty.placa_do%type;
begin
  select placa_od from etaty where nazwa=e into min_;
  select placa_do from etaty where nazwa=e into max_;
  if p<min_ then
    return false;
  end if;
  if p>max_ then
    return false;
  end if;
  return true;
end;
$$
  language plpgsql;
alter table pracownicy add check(qqq(etat,placa_pod));
----