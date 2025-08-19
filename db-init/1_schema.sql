--
-- PostgreSQL database dump
--

-- Dumped from database version 14.18 (Ubuntu 14.18-0ubuntu0.22.04.1)
-- Dumped by pg_dump version 14.18 (Ubuntu 14.18-0ubuntu0.22.04.1)

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: cases; Type: TABLE; Schema: public; Owner: lmsuture_user
--

CREATE TABLE public.cases (
    var_name text,
    analysis_result character varying,
    case_id character varying NOT NULL,
    sanitize_result text,
    model character varying NOT NULL,
    required_sanitizer text,
    detected_sanitizer text
);


ALTER TABLE public.cases OWNER TO lmsuture_user;

--
-- Name: llm_logs; Type: TABLE; Schema: public; Owner: lmsuture_user
--

CREATE TABLE public.llm_logs (
    interaction_id integer NOT NULL,
    prompt text NOT NULL,
    response text NOT NULL,
    response_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    model text,
    round character varying,
    case_id character varying
);


ALTER TABLE public.llm_logs OWNER TO lmsuture_user;

--
-- Name: llm_logs_interaction_id_seq; Type: SEQUENCE; Schema: public; Owner: lmsuture_user
--

CREATE SEQUENCE public.llm_logs_interaction_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.llm_logs_interaction_id_seq OWNER TO lmsuture_user;

--
-- Name: llm_logs_interaction_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: lmsuture_user
--

ALTER SEQUENCE public.llm_logs_interaction_id_seq OWNED BY public.llm_logs.interaction_id;


--
-- Name: llm_logs interaction_id; Type: DEFAULT; Schema: public; Owner: lmsuture_user
--

ALTER TABLE ONLY public.llm_logs ALTER COLUMN interaction_id SET DEFAULT nextval('public.llm_logs_interaction_id_seq'::regclass);


--
-- Name: cases code_analysis_cases_pkey; Type: CONSTRAINT; Schema: public; Owner: lmsuture_user
--

ALTER TABLE ONLY public.cases
    ADD CONSTRAINT code_analysis_cases_pkey PRIMARY KEY (case_id, model);


--
-- Name: llm_logs llm_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: lmsuture_user
--

ALTER TABLE ONLY public.llm_logs
    ADD CONSTRAINT llm_logs_pkey PRIMARY KEY (interaction_id);


--
-- PostgreSQL database dump complete
--

