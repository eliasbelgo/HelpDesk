--
-- PostgreSQL database dump
--

\restrict Ssdj9lghA3AKelveCwmCXjegq7ln3Rq5H4KnWn5t291FViHxGNQnavUASqjpini

-- Dumped from database version 16.15 (Debian 16.15-1.pgdg13+2)
-- Dumped by pg_dump version 16.15 (Debian 16.15-1.pgdg13+2)

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
-- Name: ticket_priority; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.ticket_priority AS ENUM (
    'low',
    'medium',
    'high',
    'urgent'
);


ALTER TYPE public.ticket_priority OWNER TO postgres;

--
-- Name: ticket_status; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.ticket_status AS ENUM (
    'open',
    'in_progress',
    'resolved',
    'closed'
);


ALTER TYPE public.ticket_status OWNER TO postgres;

--
-- Name: user_role; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.user_role AS ENUM (
    'employee',
    'manager',
    'admin'
);


ALTER TYPE public.user_role OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: comments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.comments (
    id integer NOT NULL,
    ticket_id integer NOT NULL,
    content text NOT NULL,
    author_name text NOT NULL,
    is_internal boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.comments OWNER TO postgres;

--
-- Name: comments_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.comments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.comments_id_seq OWNER TO postgres;

--
-- Name: comments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.comments_id_seq OWNED BY public.comments.id;


--
-- Name: departments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.departments (
    id integer NOT NULL,
    name text NOT NULL,
    description text,
    icon text DEFAULT 'briefcase'::text NOT NULL,
    color text DEFAULT '#2563EB'::text NOT NULL,
    contact_email text,
    contact_phone text,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.departments OWNER TO postgres;

--
-- Name: departments_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.departments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.departments_id_seq OWNER TO postgres;

--
-- Name: departments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.departments_id_seq OWNED BY public.departments.id;


--
-- Name: tickets; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tickets (
    id integer NOT NULL,
    title text NOT NULL,
    description text NOT NULL,
    status public.ticket_status DEFAULT 'open'::public.ticket_status NOT NULL,
    priority public.ticket_priority DEFAULT 'medium'::public.ticket_priority NOT NULL,
    progress integer DEFAULT 0 NOT NULL,
    department_id integer NOT NULL,
    created_by text NOT NULL,
    assigned_to text,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.tickets OWNER TO postgres;

--
-- Name: tickets_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tickets_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tickets_id_seq OWNER TO postgres;

--
-- Name: tickets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tickets_id_seq OWNED BY public.tickets.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id integer NOT NULL,
    name text NOT NULL,
    email text NOT NULL,
    role public.user_role DEFAULT 'employee'::public.user_role NOT NULL,
    department_id integer,
    password_hash text,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_id_seq OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: comments id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comments ALTER COLUMN id SET DEFAULT nextval('public.comments_id_seq'::regclass);


--
-- Name: departments id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.departments ALTER COLUMN id SET DEFAULT nextval('public.departments_id_seq'::regclass);


--
-- Name: tickets id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tickets ALTER COLUMN id SET DEFAULT nextval('public.tickets_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: comments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.comments (id, ticket_id, content, author_name, is_internal, created_at) FROM stdin;
\.


--
-- Data for Name: departments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.departments (id, name, description, icon, color, contact_email, contact_phone, created_at) FROM stdin;
1	Soporte Técnico	Soporte y mantenimiento	wrench	#1D4ED8	\N	\N	2026-10-06 21:50:48.322528
2	Soporte Técnico	Soporte y mantenimiento	wrench	#1D4ED8	\N	\N	2026-10-06 22:11:46.238559
\.


--
-- Data for Name: tickets; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tickets (id, title, description, status, priority, progress, department_id, created_by, assigned_to, created_at, updated_at) FROM stdin;
1	TICKET #1	TICKET PRUEBA	open	medium	0	1	Empleado Demo	\N	2026-10-06 22:09:27.935564	2026-10-06 22:09:27.935564
2	Ticket de prueba 1	Descripción 1	open	medium	0	1	Empleado Demo	\N	2026-10-06 22:11:51.906785	2026-10-06 22:11:51.906785
3	Ticket de prueba 2	Descripción 2	open	medium	0	1	Empleado Demo	\N	2026-10-06 22:11:51.92597	2026-10-06 22:11:51.92597
4	Ticket de prueba 3	Descripción 3	open	medium	0	1	Empleado Demo	\N	2026-10-06 22:11:51.94282	2026-10-06 22:11:51.94282
5	Ticket de prueba 4	Descripción 4	open	medium	0	1	Empleado Demo	\N	2026-10-06 22:11:51.956608	2026-10-06 22:11:51.956608
6	Ticket de prueba 5	Descripción 5	open	medium	0	1	Empleado Demo	\N	2026-10-06 22:11:51.969156	2026-10-06 22:11:51.969156
7	Ticket de prueba 6	Descripción 6	open	medium	0	1	Empleado Demo	\N	2026-10-06 22:11:51.982373	2026-10-06 22:11:51.982373
8	Ticket de prueba 7	Descripción 7	open	medium	0	1	Empleado Demo	\N	2026-10-06 22:11:51.995612	2026-10-06 22:11:51.995612
9	Ticket de prueba 8	Descripción 8	open	medium	0	1	Empleado Demo	\N	2026-10-06 22:11:52.010261	2026-10-06 22:11:52.010261
10	Ticket de prueba 9	Descripción 9	open	medium	0	1	Empleado Demo	\N	2026-10-06 22:11:52.023785	2026-10-06 22:11:52.023785
11	Ticket de prueba 10	Descripción 10	open	medium	0	1	Empleado Demo	\N	2026-10-06 22:11:52.03685	2026-10-06 22:11:52.03685
12	Ticket de prueba 11	Descripción 11	open	medium	0	1	Empleado Demo	\N	2026-10-06 22:11:52.04989	2026-10-06 22:11:52.04989
13	Ticket de prueba 12	Descripción 12	open	medium	0	1	Empleado Demo	\N	2026-10-06 22:11:52.06305	2026-10-06 22:11:52.06305
14	Ticket de prueba 13	Descripción 13	open	medium	0	1	Empleado Demo	\N	2026-10-06 22:11:52.075797	2026-10-06 22:11:52.075797
15	Ticket de prueba 14	Descripción 14	open	medium	0	1	Empleado Demo	\N	2026-10-06 22:11:52.088704	2026-10-06 22:11:52.088704
16	Ticket de prueba 15	Descripción 15	open	medium	0	1	Empleado Demo	\N	2026-10-06 22:11:52.10136	2026-10-06 22:11:52.10136
17	Ticket de prueba 16	Descripción 16	open	medium	0	1	Empleado Demo	\N	2026-10-06 22:11:52.113637	2026-10-06 22:11:52.113637
18	Ticket de prueba 17	Descripción 17	open	medium	0	1	Empleado Demo	\N	2026-10-06 22:11:52.126883	2026-10-06 22:11:52.126883
19	Ticket de prueba 18	Descripción 18	open	medium	0	1	Empleado Demo	\N	2026-10-06 22:11:52.140049	2026-10-06 22:11:52.140049
20	Ticket de prueba 19	Descripción 19	open	medium	0	1	Empleado Demo	\N	2026-10-06 22:11:52.153136	2026-10-06 22:11:52.153136
21	Ticket de prueba 20	Descripción 20	open	medium	0	1	Empleado Demo	\N	2026-10-06 22:11:52.166162	2026-10-06 22:11:52.166162
22	Ticket de prueba 21	Descripción 21	open	medium	0	1	Empleado Demo	\N	2026-10-06 22:11:52.179804	2026-10-06 22:11:52.179804
23	Ticket de prueba 22	Descripción 22	open	medium	0	1	Empleado Demo	\N	2026-10-06 22:11:52.1929	2026-10-06 22:11:52.1929
24	Ticket de prueba 23	Descripción 23	open	medium	0	1	Empleado Demo	\N	2026-10-06 22:11:52.208344	2026-10-06 22:11:52.208344
25	Ticket de prueba 24	Descripción 24	open	medium	0	1	Empleado Demo	\N	2026-10-06 22:11:52.223502	2026-10-06 22:11:52.223502
26	Ticket de prueba 25	Descripción 25	open	medium	0	1	Empleado Demo	\N	2026-10-06 22:11:52.237396	2026-10-06 22:11:52.237396
27	Ticket de prueba 26	Descripción 26	open	medium	0	1	Empleado Demo	\N	2026-10-06 22:11:52.250901	2026-10-06 22:11:52.250901
28	Ticket de prueba 27	Descripción 27	open	medium	0	1	Empleado Demo	\N	2026-10-06 22:11:52.264596	2026-10-06 22:11:52.264596
29	Ticket de prueba 28	Descripción 28	open	medium	0	1	Empleado Demo	\N	2026-10-06 22:11:52.278435	2026-10-06 22:11:52.278435
30	Ticket de prueba 29	Descripción 29	open	medium	0	1	Empleado Demo	\N	2026-10-06 22:11:52.292438	2026-10-06 22:11:52.292438
31	Ticket de prueba 30	Descripción 30	open	medium	0	1	Empleado Demo	\N	2026-10-06 22:11:52.306966	2026-10-06 22:11:52.306966
32	Ticket de prueba 31	Descripción 31	open	medium	0	1	Empleado Demo	\N	2026-10-06 22:11:52.320749	2026-10-06 22:11:52.320749
33	Ticket de prueba 32	Descripción 32	open	medium	0	1	Empleado Demo	\N	2026-10-06 22:11:52.334792	2026-10-06 22:11:52.334792
34	Ticket de prueba 33	Descripción 33	open	medium	0	1	Empleado Demo	\N	2026-10-06 22:11:52.349904	2026-10-06 22:11:52.349904
35	Ticket de prueba 34	Descripción 34	open	medium	0	1	Empleado Demo	\N	2026-10-06 22:11:52.371775	2026-10-06 22:11:52.371775
36	Ticket de prueba 35	Descripción 35	open	medium	0	1	Empleado Demo	\N	2026-10-06 22:11:52.386972	2026-10-06 22:11:52.386972
37	Ticket de prueba 36	Descripción 36	open	medium	0	1	Empleado Demo	\N	2026-10-06 22:11:52.401754	2026-10-06 22:11:52.401754
38	Ticket de prueba 37	Descripción 37	open	medium	0	1	Empleado Demo	\N	2026-10-06 22:11:52.417593	2026-10-06 22:11:52.417593
39	Ticket de prueba 38	Descripción 38	open	medium	0	1	Empleado Demo	\N	2026-10-06 22:11:52.433939	2026-10-06 22:11:52.433939
40	Ticket de prueba 39	Descripción 39	open	medium	0	1	Empleado Demo	\N	2026-10-06 22:11:52.447771	2026-10-06 22:11:52.447771
41	Ticket de prueba 40	Descripción 40	open	medium	0	1	Empleado Demo	\N	2026-10-06 22:11:52.462418	2026-10-06 22:11:52.462418
42	Ticket de prueba 41	Descripción 41	open	medium	0	1	Empleado Demo	\N	2026-10-06 22:11:52.477136	2026-10-06 22:11:52.477136
43	Ticket de prueba 42	Descripción 42	open	medium	0	1	Empleado Demo	\N	2026-10-06 22:11:52.492293	2026-10-06 22:11:52.492293
44	Ticket de prueba 43	Descripción 43	open	medium	0	1	Empleado Demo	\N	2026-10-06 22:11:52.508832	2026-10-06 22:11:52.508832
45	Ticket de prueba 44	Descripción 44	open	medium	0	1	Empleado Demo	\N	2026-10-06 22:11:52.524343	2026-10-06 22:11:52.524343
46	Ticket de prueba 45	Descripción 45	open	medium	0	1	Empleado Demo	\N	2026-10-06 22:11:52.541627	2026-10-06 22:11:52.541627
47	Ticket de prueba 46	Descripción 46	open	medium	0	1	Empleado Demo	\N	2026-10-06 22:11:52.555882	2026-10-06 22:11:52.555882
48	Ticket de prueba 47	Descripción 47	open	medium	0	1	Empleado Demo	\N	2026-10-06 22:11:52.570997	2026-10-06 22:11:52.570997
49	Ticket de prueba 48	Descripción 48	open	medium	0	1	Empleado Demo	\N	2026-10-06 22:11:52.585183	2026-10-06 22:11:52.585183
50	Ticket de prueba 49	Descripción 49	open	medium	0	1	Empleado Demo	\N	2026-10-06 22:11:52.599597	2026-10-06 22:11:52.599597
51	Ticket de prueba 50	Descripción 50	open	medium	0	1	Empleado Demo	\N	2026-10-06 22:11:52.613515	2026-10-06 22:11:52.613515
52	Ticket de prueba 51	Descripción 51	open	medium	0	1	Empleado Demo	\N	2026-10-06 22:11:52.62801	2026-10-06 22:11:52.62801
53	Ticket de prueba 52	Descripción 52	open	medium	0	1	Empleado Demo	\N	2026-10-06 22:11:52.641732	2026-10-06 22:11:52.641732
54	Ticket de prueba 53	Descripción 53	open	medium	0	1	Empleado Demo	\N	2026-10-06 22:11:52.655525	2026-10-06 22:11:52.655525
55	Ticket de prueba 54	Descripción 54	open	medium	0	1	Empleado Demo	\N	2026-10-06 22:11:52.668904	2026-10-06 22:11:52.668904
56	Ticket de prueba 55	Descripción 55	open	medium	0	1	Empleado Demo	\N	2026-10-06 22:11:52.683256	2026-10-06 22:11:52.683256
57	Ticket de prueba 56	Descripción 56	open	medium	0	1	Empleado Demo	\N	2026-10-06 22:11:52.697456	2026-10-06 22:11:52.697456
58	Ticket de prueba 57	Descripción 57	open	medium	0	1	Empleado Demo	\N	2026-10-06 22:11:52.711123	2026-10-06 22:11:52.711123
59	Ticket de prueba 58	Descripción 58	open	medium	0	1	Empleado Demo	\N	2026-10-06 22:11:52.725731	2026-10-06 22:11:52.725731
60	Ticket de prueba 59	Descripción 59	open	medium	0	1	Empleado Demo	\N	2026-10-06 22:11:52.739641	2026-10-06 22:11:52.739641
61	Ticket de prueba 60	Descripción 60	open	medium	0	1	Empleado Demo	\N	2026-10-06 22:11:52.753183	2026-10-06 22:11:52.753183
62	Ticket de prueba 61	Descripción 61	open	medium	0	1	Empleado Demo	\N	2026-10-06 22:11:52.767046	2026-10-06 22:11:52.767046
63	Ticket de prueba 62	Descripción 62	open	medium	0	1	Empleado Demo	\N	2026-10-06 22:11:52.780849	2026-10-06 22:11:52.780849
64	Ticket de prueba 63	Descripción 63	open	medium	0	1	Empleado Demo	\N	2026-10-06 22:11:52.795685	2026-10-06 22:11:52.795685
65	Ticket de prueba 64	Descripción 64	open	medium	0	1	Empleado Demo	\N	2026-10-06 22:11:52.810261	2026-10-06 22:11:52.810261
66	Ticket de prueba 65	Descripción 65	open	medium	0	1	Empleado Demo	\N	2026-10-06 22:11:52.824213	2026-10-06 22:11:52.824213
67	Ticket de prueba 66	Descripción 66	open	medium	0	1	Empleado Demo	\N	2026-10-06 22:11:52.841666	2026-10-06 22:11:52.841666
68	Ticket de prueba 67	Descripción 67	open	medium	0	1	Empleado Demo	\N	2026-10-06 22:11:52.870391	2026-10-06 22:11:52.870391
69	Ticket de prueba 68	Descripción 68	open	medium	0	1	Empleado Demo	\N	2026-10-06 22:11:52.887296	2026-10-06 22:11:52.887296
70	Ticket de prueba 69	Descripción 69	open	medium	0	1	Empleado Demo	\N	2026-10-06 22:11:52.902404	2026-10-06 22:11:52.902404
71	Ticket de prueba 70	Descripción 70	open	medium	0	1	Empleado Demo	\N	2026-10-06 22:11:52.916894	2026-10-06 22:11:52.916894
72	Ticket de prueba 71	Descripción 71	open	medium	0	1	Empleado Demo	\N	2026-10-06 22:11:52.932117	2026-10-06 22:11:52.932117
73	Ticket de prueba 72	Descripción 72	open	medium	0	1	Empleado Demo	\N	2026-10-06 22:11:52.947599	2026-10-06 22:11:52.947599
74	Ticket de prueba 73	Descripción 73	open	medium	0	1	Empleado Demo	\N	2026-10-06 22:11:52.96228	2026-10-06 22:11:52.96228
75	Ticket de prueba 74	Descripción 74	open	medium	0	1	Empleado Demo	\N	2026-10-06 22:11:52.976717	2026-10-06 22:11:52.976717
76	Ticket de prueba 75	Descripción 75	open	medium	0	1	Empleado Demo	\N	2026-10-06 22:11:52.991069	2026-10-06 22:11:52.991069
77	Ticket de prueba 76	Descripción 76	open	medium	0	1	Empleado Demo	\N	2026-10-06 22:11:53.005959	2026-10-06 22:11:53.005959
78	Ticket de prueba 77	Descripción 77	open	medium	0	1	Empleado Demo	\N	2026-10-06 22:11:53.021426	2026-10-06 22:11:53.021426
79	Ticket de prueba 78	Descripción 78	open	medium	0	1	Empleado Demo	\N	2026-10-06 22:11:53.036283	2026-10-06 22:11:53.036283
80	Ticket de prueba 79	Descripción 79	open	medium	0	1	Empleado Demo	\N	2026-10-06 22:11:53.051852	2026-10-06 22:11:53.051852
81	Ticket de prueba 80	Descripción 80	open	medium	0	1	Empleado Demo	\N	2026-10-06 22:11:53.067579	2026-10-06 22:11:53.067579
82	Ticket de prueba 81	Descripción 81	open	medium	0	1	Empleado Demo	\N	2026-10-06 22:11:53.087292	2026-10-06 22:11:53.087292
83	Ticket de prueba 82	Descripción 82	open	medium	0	1	Empleado Demo	\N	2026-10-06 22:11:53.102371	2026-10-06 22:11:53.102371
84	Ticket de prueba 83	Descripción 83	open	medium	0	1	Empleado Demo	\N	2026-10-06 22:11:53.117592	2026-10-06 22:11:53.117592
85	Ticket de prueba 84	Descripción 84	open	medium	0	1	Empleado Demo	\N	2026-10-06 22:11:53.133615	2026-10-06 22:11:53.133615
86	Ticket de prueba 85	Descripción 85	open	medium	0	1	Empleado Demo	\N	2026-10-06 22:11:53.149077	2026-10-06 22:11:53.149077
87	Ticket de prueba 86	Descripción 86	open	medium	0	1	Empleado Demo	\N	2026-10-06 22:11:53.163859	2026-10-06 22:11:53.163859
88	Ticket de prueba 87	Descripción 87	open	medium	0	1	Empleado Demo	\N	2026-10-06 22:11:53.178478	2026-10-06 22:11:53.178478
89	Ticket de prueba 88	Descripción 88	open	medium	0	1	Empleado Demo	\N	2026-10-06 22:11:53.19414	2026-10-06 22:11:53.19414
90	Ticket de prueba 89	Descripción 89	open	medium	0	1	Empleado Demo	\N	2026-10-06 22:11:53.210106	2026-10-06 22:11:53.210106
91	Ticket de prueba 90	Descripción 90	open	medium	0	1	Empleado Demo	\N	2026-10-06 22:11:53.226718	2026-10-06 22:11:53.226718
92	Ticket de prueba 91	Descripción 91	open	medium	0	1	Empleado Demo	\N	2026-10-06 22:11:53.242837	2026-10-06 22:11:53.242837
93	Ticket de prueba 92	Descripción 92	open	medium	0	1	Empleado Demo	\N	2026-10-06 22:11:53.258848	2026-10-06 22:11:53.258848
94	Ticket de prueba 93	Descripción 93	open	medium	0	1	Empleado Demo	\N	2026-10-06 22:11:53.274251	2026-10-06 22:11:53.274251
95	Ticket de prueba 94	Descripción 94	open	medium	0	1	Empleado Demo	\N	2026-10-06 22:11:53.290132	2026-10-06 22:11:53.290132
96	Ticket de prueba 95	Descripción 95	open	medium	0	1	Empleado Demo	\N	2026-10-06 22:11:53.304396	2026-10-06 22:11:53.304396
97	Ticket de prueba 96	Descripción 96	open	medium	0	1	Empleado Demo	\N	2026-10-06 22:11:53.317987	2026-10-06 22:11:53.317987
98	Ticket de prueba 97	Descripción 97	open	medium	0	1	Empleado Demo	\N	2026-10-06 22:11:53.332598	2026-10-06 22:11:53.332598
99	Ticket de prueba 98	Descripción 98	open	medium	0	1	Empleado Demo	\N	2026-10-06 22:11:53.346966	2026-10-06 22:11:53.346966
100	Ticket de prueba 99	Descripción 99	open	medium	0	1	Empleado Demo	\N	2026-10-06 22:11:53.363513	2026-10-06 22:11:53.363513
101	Ticket de prueba 100	Descripción 100	open	medium	0	1	Empleado Demo	\N	2026-10-06 22:11:53.378176	2026-10-06 22:11:53.378176
102	Ticket de prueba 101	Descripción 101	open	medium	0	1	Empleado Demo	\N	2026-10-06 22:11:53.391915	2026-10-06 22:11:53.391915
103	Ticket de prueba 102	Descripción 102	open	medium	0	1	Empleado Demo	\N	2026-10-06 22:11:53.406614	2026-10-06 22:11:53.406614
104	Ticket de prueba 103	Descripción 103	open	medium	0	1	Empleado Demo	\N	2026-10-06 22:11:53.420967	2026-10-06 22:11:53.420967
105	Ticket de prueba 104	Descripción 104	open	medium	0	1	Empleado Demo	\N	2026-10-06 22:11:53.435002	2026-10-06 22:11:53.435002
106	Ticket de prueba 105	Descripción 105	open	medium	0	1	Empleado Demo	\N	2026-10-06 22:11:53.449789	2026-10-06 22:11:53.449789
107	Ticket de prueba 106	Descripción 106	open	medium	0	1	Empleado Demo	\N	2026-10-06 22:11:53.463514	2026-10-06 22:11:53.463514
108	Ticket de prueba 107	Descripción 107	open	medium	0	1	Empleado Demo	\N	2026-10-06 22:11:53.477697	2026-10-06 22:11:53.477697
109	Ticket de prueba 108	Descripción 108	open	medium	0	1	Empleado Demo	\N	2026-10-06 22:11:53.492205	2026-10-06 22:11:53.492205
110	Ticket de prueba 109	Descripción 109	open	medium	0	1	Empleado Demo	\N	2026-10-06 22:11:53.506564	2026-10-06 22:11:53.506564
111	Ticket de prueba 110	Descripción 110	open	medium	0	1	Empleado Demo	\N	2026-10-06 22:11:53.519578	2026-10-06 22:11:53.519578
112	Ticket de prueba 111	Descripción 111	open	medium	0	1	Empleado Demo	\N	2026-10-06 22:11:53.533492	2026-10-06 22:11:53.533492
113	Ticket de prueba 112	Descripción 112	open	medium	0	1	Empleado Demo	\N	2026-10-06 22:11:53.547921	2026-10-06 22:11:53.547921
114	Ticket de prueba 113	Descripción 113	open	medium	0	1	Empleado Demo	\N	2026-10-06 22:11:53.563192	2026-10-06 22:11:53.563192
115	Ticket de prueba 114	Descripción 114	open	medium	0	1	Empleado Demo	\N	2026-10-06 22:11:53.578416	2026-10-06 22:11:53.578416
116	Ticket de prueba 115	Descripción 115	open	medium	0	1	Empleado Demo	\N	2026-10-06 22:11:53.594081	2026-10-06 22:11:53.594081
117	Ticket de prueba 116	Descripción 116	open	medium	0	1	Empleado Demo	\N	2026-10-06 22:11:53.609208	2026-10-06 22:11:53.609208
118	Ticket de prueba 117	Descripción 117	open	medium	0	1	Empleado Demo	\N	2026-10-06 22:11:53.624138	2026-10-06 22:11:53.624138
119	Ticket de prueba 118	Descripción 118	open	medium	0	1	Empleado Demo	\N	2026-10-06 22:11:53.639189	2026-10-06 22:11:53.639189
120	Ticket de prueba 119	Descripción 119	open	medium	0	1	Empleado Demo	\N	2026-10-06 22:11:53.654123	2026-10-06 22:11:53.654123
121	Ticket de prueba 120	Descripción 120	open	medium	0	1	Empleado Demo	\N	2026-10-06 22:11:53.669233	2026-10-06 22:11:53.669233
122	Ticket de prueba 121	Descripción 121	open	medium	0	1	Empleado Demo	\N	2026-10-06 22:11:53.684455	2026-10-06 22:11:53.684455
123	Ticket de prueba 122	Descripción 122	open	medium	0	1	Empleado Demo	\N	2026-10-06 22:11:53.699585	2026-10-06 22:11:53.699585
124	Ticket de prueba 123	Descripción 123	open	medium	0	1	Empleado Demo	\N	2026-10-06 22:11:53.71495	2026-10-06 22:11:53.71495
125	Ticket de prueba 124	Descripción 124	open	medium	0	1	Empleado Demo	\N	2026-10-06 22:11:53.729965	2026-10-06 22:11:53.729965
126	Ticket de prueba 125	Descripción 125	open	medium	0	1	Empleado Demo	\N	2026-10-06 22:11:53.744052	2026-10-06 22:11:53.744052
127	Ticket de prueba 126	Descripción 126	open	medium	0	1	Empleado Demo	\N	2026-10-06 22:11:53.758809	2026-10-06 22:11:53.758809
128	Ticket de prueba 127	Descripción 127	open	medium	0	1	Empleado Demo	\N	2026-10-06 22:11:53.773001	2026-10-06 22:11:53.773001
129	Ticket de prueba 128	Descripción 128	open	medium	0	1	Empleado Demo	\N	2026-10-06 22:11:53.788186	2026-10-06 22:11:53.788186
130	Ticket de prueba 129	Descripción 129	open	medium	0	1	Empleado Demo	\N	2026-10-06 22:11:53.802679	2026-10-06 22:11:53.802679
131	Ticket de prueba 130	Descripción 130	open	medium	0	1	Empleado Demo	\N	2026-10-06 22:11:53.819164	2026-10-06 22:11:53.819164
132	Ticket de prueba 131	Descripción 131	open	medium	0	1	Empleado Demo	\N	2026-10-06 22:11:53.836587	2026-10-06 22:11:53.836587
133	Ticket de prueba 132	Descripción 132	open	medium	0	1	Empleado Demo	\N	2026-10-06 22:11:53.853157	2026-10-06 22:11:53.853157
134	Ticket de prueba 133	Descripción 133	open	medium	0	1	Empleado Demo	\N	2026-10-06 22:11:53.869881	2026-10-06 22:11:53.869881
135	Ticket de prueba 134	Descripción 134	open	medium	0	1	Empleado Demo	\N	2026-10-06 22:11:53.885948	2026-10-06 22:11:53.885948
136	Ticket de prueba 135	Descripción 135	open	medium	0	1	Empleado Demo	\N	2026-10-06 22:11:53.902688	2026-10-06 22:11:53.902688
137	Ticket de prueba 136	Descripción 136	open	medium	0	1	Empleado Demo	\N	2026-10-06 22:11:53.916971	2026-10-06 22:11:53.916971
138	Ticket de prueba 137	Descripción 137	open	medium	0	1	Empleado Demo	\N	2026-10-06 22:11:53.931585	2026-10-06 22:11:53.931585
139	Ticket de prueba 138	Descripción 138	open	medium	0	1	Empleado Demo	\N	2026-10-06 22:11:53.947167	2026-10-06 22:11:53.947167
140	Ticket de prueba 139	Descripción 139	open	medium	0	1	Empleado Demo	\N	2026-10-06 22:11:53.962014	2026-10-06 22:11:53.962014
141	Ticket de prueba 140	Descripción 140	open	medium	0	1	Empleado Demo	\N	2026-10-06 22:11:53.978248	2026-10-06 22:11:53.978248
142	Ticket de prueba 141	Descripción 141	open	medium	0	1	Empleado Demo	\N	2026-10-06 22:11:53.993614	2026-10-06 22:11:53.993614
143	Ticket de prueba 142	Descripción 142	open	medium	0	1	Empleado Demo	\N	2026-10-06 22:11:54.008178	2026-10-06 22:11:54.008178
144	Ticket de prueba 143	Descripción 143	open	medium	0	1	Empleado Demo	\N	2026-10-06 22:11:54.022566	2026-10-06 22:11:54.022566
145	Ticket de prueba 144	Descripción 144	open	medium	0	1	Empleado Demo	\N	2026-10-06 22:11:54.036478	2026-10-06 22:11:54.036478
146	Ticket de prueba 145	Descripción 145	open	medium	0	1	Empleado Demo	\N	2026-10-06 22:11:54.051207	2026-10-06 22:11:54.051207
147	Ticket de prueba 146	Descripción 146	open	medium	0	1	Empleado Demo	\N	2026-10-06 22:11:54.066235	2026-10-06 22:11:54.066235
148	Ticket de prueba 147	Descripción 147	open	medium	0	1	Empleado Demo	\N	2026-10-06 22:11:54.081873	2026-10-06 22:11:54.081873
149	Ticket de prueba 148	Descripción 148	open	medium	0	1	Empleado Demo	\N	2026-10-06 22:11:54.099817	2026-10-06 22:11:54.099817
150	Ticket de prueba 149	Descripción 149	open	medium	0	1	Empleado Demo	\N	2026-10-06 22:11:54.119078	2026-10-06 22:11:54.119078
151	Ticket de prueba 150	Descripción 150	open	medium	0	1	Empleado Demo	\N	2026-10-06 22:11:54.137992	2026-10-06 22:11:54.137992
152	Ticket del admin	privado	open	low	0	1	Admin Demo	\N	2026-10-06 22:21:42.134068	2026-10-06 22:21:42.134068
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, name, email, role, department_id, password_hash, created_at) FROM stdin;
1	Admin Demo	admin@demo.com	admin	\N	$2b$10$uZ9aVNVms6gyP64LjTPM8OvzHU9uxh4E4IY4024CU6z3kMeJtMaS.	2026-10-06 20:46:43.739277
2	Gerente Demo	gerente@demo.com	manager	\N	$2b$10$o9pg67YVs9teZYpJoXtuJ.1wiD8SMCvZJJ0kVH1yoeXjpmwo0Xnci	2026-10-06 20:47:53.86562
3	Empleado Demo	empleado@demo.com	employee	\N	$2b$10$LFt86Uaff5Etxq/OyZ7a7u4HBQeT7rs4C7SKcXDysYytT1ONL/1Vq	2026-10-06 20:48:13.858037
4	Intruso	intruso29304@demo.com	admin	\N	$2b$10$p1v38jYOCIVW1dzU.u2qiuFmnCNt.uJeMgwvoB/CLjnRdAVbc.RH2	2026-10-06 22:21:42.29909
\.


--
-- Name: comments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.comments_id_seq', 1, false);


--
-- Name: departments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.departments_id_seq', 2, true);


--
-- Name: tickets_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tickets_id_seq', 152, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 4, true);


--
-- Name: comments comments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT comments_pkey PRIMARY KEY (id);


--
-- Name: departments departments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.departments
    ADD CONSTRAINT departments_pkey PRIMARY KEY (id);


--
-- Name: tickets tickets_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tickets
    ADD CONSTRAINT tickets_pkey PRIMARY KEY (id);


--
-- Name: users users_email_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_unique UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- PostgreSQL database dump complete
--

\unrestrict Ssdj9lghA3AKelveCwmCXjegq7ln3Rq5H4KnWn5t291FViHxGNQnavUASqjpini

