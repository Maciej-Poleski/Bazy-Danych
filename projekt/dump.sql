--
-- PostgreSQL database dump
--

-- Dumped from database version 9.2.2
-- Dumped by pg_dump version 9.2.2
-- Started on 2013-01-23 19:14:50 CET

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- TOC entry 7 (class 2615 OID 41555)
-- Name: tcs; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA "tcs";


SET search_path = "tcs", pg_catalog;

--
-- TOC entry 650 (class 1247 OID 42155)
-- Name: id_string_pair; Type: TYPE; Schema: tcs; Owner: -
--

CREATE TYPE "id_string_pair" AS (
	"id" integer,
	"string" "text"
);


--
-- TOC entry 248 (class 1255 OID 42072)
-- Name: add_device(character varying); Type: FUNCTION; Schema: tcs; Owner: -
--

CREATE FUNCTION "add_device"("_name" character varying) RETURNS integer
    LANGUAGE "plpgsql"
    AS $$declare
	result integer;
begin
	insert into tcs."urządzenie" values (default,_name) returning id into result;
	return result;
end;$$;


--
-- TOC entry 267 (class 1255 OID 42110)
-- Name: add_inspection(integer, integer, timestamp with time zone); Type: FUNCTION; Schema: tcs; Owner: -
--

CREATE FUNCTION "add_inspection"("_location" integer, "_officer" integer, "_datetime" timestamp with time zone) RETURNS integer
    LANGUAGE "plpgsql"
    AS $$
declare
	result integer;
begin
	insert into tcs.kontrola values(default,_location,_officer,_datetime) returning id into result;
	return result;
end;$$;


--
-- TOC entry 291 (class 1255 OID 42168)
-- Name: add_location(character varying, character varying, character varying, character varying); Type: FUNCTION; Schema: tcs; Owner: -
--

CREATE FUNCTION "add_location"("_name" character varying, "_gps_coordinates" character varying, "_city" character varying, "_street" character varying) RETURNS integer
    LANGUAGE "plpgsql"
    AS $$
declare
	result integer;
begin
	insert into tcs.miejsce values(default,_name, _gps_coordinates, _city, _street) returning id into result;
	return result;
end;$$;


--
-- TOC entry 294 (class 1255 OID 42172)
-- Name: add_offense(character varying, integer, integer, integer, integer); Type: FUNCTION; Schema: tcs; Owner: -
--

CREATE FUNCTION "add_offense"("_name" character varying, "_price_min" integer, "_price_max" integer, "min_points" integer, "max_points" integer) RETURNS integer
    LANGUAGE "plpgsql"
    AS $$declare
	result integer;
begin
	insert into tcs.wykroczenia values (default,_price_min,_price_max,_name,min_points, max_points) returning id into result;
	return result;
end;$$;


--
-- TOC entry 251 (class 1255 OID 42079)
-- Name: add_offense_device(integer, integer); Type: FUNCTION; Schema: tcs; Owner: -
--

CREATE FUNCTION "add_offense_device"("_offense" integer, "_device" integer) RETURNS "void"
    LANGUAGE "plpgsql"
    AS $$begin
	insert into tcs.wykroczenia_urządzenia values (_offense,_device);
end;$$;


--
-- TOC entry 297 (class 1255 OID 42191)
-- Name: add_officer(integer, integer, integer, integer, integer); Type: FUNCTION; Schema: tcs; Owner: -
--

CREATE FUNCTION "add_officer"("_person" integer, "_position" integer, "_station" integer, "_salary" integer, "_superior" integer) RETURNS integer
    LANGUAGE "plpgsql"
    AS $$
declare
	result integer;
begin
	insert into tcs.policjant values(default,_person,_position,_station,_salary, _superior) returning id into result;
	return result;
end;$$;


--
-- TOC entry 245 (class 1255 OID 42019)
-- Name: add_person(character varying, character varying, "bytea"); Type: FUNCTION; Schema: tcs; Owner: -
--

CREATE FUNCTION "add_person"("_first_name" character varying, "_last_name" character varying, "_photo" "bytea" DEFAULT NULL::"bytea") RETURNS integer
    LANGUAGE "plpgsql"
    AS $$declare
	result integer;
begin
	insert into tcs."człowiek" values(_first_name,_last_name,default,_photo) returning id into result;
	return result;
end;$$;


--
-- TOC entry 246 (class 1255 OID 42021)
-- Name: add_position(character varying); Type: FUNCTION; Schema: tcs; Owner: -
--

CREATE FUNCTION "add_position"("_name" character varying) RETURNS integer
    LANGUAGE "plpgsql"
    AS $$declare
	result integer;
begin
	insert into tcs.etat values(default,_name) returning id into result;
	return result;
end;$$;


--
-- TOC entry 255 (class 1255 OID 42088)
-- Name: add_station(integer); Type: FUNCTION; Schema: tcs; Owner: -
--

CREATE FUNCTION "add_station"("_location" integer) RETURNS integer
    LANGUAGE "plpgsql"
    AS $$
declare
	result integer;
begin
	insert into tcs.komisariat values(default,_location) returning id into result;
	return result;
end;$$;


--
-- TOC entry 302 (class 1255 OID 42211)
-- Name: add_ticket(integer, integer, integer, integer, integer); Type: FUNCTION; Schema: tcs; Owner: -
--

CREATE FUNCTION "add_ticket"("_offense" integer, "_inspection" integer, "_person" integer, "_price" integer, "_points" integer) RETURNS integer
    LANGUAGE "plpgsql"
    AS $$declare
	result integer;
begin
	insert into tcs.mandat values(default,_offense,_inspection,_person,_price,_points) returning id into result;
	return result;
end;$$;


--
-- TOC entry 258 (class 1255 OID 42093)
-- Name: add_ticket_device(integer, integer); Type: FUNCTION; Schema: tcs; Owner: -
--

CREATE FUNCTION "add_ticket_device"("_ticket" integer, "_device" integer) RETURNS "void"
    LANGUAGE "plpgsql"
    AS $$begin
	insert into tcs.mandat_urządzenia values(_ticket,_device);
end;$$;


--
-- TOC entry 247 (class 1255 OID 42037)
-- Name: check_fine_offense(integer, integer); Type: FUNCTION; Schema: tcs; Owner: -
--

CREATE FUNCTION "check_fine_offense"("_price" integer, "_offense" integer) RETURNS boolean
    LANGUAGE "plpgsql"
    AS $$declare
	min integer;
	max integer;
begin
	select cena_od from tcs.wykroczenia where id=_offense into min;
	select cena_do from tcs.wykroczenia where id=_offense into max;
	if min>_price then
		return false;
	elsif max<_price then
		return false;
	else
		return true;
	end if;
end;$$;


--
-- TOC entry 249 (class 1255 OID 42073)
-- Name: delete_device(integer); Type: FUNCTION; Schema: tcs; Owner: -
--

CREATE FUNCTION "delete_device"("_id" integer) RETURNS "void"
    LANGUAGE "plpgsql"
    AS $$
begin
	delete from tcs."urządzenie" where id=_id;
end;
$$;


--
-- TOC entry 239 (class 1255 OID 41983)
-- Name: delete_inspection(integer); Type: FUNCTION; Schema: tcs; Owner: -
--

CREATE FUNCTION "delete_inspection"("_id" integer) RETURNS "void"
    LANGUAGE "plpgsql"
    AS $$
begin
	delete from tcs.kontrola where id=_id;
end;
$$;


--
-- TOC entry 252 (class 1255 OID 42081)
-- Name: delete_location(integer); Type: FUNCTION; Schema: tcs; Owner: -
--

CREATE FUNCTION "delete_location"("_id" integer) RETURNS "void"
    LANGUAGE "plpgsql"
    AS $$
begin
	delete from tcs.miejsce where id=_id;
end;
$$;


--
-- TOC entry 240 (class 1255 OID 41984)
-- Name: delete_offense(integer); Type: FUNCTION; Schema: tcs; Owner: -
--

CREATE FUNCTION "delete_offense"("_id" integer) RETURNS "void"
    LANGUAGE "plpgsql"
    AS $$
begin
	delete from tcs.wykroczenia where id=_id;
end;
$$;


--
-- TOC entry 268 (class 1255 OID 42112)
-- Name: delete_offense_device(integer, integer); Type: FUNCTION; Schema: tcs; Owner: -
--

CREATE FUNCTION "delete_offense_device"("_offense" integer, "_device" integer) RETURNS "void"
    LANGUAGE "plpgsql"
    AS $$
begin
	delete from tcs."wykroczenia_urządzenia" where wykroczenie_id=_offense and urządzenie_id=_device;
end;
$$;


--
-- TOC entry 253 (class 1255 OID 42085)
-- Name: delete_officer(integer); Type: FUNCTION; Schema: tcs; Owner: -
--

CREATE FUNCTION "delete_officer"("_id" integer) RETURNS "void"
    LANGUAGE "plpgsql"
    AS $$
begin
	delete from tcs.policjant where id=_id;
end;
$$;


--
-- TOC entry 241 (class 1255 OID 41986)
-- Name: delete_person(integer); Type: FUNCTION; Schema: tcs; Owner: -
--

CREATE FUNCTION "delete_person"("_id" integer) RETURNS "void"
    LANGUAGE "plpgsql"
    AS $$
begin
	delete from tcs."człowiek" where id=_id;
end;
$$;


--
-- TOC entry 242 (class 1255 OID 41988)
-- Name: delete_position(integer); Type: FUNCTION; Schema: tcs; Owner: -
--

CREATE FUNCTION "delete_position"("_id" integer) RETURNS "void"
    LANGUAGE "plpgsql"
    AS $$
begin
	delete from tcs.etat where id=_id;
end;
$$;


--
-- TOC entry 256 (class 1255 OID 42089)
-- Name: delete_station(integer); Type: FUNCTION; Schema: tcs; Owner: -
--

CREATE FUNCTION "delete_station"("_id" integer) RETURNS "void"
    LANGUAGE "plpgsql"
    AS $$begin
	delete from tcs.komisariat where id=_id;
end;$$;


--
-- TOC entry 259 (class 1255 OID 42094)
-- Name: delete_ticket(integer); Type: FUNCTION; Schema: tcs; Owner: -
--

CREATE FUNCTION "delete_ticket"("_id" integer) RETURNS "void"
    LANGUAGE "plpgsql"
    AS $$
begin
	delete from tcs.mandat where id=_id;
end;
$$;


--
-- TOC entry 260 (class 1255 OID 42095)
-- Name: delete_ticket_device(integer, integer); Type: FUNCTION; Schema: tcs; Owner: -
--

CREATE FUNCTION "delete_ticket_device"("_ticket" integer, "_device" integer) RETURNS "void"
    LANGUAGE "plpgsql"
    AS $$
begin
	delete from tcs."mandat_urządzenia" where mandat_id=_ticket and urządzenie_id=_device;
end;
$$;


SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 196 (class 1259 OID 41623)
-- Name: urządzenie; Type: TABLE; Schema: tcs; Owner: -; Tablespace: 
--

CREATE TABLE "urządzenie" (
    "id" integer NOT NULL,
    "nazwa" character varying NOT NULL
);


--
-- TOC entry 275 (class 1255 OID 42143)
-- Name: get_all_devices(); Type: FUNCTION; Schema: tcs; Owner: -
--

CREATE FUNCTION "get_all_devices"() RETURNS SETOF "urządzenie"
    LANGUAGE "plpgsql" IMMUTABLE
    AS $$begin
	return query select * from tcs."urządzenie";
end;$$;


--
-- TOC entry 199 (class 1259 OID 41633)
-- Name: miejsce; Type: TABLE; Schema: tcs; Owner: -; Tablespace: 
--

CREATE TABLE "miejsce" (
    "id" integer NOT NULL,
    "nazwa" character varying NOT NULL,
    "gps_coordinates" character varying,
    "city" character varying,
    "street" character varying
);


--
-- TOC entry 279 (class 1255 OID 42147)
-- Name: get_all_locations(); Type: FUNCTION; Schema: tcs; Owner: -
--

CREATE FUNCTION "get_all_locations"() RETURNS SETOF "miejsce"
    LANGUAGE "plpgsql" IMMUTABLE
    AS $$begin
	return query select * from tcs.miejsce;
end;$$;


--
-- TOC entry 193 (class 1259 OID 41614)
-- Name: wykroczenia; Type: TABLE; Schema: tcs; Owner: -; Tablespace: 
--

CREATE TABLE "wykroczenia" (
    "id" integer NOT NULL,
    "cena_od" integer NOT NULL,
    "cena_do" integer NOT NULL,
    "nazwa" character varying NOT NULL,
    "min_points" integer,
    "max_points" integer,
    CONSTRAINT "wykroczenia_check" CHECK (("cena_od" <= "cena_do")),
    CONSTRAINT "wykroczenia_check1" CHECK (("min_points" <= "max_points"))
);


--
-- TOC entry 277 (class 1255 OID 42145)
-- Name: get_all_offenses(); Type: FUNCTION; Schema: tcs; Owner: -
--

CREATE FUNCTION "get_all_offenses"() RETURNS SETOF "wykroczenia"
    LANGUAGE "plpgsql" IMMUTABLE
    AS $$begin
	return query select * from tcs.wykroczenia;
end;$$;


--
-- TOC entry 194 (class 1259 OID 41617)
-- Name: etat; Type: TABLE; Schema: tcs; Owner: -; Tablespace: 
--

CREATE TABLE "etat" (
    "id" integer NOT NULL,
    "nazwa" character varying NOT NULL
);


--
-- TOC entry 281 (class 1255 OID 42149)
-- Name: get_all_ranks(); Type: FUNCTION; Schema: tcs; Owner: -
--

CREATE FUNCTION "get_all_ranks"() RETURNS SETOF "etat"
    LANGUAGE "plpgsql" IMMUTABLE
    AS $$begin
	return query select * from tcs.etat;
end;$$;


--
-- TOC entry 276 (class 1255 OID 42144)
-- Name: get_device(integer); Type: FUNCTION; Schema: tcs; Owner: -
--

CREATE FUNCTION "get_device"("_id" integer) RETURNS "urządzenie"
    LANGUAGE "plpgsql" IMMUTABLE
    AS $$declare
	r tcs."urządzenie"%rowtype;
begin
	select * from tcs."urządzenie" where id=_id into r;
	return r;
end;
$$;


--
-- TOC entry 290 (class 1255 OID 42167)
-- Name: get_device_list(); Type: FUNCTION; Schema: tcs; Owner: -
--

CREATE FUNCTION "get_device_list"() RETURNS SETOF "id_string_pair"
    LANGUAGE "plpgsql" STABLE
    AS $$begin
	return query select id,nazwa::text  from tcs."urządzenie";
end;$$;


--
-- TOC entry 262 (class 1255 OID 42156)
-- Name: get_devices_by_ticket_id(integer); Type: FUNCTION; Schema: tcs; Owner: -
--

CREATE FUNCTION "get_devices_by_ticket_id"("_ticket" integer) RETURNS SETOF "id_string_pair"
    LANGUAGE "plpgsql" IMMUTABLE
    AS $$begin
	return query select tcs.mandat_urządzenia.urządzenie_id as id, nazwa::text from tcs.mandat_urządzenia join tcs.urządzenie on "urządzenie_id"=tcs."urządzenie".id where mandat_id=_ticket;
end;$$;


--
-- TOC entry 197 (class 1259 OID 41626)
-- Name: kontrola; Type: TABLE; Schema: tcs; Owner: -; Tablespace: 
--

CREATE TABLE "kontrola" (
    "id" integer NOT NULL,
    "miejsce_id" integer NOT NULL,
    "policjant_id" integer,
    "datetime" timestamp with time zone NOT NULL
);


--
-- TOC entry 272 (class 1255 OID 42140)
-- Name: get_inspection(integer); Type: FUNCTION; Schema: tcs; Owner: -
--

CREATE FUNCTION "get_inspection"("_id" integer) RETURNS "kontrola"
    LANGUAGE "plpgsql" IMMUTABLE
    AS $$declare
	r tcs.kontrola%rowtype;
begin
	select * from tcs.kontrola where id=_id into r;
	return r;
end;$$;


--
-- TOC entry 283 (class 1255 OID 42157)
-- Name: get_inspections_by_officer_id(integer); Type: FUNCTION; Schema: tcs; Owner: -
--

CREATE FUNCTION "get_inspections_by_officer_id"("_officer" integer) RETURNS SETOF "id_string_pair"
    LANGUAGE "plpgsql" IMMUTABLE
    AS $$begin
	return query select tcs.kontrola.id, imie || ' ' || nazwisko || ' ' || tcs.miejsce.nazwa from tcs.kontrola join tcs.policjant on policjant_id=tcs.policjant.id join tcs."człowiek" on tcs.policjant.czlowiek_id=tcs."człowiek".id join tcs.miejsce on miejsce_id=tcs.miejsce.id where policjant_id=_officer;
end;$$;


--
-- TOC entry 280 (class 1255 OID 42148)
-- Name: get_location(integer); Type: FUNCTION; Schema: tcs; Owner: -
--

CREATE FUNCTION "get_location"("_id" integer) RETURNS "miejsce"
    LANGUAGE "plpgsql" IMMUTABLE
    AS $$declare
	r tcs.miejsce%rowtype;
begin
	select * from tcs.miejsce where id=_id into r;
	return r;
end;$$;


--
-- TOC entry 278 (class 1255 OID 42146)
-- Name: get_offense(integer); Type: FUNCTION; Schema: tcs; Owner: -
--

CREATE FUNCTION "get_offense"("_id" integer) RETURNS "wykroczenia"
    LANGUAGE "plpgsql" IMMUTABLE
    AS $$declare
	r tcs.wykroczenia%rowtype;
begin
	select * from tcs.wykroczenia where id=_id into r;
	return r;
end;$$;


--
-- TOC entry 289 (class 1255 OID 42166)
-- Name: get_offense_list(); Type: FUNCTION; Schema: tcs; Owner: -
--

CREATE FUNCTION "get_offense_list"() RETURNS SETOF "id_string_pair"
    LANGUAGE "plpgsql" STABLE
    AS $$begin
	return query select id,nazwa::text || ' ' || cena_od::text || '-' || cena_do::text || ' PLN' from tcs.wykroczenia;
end;$$;


--
-- TOC entry 190 (class 1259 OID 41570)
-- Name: policjant; Type: TABLE; Schema: tcs; Owner: -; Tablespace: 
--

CREATE TABLE "policjant" (
    "id" integer NOT NULL,
    "czlowiek_id" integer NOT NULL,
    "etat_id" integer NOT NULL,
    "komisariat_id" integer NOT NULL,
    "salary" integer,
    "superior" integer
);


--
-- TOC entry 271 (class 1255 OID 42136)
-- Name: get_officer(integer); Type: FUNCTION; Schema: tcs; Owner: -
--

CREATE FUNCTION "get_officer"("_id" integer) RETURNS "policjant"
    LANGUAGE "plpgsql" IMMUTABLE
    AS $$declare
	r tcs.policjant%rowtype;
begin
	select * from tcs.policjant where id=_id into r;
	return r;
end;$$;


--
-- TOC entry 284 (class 1255 OID 42158)
-- Name: get_officer_list(); Type: FUNCTION; Schema: tcs; Owner: -
--

CREATE FUNCTION "get_officer_list"() RETURNS SETOF "id_string_pair"
    LANGUAGE "plpgsql" STABLE
    AS $$begin
	return query select tcs.policjant.id, imie || ' ' || nazwisko || ' ' || nazwa from tcs.policjant join tcs."człowiek" on czlowiek_id=tcs."człowiek".id join tcs.etat on etat_id=tcs.etat.id;
end;$$;


--
-- TOC entry 301 (class 1255 OID 42195)
-- Name: get_officers_by_station_id(integer); Type: FUNCTION; Schema: tcs; Owner: -
--

CREATE FUNCTION "get_officers_by_station_id"("_station" integer) RETURNS SETOF "id_string_pair"
    LANGUAGE "plpgsql" IMMUTABLE
    AS $$begin
	return query select tcs.policjant.id, (select string from tcs.get_officer_list() where id=tcs.policjant.id) from tcs.policjant where tcs.policjant.komisariat_id=_station;
end;$$;


--
-- TOC entry 285 (class 1255 OID 42159)
-- Name: get_people_list(); Type: FUNCTION; Schema: tcs; Owner: -
--

CREATE FUNCTION "get_people_list"() RETURNS SETOF "id_string_pair"
    LANGUAGE "plpgsql" IMMUTABLE
    AS $$begin
	return query select id,imie || ' ' || nazwisko from tcs."człowiek";
end;
$$;


--
-- TOC entry 189 (class 1259 OID 41556)
-- Name: człowiek; Type: TABLE; Schema: tcs; Owner: -; Tablespace: 
--

CREATE TABLE "człowiek" (
    "imie" character varying NOT NULL,
    "nazwisko" character varying NOT NULL,
    "id" integer NOT NULL,
    "photo" "bytea"
);


--
-- TOC entry 270 (class 1255 OID 42133)
-- Name: get_person(integer); Type: FUNCTION; Schema: tcs; Owner: -
--

CREATE FUNCTION "get_person"("_id" integer) RETURNS "człowiek"
    LANGUAGE "plpgsql" IMMUTABLE
    AS $$declare
	r tcs."człowiek"%rowtype;
begin
	select * from tcs."człowiek" where id=_id into r;
	return r;
end;$$;


--
-- TOC entry 282 (class 1255 OID 42150)
-- Name: get_rank(integer); Type: FUNCTION; Schema: tcs; Owner: -
--

CREATE FUNCTION "get_rank"("_id" integer) RETURNS "etat"
    LANGUAGE "plpgsql" IMMUTABLE
    AS $$declare
	r tcs.etat%rowtype;
begin
	select * from tcs.etat where id=_id into r;
	return r;
end;$$;


--
-- TOC entry 288 (class 1255 OID 42165)
-- Name: get_rank_list(); Type: FUNCTION; Schema: tcs; Owner: -
--

CREATE FUNCTION "get_rank_list"() RETURNS SETOF "id_string_pair"
    LANGUAGE "plpgsql" STABLE
    AS $$begin
	return query select id,nazwa::text from tcs.etat;
end;$$;


--
-- TOC entry 198 (class 1259 OID 41630)
-- Name: komisariat; Type: TABLE; Schema: tcs; Owner: -; Tablespace: 
--

CREATE TABLE "komisariat" (
    "id" integer NOT NULL,
    "miejsce_id" integer NOT NULL
);


--
-- TOC entry 274 (class 1255 OID 42138)
-- Name: get_station(integer); Type: FUNCTION; Schema: tcs; Owner: -
--

CREATE FUNCTION "get_station"("_id" integer) RETURNS "komisariat"
    LANGUAGE "plpgsql" IMMUTABLE
    AS $$declare
	r tcs.komisariat%rowtype;
begin
	select * from tcs.komisariat where id=_id into r;
	return r;
end;$$;


--
-- TOC entry 286 (class 1255 OID 42163)
-- Name: get_station_list(); Type: FUNCTION; Schema: tcs; Owner: -
--

CREATE FUNCTION "get_station_list"() RETURNS SETOF "id_string_pair"
    LANGUAGE "plpgsql" IMMUTABLE
    AS $$begin
	return query select tcs.komisariat.id,nazwa::text from tcs.komisariat join tcs.miejsce on miejsce_id=tcs.miejsce.id;
end;$$;


--
-- TOC entry 195 (class 1259 OID 41620)
-- Name: mandat; Type: TABLE; Schema: tcs; Owner: -; Tablespace: 
--

CREATE TABLE "mandat" (
    "id" integer NOT NULL,
    "wykroczenie_id" integer NOT NULL,
    "kontrola_id" integer NOT NULL,
    "człowiek_id" integer NOT NULL,
    "cena" integer NOT NULL,
    "points" integer,
    CONSTRAINT "mandat_check" CHECK ("check_fine_offense"("cena", "wykroczenie_id"))
);


--
-- TOC entry 273 (class 1255 OID 42142)
-- Name: get_ticket(integer); Type: FUNCTION; Schema: tcs; Owner: -
--

CREATE FUNCTION "get_ticket"("_id" integer) RETURNS "mandat"
    LANGUAGE "plpgsql" IMMUTABLE
    AS $$declare
	r tcs.mandat%rowtype;
begin
	select * from tcs.mandat where id=_id into r;
	return r;
end;$$;


--
-- TOC entry 300 (class 1255 OID 42194)
-- Name: get_tickets_by_inspection_id(integer); Type: FUNCTION; Schema: tcs; Owner: -
--

CREATE FUNCTION "get_tickets_by_inspection_id"("_inspection" integer) RETURNS SETOF "id_string_pair"
    LANGUAGE "plpgsql" IMMUTABLE
    AS $$begin
	return query select tcs.mandat.id, tcs.wykroczenia.nazwa || ' Cena: ' || tcs.mandat.cena::text from tcs.mandat join tcs.kontrola on tcs.mandat.kontrola_id=tcs.kontrola.id join tcs.wykroczenia on tcs.mandat.wykroczenie_id=tcs.wykroczenia.id where tcs.kontrola.id=_inspection;
end;$$;


--
-- TOC entry 287 (class 1255 OID 42164)
-- Name: get_tickets_by_person_id(integer); Type: FUNCTION; Schema: tcs; Owner: -
--

CREATE FUNCTION "get_tickets_by_person_id"("_person" integer) RETURNS SETOF "id_string_pair"
    LANGUAGE "plpgsql" IMMUTABLE
    AS $$begin
	return query select tcs.mandat.id, nazwa || ' Cena: ' || cena::text from tcs.mandat join tcs.wykroczenia on wykroczenie_id=tcs.wykroczenia.id where "człowiek_id"=_person;
end;$$;


--
-- TOC entry 254 (class 1255 OID 42113)
-- Name: set_person_photo(integer, "bytea"); Type: FUNCTION; Schema: tcs; Owner: -
--

CREATE FUNCTION "set_person_photo"("_person" integer, "_photo" "bytea") RETURNS "void"
    LANGUAGE "plpgsql"
    AS $$begin
	update tcs.człowiek set photo=_photo where id=_person;
end;$$;


--
-- TOC entry 250 (class 1255 OID 42076)
-- Name: update_device(integer, character varying); Type: FUNCTION; Schema: tcs; Owner: -
--

CREATE FUNCTION "update_device"("_id" integer, "_name" character varying) RETURNS "void"
    LANGUAGE "plpgsql"
    AS $$begin
	update tcs."urządzenie" set nazwa=_name where id=_id;
end;$$;


--
-- TOC entry 264 (class 1255 OID 42101)
-- Name: update_device_checked(integer, character varying, character varying); Type: FUNCTION; Schema: tcs; Owner: -
--

CREATE FUNCTION "update_device_checked"("_id" integer, "_name" character varying, "old_name" character varying) RETURNS boolean
    LANGUAGE "plpgsql"
    AS $$
declare
	real_old_name character varying;
begin
	select nazwa from tcs."urządzenie" where id=_id into real_old_name;
	if old_name is distinct from real_old_name then
		return false;
	end if;
	perform tcs.update_device(_id,_name);
	return true;
end;$$;


--
-- TOC entry 261 (class 1255 OID 42114)
-- Name: update_inspection(integer, integer, integer, timestamp with time zone); Type: FUNCTION; Schema: tcs; Owner: -
--

CREATE FUNCTION "update_inspection"("_id" integer, "_location" integer, "_officer" integer, "_datetime" timestamp with time zone) RETURNS "void"
    LANGUAGE "plpgsql"
    AS $$begin
	update tcs.kontrola set miejsce_id=_location, policjant_id=_officer, datetime=_datetime where id=_id;
end;$$;


--
-- TOC entry 269 (class 1255 OID 42115)
-- Name: update_inspection_checked(integer, integer, integer, timestamp with time zone, integer, integer, timestamp with time zone); Type: FUNCTION; Schema: tcs; Owner: -
--

CREATE FUNCTION "update_inspection_checked"("_id" integer, "_location" integer, "_officer" integer, "_datetime" timestamp with time zone, "_old_location" integer, "_old_officer" integer, "_old_datetime" timestamp with time zone) RETURNS boolean
    LANGUAGE "plpgsql"
    AS $$
declare
	real_old_place integer;
	real_old_cop integer;
	real_old_datetime timestamp with time zone;
begin
	select miejsce_id from tcs.kontrola where id=_id into real_old_place;
	select policjant_id from tcs.kontrola where id=_id into real_old_cop;
	select datetime from tcs.kontrola where id=_id into real_old_datetime;

	if real_old_place is distinct from _old_location or real_old_cop is distinct from _old_officer or real_old_datetime is distinct from _old_datetime then
		return false;
	end if;
	
	perform tcs.update_inspection(_id,_location,_officer,_datetime);
	return true;
end;$$;


--
-- TOC entry 292 (class 1255 OID 42169)
-- Name: update_location(integer, character varying, character varying, character varying, character varying); Type: FUNCTION; Schema: tcs; Owner: -
--

CREATE FUNCTION "update_location"("_id" integer, "_name" character varying, "_gps_coordinates" character varying, "_city" character varying, "_street" character varying) RETURNS "void"
    LANGUAGE "plpgsql"
    AS $$begin
	update tcs.miejsce set nazwa=_name, gps_coordinates=_gps_coordinates , city=_city , street=_street  where id=_id;
end;$$;


--
-- TOC entry 293 (class 1255 OID 42170)
-- Name: update_location_checked(integer, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying); Type: FUNCTION; Schema: tcs; Owner: -
--

CREATE FUNCTION "update_location_checked"("_id" integer, "_name" character varying, "_gps_coordinates" character varying, "_city" character varying, "_street" character varying, "old_name" character varying, "old_gps_coordinates" character varying, "old_city" character varying, "old_street" character varying) RETURNS boolean
    LANGUAGE "plpgsql"
    AS $$
declare
	real_old_name character varying;
	real_old_gps_coordinates character varying;
	real_old_city character varying;
	real_old_street character varying;
begin
	select nazwa from tcs.miejsce where id=_id into real_old_name;
	select gps_coordinates from tcs.miejsce where id=_id into real_old_gps_coordinates;
	select city from tcs.miejsce where id=_id into real_old_city;
	select street from tcs.miejsce where id=_id into real_old_street;

	if real_old_name is distinct from old_name or real_old_gps_coordinates is distinct from old_gps_coordinates or real_old_city is distinct from old_city or real_old_street is distinct from old_street then
		return false;
	end if;
	
	perform tcs.update_location(_id,_name,_gps_coordinates, _city, _street);
	return true;
end;$$;


--
-- TOC entry 295 (class 1255 OID 42173)
-- Name: update_offense(integer, character varying, integer, integer, integer, integer); Type: FUNCTION; Schema: tcs; Owner: -
--

CREATE FUNCTION "update_offense"("_id" integer, "name" character varying, "_price_min" integer, "_price_max" integer, "_min_points" integer, "_max_points" integer) RETURNS "void"
    LANGUAGE "plpgsql"
    AS $$begin
	update tcs.wykroczenia set cena_od=_price_min, cena_do=_price_max, nazwa=name,min_points=_min_points, max_points=_max_points where id=_id;
end;$$;


--
-- TOC entry 296 (class 1255 OID 42175)
-- Name: update_offense_checked(integer, character varying, integer, integer, integer, integer, character varying, integer, integer, integer, integer); Type: FUNCTION; Schema: tcs; Owner: -
--

CREATE FUNCTION "update_offense_checked"("_id" integer, "name" character varying, "price_min" integer, "price_max" integer, "_min_points" integer, "_max_points" integer, "old_name" character varying, "old_price_min" integer, "old_price_max" integer, "old_min_points" integer, "old_max_points" integer) RETURNS boolean
    LANGUAGE "plpgsql"
    AS $$
declare
	real_old_name character varying;
	real_old_price_min integer;
	real_old_price_max integer;
	real_old_min_points integer;
	real_old_max_points integer;
begin
	select nazwa from tcs.wykroczenia where id=_id into real_old_name;
	select cena_od from tcs.wykroczenia where id=_id into real_old_price_min;
	select cena_do from tcs.wykroczenia where id=_id into real_old_price_max;
	select min_points from tcs.wykroczenia where id=_id into real_old_min_points;
	select max_points from tcs.wykroczenia where id=_id into real_old_max_points;

	if real_old_name is distinct from old_name or real_old_price_min is distinct from old_price_min or real_old_price_max is distinct from old_price_max or real_old_min_points is distinct from old_min_points or real_old_max_points is distinct from old_max_points then
		return false;
	end if;
	
	perform tcs.update_offense(_id,name,price_min,price_max,_min_points,_max_points);
	return true;
end;$$;


--
-- TOC entry 298 (class 1255 OID 42192)
-- Name: update_officer(integer, integer, integer, integer, integer, integer); Type: FUNCTION; Schema: tcs; Owner: -
--

CREATE FUNCTION "update_officer"("_id" integer, "_person" integer, "_position" integer, "_station" integer, "_salary" integer, "_superior" integer) RETURNS "void"
    LANGUAGE "plpgsql"
    AS $$begin
	update tcs.policjant set "czlowiek_id"=_person, etat_id=_position, komisariat_id=_station, salary=_salary, superior=_superior where id=_id;
end;$$;


--
-- TOC entry 299 (class 1255 OID 42193)
-- Name: update_officer_checked(integer, integer, integer, integer, integer, integer, integer, integer, integer, integer, integer); Type: FUNCTION; Schema: tcs; Owner: -
--

CREATE FUNCTION "update_officer_checked"("_id" integer, "_person" integer, "_position" integer, "_station" integer, "_salary" integer, "_superior" integer, "old_person" integer, "old_position" integer, "old_station" integer, "old_salary" integer, "old_superior" integer) RETURNS boolean
    LANGUAGE "plpgsql"
    AS $$
declare
	real_old_person integer;
	real_old_position integer;
	real_old_commissariat integer;
	real_old_salary integer;
	real_old_superior integer;
begin
	select czlowiek_id from tcs.policjant where id=_id into real_old_person;
	select etat_id from tcs.policjant where id=_id into real_old_position;
	select komisariat_id from tcs.policjant where id=_id into real_old_commissariat;
	select salary from tcs.policjant where id=_id into real_old_salary;
	select superior from tcs.policjant where id=_id into real_old_superior;
	
	if real_old_person is distinct from old_person or real_old_position is distinct from old_position or real_old_commissariat is distinct from old_station or real_old_salary is distinct from old_salary or real_old_superior is distinct from old_superior then
		return false;
	end if;
	perform tcs.update_officer(_id,_person,_position,_station, _salary, _superior);
	return true;
end;$$;


--
-- TOC entry 244 (class 1255 OID 41995)
-- Name: update_person(integer, character varying, character varying, "bytea"); Type: FUNCTION; Schema: tcs; Owner: -
--

CREATE FUNCTION "update_person"("_id" integer, "first_name" character varying, "last_name" character varying, "_photo" "bytea") RETURNS "void"
    LANGUAGE "plpgsql"
    AS $$begin
	update tcs."człowiek" set imie=first_name, nazwisko=last_name, photo=_photo where id=_id;
end;$$;


--
-- TOC entry 265 (class 1255 OID 42106)
-- Name: update_person_checked(integer, character varying, character varying, "bytea", character varying, character varying, "bytea"); Type: FUNCTION; Schema: tcs; Owner: -
--

CREATE FUNCTION "update_person_checked"("_id" integer, "_first_name" character varying, "_last_name" character varying, "_photo" "bytea", "_old_first_name" character varying, "_old_last_name" character varying, "_old_photo" "bytea") RETURNS boolean
    LANGUAGE "plpgsql"
    AS $$
declare
	real_old_first_name character varying;
	real_old_last_name character varying;
	real_old_photo bytea;
begin
	select imie from tcs."człowiek" where id=_id into real_old_first_name;
	select nazwisko from tcs."człowiek" where id=_id into real_old_last_name;
	select photo from tcs."człowiek" where id=_id into real_old_photo;

	if real_old_first_name is distinct from _old_first_name or real_old_last_name is distinct from _old_last_name or real_old_photo is distinct from _old_photo then
		return false;
	end if;
	
	perform tcs.update_person(_id,_first_name,_last_name,_photo);
	return true;
end;$$;


--
-- TOC entry 243 (class 1255 OID 41997)
-- Name: update_position(integer, character varying); Type: FUNCTION; Schema: tcs; Owner: -
--

CREATE FUNCTION "update_position"("_id" integer, "name" character varying) RETURNS "void"
    LANGUAGE "plpgsql"
    AS $$begin
	update tcs.etat set nazwa=name where id=_id;
end;$$;


--
-- TOC entry 266 (class 1255 OID 42107)
-- Name: update_position_checked(integer, character varying, character varying); Type: FUNCTION; Schema: tcs; Owner: -
--

CREATE FUNCTION "update_position_checked"("_id" integer, "_name" character varying, "_old_name" character varying) RETURNS boolean
    LANGUAGE "plpgsql"
    AS $$
declare
	real_old_name character varying;
begin
	select nazwa from tcs.etat where id=_id into real_old_name;

	if real_old_name is distinct from _old_name then
		return false;
	end if;
	
	perform tcs.update_position(_id,_name);
	return true;
end;$$;


--
-- TOC entry 257 (class 1255 OID 42090)
-- Name: update_station(integer, integer); Type: FUNCTION; Schema: tcs; Owner: -
--

CREATE FUNCTION "update_station"("_id" integer, "_location" integer) RETURNS "void"
    LANGUAGE "plpgsql"
    AS $$begin
	update tcs.komisariat set miejsce_id=_location where id=_id;
end;$$;


--
-- TOC entry 263 (class 1255 OID 42108)
-- Name: update_station_checked(integer, integer, integer); Type: FUNCTION; Schema: tcs; Owner: -
--

CREATE FUNCTION "update_station_checked"("_id" integer, "_location" integer, "_old_location" integer) RETURNS boolean
    LANGUAGE "plpgsql"
    AS $$declare
	real_old_place integer;
begin
	select miejsce_id from tcs.komissariat where id=_id into real_old_place;
	if real_old_place is distinct from _old_location then
		return false;
	end if;
	perform tcs.update_station(_id,_location);
	return true;
end;$$;


--
-- TOC entry 303 (class 1255 OID 42213)
-- Name: update_ticket(integer, integer, integer, integer, integer, integer); Type: FUNCTION; Schema: tcs; Owner: -
--

CREATE FUNCTION "update_ticket"("_id" integer, "_offense" integer, "_inspection" integer, "_person" integer, "_price" integer, "_points" integer) RETURNS "void"
    LANGUAGE "plpgsql"
    AS $$begin
	update tcs.mandat set wykroczenie_id=_offense, kontrola_id=_inspection, "człowiek_id"=_person, cena=_price, points=_points where id=_id;
end;$$;


--
-- TOC entry 304 (class 1255 OID 42215)
-- Name: update_ticket_checked(integer, integer, integer, integer, integer, integer, integer, integer, integer, integer, integer); Type: FUNCTION; Schema: tcs; Owner: -
--

CREATE FUNCTION "update_ticket_checked"("_id" integer, "_offense" integer, "_inspection" integer, "_person" integer, "_price" integer, "_points" integer, "_old_offense" integer, "_old_inspection" integer, "_old_person" integer, "_old_price" integer, "_old_points" integer) RETURNS boolean
    LANGUAGE "plpgsql"
    AS $$
declare
	real_old_offense integer;
	real_old_inspection integer;
	real_old_person integer;
	real_old_price integer;
	real_old_points integer;
begin
	select wykroczenie_id from tcs.mandat where id=_id into real_old_offense;
	select kontrola_id from tcs.mandat where id=_id into real_old_inspection;
	select człowiek_id from tcs.mandat where id=_id into real_old_person;
	select cena from tcs.mandat where id=_id into real_old_price;
	select points from tcs.mandat where id=_id into real_old_points;

	if real_old_offense is distinct from _old_offense or real_old_inspection is distinct from _old_inspection or real_old_person is distinct from _old_person or real_old_price is distinct from _old_price or real_old_points is distinct from _old_points then
		return false;
	end if;
	
	perform tcs.update_ticket(_id,_offense,_inspection,_person,_price,_points);
	return true;
end;$$;


--
-- TOC entry 192 (class 1259 OID 41596)
-- Name: człowiek_id_seq; Type: SEQUENCE; Schema: tcs; Owner: -
--

CREATE SEQUENCE "człowiek_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 2222 (class 0 OID 0)
-- Dependencies: 192
-- Name: człowiek_id_seq; Type: SEQUENCE OWNED BY; Schema: tcs; Owner: -
--

ALTER SEQUENCE "człowiek_id_seq" OWNED BY "człowiek"."id";


--
-- TOC entry 206 (class 1259 OID 41728)
-- Name: etat_id_seq; Type: SEQUENCE; Schema: tcs; Owner: -
--

CREATE SEQUENCE "etat_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 2223 (class 0 OID 0)
-- Dependencies: 206
-- Name: etat_id_seq; Type: SEQUENCE OWNED BY; Schema: tcs; Owner: -
--

ALTER SEQUENCE "etat_id_seq" OWNED BY "etat"."id";


--
-- TOC entry 201 (class 1259 OID 41647)
-- Name: komisariat_id_seq; Type: SEQUENCE; Schema: tcs; Owner: -
--

CREATE SEQUENCE "komisariat_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 2224 (class 0 OID 0)
-- Dependencies: 201
-- Name: komisariat_id_seq; Type: SEQUENCE OWNED BY; Schema: tcs; Owner: -
--

ALTER SEQUENCE "komisariat_id_seq" OWNED BY "komisariat"."id";


--
-- TOC entry 202 (class 1259 OID 41660)
-- Name: kontrola_id_seq; Type: SEQUENCE; Schema: tcs; Owner: -
--

CREATE SEQUENCE "kontrola_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 2225 (class 0 OID 0)
-- Dependencies: 202
-- Name: kontrola_id_seq; Type: SEQUENCE OWNED BY; Schema: tcs; Owner: -
--

ALTER SEQUENCE "kontrola_id_seq" OWNED BY "kontrola"."id";


--
-- TOC entry 204 (class 1259 OID 41689)
-- Name: mandat_id_seq; Type: SEQUENCE; Schema: tcs; Owner: -
--

CREATE SEQUENCE "mandat_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 2226 (class 0 OID 0)
-- Dependencies: 204
-- Name: mandat_id_seq; Type: SEQUENCE OWNED BY; Schema: tcs; Owner: -
--

ALTER SEQUENCE "mandat_id_seq" OWNED BY "mandat"."id";


--
-- TOC entry 208 (class 1259 OID 41765)
-- Name: mandat_urządzenia; Type: TABLE; Schema: tcs; Owner: -; Tablespace: 
--

CREATE TABLE "mandat_urządzenia" (
    "mandat_id" integer NOT NULL,
    "urządzenie_id" integer NOT NULL
);


--
-- TOC entry 200 (class 1259 OID 41636)
-- Name: miejsce_id_seq; Type: SEQUENCE; Schema: tcs; Owner: -
--

CREATE SEQUENCE "miejsce_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 2227 (class 0 OID 0)
-- Dependencies: 200
-- Name: miejsce_id_seq; Type: SEQUENCE OWNED BY; Schema: tcs; Owner: -
--

ALTER SEQUENCE "miejsce_id_seq" OWNED BY "miejsce"."id";


--
-- TOC entry 191 (class 1259 OID 41590)
-- Name: policjant_id_seq; Type: SEQUENCE; Schema: tcs; Owner: -
--

CREATE SEQUENCE "policjant_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 2228 (class 0 OID 0)
-- Dependencies: 191
-- Name: policjant_id_seq; Type: SEQUENCE OWNED BY; Schema: tcs; Owner: -
--

ALTER SEQUENCE "policjant_id_seq" OWNED BY "policjant"."id";


--
-- TOC entry 203 (class 1259 OID 41678)
-- Name: urządzenie_id_seq; Type: SEQUENCE; Schema: tcs; Owner: -
--

CREATE SEQUENCE "urządzenie_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 2229 (class 0 OID 0)
-- Dependencies: 203
-- Name: urządzenie_id_seq; Type: SEQUENCE OWNED BY; Schema: tcs; Owner: -
--

ALTER SEQUENCE "urządzenie_id_seq" OWNED BY "urządzenie"."id";


--
-- TOC entry 205 (class 1259 OID 41707)
-- Name: wykroczenia_id_seq; Type: SEQUENCE; Schema: tcs; Owner: -
--

CREATE SEQUENCE "wykroczenia_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 2230 (class 0 OID 0)
-- Dependencies: 205
-- Name: wykroczenia_id_seq; Type: SEQUENCE OWNED BY; Schema: tcs; Owner: -
--

ALTER SEQUENCE "wykroczenia_id_seq" OWNED BY "wykroczenia"."id";


--
-- TOC entry 207 (class 1259 OID 41750)
-- Name: wykroczenia_urządzenia; Type: TABLE; Schema: tcs; Owner: -; Tablespace: 
--

CREATE TABLE "wykroczenia_urządzenia" (
    "wykroczenie_id" integer NOT NULL,
    "urządzenie_id" integer NOT NULL
);


--
-- TOC entry 2141 (class 2604 OID 41598)
-- Name: id; Type: DEFAULT; Schema: tcs; Owner: -
--

ALTER TABLE ONLY "człowiek" ALTER COLUMN "id" SET DEFAULT "nextval"('"człowiek_id_seq"'::"regclass");


--
-- TOC entry 2146 (class 2604 OID 41730)
-- Name: id; Type: DEFAULT; Schema: tcs; Owner: -
--

ALTER TABLE ONLY "etat" ALTER COLUMN "id" SET DEFAULT "nextval"('"etat_id_seq"'::"regclass");


--
-- TOC entry 2151 (class 2604 OID 41649)
-- Name: id; Type: DEFAULT; Schema: tcs; Owner: -
--

ALTER TABLE ONLY "komisariat" ALTER COLUMN "id" SET DEFAULT "nextval"('"komisariat_id_seq"'::"regclass");


--
-- TOC entry 2150 (class 2604 OID 41662)
-- Name: id; Type: DEFAULT; Schema: tcs; Owner: -
--

ALTER TABLE ONLY "kontrola" ALTER COLUMN "id" SET DEFAULT "nextval"('"kontrola_id_seq"'::"regclass");


--
-- TOC entry 2147 (class 2604 OID 41691)
-- Name: id; Type: DEFAULT; Schema: tcs; Owner: -
--

ALTER TABLE ONLY "mandat" ALTER COLUMN "id" SET DEFAULT "nextval"('"mandat_id_seq"'::"regclass");


--
-- TOC entry 2152 (class 2604 OID 41638)
-- Name: id; Type: DEFAULT; Schema: tcs; Owner: -
--

ALTER TABLE ONLY "miejsce" ALTER COLUMN "id" SET DEFAULT "nextval"('"miejsce_id_seq"'::"regclass");


--
-- TOC entry 2142 (class 2604 OID 41592)
-- Name: id; Type: DEFAULT; Schema: tcs; Owner: -
--

ALTER TABLE ONLY "policjant" ALTER COLUMN "id" SET DEFAULT "nextval"('"policjant_id_seq"'::"regclass");


--
-- TOC entry 2149 (class 2604 OID 41680)
-- Name: id; Type: DEFAULT; Schema: tcs; Owner: -
--

ALTER TABLE ONLY "urządzenie" ALTER COLUMN "id" SET DEFAULT "nextval"('"urządzenie_id_seq"'::"regclass");


--
-- TOC entry 2143 (class 2604 OID 41709)
-- Name: id; Type: DEFAULT; Schema: tcs; Owner: -
--

ALTER TABLE ONLY "wykroczenia" ALTER COLUMN "id" SET DEFAULT "nextval"('"wykroczenia_id_seq"'::"regclass");


--
-- TOC entry 2198 (class 0 OID 41556)
-- Dependencies: 189
-- Data for Name: człowiek; Type: TABLE DATA; Schema: tcs; Owner: -
--

INSERT INTO "człowiek" VALUES ('Jan', 'Marecki', 7, NULL);
INSERT INTO "człowiek" VALUES ('Karol', 'Janicki', 8, NULL);
INSERT INTO "człowiek" VALUES ('Paweł', 'Nowicki', 9, NULL);
INSERT INTO "człowiek" VALUES ('Piotr', 'Nowak', 10, NULL);
INSERT INTO "człowiek" VALUES ('Krzysztof', 'Kowalski', 11, NULL);
INSERT INTO "człowiek" VALUES ('Maria', 'Grzybowska', 12, NULL);
INSERT INTO "człowiek" VALUES ('Joanna', 'Krakowska', 13, NULL);
INSERT INTO "człowiek" VALUES ('Roman', 'Opolski', 14, NULL);
INSERT INTO "człowiek" VALUES ('Konrad', 'Kotarski', 15, NULL);
INSERT INTO "człowiek" VALUES ('Marek', 'Makowski', 16, NULL);
INSERT INTO "człowiek" VALUES ('Leon', 'Przywarek', 17, NULL);
INSERT INTO "człowiek" VALUES ('Stefan', 'Kotlarczyk', 18, NULL);
INSERT INTO "człowiek" VALUES ('Mateusz', 'Siekierski', 19, NULL);
INSERT INTO "człowiek" VALUES ('Tomasz', 'Dolny', 20, NULL);


--
-- TOC entry 2231 (class 0 OID 0)
-- Dependencies: 192
-- Name: człowiek_id_seq; Type: SEQUENCE SET; Schema: tcs; Owner: -
--

SELECT pg_catalog.setval('"człowiek_id_seq"', 20, true);


--
-- TOC entry 2203 (class 0 OID 41617)
-- Dependencies: 194
-- Data for Name: etat; Type: TABLE DATA; Schema: tcs; Owner: -
--

INSERT INTO "etat" VALUES (2, 'posterunkowy');
INSERT INTO "etat" VALUES (3, 'starszy posterunkowy');
INSERT INTO "etat" VALUES (4, 'sierżant');
INSERT INTO "etat" VALUES (5, 'starszy sierżant');
INSERT INTO "etat" VALUES (6, 'sierżant sztabowy');
INSERT INTO "etat" VALUES (7, 'młodszy aspirant');
INSERT INTO "etat" VALUES (8, 'aspirant');
INSERT INTO "etat" VALUES (9, 'starszy aspirant');
INSERT INTO "etat" VALUES (10, 'aspirant sztabowy');
INSERT INTO "etat" VALUES (11, 'podkomisarz');
INSERT INTO "etat" VALUES (12, 'komisarz');
INSERT INTO "etat" VALUES (13, 'nadkomisarz');
INSERT INTO "etat" VALUES (14, 'podinspektor');
INSERT INTO "etat" VALUES (15, 'młodszy inspektor');
INSERT INTO "etat" VALUES (16, 'inspektor');
INSERT INTO "etat" VALUES (17, 'nadinspektor');
INSERT INTO "etat" VALUES (18, 'generalny inspektor');


--
-- TOC entry 2232 (class 0 OID 0)
-- Dependencies: 206
-- Name: etat_id_seq; Type: SEQUENCE SET; Schema: tcs; Owner: -
--

SELECT pg_catalog.setval('"etat_id_seq"', 18, true);


--
-- TOC entry 2207 (class 0 OID 41630)
-- Dependencies: 198
-- Data for Name: komisariat; Type: TABLE DATA; Schema: tcs; Owner: -
--

INSERT INTO "komisariat" VALUES (2, 2);


--
-- TOC entry 2233 (class 0 OID 0)
-- Dependencies: 201
-- Name: komisariat_id_seq; Type: SEQUENCE SET; Schema: tcs; Owner: -
--

SELECT pg_catalog.setval('"komisariat_id_seq"', 3, true);


--
-- TOC entry 2206 (class 0 OID 41626)
-- Dependencies: 197
-- Data for Name: kontrola; Type: TABLE DATA; Schema: tcs; Owner: -
--

INSERT INTO "kontrola" VALUES (6, 2, 10, '2013-01-16 22:42:14.769459+01');
INSERT INTO "kontrola" VALUES (9, 2, 8, '2013-01-16 22:42:27.906732+01');


--
-- TOC entry 2234 (class 0 OID 0)
-- Dependencies: 202
-- Name: kontrola_id_seq; Type: SEQUENCE SET; Schema: tcs; Owner: -
--

SELECT pg_catalog.setval('"kontrola_id_seq"', 9, true);


--
-- TOC entry 2204 (class 0 OID 41620)
-- Dependencies: 195
-- Data for Name: mandat; Type: TABLE DATA; Schema: tcs; Owner: -
--

INSERT INTO "mandat" VALUES (4, 1, 6, 13, 700, NULL);
INSERT INTO "mandat" VALUES (7, 2, 9, 17, 800, NULL);


--
-- TOC entry 2235 (class 0 OID 0)
-- Dependencies: 204
-- Name: mandat_id_seq; Type: SEQUENCE SET; Schema: tcs; Owner: -
--

SELECT pg_catalog.setval('"mandat_id_seq"', 7, true);


--
-- TOC entry 2217 (class 0 OID 41765)
-- Dependencies: 208
-- Data for Name: mandat_urządzenia; Type: TABLE DATA; Schema: tcs; Owner: -
--

INSERT INTO "mandat_urządzenia" VALUES (4, 3);
INSERT INTO "mandat_urządzenia" VALUES (7, 1);


--
-- TOC entry 2208 (class 0 OID 41633)
-- Dependencies: 199
-- Data for Name: miejsce; Type: TABLE DATA; Schema: tcs; Owner: -
--

INSERT INTO "miejsce" VALUES (2, 'Kraków, łojasiewicza 6', NULL, NULL, NULL);
INSERT INTO "miejsce" VALUES (3, 'Kraków, studencka 12', NULL, NULL, NULL);


--
-- TOC entry 2236 (class 0 OID 0)
-- Dependencies: 200
-- Name: miejsce_id_seq; Type: SEQUENCE SET; Schema: tcs; Owner: -
--

SELECT pg_catalog.setval('"miejsce_id_seq"', 3, true);


--
-- TOC entry 2199 (class 0 OID 41570)
-- Dependencies: 190
-- Data for Name: policjant; Type: TABLE DATA; Schema: tcs; Owner: -
--

INSERT INTO "policjant" VALUES (5, 7, 2, 2, NULL, NULL);
INSERT INTO "policjant" VALUES (7, 9, 6, 2, NULL, NULL);
INSERT INTO "policjant" VALUES (8, 10, 8, 2, NULL, NULL);
INSERT INTO "policjant" VALUES (9, 11, 10, 2, NULL, NULL);
INSERT INTO "policjant" VALUES (10, 13, 16, 2, NULL, NULL);
INSERT INTO "policjant" VALUES (6, 8, 4, 2, NULL, NULL);


--
-- TOC entry 2237 (class 0 OID 0)
-- Dependencies: 191
-- Name: policjant_id_seq; Type: SEQUENCE SET; Schema: tcs; Owner: -
--

SELECT pg_catalog.setval('"policjant_id_seq"', 10, true);


--
-- TOC entry 2205 (class 0 OID 41623)
-- Dependencies: 196
-- Data for Name: urządzenie; Type: TABLE DATA; Schema: tcs; Owner: -
--

INSERT INTO "urządzenie" VALUES (3, 'alkomat');
INSERT INTO "urządzenie" VALUES (1, 'suszarka');


--
-- TOC entry 2238 (class 0 OID 0)
-- Dependencies: 203
-- Name: urządzenie_id_seq; Type: SEQUENCE SET; Schema: tcs; Owner: -
--

SELECT pg_catalog.setval('"urządzenie_id_seq"', 3, true);


--
-- TOC entry 2202 (class 0 OID 41614)
-- Dependencies: 193
-- Data for Name: wykroczenia; Type: TABLE DATA; Schema: tcs; Owner: -
--

INSERT INTO "wykroczenia" VALUES (1, 500, 2000, 'jazda na podwójnym gazie', NULL, NULL);
INSERT INTO "wykroczenia" VALUES (2, 100, 1000, 'przekroczenie prędkości', NULL, NULL);


--
-- TOC entry 2239 (class 0 OID 0)
-- Dependencies: 205
-- Name: wykroczenia_id_seq; Type: SEQUENCE SET; Schema: tcs; Owner: -
--

SELECT pg_catalog.setval('"wykroczenia_id_seq"', 2, true);


--
-- TOC entry 2216 (class 0 OID 41750)
-- Dependencies: 207
-- Data for Name: wykroczenia_urządzenia; Type: TABLE DATA; Schema: tcs; Owner: -
--

INSERT INTO "wykroczenia_urządzenia" VALUES (2, 1);
INSERT INTO "wykroczenia_urządzenia" VALUES (1, 3);


--
-- TOC entry 2154 (class 2606 OID 41606)
-- Name: człowiek_pkey; Type: CONSTRAINT; Schema: tcs; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "człowiek"
    ADD CONSTRAINT "człowiek_pkey" PRIMARY KEY ("id");


--
-- TOC entry 2164 (class 2606 OID 41850)
-- Name: etat_nazwa_key; Type: CONSTRAINT; Schema: tcs; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "etat"
    ADD CONSTRAINT "etat_nazwa_key" UNIQUE ("nazwa");


--
-- TOC entry 2166 (class 2606 OID 41738)
-- Name: etat_pkey; Type: CONSTRAINT; Schema: tcs; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "etat"
    ADD CONSTRAINT "etat_pkey" PRIMARY KEY ("id");


--
-- TOC entry 2176 (class 2606 OID 41654)
-- Name: komisariat_pkey; Type: CONSTRAINT; Schema: tcs; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "komisariat"
    ADD CONSTRAINT "komisariat_pkey" PRIMARY KEY ("id");


--
-- TOC entry 2174 (class 2606 OID 41667)
-- Name: kontrola_pkey; Type: CONSTRAINT; Schema: tcs; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "kontrola"
    ADD CONSTRAINT "kontrola_pkey" PRIMARY KEY ("id");


--
-- TOC entry 2168 (class 2606 OID 41696)
-- Name: mandat_pkey; Type: CONSTRAINT; Schema: tcs; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "mandat"
    ADD CONSTRAINT "mandat_pkey" PRIMARY KEY ("id");


--
-- TOC entry 2184 (class 2606 OID 41769)
-- Name: mandat_urządzenia_pkey; Type: CONSTRAINT; Schema: tcs; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "mandat_urządzenia"
    ADD CONSTRAINT "mandat_urządzenia_pkey" PRIMARY KEY ("mandat_id", "urządzenie_id");


--
-- TOC entry 2178 (class 2606 OID 41852)
-- Name: miejsce_nazwa_key; Type: CONSTRAINT; Schema: tcs; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "miejsce"
    ADD CONSTRAINT "miejsce_nazwa_key" UNIQUE ("nazwa");


--
-- TOC entry 2180 (class 2606 OID 41646)
-- Name: miejsce_pkey; Type: CONSTRAINT; Schema: tcs; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "miejsce"
    ADD CONSTRAINT "miejsce_pkey" PRIMARY KEY ("id");


--
-- TOC entry 2156 (class 2606 OID 41848)
-- Name: policjant_czlowiek_id_key; Type: CONSTRAINT; Schema: tcs; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "policjant"
    ADD CONSTRAINT "policjant_czlowiek_id_key" UNIQUE ("czlowiek_id");


--
-- TOC entry 2158 (class 2606 OID 41608)
-- Name: policjant_pkey; Type: CONSTRAINT; Schema: tcs; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "policjant"
    ADD CONSTRAINT "policjant_pkey" PRIMARY KEY ("id");


--
-- TOC entry 2170 (class 2606 OID 41854)
-- Name: urządzenie_nazwa_key; Type: CONSTRAINT; Schema: tcs; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "urządzenie"
    ADD CONSTRAINT "urządzenie_nazwa_key" UNIQUE ("nazwa");


--
-- TOC entry 2172 (class 2606 OID 41688)
-- Name: urządzenie_pkey; Type: CONSTRAINT; Schema: tcs; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "urządzenie"
    ADD CONSTRAINT "urządzenie_pkey" PRIMARY KEY ("id");


--
-- TOC entry 2160 (class 2606 OID 41856)
-- Name: wykroczenia_nazwa_key; Type: CONSTRAINT; Schema: tcs; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "wykroczenia"
    ADD CONSTRAINT "wykroczenia_nazwa_key" UNIQUE ("nazwa");


--
-- TOC entry 2162 (class 2606 OID 41717)
-- Name: wykroczenia_pkey; Type: CONSTRAINT; Schema: tcs; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "wykroczenia"
    ADD CONSTRAINT "wykroczenia_pkey" PRIMARY KEY ("id");


--
-- TOC entry 2182 (class 2606 OID 41754)
-- Name: wykroczenia_urządzenia_pkey; Type: CONSTRAINT; Schema: tcs; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "wykroczenia_urządzenia"
    ADD CONSTRAINT "wykroczenia_urządzenia_pkey" PRIMARY KEY ("wykroczenie_id", "urządzenie_id");


--
-- TOC entry 2193 (class 2606 OID 41655)
-- Name: komisariat_miejsce_id_fkey; Type: FK CONSTRAINT; Schema: tcs; Owner: -
--

ALTER TABLE ONLY "komisariat"
    ADD CONSTRAINT "komisariat_miejsce_id_fkey" FOREIGN KEY ("miejsce_id") REFERENCES "miejsce"("id");


--
-- TOC entry 2191 (class 2606 OID 41859)
-- Name: kontrola_miejsce_id_fkey; Type: FK CONSTRAINT; Schema: tcs; Owner: -
--

ALTER TABLE ONLY "kontrola"
    ADD CONSTRAINT "kontrola_miejsce_id_fkey" FOREIGN KEY ("miejsce_id") REFERENCES "miejsce"("id");


--
-- TOC entry 2192 (class 2606 OID 41864)
-- Name: kontrola_policjant_id_fkey; Type: FK CONSTRAINT; Schema: tcs; Owner: -
--

ALTER TABLE ONLY "kontrola"
    ADD CONSTRAINT "kontrola_policjant_id_fkey" FOREIGN KEY ("policjant_id") REFERENCES "policjant"("id");


--
-- TOC entry 2188 (class 2606 OID 42196)
-- Name: mandat_człowiek_id_fkey; Type: FK CONSTRAINT; Schema: tcs; Owner: -
--

ALTER TABLE ONLY "mandat"
    ADD CONSTRAINT "mandat_człowiek_id_fkey" FOREIGN KEY ("człowiek_id") REFERENCES "człowiek"("id");


--
-- TOC entry 2189 (class 2606 OID 42201)
-- Name: mandat_kontrola_id_fkey; Type: FK CONSTRAINT; Schema: tcs; Owner: -
--

ALTER TABLE ONLY "mandat"
    ADD CONSTRAINT "mandat_kontrola_id_fkey" FOREIGN KEY ("kontrola_id") REFERENCES "kontrola"("id");


--
-- TOC entry 2196 (class 2606 OID 41770)
-- Name: mandat_urządzenia_mandat_id_fkey; Type: FK CONSTRAINT; Schema: tcs; Owner: -
--

ALTER TABLE ONLY "mandat_urządzenia"
    ADD CONSTRAINT "mandat_urządzenia_mandat_id_fkey" FOREIGN KEY ("mandat_id") REFERENCES "mandat"("id");


--
-- TOC entry 2197 (class 2606 OID 41775)
-- Name: mandat_urządzenia_urządzenie_id_fkey; Type: FK CONSTRAINT; Schema: tcs; Owner: -
--

ALTER TABLE ONLY "mandat_urządzenia"
    ADD CONSTRAINT "mandat_urządzenia_urządzenie_id_fkey" FOREIGN KEY ("urządzenie_id") REFERENCES "urządzenie"("id");


--
-- TOC entry 2190 (class 2606 OID 42206)
-- Name: mandat_wykroczenie_id_fkey; Type: FK CONSTRAINT; Schema: tcs; Owner: -
--

ALTER TABLE ONLY "mandat"
    ADD CONSTRAINT "mandat_wykroczenie_id_fkey" FOREIGN KEY ("wykroczenie_id") REFERENCES "wykroczenia"("id");


--
-- TOC entry 2185 (class 2606 OID 42176)
-- Name: policjant_czlowiek_id_fkey; Type: FK CONSTRAINT; Schema: tcs; Owner: -
--

ALTER TABLE ONLY "policjant"
    ADD CONSTRAINT "policjant_czlowiek_id_fkey" FOREIGN KEY ("czlowiek_id") REFERENCES "człowiek"("id");


--
-- TOC entry 2186 (class 2606 OID 42181)
-- Name: policjant_etat_id_fkey; Type: FK CONSTRAINT; Schema: tcs; Owner: -
--

ALTER TABLE ONLY "policjant"
    ADD CONSTRAINT "policjant_etat_id_fkey" FOREIGN KEY ("etat_id") REFERENCES "etat"("id");


--
-- TOC entry 2187 (class 2606 OID 42186)
-- Name: policjant_komisariat_id_fkey; Type: FK CONSTRAINT; Schema: tcs; Owner: -
--

ALTER TABLE ONLY "policjant"
    ADD CONSTRAINT "policjant_komisariat_id_fkey" FOREIGN KEY ("komisariat_id") REFERENCES "komisariat"("id");


--
-- TOC entry 2195 (class 2606 OID 41760)
-- Name: wykroczenia_urządzenia_urządzenie_id_fkey; Type: FK CONSTRAINT; Schema: tcs; Owner: -
--

ALTER TABLE ONLY "wykroczenia_urządzenia"
    ADD CONSTRAINT "wykroczenia_urządzenia_urządzenie_id_fkey" FOREIGN KEY ("urządzenie_id") REFERENCES "urządzenie"("id");


--
-- TOC entry 2194 (class 2606 OID 41755)
-- Name: wykroczenia_urządzenia_wykroczenie_id_fkey; Type: FK CONSTRAINT; Schema: tcs; Owner: -
--

ALTER TABLE ONLY "wykroczenia_urządzenia"
    ADD CONSTRAINT "wykroczenia_urządzenia_wykroczenie_id_fkey" FOREIGN KEY ("wykroczenie_id") REFERENCES "wykroczenia"("id");


-- Completed on 2013-01-23 19:14:51 CET

--
-- PostgreSQL database dump complete
--

