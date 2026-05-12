--
-- PostgreSQL database dump
--

-- Dumped from database version 10.23
-- Dumped by pg_dump version 10.23

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
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: CUSTOMERS; Type: TABLE; Schema: public; Owner: ccmall_user
--

CREATE TABLE public."CUSTOMERS" (
    "ID" character varying(50) NOT NULL,
    "PW" character varying(255) NOT NULL,
    "NAME" character varying(50) NOT NULL,
    "BIRTH" date NOT NULL,
    "ADDR" character varying(50) NOT NULL,
    "EMAIL" character varying(100) NOT NULL,
    "PHONE" character varying(20) NOT NULL
);


ALTER TABLE public."CUSTOMERS" OWNER TO ccmall_user;

--
-- Name: admins; Type: TABLE; Schema: public; Owner: ccmall_user
--

CREATE TABLE public.admins (
    id integer NOT NULL,
    username character varying(50) NOT NULL,
    password character varying(255) NOT NULL
);


ALTER TABLE public.admins OWNER TO ccmall_user;

--
-- Name: admins_id_seq; Type: SEQUENCE; Schema: public; Owner: ccmall_user
--

CREATE SEQUENCE public.admins_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.admins_id_seq OWNER TO ccmall_user;

--
-- Name: admins_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ccmall_user
--

ALTER SEQUENCE public.admins_id_seq OWNED BY public.admins.id;


--
-- Name: customers; Type: TABLE; Schema: public; Owner: ccmall_user
--

CREATE TABLE public.customers (
    id character varying(50) NOT NULL,
    password character varying(255) NOT NULL,
    name character varying(50) NOT NULL,
    birth_date date NOT NULL,
    address character varying(50) NOT NULL,
    email character varying(100) NOT NULL,
    phone_number character varying(20) NOT NULL
);


ALTER TABLE public.customers OWNER TO ccmall_user;

--
-- Name: inventorys; Type: TABLE; Schema: public; Owner: ccmall_user
--

CREATE TABLE public.inventorys (
    item_id integer NOT NULL,
    item_name character varying(255),
    quantity integer
);


ALTER TABLE public.inventorys OWNER TO ccmall_user;

--
-- Name: inventorys_item_id_seq; Type: SEQUENCE; Schema: public; Owner: ccmall_user
--

CREATE SEQUENCE public.inventorys_item_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.inventorys_item_id_seq OWNER TO ccmall_user;

--
-- Name: inventorys_item_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ccmall_user
--

ALTER SEQUENCE public.inventorys_item_id_seq OWNED BY public.inventorys.item_id;


--
-- Name: orders; Type: TABLE; Schema: public; Owner: ccmall_user
--

CREATE TABLE public.orders (
    order_id integer NOT NULL,
    item_id integer,
    customer_id character varying(50),
    order_quantity integer DEFAULT 1 NOT NULL,
    order_time timestamp without time zone
);


ALTER TABLE public.orders OWNER TO ccmall_user;

--
-- Name: orders_order_id_seq; Type: SEQUENCE; Schema: public; Owner: ccmall_user
--

CREATE SEQUENCE public.orders_order_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.orders_order_id_seq OWNER TO ccmall_user;

--
-- Name: orders_order_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ccmall_user
--

ALTER SEQUENCE public.orders_order_id_seq OWNED BY public.orders.order_id;


--
-- Name: admins id; Type: DEFAULT; Schema: public; Owner: ccmall_user
--

ALTER TABLE ONLY public.admins ALTER COLUMN id SET DEFAULT nextval('public.admins_id_seq'::regclass);


--
-- Name: inventorys item_id; Type: DEFAULT; Schema: public; Owner: ccmall_user
--

ALTER TABLE ONLY public.inventorys ALTER COLUMN item_id SET DEFAULT nextval('public.inventorys_item_id_seq'::regclass);


--
-- Name: orders order_id; Type: DEFAULT; Schema: public; Owner: ccmall_user
--

ALTER TABLE ONLY public.orders ALTER COLUMN order_id SET DEFAULT nextval('public.orders_order_id_seq'::regclass);


--
-- Data for Name: CUSTOMERS; Type: TABLE DATA; Schema: public; Owner: ccmall_user
--

COPY public."CUSTOMERS" ("ID", "PW", "NAME", "BIRTH", "ADDR", "EMAIL", "PHONE") FROM stdin;
user01	pass123	홍길동	1990-01-01	서울시	test@test.com	010-1234-5678
user03	pass123	홍길동	1990-01-01	서울시	test@test.com	010-1234-5678
\.


--
-- Data for Name: admins; Type: TABLE DATA; Schema: public; Owner: ccmall_user
--

COPY public.admins (id, username, password) FROM stdin;
1	admin	password
\.


--
-- Data for Name: customers; Type: TABLE DATA; Schema: public; Owner: ccmall_user
--

COPY public.customers (id, password, name, birth_date, address, email, phone_number) FROM stdin;
c00046b432	pw4!	최지우	2001-07-30	서울시 동작구 사당동 101	jiwoo_choi@outlook.com	010-8592-3456
c0005a87ff	pw5!	정하윤	1984-12-05	서울시 마포구 망원동 7	hayun_jung@gmail.com	010-4412-7890
c00067d5e4	pw6!	강건우	1992-01-18	서울시 서대문구 연희동 23	gunwoo_k@naver.com	010-9283-1122
c000781745	pw7!	조예진	1980-09-25	서울시 용산구 이태원동 56	yejin_cho@daum.net	010-3341-3344
c0008f512a	pw8!	윤상현	1999-04-12	서울시 성동구 성수동 99	sanghyun_y@gmail.com	010-2194-5566
c0009c9612	pw9!	장미소	1987-06-21	서울시 광진구 자양동 14	miso_jang@naver.com	010-7752-7788
c001099612	pw10!	임태양	1993-10-02	경기도 수원시 영통구 33	taeyang_lim@daum.net	010-1123-9900
c0011a2f34	pw11!	한지민	1985-02-14	경기도 성남시 분당구 202	jimin_han@gmail.com	010-4566-1010
c0012b1d56	pw12!	오세진	1991-08-08	인천시 연수구 송도동 41	sejin_oh@naver.com	010-8921-2020
c0013c7a88	pw13!	서유나	1983-05-27	부산시 해운대구 우동 15	yuna_seo@daum.net	010-3321-3030
c0014d9b12	pw14!	신동혁	2000-12-12	대구시 수성구 범어동 88	donghyuk_s@gmail.com	010-7711-4040
c0015e5f31	pw15!	권보람	1989-01-01	광주시 북구 용봉동 12	boram_kwon@naver.com	010-9982-5050
c0016f9a00	pw16!	황우진	1994-03-20	대전시 유성구 궁동 77	woojin_h@daum.net	010-4451-6060
c0017a0b22	pw17!	안소희	1981-06-15	서울시 은평구 불광동 5	sohee_ahn@gmail.com	010-2210-7070
c0018b3c44	pw18!	송준호	1997-09-09	서울시 강동구 천호동 32	junho_song@naver.com	010-8843-8080
c0019c5d66	pw19!	전지혜	1986-11-11	서울시 중랑구 면목동 19	jihye_jeon@daum.net	010-6672-9090
c0020d7e88	pw20!	홍길동	2003-02-28	서울시 금천구 가산동 44	gildong_h@gmail.com	010-1194-0101
c0021e9f10	pw21!	유재석	1982-04-05	서울시 관악구 신림동 2	jaeseok_y@naver.com	010-5541-0202
c0022a1b32	pw22!	강호동	1990-07-07	경기도 고양시 일산구 6	hodong_k@daum.net	010-3382-0303
c0023b2c43	pw23!	이수근	1984-09-19	강원도 춘천시 퇴계동 11	soogeun_l@gmail.com	010-2274-0404
c0024c3d54	pw24!	김희철	1996-12-31	서울시 성북구 성북동 8	heechul_k@naver.com	010-8812-0505
c0025d4e65	pw25!	손흥민	1988-05-14	서울시 강북구 수유동 21	sonny7@daum.net	010-4491-0606
c0026e5f76	pw26!	이강인	2001-08-22	서울시 영등포구 여의도 3	kangin_l@gmail.com	010-9923-0707
c0027f6a87	pw27!	김연아	1980-02-11	서울시 종로구 평창동 1	yuna_k@naver.com	010-3345-0808
c0028a7b98	pw28!	차범근	1993-11-30	경기도 용인시 기흥구 9	beomgeun_c@daum.net	010-7714-0909
c0029b8c09	pw29!	박세리	1985-04-18	대전시 서구 둔산동 12	seri_p@gmail.com	010-5592-1011
c0030c9d10	pw30!	현진영	1998-06-06	서울시 중구 명동 55	jinyoung_h@naver.com	010-1124-1212
c0031d0e21	pw31!	이효리	1987-10-15	제주시 애월읍 소길리 1	hyori_l@daum.net	010-4456-1313
c0032e1f32	pw32!	엄정화	2002-01-25	서울시 서초구 방배동 9	junghwa_e@gmail.com	010-9983-1414
c0034a3b54	pw34!	정우성	1994-07-20	서울시 마포구 상암동 3	woosung_j@daum.net	010-8845-1616
c0035b4c65	pw35!	이정재	1983-09-09	서울시 성북구 안암동 1	jungjae_l@gmail.com	010-6671-1717
c0036c5d76	pw36!	공유	1991-04-10	서울시 서대문구 신촌동 4	gongyoo@naver.com	010-5523-1818
c0037d6e87	pw37!	한효주	1989-02-22	경기도 남양주시 11	hyojoo_h@daum.net	010-3312-1919
c0038e7f98	pw38!	남주혁	1996-05-18	서울시 광진구 화양동 6	juhyuk_n@gmail.com	010-2294-2020
c0039f8a09	pw39!	수지	1994-10-10	서울시 송파구 문정동 14	suzy_bae@naver.com	010-1182-2121
c0040a9b10	pw40!	아이유	1993-05-16	서울시 용산구 한남동 2	iu_lee@daum.net	010-4471-2222
c0041b0c21	pw41!	지드래곤	1988-08-18	서울시 성동구 옥수동 5	gd_kwon@gmail.com	010-9912-2323
c0042c1d32	pw42!	태연	1989-03-09	서울시 강남구 논현동 7	taeyeon_k@naver.com	010-2245-2424
c0043d2e43	pw43!	박보검	1993-06-16	서울시 강서구 화곡동 33	bogum_p@daum.net	010-8821-2525
c0044e3f54	pw44!	김수현	1988-02-16	서울시 양천구 목동 41	soohyun_k@gmail.com	010-3372-2626
c0045f4a65	pw45!	신세경	1990-07-29	서울시 구로구 신도림동 2	sekyeong_s@naver.com	010-7794-2727
c0046a5b76	pw46!	이종석	1989-09-14	서울시 중구 을지로 12	jongsuk_l@daum.net	010-1141-2828
c0047b6c87	pw47!	박서준	1988-12-16	서울시 서초구 반포동 5	seojun_p@gmail.com	010-5566-2929
c0048c7d98	pw48!	정해인	1988-04-01	서울시 마포구 서교동 8	haein_j@naver.com	010-3388-3030
c0049d8e09	pw49!	송혜교	1981-11-22	서울시 강남구 압구정동 1	hyekyo_s@daum.net	010-2211-3131
c0050e9f10	pw50!	장동건	1982-03-07	서울시 종로구 가회동 12	donggun_j@gmail.com	010-8844-3232
c00028941f	pw2!	이서연	1995-11-22	서울시 강남구 역삼동 82	seoyeon_lee@dsa.as	010-3942-5678
c0003072b0	pw3!	박도현	1988-03-15	서울시 서초구 서초동 45	dohyun88@daum.net	010-1294-9014
\.


--
-- Data for Name: inventorys; Type: TABLE DATA; Schema: public; Owner: ccmall_user
--

COPY public.inventorys (item_id, item_name, quantity) FROM stdin;
2	삼성 갤럭시 S24 울트라	23
3	LG 디오스 오브제컬렉션 냉장고	8
4	소니 노이즈캔슬링 헤드폰 WH-1000XM5	42
5	로지텍 MX Master 3S 마우스	55
6	다이슨 에어랩 멀티 스타일러	12
7	필립스 휴 스마트 조명 스타터 키트	30
8	닌텐도 스위치 OLED 모델	28
9	드롱기 전자동 커피머신	5
10	발뮤다 더 토스터	18
11	레오폴드 기계식 키보드 FC900R	25
12	아이패드 프로 12.9 6세대	14
13	샤오미 미에어 공기청정기 4	60
14	보스 사운드링크 플렉스 블루투스 스피커	35
15	시디즈 T50 사무용 의자	20
16	모카포트 비알레띠 3컵	48
17	킨토 데이트 텀블러 500ml	100
18	크레마 모티프 전자책 단말기	22
19	네스프레소 버츄오 팝	17
20	뱅앤올룹슨 Beosound A1 2세대	10
1	애플 맥북 에어 M3	16
\.


--
-- Data for Name: orders; Type: TABLE DATA; Schema: public; Owner: ccmall_user
--

COPY public.orders (order_id, item_id, customer_id, order_quantity, order_time) FROM stdin;
2	5	c00028941f	2	2024-04-02 14:15:30
3	12	c0003072b0	1	2024-04-03 09:45:12
4	8	c00046b432	3	2024-04-04 18:22:45
5	3	c0005a87ff	1	2024-04-05 11:30:00
6	15	c00067d5e4	1	2024-04-06 13:10:22
7	20	c000781745	2	2024-04-07 15:55:00
8	7	c0008f512a	1	2024-04-08 12:40:15
9	2	c0009c9612	1	2024-04-09 17:05:33
10	11	c001099612	2	2024-04-10 20:18:00
11	18	c0011a2f34	1	2024-04-11 08:30:45
12	4	c0012b1d56	3	2024-04-12 21:12:00
13	9	c0013c7a88	1	2024-04-13 14:25:10
14	6	c0014d9b12	1	2024-04-14 11:11:11
15	14	c0015e5f31	2	2024-04-15 16:45:00
16	19	c0016f9a00	1	2024-04-16 10:05:30
17	10	c0017a0b22	1	2024-04-17 19:33:00
18	17	c0018b3c44	2	2024-04-18 12:22:15
19	13	c0019c5d66	1	2024-04-19 14:14:14
20	1	c0020d7e88	1	2024-04-20 09:50:00
21	16	c0021e9f10	3	2024-04-21 17:15:45
22	3	c0022a1b32	1	2024-04-22 13:00:00
23	5	c0023b2c43	2	2024-04-23 20:40:30
24	11	c0024c3d54	1	2024-04-24 11:20:12
25	8	c0025d4e65	1	2024-04-25 15:55:55
26	2	c0026e5f76	2	2024-04-26 18:10:00
27	12	c0027f6a87	1	2024-04-27 12:30:40
28	15	c0028a7b98	1	2024-04-28 14:05:00
29	7	c0029b8c09	3	2024-04-29 16:50:20
30	10	c0030c9d10	1	2024-04-30 21:00:00
\.


--
-- Name: admins_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ccmall_user
--

SELECT pg_catalog.setval('public.admins_id_seq', 1, true);


--
-- Name: inventorys_item_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ccmall_user
--

SELECT pg_catalog.setval('public.inventorys_item_id_seq', 20, true);


--
-- Name: orders_order_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ccmall_user
--

SELECT pg_catalog.setval('public.orders_order_id_seq', 30, true);


--
-- Name: CUSTOMERS CUSTOMERS_pkey; Type: CONSTRAINT; Schema: public; Owner: ccmall_user
--

ALTER TABLE ONLY public."CUSTOMERS"
    ADD CONSTRAINT "CUSTOMERS_pkey" PRIMARY KEY ("ID");


--
-- Name: admins admins_pkey; Type: CONSTRAINT; Schema: public; Owner: ccmall_user
--

ALTER TABLE ONLY public.admins
    ADD CONSTRAINT admins_pkey PRIMARY KEY (id);


--
-- Name: admins admins_username_key; Type: CONSTRAINT; Schema: public; Owner: ccmall_user
--

ALTER TABLE ONLY public.admins
    ADD CONSTRAINT admins_username_key UNIQUE (username);


--
-- Name: customers customers_pkey; Type: CONSTRAINT; Schema: public; Owner: ccmall_user
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_pkey PRIMARY KEY (id);


--
-- Name: inventorys inventorys_pkey; Type: CONSTRAINT; Schema: public; Owner: ccmall_user
--

ALTER TABLE ONLY public.inventorys
    ADD CONSTRAINT inventorys_pkey PRIMARY KEY (item_id);


--
-- Name: orders orders_pkey; Type: CONSTRAINT; Schema: public; Owner: ccmall_user
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (order_id);


--
-- Name: idx_orders_order_id; Type: INDEX; Schema: public; Owner: ccmall_user
--

CREATE INDEX idx_orders_order_id ON public.orders USING btree (order_id);


--
-- Name: ix_CUSTOMERS_ID; Type: INDEX; Schema: public; Owner: ccmall_user
--

CREATE INDEX "ix_CUSTOMERS_ID" ON public."CUSTOMERS" USING btree ("ID");


--
-- Name: orders orders_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ccmall_user
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customers(id);


--
-- Name: orders orders_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ccmall_user
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.inventorys(item_id);


--
-- PostgreSQL database dump complete
--

