--
-- PostgreSQL database dump
--

-- Dumped from database version 15.5
-- Dumped by pg_dump version 16.1

-- Started on 2024-12-08 20:52:09

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 5 (class 2615 OID 76499)
-- Name: public; Type: SCHEMA; Schema: -; Owner: postgres
--

-- *not* creating schema, since initdb creates it


ALTER SCHEMA public OWNER TO postgres;

--
-- TOC entry 3483 (class 0 OID 0)
-- Dependencies: 5
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA public IS '';


--
-- TOC entry 238 (class 1255 OID 77359)
-- Name: search_places_and_shelters(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.search_places_and_shelters(search_term text) RETURNS TABLE(place_id text, department_name text, province_name text, district_name text, place_level text, full_location text, shelter_address text)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    WITH dynamic_matches AS (
        SELECT 
            s.shelter_id::TEXT AS place_id,
            NULL AS department_name,
            NULL AS province_name,
            NULL AS district_name,
            'Shelter' AS place_level,
            s.name AS full_location,
            s.address AS shelter_address
        FROM 
            shelters s
    )
    SELECT 
        ph.place_id::TEXT AS place_id, 
        ph.department_name,
        ph.province_name,
        ph.district_name,
        ph.place_level,
        ph.full_location,
        NULL AS shelter_address 
    FROM 
        place_hierarchy ph
    WHERE 
        ph.full_location ILIKE search_term 

    UNION ALL

    SELECT 
        dm.place_id,
        NULL AS department_name,
        NULL AS province_name,
        NULL AS district_name,
        dm.place_level,
        dm.full_location,
        dm.shelter_address 
    FROM 
        dynamic_matches dm
    WHERE 
        dm.full_location ILIKE search_term 
       OR dm.shelter_address ILIKE search_term
    ORDER BY 
        place_level, 
        full_location;
END;
$$;


ALTER FUNCTION public.search_places_and_shelters(search_term text) OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 214 (class 1259 OID 76713)
-- Name: _prisma_migrations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public._prisma_migrations (
    id character varying(36) NOT NULL,
    checksum character varying(64) NOT NULL,
    finished_at timestamp with time zone,
    migration_name character varying(255) NOT NULL,
    logs text,
    rolled_back_at timestamp with time zone,
    started_at timestamp with time zone DEFAULT now() NOT NULL,
    applied_steps_count integer DEFAULT 0 NOT NULL
);


ALTER TABLE public._prisma_migrations OWNER TO postgres;

--
-- TOC entry 234 (class 1259 OID 76830)
-- Name: adoptions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.adoptions (
    adoption_id uuid DEFAULT gen_random_uuid() NOT NULL,
    application jsonb NOT NULL,
    status text NOT NULL,
    pet_id integer NOT NULL,
    user_id uuid NOT NULL,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone
);


ALTER TABLE public.adoptions OWNER TO postgres;

--
-- TOC entry 216 (class 1259 OID 76723)
-- Name: departments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.departments (
    department_id integer NOT NULL,
    name text NOT NULL,
    code text NOT NULL,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp(3) without time zone
);


ALTER TABLE public.departments OWNER TO postgres;

--
-- TOC entry 215 (class 1259 OID 76722)
-- Name: departments_department_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.departments_department_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.departments_department_id_seq OWNER TO postgres;

--
-- TOC entry 3485 (class 0 OID 0)
-- Dependencies: 215
-- Name: departments_department_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.departments_department_id_seq OWNED BY public.departments.department_id;


--
-- TOC entry 220 (class 1259 OID 76743)
-- Name: districts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.districts (
    district_id integer NOT NULL,
    name text NOT NULL,
    code text NOT NULL,
    province_id integer NOT NULL,
    department_id integer NOT NULL,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone
);


ALTER TABLE public.districts OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 76742)
-- Name: districts_district_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.districts_district_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.districts_district_id_seq OWNER TO postgres;

--
-- TOC entry 3486 (class 0 OID 0)
-- Dependencies: 219
-- Name: districts_district_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.districts_district_id_seq OWNED BY public.districts.district_id;


--
-- TOC entry 224 (class 1259 OID 76771)
-- Name: donations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.donations (
    donation_id uuid DEFAULT gen_random_uuid() NOT NULL,
    plan_id integer,
    user_id uuid,
    email text,
    name text,
    amount numeric(6,2) NOT NULL,
    type text NOT NULL,
    status text NOT NULL,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone
);


ALTER TABLE public.donations OWNER TO postgres;

--
-- TOC entry 236 (class 1259 OID 76840)
-- Name: favorite_pets; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.favorite_pets (
    favorite_pet_id integer NOT NULL,
    pet_id integer NOT NULL,
    user_id uuid NOT NULL,
    value boolean NOT NULL,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone
);


ALTER TABLE public.favorite_pets OWNER TO postgres;

--
-- TOC entry 235 (class 1259 OID 76839)
-- Name: favorite_pets_favorite_pet_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.favorite_pets_favorite_pet_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.favorite_pets_favorite_pet_id_seq OWNER TO postgres;

--
-- TOC entry 3487 (class 0 OID 0)
-- Dependencies: 235
-- Name: favorite_pets_favorite_pet_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.favorite_pets_favorite_pet_id_seq OWNED BY public.favorite_pets.favorite_pet_id;


--
-- TOC entry 229 (class 1259 OID 76800)
-- Name: pet_breeds; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pet_breeds (
    pet_breed_id integer NOT NULL,
    name text NOT NULL,
    category_id integer NOT NULL,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone
);


ALTER TABLE public.pet_breeds OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 76799)
-- Name: pet_breeds_pet_breed_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.pet_breeds_pet_breed_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.pet_breeds_pet_breed_id_seq OWNER TO postgres;

--
-- TOC entry 3488 (class 0 OID 0)
-- Dependencies: 228
-- Name: pet_breeds_pet_breed_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.pet_breeds_pet_breed_id_seq OWNED BY public.pet_breeds.pet_breed_id;


--
-- TOC entry 227 (class 1259 OID 76790)
-- Name: pet_categories; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pet_categories (
    pet_category_id integer NOT NULL,
    name text NOT NULL,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone
);


ALTER TABLE public.pet_categories OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 76789)
-- Name: pet_categories_pet_category_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.pet_categories_pet_category_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.pet_categories_pet_category_id_seq OWNER TO postgres;

--
-- TOC entry 3489 (class 0 OID 0)
-- Dependencies: 226
-- Name: pet_categories_pet_category_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.pet_categories_pet_category_id_seq OWNED BY public.pet_categories.pet_category_id;


--
-- TOC entry 233 (class 1259 OID 76821)
-- Name: pet_photos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pet_photos (
    id integer NOT NULL,
    pet_id integer NOT NULL,
    url jsonb,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone
);


ALTER TABLE public.pet_photos OWNER TO postgres;

--
-- TOC entry 232 (class 1259 OID 76820)
-- Name: pet_photos_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.pet_photos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.pet_photos_id_seq OWNER TO postgres;

--
-- TOC entry 3490 (class 0 OID 0)
-- Dependencies: 232
-- Name: pet_photos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.pet_photos_id_seq OWNED BY public.pet_photos.id;


--
-- TOC entry 231 (class 1259 OID 76810)
-- Name: pets; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pets (
    pet_id integer NOT NULL,
    name text NOT NULL,
    description text NOT NULL,
    birthdate timestamp(3) without time zone NOT NULL,
    weight numeric(6,2) NOT NULL,
    height numeric(6,2) NOT NULL,
    gender text NOT NULL,
    color text NOT NULL,
    behavior text[],
    profile_picture jsonb,
    category_id integer NOT NULL,
    breed_id integer NOT NULL,
    shelter_id uuid NOT NULL,
    status text DEFAULT 'Available'::text NOT NULL,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone
);


ALTER TABLE public.pets OWNER TO postgres;

--
-- TOC entry 230 (class 1259 OID 76809)
-- Name: pets_pet_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.pets_pet_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.pets_pet_id_seq OWNER TO postgres;

--
-- TOC entry 3491 (class 0 OID 0)
-- Dependencies: 230
-- Name: pets_pet_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.pets_pet_id_seq OWNED BY public.pets.pet_id;


--
-- TOC entry 218 (class 1259 OID 76733)
-- Name: provinces; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.provinces (
    province_id integer NOT NULL,
    name text NOT NULL,
    code text NOT NULL,
    department_id integer NOT NULL,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone
);


ALTER TABLE public.provinces OWNER TO postgres;

--
-- TOC entry 237 (class 1259 OID 77354)
-- Name: place_hierarchy; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.place_hierarchy AS
 SELECT dept.department_id AS place_id,
    dept.name AS department_name,
    NULL::text AS province_name,
    NULL::text AS district_name,
    'Department'::text AS place_level,
    dept.name AS full_location
   FROM public.departments dept
UNION ALL
 SELECT p.province_id AS place_id,
    dept.name AS department_name,
    p.name AS province_name,
    NULL::text AS district_name,
    'Province'::text AS place_level,
    concat(dept.name, ',', p.name) AS full_location
   FROM (public.provinces p
     JOIN public.departments dept ON ((p.department_id = dept.department_id)))
UNION ALL
 SELECT d.district_id AS place_id,
    dept.name AS department_name,
    p.name AS province_name,
    d.name AS district_name,
    'District'::text AS place_level,
    concat(dept.name, ',', p.name, ',', d.name) AS full_location
   FROM ((public.districts d
     JOIN public.provinces p ON ((d.province_id = p.province_id)))
     JOIN public.departments dept ON ((p.department_id = dept.department_id)));


ALTER VIEW public.place_hierarchy OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 76762)
-- Name: plans; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.plans (
    plan_id integer NOT NULL,
    product_id text NOT NULL,
    code_one_time text NOT NULL,
    code_subscription text NOT NULL,
    name text NOT NULL,
    title text NOT NULL,
    description text NOT NULL,
    price numeric(6,2) NOT NULL,
    is_polular boolean NOT NULL,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone
);


ALTER TABLE public.plans OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 76761)
-- Name: plans_plan_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.plans_plan_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.plans_plan_id_seq OWNER TO postgres;

--
-- TOC entry 3492 (class 0 OID 0)
-- Dependencies: 222
-- Name: plans_plan_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.plans_plan_id_seq OWNED BY public.plans.plan_id;


--
-- TOC entry 217 (class 1259 OID 76732)
-- Name: provinces_province_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.provinces_province_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.provinces_province_id_seq OWNER TO postgres;

--
-- TOC entry 3493 (class 0 OID 0)
-- Dependencies: 217
-- Name: provinces_province_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.provinces_province_id_seq OWNED BY public.provinces.province_id;


--
-- TOC entry 225 (class 1259 OID 76780)
-- Name: shelters; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.shelters (
    shelter_id uuid DEFAULT gen_random_uuid() NOT NULL,
    name text NOT NULL,
    address text NOT NULL,
    phone text NOT NULL,
    email text NOT NULL,
    latitude numeric(65,30) NOT NULL,
    longitude numeric(65,30) NOT NULL,
    district_id integer NOT NULL,
    user_id uuid,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone
);


ALTER TABLE public.shelters OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 76752)
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    user_id uuid DEFAULT gen_random_uuid() NOT NULL,
    channel text NOT NULL,
    first_name text NOT NULL,
    last_name text NOT NULL,
    email text NOT NULL,
    password text NOT NULL,
    avatar jsonb,
    phone text,
    birthdate date,
    address text,
    district_id integer,
    customer_id text,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone
);


ALTER TABLE public.users OWNER TO postgres;

--
-- TOC entry 3240 (class 2604 OID 76726)
-- Name: departments department_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.departments ALTER COLUMN department_id SET DEFAULT nextval('public.departments_department_id_seq'::regclass);


--
-- TOC entry 3244 (class 2604 OID 76746)
-- Name: districts district_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.districts ALTER COLUMN district_id SET DEFAULT nextval('public.districts_district_id_seq'::regclass);


--
-- TOC entry 3265 (class 2604 OID 76843)
-- Name: favorite_pets favorite_pet_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.favorite_pets ALTER COLUMN favorite_pet_id SET DEFAULT nextval('public.favorite_pets_favorite_pet_id_seq'::regclass);


--
-- TOC entry 3256 (class 2604 OID 76803)
-- Name: pet_breeds pet_breed_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pet_breeds ALTER COLUMN pet_breed_id SET DEFAULT nextval('public.pet_breeds_pet_breed_id_seq'::regclass);


--
-- TOC entry 3254 (class 2604 OID 76793)
-- Name: pet_categories pet_category_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pet_categories ALTER COLUMN pet_category_id SET DEFAULT nextval('public.pet_categories_pet_category_id_seq'::regclass);


--
-- TOC entry 3261 (class 2604 OID 76824)
-- Name: pet_photos id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pet_photos ALTER COLUMN id SET DEFAULT nextval('public.pet_photos_id_seq'::regclass);


--
-- TOC entry 3258 (class 2604 OID 76813)
-- Name: pets pet_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pets ALTER COLUMN pet_id SET DEFAULT nextval('public.pets_pet_id_seq'::regclass);


--
-- TOC entry 3248 (class 2604 OID 76765)
-- Name: plans plan_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.plans ALTER COLUMN plan_id SET DEFAULT nextval('public.plans_plan_id_seq'::regclass);


--
-- TOC entry 3242 (class 2604 OID 76736)
-- Name: provinces province_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.provinces ALTER COLUMN province_id SET DEFAULT nextval('public.provinces_province_id_seq'::regclass);


--
-- TOC entry 3455 (class 0 OID 76713)
-- Dependencies: 214
-- Data for Name: _prisma_migrations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public._prisma_migrations (id, checksum, finished_at, migration_name, logs, rolled_back_at, started_at, applied_steps_count) FROM stdin;
a10c79b7-377a-455a-8261-e1bdd27b0445	d838d54dd51b371972bba89ef334a15a6be2116d66f97327994fff6db0cf8338	2024-12-07 16:07:43.597208-05	20241130234550_init	\N	\N	2024-12-07 16:07:42.938022-05	1
\.


--
-- TOC entry 3475 (class 0 OID 76830)
-- Dependencies: 234
-- Data for Name: adoptions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.adoptions (adoption_id, application, status, pet_id, user_id, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 3457 (class 0 OID 76723)
-- Dependencies: 216
-- Data for Name: departments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.departments (department_id, name, code, created_at, updated_at) FROM stdin;
1	Amazonas	01	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
2	Áncash	02	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
3	Apurímac	03	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
4	Arequipa	04	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
5	Ayacucho	05	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
6	Cajamarca	06	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
7	Callao	07	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
8	Cusco	08	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
9	Huancavelica	09	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
10	Huánuco	10	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
11	Ica	11	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
12	Junín	12	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
13	La Libertad	13	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
14	Lambayeque	14	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
15	Lima	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
16	Loreto	16	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
17	Madre de Dios	17	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
18	Moquegua	18	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
19	Pasco	19	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
20	Piura	20	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
21	Puno	21	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
22	San Martín	22	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
23	Tacna	23	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
24	Tumbes	24	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
25	Ucayali	25	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
\.


--
-- TOC entry 3461 (class 0 OID 76743)
-- Dependencies: 220
-- Data for Name: districts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.districts (district_id, name, code, province_id, department_id, created_at, updated_at) FROM stdin;
1	Chachapoyas	10101	1	1	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
2	Asunción	10102	1	1	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
3	Balsas	10103	1	1	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
4	Cheto	10104	1	1	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
5	Chiliquin	10105	1	1	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
6	Chuquibamba	10106	1	1	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
7	Granada	10107	1	1	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
8	Huancas	10108	1	1	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
9	La Jalca	10109	1	1	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
10	Leimebamba	10110	1	1	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
11	Levanto	10111	1	1	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
12	Magdalena	10112	1	1	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
13	Mariscal Castilla	10113	1	1	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
14	Molinopampa	10114	1	1	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
15	Montevideo	10115	1	1	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
16	Olleros	10116	1	1	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
17	Quinjalca	10117	1	1	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
18	San Francisco de Daguas	10118	1	1	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
19	San Isidro de Maino	10119	1	1	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
20	Soloco	10120	1	1	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
21	Sonche	10121	1	1	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
22	Bagua	10201	2	1	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
23	Aramango	10202	2	1	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
24	Copallin	10203	2	1	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
25	El Parco	10204	2	1	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
26	Imaza	10205	2	1	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
27	La Peca	10206	2	1	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
28	Jumbilla	10301	3	1	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
29	Chisquilla	10302	3	1	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
30	Churuja	10303	3	1	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
31	Corosha	10304	3	1	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
32	Cuispes	10305	3	1	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
33	Florida	10306	3	1	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
34	Jazan	10307	3	1	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
35	Recta	10308	3	1	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
36	San Carlos	10309	3	1	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
37	Shipasbamba	10310	3	1	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
38	Valera	10311	3	1	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
39	Yambrasbamba	10312	3	1	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
40	Nieva	10401	4	1	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
41	El Cenepa	10402	4	1	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
42	Río Santiago	10403	4	1	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
43	Lamud	10501	5	1	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
44	Camporredondo	10502	5	1	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
45	Cocabamba	10503	5	1	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
46	Colcamar	10504	5	1	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
47	Conila	10505	5	1	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
48	Inguilpata	10506	5	1	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
49	Longuita	10507	5	1	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
50	Lonya Chico	10508	5	1	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
51	Luya	10509	5	1	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
52	Luya Viejo	10510	5	1	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
53	María	10511	5	1	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
54	Ocalli	10512	5	1	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
55	Ocumal	10513	5	1	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
56	Pisuquia	10514	5	1	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
57	Providencia	10515	5	1	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
58	San Cristóbal	10516	5	1	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
59	San Francisco de Yeso	10517	5	1	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
60	San Jerónimo	10518	5	1	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
61	San Juan de Lopecancha	10519	5	1	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
62	Santa Catalina	10520	5	1	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
63	Santo Tomas	10521	5	1	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
64	Tingo	10522	5	1	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
65	Trita	10523	5	1	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
66	San Nicolás	10601	6	1	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
67	Chirimoto	10602	6	1	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
68	Cochamal	10603	6	1	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
69	Huambo	10604	6	1	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
70	Limabamba	10605	6	1	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
71	Longar	10606	6	1	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
72	Mariscal Benavides	10607	6	1	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
73	Milpuc	10608	6	1	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
74	Omia	10609	6	1	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
75	Santa Rosa	10610	6	1	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
76	Totora	10611	6	1	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
77	Vista Alegre	10612	6	1	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
78	Bagua Grande	10701	7	1	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
79	Cajaruro	10702	7	1	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
80	Cumba	10703	7	1	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
81	El Milagro	10704	7	1	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
82	Jamalca	10705	7	1	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
83	Lonya Grande	10706	7	1	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
84	Yamon	10707	7	1	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
85	Huaraz	20101	8	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
86	Cochabamba	20102	8	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
87	Colcabamba	20103	8	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
88	Huanchay	20104	8	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
89	Independencia	20105	8	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
90	Jangas	20106	8	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
91	La Libertad	20107	8	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
92	Olleros	20108	8	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
93	Pampas Grande	20109	8	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
94	Pariacoto	20110	8	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
95	Pira	20111	8	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
96	Tarica	20112	8	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
97	Aija	20201	9	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
98	Coris	20202	9	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
99	Huacllan	20203	9	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
100	La Merced	20204	9	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
101	Succha	20205	9	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
102	Llamellin	20301	10	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
103	Aczo	20302	10	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
104	Chaccho	20303	10	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
105	Chingas	20304	10	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
106	Mirgas	20305	10	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
107	San Juan de Rontoy	20306	10	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
108	Chacas	20401	11	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
109	Acochaca	20402	11	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
110	Chiquian	20501	12	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
111	Abelardo Pardo Lezameta	20502	12	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
112	Antonio Raymondi	20503	12	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
113	Aquia	20504	12	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
114	Cajacay	20505	12	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
115	Canis	20506	12	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
116	Colquioc	20507	12	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
117	Huallanca	20508	12	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
118	Huasta	20509	12	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
119	Huayllacayan	20510	12	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
120	La Primavera	20511	12	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
121	Mangas	20512	12	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
122	Pacllon	20513	12	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
123	San Miguel de Corpanqui	20514	12	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
124	Ticllos	20515	12	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
125	Carhuaz	20601	13	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
126	Acopampa	20602	13	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
127	Amashca	20603	13	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
128	Anta	20604	13	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
129	Ataquero	20605	13	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
130	Marcara	20606	13	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
131	Pariahuanca	20607	13	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
132	San Miguel de Aco	20608	13	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
133	Shilla	20609	13	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
134	Tinco	20610	13	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
135	Yungar	20611	13	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
136	San Luis	20701	14	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
137	San Nicolás	20702	14	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
138	Yauya	20703	14	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
139	Casma	20801	15	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
140	Buena Vista Alta	20802	15	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
141	Comandante Noel	20803	15	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
142	Yautan	20804	15	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
143	Corongo	20901	16	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
144	Aco	20902	16	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
145	Bambas	20903	16	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
146	Cusca	20904	16	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
147	La Pampa	20905	16	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
148	Yanac	20906	16	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
149	Yupan	20907	16	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
150	Huari	21001	17	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
151	Anra	21002	17	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
152	Cajay	21003	17	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
153	Chavin de Huantar	21004	17	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
154	Huacachi	21005	17	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
155	Huacchis	21006	17	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
156	Huachis	21007	17	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
157	Huantar	21008	17	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
158	Masin	21009	17	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
159	Paucas	21010	17	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
160	Ponto	21011	17	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
161	Rahuapampa	21012	17	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
162	Rapayan	21013	17	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
163	San Marcos	21014	17	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
164	San Pedro de Chana	21015	17	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
165	Uco	21016	17	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
166	Huarmey	21101	18	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
167	Cochapeti	21102	18	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
168	Culebras	21103	18	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
169	Huayan	21104	18	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
170	Malvas	21105	18	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
171	Caraz	21201	19	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
172	Huallanca	21202	19	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
173	Huata	21203	19	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
174	Huaylas	21204	19	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
175	Mato	21205	19	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
176	Pamparomas	21206	19	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
177	Pueblo Libre	21207	19	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
178	Santa Cruz	21208	19	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
179	Santo Toribio	21209	19	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
180	Yuracmarca	21210	19	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
181	Piscobamba	21301	20	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
182	Casca	21302	20	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
183	Eleazar Guzmán Barron	21303	20	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
184	Fidel Olivas Escudero	21304	20	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
185	Llama	21305	20	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
186	Llumpa	21306	20	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
187	Lucma	21307	20	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
188	Musga	21308	20	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
189	Ocros	21401	21	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
190	Acas	21402	21	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
191	Cajamarquilla	21403	21	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
192	Carhuapampa	21404	21	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
193	Cochas	21405	21	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
194	Congas	21406	21	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
195	Llipa	21407	21	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
196	San Cristóbal de Rajan	21408	21	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
197	San Pedro	21409	21	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
198	Santiago de Chilcas	21410	21	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
199	Cabana	21501	22	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
200	Bolognesi	21502	22	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
201	Conchucos	21503	22	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
202	Huacaschuque	21504	22	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
203	Huandoval	21505	22	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
204	Lacabamba	21506	22	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
205	Llapo	21507	22	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
206	Pallasca	21508	22	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
207	Pampas	21509	22	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
208	Santa Rosa	21510	22	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
209	Tauca	21511	22	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
210	Pomabamba	21601	23	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
211	Huayllan	21602	23	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
212	Parobamba	21603	23	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
213	Quinuabamba	21604	23	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
214	Recuay	21701	24	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
215	Catac	21702	24	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
216	Cotaparaco	21703	24	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
217	Huayllapampa	21704	24	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
218	Llacllin	21705	24	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
219	Marca	21706	24	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
220	Pampas Chico	21707	24	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
221	Pararin	21708	24	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
222	Tapacocha	21709	24	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
223	Ticapampa	21710	24	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
224	Chimbote	21801	25	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
225	Cáceres del Perú	21802	25	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
226	Coishco	21803	25	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
227	Macate	21804	25	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
228	Moro	21805	25	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
229	Nepeña	21806	25	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
230	Samanco	21807	25	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
231	Santa	21808	25	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
232	Nuevo Chimbote	21809	25	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
233	Sihuas	21901	26	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
234	Acobamba	21902	26	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
235	Alfonso Ugarte	21903	26	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
236	Cashapampa	21904	26	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
237	Chingalpo	21905	26	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
238	Huayllabamba	21906	26	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
239	Quiches	21907	26	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
240	Ragash	21908	26	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
241	San Juan	21909	26	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
242	Sicsibamba	21910	26	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
243	Yungay	22001	27	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
244	Cascapara	22002	27	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
245	Mancos	22003	27	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
246	Matacoto	22004	27	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
247	Quillo	22005	27	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
248	Ranrahirca	22006	27	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
249	Shupluy	22007	27	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
250	Yanama	22008	27	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
251	Abancay	30101	28	3	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
252	Chacoche	30102	28	3	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
253	Circa	30103	28	3	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
254	Curahuasi	30104	28	3	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
255	Huanipaca	30105	28	3	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
256	Lambrama	30106	28	3	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
257	Pichirhua	30107	28	3	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
258	San Pedro de Cachora	30108	28	3	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
259	Tamburco	30109	28	3	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
260	Andahuaylas	30201	29	3	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
261	Andarapa	30202	29	3	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
262	Chiara	30203	29	3	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
263	Huancarama	30204	29	3	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
264	Huancaray	30205	29	3	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
265	Huayana	30206	29	3	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
266	Kishuara	30207	29	3	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
267	Pacobamba	30208	29	3	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
268	Pacucha	30209	29	3	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
269	Pampachiri	30210	29	3	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
270	Pomacocha	30211	29	3	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
271	San Antonio de Cachi	30212	29	3	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
272	San Jerónimo	30213	29	3	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
273	San Miguel de Chaccrampa	30214	29	3	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
274	Santa María de Chicmo	30215	29	3	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
275	Talavera	30216	29	3	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
276	Tumay Huaraca	30217	29	3	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
277	Turpo	30218	29	3	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
278	Kaquiabamba	30219	29	3	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
279	José María Arguedas	30220	29	3	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
280	Antabamba	30301	30	3	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
281	El Oro	30302	30	3	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
282	Huaquirca	30303	30	3	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
283	Juan Espinoza Medrano	30304	30	3	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
284	Oropesa	30305	30	3	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
285	Pachaconas	30306	30	3	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
286	Sabaino	30307	30	3	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
287	Chalhuanca	30401	31	3	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
288	Capaya	30402	31	3	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
289	Caraybamba	30403	31	3	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
290	Chapimarca	30404	31	3	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
291	Colcabamba	30405	31	3	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
292	Cotaruse	30406	31	3	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
293	Ihuayllo	30407	31	3	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
294	Justo Apu Sahuaraura	30408	31	3	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
295	Lucre	30409	31	3	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
296	Pocohuanca	30410	31	3	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
297	San Juan de Chacña	30411	31	3	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
298	Sañayca	30412	31	3	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
299	Soraya	30413	31	3	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
300	Tapairihua	30414	31	3	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
301	Tintay	30415	31	3	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
302	Toraya	30416	31	3	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
303	Yanaca	30417	31	3	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
304	Tambobamba	30501	32	3	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
305	Cotabambas	30502	32	3	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
306	Coyllurqui	30503	32	3	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
307	Haquira	30504	32	3	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
308	Mara	30505	32	3	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
309	Challhuahuacho	30506	32	3	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
310	Chincheros	30601	33	3	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
311	Anco_Huallo	30602	33	3	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
312	Cocharcas	30603	33	3	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
313	Huaccana	30604	33	3	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
314	Ocobamba	30605	33	3	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
315	Ongoy	30606	33	3	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
316	Uranmarca	30607	33	3	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
317	Ranracancha	30608	33	3	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
318	Rocchacc	30609	33	3	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
319	El Porvenir	30610	33	3	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
320	Los Chankas	30611	33	3	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
321	Chuquibambilla	30701	34	3	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
322	Curpahuasi	30702	34	3	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
323	Gamarra	30703	34	3	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
324	Huayllati	30704	34	3	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
325	Mamara	30705	34	3	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
326	Micaela Bastidas	30706	34	3	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
327	Pataypampa	30707	34	3	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
328	Progreso	30708	34	3	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
329	San Antonio	30709	34	3	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
330	Santa Rosa	30710	34	3	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
331	Turpay	30711	34	3	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
332	Vilcabamba	30712	34	3	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
333	Virundo	30713	34	3	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
334	Curasco	30714	34	3	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
335	Arequipa	40101	35	4	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
336	Alto Selva Alegre	40102	35	4	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
337	Cayma	40103	35	4	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
338	Cerro Colorado	40104	35	4	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
339	Characato	40105	35	4	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
340	Chiguata	40106	35	4	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
341	Jacobo Hunter	40107	35	4	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
342	La Joya	40108	35	4	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
343	Mariano Melgar	40109	35	4	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
344	Miraflores	40110	35	4	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
345	Mollebaya	40111	35	4	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
346	Paucarpata	40112	35	4	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
347	Pocsi	40113	35	4	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
348	Polobaya	40114	35	4	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
349	Quequeña	40115	35	4	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
350	Sabandia	40116	35	4	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
351	Sachaca	40117	35	4	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
352	San Juan de Siguas	40118	35	4	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
353	San Juan de Tarucani	40119	35	4	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
354	Santa Isabel de Siguas	40120	35	4	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
355	Santa Rita de Siguas	40121	35	4	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
356	Socabaya	40122	35	4	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
357	Tiabaya	40123	35	4	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
358	Uchumayo	40124	35	4	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
359	Vitor	40125	35	4	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
360	Yanahuara	40126	35	4	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
361	Yarabamba	40127	35	4	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
362	Yura	40128	35	4	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
363	José Luis Bustamante Y Rivero	40129	35	4	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
364	Camaná	40201	36	4	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
365	José María Quimper	40202	36	4	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
366	Mariano Nicolás Valcárcel	40203	36	4	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
367	Mariscal Cáceres	40204	36	4	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
368	Nicolás de Pierola	40205	36	4	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
369	Ocoña	40206	36	4	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
370	Quilca	40207	36	4	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
371	Samuel Pastor	40208	36	4	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
372	Caravelí	40301	37	4	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
373	Acarí	40302	37	4	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
374	Atico	40303	37	4	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
375	Atiquipa	40304	37	4	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
376	Bella Unión	40305	37	4	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
377	Cahuacho	40306	37	4	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
378	Chala	40307	37	4	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
379	Chaparra	40308	37	4	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
380	Huanuhuanu	40309	37	4	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
381	Jaqui	40310	37	4	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
382	Lomas	40311	37	4	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
383	Quicacha	40312	37	4	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
384	Yauca	40313	37	4	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
385	Aplao	40401	38	4	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
386	Andagua	40402	38	4	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
387	Ayo	40403	38	4	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
388	Chachas	40404	38	4	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
389	Chilcaymarca	40405	38	4	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
390	Choco	40406	38	4	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
391	Huancarqui	40407	38	4	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
392	Machaguay	40408	38	4	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
393	Orcopampa	40409	38	4	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
394	Pampacolca	40410	38	4	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
395	Tipan	40411	38	4	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
396	Uñon	40412	38	4	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
397	Uraca	40413	38	4	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
398	Viraco	40414	38	4	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
399	Chivay	40501	39	4	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
400	Achoma	40502	39	4	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
401	Cabanaconde	40503	39	4	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
402	Callalli	40504	39	4	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
403	Caylloma	40505	39	4	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
404	Coporaque	40506	39	4	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
405	Huambo	40507	39	4	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
406	Huanca	40508	39	4	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
407	Ichupampa	40509	39	4	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
408	Lari	40510	39	4	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
409	Lluta	40511	39	4	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
410	Maca	40512	39	4	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
411	Madrigal	40513	39	4	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
412	San Antonio de Chuca	40514	39	4	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
413	Sibayo	40515	39	4	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
414	Tapay	40516	39	4	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
415	Tisco	40517	39	4	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
416	Tuti	40518	39	4	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
417	Yanque	40519	39	4	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
418	Majes	40520	39	4	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
419	Chuquibamba	40601	40	4	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
420	Andaray	40602	40	4	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
421	Cayarani	40603	40	4	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
422	Chichas	40604	40	4	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
423	Iray	40605	40	4	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
424	Río Grande	40606	40	4	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
425	Salamanca	40607	40	4	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
426	Yanaquihua	40608	40	4	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
427	Mollendo	40701	41	4	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
428	Cocachacra	40702	41	4	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
429	Dean Valdivia	40703	41	4	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
430	Islay	40704	41	4	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
431	Mejia	40705	41	4	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
432	Punta de Bombón	40706	41	4	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
433	Cotahuasi	40801	42	4	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
434	Alca	40802	42	4	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
435	Charcana	40803	42	4	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
436	Huaynacotas	40804	42	4	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
437	Pampamarca	40805	42	4	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
438	Puyca	40806	42	4	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
439	Quechualla	40807	42	4	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
440	Sayla	40808	42	4	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
441	Tauria	40809	42	4	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
442	Tomepampa	40810	42	4	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
443	Toro	40811	42	4	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
444	Ayacucho	50101	43	5	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
445	Acocro	50102	43	5	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
446	Acos Vinchos	50103	43	5	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
447	Carmen Alto	50104	43	5	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
448	Chiara	50105	43	5	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
449	Ocros	50106	43	5	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
450	Pacaycasa	50107	43	5	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
451	Quinua	50108	43	5	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
452	San José de Ticllas	50109	43	5	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
453	San Juan Bautista	50110	43	5	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
454	Santiago de Pischa	50111	43	5	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
455	Socos	50112	43	5	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
456	Tambillo	50113	43	5	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
457	Vinchos	50114	43	5	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
458	Jesús Nazareno	50115	43	5	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
459	Andrés Avelino Cáceres Dorregaray	50116	43	5	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
460	Cangallo	50201	44	5	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
461	Chuschi	50202	44	5	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
462	Los Morochucos	50203	44	5	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
463	María Parado de Bellido	50204	44	5	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
464	Paras	50205	44	5	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
465	Totos	50206	44	5	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
466	Sancos	50301	45	5	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
467	Carapo	50302	45	5	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
468	Sacsamarca	50303	45	5	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
469	Santiago de Lucanamarca	50304	45	5	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
470	Huanta	50401	46	5	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
471	Ayahuanco	50402	46	5	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
472	Huamanguilla	50403	46	5	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
473	Iguain	50404	46	5	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
474	Luricocha	50405	46	5	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
475	Santillana	50406	46	5	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
476	Sivia	50407	46	5	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
477	Llochegua	50408	46	5	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
478	Canayre	50409	46	5	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
479	Uchuraccay	50410	46	5	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
480	Pucacolpa	50411	46	5	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
481	Chaca	50412	46	5	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
482	San Miguel	50501	47	5	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
483	Anco	50502	47	5	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
484	Ayna	50503	47	5	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
485	Chilcas	50504	47	5	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
486	Chungui	50505	47	5	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
487	Luis Carranza	50506	47	5	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
488	Santa Rosa	50507	47	5	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
489	Tambo	50508	47	5	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
490	Samugari	50509	47	5	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
491	Anchihuay	50510	47	5	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
492	Oronccoy	50511	47	5	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
493	Puquio	50601	48	5	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
494	Aucara	50602	48	5	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
495	Cabana	50603	48	5	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
496	Carmen Salcedo	50604	48	5	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
497	Chaviña	50605	48	5	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
498	Chipao	50606	48	5	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
499	Huac-Huas	50607	48	5	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
500	Laramate	50608	48	5	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
501	Leoncio Prado	50609	48	5	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
502	Llauta	50610	48	5	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
503	Lucanas	50611	48	5	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
504	Ocaña	50612	48	5	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
505	Otoca	50613	48	5	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
506	Saisa	50614	48	5	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
507	San Cristóbal	50615	48	5	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
508	San Juan	50616	48	5	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
509	San Pedro	50617	48	5	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
510	San Pedro de Palco	50618	48	5	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
511	Sancos	50619	48	5	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
512	Santa Ana de Huaycahuacho	50620	48	5	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
513	Santa Lucia	50621	48	5	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
514	Coracora	50701	49	5	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
515	Chumpi	50702	49	5	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
516	Coronel Castañeda	50703	49	5	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
517	Pacapausa	50704	49	5	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
518	Pullo	50705	49	5	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
519	Puyusca	50706	49	5	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
520	San Francisco de Ravacayco	50707	49	5	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
521	Upahuacho	50708	49	5	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
522	Pausa	50801	50	5	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
523	Colta	50802	50	5	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
524	Corculla	50803	50	5	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
525	Lampa	50804	50	5	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
526	Marcabamba	50805	50	5	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
527	Oyolo	50806	50	5	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
528	Pararca	50807	50	5	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
529	San Javier de Alpabamba	50808	50	5	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
530	San José de Ushua	50809	50	5	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
531	Sara Sara	50810	50	5	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
532	Querobamba	50901	51	5	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
533	Belén	50902	51	5	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
534	Chalcos	50903	51	5	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
535	Chilcayoc	50904	51	5	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
536	Huacaña	50905	51	5	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
537	Morcolla	50906	51	5	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
538	Paico	50907	51	5	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
539	San Pedro de Larcay	50908	51	5	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
540	San Salvador de Quije	50909	51	5	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
541	Santiago de Paucaray	50910	51	5	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
542	Soras	50911	51	5	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
543	Huancapi	51001	52	5	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
544	Alcamenca	51002	52	5	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
545	Apongo	51003	52	5	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
546	Asquipata	51004	52	5	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
547	Canaria	51005	52	5	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
548	Cayara	51006	52	5	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
549	Colca	51007	52	5	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
550	Huamanquiquia	51008	52	5	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
551	Huancaraylla	51009	52	5	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
552	Hualla	51010	52	5	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
553	Sarhua	51011	52	5	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
554	Vilcanchos	51012	52	5	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
555	Vilcas Huaman	51101	53	5	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
556	Accomarca	51102	53	5	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
557	Carhuanca	51103	53	5	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
558	Concepción	51104	53	5	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
559	Huambalpa	51105	53	5	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
560	Independencia	51106	53	5	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
561	Saurama	51107	53	5	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
562	Vischongo	51108	53	5	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
563	Cajamarca	60101	54	6	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
564	Asunción	60102	54	6	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
565	Chetilla	60103	54	6	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
566	Cospan	60104	54	6	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
567	Encañada	60105	54	6	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
568	Jesús	60106	54	6	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
569	Llacanora	60107	54	6	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
570	Los Baños del Inca	60108	54	6	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
571	Magdalena	60109	54	6	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
572	Matara	60110	54	6	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
573	Namora	60111	54	6	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
574	San Juan	60112	54	6	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
575	Cajabamba	60201	55	6	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
576	Cachachi	60202	55	6	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
577	Condebamba	60203	55	6	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
578	Sitacocha	60204	55	6	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
579	Celendín	60301	56	6	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
580	Chumuch	60302	56	6	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
581	Cortegana	60303	56	6	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
582	Huasmin	60304	56	6	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
583	Jorge Chávez	60305	56	6	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
584	José Gálvez	60306	56	6	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
585	Miguel Iglesias	60307	56	6	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
586	Oxamarca	60308	56	6	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
587	Sorochuco	60309	56	6	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
588	Sucre	60310	56	6	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
589	Utco	60311	56	6	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
590	La Libertad de Pallan	60312	56	6	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
591	Chota	60401	57	6	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
592	Anguia	60402	57	6	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
593	Chadin	60403	57	6	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
594	Chiguirip	60404	57	6	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
595	Chimban	60405	57	6	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
596	Choropampa	60406	57	6	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
597	Cochabamba	60407	57	6	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
598	Conchan	60408	57	6	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
599	Huambos	60409	57	6	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
600	Lajas	60410	57	6	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
601	Llama	60411	57	6	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
602	Miracosta	60412	57	6	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
603	Paccha	60413	57	6	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
604	Pion	60414	57	6	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
605	Querocoto	60415	57	6	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
606	San Juan de Licupis	60416	57	6	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
607	Tacabamba	60417	57	6	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
608	Tocmoche	60418	57	6	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
609	Chalamarca	60419	57	6	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
610	Contumaza	60501	58	6	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
611	Chilete	60502	58	6	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
612	Cupisnique	60503	58	6	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
613	Guzmango	60504	58	6	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
614	San Benito	60505	58	6	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
615	Santa Cruz de Toledo	60506	58	6	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
616	Tantarica	60507	58	6	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
617	Yonan	60508	58	6	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
618	Cutervo	60601	59	6	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
619	Callayuc	60602	59	6	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
620	Choros	60603	59	6	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
621	Cujillo	60604	59	6	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
622	La Ramada	60605	59	6	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
623	Pimpingos	60606	59	6	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
624	Querocotillo	60607	59	6	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
625	San Andrés de Cutervo	60608	59	6	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
626	San Juan de Cutervo	60609	59	6	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
627	San Luis de Lucma	60610	59	6	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
628	Santa Cruz	60611	59	6	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
629	Santo Domingo de la Capilla	60612	59	6	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
630	Santo Tomas	60613	59	6	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
631	Socota	60614	59	6	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
632	Toribio Casanova	60615	59	6	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
633	Bambamarca	60701	60	6	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
634	Chugur	60702	60	6	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
635	Hualgayoc	60703	60	6	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
636	Jaén	60801	61	6	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
637	Bellavista	60802	61	6	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
638	Chontali	60803	61	6	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
639	Colasay	60804	61	6	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
640	Huabal	60805	61	6	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
641	Las Pirias	60806	61	6	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
642	Pomahuaca	60807	61	6	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
643	Pucara	60808	61	6	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
644	Sallique	60809	61	6	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
645	San Felipe	60810	61	6	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
646	San José del Alto	60811	61	6	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
647	Santa Rosa	60812	61	6	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
648	San Ignacio	60901	62	6	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
649	Chirinos	60902	62	6	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
650	Huarango	60903	62	6	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
651	La Coipa	60904	62	6	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
652	Namballe	60905	62	6	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
653	San José de Lourdes	60906	62	6	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
654	Tabaconas	60907	62	6	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
655	Pedro Gálvez	61001	63	6	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
656	Chancay	61002	63	6	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
657	Eduardo Villanueva	61003	63	6	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
658	Gregorio Pita	61004	63	6	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
659	Ichocan	61005	63	6	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
660	José Manuel Quiroz	61006	63	6	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
661	José Sabogal	61007	63	6	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
662	San Miguel	61101	64	6	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
663	Bolívar	61102	64	6	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
664	Calquis	61103	64	6	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
665	Catilluc	61104	64	6	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
666	El Prado	61105	64	6	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
667	La Florida	61106	64	6	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
668	Llapa	61107	64	6	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
669	Nanchoc	61108	64	6	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
670	Niepos	61109	64	6	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
671	San Gregorio	61110	64	6	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
672	San Silvestre de Cochan	61111	64	6	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
673	Tongod	61112	64	6	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
674	Unión Agua Blanca	61113	64	6	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
675	San Pablo	61201	65	6	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
676	San Bernardino	61202	65	6	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
677	San Luis	61203	65	6	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
678	Tumbaden	61204	65	6	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
679	Santa Cruz	61301	66	6	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
680	Andabamba	61302	66	6	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
681	Catache	61303	66	6	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
682	Chancaybaños	61304	66	6	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
683	La Esperanza	61305	66	6	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
684	Ninabamba	61306	66	6	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
685	Pulan	61307	66	6	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
686	Saucepampa	61308	66	6	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
687	Sexi	61309	66	6	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
688	Uticyacu	61310	66	6	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
689	Yauyucan	61311	66	6	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
690	Callao	70101	67	7	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
691	Bellavista	70102	67	7	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
692	Carmen de la Legua Reynoso	70103	67	7	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
693	La Perla	70104	67	7	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
694	La Punta	70105	67	7	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
695	Ventanilla	70106	67	7	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
696	Mi Perú	70107	67	7	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
697	Cusco	80101	68	8	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
698	Ccorca	80102	68	8	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
699	Poroy	80103	68	8	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
700	San Jerónimo	80104	68	8	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
701	San Sebastian	80105	68	8	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
702	Santiago	80106	68	8	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
703	Saylla	80107	68	8	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
704	Wanchaq	80108	68	8	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
705	Acomayo	80201	69	8	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
706	Acopia	80202	69	8	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
707	Acos	80203	69	8	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
708	Mosoc Llacta	80204	69	8	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
709	Pomacanchi	80205	69	8	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
710	Rondocan	80206	69	8	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
711	Sangarara	80207	69	8	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
712	Anta	80301	70	8	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
713	Ancahuasi	80302	70	8	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
714	Cachimayo	80303	70	8	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
715	Chinchaypujio	80304	70	8	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
716	Huarocondo	80305	70	8	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
717	Limatambo	80306	70	8	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
718	Mollepata	80307	70	8	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
719	Pucyura	80308	70	8	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
720	Zurite	80309	70	8	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
721	Calca	80401	71	8	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
722	Coya	80402	71	8	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
723	Lamay	80403	71	8	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
724	Lares	80404	71	8	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
725	Pisac	80405	71	8	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
726	San Salvador	80406	71	8	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
727	Taray	80407	71	8	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
728	Yanatile	80408	71	8	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
729	Yanaoca	80501	72	8	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
730	Checca	80502	72	8	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
731	Kunturkanki	80503	72	8	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
732	Langui	80504	72	8	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
733	Layo	80505	72	8	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
734	Pampamarca	80506	72	8	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
735	Quehue	80507	72	8	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
736	Tupac Amaru	80508	72	8	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
737	Sicuani	80601	73	8	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
738	Checacupe	80602	73	8	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
739	Combapata	80603	73	8	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
740	Marangani	80604	73	8	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
741	Pitumarca	80605	73	8	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
742	San Pablo	80606	73	8	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
743	San Pedro	80607	73	8	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
744	Tinta	80608	73	8	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
745	Santo Tomas	80701	74	8	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
746	Capacmarca	80702	74	8	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
747	Chamaca	80703	74	8	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
748	Colquemarca	80704	74	8	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
749	Livitaca	80705	74	8	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
750	Llusco	80706	74	8	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
751	Quiñota	80707	74	8	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
752	Velille	80708	74	8	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
753	Espinar	80801	75	8	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
754	Condoroma	80802	75	8	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
755	Coporaque	80803	75	8	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
756	Ocoruro	80804	75	8	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
757	Pallpata	80805	75	8	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
758	Pichigua	80806	75	8	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
759	Suyckutambo	80807	75	8	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
760	Alto Pichigua	80808	75	8	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
761	Santa Ana	80901	76	8	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
762	Echarate	80902	76	8	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
763	Huayopata	80903	76	8	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
764	Maranura	80904	76	8	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
765	Ocobamba	80905	76	8	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
766	Quellouno	80906	76	8	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
767	Kimbiri	80907	76	8	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
768	Santa Teresa	80908	76	8	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
769	Vilcabamba	80909	76	8	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
770	Pichari	80910	76	8	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
771	Inkawasi	80911	76	8	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
772	Villa Virgen	80912	76	8	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
773	Villa Kintiarina	80913	76	8	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
774	Megantoni	80914	76	8	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
775	Paruro	81001	77	8	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
776	Accha	81002	77	8	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
777	Ccapi	81003	77	8	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
778	Colcha	81004	77	8	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
779	Huanoquite	81005	77	8	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
780	Omachaç	81006	77	8	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
781	Paccaritambo	81007	77	8	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
782	Pillpinto	81008	77	8	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
783	Yaurisque	81009	77	8	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
784	Paucartambo	81101	78	8	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
785	Caicay	81102	78	8	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
786	Challabamba	81103	78	8	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
787	Colquepata	81104	78	8	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
788	Huancarani	81105	78	8	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
789	Kosñipata	81106	78	8	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
790	Urcos	81201	79	8	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
791	Andahuaylillas	81202	79	8	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
792	Camanti	81203	79	8	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
793	Ccarhuayo	81204	79	8	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
794	Ccatca	81205	79	8	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
795	Cusipata	81206	79	8	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
796	Huaro	81207	79	8	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
797	Lucre	81208	79	8	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
798	Marcapata	81209	79	8	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
799	Ocongate	81210	79	8	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
800	Oropesa	81211	79	8	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
801	Quiquijana	81212	79	8	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
802	Urubamba	81301	80	8	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
803	Chinchero	81302	80	8	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
804	Huayllabamba	81303	80	8	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
805	Machupicchu	81304	80	8	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
806	Maras	81305	80	8	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
807	Ollantaytambo	81306	80	8	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
808	Yucay	81307	80	8	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
809	Huancavelica	90101	81	9	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
810	Acobambilla	90102	81	9	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
811	Acoria	90103	81	9	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
812	Conayca	90104	81	9	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
813	Cuenca	90105	81	9	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
814	Huachocolpa	90106	81	9	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
815	Huayllahuara	90107	81	9	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
816	Izcuchaca	90108	81	9	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
817	Laria	90109	81	9	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
818	Manta	90110	81	9	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
819	Mariscal Cáceres	90111	81	9	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
820	Moya	90112	81	9	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
821	Nuevo Occoro	90113	81	9	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
822	Palca	90114	81	9	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
823	Pilchaca	90115	81	9	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
824	Vilca	90116	81	9	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
825	Yauli	90117	81	9	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
826	Ascensión	90118	81	9	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
827	Huando	90119	81	9	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
828	Acobamba	90201	82	9	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
829	Andabamba	90202	82	9	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
830	Anta	90203	82	9	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
831	Caja	90204	82	9	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
832	Marcas	90205	82	9	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
833	Paucara	90206	82	9	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
834	Pomacocha	90207	82	9	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
835	Rosario	90208	82	9	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
836	Lircay	90301	83	9	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
837	Anchonga	90302	83	9	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
838	Callanmarca	90303	83	9	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
839	Ccochaccasa	90304	83	9	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
840	Chincho	90305	83	9	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
841	Congalla	90306	83	9	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
842	Huanca-Huanca	90307	83	9	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
843	Huayllay Grande	90308	83	9	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
844	Julcamarca	90309	83	9	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
845	San Antonio de Antaparco	90310	83	9	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
846	Santo Tomas de Pata	90311	83	9	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
847	Secclla	90312	83	9	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
848	Castrovirreyna	90401	84	9	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
849	Arma	90402	84	9	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
850	Aurahua	90403	84	9	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
851	Capillas	90404	84	9	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
852	Chupamarca	90405	84	9	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
853	Cocas	90406	84	9	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
854	Huachos	90407	84	9	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
855	Huamatambo	90408	84	9	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
856	Mollepampa	90409	84	9	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
857	San Juan	90410	84	9	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
858	Santa Ana	90411	84	9	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
859	Tantara	90412	84	9	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
860	Ticrapo	90413	84	9	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
861	Churcampa	90501	85	9	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
862	Anco	90502	85	9	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
863	Chinchihuasi	90503	85	9	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
864	El Carmen	90504	85	9	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
865	La Merced	90505	85	9	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
866	Locroja	90506	85	9	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
867	Paucarbamba	90507	85	9	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
868	San Miguel de Mayocc	90508	85	9	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
869	San Pedro de Coris	90509	85	9	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
870	Pachamarca	90510	85	9	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
871	Cosme	90511	85	9	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
872	Huaytara	90601	86	9	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
873	Ayavi	90602	86	9	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
874	Córdova	90603	86	9	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
875	Huayacundo Arma	90604	86	9	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
876	Laramarca	90605	86	9	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
877	Ocoyo	90606	86	9	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
878	Pilpichaca	90607	86	9	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
879	Querco	90608	86	9	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
880	Quito-Arma	90609	86	9	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
881	San Antonio de Cusicancha	90610	86	9	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
882	San Francisco de Sangayaico	90611	86	9	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
883	San Isidro	90612	86	9	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
884	Santiago de Chocorvos	90613	86	9	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
885	Santiago de Quirahuara	90614	86	9	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
886	Santo Domingo de Capillas	90615	86	9	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
887	Tambo	90616	86	9	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
888	Pampas	90701	87	9	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
889	Acostambo	90702	87	9	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
890	Acraquia	90703	87	9	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
891	Ahuaycha	90704	87	9	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
892	Colcabamba	90705	87	9	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
893	Daniel Hernández	90706	87	9	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
894	Huachocolpa	90707	87	9	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
895	Huaribamba	90709	87	9	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
896	Ñahuimpuquio	90710	87	9	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
897	Pazos	90711	87	9	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
898	Quishuar	90713	87	9	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
899	Salcabamba	90714	87	9	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
900	Salcahuasi	90715	87	9	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
901	San Marcos de Rocchac	90716	87	9	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
902	Surcubamba	90717	87	9	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
903	Tintay Puncu	90718	87	9	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
904	Quichuas	90719	87	9	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
905	Andaymarca	90720	87	9	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
906	Roble	90721	87	9	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
907	Pichos	90722	87	9	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
908	Santiago de Tucuma	90723	87	9	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
909	Huanuco	100101	88	10	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
910	Amarilis	100102	88	10	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
911	Chinchao	100103	88	10	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
912	Churubamba	100104	88	10	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
913	Margos	100105	88	10	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
914	Quisqui (Kichki)	100106	88	10	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
915	San Francisco de Cayran	100107	88	10	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
916	San Pedro de Chaulan	100108	88	10	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
917	Santa María del Valle	100109	88	10	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
918	Yarumayo	100110	88	10	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
919	Pillco Marca	100111	88	10	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
920	Yacus	100112	88	10	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
921	San Pablo de Pillao	100113	88	10	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
922	Ambo	100201	89	10	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
923	Cayna	100202	89	10	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
924	Colpas	100203	89	10	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
925	Conchamarca	100204	89	10	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
926	Huacar	100205	89	10	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
927	San Francisco	100206	89	10	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
928	San Rafael	100207	89	10	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
929	Tomay Kichwa	100208	89	10	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
930	La Unión	100301	90	10	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
931	Chuquis	100307	90	10	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
932	Marías	100311	90	10	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
933	Pachas	100313	90	10	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
934	Quivilla	100316	90	10	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
935	Ripan	100317	90	10	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
936	Shunqui	100321	90	10	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
937	Sillapata	100322	90	10	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
938	Yanas	100323	90	10	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
939	Huacaybamba	100401	91	10	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
940	Canchabamba	100402	91	10	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
941	Cochabamba	100403	91	10	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
942	Pinra	100404	91	10	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
943	Llata	100501	92	10	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
944	Arancay	100502	92	10	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
945	Chavín de Pariarca	100503	92	10	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
946	Jacas Grande	100504	92	10	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
947	Jircan	100505	92	10	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
948	Miraflores	100506	92	10	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
949	Monzón	100507	92	10	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
950	Punchao	100508	92	10	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
951	Puños	100509	92	10	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
952	Singa	100510	92	10	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
953	Tantamayo	100511	92	10	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
954	Rupa-Rupa	100601	93	10	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
955	Daniel Alomía Robles	100602	93	10	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
956	Hermílio Valdizan	100603	93	10	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
957	José Crespo y Castillo	100604	93	10	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
958	Luyando	100605	93	10	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
959	Mariano Damaso Beraun	100606	93	10	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
960	Pucayacu	100607	93	10	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
961	Castillo Grande	100608	93	10	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
962	Pueblo Nuevo	100609	93	10	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
963	Santo Domingo de Anda	100610	93	10	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
964	Huacrachuco	100701	94	10	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
965	Cholon	100702	94	10	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
966	San Buenaventura	100703	94	10	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
967	La Morada	100704	94	10	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
968	Santa Rosa de Alto Yanajanca	100705	94	10	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
969	Panao	100801	95	10	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
970	Chaglla	100802	95	10	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
971	Molino	100803	95	10	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
972	Umari	100804	95	10	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
973	Puerto Inca	100901	96	10	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
974	Codo del Pozuzo	100902	96	10	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
975	Honoria	100903	96	10	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
976	Tournavista	100904	96	10	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
977	Yuyapichis	100905	96	10	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
978	Jesús	101001	97	10	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
979	Baños	101002	97	10	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
980	Jivia	101003	97	10	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
981	Queropalca	101004	97	10	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
982	Rondos	101005	97	10	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
983	San Francisco de Asís	101006	97	10	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
984	San Miguel de Cauri	101007	97	10	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
985	Chavinillo	101101	98	10	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
986	Cahuac	101102	98	10	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
987	Chacabamba	101103	98	10	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
988	Aparicio Pomares	101104	98	10	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
989	Jacas Chico	101105	98	10	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
990	Obas	101106	98	10	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
991	Pampamarca	101107	98	10	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
992	Choras	101108	98	10	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
993	Ica	110101	99	11	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
994	La Tinguiña	110102	99	11	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
995	Los Aquijes	110103	99	11	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
996	Ocucaje	110104	99	11	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
997	Pachacutec	110105	99	11	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
998	Parcona	110106	99	11	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
999	Pueblo Nuevo	110107	99	11	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1000	Salas	110108	99	11	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1001	San José de Los Molinos	110109	99	11	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1002	San Juan Bautista	110110	99	11	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1003	Santiago	110111	99	11	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1004	Subtanjalla	110112	99	11	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1005	Tate	110113	99	11	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1006	Yauca del Rosario	110114	99	11	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1007	Chincha Alta	110201	100	11	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1008	Alto Laran	110202	100	11	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1009	Chavin	110203	100	11	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1010	Chincha Baja	110204	100	11	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1011	El Carmen	110205	100	11	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1012	Grocio Prado	110206	100	11	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1013	Pueblo Nuevo	110207	100	11	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1014	San Juan de Yanac	110208	100	11	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1015	San Pedro de Huacarpana	110209	100	11	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1016	Sunampe	110210	100	11	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1017	Tambo de Mora	110211	100	11	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1018	Nasca	110301	101	11	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1019	Changuillo	110302	101	11	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1020	El Ingenio	110303	101	11	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1021	Marcona	110304	101	11	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1022	Vista Alegre	110305	101	11	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1023	Palpa	110401	102	11	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1024	Llipata	110402	102	11	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1025	Río Grande	110403	102	11	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1026	Santa Cruz	110404	102	11	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1027	Tibillo	110405	102	11	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1028	Pisco	110501	103	11	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1029	Huancano	110502	103	11	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1030	Humay	110503	103	11	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1031	Independencia	110504	103	11	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1032	Paracas	110505	103	11	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1033	San Andrés	110506	103	11	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1034	San Clemente	110507	103	11	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1035	Tupac Amaru Inca	110508	103	11	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1036	Huancayo	120101	104	12	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1037	Carhuacallanga	120104	104	12	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1038	Chacapampa	120105	104	12	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1039	Chicche	120106	104	12	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1040	Chilca	120107	104	12	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1041	Chongos Alto	120108	104	12	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1042	Chupuro	120111	104	12	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1043	Colca	120112	104	12	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1044	Cullhuas	120113	104	12	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1045	El Tambo	120114	104	12	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1046	Huacrapuquio	120116	104	12	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1047	Hualhuas	120117	104	12	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1048	Huancan	120119	104	12	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1049	Huasicancha	120120	104	12	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1050	Huayucachi	120121	104	12	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1051	Ingenio	120122	104	12	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1052	Pariahuanca	120124	104	12	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1053	Pilcomayo	120125	104	12	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1054	Pucara	120126	104	12	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1055	Quichuay	120127	104	12	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1056	Quilcas	120128	104	12	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1057	San Agustín	120129	104	12	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1058	San Jerónimo de Tunan	120130	104	12	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1059	Saño	120132	104	12	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1060	Sapallanga	120133	104	12	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1061	Sicaya	120134	104	12	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1062	Santo Domingo de Acobamba	120135	104	12	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1063	Viques	120136	104	12	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1064	Concepción	120201	105	12	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1065	Aco	120202	105	12	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1066	Andamarca	120203	105	12	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1067	Chambara	120204	105	12	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1068	Cochas	120205	105	12	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1069	Comas	120206	105	12	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1070	Heroínas Toledo	120207	105	12	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1071	Manzanares	120208	105	12	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1072	Mariscal Castilla	120209	105	12	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1073	Matahuasi	120210	105	12	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1074	Mito	120211	105	12	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1075	Nueve de Julio	120212	105	12	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1076	Orcotuna	120213	105	12	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1077	San José de Quero	120214	105	12	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1078	Santa Rosa de Ocopa	120215	105	12	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1079	Chanchamayo	120301	106	12	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1080	Perene	120302	106	12	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1081	Pichanaqui	120303	106	12	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1082	San Luis de Shuaro	120304	106	12	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1083	San Ramón	120305	106	12	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1084	Vitoc	120306	106	12	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1085	Jauja	120401	107	12	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1086	Acolla	120402	107	12	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1087	Apata	120403	107	12	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1088	Ataura	120404	107	12	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1089	Canchayllo	120405	107	12	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1090	Curicaca	120406	107	12	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1091	El Mantaro	120407	107	12	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1092	Huamali	120408	107	12	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1093	Huaripampa	120409	107	12	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1094	Huertas	120410	107	12	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1095	Janjaillo	120411	107	12	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1096	Julcán	120412	107	12	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1097	Leonor Ordóñez	120413	107	12	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1098	Llocllapampa	120414	107	12	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1099	Marco	120415	107	12	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1100	Masma	120416	107	12	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1101	Masma Chicche	120417	107	12	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1102	Molinos	120418	107	12	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1103	Monobamba	120419	107	12	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1104	Muqui	120420	107	12	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1105	Muquiyauyo	120421	107	12	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1106	Paca	120422	107	12	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1107	Paccha	120423	107	12	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1108	Pancan	120424	107	12	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1109	Parco	120425	107	12	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1110	Pomacancha	120426	107	12	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1111	Ricran	120427	107	12	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1112	San Lorenzo	120428	107	12	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1113	San Pedro de Chunan	120429	107	12	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1114	Sausa	120430	107	12	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1115	Sincos	120431	107	12	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1116	Tunan Marca	120432	107	12	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1117	Yauli	120433	107	12	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1118	Yauyos	120434	107	12	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1119	Junin	120501	108	12	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1120	Carhuamayo	120502	108	12	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1121	Ondores	120503	108	12	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1122	Ulcumayo	120504	108	12	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1123	Satipo	120601	109	12	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1124	Coviriali	120602	109	12	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1125	Llaylla	120603	109	12	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1126	Mazamari	120604	109	12	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1127	Pampa Hermosa	120605	109	12	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1128	Pangoa	120606	109	12	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1129	Río Negro	120607	109	12	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1130	Río Tambo	120608	109	12	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1131	Vizcatan del Ene	120609	109	12	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1132	Tarma	120701	110	12	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1133	Acobamba	120702	110	12	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1134	Huaricolca	120703	110	12	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1135	Huasahuasi	120704	110	12	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1136	La Unión	120705	110	12	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1137	Palca	120706	110	12	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1138	Palcamayo	120707	110	12	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1139	San Pedro de Cajas	120708	110	12	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1140	Tapo	120709	110	12	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1141	La Oroya	120801	111	12	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1142	Chacapalpa	120802	111	12	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1143	Huay-Huay	120803	111	12	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1144	Marcapomacocha	120804	111	12	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1145	Morococha	120805	111	12	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1146	Paccha	120806	111	12	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1147	Santa Bárbara de Carhuacayan	120807	111	12	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1148	Santa Rosa de Sacco	120808	111	12	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1149	Suitucancha	120809	111	12	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1150	Yauli	120810	111	12	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1151	Chupaca	120901	112	12	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1152	Ahuac	120902	112	12	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1153	Chongos Bajo	120903	112	12	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1154	Huachac	120904	112	12	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1155	Huamancaca Chico	120905	112	12	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1156	San Juan de Iscos	120906	112	12	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1157	San Juan de Jarpa	120907	112	12	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1158	Tres de Diciembre	120908	112	12	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1159	Yanacancha	120909	112	12	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1160	Trujillo	130101	113	13	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1161	El Porvenir	130102	113	13	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1162	Florencia de Mora	130103	113	13	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1163	Huanchaco	130104	113	13	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1164	La Esperanza	130105	113	13	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1165	Laredo	130106	113	13	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1166	Moche	130107	113	13	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1167	Poroto	130108	113	13	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1168	Salaverry	130109	113	13	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1169	Simbal	130110	113	13	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1170	Victor Larco Herrera	130111	113	13	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1171	Ascope	130201	114	13	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1172	Chicama	130202	114	13	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1173	Chocope	130203	114	13	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1174	Magdalena de Cao	130204	114	13	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1175	Paijan	130205	114	13	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1176	Rázuri	130206	114	13	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1177	Santiago de Cao	130207	114	13	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1178	Casa Grande	130208	114	13	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1179	Bolívar	130301	115	13	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1180	Bambamarca	130302	115	13	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1181	Condormarca	130303	115	13	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1182	Longotea	130304	115	13	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1183	Uchumarca	130305	115	13	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1184	Ucuncha	130306	115	13	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1185	Chepen	130401	116	13	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1186	Pacanga	130402	116	13	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1187	Pueblo Nuevo	130403	116	13	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1188	Julcan	130501	117	13	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1189	Calamarca	130502	117	13	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1190	Carabamba	130503	117	13	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1191	Huaso	130504	117	13	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1192	Otuzco	130601	118	13	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1193	Agallpampa	130602	118	13	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1194	Charat	130604	118	13	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1195	Huaranchal	130605	118	13	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1196	La Cuesta	130606	118	13	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1197	Mache	130608	118	13	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1198	Paranday	130610	118	13	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1199	Salpo	130611	118	13	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1200	Sinsicap	130613	118	13	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1201	Usquil	130614	118	13	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1202	San Pedro de Lloc	130701	119	13	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1203	Guadalupe	130702	119	13	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1204	Jequetepeque	130703	119	13	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1205	Pacasmayo	130704	119	13	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1206	San José	130705	119	13	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1207	Tayabamba	130801	120	13	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1208	Buldibuyo	130802	120	13	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1209	Chillia	130803	120	13	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1210	Huancaspata	130804	120	13	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1211	Huaylillas	130805	120	13	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1212	Huayo	130806	120	13	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1213	Ongon	130807	120	13	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1214	Parcoy	130808	120	13	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1215	Pataz	130809	120	13	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1216	Pias	130810	120	13	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1217	Santiago de Challas	130811	120	13	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1218	Taurija	130812	120	13	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1219	Urpay	130813	120	13	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1220	Huamachuco	130901	121	13	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1221	Chugay	130902	121	13	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1222	Cochorco	130903	121	13	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1223	Curgos	130904	121	13	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1224	Marcabal	130905	121	13	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1225	Sanagoran	130906	121	13	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1226	Sarin	130907	121	13	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1227	Sartimbamba	130908	121	13	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1228	Santiago de Chuco	131001	122	13	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1229	Angasmarca	131002	122	13	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1230	Cachicadan	131003	122	13	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1231	Mollebamba	131004	122	13	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1232	Mollepata	131005	122	13	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1233	Quiruvilca	131006	122	13	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1234	Santa Cruz de Chuca	131007	122	13	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1235	Sitabamba	131008	122	13	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1236	Cascas	131101	123	13	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1237	Lucma	131102	123	13	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1238	Marmot	131103	123	13	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1239	Sayapullo	131104	123	13	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1240	Viru	131201	124	13	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1241	Chao	131202	124	13	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1242	Guadalupito	131203	124	13	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1243	Chiclayo	140101	125	14	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1244	Chongoyape	140102	125	14	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1245	Eten	140103	125	14	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1246	Eten Puerto	140104	125	14	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1247	José Leonardo Ortiz	140105	125	14	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1248	La Victoria	140106	125	14	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1249	Lagunas	140107	125	14	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1250	Monsefu	140108	125	14	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1251	Nueva Arica	140109	125	14	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1252	Oyotun	140110	125	14	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1253	Picsi	140111	125	14	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1254	Pimentel	140112	125	14	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1255	Reque	140113	125	14	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1256	Santa Rosa	140114	125	14	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1257	Saña	140115	125	14	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1258	Cayalti	140116	125	14	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1259	Patapo	140117	125	14	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1260	Pomalca	140118	125	14	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1261	Pucala	140119	125	14	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1262	Tuman	140120	125	14	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1263	Ferreñafe	140201	126	14	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1264	Cañaris	140202	126	14	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1265	Incahuasi	140203	126	14	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1266	Manuel Antonio Mesones Muro	140204	126	14	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1267	Pitipo	140205	126	14	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1268	Pueblo Nuevo	140206	126	14	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1269	Lambayeque	140301	127	14	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1270	Chochope	140302	127	14	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1271	Illimo	140303	127	14	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1272	Jayanca	140304	127	14	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1273	Mochumi	140305	127	14	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1274	Morrope	140306	127	14	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1275	Motupe	140307	127	14	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1276	Olmos	140308	127	14	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1277	Pacora	140309	127	14	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1278	Salas	140310	127	14	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1279	San José	140311	127	14	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1280	Tucume	140312	127	14	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1281	Lima	150101	128	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1282	Ancón	150102	128	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1283	Ate	150103	128	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1284	Barranco	150104	128	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1285	Breña	150105	128	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1286	Carabayllo	150106	128	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1287	Chaclacayo	150107	128	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1288	Chorrillos	150108	128	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1289	Cieneguilla	150109	128	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1290	Comas	150110	128	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1291	El Agustino	150111	128	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1292	Independencia	150112	128	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1293	Jesús María	150113	128	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1294	La Molina	150114	128	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1295	La Victoria	150115	128	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1296	Lince	150116	128	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1297	Los Olivos	150117	128	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1298	Lurigancho	150118	128	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1299	Lurin	150119	128	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1300	Magdalena del Mar	150120	128	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1301	Pueblo Libre	150121	128	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1302	Miraflores	150122	128	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1303	Pachacamac	150123	128	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1304	Pucusana	150124	128	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1305	Puente Piedra	150125	128	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1306	Punta Hermosa	150126	128	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1307	Punta Negra	150127	128	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1308	Rímac	150128	128	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1309	San Bartolo	150129	128	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1310	San Borja	150130	128	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1311	San Isidro	150131	128	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1312	San Juan de Lurigancho	150132	128	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1313	San Juan de Miraflores	150133	128	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1314	San Luis	150134	128	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1315	San Martín de Porres	150135	128	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1316	San Miguel	150136	128	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1317	Santa Anita	150137	128	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1318	Santa María del Mar	150138	128	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1319	Santa Rosa	150139	128	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1320	Santiago de Surco	150140	128	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1321	Surquillo	150141	128	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1322	Villa El Salvador	150142	128	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1323	Villa María del Triunfo	150143	128	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1324	Barranca	150201	129	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1325	Paramonga	150202	129	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1326	Pativilca	150203	129	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1327	Supe	150204	129	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1328	Supe Puerto	150205	129	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1329	Cajatambo	150301	130	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1330	Copa	150302	130	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1331	Gorgor	150303	130	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1332	Huancapon	150304	130	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1333	Manas	150305	130	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1334	Canta	150401	131	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1335	Arahuay	150402	131	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1336	Huamantanga	150403	131	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1337	Huaros	150404	131	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1338	Lachaqui	150405	131	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1339	San Buenaventura	150406	131	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1340	Santa Rosa de Quives	150407	131	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1341	San Vicente de Cañete	150501	132	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1342	Asia	150502	132	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1343	Calango	150503	132	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1344	Cerro Azul	150504	132	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1345	Chilca	150505	132	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1346	Coayllo	150506	132	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1347	Imperial	150507	132	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1348	Lunahuana	150508	132	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1349	Mala	150509	132	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1350	Nuevo Imperial	150510	132	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1351	Pacaran	150511	132	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1352	Quilmana	150512	132	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1353	San Antonio	150513	132	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1354	San Luis	150514	132	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1355	Santa Cruz de Flores	150515	132	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1356	Zúñiga	150516	132	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1357	Huaral	150601	133	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1358	Atavillos Alto	150602	133	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1359	Atavillos Bajo	150603	133	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1360	Aucallama	150604	133	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1361	Chancay	150605	133	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1362	Ihuari	150606	133	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1363	Lampian	150607	133	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1364	Pacaraos	150608	133	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1365	San Miguel de Acos	150609	133	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1366	Santa Cruz de Andamarca	150610	133	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1367	Sumbilca	150611	133	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1368	Veintisiete de Noviembre	150612	133	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1369	Matucana	150701	134	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1370	Antioquia	150702	134	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1371	Callahuanca	150703	134	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1372	Carampoma	150704	134	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1373	Chicla	150705	134	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1374	Cuenca	150706	134	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1375	Huachupampa	150707	134	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1376	Huanza	150708	134	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1377	Huarochiri	150709	134	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1378	Lahuaytambo	150710	134	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1379	Langa	150711	134	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1380	Laraos	150712	134	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1381	Mariatana	150713	134	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1382	Ricardo Palma	150714	134	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1383	San Andrés de Tupicocha	150715	134	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1384	San Antonio	150716	134	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1385	San Bartolomé	150717	134	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1386	San Damian	150718	134	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1387	San Juan de Iris	150719	134	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1388	San Juan de Tantaranche	150720	134	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1389	San Lorenzo de Quinti	150721	134	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1390	San Mateo	150722	134	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1391	San Mateo de Otao	150723	134	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1392	San Pedro de Casta	150724	134	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1393	San Pedro de Huancayre	150725	134	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1394	Sangallaya	150726	134	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1395	Santa Cruz de Cocachacra	150727	134	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1396	Santa Eulalia	150728	134	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1397	Santiago de Anchucaya	150729	134	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1398	Santiago de Tuna	150730	134	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1399	Santo Domingo de Los Olleros	150731	134	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1400	Surco	150732	134	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1401	Huacho	150801	135	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1402	Ambar	150802	135	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1403	Caleta de Carquin	150803	135	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1404	Checras	150804	135	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1405	Hualmay	150805	135	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1406	Huaura	150806	135	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1407	Leoncio Prado	150807	135	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1408	Paccho	150808	135	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1409	Santa Leonor	150809	135	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1410	Santa María	150810	135	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1411	Sayan	150811	135	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1412	Vegueta	150812	135	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1413	Oyon	150901	136	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1414	Andajes	150902	136	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1415	Caujul	150903	136	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1416	Cochamarca	150904	136	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1417	Navan	150905	136	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1418	Pachangara	150906	136	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1419	Yauyos	151001	137	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1420	Alis	151002	137	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1421	Allauca	151003	137	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1422	Ayaviri	151004	137	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1423	Azángaro	151005	137	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1424	Cacra	151006	137	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1425	Carania	151007	137	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1426	Catahuasi	151008	137	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1427	Chocos	151009	137	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1428	Cochas	151010	137	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1429	Colonia	151011	137	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1430	Hongos	151012	137	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1431	Huampara	151013	137	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1432	Huancaya	151014	137	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1433	Huangascar	151015	137	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1434	Huantan	151016	137	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1435	Huañec	151017	137	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1436	Laraos	151018	137	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1437	Lincha	151019	137	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1438	Madean	151020	137	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1439	Miraflores	151021	137	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1440	Omas	151022	137	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1441	Putinza	151023	137	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1442	Quinches	151024	137	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1443	Quinocay	151025	137	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1444	San Joaquín	151026	137	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1445	San Pedro de Pilas	151027	137	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1446	Tanta	151028	137	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1447	Tauripampa	151029	137	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1448	Tomas	151030	137	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1449	Tupe	151031	137	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1450	Viñac	151032	137	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1451	Vitis	151033	137	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1452	Iquitos	160101	138	16	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1453	Alto Nanay	160102	138	16	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1454	Fernando Lores	160103	138	16	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1455	Indiana	160104	138	16	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1456	Las Amazonas	160105	138	16	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1457	Mazan	160106	138	16	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1458	Napo	160107	138	16	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1459	Punchana	160108	138	16	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1460	Torres Causana	160110	138	16	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1461	Belén	160112	138	16	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1462	San Juan Bautista	160113	138	16	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1463	Yurimaguas	160201	139	16	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1464	Balsapuerto	160202	139	16	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1465	Jeberos	160205	139	16	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1466	Lagunas	160206	139	16	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1467	Santa Cruz	160210	139	16	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1468	Teniente Cesar López Rojas	160211	139	16	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1469	Nauta	160301	140	16	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1470	Parinari	160302	140	16	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1471	Tigre	160303	140	16	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1472	Trompeteros	160304	140	16	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1473	Urarinas	160305	140	16	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1474	Ramón Castilla	160401	141	16	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1475	Pebas	160402	141	16	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1476	Yavari	160403	141	16	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1477	San Pablo	160404	141	16	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1478	Requena	160501	142	16	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1479	Alto Tapiche	160502	142	16	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1480	Capelo	160503	142	16	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1481	Emilio San Martín	160504	142	16	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1482	Maquia	160505	142	16	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1483	Puinahua	160506	142	16	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1484	Saquena	160507	142	16	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1485	Soplin	160508	142	16	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1486	Tapiche	160509	142	16	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1487	Jenaro Herrera	160510	142	16	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1488	Yaquerana	160511	142	16	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1489	Contamana	160601	143	16	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1490	Inahuaya	160602	143	16	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1491	Padre Márquez	160603	143	16	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1492	Pampa Hermosa	160604	143	16	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1493	Sarayacu	160605	143	16	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1494	Vargas Guerra	160606	143	16	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1495	Barranca	160701	144	16	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1496	Cahuapanas	160702	144	16	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1497	Manseriche	160703	144	16	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1498	Morona	160704	144	16	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1499	Pastaza	160705	144	16	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1500	Andoas	160706	144	16	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1501	Putumayo	160801	145	16	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1502	Rosa Panduro	160802	145	16	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1503	Teniente Manuel Clavero	160803	145	16	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1504	Yaguas	160804	145	16	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1505	Tambopata	170101	146	17	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1506	Inambari	170102	146	17	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1507	Las Piedras	170103	146	17	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1508	Laberinto	170104	146	17	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1509	Manu	170201	147	17	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1510	Fitzcarrald	170202	147	17	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1511	Madre de Dios	170203	147	17	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1512	Huepetuhe	170204	147	17	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1513	Iñapari	170301	148	17	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1514	Iberia	170302	148	17	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1515	Tahuamanu	170303	148	17	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1516	Moquegua	180101	149	18	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1517	Carumas	180102	149	18	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1518	Cuchumbaya	180103	149	18	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1519	Samegua	180104	149	18	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1520	San Cristóbal	180105	149	18	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1521	Torata	180106	149	18	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1522	Omate	180201	150	18	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1523	Chojata	180202	150	18	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1524	Coalaque	180203	150	18	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1525	Ichuña	180204	150	18	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1526	La Capilla	180205	150	18	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1527	Lloque	180206	150	18	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1528	Matalaque	180207	150	18	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1529	Puquina	180208	150	18	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1530	Quinistaquillas	180209	150	18	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1531	Ubinas	180210	150	18	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1532	Yunga	180211	150	18	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1533	Ilo	180301	151	18	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1534	El Algarrobal	180302	151	18	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1535	Pacocha	180303	151	18	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1536	Chaupimarca	190101	152	19	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1537	Huachon	190102	152	19	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1538	Huariaca	190103	152	19	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1539	Huayllay	190104	152	19	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1540	Ninacaca	190105	152	19	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1541	Pallanchacra	190106	152	19	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1542	Paucartambo	190107	152	19	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1543	San Francisco de Asís de Yarusyacan	190108	152	19	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1544	Simon Bolívar	190109	152	19	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1545	Ticlacayan	190110	152	19	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1546	Tinyahuarco	190111	152	19	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1547	Vicco	190112	152	19	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1548	Yanacancha	190113	152	19	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1549	Yanahuanca	190201	153	19	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1550	Chacayan	190202	153	19	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1551	Goyllarisquizga	190203	153	19	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1552	Paucar	190204	153	19	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1553	San Pedro de Pillao	190205	153	19	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1554	Santa Ana de Tusi	190206	153	19	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1555	Tapuc	190207	153	19	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1556	Vilcabamba	190208	153	19	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1557	Oxapampa	190301	154	19	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1558	Chontabamba	190302	154	19	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1559	Huancabamba	190303	154	19	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1560	Palcazu	190304	154	19	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1561	Pozuzo	190305	154	19	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1562	Puerto Bermúdez	190306	154	19	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1563	Villa Rica	190307	154	19	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1564	Constitución	190308	154	19	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1565	Piura	200101	155	20	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1566	Castilla	200104	155	20	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1567	Catacaos	200105	155	20	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1568	Cura Mori	200107	155	20	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1569	El Tallan	200108	155	20	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1570	La Arena	200109	155	20	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1571	La Unión	200110	155	20	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1572	Las Lomas	200111	155	20	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1573	Tambo Grande	200114	155	20	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1574	Veintiseis de Octubre	200115	155	20	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1575	Ayabaca	200201	156	20	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1576	Frias	200202	156	20	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1577	Jilili	200203	156	20	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1578	Lagunas	200204	156	20	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1579	Montero	200205	156	20	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1580	Pacaipampa	200206	156	20	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1581	Paimas	200207	156	20	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1582	Sapillica	200208	156	20	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1583	Sicchez	200209	156	20	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1584	Suyo	200210	156	20	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1585	Huancabamba	200301	157	20	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1586	Canchaque	200302	157	20	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1587	El Carmen de la Frontera	200303	157	20	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1588	Huarmaca	200304	157	20	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1589	Lalaquiz	200305	157	20	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1590	San Miguel de El Faique	200306	157	20	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1591	Sondor	200307	157	20	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1592	Sondorillo	200308	157	20	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1593	Chulucanas	200401	158	20	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1594	Buenos Aires	200402	158	20	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1595	Chalaco	200403	158	20	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1596	La Matanza	200404	158	20	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1597	Morropon	200405	158	20	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1598	Salitral	200406	158	20	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1599	San Juan de Bigote	200407	158	20	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1600	Santa Catalina de Mossa	200408	158	20	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1601	Santo Domingo	200409	158	20	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1602	Yamango	200410	158	20	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1603	Paita	200501	159	20	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1604	Amotape	200502	159	20	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1605	Arenal	200503	159	20	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1606	Colan	200504	159	20	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1607	La Huaca	200505	159	20	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1608	Tamarindo	200506	159	20	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1609	Vichayal	200507	159	20	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1610	Sullana	200601	160	20	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1611	Bellavista	200602	160	20	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1612	Ignacio Escudero	200603	160	20	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1613	Lancones	200604	160	20	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1614	Marcavelica	200605	160	20	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1615	Miguel Checa	200606	160	20	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1616	Querecotillo	200607	160	20	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1617	Salitral	200608	160	20	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1618	Pariñas	200701	161	20	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1619	El Alto	200702	161	20	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1620	La Brea	200703	161	20	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1621	Lobitos	200704	161	20	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1622	Los Organos	200705	161	20	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1623	Mancora	200706	161	20	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1624	Sechura	200801	162	20	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1625	Bellavista de la Unión	200802	162	20	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1626	Bernal	200803	162	20	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1627	Cristo Nos Valga	200804	162	20	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1628	Vice	200805	162	20	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1629	Rinconada Llicuar	200806	162	20	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1630	Puno	210101	163	21	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1631	Acora	210102	163	21	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1632	Amantani	210103	163	21	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1633	Atuncolla	210104	163	21	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1634	Capachica	210105	163	21	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1635	Chucuito	210106	163	21	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1636	Coata	210107	163	21	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1637	Huata	210108	163	21	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1638	Mañazo	210109	163	21	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1639	Paucarcolla	210110	163	21	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1640	Pichacani	210111	163	21	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1641	Plateria	210112	163	21	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1642	San Antonio	210113	163	21	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1643	Tiquillaca	210114	163	21	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1644	Vilque	210115	163	21	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1645	Azángaro	210201	164	21	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1646	Achaya	210202	164	21	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1647	Arapa	210203	164	21	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1648	Asillo	210204	164	21	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1649	Caminaca	210205	164	21	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1650	Chupa	210206	164	21	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1651	José Domingo Choquehuanca	210207	164	21	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1652	Muñani	210208	164	21	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1653	Potoni	210209	164	21	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1654	Saman	210210	164	21	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1655	San Anton	210211	164	21	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1656	San José	210212	164	21	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1657	San Juan de Salinas	210213	164	21	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1658	Santiago de Pupuja	210214	164	21	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1659	Tirapata	210215	164	21	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1660	Macusani	210301	165	21	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1661	Ajoyani	210302	165	21	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1662	Ayapata	210303	165	21	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1663	Coasa	210304	165	21	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1664	Corani	210305	165	21	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1665	Crucero	210306	165	21	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1666	Ituata	210307	165	21	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1667	Ollachea	210308	165	21	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1668	San Gaban	210309	165	21	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1669	Usicayos	210310	165	21	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1670	Juli	210401	166	21	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1671	Desaguadero	210402	166	21	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1672	Huacullani	210403	166	21	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1673	Kelluyo	210404	166	21	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1674	Pisacoma	210405	166	21	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1675	Pomata	210406	166	21	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1676	Zepita	210407	166	21	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1677	Ilave	210501	167	21	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1678	Capazo	210502	167	21	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1679	Pilcuyo	210503	167	21	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1680	Santa Rosa	210504	167	21	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1681	Conduriri	210505	167	21	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1682	Huancane	210601	168	21	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1683	Cojata	210602	168	21	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1684	Huatasani	210603	168	21	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1685	Inchupalla	210604	168	21	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1686	Pusi	210605	168	21	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1687	Rosaspata	210606	168	21	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1688	Taraco	210607	168	21	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1689	Vilque Chico	210608	168	21	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1690	Lampa	210701	169	21	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1691	Cabanilla	210702	169	21	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1692	Calapuja	210703	169	21	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1693	Nicasio	210704	169	21	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1694	Ocuviri	210705	169	21	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1695	Palca	210706	169	21	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1696	Paratia	210707	169	21	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1697	Pucara	210708	169	21	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1698	Santa Lucia	210709	169	21	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1699	Vilavila	210710	169	21	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1700	Ayaviri	210801	170	21	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1701	Antauta	210802	170	21	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1702	Cupi	210803	170	21	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1703	Llalli	210804	170	21	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1704	Macari	210805	170	21	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1705	Nuñoa	210806	170	21	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1706	Orurillo	210807	170	21	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1707	Santa Rosa	210808	170	21	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1708	Umachiri	210809	170	21	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1709	Moho	210901	171	21	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1710	Conima	210902	171	21	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1711	Huayrapata	210903	171	21	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1712	Tilali	210904	171	21	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1713	Putina	211001	172	21	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1714	Ananea	211002	172	21	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1715	Pedro Vilca Apaza	211003	172	21	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1716	Quilcapuncu	211004	172	21	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1717	Sina	211005	172	21	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1718	Juliaca	211101	173	21	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1719	Cabana	211102	173	21	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1720	Cabanillas	211103	173	21	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1721	Caracoto	211104	173	21	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1722	San Miguel	211105	173	21	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1723	Sandia	211201	174	21	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1724	Cuyocuyo	211202	174	21	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1725	Limbani	211203	174	21	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1726	Patambuco	211204	174	21	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1727	Phara	211205	174	21	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1728	Quiaca	211206	174	21	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1729	San Juan del Oro	211207	174	21	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1730	Yanahuaya	211208	174	21	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1731	Alto Inambari	211209	174	21	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1732	San Pedro de Putina Punco	211210	174	21	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1733	Yunguyo	211301	175	21	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1734	Anapia	211302	175	21	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1735	Copani	211303	175	21	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1736	Cuturapi	211304	175	21	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1737	Ollaraya	211305	175	21	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1738	Tinicachi	211306	175	21	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1739	Unicachi	211307	175	21	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1740	Moyobamba	220101	176	22	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1741	Calzada	220102	176	22	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1742	Habana	220103	176	22	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1743	Jepelacio	220104	176	22	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1744	Soritor	220105	176	22	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1745	Yantalo	220106	176	22	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1746	Bellavista	220201	177	22	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1747	Alto Biavo	220202	177	22	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1748	Bajo Biavo	220203	177	22	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1749	Huallaga	220204	177	22	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1750	San Pablo	220205	177	22	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1751	San Rafael	220206	177	22	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1752	San José de Sisa	220301	178	22	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1753	Agua Blanca	220302	178	22	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1754	San Martín	220303	178	22	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1755	Santa Rosa	220304	178	22	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1756	Shatoja	220305	178	22	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1757	Saposoa	220401	179	22	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1758	Alto Saposoa	220402	179	22	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1759	El Eslabón	220403	179	22	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1760	Piscoyacu	220404	179	22	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1761	Sacanche	220405	179	22	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1762	Tingo de Saposoa	220406	179	22	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1763	Lamas	220501	180	22	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1764	Alonso de Alvarado	220502	180	22	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1765	Barranquita	220503	180	22	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1766	Caynarachi	220504	180	22	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1767	Cuñumbuqui	220505	180	22	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1768	Pinto Recodo	220506	180	22	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1769	Rumisapa	220507	180	22	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1770	San Roque de Cumbaza	220508	180	22	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1771	Shanao	220509	180	22	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1772	Tabalosos	220510	180	22	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1773	Zapatero	220511	180	22	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1774	Juanjuí	220601	181	22	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1775	Campanilla	220602	181	22	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1776	Huicungo	220603	181	22	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1777	Pachiza	220604	181	22	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1778	Pajarillo	220605	181	22	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1779	Picota	220701	182	22	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1780	Buenos Aires	220702	182	22	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1781	Caspisapa	220703	182	22	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1782	Pilluana	220704	182	22	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1783	Pucacaca	220705	182	22	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1784	San Cristóbal	220706	182	22	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1785	San Hilarión	220707	182	22	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1786	Shamboyacu	220708	182	22	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1787	Tingo de Ponasa	220709	182	22	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1788	Tres Unidos	220710	182	22	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1789	Rioja	220801	183	22	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1790	Awajun	220802	183	22	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1791	Elías Soplin Vargas	220803	183	22	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1792	Nueva Cajamarca	220804	183	22	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1793	Pardo Miguel	220805	183	22	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1794	Posic	220806	183	22	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1795	San Fernando	220807	183	22	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1796	Yorongos	220808	183	22	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1797	Yuracyacu	220809	183	22	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1798	Tarapoto	220901	184	22	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1799	Alberto Leveau	220902	184	22	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1800	Cacatachi	220903	184	22	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1801	Chazuta	220904	184	22	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1802	Chipurana	220905	184	22	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1803	El Porvenir	220906	184	22	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1804	Huimbayoc	220907	184	22	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1805	Juan Guerra	220908	184	22	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1806	La Banda de Shilcayo	220909	184	22	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1807	Morales	220910	184	22	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1808	Papaplaya	220911	184	22	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1809	San Antonio	220912	184	22	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1810	Sauce	220913	184	22	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1811	Shapaja	220914	184	22	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1812	Tocache	221001	185	22	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1813	Nuevo Progreso	221002	185	22	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1814	Polvora	221003	185	22	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1815	Shunte	221004	185	22	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1816	Uchiza	221005	185	22	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1817	Tacna	230101	186	23	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1818	Alto de la Alianza	230102	186	23	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1819	Calana	230103	186	23	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1820	Ciudad Nueva	230104	186	23	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1821	Inclan	230105	186	23	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1822	Pachia	230106	186	23	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1823	Palca	230107	186	23	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1824	Pocollay	230108	186	23	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1825	Sama	230109	186	23	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1826	Coronel Gregorio Albarracín Lanchipa	230110	186	23	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1827	La Yarada los Palos	230111	186	23	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1828	Candarave	230201	187	23	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1829	Cairani	230202	187	23	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1830	Camilaca	230203	187	23	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1831	Curibaya	230204	187	23	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1832	Huanuara	230205	187	23	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1833	Quilahuani	230206	187	23	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1834	Locumba	230301	188	23	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1835	Ilabaya	230302	188	23	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1836	Ite	230303	188	23	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1837	Tarata	230401	189	23	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1838	Héroes Albarracín	230402	189	23	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1839	Estique	230403	189	23	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1840	Estique-Pampa	230404	189	23	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1841	Sitajara	230405	189	23	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1842	Susapaya	230406	189	23	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1843	Tarucachi	230407	189	23	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1844	Ticaco	230408	189	23	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1845	Tumbes	240101	190	24	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1846	Corrales	240102	190	24	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1847	La Cruz	240103	190	24	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1848	Pampas de Hospital	240104	190	24	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1849	San Jacinto	240105	190	24	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1850	San Juan de la Virgen	240106	190	24	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1851	Zorritos	240201	191	24	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1852	Casitas	240202	191	24	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1853	Canoas de Punta Sal	240203	191	24	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1854	Zarumilla	240301	192	24	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1855	Aguas Verdes	240302	192	24	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1856	Matapalo	240303	192	24	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1857	Papayal	240304	192	24	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1858	Calleria	250101	193	25	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1859	Campoverde	250102	193	25	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1860	Iparia	250103	193	25	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1861	Masisea	250104	193	25	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1862	Yarinacocha	250105	193	25	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1863	Nueva Requena	250106	193	25	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1864	Manantay	250107	193	25	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1865	Raymondi	250201	194	25	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1866	Sepahua	250202	194	25	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1867	Tahuania	250203	194	25	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1868	Yurua	250204	194	25	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1869	Padre Abad	250301	195	25	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1870	Irazola	250302	195	25	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1871	Curimana	250303	195	25	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1872	Neshuya	250304	195	25	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1873	Alexander Von Humboldt	250305	195	25	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
1874	Purus	250401	196	25	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
\.


--
-- TOC entry 3465 (class 0 OID 76771)
-- Dependencies: 224
-- Data for Name: donations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.donations (donation_id, plan_id, user_id, email, name, amount, type, status, created_at, updated_at) FROM stdin;
178eaf09-6ec6-4cb9-b49d-01daf9080974	2	\N	\N	\N	10.00	subscription	pending	2024-12-08 04:17:43.064	2024-12-08 04:17:43.064
a3bdbbfd-8e61-40de-a70c-a8bab67db1b6	1	\N	\N	\N	10.00	subscription	pending	2024-12-08 04:19:09.428	2024-12-08 04:19:09.428
321f4a23-75c5-4a21-a627-058676f0b256	2	\N	\N	\N	25.00	subscription	pending	2024-12-08 04:19:17.007	2024-12-08 04:19:17.007
c159b3c1-5cb7-4ddd-adc2-d70d42c0e342	1	\N	lfzarate30@gmail.com	Leslie Zarate	10.00	payment	success	2024-12-08 18:59:33.216	2024-12-08 19:00:05.221
027bd005-50ff-4522-b7e1-9595ff57daa8	2	\N	lfzarate30@gmail.com	Leslie Zarate	25.00	subscription	success	2024-12-08 19:03:43.164	2024-12-08 19:04:12.424
\.


--
-- TOC entry 3477 (class 0 OID 76840)
-- Dependencies: 236
-- Data for Name: favorite_pets; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.favorite_pets (favorite_pet_id, pet_id, user_id, value, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 3470 (class 0 OID 76800)
-- Dependencies: 229
-- Data for Name: pet_breeds; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pet_breeds (pet_breed_id, name, category_id, created_at, updated_at) FROM stdin;
1	Labrador Retriever	1	2024-12-07 16:09:55.278	2024-12-07 16:09:55.278
2	Golden Retriever	1	2024-12-07 16:09:55.278	2024-12-07 16:09:55.278
3	German Shepherd	1	2024-12-07 16:09:55.278	2024-12-07 16:09:55.278
4	French Bulldog	1	2024-12-07 16:09:55.278	2024-12-07 16:09:55.278
5	Beagle	1	2024-12-07 16:09:55.278	2024-12-07 16:09:55.278
6	Rottweiler	1	2024-12-07 16:09:55.278	2024-12-07 16:09:55.278
7	Poodle	1	2024-12-07 16:09:55.278	2024-12-07 16:09:55.278
8	English Bulldog	1	2024-12-07 16:09:55.278	2024-12-07 16:09:55.278
9	Chihuahua	1	2024-12-07 16:09:55.278	2024-12-07 16:09:55.278
10	Doberman Pinscher	1	2024-12-07 16:09:55.278	2024-12-07 16:09:55.278
11	Boxer	1	2024-12-07 16:09:55.278	2024-12-07 16:09:55.278
12	Shih Tzu	1	2024-12-07 16:09:55.278	2024-12-07 16:09:55.278
13	Cocker Spaniel	1	2024-12-07 16:09:55.278	2024-12-07 16:09:55.278
14	Dachshund	1	2024-12-07 16:09:55.278	2024-12-07 16:09:55.278
15	Pomeranian	1	2024-12-07 16:09:55.278	2024-12-07 16:09:55.278
16	Pitbull Terrier	1	2024-12-07 16:09:55.278	2024-12-07 16:09:55.278
17	Schnauzer	1	2024-12-07 16:09:55.278	2024-12-07 16:09:55.278
18	Siberian Husky	1	2024-12-07 16:09:55.278	2024-12-07 16:09:55.278
19	Siamese	2	2024-12-07 16:09:55.278	2024-12-07 16:09:55.278
20	Persian	2	2024-12-07 16:09:55.278	2024-12-07 16:09:55.278
21	Maine Coon	2	2024-12-07 16:09:55.278	2024-12-07 16:09:55.278
22	Sphynx	2	2024-12-07 16:09:55.278	2024-12-07 16:09:55.278
23	Bengal	2	2024-12-07 16:09:55.278	2024-12-07 16:09:55.278
24	Abyssinian	2	2024-12-07 16:09:55.278	2024-12-07 16:09:55.278
25	Ragdoll	2	2024-12-07 16:09:55.278	2024-12-07 16:09:55.278
26	British Shorthair	2	2024-12-07 16:09:55.278	2024-12-07 16:09:55.278
27	Scottish Fold	2	2024-12-07 16:09:55.278	2024-12-07 16:09:55.278
28	Birman	2	2024-12-07 16:09:55.278	2024-12-07 16:09:55.278
29	Devon Rex	2	2024-12-07 16:09:55.278	2024-12-07 16:09:55.278
30	Oriental	2	2024-12-07 16:09:55.278	2024-12-07 16:09:55.278
31	Exotic Persian	2	2024-12-07 16:09:55.278	2024-12-07 16:09:55.278
32	Syrian Hamster	3	2024-12-07 16:09:55.278	2024-12-07 16:09:55.278
33	Russian Dwarf Hamster	3	2024-12-07 16:09:55.278	2024-12-07 16:09:55.278
34	Roborovski Hamster	3	2024-12-07 16:09:55.278	2024-12-07 16:09:55.278
35	Chinese Hamster	3	2024-12-07 16:09:55.278	2024-12-07 16:09:55.278
36	Holland Lop	4	2024-12-07 16:25:32.197	2024-12-07 16:25:32.197
37	French Lop	4	2024-12-07 16:25:32.197	2024-12-07 16:25:32.197
38	Havana	4	2024-12-07 16:25:32.197	2024-12-07 16:25:32.197
39	French Angora	4	2024-12-07 16:25:32.197	2024-12-07 16:25:32.197
41	Husky siberiano, cruce de border collie	1	2024-12-07 21:52:31.398	2024-12-07 21:52:31.398
40	Staffordshire Bull Terrier	1	2024-12-07 18:36:40.835	2024-12-07 18:36:40.835
\.


--
-- TOC entry 3468 (class 0 OID 76790)
-- Dependencies: 227
-- Data for Name: pet_categories; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pet_categories (pet_category_id, name, created_at, updated_at) FROM stdin;
1	Perro	2024-12-07 16:09:55.278	2024-12-07 16:09:55.278
2	Gato	2024-12-07 16:09:55.278	2024-12-07 16:09:55.278
3	Hamster	2024-12-07 16:09:55.278	2024-12-07 16:09:55.278
4	Conejo	2024-12-07 16:09:55.278	2024-12-07 16:09:55.278
\.


--
-- TOC entry 3474 (class 0 OID 76821)
-- Dependencies: 233
-- Data for Name: pet_photos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pet_photos (id, pet_id, url, created_at, updated_at) FROM stdin;
1	1	{"url": "https://res.cloudinary.com/dyntsz5qv/image/upload/v1733614663/123e4567-e89b-12d3-a456-426614174014/ydj9mq8fuyknq5b6znfv.png", "fileName": "Ebony-photo-1.PNG", "publicId": "123e4567-e89b-12d3-a456-426614174014/ydj9mq8fuyknq5b6znfv"}	2024-12-07 19:45:57.285	2024-12-07 19:45:57.285
2	1	{"url": "https://res.cloudinary.com/dyntsz5qv/image/upload/v1733614664/123e4567-e89b-12d3-a456-426614174014/dirnqm1yn2rml11cypde.png", "fileName": "Ebony-profile.PNG", "publicId": "123e4567-e89b-12d3-a456-426614174014/dirnqm1yn2rml11cypde"}	2024-12-07 19:47:03.331	2024-12-07 19:47:03.331
3	2	{"url": "https://res.cloudinary.com/dyntsz5qv/image/upload/v1733620530/123e4567-e89b-12d3-a456-426614174014/l5b9hypxopba7gs2vbmq.png", "fileName": "Creed-profile.PNG", "publicId": "123e4567-e89b-12d3-a456-426614174014/l5b9hypxopba7gs2vbmq"}	2024-12-07 20:19:48.931	2024-12-07 20:19:48.931
4	2	{"url": "https://res.cloudinary.com/dyntsz5qv/image/upload/v1733620529/123e4567-e89b-12d3-a456-426614174014/rgbegmrgbujlkexgo1m0.png", "fileName": "Creed-photo-1.PNG", "publicId": "123e4567-e89b-12d3-a456-426614174014/rgbegmrgbujlkexgo1m0"}	2024-12-07 20:19:48.931	2024-12-07 20:19:48.931
5	3	{"url": "https://res.cloudinary.com/dyntsz5qv/image/upload/v1733621417/123e4567-e89b-12d3-a456-426614174014/zzmsm9o5e1wejxknwolk.png", "fileName": "Willow-profile.PNG", "publicId": "123e4567-e89b-12d3-a456-426614174014/zzmsm9o5e1wejxknwolk"}	2024-12-07 20:32:59.29	2024-12-07 20:32:59.29
6	3	{"url": "https://res.cloudinary.com/dyntsz5qv/image/upload/v1733621417/123e4567-e89b-12d3-a456-426614174014/yrncvqnlreh74dxq1tpp.png", "fileName": "Willow-photo-1.PNG", "publicId": "123e4567-e89b-12d3-a456-426614174014/yrncvqnlreh74dxq1tpp"}	2024-12-07 20:32:59.29	2024-12-07 20:32:59.29
7	4	{"url": "https://res.cloudinary.com/dyntsz5qv/image/upload/v1733625022/123e4567-e89b-12d3-a456-426614174014/zrdberh4gpxkzkqngdaf.png", "fileName": "Toby-profile.PNG", "publicId": "123e4567-e89b-12d3-a456-426614174014/zrdberh4gpxkzkqngdaf"}	2024-12-07 21:33:15.003	2024-12-07 21:33:15.003
8	4	{"url": "https://res.cloudinary.com/dyntsz5qv/image/upload/v1733625021/123e4567-e89b-12d3-a456-426614174014/htvmwpsewetwa2y23t0n.png", "fileName": "Toby-photo-1.PNG", "publicId": "123e4567-e89b-12d3-a456-426614174014/htvmwpsewetwa2y23t0n"}	2024-12-07 21:33:15.003	2024-12-07 21:33:15.003
9	5	{"url": "https://res.cloudinary.com/dyntsz5qv/image/upload/v1733625947/123e4567-e89b-12d3-a456-426614174014/eaosxqyf85chgrwocz7v.png", "fileName": "Bailey-profile.PNG", "publicId": "123e4567-e89b-12d3-a456-426614174014/eaosxqyf85chgrwocz7v"}	2024-12-07 21:47:04.389	2024-12-07 21:47:04.389
10	5	{"url": "https://res.cloudinary.com/dyntsz5qv/image/upload/v1733625946/123e4567-e89b-12d3-a456-426614174014/direyrrvoj3rs9lfegcq.png", "fileName": "Bailey-photo-1.PNG", "publicId": "123e4567-e89b-12d3-a456-426614174014/direyrrvoj3rs9lfegcq"}	2024-12-07 21:47:04.389	2024-12-07 21:47:04.389
11	6	{"url": "https://res.cloudinary.com/dyntsz5qv/image/upload/v1733627742/123e4567-e89b-12d3-a456-426614174003/yiwzqiavjp1q6d9gbnda.png", "fileName": "Jared-profile.PNG", "publicId": "123e4567-e89b-12d3-a456-426614174003/yiwzqiavjp1q6d9gbnda"}	2024-12-07 21:59:15.993	2024-12-07 21:59:15.993
12	6	{"url": "https://res.cloudinary.com/dyntsz5qv/image/upload/v1733627743/123e4567-e89b-12d3-a456-426614174003/rnfbjxrpszjhnvmsstp4.png", "fileName": "Jared-photo-1.PNG", "publicId": "123e4567-e89b-12d3-a456-426614174003/rnfbjxrpszjhnvmsstp4"}	2024-12-07 21:59:15.993	2024-12-07 21:59:15.993
\.


--
-- TOC entry 3472 (class 0 OID 76810)
-- Dependencies: 231
-- Data for Name: pets; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pets (pet_id, name, description, birthdate, weight, height, gender, color, behavior, profile_picture, category_id, breed_id, shelter_id, status, created_at, updated_at) FROM stdin;
1	Ebony	A Ebony le encanta aprender y ha aprendido rápidamente las nuevas habilidades que le enseñamos. Disfruta tumbada en su colchoneta favorita con un juguete para masticar y jugando con sus juguetes.||Buscamos un hogar con dueños con mentalidad de adiestramiento y experiencia con perros con mucha energía. Ebony ha tenido dificultades para adaptarse a sus hogares anteriores y esto es algo en lo que estamos trabajando aquí en el centro. Lo ideal sería que los nuevos dueños de Ebony estuvieran en casa la mayor parte del día.||Ebony podría vivir con niños adolescentes que comprendan su naturaleza vivaz y podrán ayudar con el entrenamiento.||Ebony deberá ser la única mascota de la casa. Le vendría bien tener algunos amigos perrunos con los que pueda seguir socializando. Perseguirá a los gatos, por lo que no podrá vivir con ellos.||Una vez que Ebony esté en un hogar con una buena rutina y estructura en su vida diaria, ¡creemos que esta hermosa niña brillará!||Si cree que podría tener el hogar perfecto para Ebony, esperamos saber de usted	2023-11-10 00:00:00	30.00	60.00	female	blanco y negro	{Amigable,Activa}	{"url": "https://res.cloudinary.com/dyntsz5qv/image/upload/v1733614663/123e4567-e89b-12d3-a456-426614174014/ydj9mq8fuyknq5b6znfv.png", "fileName": "Ebony-photo-1.PNG", "publicId": "123e4567-e89b-12d3-a456-426614174014/ydj9mq8fuyknq5b6znfv"}	1	40	123e4567-e89b-12d3-a456-426614174014	Available	2024-12-07 18:49:56.077	2024-12-07 18:49:56.077
2	Creed	Creed es un hermoso Staffordshire Bull Terrier de 5 años con una energía desbordante y un corazón lleno de amor. Si buscas un compañero que te mantenga alerta, Creed puede ser la opción perfecta.||Creed está lleno de vida y siempre está listo para una aventura. Ya sea una caminata larga, un divertido juego de buscar la pelota o simplemente correr por el jardín, le encanta estar activo y comprometido. Tiene mucha energía para gastar y le iría bien en un hogar que le brinde mucho ejercicio y estimulación mental. Para sus paseos, Creed necesitaría estar atado con correa.||La familia actual de Creed comenta que sus cosas favoritas en el mundo son jugar al tira y afloja o jugar con sus juguetes de pelota.||Definitivamente también tiene un lado cariñoso y le encanta pasar tiempo con sus personas favoritas. Le encanta estar cerca de la gente para mimarlo y relajarse.||Creed no sería adecuado para vivir con gatos u otros perros. Sería más adecuado para hogares con niños mayores en edad de asistir a la escuela secundaria.	2020-01-14 00:00:00	24.00	50.00	male	atigrado blanco	{Dulce,Leal}	{"url": "https://res.cloudinary.com/dyntsz5qv/image/upload/v1733620530/123e4567-e89b-12d3-a456-426614174014/l5b9hypxopba7gs2vbmq.png", "fileName": "Creed-profile.PNG", "publicId": "123e4567-e89b-12d3-a456-426614174014/l5b9hypxopba7gs2vbmq"}	1	40	123e4567-e89b-12d3-a456-426614174014	Available	2024-12-07 20:18:24.666	2024-12-07 20:18:24.666
3	Willow	Los Willows suelen ser conocidos por su gracia, encanto y resistencia. Todo esto es cierto en el caso de nuestra preciosa Willow, que está siendo reubicada debido a un cambio en las circunstancias personales de su dueña. Cuando no está durmiendo la siesta o jugando con sus juguetes, a Willow le encanta salir a caminar. De hecho, sabe lo que significa la palabra ""W"" y corre por todos lados con entusiasmo antes de esperar junto a la puerta principal para salir.||Willow es una compañera adorable para su dueña y disfruta acurrucándose en el sofá por las noches. Willow puede tardar un tiempo en entablar una relación con nuevas personas, ya que no está acostumbrada a encontrarse con extraños a menudo. Está buscando un nuevo hogar familiar que le brinde el tiempo y la paciencia que necesita para adaptarse y ganar confianza. Debido a esto, Willow necesitaría conocer a sus adoptantes en varias ocasiones en el centro antes de volver a casa.||Willow no ha vivido con niños pequeños antes; por lo tanto, estaríamos buscando un hogar familiar con niños en edad de escuela secundaria o mayores.	2022-07-28 00:00:00	30.00	64.00	female	plateado	{Afectuosa,Tranquila}	{"url": "https://res.cloudinary.com/dyntsz5qv/image/upload/v1733621417/123e4567-e89b-12d3-a456-426614174014/zzmsm9o5e1wejxknwolk.png", "fileName": "Willow-profile.PNG", "publicId": "123e4567-e89b-12d3-a456-426614174014/zzmsm9o5e1wejxknwolk"}	1	1	123e4567-e89b-12d3-a456-426614174014	Available	2024-12-07 20:31:57.936	2024-12-07 20:31:57.936
4	Toby	Es un tipo cariñoso y no hay nada que le guste más que pasar tiempo con sus personas favoritas y recibir mucha atención.||A Toby le gustan los paseos y le encanta conocer y saludar a otros perros cuando pasa, pero también le encanta acurrucarse en el sofá por la noche. A Toby también le encanta jugar, pero puede ser un poco entusiasta, por lo que puede ser más adecuado para una casa con niños en edad escolar.||Es un chico muy tranquilo y seguro que será un compañero fantástico. Si Toby parece ser el chico ideal para ti, envía tu solicitud hoy mismo. Ten en cuenta que Toby es un bulldog francés grande, ya que pesa 16,9 kg.||“Los perros de cara plana (braquicéfalos) sufren problemas de salud adicionales que pueden afectar su calidad de vida. Siempre recomendamos a quienes estén pensando en adoptar o comprar un perro de cara plana (braquicéfalo) que investiguen a fondo la raza de antemano. Nuestro equipo de expertos podrá darle consejos sobre ejercicio y control de peso, así como sobre cualquier ayuda que Frank pueda necesitar”.	2022-08-13 00:00:00	24.00	45.00	male	gris blanco	{Alerta,Juguetón}	{"url": "https://res.cloudinary.com/dyntsz5qv/image/upload/v1733625022/123e4567-e89b-12d3-a456-426614174014/zrdberh4gpxkzkqngdaf.png", "fileName": "Toby-profile.PNG", "publicId": "123e4567-e89b-12d3-a456-426614174014/zrdberh4gpxkzkqngdaf"}	1	4	123e4567-e89b-12d3-a456-426614174014	Available	2024-12-07 21:32:14.762	2024-12-07 21:32:14.762
5	Bailey	Bailey puede ser un poco tímida en situaciones nuevas y cuando conoce gente nueva, y necesitará que los nuevos dueños sean pacientes y la apoyen.||Bailey ha mostrado una falta de confianza aquí en el centro cuando se encuentra con perros desconocidos, pero está haciendo un gran progreso en la construcción de amistades con algunos de los perros aquí, y está mostrando un lado un poco juguetón con sus amigos más familiares, debido a la falta de confianza de Bailey y la necesidad de apoyo con su nuevo entorno y caminó en rutas de paseo para perros más tranquilas y necesitaría ser la única mascota en el hogar.||Después de un paseo, nada le gusta más que relajarse en su cama, o a tu lado en el sofá y recibir todos los mimos que se merece.||Bailey busca idealmente un hogar donde haya alguien cerca durante gran parte del día y un hogar con niños adolescentes mayores que puedan permitirle espacio y paciencia cuando sea necesario.||Si tiene un espacio con forma de Labrador en su vida, complete una solicitud hoy	2019-03-19 00:00:00	30.00	65.00	female	amarillo	{Juguetona,Inteligente}	{"url": "https://res.cloudinary.com/dyntsz5qv/image/upload/v1733625947/123e4567-e89b-12d3-a456-426614174014/eaosxqyf85chgrwocz7v.png", "fileName": "Bailey-profile.PNG", "publicId": "123e4567-e89b-12d3-a456-426614174014/eaosxqyf85chgrwocz7v"}	1	1	123e4567-e89b-12d3-a456-426614174014	Available	2024-12-07 21:46:01.456	2024-12-07 21:46:01.456
6	Jared	Estos cachorros son muy inteligentes y necesitarán orientación sobre cómo dirigir su energía. Son un poco inseguros, por lo que necesitarán tiempo para adaptarse a sus nuevos hogares y todo se hará a su propio ritmo.||Necesitarán una nueva familia con tiempo para poder ofrecerles un estilo de vida activo y divertido, ya sea con entrenamiento, enriquecimiento, paseos más largos y enriquecedores y tiempo de juego.||Recomendamos a cualquiera que consulte sus perfiles que investigue ambas razas.||Necesitarán a alguien cerca la mayor parte del día, ya que aún no se sienten cómodos estando solos o no están acostumbrados a hacer sus necesidades en casa.	2023-10-10 00:00:00	8.00	26.00	male	tricolor	{Sociable,Juguetón}	{"url": "https://res.cloudinary.com/dyntsz5qv/image/upload/v1733627742/123e4567-e89b-12d3-a456-426614174003/yiwzqiavjp1q6d9gbnda.png", "fileName": "Jared-profile.PNG", "publicId": "123e4567-e89b-12d3-a456-426614174003/yiwzqiavjp1q6d9gbnda"}	1	18	123e4567-e89b-12d3-a456-426614174003	Available	2024-12-07 21:58:16.982	2024-12-07 21:58:16.982
\.


--
-- TOC entry 3464 (class 0 OID 76762)
-- Dependencies: 223
-- Data for Name: plans; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.plans (plan_id, product_id, code_one_time, code_subscription, name, title, description, price, is_polular, created_at, updated_at) FROM stdin;
4	prod_RGCxBEchzLdKGj	price_1QTbrgGbNy5Q0IZgHXiVBUOy	price_1QTbrJGbNy5Q0IZgJmOIaZ5V	Héroe del Día	Sé un héroe hoy	Apoya cuidados avanzados y tratamientos, dando a las mascotas la salud que necesitan para prosperar y encontrar un hogar.	100.00	f	2024-12-07 22:45:16.312	2024-12-07 22:45:16.312
3	prod_RGCwVO8LAbCXr7	price_1QTbsmGbNy5Q0IZgAJM7kWT1	price_1QTbsYGbNy5Q0IZgqv4GbDL1	Cuidado Completo	Dale una segunda oportunidad	Asegúrate de que una mascota reciba todo lo que necesita, desde comida hasta atención médica, para un nuevo comienzo en la vida.	50.00	t	2024-12-07 22:45:16.312	2024-12-07 22:45:16.312
1	prod_RGCsz3KIosS2Lx	price_1QTbuOGbNy5Q0IZg7m1HP1Kk	price_1QTbuEGbNy5Q0IZgXsASilX0	Salvador de Vidas	Haz posible la adopción	Ayuda a una mascota rescatada a transicionar a un hogar amoroso cubriendo cuidados esenciales y preparación para la adopción.	10.00	f	2024-12-07 22:45:16.312	2024-12-07 22:45:16.312
2	prod_RGCurBH4qGz90M	price_1QTbtYGbNy5Q0IZgAbIQO3F8	price_1QTbtPGbNy5Q0IZgYxWdOFSJ	Pequeña Ayuda	Un pequeño aporte, gran ayuda	Proporciona necesidades diarias como comida y agua para mantener a las mascotas cómodas mientras esperan adopción.	25.00	f	2024-12-07 22:45:16.312	2024-12-07 22:45:16.312
\.


--
-- TOC entry 3459 (class 0 OID 76733)
-- Dependencies: 218
-- Data for Name: provinces; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.provinces (province_id, name, code, department_id, created_at, updated_at) FROM stdin;
1	Chachapoyas	0101	1	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
2	Bagua	0102	1	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
3	Bongará	0103	1	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
4	Condorcanqui	0104	1	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
5	Luya	0105	1	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
6	Rodríguez de Mendoza	0106	1	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
7	Utcubamba	0107	1	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
8	Huaraz	0201	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
9	Aija	0202	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
10	Antonio Raymondi	0203	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
11	Asunción	0204	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
12	Bolognesi	0205	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
13	Carhuaz	0206	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
14	Carlos Fermín Fitzcarrald	0207	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
15	Casma	0208	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
16	Corongo	0209	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
17	Huari	0210	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
18	Huarmey	0211	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
19	Huaylas	0212	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
20	Mariscal Luzuriaga	0213	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
21	Ocros	0214	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
22	Pallasca	0215	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
23	Pomabamba	0216	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
24	Recuay	0217	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
25	Santa	0218	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
26	Sihuas	0219	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
27	Yungay	0220	2	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
28	Abancay	0301	3	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
29	Andahuaylas	0302	3	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
30	Antabamba	0303	3	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
31	Aymaraes	0304	3	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
32	Cotabambas	0305	3	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
33	Chincheros	0306	3	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
34	Grau	0307	3	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
35	Arequipa	0401	4	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
36	Camaná	0402	4	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
37	Caravelí	0403	4	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
38	Castilla	0404	4	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
39	Caylloma	0405	4	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
40	Condesuyos	0406	4	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
41	Islay	0407	4	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
42	La Uniòn	0408	4	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
43	Huamanga	0501	5	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
44	Cangallo	0502	5	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
45	Huanca Sancos	0503	5	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
46	Huanta	0504	5	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
47	La Mar	0505	5	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
48	Lucanas	0506	5	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
49	Parinacochas	0507	5	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
50	Pàucar del Sara Sara	0508	5	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
51	Sucre	0509	5	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
52	Víctor Fajardo	0510	5	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
53	Vilcas Huamán	0511	5	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
54	Cajamarca	0601	6	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
55	Cajabamba	0602	6	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
56	Celendín	0603	6	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
57	Chota	0604	6	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
58	Contumazá	0605	6	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
59	Cutervo	0606	6	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
60	Hualgayoc	0607	6	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
61	Jaén	0608	6	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
62	San Ignacio	0609	6	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
63	San Marcos	0610	6	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
64	San Miguel	0611	6	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
65	San Pablo	0612	6	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
66	Santa Cruz	0613	6	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
67	Prov. Const. del Callao	0701	7	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
68	Cusco	0801	8	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
69	Acomayo	0802	8	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
70	Anta	0803	8	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
71	Calca	0804	8	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
72	Canas	0805	8	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
73	Canchis	0806	8	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
74	Chumbivilcas	0807	8	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
75	Espinar	0808	8	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
76	La Convención	0809	8	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
77	Paruro	0810	8	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
78	Paucartambo	0811	8	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
79	Quispicanchi	0812	8	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
80	Urubamba	0813	8	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
81	Huancavelica	0901	9	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
82	Acobamba	0902	9	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
83	Angaraes	0903	9	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
84	Castrovirreyna	0904	9	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
85	Churcampa	0905	9	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
86	Huaytará	0906	9	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
87	Tayacaja	0907	9	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
88	Huánuco	1001	10	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
89	Ambo	1002	10	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
90	Dos de Mayo	1003	10	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
91	Huacaybamba	1004	10	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
92	Huamalíes	1005	10	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
93	Leoncio Prado	1006	10	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
94	Marañón	1007	10	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
95	Pachitea	1008	10	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
96	Puerto Inca	1009	10	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
97	Lauricocha	1010	10	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
98	Yarowilca	1011	10	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
99	Ica	1101	11	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
100	Chincha	1102	11	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
101	Nasca	1103	11	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
102	Palpa	1104	11	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
103	Pisco	1105	11	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
104	Huancayo	1201	12	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
105	Concepción	1202	12	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
106	Chanchamayo	1203	12	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
107	Jauja	1204	12	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
108	Junín	1205	12	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
109	Satipo	1206	12	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
110	Tarma	1207	12	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
111	Yauli	1208	12	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
112	Chupaca	1209	12	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
113	Trujillo	1301	13	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
114	Ascope	1302	13	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
115	Bolívar	1303	13	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
116	Chepén	1304	13	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
117	Julcán	1305	13	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
118	Otuzco	1306	13	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
119	Pacasmayo	1307	13	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
120	Pataz	1308	13	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
121	Sánchez Carrión	1309	13	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
122	Santiago de Chuco	1310	13	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
123	Gran Chimú	1311	13	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
124	Virú	1312	13	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
125	Chiclayo	1401	14	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
126	Ferreñafe	1402	14	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
127	Lambayeque	1403	14	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
128	Lima	1501	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
129	Barranca	1502	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
130	Cajatambo	1503	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
131	Canta	1504	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
132	Cañete	1505	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
133	Huaral	1506	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
134	Huarochirí	1507	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
135	Huaura	1508	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
136	Oyón	1509	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
137	Yauyos	1510	15	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
138	Maynas	1601	16	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
139	Alto Amazonas	1602	16	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
140	Loreto	1603	16	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
141	Mariscal Ramón Castilla	1604	16	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
142	Requena	1605	16	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
143	Ucayali	1606	16	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
144	Datem del Marañón	1607	16	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
145	Putumayo	1608	16	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
146	Tambopata	1701	17	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
147	Manu	1702	17	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
148	Tahuamanu	1703	17	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
149	Mariscal Nieto	1801	18	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
150	General Sánchez Cerro	1802	18	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
151	Ilo	1803	18	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
152	Pasco	1901	19	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
153	Daniel Alcides Carrión	1902	19	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
154	Oxapampa	1903	19	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
155	Piura	2001	20	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
156	Ayabaca	2002	20	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
157	Huancabamba	2003	20	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
158	Morropón	2004	20	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
159	Paita	2005	20	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
160	Sullana	2006	20	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
161	Talara	2007	20	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
162	Sechura	2008	20	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
163	Puno	2101	21	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
164	Azángaro	2102	21	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
165	Carabaya	2103	21	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
166	Chucuito	2104	21	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
167	El Collao	2105	21	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
168	Huancané	2106	21	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
169	Lampa	2107	21	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
170	Melgar	2108	21	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
171	Moho	2109	21	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
172	San Antonio de Putina	2110	21	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
173	San Román	2111	21	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
174	Sandia	2112	21	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
175	Yunguyo	2113	21	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
176	Moyobamba	2201	22	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
177	Bellavista	2202	22	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
178	El Dorado	2203	22	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
179	Huallaga	2204	22	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
180	Lamas	2205	22	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
181	Mariscal Cáceres	2206	22	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
182	Picota	2207	22	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
183	Rioja	2208	22	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
184	San Martín	2209	22	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
185	Tocache	2210	22	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
186	Tacna	2301	23	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
187	Candarave	2302	23	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
188	Jorge Basadre	2303	23	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
189	Tarata	2304	23	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
190	Tumbes	2401	24	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
191	Contralmirante Villar	2402	24	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
192	Zarumilla	2403	24	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
193	Coronel Portillo	2501	25	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
194	Atalaya	2502	25	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
195	Padre Abad	2503	25	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
196	Purús	2504	25	2024-12-07 16:09:06.024	2024-12-07 16:09:06.024
\.


--
-- TOC entry 3466 (class 0 OID 76780)
-- Dependencies: 225
-- Data for Name: shelters; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.shelters (shelter_id, name, address, phone, email, latitude, longitude, district_id, user_id, created_at, updated_at) FROM stdin;
123e4567-e89b-12d3-a456-426614174003	Hogar de Esperanza Animal	Av. Los Pinos 123, Miraflores	555-4321	info@esperanzaanimal.com	-12.123000000000000000000000000000	-77.029000000000000000000000000000	1302	\N	2024-12-07 17:49:54.102	2024-12-07 17:49:54.102
123e4567-e89b-12d3-a456-426614174004	Refugio Patitas Felices	Jr. Los Gatos 456, Surco	555-5679	contacto@patitasfelices.com	-12.105000000000000000000000000000	-77.035000000000000000000000000000	1320	\N	2024-12-07 17:49:54.102	2024-12-07 17:49:54.102
123e4567-e89b-12d3-a456-426614174005	Centro de Rescate Vida Animal	Calle Los Amores 789, Barranco	555-6781	ayuda@vidaanimal.com	-12.144000000000000000000000000000	-77.019000000000000000000000000000	1284	\N	2024-12-07 17:49:54.102	2024-12-07 17:49:54.102
123e4567-e89b-12d3-a456-426614174006	Refugio Corazón Animal	Av. Principal 321, San Isidro	555-8910	corazon@refugioanimal.com	-12.098000000000000000000000000000	-77.036000000000000000000000000000	1311	\N	2024-12-07 17:49:54.102	2024-12-07 17:49:54.102
123e4567-e89b-12d3-a456-426614174007	Hogar Refugio y Amor	Jr. Las Flores 654, La Molina	555-2345	contacto@refugioyamor.com	-12.090000000000000000000000000000	-76.948000000000000000000000000000	1294	\N	2024-12-07 17:49:54.102	2024-12-07 17:49:54.102
123e4567-e89b-12d3-a456-426614174008	Patitas de Amor Refugio	Av. Las Palmeras 987, San Borja	555-3456	info@patitasdeamor.com	-12.111000000000000000000000000000	-76.991000000000000000000000000000	1310	\N	2024-12-07 17:49:54.102	2024-12-07 17:49:54.102
123e4567-e89b-12d3-a456-426614174009	Amigos por Siempre Refugio	Jr. Los Perros 112, Jesús María	555-4567	ayuda@amigosporsiempre.com	-12.075000000000000000000000000000	-77.048000000000000000000000000000	1293	\N	2024-12-07 17:49:54.102	2024-12-07 17:49:54.102
123e4567-e89b-12d3-a456-426614174011	Casa Animal del Perú	Calle Mascotas 556, Chorrillos	555-7893	ayuda@casaanimalperu.com	-12.180000000000000000000000000000	-77.016000000000000000000000000000	1288	\N	2024-12-07 17:49:54.102	2024-12-07 17:49:54.102
123e4567-e89b-12d3-a456-426614174013	Refugio Lago Azul	Av. Titicaca 123, Juliaca	051-5678	contacto@refugiolagoazul.com	-15.499000000000000000000000000000	-70.133000000000000000000000000000	1718	\N	2024-12-07 17:54:10.277	2024-12-07 17:54:10.277
123e4567-e89b-12d3-a456-426614174017	Refugio Esperanza Hunter	Calle Principal 321, Hunter	054-1234	contacto@esperanzahunter.com	-16.436000000000000000000000000000	-71.555000000000000000000000000000	341	\N	2024-12-07 17:54:10.277	2024-12-07 17:54:10.277
123e4567-e89b-12d3-a456-426614174016	Patitas del Misti	Jr. El Volcán 112, Yanahuara	054-8901	contacto@patitasdelmisti.com	-16.402000000000000000000000000000	-71.548000000000000000000000000000	360	\N	2024-12-07 17:54:10.277	2024-12-07 17:54:10.277
123e4567-e89b-12d3-a456-426614174014	Hogar Animal Sillustani	Jr. Los Andes 456, Puno	051-6789	info@hogaranimaluros.com	-15.840000000000000000000000000000	-70.021000000000000000000000000000	1630	\N	2024-12-07 17:54:10.277	2024-12-07 17:54:10.277
\.


--
-- TOC entry 3462 (class 0 OID 76752)
-- Dependencies: 221
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (user_id, channel, first_name, last_name, email, password, avatar, phone, birthdate, address, district_id, customer_id, created_at, updated_at) FROM stdin;
fb20d747-72b9-411e-810b-f49e8690d802	838c9b0b-03e1-402f-a457-f47d2c213323	Leslie Zarate		lfzarate30@gmail.com		\N	\N	\N	\N	\N	\N	2024-12-09 01:29:45.811	2024-12-09 01:29:45.811
\.


--
-- TOC entry 3494 (class 0 OID 0)
-- Dependencies: 215
-- Name: departments_department_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.departments_department_id_seq', 1, false);


--
-- TOC entry 3495 (class 0 OID 0)
-- Dependencies: 219
-- Name: districts_district_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.districts_district_id_seq', 1874, true);


--
-- TOC entry 3496 (class 0 OID 0)
-- Dependencies: 235
-- Name: favorite_pets_favorite_pet_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.favorite_pets_favorite_pet_id_seq', 4, true);


--
-- TOC entry 3497 (class 0 OID 0)
-- Dependencies: 228
-- Name: pet_breeds_pet_breed_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.pet_breeds_pet_breed_id_seq', 1, false);


--
-- TOC entry 3498 (class 0 OID 0)
-- Dependencies: 226
-- Name: pet_categories_pet_category_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.pet_categories_pet_category_id_seq', 1, false);


--
-- TOC entry 3499 (class 0 OID 0)
-- Dependencies: 232
-- Name: pet_photos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.pet_photos_id_seq', 1, false);


--
-- TOC entry 3500 (class 0 OID 0)
-- Dependencies: 230
-- Name: pets_pet_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.pets_pet_id_seq', 6, true);


--
-- TOC entry 3501 (class 0 OID 0)
-- Dependencies: 222
-- Name: plans_plan_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.plans_plan_id_seq', 4, true);


--
-- TOC entry 3502 (class 0 OID 0)
-- Dependencies: 217
-- Name: provinces_province_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.provinces_province_id_seq', 196, true);


--
-- TOC entry 3268 (class 2606 OID 76721)
-- Name: _prisma_migrations _prisma_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public._prisma_migrations
    ADD CONSTRAINT _prisma_migrations_pkey PRIMARY KEY (id);


--
-- TOC entry 3292 (class 2606 OID 76838)
-- Name: adoptions adoptions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.adoptions
    ADD CONSTRAINT adoptions_pkey PRIMARY KEY (adoption_id);


--
-- TOC entry 3270 (class 2606 OID 76731)
-- Name: departments departments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.departments
    ADD CONSTRAINT departments_pkey PRIMARY KEY (department_id);


--
-- TOC entry 3274 (class 2606 OID 76751)
-- Name: districts districts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.districts
    ADD CONSTRAINT districts_pkey PRIMARY KEY (district_id);


--
-- TOC entry 3280 (class 2606 OID 76779)
-- Name: donations donations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.donations
    ADD CONSTRAINT donations_pkey PRIMARY KEY (donation_id);


--
-- TOC entry 3294 (class 2606 OID 76846)
-- Name: favorite_pets favorite_pets_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.favorite_pets
    ADD CONSTRAINT favorite_pets_pkey PRIMARY KEY (favorite_pet_id);


--
-- TOC entry 3286 (class 2606 OID 76808)
-- Name: pet_breeds pet_breeds_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pet_breeds
    ADD CONSTRAINT pet_breeds_pkey PRIMARY KEY (pet_breed_id);


--
-- TOC entry 3284 (class 2606 OID 76798)
-- Name: pet_categories pet_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pet_categories
    ADD CONSTRAINT pet_categories_pkey PRIMARY KEY (pet_category_id);


--
-- TOC entry 3290 (class 2606 OID 76829)
-- Name: pet_photos pet_photos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pet_photos
    ADD CONSTRAINT pet_photos_pkey PRIMARY KEY (id);


--
-- TOC entry 3288 (class 2606 OID 76819)
-- Name: pets pets_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pets
    ADD CONSTRAINT pets_pkey PRIMARY KEY (pet_id);


--
-- TOC entry 3278 (class 2606 OID 76770)
-- Name: plans plans_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.plans
    ADD CONSTRAINT plans_pkey PRIMARY KEY (plan_id);


--
-- TOC entry 3272 (class 2606 OID 76741)
-- Name: provinces provinces_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.provinces
    ADD CONSTRAINT provinces_pkey PRIMARY KEY (province_id);


--
-- TOC entry 3282 (class 2606 OID 76788)
-- Name: shelters shelters_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shelters
    ADD CONSTRAINT shelters_pkey PRIMARY KEY (shelter_id);


--
-- TOC entry 3276 (class 2606 OID 76760)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_id);


--
-- TOC entry 3308 (class 2606 OID 76912)
-- Name: adoptions adoptions_pet_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.adoptions
    ADD CONSTRAINT adoptions_pet_id_fkey FOREIGN KEY (pet_id) REFERENCES public.pets(pet_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3309 (class 2606 OID 76917)
-- Name: adoptions adoptions_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.adoptions
    ADD CONSTRAINT adoptions_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3296 (class 2606 OID 76857)
-- Name: districts districts_department_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.districts
    ADD CONSTRAINT districts_department_id_fkey FOREIGN KEY (department_id) REFERENCES public.departments(department_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3297 (class 2606 OID 76852)
-- Name: districts districts_province_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.districts
    ADD CONSTRAINT districts_province_id_fkey FOREIGN KEY (province_id) REFERENCES public.provinces(province_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3299 (class 2606 OID 76867)
-- Name: donations donations_plan_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.donations
    ADD CONSTRAINT donations_plan_id_fkey FOREIGN KEY (plan_id) REFERENCES public.plans(plan_id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 3300 (class 2606 OID 76872)
-- Name: donations donations_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.donations
    ADD CONSTRAINT donations_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 3310 (class 2606 OID 76922)
-- Name: favorite_pets favorite_pets_pet_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.favorite_pets
    ADD CONSTRAINT favorite_pets_pet_id_fkey FOREIGN KEY (pet_id) REFERENCES public.pets(pet_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3311 (class 2606 OID 76927)
-- Name: favorite_pets favorite_pets_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.favorite_pets
    ADD CONSTRAINT favorite_pets_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3303 (class 2606 OID 76887)
-- Name: pet_breeds pet_breeds_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pet_breeds
    ADD CONSTRAINT pet_breeds_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.pet_categories(pet_category_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3307 (class 2606 OID 76907)
-- Name: pet_photos pet_photos_pet_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pet_photos
    ADD CONSTRAINT pet_photos_pet_id_fkey FOREIGN KEY (pet_id) REFERENCES public.pets(pet_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3304 (class 2606 OID 76897)
-- Name: pets pets_breed_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pets
    ADD CONSTRAINT pets_breed_id_fkey FOREIGN KEY (breed_id) REFERENCES public.pet_breeds(pet_breed_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3305 (class 2606 OID 76892)
-- Name: pets pets_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pets
    ADD CONSTRAINT pets_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.pet_categories(pet_category_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3306 (class 2606 OID 76902)
-- Name: pets pets_shelter_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pets
    ADD CONSTRAINT pets_shelter_id_fkey FOREIGN KEY (shelter_id) REFERENCES public.shelters(shelter_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3295 (class 2606 OID 76847)
-- Name: provinces provinces_department_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.provinces
    ADD CONSTRAINT provinces_department_id_fkey FOREIGN KEY (department_id) REFERENCES public.departments(department_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3301 (class 2606 OID 76877)
-- Name: shelters shelters_district_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shelters
    ADD CONSTRAINT shelters_district_id_fkey FOREIGN KEY (district_id) REFERENCES public.districts(district_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3302 (class 2606 OID 76882)
-- Name: shelters shelters_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shelters
    ADD CONSTRAINT shelters_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 3298 (class 2606 OID 76862)
-- Name: users users_district_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_district_id_fkey FOREIGN KEY (district_id) REFERENCES public.districts(district_id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 3484 (class 0 OID 0)
-- Dependencies: 5
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;


-- Completed on 2024-12-08 20:52:11

--
-- PostgreSQL database dump complete
--

