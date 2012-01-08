--ZAD1
CREATE SEQUENCE seqtrig start 5 increment 10;
create or replace function trigger1() returns trigger AS $$
begin
    NEW.id_zesp = nextval('seqtrig');
    return NEW;
end;
$$ language plpgsql;
CREATE TRIGGER trigger1 before insert on zespoly for each row execute procedure trigger1();
INSERT INTO zespoly VALUES (null,'a','b');
INSERT INTO zespoly VALUES (null,'c','d');
----
--ZAD2
CREATE TABLE historia (id_prac numeric(4,0),placa_pod numeric(6,2),etat varchar(15), id_zesp numeric(2,0), data timestamp);
create or replace function trigger2() returns trigger as $$
begin
    NEW.id_prac=OLD.id_prac;
    if (NEW.placa_pod is null != OLD.placa_pod is null) or (NEW.placa_pod != OLD.placa_pod) or
       (NEW.etat is null != OLD.etat is null) or (NEW.etat != OLD.etat) or
       (NEW.id_zesp is null != OLD.id_zesp is null) or (NEW.id_zesp != OLD.id_zesp) then
        insert into historia values (OLD.id_prac,OLD.placa_pod,OLD.etat,OLD.id_zesp,now());
    end if;
    return NEW;
end;
$$ language plpgsql;
CREATE trigger trigger2 BEFORE UPDATE on pracownicy for each row execute procedure trigger2();
----
--ZAD3
--ZAD4
create or replace function trigger3() returns trigger as $$
declare
    c int;
begin
    if NEW.ref is null then
        raise exception 'Bad reference';
    end if;
    if NEW.type='Ph' then
        select count(*) from photos where id=NEW.ref into c;
    elsif NEW.type='Pe' then
        select count(*) from persons where id=NEW.ref into c;
    else
        raise exception 'Bad reference';
    end if;
    if c!=1 then
        raise exception 'Bad reference';
    end if;
    return NEW;
end;
$$ language plpgsql;
create trigger trigger3 before insert or update on comments
for each row execute procedure trigger3();
----
--ZAD4
create or replace function trigger4a() returns trigger as $$
begin
  delete from comments where ref=OLD.id and type='Ph';
  return OLD;
end;
$$ language plpgsql;
create or replace function trigger4b() returns trigger as $$
begin
  delete from comments where ref=OLD.id and type='Pe';
  return OLD;
end;
$$ language plpgsql;
create trigger trigger4a after delete on photos
for each row execute procedure trigger4a();
create trigger trigger4b after delete on persons
for each row execute procedure trigger4b();
----
--ZAD5
--ZAD6
create view profesorowie as select id_prac as "id",imie,nazwisko,zatrudniony,placa_pod from pracownicy where etat='PROFESOR';
create rule rule5 as on insert to profesorowie do instead insert into pracownicy (etat,id_prac,imie,nazwisko,zatrudniony,placa_pod) values ('PROFESOR',NEW.id,NEW.imie,NEW.nazwisko,NEW.zatrudniony,NEW.placa_pod);
----
--ZAD6
create rule rule6 as on delete to profesorowie do instead delete from pracownicy where id_prac =OLD.id;
----
--ZAD7
create table profesorowie (id numeric(4,0),imie varchar(15),nazwisko varchar(15),zatrudniony date,placa_pod numeric(6,2));
create rule "_RETURN" as on select to profesorowie do instead select id_prac as id,imie,nazwisko,zatrudniony,placa_pod from pracownicy where etat='PROFESOR';
----
--ZAD8
create view place_minimalne as select * from pracownicy where placa_pod<1500;
create or replace function trigger8a() returns trigger as $$
begin
  if NEW.placa_pod<=1500 then
    insert into pracownicy values (NEW.id_prac,NEW.nazwisko,NEW.imie,NEW.etat,NEW.id_szefa,NEW.zatrudniony,NEW.placa_pod,NEW.placa_dod,NEW.id_zesp);
  end if;
  return NEW;
end;
$$ language plpgsql;
create trigger trigger8a instead of insert on place_minimalne
for each row execute procedure trigger8a();
create or replace function trigger8b() returns trigger as $$
begin
  if NEW.placa_pod<=1500 then
    update pracownicy set id_prac=NEW.id_prac, nazwisko=NEW.nazwisko, imie=NEW.imie, etat=NEW.etat,id_szefa=NEW.id_szefa,zatrudniony=NEW.zatrudniony,placa_pod=NEW.placa_pod,placa_dod=NEW.placa_dod,id_zesp=NEW.id_zesp where id_prac=OLD.id_prac;
    return NEW;
  else
    return OLD;
  end if;
end;
$$ language plpgsql;
create trigger trigger8b instead of update on place_minimalne
for each row execute procedure trigger8b();
----
--ZAD9
create view prac_szef as select p.id_prac,p.nazwisko,p.etat,p.id_szefa,s.nazwisko as nazwisko_szefa from pracownicy p left join pracownicy s on p.id_szefa=s.id_prac order by p.id_prac,p.nazwisko,p.etat,p.id_szefa,s.nazwisko;
create rule rule9a as on insert to prac_szef do instead insert into pracownicy (id_prac,nazwisko,etat,id_szefa) VALUES (NEW.id_prac,NEW.nazwisko,NEW.etat,NEW.id_szefa);
create rule rule9b as on update to prac_szef do instead update pracownicy set id_prac=NEW.id_prac,nazwisko=NEW.nazwisko,etat=NEW.etat,id_szefa=NEW.id_szefa where id_prac=OLD.id_prac;
create rule rule9c as on delete to prac_szef do instead delete from pracownicy where id_prac=OLD.id_prac;
----
--ZAD10
--ZAD11
create table czytelnicy(pesel char(11) primary key,imie varchar(100) not null, nazwisko varchar(100) not null);
create table ksiazki(id_ksiazki numeric(6) primary key, autor varchar(100) not null, tytul varchar(1000) not null);
create table wypozyczenia(id_ksiazki numeric(6) not null, pesel char(11) not null, data date not null, stan varchar(100) not null check(stan='wypozyczenie' or stan='zwrot'));
----
--ZAD11
create or replace function check_pesel() returns trigger as $$
declare
    a int;
    b int;
    c int;
    d int;
    e int;
    f int;
    g int;
    h int;
    i int;
    j int;
    k int;
begin
    a=cast(substr(new.pesel,1,1) as int);
    b=cast(substr(new.pesel,2,1) as int);
    c=cast(substr(new.pesel,3,1) as int);
    d=cast(substr(new.pesel,4,1) as int);
    e=cast(substr(new.pesel,5,1) as int);
    f=cast(substr(new.pesel,6,1) as int);
    g=cast(substr(new.pesel,7,1) as int);
    h=cast(substr(new.pesel,8,1) as int);
    i=cast(substr(new.pesel,9,1) as int);
    j=cast(substr(new.pesel,10,1) as int);
    k=cast(substr(new.pesel,11,1) as int);
    if (a+3*b+7*c+9*d+e+3*f+7*g+9*h+i+3*j+k)%10 = 0 then
        return new;
    end if;
    return null;
end;
$$ language plpgsql;
create trigger trigger11pesel before insert on czytelnicy
for each row execute procedure check_pesel();
create or replace function check_wypozyczenia5() returns trigger as $$
declare
    c1 int;
    c2 int;
begin
    select count(*) from wypozyczenia where pesel=NEW.pesel and stan='wypozyczenie' into c1;
    select count(*) from wypozyczenia where pesel=NEW.pesel and stan='zwrot' into c2;
    if c1-c2=5 and NEW.stan='wypozyczenie' then
        return null;
    else
        return NEW;
    end if;
end;
$$ language plpgsql;
create trigger trigger11wypozyczenia5 before insert on wypozyczenia
for row execute procedure check_wypozyczenia5();
create or replace function check_day() returns trigger as $$
begin
    if extract(isodow from new.data)=7 or extract(day from new.data)=1 or extract(day from new.data + interval '1 day')=1 then
        return null;
    else
        return NEW;
    end if;
end;
$$ language plpgsql;
create trigger trigger11day before insert on wypozyczenia
for row execute procedure check_day();
create or replace function check_zw() returns trigger as $$
declare
    c1 int;
    c2 int;
    wypoz date;
begin
    select count(*) from wypozyczenia where pesel=NEW.pesel and id_ksiazki=NEW.id_ksiazki and stan='wypozyczenie' into c1;
    select count(*) from wypozyczenia where pesel=NEW.pesel and id_ksiazki=NEW.id_ksiazki and stan='zwrot' into c2;
    if NEW.stan='zwrot'then
        if c1!=c2+1 then 
            return null;
        else
            select data from wypozyczenia where pesel=NEW.pesel and id_ksiazki=NEW.id_ksiazki and stan='wypozyczenie' order by data desc limit 1 into wypoz;
            if wypoz > NEW.data then
                return null;
            end if;
        end if;
    end if;
    return NEW;
end;
$$ language plpgsql;
create trigger trigger11zw before insert on wypozyczenia
for row execute procedure check_zw();
create or replace function check_poz() returns trigger as $$
declare
    c1 int;
    c2 int;
begin
    select count(*) from wypozyczenia where id_ksiazki=NEW.id_ksiazki and stan='wypozyczenie' into c1;
    select count(*) from wypozyczenia where id_ksiazki=NEW.id_ksiazki and stan='zwrot' into c2;
    if NEW.stan='wypozyczenie' and c1!=c2 then
        return null;
    end if;
    return NEW;
end;
$$ language plpgsql;
create trigger trigger11poz before insert on wypozyczenia
for row execute procedure check_poz();
----