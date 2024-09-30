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
-- Name: fao; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA fao;


--
-- Name: health; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA health;


--
-- Name: agg_capabilities; Type: TYPE; Schema: fao; Owner: -
--

CREATE TYPE fao.agg_capabilities AS ENUM (
    'Transfer to Subscribers',
    'Transfer to Business',
    'Balance Check',
    'Delivery Notification',
    'Reporting',
    'SMPP',
    'HTTP',
    'HTTPS',
    'XML-RPC',
    'FTP',
    'GUI-Self Service',
    'Data Integrity',
    'VPN',
    'Other API Support',
    'Content Management',
    'Subscription Management',
    'Campaign Management',
    'Portal Management',
    'Recommendation Engine',
    'Advertisement Platform',
    'Analytics and Reporting',
    'URL-IP Configuration',
    'Standard Billing',
    'Zero Rated',
    'Reverse Billing',
    'Private APN Provisioning',
    'Business to Subscriber',
    'Subscriber to Business',
    'Bulk Transfer',
    'Alarm Support',
    'Consolidated Reports',
    'Automated realtime alerts',
    'Configure & Monitor Message length',
    'Threshold Monitoring',
    'Spam Control',
    'WhatsApp',
    'Facebook Messenger',
    'Media Streaming',
    'Reliability percent',
    'High Availability',
    'Redundancy',
    'Support',
    'Security Policies',
    'One Way',
    'Two Way',
    'Bulk SMS',
    'Delivery Reports',
    'Sender ID Configuration',
    'Number Masking',
    'Premium Billing',
    'Zero Rating',
    'Dedicated Short Code Provisioning',
    'Shared Short Code',
    'Long Code Provisioning',
    'SMS Spam filter',
    'Automated regulatory compliance',
    'Traffic-Capacity-Bandwidth',
    'Graphical User Interface',
    'Customized User Creation',
    'Session Reports',
    'Hosted Menu',
    'IVR Inbound',
    'IVR Outbound',
    'Leased Lines',
    'VOIP',
    'Hosted IVR Menu',
    'Short Code Provisioning'
);


--
-- Name: category_indicator_type; Type: TYPE; Schema: fao; Owner: -
--

CREATE TYPE fao.category_indicator_type AS ENUM (
    'boolean',
    'scale',
    'numeric'
);


--
-- Name: category_type; Type: TYPE; Schema: fao; Owner: -
--

CREATE TYPE fao.category_type AS ENUM (
    'DPI',
    'FUNCTIONAL'
);


--
-- Name: comment_object_type; Type: TYPE; Schema: fao; Owner: -
--

CREATE TYPE fao.comment_object_type AS ENUM (
    'PRODUCT',
    'OPEN_DATA',
    'PROJECT',
    'USE_CASE',
    'BUILDING_BLOCK',
    'PLAYBOOK',
    'ORGANIZATION',
    'OPPORTUNITY',
    'CANDIDATE_OPEN_DATA',
    'CANDIDATE_ORGANIZATION',
    'CANDIDATE_PRODUCT',
    'CANDIDATE_ROLE',
    'TAG',
    'SECTOR',
    'COUNTRY',
    'CITY',
    'CONTACT',
    'RESOURCE',
    'PLAY'
);


--
-- Name: digisquare_maturity_level; Type: TYPE; Schema: fao; Owner: -
--

CREATE TYPE fao.digisquare_maturity_level AS ENUM (
    'low',
    'medium',
    'high'
);


--
-- Name: endorser_type; Type: TYPE; Schema: fao; Owner: -
--

CREATE TYPE fao.endorser_type AS ENUM (
    'none',
    'bronze',
    'silver',
    'gold'
);


--
-- Name: entity_status_type; Type: TYPE; Schema: fao; Owner: -
--

CREATE TYPE fao.entity_status_type AS ENUM (
    'BETA',
    'MATURE',
    'SELF-REPORTED',
    'VALIDATED',
    'PUBLISHED',
    'DRAFT'
);


--
-- Name: filter_nav; Type: TYPE; Schema: fao; Owner: -
--

CREATE TYPE fao.filter_nav AS ENUM (
    'sdgs',
    'use_cases',
    'workflows',
    'building_blocks',
    'products',
    'projects',
    'locations',
    'sectors',
    'organizations'
);


--
-- Name: location_type; Type: TYPE; Schema: fao; Owner: -
--

CREATE TYPE fao.location_type AS ENUM (
    'country',
    'point'
);


--
-- Name: mapping_status_type; Type: TYPE; Schema: fao; Owner: -
--

CREATE TYPE fao.mapping_status_type AS ENUM (
    'BETA',
    'MATURE',
    'SELF-REPORTED',
    'VALIDATED'
);


--
-- Name: mobile_services; Type: TYPE; Schema: fao; Owner: -
--

CREATE TYPE fao.mobile_services AS ENUM (
    'Airtime',
    'API',
    'HS',
    'Mobile-Internet',
    'Mobile-Money',
    'Ops-Maintenance',
    'OTT',
    'SLA',
    'SMS',
    'User-Interface',
    'USSD',
    'Voice'
);


--
-- Name: opportunity_status_type; Type: TYPE; Schema: fao; Owner: -
--

CREATE TYPE fao.opportunity_status_type AS ENUM (
    'UPCOMING',
    'OPEN',
    'CLOSED'
);


--
-- Name: opportunity_type_type; Type: TYPE; Schema: fao; Owner: -
--

CREATE TYPE fao.opportunity_type_type AS ENUM (
    'BID',
    'TENDER',
    'INNOVATION',
    'BUILDING BLOCK',
    'OTHER'
);


--
-- Name: org_type; Type: TYPE; Schema: fao; Owner: -
--

CREATE TYPE fao.org_type AS ENUM (
    'owner',
    'maintainer',
    'funder',
    'implementer'
);


--
-- Name: org_type_orig; Type: TYPE; Schema: fao; Owner: -
--

CREATE TYPE fao.org_type_orig AS ENUM (
    'owner',
    'maintainer'
);


--
-- Name: org_type_save; Type: TYPE; Schema: fao; Owner: -
--

CREATE TYPE fao.org_type_save AS ENUM (
    'owner',
    'maintainer',
    'funder'
);


--
-- Name: product_type; Type: TYPE; Schema: fao; Owner: -
--

CREATE TYPE fao.product_type AS ENUM (
    'product',
    'dataset',
    'content'
);


--
-- Name: product_type_save; Type: TYPE; Schema: fao; Owner: -
--

CREATE TYPE fao.product_type_save AS ENUM (
    'product',
    'dataset'
);


--
-- Name: relationship_type; Type: TYPE; Schema: fao; Owner: -
--

CREATE TYPE fao.relationship_type AS ENUM (
    'composed',
    'interoperates'
);


--
-- Name: top_nav; Type: TYPE; Schema: fao; Owner: -
--

CREATE TYPE fao.top_nav AS ENUM (
    'sdgs',
    'use_cases',
    'workflows',
    'building_blocks',
    'products',
    'projects',
    'organizations'
);


--
-- Name: user_role; Type: TYPE; Schema: fao; Owner: -
--

CREATE TYPE fao.user_role AS ENUM (
    'admin',
    'ict4sdg',
    'principle',
    'user',
    'org_user',
    'org_product_user',
    'product_user',
    'mni',
    'content_writer',
    'content_editor',
    'dataset_user',
    'adli_admin',
    'adli_user'
);


--
-- Name: agg_capabilities; Type: TYPE; Schema: health; Owner: -
--

CREATE TYPE health.agg_capabilities AS ENUM (
    'Transfer to Subscribers',
    'Transfer to Business',
    'Balance Check',
    'Delivery Notification',
    'Reporting',
    'SMPP',
    'HTTP',
    'HTTPS',
    'XML-RPC',
    'FTP',
    'GUI-Self Service',
    'Data Integrity',
    'VPN',
    'Other API Support',
    'Content Management',
    'Subscription Management',
    'Campaign Management',
    'Portal Management',
    'Recommendation Engine',
    'Advertisement Platform',
    'Analytics and Reporting',
    'URL-IP Configuration',
    'Standard Billing',
    'Zero Rated',
    'Reverse Billing',
    'Private APN Provisioning',
    'Business to Subscriber',
    'Subscriber to Business',
    'Bulk Transfer',
    'Alarm Support',
    'Consolidated Reports',
    'Automated realtime alerts',
    'Configure & Monitor Message length',
    'Threshold Monitoring',
    'Spam Control',
    'WhatsApp',
    'Facebook Messenger',
    'Media Streaming',
    'Reliability percent',
    'High Availability',
    'Redundancy',
    'Support',
    'Security Policies',
    'One Way',
    'Two Way',
    'Bulk SMS',
    'Delivery Reports',
    'Sender ID Configuration',
    'Number Masking',
    'Premium Billing',
    'Zero Rating',
    'Dedicated Short Code Provisioning',
    'Shared Short Code',
    'Long Code Provisioning',
    'SMS Spam filter',
    'Automated regulatory compliance',
    'Traffic-Capacity-Bandwidth',
    'Graphical User Interface',
    'Customized User Creation',
    'Session Reports',
    'Hosted Menu',
    'IVR Inbound',
    'IVR Outbound',
    'Leased Lines',
    'VOIP',
    'Hosted IVR Menu',
    'Short Code Provisioning'
);


--
-- Name: category_indicator_type; Type: TYPE; Schema: health; Owner: -
--

CREATE TYPE health.category_indicator_type AS ENUM (
    'boolean',
    'scale',
    'numeric'
);


--
-- Name: category_type; Type: TYPE; Schema: health; Owner: -
--

CREATE TYPE health.category_type AS ENUM (
    'DPI',
    'FUNCTIONAL'
);


--
-- Name: comment_object_type; Type: TYPE; Schema: health; Owner: -
--

CREATE TYPE health.comment_object_type AS ENUM (
    'PRODUCT',
    'OPEN_DATA',
    'PROJECT',
    'USE_CASE',
    'BUILDING_BLOCK',
    'PLAYBOOK',
    'ORGANIZATION',
    'OPPORTUNITY',
    'CANDIDATE_OPEN_DATA',
    'CANDIDATE_ORGANIZATION',
    'CANDIDATE_PRODUCT',
    'CANDIDATE_ROLE',
    'TAG',
    'SECTOR',
    'COUNTRY',
    'CITY',
    'CONTACT',
    'RESOURCE',
    'PLAY'
);


--
-- Name: digisquare_maturity_level; Type: TYPE; Schema: health; Owner: -
--

CREATE TYPE health.digisquare_maturity_level AS ENUM (
    'low',
    'medium',
    'high'
);


--
-- Name: endorser_type; Type: TYPE; Schema: health; Owner: -
--

CREATE TYPE health.endorser_type AS ENUM (
    'none',
    'bronze',
    'silver',
    'gold'
);


--
-- Name: entity_status_type; Type: TYPE; Schema: health; Owner: -
--

CREATE TYPE health.entity_status_type AS ENUM (
    'BETA',
    'MATURE',
    'SELF-REPORTED',
    'VALIDATED',
    'PUBLISHED',
    'DRAFT'
);


--
-- Name: filter_nav; Type: TYPE; Schema: health; Owner: -
--

CREATE TYPE health.filter_nav AS ENUM (
    'sdgs',
    'use_cases',
    'workflows',
    'building_blocks',
    'products',
    'projects',
    'locations',
    'sectors',
    'organizations'
);


--
-- Name: location_type; Type: TYPE; Schema: health; Owner: -
--

CREATE TYPE health.location_type AS ENUM (
    'country',
    'point'
);


--
-- Name: mapping_status_type; Type: TYPE; Schema: health; Owner: -
--

CREATE TYPE health.mapping_status_type AS ENUM (
    'BETA',
    'MATURE',
    'SELF-REPORTED',
    'VALIDATED'
);


--
-- Name: mobile_services; Type: TYPE; Schema: health; Owner: -
--

CREATE TYPE health.mobile_services AS ENUM (
    'Airtime',
    'API',
    'HS',
    'Mobile-Internet',
    'Mobile-Money',
    'Ops-Maintenance',
    'OTT',
    'SLA',
    'SMS',
    'User-Interface',
    'USSD',
    'Voice'
);


--
-- Name: opportunity_status_type; Type: TYPE; Schema: health; Owner: -
--

CREATE TYPE health.opportunity_status_type AS ENUM (
    'UPCOMING',
    'OPEN',
    'CLOSED'
);


--
-- Name: opportunity_type_type; Type: TYPE; Schema: health; Owner: -
--

CREATE TYPE health.opportunity_type_type AS ENUM (
    'BID',
    'TENDER',
    'INNOVATION',
    'BUILDING BLOCK',
    'OTHER'
);


--
-- Name: org_type; Type: TYPE; Schema: health; Owner: -
--

CREATE TYPE health.org_type AS ENUM (
    'owner',
    'maintainer',
    'funder',
    'implementer'
);


--
-- Name: org_type_orig; Type: TYPE; Schema: health; Owner: -
--

CREATE TYPE health.org_type_orig AS ENUM (
    'owner',
    'maintainer'
);


--
-- Name: org_type_save; Type: TYPE; Schema: health; Owner: -
--

CREATE TYPE health.org_type_save AS ENUM (
    'owner',
    'maintainer',
    'funder'
);


--
-- Name: product_type; Type: TYPE; Schema: health; Owner: -
--

CREATE TYPE health.product_type AS ENUM (
    'product',
    'dataset',
    'content'
);


--
-- Name: product_type_save; Type: TYPE; Schema: health; Owner: -
--

CREATE TYPE health.product_type_save AS ENUM (
    'product',
    'dataset'
);


--
-- Name: relationship_type; Type: TYPE; Schema: health; Owner: -
--

CREATE TYPE health.relationship_type AS ENUM (
    'composed',
    'interoperates'
);


--
-- Name: top_nav; Type: TYPE; Schema: health; Owner: -
--

CREATE TYPE health.top_nav AS ENUM (
    'sdgs',
    'use_cases',
    'workflows',
    'building_blocks',
    'products',
    'projects',
    'organizations'
);


--
-- Name: user_role; Type: TYPE; Schema: health; Owner: -
--

CREATE TYPE health.user_role AS ENUM (
    'admin',
    'ict4sdg',
    'principle',
    'user',
    'org_user',
    'org_product_user',
    'product_user',
    'mni',
    'content_writer',
    'content_editor',
    'dataset_user',
    'adli_admin',
    'adli_user'
);


--
-- Name: agg_capabilities; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.agg_capabilities AS ENUM (
    'Transfer to Subscribers',
    'Transfer to Business',
    'Balance Check',
    'Delivery Notification',
    'Reporting',
    'SMPP',
    'HTTP',
    'HTTPS',
    'XML-RPC',
    'FTP',
    'GUI-Self Service',
    'Data Integrity',
    'VPN',
    'Other API Support',
    'Content Management',
    'Subscription Management',
    'Campaign Management',
    'Portal Management',
    'Recommendation Engine',
    'Advertisement Platform',
    'Analytics and Reporting',
    'URL-IP Configuration',
    'Standard Billing',
    'Zero Rated',
    'Reverse Billing',
    'Private APN Provisioning',
    'Business to Subscriber',
    'Subscriber to Business',
    'Bulk Transfer',
    'Alarm Support',
    'Consolidated Reports',
    'Automated realtime alerts',
    'Configure & Monitor Message length',
    'Threshold Monitoring',
    'Spam Control',
    'WhatsApp',
    'Facebook Messenger',
    'Media Streaming',
    'Reliability percent',
    'High Availability',
    'Redundancy',
    'Support',
    'Security Policies',
    'One Way',
    'Two Way',
    'Bulk SMS',
    'Delivery Reports',
    'Sender ID Configuration',
    'Number Masking',
    'Premium Billing',
    'Zero Rating',
    'Dedicated Short Code Provisioning',
    'Shared Short Code',
    'Long Code Provisioning',
    'SMS Spam filter',
    'Automated regulatory compliance',
    'Traffic-Capacity-Bandwidth',
    'Graphical User Interface',
    'Customized User Creation',
    'Session Reports',
    'Hosted Menu',
    'IVR Inbound',
    'IVR Outbound',
    'Leased Lines',
    'VOIP',
    'Hosted IVR Menu',
    'Short Code Provisioning'
);


--
-- Name: category_indicator_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.category_indicator_type AS ENUM (
    'boolean',
    'scale',
    'numeric'
);


--
-- Name: category_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.category_type AS ENUM (
    'DPI',
    'FUNCTIONAL'
);


--
-- Name: comment_object_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.comment_object_type AS ENUM (
    'PRODUCT',
    'OPEN_DATA',
    'PROJECT',
    'USE_CASE',
    'BUILDING_BLOCK',
    'PLAYBOOK',
    'ORGANIZATION',
    'OPPORTUNITY',
    'CANDIDATE_OPEN_DATA',
    'CANDIDATE_ORGANIZATION',
    'CANDIDATE_PRODUCT',
    'CANDIDATE_ROLE',
    'TAG',
    'SECTOR',
    'COUNTRY',
    'CITY',
    'CONTACT',
    'RESOURCE',
    'PLAY'
);


--
-- Name: digisquare_maturity_level; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.digisquare_maturity_level AS ENUM (
    'low',
    'medium',
    'high'
);


--
-- Name: endorser_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.endorser_type AS ENUM (
    'none',
    'bronze',
    'silver',
    'gold'
);


--
-- Name: entity_status_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.entity_status_type AS ENUM (
    'BETA',
    'MATURE',
    'SELF-REPORTED',
    'VALIDATED',
    'PUBLISHED',
    'DRAFT'
);


--
-- Name: filter_nav; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.filter_nav AS ENUM (
    'sdgs',
    'use_cases',
    'workflows',
    'building_blocks',
    'products',
    'projects',
    'locations',
    'sectors',
    'organizations'
);


--
-- Name: location_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.location_type AS ENUM (
    'country',
    'point'
);


--
-- Name: mapping_status_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.mapping_status_type AS ENUM (
    'BETA',
    'MATURE',
    'SELF-REPORTED',
    'VALIDATED'
);


--
-- Name: mobile_services; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.mobile_services AS ENUM (
    'Airtime',
    'API',
    'HS',
    'Mobile-Internet',
    'Mobile-Money',
    'Ops-Maintenance',
    'OTT',
    'SLA',
    'SMS',
    'User-Interface',
    'USSD',
    'Voice'
);


--
-- Name: opportunity_status_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.opportunity_status_type AS ENUM (
    'UPCOMING',
    'OPEN',
    'CLOSED'
);


--
-- Name: opportunity_type_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.opportunity_type_type AS ENUM (
    'BID',
    'TENDER',
    'INNOVATION',
    'BUILDING BLOCK',
    'OTHER'
);


--
-- Name: org_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.org_type AS ENUM (
    'owner',
    'maintainer',
    'funder',
    'implementer'
);


--
-- Name: org_type_orig; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.org_type_orig AS ENUM (
    'owner',
    'maintainer'
);


--
-- Name: org_type_save; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.org_type_save AS ENUM (
    'owner',
    'maintainer',
    'funder'
);


--
-- Name: product_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.product_type AS ENUM (
    'product',
    'dataset',
    'content'
);


--
-- Name: product_type_save; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.product_type_save AS ENUM (
    'product',
    'dataset'
);


--
-- Name: relationship_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.relationship_type AS ENUM (
    'composed',
    'interoperates'
);


--
-- Name: top_nav; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.top_nav AS ENUM (
    'sdgs',
    'use_cases',
    'workflows',
    'building_blocks',
    'products',
    'projects',
    'organizations'
);


--
-- Name: user_role; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.user_role AS ENUM (
    'admin',
    'ict4sdg',
    'principle',
    'user',
    'org_user',
    'org_product_user',
    'product_user',
    'mni',
    'content_writer',
    'content_editor',
    'dataset_user',
    'adli_admin',
    'adli_user'
);


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: aggregator_capabilities; Type: TABLE; Schema: fao; Owner: -
--

CREATE TABLE fao.aggregator_capabilities (
    id bigint NOT NULL,
    aggregator_id bigint,
    operator_services_id bigint,
    service fao.mobile_services,
    capability fao.agg_capabilities,
    country_name character varying,
    country_id bigint
);


--
-- Name: aggregator_capabilities_id_seq; Type: SEQUENCE; Schema: fao; Owner: -
--

CREATE SEQUENCE fao.aggregator_capabilities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: aggregator_capabilities_id_seq; Type: SEQUENCE OWNED BY; Schema: fao; Owner: -
--

ALTER SEQUENCE fao.aggregator_capabilities_id_seq OWNED BY fao.aggregator_capabilities.id;


--
-- Name: ar_internal_metadata; Type: TABLE; Schema: fao; Owner: -
--

CREATE TABLE fao.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: audits; Type: TABLE; Schema: fao; Owner: -
--

CREATE TABLE fao.audits (
    id bigint NOT NULL,
    associated_id character varying,
    associated_type character varying,
    user_id integer,
    user_role character varying,
    username character varying,
    action character varying,
    audit_changes jsonb,
    version integer DEFAULT 0,
    comment character varying,
    created_at timestamp without time zone
);


--
-- Name: audits_id_seq; Type: SEQUENCE; Schema: fao; Owner: -
--

CREATE SEQUENCE fao.audits_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: audits_id_seq; Type: SEQUENCE OWNED BY; Schema: fao; Owner: -
--

ALTER SEQUENCE fao.audits_id_seq OWNED BY fao.audits.id;


--
-- Name: authors; Type: TABLE; Schema: fao; Owner: -
--

CREATE TABLE fao.authors (
    id bigint NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    email character varying,
    picture character varying NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: authors_id_seq; Type: SEQUENCE; Schema: fao; Owner: -
--

CREATE SEQUENCE fao.authors_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: authors_id_seq; Type: SEQUENCE OWNED BY; Schema: fao; Owner: -
--

ALTER SEQUENCE fao.authors_id_seq OWNED BY fao.authors.id;


--
-- Name: building_block_descriptions; Type: TABLE; Schema: fao; Owner: -
--

CREATE TABLE fao.building_block_descriptions (
    id bigint NOT NULL,
    building_block_id bigint NOT NULL,
    locale character varying NOT NULL,
    description character varying DEFAULT ''::character varying NOT NULL
);


--
-- Name: building_block_descriptions_id_seq; Type: SEQUENCE; Schema: fao; Owner: -
--

CREATE SEQUENCE fao.building_block_descriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: building_block_descriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: fao; Owner: -
--

ALTER SEQUENCE fao.building_block_descriptions_id_seq OWNED BY fao.building_block_descriptions.id;


--
-- Name: building_blocks; Type: TABLE; Schema: fao; Owner: -
--

CREATE TABLE fao.building_blocks (
    id bigint NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    description jsonb DEFAULT '{}'::jsonb NOT NULL,
    maturity fao.entity_status_type DEFAULT 'DRAFT'::fao.entity_status_type NOT NULL,
    spec_url character varying,
    category fao.category_type,
    display_order integer DEFAULT 0 NOT NULL,
    gov_stack_entity boolean DEFAULT false NOT NULL
);


--
-- Name: building_blocks_id_seq; Type: SEQUENCE; Schema: fao; Owner: -
--

CREATE SEQUENCE fao.building_blocks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: building_blocks_id_seq; Type: SEQUENCE OWNED BY; Schema: fao; Owner: -
--

ALTER SEQUENCE fao.building_blocks_id_seq OWNED BY fao.building_blocks.id;


--
-- Name: candidate_datasets; Type: TABLE; Schema: fao; Owner: -
--

CREATE TABLE fao.candidate_datasets (
    id bigint NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    website character varying NOT NULL,
    visualization_url character varying,
    dataset_type character varying NOT NULL,
    submitter_email character varying NOT NULL,
    description character varying NOT NULL,
    rejected boolean,
    rejected_date timestamp without time zone,
    rejected_by_id bigint,
    approved_date timestamp without time zone,
    approved_by_id bigint,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: candidate_datasets_id_seq; Type: SEQUENCE; Schema: fao; Owner: -
--

CREATE SEQUENCE fao.candidate_datasets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: candidate_datasets_id_seq; Type: SEQUENCE OWNED BY; Schema: fao; Owner: -
--

ALTER SEQUENCE fao.candidate_datasets_id_seq OWNED BY fao.candidate_datasets.id;


--
-- Name: candidate_organizations; Type: TABLE; Schema: fao; Owner: -
--

CREATE TABLE fao.candidate_organizations (
    id bigint NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    website text,
    rejected boolean,
    rejected_date timestamp without time zone,
    rejected_by_id bigint,
    approved_date timestamp without time zone,
    approved_by_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    description character varying,
    create_storefront boolean DEFAULT false NOT NULL
);


--
-- Name: candidate_organizations_contacts; Type: TABLE; Schema: fao; Owner: -
--

CREATE TABLE fao.candidate_organizations_contacts (
    candidate_organization_id bigint NOT NULL,
    contact_id bigint NOT NULL,
    started_at timestamp without time zone,
    ended_at timestamp without time zone
);


--
-- Name: candidate_organizations_id_seq; Type: SEQUENCE; Schema: fao; Owner: -
--

CREATE SEQUENCE fao.candidate_organizations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: candidate_organizations_id_seq; Type: SEQUENCE OWNED BY; Schema: fao; Owner: -
--

ALTER SEQUENCE fao.candidate_organizations_id_seq OWNED BY fao.candidate_organizations.id;


--
-- Name: candidate_products; Type: TABLE; Schema: fao; Owner: -
--

CREATE TABLE fao.candidate_products (
    id bigint NOT NULL,
    slug character varying NOT NULL,
    name character varying NOT NULL,
    website character varying NOT NULL,
    repository character varying NOT NULL,
    submitter_email character varying NOT NULL,
    rejected boolean,
    rejected_date timestamp without time zone,
    rejected_by_id bigint,
    approved_date timestamp without time zone,
    approved_by_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    description character varying,
    commercial_product boolean DEFAULT false NOT NULL
);


--
-- Name: candidate_products_id_seq; Type: SEQUENCE; Schema: fao; Owner: -
--

CREATE SEQUENCE fao.candidate_products_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: candidate_products_id_seq; Type: SEQUENCE OWNED BY; Schema: fao; Owner: -
--

ALTER SEQUENCE fao.candidate_products_id_seq OWNED BY fao.candidate_products.id;


--
-- Name: candidate_resources; Type: TABLE; Schema: fao; Owner: -
--

CREATE TABLE fao.candidate_resources (
    id bigint NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    description character varying NOT NULL,
    published_date timestamp(6) without time zone DEFAULT '2024-08-27 00:00:00'::timestamp without time zone NOT NULL,
    resource_type character varying NOT NULL,
    resource_link character varying NOT NULL,
    link_description character varying NOT NULL,
    submitter_email character varying NOT NULL,
    rejected boolean,
    rejected_date timestamp(6) without time zone,
    rejected_by_id bigint,
    approved_date timestamp(6) without time zone,
    approved_by_id bigint,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: candidate_resources_countries; Type: TABLE; Schema: fao; Owner: -
--

CREATE TABLE fao.candidate_resources_countries (
    id bigint NOT NULL,
    candidate_resource_id bigint NOT NULL,
    country_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: candidate_resources_countries_id_seq; Type: SEQUENCE; Schema: fao; Owner: -
--

CREATE SEQUENCE fao.candidate_resources_countries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: candidate_resources_countries_id_seq; Type: SEQUENCE OWNED BY; Schema: fao; Owner: -
--

ALTER SEQUENCE fao.candidate_resources_countries_id_seq OWNED BY fao.candidate_resources_countries.id;


--
-- Name: candidate_resources_id_seq; Type: SEQUENCE; Schema: fao; Owner: -
--

CREATE SEQUENCE fao.candidate_resources_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: candidate_resources_id_seq; Type: SEQUENCE OWNED BY; Schema: fao; Owner: -
--

ALTER SEQUENCE fao.candidate_resources_id_seq OWNED BY fao.candidate_resources.id;


--
-- Name: candidate_roles; Type: TABLE; Schema: fao; Owner: -
--

CREATE TABLE fao.candidate_roles (
    id bigint NOT NULL,
    email character varying NOT NULL,
    roles fao.user_role[] DEFAULT '{}'::fao.user_role[],
    description character varying NOT NULL,
    rejected boolean,
    rejected_date timestamp without time zone,
    rejected_by_id bigint,
    approved_date timestamp without time zone,
    approved_by_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    product_id integer,
    organization_id integer,
    dataset_id bigint
);


--
-- Name: candidate_roles_id_seq; Type: SEQUENCE; Schema: fao; Owner: -
--

CREATE SEQUENCE fao.candidate_roles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: candidate_roles_id_seq; Type: SEQUENCE OWNED BY; Schema: fao; Owner: -
--

ALTER SEQUENCE fao.candidate_roles_id_seq OWNED BY fao.candidate_roles.id;


--
-- Name: category_indicator_descriptions; Type: TABLE; Schema: fao; Owner: -
--

CREATE TABLE fao.category_indicator_descriptions (
    id bigint NOT NULL,
    category_indicator_id bigint NOT NULL,
    locale character varying NOT NULL,
    description character varying DEFAULT ''::character varying NOT NULL
);


--
-- Name: category_indicator_descriptions_id_seq; Type: SEQUENCE; Schema: fao; Owner: -
--

CREATE SEQUENCE fao.category_indicator_descriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: category_indicator_descriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: fao; Owner: -
--

ALTER SEQUENCE fao.category_indicator_descriptions_id_seq OWNED BY fao.category_indicator_descriptions.id;


--
-- Name: category_indicators; Type: TABLE; Schema: fao; Owner: -
--

CREATE TABLE fao.category_indicators (
    id bigint NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    indicator_type fao.category_indicator_type,
    weight numeric DEFAULT 0 NOT NULL,
    rubric_category_id bigint,
    data_source character varying,
    source_indicator character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    script_name character varying
);


--
-- Name: category_indicators_id_seq; Type: SEQUENCE; Schema: fao; Owner: -
--

CREATE SEQUENCE fao.category_indicators_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: category_indicators_id_seq; Type: SEQUENCE OWNED BY; Schema: fao; Owner: -
--

ALTER SEQUENCE fao.category_indicators_id_seq OWNED BY fao.category_indicators.id;


--
-- Name: chatbot_conversations; Type: TABLE; Schema: fao; Owner: -
--

CREATE TABLE fao.chatbot_conversations (
    id bigint NOT NULL,
    identifier character varying NOT NULL,
    session_identifier character varying NOT NULL,
    chatbot_question character varying NOT NULL,
    chatbot_answer character varying NOT NULL,
    user_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    chatbot_response jsonb DEFAULT '{}'::jsonb
);


--
-- Name: chatbot_conversations_id_seq; Type: SEQUENCE; Schema: fao; Owner: -
--

CREATE SEQUENCE fao.chatbot_conversations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: chatbot_conversations_id_seq; Type: SEQUENCE OWNED BY; Schema: fao; Owner: -
--

ALTER SEQUENCE fao.chatbot_conversations_id_seq OWNED BY fao.chatbot_conversations.id;


--
-- Name: cities; Type: TABLE; Schema: fao; Owner: -
--

CREATE TABLE fao.cities (
    id bigint NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    province_id bigint,
    latitude numeric NOT NULL,
    longitude numeric NOT NULL,
    aliases character varying[] DEFAULT '{}'::character varying[],
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: cities_id_seq; Type: SEQUENCE; Schema: fao; Owner: -
--

CREATE SEQUENCE fao.cities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cities_id_seq; Type: SEQUENCE OWNED BY; Schema: fao; Owner: -
--

ALTER SEQUENCE fao.cities_id_seq OWNED BY fao.cities.id;


--
-- Name: ckeditor_assets; Type: TABLE; Schema: fao; Owner: -
--

CREATE TABLE fao.ckeditor_assets (
    id bigint NOT NULL,
    data_file_name character varying NOT NULL,
    data_content_type character varying,
    data_file_size integer,
    type character varying(30),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: ckeditor_assets_id_seq; Type: SEQUENCE; Schema: fao; Owner: -
--

CREATE SEQUENCE fao.ckeditor_assets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ckeditor_assets_id_seq; Type: SEQUENCE OWNED BY; Schema: fao; Owner: -
--

ALTER SEQUENCE fao.ckeditor_assets_id_seq OWNED BY fao.ckeditor_assets.id;


--
-- Name: classifications; Type: TABLE; Schema: fao; Owner: -
--

CREATE TABLE fao.classifications (
    id bigint NOT NULL,
    name character varying,
    indicator character varying,
    description character varying,
    source character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: classifications_id_seq; Type: SEQUENCE; Schema: fao; Owner: -
--

CREATE SEQUENCE fao.classifications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: classifications_id_seq; Type: SEQUENCE OWNED BY; Schema: fao; Owner: -
--

ALTER SEQUENCE fao.classifications_id_seq OWNED BY fao.classifications.id;


--
-- Name: comments; Type: TABLE; Schema: fao; Owner: -
--

CREATE TABLE fao.comments (
    id bigint NOT NULL,
    comment_object_id integer NOT NULL,
    author jsonb NOT NULL,
    text character varying NOT NULL,
    comment_id character varying NOT NULL,
    parent_comment_id character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    comment_object_type fao.comment_object_type NOT NULL
);


--
-- Name: comments_id_seq; Type: SEQUENCE; Schema: fao; Owner: -
--

CREATE SEQUENCE fao.comments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: comments_id_seq; Type: SEQUENCE OWNED BY; Schema: fao; Owner: -
--

ALTER SEQUENCE fao.comments_id_seq OWNED BY fao.comments.id;


--
-- Name: contacts; Type: TABLE; Schema: fao; Owner: -
--

CREATE TABLE fao.contacts (
    id bigint NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    email character varying,
    title character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    biography text,
    social_networking_services jsonb DEFAULT '[]'::jsonb,
    source character varying DEFAULT 'exchange'::character varying,
    extended_data jsonb DEFAULT '[]'::jsonb
);


--
-- Name: contacts_id_seq; Type: SEQUENCE; Schema: fao; Owner: -
--

CREATE SEQUENCE fao.contacts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: contacts_id_seq; Type: SEQUENCE OWNED BY; Schema: fao; Owner: -
--

ALTER SEQUENCE fao.contacts_id_seq OWNED BY fao.contacts.id;


--
-- Name: countries; Type: TABLE; Schema: fao; Owner: -
--

CREATE TABLE fao.countries (
    id bigint NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    code character varying NOT NULL,
    code_longer character varying NOT NULL,
    latitude numeric NOT NULL,
    longitude numeric NOT NULL,
    aliases character varying[] DEFAULT '{}'::character varying[],
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    description character varying
);


--
-- Name: countries_id_seq; Type: SEQUENCE; Schema: fao; Owner: -
--

CREATE SEQUENCE fao.countries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: countries_id_seq; Type: SEQUENCE OWNED BY; Schema: fao; Owner: -
--

ALTER SEQUENCE fao.countries_id_seq OWNED BY fao.countries.id;


--
-- Name: dataset_descriptions; Type: TABLE; Schema: fao; Owner: -
--

CREATE TABLE fao.dataset_descriptions (
    id bigint NOT NULL,
    dataset_id bigint,
    locale character varying NOT NULL,
    description character varying DEFAULT ''::character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: dataset_descriptions_id_seq; Type: SEQUENCE; Schema: fao; Owner: -
--

CREATE SEQUENCE fao.dataset_descriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: dataset_descriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: fao; Owner: -
--

ALTER SEQUENCE fao.dataset_descriptions_id_seq OWNED BY fao.dataset_descriptions.id;


--
-- Name: dataset_sectors; Type: TABLE; Schema: fao; Owner: -
--

CREATE TABLE fao.dataset_sectors (
    id bigint NOT NULL,
    dataset_id bigint NOT NULL,
    sector_id bigint NOT NULL,
    mapping_status fao.mapping_status_type DEFAULT 'BETA'::fao.mapping_status_type NOT NULL,
    slug character varying NOT NULL
);


--
-- Name: dataset_sectors_id_seq; Type: SEQUENCE; Schema: fao; Owner: -
--

CREATE SEQUENCE fao.dataset_sectors_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: dataset_sectors_id_seq; Type: SEQUENCE OWNED BY; Schema: fao; Owner: -
--

ALTER SEQUENCE fao.dataset_sectors_id_seq OWNED BY fao.dataset_sectors.id;


--
-- Name: dataset_sustainable_development_goals; Type: TABLE; Schema: fao; Owner: -
--

CREATE TABLE fao.dataset_sustainable_development_goals (
    id bigint NOT NULL,
    dataset_id bigint NOT NULL,
    sustainable_development_goal_id bigint NOT NULL,
    mapping_status fao.mapping_status_type DEFAULT 'BETA'::fao.mapping_status_type NOT NULL,
    slug character varying NOT NULL
);


--
-- Name: dataset_sustainable_development_goals_id_seq; Type: SEQUENCE; Schema: fao; Owner: -
--

CREATE SEQUENCE fao.dataset_sustainable_development_goals_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: dataset_sustainable_development_goals_id_seq; Type: SEQUENCE OWNED BY; Schema: fao; Owner: -
--

ALTER SEQUENCE fao.dataset_sustainable_development_goals_id_seq OWNED BY fao.dataset_sustainable_development_goals.id;


--
-- Name: datasets; Type: TABLE; Schema: fao; Owner: -
--

CREATE TABLE fao.datasets (
    id bigint NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    aliases character varying[] DEFAULT '{}'::character varying[],
    website character varying NOT NULL,
    visualization_url character varying,
    tags character varying[] DEFAULT '{}'::character varying[],
    dataset_type character varying NOT NULL,
    geographic_coverage character varying,
    time_range character varying,
    manual_update boolean DEFAULT false,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    license character varying,
    languages character varying,
    data_format character varying
);


--
-- Name: datasets_countries; Type: TABLE; Schema: fao; Owner: -
--

CREATE TABLE fao.datasets_countries (
    id bigint NOT NULL,
    dataset_id bigint NOT NULL,
    country_id bigint NOT NULL
);


--
-- Name: datasets_countries_id_seq; Type: SEQUENCE; Schema: fao; Owner: -
--

CREATE SEQUENCE fao.datasets_countries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: datasets_countries_id_seq; Type: SEQUENCE OWNED BY; Schema: fao; Owner: -
--

ALTER SEQUENCE fao.datasets_countries_id_seq OWNED BY fao.datasets_countries.id;


--
-- Name: datasets_id_seq; Type: SEQUENCE; Schema: fao; Owner: -
--

CREATE SEQUENCE fao.datasets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: datasets_id_seq; Type: SEQUENCE OWNED BY; Schema: fao; Owner: -
--

ALTER SEQUENCE fao.datasets_id_seq OWNED BY fao.datasets.id;


--
-- Name: datasets_origins; Type: TABLE; Schema: fao; Owner: -
--

CREATE TABLE fao.datasets_origins (
    id bigint NOT NULL,
    dataset_id bigint NOT NULL,
    origin_id bigint NOT NULL
);


--
-- Name: datasets_origins_id_seq; Type: SEQUENCE; Schema: fao; Owner: -
--

CREATE SEQUENCE fao.datasets_origins_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: datasets_origins_id_seq; Type: SEQUENCE OWNED BY; Schema: fao; Owner: -
--

ALTER SEQUENCE fao.datasets_origins_id_seq OWNED BY fao.datasets_origins.id;


--
-- Name: deploys; Type: TABLE; Schema: fao; Owner: -
--

CREATE TABLE fao.deploys (
    id bigint NOT NULL,
    user_id bigint,
    product_id bigint,
    provider character varying,
    instance_name character varying,
    auth_token character varying,
    status character varying,
    message character varying,
    url character varying,
    suite character varying,
    job_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: deploys_id_seq; Type: SEQUENCE; Schema: fao; Owner: -
--

CREATE SEQUENCE fao.deploys_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: deploys_id_seq; Type: SEQUENCE OWNED BY; Schema: fao; Owner: -
--

ALTER SEQUENCE fao.deploys_id_seq OWNED BY fao.deploys.id;


--
-- Name: dial_spreadsheet_data; Type: TABLE; Schema: fao; Owner: -
--

CREATE TABLE fao.dial_spreadsheet_data (
    id bigint NOT NULL,
    slug character varying NOT NULL,
    spreadsheet_type character varying NOT NULL,
    spreadsheet_data jsonb DEFAULT '{}'::jsonb NOT NULL,
    deleted boolean DEFAULT false NOT NULL,
    updated_by bigint,
    updated_date timestamp without time zone
);


--
-- Name: dial_spreadsheet_data_id_seq; Type: SEQUENCE; Schema: fao; Owner: -
--

CREATE SEQUENCE fao.dial_spreadsheet_data_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: dial_spreadsheet_data_id_seq; Type: SEQUENCE OWNED BY; Schema: fao; Owner: -
--

ALTER SEQUENCE fao.dial_spreadsheet_data_id_seq OWNED BY fao.dial_spreadsheet_data.id;


--
-- Name: digital_principles; Type: TABLE; Schema: fao; Owner: -
--

CREATE TABLE fao.digital_principles (
    id bigint NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    url character varying NOT NULL,
    phase character varying
);


--
-- Name: digital_principles_id_seq; Type: SEQUENCE; Schema: fao; Owner: -
--

CREATE SEQUENCE fao.digital_principles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: digital_principles_id_seq; Type: SEQUENCE OWNED BY; Schema: fao; Owner: -
--

ALTER SEQUENCE fao.digital_principles_id_seq OWNED BY fao.digital_principles.id;


--
-- Name: districts; Type: TABLE; Schema: fao; Owner: -
--

CREATE TABLE fao.districts (
    id bigint NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    province_id bigint NOT NULL,
    latitude numeric NOT NULL,
    longitude numeric NOT NULL,
    aliases character varying[] DEFAULT '{}'::character varying[],
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: districts_id_seq; Type: SEQUENCE; Schema: fao; Owner: -
--

CREATE SEQUENCE fao.districts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: districts_id_seq; Type: SEQUENCE OWNED BY; Schema: fao; Owner: -
--

ALTER SEQUENCE fao.districts_id_seq OWNED BY fao.districts.id;


--
-- Name: endorsers; Type: TABLE; Schema: fao; Owner: -
--

CREATE TABLE fao.endorsers (
    id bigint NOT NULL,
    slug character varying NOT NULL,
    name character varying NOT NULL,
    description character varying
);


--
-- Name: endorsers_id_seq; Type: SEQUENCE; Schema: fao; Owner: -
--

CREATE SEQUENCE fao.endorsers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: endorsers_id_seq; Type: SEQUENCE OWNED BY; Schema: fao; Owner: -
--

ALTER SEQUENCE fao.endorsers_id_seq OWNED BY fao.endorsers.id;


--
-- Name: exchange_tenants; Type: TABLE; Schema: fao; Owner: -
--

CREATE TABLE fao.exchange_tenants (
    id bigint NOT NULL,
    tenant_name character varying,
    domain character varying,
    postgres_config jsonb,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    allow_unsecure_read boolean DEFAULT true NOT NULL
);


--
-- Name: exchange_tenants_id_seq; Type: SEQUENCE; Schema: fao; Owner: -
--

CREATE SEQUENCE fao.exchange_tenants_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: exchange_tenants_id_seq; Type: SEQUENCE OWNED BY; Schema: fao; Owner: -
--

ALTER SEQUENCE fao.exchange_tenants_id_seq OWNED BY fao.exchange_tenants.id;


--
-- Name: froala_images; Type: TABLE; Schema: fao; Owner: -
--

CREATE TABLE fao.froala_images (
    id bigint NOT NULL,
    picture character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: froala_images_id_seq; Type: SEQUENCE; Schema: fao; Owner: -
--

CREATE SEQUENCE fao.froala_images_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: froala_images_id_seq; Type: SEQUENCE OWNED BY; Schema: fao; Owner: -
--

ALTER SEQUENCE fao.froala_images_id_seq OWNED BY fao.froala_images.id;


--
-- Name: glossaries; Type: TABLE; Schema: fao; Owner: -
--

CREATE TABLE fao.glossaries (
    id bigint NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    locale character varying NOT NULL,
    description character varying DEFAULT ''::character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: glossaries_id_seq; Type: SEQUENCE; Schema: fao; Owner: -
--

CREATE SEQUENCE fao.glossaries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: glossaries_id_seq; Type: SEQUENCE OWNED BY; Schema: fao; Owner: -
--

ALTER SEQUENCE fao.glossaries_id_seq OWNED BY fao.glossaries.id;


--
-- Name: handbook_answers; Type: TABLE; Schema: fao; Owner: -
--

CREATE TABLE fao.handbook_answers (
    id bigint NOT NULL,
    answer_text character varying NOT NULL,
    action character varying NOT NULL,
    locale character varying DEFAULT 'en'::character varying NOT NULL,
    handbook_question_id bigint
);


--
-- Name: handbook_answers_id_seq; Type: SEQUENCE; Schema: fao; Owner: -
--

CREATE SEQUENCE fao.handbook_answers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: handbook_answers_id_seq; Type: SEQUENCE OWNED BY; Schema: fao; Owner: -
--

ALTER SEQUENCE fao.handbook_answers_id_seq OWNED BY fao.handbook_answers.id;


--
-- Name: handbook_descriptions; Type: TABLE; Schema: fao; Owner: -
--

CREATE TABLE fao.handbook_descriptions (
    id bigint NOT NULL,
    handbook_id bigint,
    locale character varying NOT NULL,
    overview character varying DEFAULT ''::character varying NOT NULL,
    audience character varying DEFAULT ''::character varying NOT NULL,
    outcomes character varying DEFAULT ''::character varying NOT NULL,
    cover character varying
);


--
-- Name: handbook_descriptions_id_seq; Type: SEQUENCE; Schema: fao; Owner: -
--

CREATE SEQUENCE fao.handbook_descriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: handbook_descriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: fao; Owner: -
--

ALTER SEQUENCE fao.handbook_descriptions_id_seq OWNED BY fao.handbook_descriptions.id;


--
-- Name: handbook_pages; Type: TABLE; Schema: fao; Owner: -
--

CREATE TABLE fao.handbook_pages (
    id bigint NOT NULL,
    handbook_id bigint NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    phase character varying,
    page_order integer,
    parent_page_id bigint,
    handbook_questions_id bigint,
    resources jsonb DEFAULT '[]'::jsonb NOT NULL,
    media_url character varying
);


--
-- Name: handbook_pages_id_seq; Type: SEQUENCE; Schema: fao; Owner: -
--

CREATE SEQUENCE fao.handbook_pages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: handbook_pages_id_seq; Type: SEQUENCE OWNED BY; Schema: fao; Owner: -
--

ALTER SEQUENCE fao.handbook_pages_id_seq OWNED BY fao.handbook_pages.id;


--
-- Name: handbook_questions; Type: TABLE; Schema: fao; Owner: -
--

CREATE TABLE fao.handbook_questions (
    id bigint NOT NULL,
    question_text character varying NOT NULL,
    locale character varying DEFAULT 'en'::character varying NOT NULL,
    handbook_page_id bigint
);


--
-- Name: handbook_questions_id_seq; Type: SEQUENCE; Schema: fao; Owner: -
--

CREATE SEQUENCE fao.handbook_questions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: handbook_questions_id_seq; Type: SEQUENCE OWNED BY; Schema: fao; Owner: -
--

ALTER SEQUENCE fao.handbook_questions_id_seq OWNED BY fao.handbook_questions.id;


--
-- Name: handbooks; Type: TABLE; Schema: fao; Owner: -
--

CREATE TABLE fao.handbooks (
    id bigint NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    phases jsonb DEFAULT '[]'::jsonb NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    maturity character varying DEFAULT 'Beta'::character varying,
    pdf_url character varying
);


--
-- Name: handbooks_id_seq; Type: SEQUENCE; Schema: fao; Owner: -
--

CREATE SEQUENCE fao.handbooks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: handbooks_id_seq; Type: SEQUENCE OWNED BY; Schema: fao; Owner: -
--

ALTER SEQUENCE fao.handbooks_id_seq OWNED BY fao.handbooks.id;


--
-- Name: messages; Type: TABLE; Schema: fao; Owner: -
--

CREATE TABLE fao.messages (
    id bigint NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    message_type character varying NOT NULL,
    message_template character varying NOT NULL,
    message_datetime timestamp(6) without time zone NOT NULL,
    visible boolean DEFAULT false NOT NULL,
    location character varying,
    location_type character varying,
    created_by_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: messages_id_seq; Type: SEQUENCE; Schema: fao; Owner: -
--

CREATE SEQUENCE fao.messages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: messages_id_seq; Type: SEQUENCE OWNED BY; Schema: fao; Owner: -
--

ALTER SEQUENCE fao.messages_id_seq OWNED BY fao.messages.id;


--
-- Name: offices; Type: TABLE; Schema: fao; Owner: -
--

CREATE TABLE fao.offices (
    id bigint NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    latitude numeric NOT NULL,
    longitude numeric NOT NULL,
    city character varying NOT NULL,
    organization_id bigint NOT NULL,
    province_id bigint,
    country_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: offices_id_seq; Type: SEQUENCE; Schema: fao; Owner: -
--

CREATE SEQUENCE fao.offices_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: offices_id_seq; Type: SEQUENCE OWNED BY; Schema: fao; Owner: -
--

ALTER SEQUENCE fao.offices_id_seq OWNED BY fao.offices.id;


--
-- Name: operator_services; Type: TABLE; Schema: fao; Owner: -
--

CREATE TABLE fao.operator_services (
    id bigint NOT NULL,
    name character varying,
    service fao.mobile_services,
    country_id bigint,
    country_name character varying
);


--
-- Name: operator_services_id_seq; Type: SEQUENCE; Schema: fao; Owner: -
--

CREATE SEQUENCE fao.operator_services_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: operator_services_id_seq; Type: SEQUENCE OWNED BY; Schema: fao; Owner: -
--

ALTER SEQUENCE fao.operator_services_id_seq OWNED BY fao.operator_services.id;


--
-- Name: opportunities; Type: TABLE; Schema: fao; Owner: -
--

CREATE TABLE fao.opportunities (
    id bigint NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    description character varying NOT NULL,
    contact_name character varying NOT NULL,
    contact_email character varying NOT NULL,
    opening_date timestamp without time zone,
    closing_date timestamp without time zone,
    opportunity_type fao.opportunity_type_type DEFAULT 'OTHER'::fao.opportunity_type_type NOT NULL,
    opportunity_status fao.opportunity_status_type DEFAULT 'UPCOMING'::fao.opportunity_status_type NOT NULL,
    web_address character varying,
    requirements character varying,
    budget numeric(12,2),
    tags character varying[] DEFAULT '{}'::character varying[],
    origin_id bigint,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    gov_stack_entity boolean DEFAULT false NOT NULL
);


--
-- Name: opportunities_building_blocks; Type: TABLE; Schema: fao; Owner: -
--

CREATE TABLE fao.opportunities_building_blocks (
    building_block_id bigint,
    opportunity_id bigint
);


--
-- Name: opportunities_countries; Type: TABLE; Schema: fao; Owner: -
--

CREATE TABLE fao.opportunities_countries (
    country_id bigint,
    opportunity_id bigint
);


--
-- Name: opportunities_id_seq; Type: SEQUENCE; Schema: fao; Owner: -
--

CREATE SEQUENCE fao.opportunities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: opportunities_id_seq; Type: SEQUENCE OWNED BY; Schema: fao; Owner: -
--

ALTER SEQUENCE fao.opportunities_id_seq OWNED BY fao.opportunities.id;


--
-- Name: opportunities_organizations; Type: TABLE; Schema: fao; Owner: -
--

CREATE TABLE fao.opportunities_organizations (
    organization_id bigint,
    opportunity_id bigint
);


--
-- Name: opportunities_sectors; Type: TABLE; Schema: fao; Owner: -
--

CREATE TABLE fao.opportunities_sectors (
    sector_id bigint,
    opportunity_id bigint
);


--
-- Name: opportunities_use_cases; Type: TABLE; Schema: fao; Owner: -
--

CREATE TABLE fao.opportunities_use_cases (
    use_case_id bigint,
    opportunity_id bigint
);


--
-- Name: organization_contacts; Type: TABLE; Schema: fao; Owner: -
--

CREATE TABLE fao.organization_contacts (
    organization_id bigint NOT NULL,
    contact_id bigint NOT NULL,
    started_at timestamp without time zone,
    ended_at timestamp without time zone,
    id bigint NOT NULL,
    slug character varying NOT NULL,
    main_contact boolean DEFAULT false NOT NULL
);


--
-- Name: organization_contacts_id_seq; Type: SEQUENCE; Schema: fao; Owner: -
--

CREATE SEQUENCE fao.organization_contacts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: organization_contacts_id_seq; Type: SEQUENCE OWNED BY; Schema: fao; Owner: -
--

ALTER SEQUENCE fao.organization_contacts_id_seq OWNED BY fao.organization_contacts.id;


--
-- Name: organization_datasets; Type: TABLE; Schema: fao; Owner: -
--

CREATE TABLE fao.organization_datasets (
    id bigint NOT NULL,
    organization_id bigint NOT NULL,
    dataset_id bigint NOT NULL,
    organization_type fao.org_type DEFAULT 'owner'::fao.org_type NOT NULL,
    slug character varying NOT NULL
);


--
-- Name: organization_datasets_id_seq; Type: SEQUENCE; Schema: fao; Owner: -
--

CREATE SEQUENCE fao.organization_datasets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: organization_datasets_id_seq; Type: SEQUENCE OWNED BY; Schema: fao; Owner: -
--

ALTER SEQUENCE fao.organization_datasets_id_seq OWNED BY fao.organization_datasets.id;


--
-- Name: organization_descriptions; Type: TABLE; Schema: fao; Owner: -
--

CREATE TABLE fao.organization_descriptions (
    id bigint NOT NULL,
    organization_id bigint NOT NULL,
    locale character varying NOT NULL,
    description character varying DEFAULT ''::character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: organization_descriptions_id_seq; Type: SEQUENCE; Schema: fao; Owner: -
--

CREATE SEQUENCE fao.organization_descriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: organization_descriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: fao; Owner: -
--

ALTER SEQUENCE fao.organization_descriptions_id_seq OWNED BY fao.organization_descriptions.id;


--
-- Name: organization_products; Type: TABLE; Schema: fao; Owner: -
--

CREATE TABLE fao.organization_products (
    organization_id bigint NOT NULL,
    product_id bigint NOT NULL,
    id bigint NOT NULL,
    slug character varying NOT NULL,
    org_type fao.org_type DEFAULT 'owner'::fao.org_type
);


--
-- Name: organization_products_id_seq; Type: SEQUENCE; Schema: fao; Owner: -
--

CREATE SEQUENCE fao.organization_products_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: organization_products_id_seq; Type: SEQUENCE OWNED BY; Schema: fao; Owner: -
--

ALTER SEQUENCE fao.organization_products_id_seq OWNED BY fao.organization_products.id;


--
-- Name: organizations; Type: TABLE; Schema: fao; Owner: -
--

CREATE TABLE fao.organizations (
    id bigint NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    when_endorsed timestamp without time zone,
    website character varying,
    is_endorser boolean DEFAULT false,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    is_mni boolean DEFAULT false,
    aliases character varying[] DEFAULT '{}'::character varying[],
    endorser_level fao.endorser_type DEFAULT 'none'::fao.endorser_type,
    has_storefront boolean DEFAULT false NOT NULL,
    hero_url character varying,
    specialties jsonb DEFAULT '[]'::jsonb NOT NULL,
    certifications jsonb DEFAULT '[]'::jsonb NOT NULL,
    building_blocks jsonb DEFAULT '[]'::jsonb NOT NULL
);


--
-- Name: organizations_countries; Type: TABLE; Schema: fao; Owner: -
--

CREATE TABLE fao.organizations_countries (
    id bigint NOT NULL,
    organization_id bigint NOT NULL,
    country_id bigint NOT NULL
);


--
-- Name: organizations_countries_id_seq; Type: SEQUENCE; Schema: fao; Owner: -
--

CREATE SEQUENCE fao.organizations_countries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: organizations_countries_id_seq; Type: SEQUENCE OWNED BY; Schema: fao; Owner: -
--

ALTER SEQUENCE fao.organizations_countries_id_seq OWNED BY fao.organizations_countries.id;


--
-- Name: organizations_id_seq; Type: SEQUENCE; Schema: fao; Owner: -
--

CREATE SEQUENCE fao.organizations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: organizations_id_seq; Type: SEQUENCE OWNED BY; Schema: fao; Owner: -
--

ALTER SEQUENCE fao.organizations_id_seq OWNED BY fao.organizations.id;


--
-- Name: organizations_resources; Type: TABLE; Schema: fao; Owner: -
--

CREATE TABLE fao.organizations_resources (
    id bigint NOT NULL,
    organization_id bigint NOT NULL,
    resource_id bigint NOT NULL
);


--
-- Name: organizations_resources_id_seq; Type: SEQUENCE; Schema: fao; Owner: -
--

CREATE SEQUENCE fao.organizations_resources_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: organizations_resources_id_seq; Type: SEQUENCE OWNED BY; Schema: fao; Owner: -
--

ALTER SEQUENCE fao.organizations_resources_id_seq OWNED BY fao.organizations_resources.id;


--
-- Name: organizations_sectors; Type: TABLE; Schema: fao; Owner: -
--

CREATE TABLE fao.organizations_sectors (
    sector_id bigint NOT NULL,
    organization_id bigint NOT NULL
);


--
-- Name: origins; Type: TABLE; Schema: fao; Owner: -
--

CREATE TABLE fao.origins (
    id bigint NOT NULL,
    organization_id bigint,
    name character varying,
    slug character varying,
    description character varying,
    last_synced timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: origins_id_seq; Type: SEQUENCE; Schema: fao; Owner: -
--

CREATE SEQUENCE fao.origins_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: origins_id_seq; Type: SEQUENCE OWNED BY; Schema: fao; Owner: -
--

ALTER SEQUENCE fao.origins_id_seq OWNED BY fao.origins.id;


--
-- Name: page_contents; Type: TABLE; Schema: fao; Owner: -
--

CREATE TABLE fao.page_contents (
    id bigint NOT NULL,
    handbook_page_id bigint,
    locale character varying NOT NULL,
    html character varying NOT NULL,
    css character varying NOT NULL,
    components character varying,
    assets character varying,
    styles character varying,
    editor_type character varying
);


--
-- Name: page_contents_id_seq; Type: SEQUENCE; Schema: fao; Owner: -
--

CREATE SEQUENCE fao.page_contents_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: page_contents_id_seq; Type: SEQUENCE OWNED BY; Schema: fao; Owner: -
--

ALTER SEQUENCE fao.page_contents_id_seq OWNED BY fao.page_contents.id;


--
-- Name: play_descriptions; Type: TABLE; Schema: fao; Owner: -
--

CREATE TABLE fao.play_descriptions (
    id bigint NOT NULL,
    play_id bigint,
    locale character varying NOT NULL,
    description character varying NOT NULL
);


--
-- Name: play_descriptions_id_seq; Type: SEQUENCE; Schema: fao; Owner: -
--

CREATE SEQUENCE fao.play_descriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: play_descriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: fao; Owner: -
--

ALTER SEQUENCE fao.play_descriptions_id_seq OWNED BY fao.play_descriptions.id;


--
-- Name: play_move_descriptions; Type: TABLE; Schema: fao; Owner: -
--

CREATE TABLE fao.play_move_descriptions (
    id bigint NOT NULL,
    play_move_id bigint,
    locale character varying NOT NULL,
    description character varying NOT NULL,
    prerequisites character varying DEFAULT ''::character varying NOT NULL,
    outcomes character varying DEFAULT ''::character varying NOT NULL
);


--
-- Name: play_move_descriptions_id_seq; Type: SEQUENCE; Schema: fao; Owner: -
--

CREATE SEQUENCE fao.play_move_descriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: play_move_descriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: fao; Owner: -
--

ALTER SEQUENCE fao.play_move_descriptions_id_seq OWNED BY fao.play_move_descriptions.id;


--
-- Name: play_moves; Type: TABLE; Schema: fao; Owner: -
--

CREATE TABLE fao.play_moves (
    id bigint NOT NULL,
    play_id bigint,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    move_order integer DEFAULT 0 NOT NULL,
    inline_resources jsonb DEFAULT '[]'::jsonb NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: play_moves_id_seq; Type: SEQUENCE; Schema: fao; Owner: -
--

CREATE SEQUENCE fao.play_moves_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: play_moves_id_seq; Type: SEQUENCE OWNED BY; Schema: fao; Owner: -
--

ALTER SEQUENCE fao.play_moves_id_seq OWNED BY fao.play_moves.id;


--
-- Name: play_moves_resources; Type: TABLE; Schema: fao; Owner: -
--

CREATE TABLE fao.play_moves_resources (
    id bigint NOT NULL,
    play_move_id bigint NOT NULL,
    resource_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: play_moves_resources_id_seq; Type: SEQUENCE; Schema: fao; Owner: -
--

CREATE SEQUENCE fao.play_moves_resources_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: play_moves_resources_id_seq; Type: SEQUENCE OWNED BY; Schema: fao; Owner: -
--

ALTER SEQUENCE fao.play_moves_resources_id_seq OWNED BY fao.play_moves_resources.id;


--
-- Name: playbook_descriptions; Type: TABLE; Schema: fao; Owner: -
--

CREATE TABLE fao.playbook_descriptions (
    id bigint NOT NULL,
    playbook_id bigint,
    locale character varying NOT NULL,
    overview character varying NOT NULL,
    audience character varying NOT NULL,
    outcomes character varying NOT NULL
);


--
-- Name: playbook_descriptions_id_seq; Type: SEQUENCE; Schema: fao; Owner: -
--

CREATE SEQUENCE fao.playbook_descriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: playbook_descriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: fao; Owner: -
--

ALTER SEQUENCE fao.playbook_descriptions_id_seq OWNED BY fao.playbook_descriptions.id;


--
-- Name: playbook_plays; Type: TABLE; Schema: fao; Owner: -
--

CREATE TABLE fao.playbook_plays (
    id bigint NOT NULL,
    playbook_id bigint NOT NULL,
    play_id bigint NOT NULL,
    phase character varying,
    play_order integer DEFAULT 0 NOT NULL
);


--
-- Name: playbook_plays_id_seq; Type: SEQUENCE; Schema: fao; Owner: -
--

CREATE SEQUENCE fao.playbook_plays_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: playbook_plays_id_seq; Type: SEQUENCE OWNED BY; Schema: fao; Owner: -
--

ALTER SEQUENCE fao.playbook_plays_id_seq OWNED BY fao.playbook_plays.id;


--
-- Name: playbooks; Type: TABLE; Schema: fao; Owner: -
--

CREATE TABLE fao.playbooks (
    id bigint NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    phases jsonb DEFAULT '[]'::jsonb NOT NULL,
    tags character varying[] DEFAULT '{}'::character varying[],
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    draft boolean DEFAULT true NOT NULL,
    author character varying,
    owned_by character varying DEFAULT 'public'::character varying
);


--
-- Name: playbooks_id_seq; Type: SEQUENCE; Schema: fao; Owner: -
--

CREATE SEQUENCE fao.playbooks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: playbooks_id_seq; Type: SEQUENCE OWNED BY; Schema: fao; Owner: -
--

ALTER SEQUENCE fao.playbooks_id_seq OWNED BY fao.playbooks.id;


--
-- Name: playbooks_sectors; Type: TABLE; Schema: fao; Owner: -
--

CREATE TABLE fao.playbooks_sectors (
    playbook_id bigint NOT NULL,
    sector_id bigint NOT NULL
);


--
-- Name: plays; Type: TABLE; Schema: fao; Owner: -
--

CREATE TABLE fao.plays (
    id bigint NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    author character varying,
    resources jsonb DEFAULT '[]'::jsonb NOT NULL,
    tags character varying[] DEFAULT '{}'::character varying[],
    version character varying DEFAULT '1.0'::character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    owned_by character varying DEFAULT 'public'::character varying,
    draft boolean DEFAULT false
);


--
-- Name: plays_building_blocks; Type: TABLE; Schema: fao; Owner: -
--

CREATE TABLE fao.plays_building_blocks (
    id bigint NOT NULL,
    play_id bigint,
    building_block_id bigint
);


--
-- Name: plays_building_blocks_id_seq; Type: SEQUENCE; Schema: fao; Owner: -
--

CREATE SEQUENCE fao.plays_building_blocks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: plays_building_blocks_id_seq; Type: SEQUENCE OWNED BY; Schema: fao; Owner: -
--

ALTER SEQUENCE fao.plays_building_blocks_id_seq OWNED BY fao.plays_building_blocks.id;


--
-- Name: plays_id_seq; Type: SEQUENCE; Schema: fao; Owner: -
--

CREATE SEQUENCE fao.plays_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: plays_id_seq; Type: SEQUENCE OWNED BY; Schema: fao; Owner: -
--

ALTER SEQUENCE fao.plays_id_seq OWNED BY fao.plays.id;


--
-- Name: plays_products; Type: TABLE; Schema: fao; Owner: -
--

CREATE TABLE fao.plays_products (
    id bigint NOT NULL,
    play_id bigint,
    product_id bigint
);


--
-- Name: plays_products_id_seq; Type: SEQUENCE; Schema: fao; Owner: -
--

CREATE SEQUENCE fao.plays_products_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: plays_products_id_seq; Type: SEQUENCE OWNED BY; Schema: fao; Owner: -
--

ALTER SEQUENCE fao.plays_products_id_seq OWNED BY fao.plays_products.id;


--
-- Name: plays_subplays; Type: TABLE; Schema: fao; Owner: -
--

CREATE TABLE fao.plays_subplays (
    id bigint NOT NULL,
    parent_play_id bigint NOT NULL,
    child_play_id bigint NOT NULL,
    "order" integer
);


--
-- Name: plays_subplays_id_seq; Type: SEQUENCE; Schema: fao; Owner: -
--

CREATE SEQUENCE fao.plays_subplays_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: plays_subplays_id_seq; Type: SEQUENCE OWNED BY; Schema: fao; Owner: -
--

ALTER SEQUENCE fao.plays_subplays_id_seq OWNED BY fao.plays_subplays.id;


--
-- Name: portal_views; Type: TABLE; Schema: fao; Owner: -
--

CREATE TABLE fao.portal_views (
    id bigint NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    description character varying NOT NULL,
    top_navs character varying[] DEFAULT '{}'::character varying[],
    filter_navs character varying[] DEFAULT '{}'::character varying[],
    user_roles character varying[] DEFAULT '{}'::character varying[],
    product_views character varying[] DEFAULT '{}'::character varying[],
    organization_views character varying[] DEFAULT '{}'::character varying[],
    subdomain character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: portal_views_id_seq; Type: SEQUENCE; Schema: fao; Owner: -
--

CREATE SEQUENCE fao.portal_views_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: portal_views_id_seq; Type: SEQUENCE OWNED BY; Schema: fao; Owner: -
--

ALTER SEQUENCE fao.portal_views_id_seq OWNED BY fao.portal_views.id;


--
-- Name: principle_descriptions; Type: TABLE; Schema: fao; Owner: -
--

CREATE TABLE fao.principle_descriptions (
    id bigint NOT NULL,
    digital_principle_id bigint,
    locale character varying NOT NULL,
    description character varying DEFAULT ''::character varying NOT NULL
);


--
-- Name: principle_descriptions_id_seq; Type: SEQUENCE; Schema: fao; Owner: -
--

CREATE SEQUENCE fao.principle_descriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: principle_descriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: fao; Owner: -
--

ALTER SEQUENCE fao.principle_descriptions_id_seq OWNED BY fao.principle_descriptions.id;


--
-- Name: product_building_blocks; Type: TABLE; Schema: fao; Owner: -
--

CREATE TABLE fao.product_building_blocks (
    building_block_id bigint NOT NULL,
    product_id bigint NOT NULL,
    mapping_status fao.mapping_status_type DEFAULT 'BETA'::fao.mapping_status_type NOT NULL,
    id bigint NOT NULL,
    slug character varying NOT NULL
);


--
-- Name: product_building_blocks_id_seq; Type: SEQUENCE; Schema: fao; Owner: -
--

CREATE SEQUENCE fao.product_building_blocks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: product_building_blocks_id_seq; Type: SEQUENCE OWNED BY; Schema: fao; Owner: -
--

ALTER SEQUENCE fao.product_building_blocks_id_seq OWNED BY fao.product_building_blocks.id;


--
-- Name: product_categories; Type: TABLE; Schema: fao; Owner: -
--

CREATE TABLE fao.product_categories (
    product_id bigint,
    software_category_id bigint
);


--
-- Name: product_classifications; Type: TABLE; Schema: fao; Owner: -
--

CREATE TABLE fao.product_classifications (
    id bigint NOT NULL,
    product_id bigint,
    classification_id bigint
);


--
-- Name: product_classifications_id_seq; Type: SEQUENCE; Schema: fao; Owner: -
--

CREATE SEQUENCE fao.product_classifications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: product_classifications_id_seq; Type: SEQUENCE OWNED BY; Schema: fao; Owner: -
--

ALTER SEQUENCE fao.product_classifications_id_seq OWNED BY fao.product_classifications.id;


--
-- Name: product_descriptions; Type: TABLE; Schema: fao; Owner: -
--

CREATE TABLE fao.product_descriptions (
    id bigint NOT NULL,
    product_id bigint NOT NULL,
    locale character varying NOT NULL,
    description character varying DEFAULT ''::character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: product_descriptions_id_seq; Type: SEQUENCE; Schema: fao; Owner: -
--

CREATE SEQUENCE fao.product_descriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: product_descriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: fao; Owner: -
--

ALTER SEQUENCE fao.product_descriptions_id_seq OWNED BY fao.product_descriptions.id;


--
-- Name: product_features; Type: TABLE; Schema: fao; Owner: -
--

CREATE TABLE fao.product_features (
    product_id bigint,
    software_feature_id bigint
);


--
-- Name: product_indicators; Type: TABLE; Schema: fao; Owner: -
--

CREATE TABLE fao.product_indicators (
    id bigint NOT NULL,
    product_id bigint NOT NULL,
    category_indicator_id bigint NOT NULL,
    indicator_value character varying NOT NULL,
    updated_at timestamp without time zone
);


--
-- Name: product_indicators_id_seq; Type: SEQUENCE; Schema: fao; Owner: -
--

CREATE SEQUENCE fao.product_indicators_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: product_indicators_id_seq; Type: SEQUENCE OWNED BY; Schema: fao; Owner: -
--

ALTER SEQUENCE fao.product_indicators_id_seq OWNED BY fao.product_indicators.id;


--
-- Name: product_product_relationships; Type: TABLE; Schema: fao; Owner: -
--

CREATE TABLE fao.product_product_relationships (
    id bigint NOT NULL,
    from_product_id bigint NOT NULL,
    to_product_id bigint NOT NULL,
    relationship_type fao.relationship_type NOT NULL,
    slug character varying NOT NULL
);


--
-- Name: product_product_relationships_id_seq; Type: SEQUENCE; Schema: fao; Owner: -
--

CREATE SEQUENCE fao.product_product_relationships_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: product_product_relationships_id_seq; Type: SEQUENCE OWNED BY; Schema: fao; Owner: -
--

ALTER SEQUENCE fao.product_product_relationships_id_seq OWNED BY fao.product_product_relationships.id;


--
-- Name: product_repositories; Type: TABLE; Schema: fao; Owner: -
--

CREATE TABLE fao.product_repositories (
    id bigint NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    product_id bigint NOT NULL,
    absolute_url character varying NOT NULL,
    description character varying NOT NULL,
    main_repository boolean DEFAULT false NOT NULL,
    dpga_data jsonb DEFAULT '{}'::jsonb NOT NULL,
    language_data jsonb DEFAULT '{}'::jsonb NOT NULL,
    statistical_data jsonb DEFAULT '{}'::jsonb NOT NULL,
    license_data jsonb DEFAULT '{}'::jsonb NOT NULL,
    license character varying DEFAULT 'NA'::character varying NOT NULL,
    code_lines integer,
    cocomo integer,
    est_hosting integer,
    est_invested integer,
    updated_at timestamp without time zone NOT NULL,
    updated_by bigint,
    deleted boolean DEFAULT false NOT NULL,
    deleted_at timestamp without time zone,
    deleted_by bigint,
    created_at timestamp without time zone NOT NULL
);


--
-- Name: product_repositories_id_seq; Type: SEQUENCE; Schema: fao; Owner: -
--

CREATE SEQUENCE fao.product_repositories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: product_repositories_id_seq; Type: SEQUENCE OWNED BY; Schema: fao; Owner: -
--

ALTER SEQUENCE fao.product_repositories_id_seq OWNED BY fao.product_repositories.id;


--
-- Name: product_sectors; Type: TABLE; Schema: fao; Owner: -
--

CREATE TABLE fao.product_sectors (
    product_id bigint NOT NULL,
    sector_id bigint NOT NULL,
    mapping_status fao.mapping_status_type DEFAULT 'BETA'::fao.mapping_status_type NOT NULL,
    id bigint NOT NULL,
    slug character varying NOT NULL
);


--
-- Name: product_sectors_id_seq; Type: SEQUENCE; Schema: fao; Owner: -
--

CREATE SEQUENCE fao.product_sectors_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: product_sectors_id_seq; Type: SEQUENCE OWNED BY; Schema: fao; Owner: -
--

ALTER SEQUENCE fao.product_sectors_id_seq OWNED BY fao.product_sectors.id;


--
-- Name: product_sustainable_development_goals; Type: TABLE; Schema: fao; Owner: -
--

CREATE TABLE fao.product_sustainable_development_goals (
    product_id bigint NOT NULL,
    sustainable_development_goal_id bigint NOT NULL,
    mapping_status fao.mapping_status_type DEFAULT 'BETA'::fao.mapping_status_type NOT NULL,
    id bigint NOT NULL,
    slug character varying NOT NULL
);


--
-- Name: product_sustainable_development_goals_id_seq; Type: SEQUENCE; Schema: fao; Owner: -
--

CREATE SEQUENCE fao.product_sustainable_development_goals_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: product_sustainable_development_goals_id_seq; Type: SEQUENCE OWNED BY; Schema: fao; Owner: -
--

ALTER SEQUENCE fao.product_sustainable_development_goals_id_seq OWNED BY fao.product_sustainable_development_goals.id;


--
-- Name: products; Type: TABLE; Schema: fao; Owner: -
--

CREATE TABLE fao.products (
    id bigint NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    website character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    is_launchable boolean DEFAULT false,
    start_assessment boolean DEFAULT false,
    default_url character varying DEFAULT 'http://<host_ip>'::character varying NOT NULL,
    aliases character varying[] DEFAULT '{}'::character varying[],
    tags character varying[] DEFAULT '{}'::character varying[],
    maturity_score jsonb,
    product_type fao.product_type_save DEFAULT 'product'::fao.product_type_save,
    manual_update boolean DEFAULT false,
    commercial_product boolean DEFAULT false,
    pricing_model character varying,
    pricing_details character varying,
    hosting_model character varying,
    pricing_date date,
    pricing_url character varying,
    languages jsonb,
    gov_stack_entity boolean DEFAULT false NOT NULL,
    extra_attributes jsonb DEFAULT '[]'::jsonb,
    product_stage character varying
);


--
-- Name: products_countries; Type: TABLE; Schema: fao; Owner: -
--

CREATE TABLE fao.products_countries (
    id bigint NOT NULL,
    product_id bigint NOT NULL,
    country_id bigint NOT NULL
);


--
-- Name: products_countries_id_seq; Type: SEQUENCE; Schema: fao; Owner: -
--

CREATE SEQUENCE fao.products_countries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: products_countries_id_seq; Type: SEQUENCE OWNED BY; Schema: fao; Owner: -
--

ALTER SEQUENCE fao.products_countries_id_seq OWNED BY fao.products_countries.id;


--
-- Name: products_endorsers; Type: TABLE; Schema: fao; Owner: -
--

CREATE TABLE fao.products_endorsers (
    id bigint NOT NULL,
    product_id bigint NOT NULL,
    endorser_id bigint NOT NULL
);


--
-- Name: products_endorsers_id_seq; Type: SEQUENCE; Schema: fao; Owner: -
--

CREATE SEQUENCE fao.products_endorsers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: products_endorsers_id_seq; Type: SEQUENCE OWNED BY; Schema: fao; Owner: -
--

ALTER SEQUENCE fao.products_endorsers_id_seq OWNED BY fao.products_endorsers.id;


--
-- Name: products_id_seq; Type: SEQUENCE; Schema: fao; Owner: -
--

CREATE SEQUENCE fao.products_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: products_id_seq; Type: SEQUENCE OWNED BY; Schema: fao; Owner: -
--

ALTER SEQUENCE fao.products_id_seq OWNED BY fao.products.id;


--
-- Name: products_origins; Type: TABLE; Schema: fao; Owner: -
--

CREATE TABLE fao.products_origins (
    product_id bigint NOT NULL,
    origin_id bigint NOT NULL
);


--
-- Name: products_resources; Type: TABLE; Schema: fao; Owner: -
--

CREATE TABLE fao.products_resources (
    product_id bigint NOT NULL,
    resource_id bigint NOT NULL
);


--
-- Name: project_descriptions; Type: TABLE; Schema: fao; Owner: -
--

CREATE TABLE fao.project_descriptions (
    id bigint NOT NULL,
    project_id bigint NOT NULL,
    locale character varying NOT NULL,
    description character varying DEFAULT ''::character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: project_descriptions_id_seq; Type: SEQUENCE; Schema: fao; Owner: -
--

CREATE SEQUENCE fao.project_descriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: project_descriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: fao; Owner: -
--

ALTER SEQUENCE fao.project_descriptions_id_seq OWNED BY fao.project_descriptions.id;


--
-- Name: projects; Type: TABLE; Schema: fao; Owner: -
--

CREATE TABLE fao.projects (
    id bigint NOT NULL,
    origin_id bigint,
    start_date date,
    end_date date,
    budget numeric(12,2),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    project_url character varying,
    tags character varying[] DEFAULT '{}'::character varying[]
);


--
-- Name: projects_countries; Type: TABLE; Schema: fao; Owner: -
--

CREATE TABLE fao.projects_countries (
    id bigint NOT NULL,
    project_id bigint NOT NULL,
    country_id bigint NOT NULL
);


--
-- Name: projects_countries_id_seq; Type: SEQUENCE; Schema: fao; Owner: -
--

CREATE SEQUENCE fao.projects_countries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: projects_countries_id_seq; Type: SEQUENCE OWNED BY; Schema: fao; Owner: -
--

ALTER SEQUENCE fao.projects_countries_id_seq OWNED BY fao.projects_countries.id;


--
-- Name: projects_digital_principles; Type: TABLE; Schema: fao; Owner: -
--

CREATE TABLE fao.projects_digital_principles (
    id bigint NOT NULL,
    project_id bigint NOT NULL,
    digital_principle_id bigint NOT NULL
);


--
-- Name: projects_digital_principles_id_seq; Type: SEQUENCE; Schema: fao; Owner: -
--

CREATE SEQUENCE fao.projects_digital_principles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: projects_digital_principles_id_seq; Type: SEQUENCE OWNED BY; Schema: fao; Owner: -
--

ALTER SEQUENCE fao.projects_digital_principles_id_seq OWNED BY fao.projects_digital_principles.id;


--
-- Name: projects_id_seq; Type: SEQUENCE; Schema: fao; Owner: -
--

CREATE SEQUENCE fao.projects_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: projects_id_seq; Type: SEQUENCE OWNED BY; Schema: fao; Owner: -
--

ALTER SEQUENCE fao.projects_id_seq OWNED BY fao.projects.id;


--
-- Name: projects_organizations; Type: TABLE; Schema: fao; Owner: -
--

CREATE TABLE fao.projects_organizations (
    project_id bigint NOT NULL,
    organization_id bigint NOT NULL,
    org_type fao.org_type DEFAULT 'owner'::fao.org_type,
    featured_project boolean DEFAULT false NOT NULL
);


--
-- Name: projects_products; Type: TABLE; Schema: fao; Owner: -
--

CREATE TABLE fao.projects_products (
    project_id bigint NOT NULL,
    product_id bigint NOT NULL
);


--
-- Name: projects_sdgs; Type: TABLE; Schema: fao; Owner: -
--

CREATE TABLE fao.projects_sdgs (
    project_id bigint NOT NULL,
    sdg_id bigint NOT NULL
);


--
-- Name: projects_sectors; Type: TABLE; Schema: fao; Owner: -
--

CREATE TABLE fao.projects_sectors (
    project_id bigint NOT NULL,
    sector_id bigint NOT NULL
);


--
-- Name: provinces; Type: TABLE; Schema: fao; Owner: -
--

CREATE TABLE fao.provinces (
    id bigint NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    country_id bigint NOT NULL,
    latitude numeric NOT NULL,
    longitude numeric NOT NULL,
    aliases character varying[] DEFAULT '{}'::character varying[],
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: provinces_id_seq; Type: SEQUENCE; Schema: fao; Owner: -
--

CREATE SEQUENCE fao.provinces_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: provinces_id_seq; Type: SEQUENCE OWNED BY; Schema: fao; Owner: -
--

ALTER SEQUENCE fao.provinces_id_seq OWNED BY fao.provinces.id;


--
-- Name: regions; Type: TABLE; Schema: fao; Owner: -
--

CREATE TABLE fao.regions (
    id bigint NOT NULL,
    slug character varying NOT NULL,
    name character varying NOT NULL,
    description character varying NOT NULL,
    aliases character varying[] DEFAULT '{}'::character varying[],
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: regions_countries; Type: TABLE; Schema: fao; Owner: -
--

CREATE TABLE fao.regions_countries (
    region_id bigint NOT NULL,
    country_id bigint NOT NULL
);


--
-- Name: regions_id_seq; Type: SEQUENCE; Schema: fao; Owner: -
--

CREATE SEQUENCE fao.regions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: regions_id_seq; Type: SEQUENCE OWNED BY; Schema: fao; Owner: -
--

ALTER SEQUENCE fao.regions_id_seq OWNED BY fao.regions.id;


--
-- Name: resource_building_blocks; Type: TABLE; Schema: fao; Owner: -
--

CREATE TABLE fao.resource_building_blocks (
    id bigint NOT NULL,
    resource_id bigint NOT NULL,
    building_block_id bigint NOT NULL,
    mapping_status fao.mapping_status_type DEFAULT 'BETA'::fao.mapping_status_type,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: resource_building_blocks_id_seq; Type: SEQUENCE; Schema: fao; Owner: -
--

CREATE SEQUENCE fao.resource_building_blocks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: resource_building_blocks_id_seq; Type: SEQUENCE OWNED BY; Schema: fao; Owner: -
--

ALTER SEQUENCE fao.resource_building_blocks_id_seq OWNED BY fao.resource_building_blocks.id;


--
-- Name: resource_topic_descriptions; Type: TABLE; Schema: fao; Owner: -
--

CREATE TABLE fao.resource_topic_descriptions (
    id bigint NOT NULL,
    locale character varying NOT NULL,
    description character varying NOT NULL,
    resource_topic_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: resource_topic_descriptions_id_seq; Type: SEQUENCE; Schema: fao; Owner: -
--

CREATE SEQUENCE fao.resource_topic_descriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: resource_topic_descriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: fao; Owner: -
--

ALTER SEQUENCE fao.resource_topic_descriptions_id_seq OWNED BY fao.resource_topic_descriptions.id;


--
-- Name: resource_topics; Type: TABLE; Schema: fao; Owner: -
--

CREATE TABLE fao.resource_topics (
    id bigint NOT NULL,
    slug character varying NOT NULL,
    name character varying NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    parent_topic_id bigint
);


--
-- Name: resource_topics_id_seq; Type: SEQUENCE; Schema: fao; Owner: -
--

CREATE SEQUENCE fao.resource_topics_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: resource_topics_id_seq; Type: SEQUENCE OWNED BY; Schema: fao; Owner: -
--

ALTER SEQUENCE fao.resource_topics_id_seq OWNED BY fao.resource_topics.id;


--
-- Name: resource_types; Type: TABLE; Schema: fao; Owner: -
--

CREATE TABLE fao.resource_types (
    id bigint NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    description character varying NOT NULL,
    locale character varying DEFAULT 'en'::character varying NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: resource_types_id_seq; Type: SEQUENCE; Schema: fao; Owner: -
--

CREATE SEQUENCE fao.resource_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: resource_types_id_seq; Type: SEQUENCE OWNED BY; Schema: fao; Owner: -
--

ALTER SEQUENCE fao.resource_types_id_seq OWNED BY fao.resource_types.id;


--
-- Name: resources; Type: TABLE; Schema: fao; Owner: -
--

CREATE TABLE fao.resources (
    id bigint NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    phase character varying NOT NULL,
    image_url character varying,
    resource_link character varying,
    description character varying,
    show_in_wizard boolean DEFAULT false NOT NULL,
    show_in_exchange boolean DEFAULT false NOT NULL,
    link_description character varying,
    tags character varying[] DEFAULT '{}'::character varying[],
    resource_type character varying,
    published_date timestamp(6) without time zone,
    featured boolean DEFAULT false NOT NULL,
    resource_filename character varying,
    resource_topics character varying[] DEFAULT '{}'::character varying[],
    organization_id bigint,
    submitted_by_id bigint
);


--
-- Name: resources_authors; Type: TABLE; Schema: fao; Owner: -
--

CREATE TABLE fao.resources_authors (
    resource_id bigint NOT NULL,
    author_id bigint NOT NULL
);


--
-- Name: resources_countries; Type: TABLE; Schema: fao; Owner: -
--

CREATE TABLE fao.resources_countries (
    resource_id bigint NOT NULL,
    country_id bigint NOT NULL
);


--
-- Name: resources_id_seq; Type: SEQUENCE; Schema: fao; Owner: -
--

CREATE SEQUENCE fao.resources_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: resources_id_seq; Type: SEQUENCE OWNED BY; Schema: fao; Owner: -
--

ALTER SEQUENCE fao.resources_id_seq OWNED BY fao.resources.id;


--
-- Name: resources_use_cases; Type: TABLE; Schema: fao; Owner: -
--

CREATE TABLE fao.resources_use_cases (
    id bigint NOT NULL,
    resource_id bigint NOT NULL,
    use_case_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: resources_use_cases_id_seq; Type: SEQUENCE; Schema: fao; Owner: -
--

CREATE SEQUENCE fao.resources_use_cases_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: resources_use_cases_id_seq; Type: SEQUENCE OWNED BY; Schema: fao; Owner: -
--

ALTER SEQUENCE fao.resources_use_cases_id_seq OWNED BY fao.resources_use_cases.id;


--
-- Name: rubric_categories; Type: TABLE; Schema: fao; Owner: -
--

CREATE TABLE fao.rubric_categories (
    id bigint NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    weight numeric DEFAULT 0 NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: rubric_categories_id_seq; Type: SEQUENCE; Schema: fao; Owner: -
--

CREATE SEQUENCE fao.rubric_categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: rubric_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: fao; Owner: -
--

ALTER SEQUENCE fao.rubric_categories_id_seq OWNED BY fao.rubric_categories.id;


--
-- Name: rubric_category_descriptions; Type: TABLE; Schema: fao; Owner: -
--

CREATE TABLE fao.rubric_category_descriptions (
    id bigint NOT NULL,
    rubric_category_id bigint NOT NULL,
    locale character varying NOT NULL,
    description character varying DEFAULT ''::character varying NOT NULL
);


--
-- Name: rubric_category_descriptions_id_seq; Type: SEQUENCE; Schema: fao; Owner: -
--

CREATE SEQUENCE fao.rubric_category_descriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: rubric_category_descriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: fao; Owner: -
--

ALTER SEQUENCE fao.rubric_category_descriptions_id_seq OWNED BY fao.rubric_category_descriptions.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: fao; Owner: -
--

CREATE TABLE fao.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: sdg_targets; Type: TABLE; Schema: fao; Owner: -
--

CREATE TABLE fao.sdg_targets (
    id bigint NOT NULL,
    name character varying NOT NULL,
    target_number character varying NOT NULL,
    slug character varying,
    sdg_number integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: sdg_targets_id_seq; Type: SEQUENCE; Schema: fao; Owner: -
--

CREATE SEQUENCE fao.sdg_targets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sdg_targets_id_seq; Type: SEQUENCE OWNED BY; Schema: fao; Owner: -
--

ALTER SEQUENCE fao.sdg_targets_id_seq OWNED BY fao.sdg_targets.id;


--
-- Name: sectors; Type: TABLE; Schema: fao; Owner: -
--

CREATE TABLE fao.sectors (
    id bigint NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    is_displayable boolean,
    parent_sector_id bigint,
    origin_id bigint,
    locale character varying DEFAULT 'en'::character varying
);


--
-- Name: sectors_id_seq; Type: SEQUENCE; Schema: fao; Owner: -
--

CREATE SEQUENCE fao.sectors_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sectors_id_seq; Type: SEQUENCE OWNED BY; Schema: fao; Owner: -
--

ALTER SEQUENCE fao.sectors_id_seq OWNED BY fao.sectors.id;


--
-- Name: sessions; Type: TABLE; Schema: fao; Owner: -
--

CREATE TABLE fao.sessions (
    id bigint NOT NULL,
    session_id character varying NOT NULL,
    data text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: sessions_id_seq; Type: SEQUENCE; Schema: fao; Owner: -
--

CREATE SEQUENCE fao.sessions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sessions_id_seq; Type: SEQUENCE OWNED BY; Schema: fao; Owner: -
--

ALTER SEQUENCE fao.sessions_id_seq OWNED BY fao.sessions.id;


--
-- Name: settings; Type: TABLE; Schema: fao; Owner: -
--

CREATE TABLE fao.settings (
    id bigint NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    description character varying NOT NULL,
    value text NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: settings_id_seq; Type: SEQUENCE; Schema: fao; Owner: -
--

CREATE SEQUENCE fao.settings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: settings_id_seq; Type: SEQUENCE OWNED BY; Schema: fao; Owner: -
--

ALTER SEQUENCE fao.settings_id_seq OWNED BY fao.settings.id;


--
-- Name: software_categories; Type: TABLE; Schema: fao; Owner: -
--

CREATE TABLE fao.software_categories (
    id bigint NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    description character varying NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: software_categories_id_seq; Type: SEQUENCE; Schema: fao; Owner: -
--

CREATE SEQUENCE fao.software_categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: software_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: fao; Owner: -
--

ALTER SEQUENCE fao.software_categories_id_seq OWNED BY fao.software_categories.id;


--
-- Name: software_features; Type: TABLE; Schema: fao; Owner: -
--

CREATE TABLE fao.software_features (
    id bigint NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    description character varying NOT NULL,
    facility_scale integer,
    software_category_id bigint,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: software_features_id_seq; Type: SEQUENCE; Schema: fao; Owner: -
--

CREATE SEQUENCE fao.software_features_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: software_features_id_seq; Type: SEQUENCE OWNED BY; Schema: fao; Owner: -
--

ALTER SEQUENCE fao.software_features_id_seq OWNED BY fao.software_features.id;


--
-- Name: starred_objects; Type: TABLE; Schema: fao; Owner: -
--

CREATE TABLE fao.starred_objects (
    id bigint NOT NULL,
    starred_object_type character varying NOT NULL,
    starred_object_value character varying NOT NULL,
    source_object_type character varying NOT NULL,
    source_object_value character varying NOT NULL,
    starred_by_id bigint,
    starred_date timestamp(6) without time zone NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: starred_objects_id_seq; Type: SEQUENCE; Schema: fao; Owner: -
--

CREATE SEQUENCE fao.starred_objects_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: starred_objects_id_seq; Type: SEQUENCE OWNED BY; Schema: fao; Owner: -
--

ALTER SEQUENCE fao.starred_objects_id_seq OWNED BY fao.starred_objects.id;


--
-- Name: stylesheets; Type: TABLE; Schema: fao; Owner: -
--

CREATE TABLE fao.stylesheets (
    id bigint NOT NULL,
    portal character varying,
    background_color character varying,
    about_page character varying DEFAULT ''::character varying NOT NULL,
    footer_content character varying DEFAULT ''::character varying NOT NULL,
    header_logo character varying
);


--
-- Name: stylesheets_id_seq; Type: SEQUENCE; Schema: fao; Owner: -
--

CREATE SEQUENCE fao.stylesheets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: stylesheets_id_seq; Type: SEQUENCE OWNED BY; Schema: fao; Owner: -
--

ALTER SEQUENCE fao.stylesheets_id_seq OWNED BY fao.stylesheets.id;


--
-- Name: sustainable_development_goals; Type: TABLE; Schema: fao; Owner: -
--

CREATE TABLE fao.sustainable_development_goals (
    id bigint NOT NULL,
    slug character varying NOT NULL,
    name character varying NOT NULL,
    long_title character varying NOT NULL,
    number integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: sustainable_development_goals_id_seq; Type: SEQUENCE; Schema: fao; Owner: -
--

CREATE SEQUENCE fao.sustainable_development_goals_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sustainable_development_goals_id_seq; Type: SEQUENCE OWNED BY; Schema: fao; Owner: -
--

ALTER SEQUENCE fao.sustainable_development_goals_id_seq OWNED BY fao.sustainable_development_goals.id;


--
-- Name: tag_descriptions; Type: TABLE; Schema: fao; Owner: -
--

CREATE TABLE fao.tag_descriptions (
    id bigint NOT NULL,
    tag_id bigint NOT NULL,
    locale character varying NOT NULL,
    description character varying DEFAULT ''::character varying NOT NULL
);


--
-- Name: tag_descriptions_id_seq; Type: SEQUENCE; Schema: fao; Owner: -
--

CREATE SEQUENCE fao.tag_descriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tag_descriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: fao; Owner: -
--

ALTER SEQUENCE fao.tag_descriptions_id_seq OWNED BY fao.tag_descriptions.id;


--
-- Name: tags; Type: TABLE; Schema: fao; Owner: -
--

CREATE TABLE fao.tags (
    id bigint NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: tags_id_seq; Type: SEQUENCE; Schema: fao; Owner: -
--

CREATE SEQUENCE fao.tags_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tags_id_seq; Type: SEQUENCE OWNED BY; Schema: fao; Owner: -
--

ALTER SEQUENCE fao.tags_id_seq OWNED BY fao.tags.id;


--
-- Name: task_tracker_descriptions; Type: TABLE; Schema: fao; Owner: -
--

CREATE TABLE fao.task_tracker_descriptions (
    id bigint NOT NULL,
    task_tracker_id bigint NOT NULL,
    locale character varying NOT NULL,
    description character varying DEFAULT '{}'::jsonb NOT NULL
);


--
-- Name: task_tracker_descriptions_id_seq; Type: SEQUENCE; Schema: fao; Owner: -
--

CREATE SEQUENCE fao.task_tracker_descriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: task_tracker_descriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: fao; Owner: -
--

ALTER SEQUENCE fao.task_tracker_descriptions_id_seq OWNED BY fao.task_tracker_descriptions.id;


--
-- Name: task_trackers; Type: TABLE; Schema: fao; Owner: -
--

CREATE TABLE fao.task_trackers (
    id bigint NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    last_started_date timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    last_received_message character varying NOT NULL,
    task_completed boolean DEFAULT false NOT NULL
);


--
-- Name: task_trackers_id_seq; Type: SEQUENCE; Schema: fao; Owner: -
--

CREATE SEQUENCE fao.task_trackers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: task_trackers_id_seq; Type: SEQUENCE OWNED BY; Schema: fao; Owner: -
--

ALTER SEQUENCE fao.task_trackers_id_seq OWNED BY fao.task_trackers.id;


--
-- Name: tenant_sync_configurations; Type: TABLE; Schema: fao; Owner: -
--

CREATE TABLE fao.tenant_sync_configurations (
    id bigint NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    description character varying NOT NULL,
    tenant_source character varying NOT NULL,
    tenant_destination character varying NOT NULL,
    sync_enabled boolean DEFAULT true NOT NULL,
    sync_configuration json DEFAULT '{}'::json NOT NULL,
    last_sync_at timestamp(6) without time zone,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: tenant_sync_configurations_id_seq; Type: SEQUENCE; Schema: fao; Owner: -
--

CREATE SEQUENCE fao.tenant_sync_configurations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tenant_sync_configurations_id_seq; Type: SEQUENCE OWNED BY; Schema: fao; Owner: -
--

ALTER SEQUENCE fao.tenant_sync_configurations_id_seq OWNED BY fao.tenant_sync_configurations.id;


--
-- Name: use_case_descriptions; Type: TABLE; Schema: fao; Owner: -
--

CREATE TABLE fao.use_case_descriptions (
    id bigint NOT NULL,
    use_case_id bigint NOT NULL,
    locale character varying NOT NULL,
    description character varying DEFAULT ''::character varying NOT NULL
);


--
-- Name: use_case_descriptions_id_seq; Type: SEQUENCE; Schema: fao; Owner: -
--

CREATE SEQUENCE fao.use_case_descriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: use_case_descriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: fao; Owner: -
--

ALTER SEQUENCE fao.use_case_descriptions_id_seq OWNED BY fao.use_case_descriptions.id;


--
-- Name: use_case_headers; Type: TABLE; Schema: fao; Owner: -
--

CREATE TABLE fao.use_case_headers (
    id bigint NOT NULL,
    use_case_id bigint NOT NULL,
    locale character varying NOT NULL,
    header character varying DEFAULT ''::character varying NOT NULL
);


--
-- Name: use_case_headers_id_seq; Type: SEQUENCE; Schema: fao; Owner: -
--

CREATE SEQUENCE fao.use_case_headers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: use_case_headers_id_seq; Type: SEQUENCE OWNED BY; Schema: fao; Owner: -
--

ALTER SEQUENCE fao.use_case_headers_id_seq OWNED BY fao.use_case_headers.id;


--
-- Name: use_case_step_descriptions; Type: TABLE; Schema: fao; Owner: -
--

CREATE TABLE fao.use_case_step_descriptions (
    id bigint NOT NULL,
    use_case_step_id bigint NOT NULL,
    locale character varying NOT NULL,
    description character varying DEFAULT ''::character varying NOT NULL
);


--
-- Name: use_case_step_descriptions_id_seq; Type: SEQUENCE; Schema: fao; Owner: -
--

CREATE SEQUENCE fao.use_case_step_descriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: use_case_step_descriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: fao; Owner: -
--

ALTER SEQUENCE fao.use_case_step_descriptions_id_seq OWNED BY fao.use_case_step_descriptions.id;


--
-- Name: use_case_steps; Type: TABLE; Schema: fao; Owner: -
--

CREATE TABLE fao.use_case_steps (
    id bigint NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    step_number integer NOT NULL,
    use_case_id bigint NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    example_implementation character varying
);


--
-- Name: use_case_steps_building_blocks; Type: TABLE; Schema: fao; Owner: -
--

CREATE TABLE fao.use_case_steps_building_blocks (
    id bigint NOT NULL,
    use_case_step_id bigint NOT NULL,
    building_block_id bigint NOT NULL
);


--
-- Name: use_case_steps_building_blocks_id_seq; Type: SEQUENCE; Schema: fao; Owner: -
--

CREATE SEQUENCE fao.use_case_steps_building_blocks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: use_case_steps_building_blocks_id_seq; Type: SEQUENCE OWNED BY; Schema: fao; Owner: -
--

ALTER SEQUENCE fao.use_case_steps_building_blocks_id_seq OWNED BY fao.use_case_steps_building_blocks.id;


--
-- Name: use_case_steps_datasets; Type: TABLE; Schema: fao; Owner: -
--

CREATE TABLE fao.use_case_steps_datasets (
    id bigint NOT NULL,
    use_case_step_id bigint NOT NULL,
    dataset_id bigint NOT NULL
);


--
-- Name: use_case_steps_datasets_id_seq; Type: SEQUENCE; Schema: fao; Owner: -
--

CREATE SEQUENCE fao.use_case_steps_datasets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: use_case_steps_datasets_id_seq; Type: SEQUENCE OWNED BY; Schema: fao; Owner: -
--

ALTER SEQUENCE fao.use_case_steps_datasets_id_seq OWNED BY fao.use_case_steps_datasets.id;


--
-- Name: use_case_steps_id_seq; Type: SEQUENCE; Schema: fao; Owner: -
--

CREATE SEQUENCE fao.use_case_steps_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: use_case_steps_id_seq; Type: SEQUENCE OWNED BY; Schema: fao; Owner: -
--

ALTER SEQUENCE fao.use_case_steps_id_seq OWNED BY fao.use_case_steps.id;


--
-- Name: use_case_steps_products; Type: TABLE; Schema: fao; Owner: -
--

CREATE TABLE fao.use_case_steps_products (
    id bigint NOT NULL,
    use_case_step_id bigint NOT NULL,
    product_id bigint NOT NULL
);


--
-- Name: use_case_steps_products_id_seq; Type: SEQUENCE; Schema: fao; Owner: -
--

CREATE SEQUENCE fao.use_case_steps_products_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: use_case_steps_products_id_seq; Type: SEQUENCE OWNED BY; Schema: fao; Owner: -
--

ALTER SEQUENCE fao.use_case_steps_products_id_seq OWNED BY fao.use_case_steps_products.id;


--
-- Name: use_case_steps_workflows; Type: TABLE; Schema: fao; Owner: -
--

CREATE TABLE fao.use_case_steps_workflows (
    use_case_step_id bigint NOT NULL,
    workflow_id bigint NOT NULL
);


--
-- Name: use_cases; Type: TABLE; Schema: fao; Owner: -
--

CREATE TABLE fao.use_cases (
    id bigint NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    sector_id bigint NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    description jsonb DEFAULT '{}'::jsonb NOT NULL,
    maturity fao.entity_status_type DEFAULT 'DRAFT'::fao.entity_status_type NOT NULL,
    tags character varying[] DEFAULT '{}'::character varying[],
    markdown_url character varying,
    gov_stack_entity boolean DEFAULT false NOT NULL
);


--
-- Name: use_cases_id_seq; Type: SEQUENCE; Schema: fao; Owner: -
--

CREATE SEQUENCE fao.use_cases_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: use_cases_id_seq; Type: SEQUENCE OWNED BY; Schema: fao; Owner: -
--

ALTER SEQUENCE fao.use_cases_id_seq OWNED BY fao.use_cases.id;


--
-- Name: use_cases_sdg_targets; Type: TABLE; Schema: fao; Owner: -
--

CREATE TABLE fao.use_cases_sdg_targets (
    use_case_id bigint NOT NULL,
    sdg_target_id bigint NOT NULL
);


--
-- Name: user_events; Type: TABLE; Schema: fao; Owner: -
--

CREATE TABLE fao.user_events (
    id bigint NOT NULL,
    identifier character varying NOT NULL,
    email character varying,
    event_datetime timestamp without time zone NOT NULL,
    event_type character varying NOT NULL,
    extended_data jsonb DEFAULT '{}'::jsonb NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: user_events_id_seq; Type: SEQUENCE; Schema: fao; Owner: -
--

CREATE SEQUENCE fao.user_events_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: user_events_id_seq; Type: SEQUENCE OWNED BY; Schema: fao; Owner: -
--

ALTER SEQUENCE fao.user_events_id_seq OWNED BY fao.user_events.id;


--
-- Name: user_messages; Type: TABLE; Schema: fao; Owner: -
--

CREATE TABLE fao.user_messages (
    id bigint NOT NULL,
    message_id bigint NOT NULL,
    received_by_id bigint NOT NULL,
    read boolean DEFAULT false NOT NULL,
    visible boolean DEFAULT false NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: user_messages_id_seq; Type: SEQUENCE; Schema: fao; Owner: -
--

CREATE SEQUENCE fao.user_messages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: user_messages_id_seq; Type: SEQUENCE OWNED BY; Schema: fao; Owner: -
--

ALTER SEQUENCE fao.user_messages_id_seq OWNED BY fao.user_messages.id;


--
-- Name: users; Type: TABLE; Schema: fao; Owner: -
--

CREATE TABLE fao.users (
    id bigint NOT NULL,
    email character varying DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    confirmation_token character varying,
    confirmed_at timestamp without time zone,
    confirmation_sent_at timestamp without time zone,
    unconfirmed_email character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    receive_backup boolean DEFAULT false,
    organization_id bigint,
    expired boolean,
    expired_at timestamp without time zone,
    saved_products bigint[] DEFAULT '{}'::bigint[],
    saved_use_cases bigint[] DEFAULT '{}'::bigint[],
    saved_projects bigint[] DEFAULT '{}'::bigint[],
    saved_urls character varying[] DEFAULT '{}'::character varying[],
    roles fao.user_role[] DEFAULT '{}'::fao.user_role[],
    authentication_token text,
    authentication_token_created_at timestamp without time zone,
    user_products bigint[] DEFAULT '{}'::bigint[],
    receive_admin_emails boolean DEFAULT false,
    username character varying,
    user_datasets bigint[] DEFAULT '{}'::bigint[],
    saved_building_blocks bigint[] DEFAULT '{}'::bigint[] NOT NULL
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: fao; Owner: -
--

CREATE SEQUENCE fao.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: fao; Owner: -
--

ALTER SEQUENCE fao.users_id_seq OWNED BY fao.users.id;


--
-- Name: workflow_descriptions; Type: TABLE; Schema: fao; Owner: -
--

CREATE TABLE fao.workflow_descriptions (
    id bigint NOT NULL,
    workflow_id bigint NOT NULL,
    locale character varying NOT NULL,
    description character varying DEFAULT ''::character varying NOT NULL
);


--
-- Name: workflow_descriptions_id_seq; Type: SEQUENCE; Schema: fao; Owner: -
--

CREATE SEQUENCE fao.workflow_descriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: workflow_descriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: fao; Owner: -
--

ALTER SEQUENCE fao.workflow_descriptions_id_seq OWNED BY fao.workflow_descriptions.id;


--
-- Name: workflows; Type: TABLE; Schema: fao; Owner: -
--

CREATE TABLE fao.workflows (
    id bigint NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    description jsonb DEFAULT '{}'::jsonb NOT NULL
);


--
-- Name: workflows_building_blocks; Type: TABLE; Schema: fao; Owner: -
--

CREATE TABLE fao.workflows_building_blocks (
    workflow_id bigint NOT NULL,
    building_block_id bigint NOT NULL
);


--
-- Name: workflows_id_seq; Type: SEQUENCE; Schema: fao; Owner: -
--

CREATE SEQUENCE fao.workflows_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: workflows_id_seq; Type: SEQUENCE OWNED BY; Schema: fao; Owner: -
--

ALTER SEQUENCE fao.workflows_id_seq OWNED BY fao.workflows.id;


--
-- Name: workflows_use_cases; Type: TABLE; Schema: fao; Owner: -
--

CREATE TABLE fao.workflows_use_cases (
    workflow_id bigint NOT NULL,
    use_case_id bigint NOT NULL
);


--
-- Name: aggregator_capabilities; Type: TABLE; Schema: health; Owner: -
--

CREATE TABLE health.aggregator_capabilities (
    id bigint NOT NULL,
    aggregator_id bigint,
    operator_services_id bigint,
    service health.mobile_services,
    capability health.agg_capabilities,
    country_name character varying,
    country_id bigint
);


--
-- Name: aggregator_capabilities_id_seq; Type: SEQUENCE; Schema: health; Owner: -
--

CREATE SEQUENCE health.aggregator_capabilities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: aggregator_capabilities_id_seq; Type: SEQUENCE OWNED BY; Schema: health; Owner: -
--

ALTER SEQUENCE health.aggregator_capabilities_id_seq OWNED BY health.aggregator_capabilities.id;


--
-- Name: ar_internal_metadata; Type: TABLE; Schema: health; Owner: -
--

CREATE TABLE health.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: audits; Type: TABLE; Schema: health; Owner: -
--

CREATE TABLE health.audits (
    id bigint NOT NULL,
    associated_id character varying,
    associated_type character varying,
    user_id integer,
    user_role character varying,
    username character varying,
    action character varying,
    audit_changes jsonb,
    version integer DEFAULT 0,
    comment character varying,
    created_at timestamp without time zone
);


--
-- Name: audits_id_seq; Type: SEQUENCE; Schema: health; Owner: -
--

CREATE SEQUENCE health.audits_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: audits_id_seq; Type: SEQUENCE OWNED BY; Schema: health; Owner: -
--

ALTER SEQUENCE health.audits_id_seq OWNED BY health.audits.id;


--
-- Name: authors; Type: TABLE; Schema: health; Owner: -
--

CREATE TABLE health.authors (
    id bigint NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    email character varying,
    picture character varying NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: authors_id_seq; Type: SEQUENCE; Schema: health; Owner: -
--

CREATE SEQUENCE health.authors_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: authors_id_seq; Type: SEQUENCE OWNED BY; Schema: health; Owner: -
--

ALTER SEQUENCE health.authors_id_seq OWNED BY health.authors.id;


--
-- Name: building_block_descriptions; Type: TABLE; Schema: health; Owner: -
--

CREATE TABLE health.building_block_descriptions (
    id bigint NOT NULL,
    building_block_id bigint NOT NULL,
    locale character varying NOT NULL,
    description character varying DEFAULT ''::character varying NOT NULL
);


--
-- Name: building_block_descriptions_id_seq; Type: SEQUENCE; Schema: health; Owner: -
--

CREATE SEQUENCE health.building_block_descriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: building_block_descriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: health; Owner: -
--

ALTER SEQUENCE health.building_block_descriptions_id_seq OWNED BY health.building_block_descriptions.id;


--
-- Name: building_blocks; Type: TABLE; Schema: health; Owner: -
--

CREATE TABLE health.building_blocks (
    id bigint NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    description jsonb DEFAULT '{}'::jsonb NOT NULL,
    maturity health.entity_status_type DEFAULT 'DRAFT'::health.entity_status_type NOT NULL,
    spec_url character varying,
    category health.category_type,
    display_order integer DEFAULT 0 NOT NULL,
    gov_stack_entity boolean DEFAULT false NOT NULL
);


--
-- Name: building_blocks_id_seq; Type: SEQUENCE; Schema: health; Owner: -
--

CREATE SEQUENCE health.building_blocks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: building_blocks_id_seq; Type: SEQUENCE OWNED BY; Schema: health; Owner: -
--

ALTER SEQUENCE health.building_blocks_id_seq OWNED BY health.building_blocks.id;


--
-- Name: candidate_datasets; Type: TABLE; Schema: health; Owner: -
--

CREATE TABLE health.candidate_datasets (
    id bigint NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    website character varying NOT NULL,
    visualization_url character varying,
    dataset_type character varying NOT NULL,
    submitter_email character varying NOT NULL,
    description character varying NOT NULL,
    rejected boolean,
    rejected_date timestamp without time zone,
    rejected_by_id bigint,
    approved_date timestamp without time zone,
    approved_by_id bigint,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: candidate_datasets_id_seq; Type: SEQUENCE; Schema: health; Owner: -
--

CREATE SEQUENCE health.candidate_datasets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: candidate_datasets_id_seq; Type: SEQUENCE OWNED BY; Schema: health; Owner: -
--

ALTER SEQUENCE health.candidate_datasets_id_seq OWNED BY health.candidate_datasets.id;


--
-- Name: candidate_organizations; Type: TABLE; Schema: health; Owner: -
--

CREATE TABLE health.candidate_organizations (
    id bigint NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    website text,
    rejected boolean,
    rejected_date timestamp without time zone,
    rejected_by_id bigint,
    approved_date timestamp without time zone,
    approved_by_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    description character varying,
    create_storefront boolean DEFAULT false NOT NULL
);


--
-- Name: candidate_organizations_contacts; Type: TABLE; Schema: health; Owner: -
--

CREATE TABLE health.candidate_organizations_contacts (
    candidate_organization_id bigint NOT NULL,
    contact_id bigint NOT NULL,
    started_at timestamp without time zone,
    ended_at timestamp without time zone
);


--
-- Name: candidate_organizations_id_seq; Type: SEQUENCE; Schema: health; Owner: -
--

CREATE SEQUENCE health.candidate_organizations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: candidate_organizations_id_seq; Type: SEQUENCE OWNED BY; Schema: health; Owner: -
--

ALTER SEQUENCE health.candidate_organizations_id_seq OWNED BY health.candidate_organizations.id;


--
-- Name: candidate_products; Type: TABLE; Schema: health; Owner: -
--

CREATE TABLE health.candidate_products (
    id bigint NOT NULL,
    slug character varying NOT NULL,
    name character varying NOT NULL,
    website character varying NOT NULL,
    repository character varying NOT NULL,
    submitter_email character varying NOT NULL,
    rejected boolean,
    rejected_date timestamp without time zone,
    rejected_by_id bigint,
    approved_date timestamp without time zone,
    approved_by_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    description character varying,
    commercial_product boolean DEFAULT false NOT NULL
);


--
-- Name: candidate_products_id_seq; Type: SEQUENCE; Schema: health; Owner: -
--

CREATE SEQUENCE health.candidate_products_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: candidate_products_id_seq; Type: SEQUENCE OWNED BY; Schema: health; Owner: -
--

ALTER SEQUENCE health.candidate_products_id_seq OWNED BY health.candidate_products.id;


--
-- Name: candidate_resources; Type: TABLE; Schema: health; Owner: -
--

CREATE TABLE health.candidate_resources (
    id bigint NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    description character varying NOT NULL,
    published_date timestamp(6) without time zone DEFAULT '2024-08-27 00:00:00'::timestamp without time zone NOT NULL,
    resource_type character varying NOT NULL,
    resource_link character varying NOT NULL,
    link_description character varying NOT NULL,
    submitter_email character varying NOT NULL,
    rejected boolean,
    rejected_date timestamp(6) without time zone,
    rejected_by_id bigint,
    approved_date timestamp(6) without time zone,
    approved_by_id bigint,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: candidate_resources_countries; Type: TABLE; Schema: health; Owner: -
--

CREATE TABLE health.candidate_resources_countries (
    id bigint NOT NULL,
    candidate_resource_id bigint NOT NULL,
    country_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: candidate_resources_countries_id_seq; Type: SEQUENCE; Schema: health; Owner: -
--

CREATE SEQUENCE health.candidate_resources_countries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: candidate_resources_countries_id_seq; Type: SEQUENCE OWNED BY; Schema: health; Owner: -
--

ALTER SEQUENCE health.candidate_resources_countries_id_seq OWNED BY health.candidate_resources_countries.id;


--
-- Name: candidate_resources_id_seq; Type: SEQUENCE; Schema: health; Owner: -
--

CREATE SEQUENCE health.candidate_resources_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: candidate_resources_id_seq; Type: SEQUENCE OWNED BY; Schema: health; Owner: -
--

ALTER SEQUENCE health.candidate_resources_id_seq OWNED BY health.candidate_resources.id;


--
-- Name: candidate_roles; Type: TABLE; Schema: health; Owner: -
--

CREATE TABLE health.candidate_roles (
    id bigint NOT NULL,
    email character varying NOT NULL,
    roles health.user_role[] DEFAULT '{}'::health.user_role[],
    description character varying NOT NULL,
    rejected boolean,
    rejected_date timestamp without time zone,
    rejected_by_id bigint,
    approved_date timestamp without time zone,
    approved_by_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    product_id integer,
    organization_id integer,
    dataset_id bigint
);


--
-- Name: candidate_roles_id_seq; Type: SEQUENCE; Schema: health; Owner: -
--

CREATE SEQUENCE health.candidate_roles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: candidate_roles_id_seq; Type: SEQUENCE OWNED BY; Schema: health; Owner: -
--

ALTER SEQUENCE health.candidate_roles_id_seq OWNED BY health.candidate_roles.id;


--
-- Name: category_indicator_descriptions; Type: TABLE; Schema: health; Owner: -
--

CREATE TABLE health.category_indicator_descriptions (
    id bigint NOT NULL,
    category_indicator_id bigint NOT NULL,
    locale character varying NOT NULL,
    description character varying DEFAULT ''::character varying NOT NULL
);


--
-- Name: category_indicator_descriptions_id_seq; Type: SEQUENCE; Schema: health; Owner: -
--

CREATE SEQUENCE health.category_indicator_descriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: category_indicator_descriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: health; Owner: -
--

ALTER SEQUENCE health.category_indicator_descriptions_id_seq OWNED BY health.category_indicator_descriptions.id;


--
-- Name: category_indicators; Type: TABLE; Schema: health; Owner: -
--

CREATE TABLE health.category_indicators (
    id bigint NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    indicator_type health.category_indicator_type,
    weight numeric DEFAULT 0 NOT NULL,
    rubric_category_id bigint,
    data_source character varying,
    source_indicator character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    script_name character varying
);


--
-- Name: category_indicators_id_seq; Type: SEQUENCE; Schema: health; Owner: -
--

CREATE SEQUENCE health.category_indicators_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: category_indicators_id_seq; Type: SEQUENCE OWNED BY; Schema: health; Owner: -
--

ALTER SEQUENCE health.category_indicators_id_seq OWNED BY health.category_indicators.id;


--
-- Name: chatbot_conversations; Type: TABLE; Schema: health; Owner: -
--

CREATE TABLE health.chatbot_conversations (
    id bigint NOT NULL,
    identifier character varying NOT NULL,
    session_identifier character varying NOT NULL,
    chatbot_question character varying NOT NULL,
    chatbot_answer character varying NOT NULL,
    user_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    chatbot_response jsonb DEFAULT '{}'::jsonb
);


--
-- Name: chatbot_conversations_id_seq; Type: SEQUENCE; Schema: health; Owner: -
--

CREATE SEQUENCE health.chatbot_conversations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: chatbot_conversations_id_seq; Type: SEQUENCE OWNED BY; Schema: health; Owner: -
--

ALTER SEQUENCE health.chatbot_conversations_id_seq OWNED BY health.chatbot_conversations.id;


--
-- Name: cities; Type: TABLE; Schema: health; Owner: -
--

CREATE TABLE health.cities (
    id bigint NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    province_id bigint,
    latitude numeric NOT NULL,
    longitude numeric NOT NULL,
    aliases character varying[] DEFAULT '{}'::character varying[],
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: cities_id_seq; Type: SEQUENCE; Schema: health; Owner: -
--

CREATE SEQUENCE health.cities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cities_id_seq; Type: SEQUENCE OWNED BY; Schema: health; Owner: -
--

ALTER SEQUENCE health.cities_id_seq OWNED BY health.cities.id;


--
-- Name: ckeditor_assets; Type: TABLE; Schema: health; Owner: -
--

CREATE TABLE health.ckeditor_assets (
    id bigint NOT NULL,
    data_file_name character varying NOT NULL,
    data_content_type character varying,
    data_file_size integer,
    type character varying(30),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: ckeditor_assets_id_seq; Type: SEQUENCE; Schema: health; Owner: -
--

CREATE SEQUENCE health.ckeditor_assets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ckeditor_assets_id_seq; Type: SEQUENCE OWNED BY; Schema: health; Owner: -
--

ALTER SEQUENCE health.ckeditor_assets_id_seq OWNED BY health.ckeditor_assets.id;


--
-- Name: classifications; Type: TABLE; Schema: health; Owner: -
--

CREATE TABLE health.classifications (
    id bigint NOT NULL,
    name character varying,
    indicator character varying,
    description character varying,
    source character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: classifications_id_seq; Type: SEQUENCE; Schema: health; Owner: -
--

CREATE SEQUENCE health.classifications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: classifications_id_seq; Type: SEQUENCE OWNED BY; Schema: health; Owner: -
--

ALTER SEQUENCE health.classifications_id_seq OWNED BY health.classifications.id;


--
-- Name: comments; Type: TABLE; Schema: health; Owner: -
--

CREATE TABLE health.comments (
    id bigint NOT NULL,
    comment_object_id integer NOT NULL,
    author jsonb NOT NULL,
    text character varying NOT NULL,
    comment_id character varying NOT NULL,
    parent_comment_id character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    comment_object_type health.comment_object_type NOT NULL
);


--
-- Name: comments_id_seq; Type: SEQUENCE; Schema: health; Owner: -
--

CREATE SEQUENCE health.comments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: comments_id_seq; Type: SEQUENCE OWNED BY; Schema: health; Owner: -
--

ALTER SEQUENCE health.comments_id_seq OWNED BY health.comments.id;


--
-- Name: contacts; Type: TABLE; Schema: health; Owner: -
--

CREATE TABLE health.contacts (
    id bigint NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    email character varying,
    title character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    biography text,
    social_networking_services jsonb DEFAULT '[]'::jsonb,
    source character varying DEFAULT 'exchange'::character varying,
    extended_data jsonb DEFAULT '[]'::jsonb
);


--
-- Name: contacts_id_seq; Type: SEQUENCE; Schema: health; Owner: -
--

CREATE SEQUENCE health.contacts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: contacts_id_seq; Type: SEQUENCE OWNED BY; Schema: health; Owner: -
--

ALTER SEQUENCE health.contacts_id_seq OWNED BY health.contacts.id;


--
-- Name: countries; Type: TABLE; Schema: health; Owner: -
--

CREATE TABLE health.countries (
    id bigint NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    code character varying NOT NULL,
    code_longer character varying NOT NULL,
    latitude numeric NOT NULL,
    longitude numeric NOT NULL,
    aliases character varying[] DEFAULT '{}'::character varying[],
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    description character varying
);


--
-- Name: countries_id_seq; Type: SEQUENCE; Schema: health; Owner: -
--

CREATE SEQUENCE health.countries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: countries_id_seq; Type: SEQUENCE OWNED BY; Schema: health; Owner: -
--

ALTER SEQUENCE health.countries_id_seq OWNED BY health.countries.id;


--
-- Name: dataset_descriptions; Type: TABLE; Schema: health; Owner: -
--

CREATE TABLE health.dataset_descriptions (
    id bigint NOT NULL,
    dataset_id bigint,
    locale character varying NOT NULL,
    description character varying DEFAULT ''::character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: dataset_descriptions_id_seq; Type: SEQUENCE; Schema: health; Owner: -
--

CREATE SEQUENCE health.dataset_descriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: dataset_descriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: health; Owner: -
--

ALTER SEQUENCE health.dataset_descriptions_id_seq OWNED BY health.dataset_descriptions.id;


--
-- Name: dataset_sectors; Type: TABLE; Schema: health; Owner: -
--

CREATE TABLE health.dataset_sectors (
    id bigint NOT NULL,
    dataset_id bigint NOT NULL,
    sector_id bigint NOT NULL,
    mapping_status health.mapping_status_type DEFAULT 'BETA'::health.mapping_status_type NOT NULL,
    slug character varying NOT NULL
);


--
-- Name: dataset_sectors_id_seq; Type: SEQUENCE; Schema: health; Owner: -
--

CREATE SEQUENCE health.dataset_sectors_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: dataset_sectors_id_seq; Type: SEQUENCE OWNED BY; Schema: health; Owner: -
--

ALTER SEQUENCE health.dataset_sectors_id_seq OWNED BY health.dataset_sectors.id;


--
-- Name: dataset_sustainable_development_goals; Type: TABLE; Schema: health; Owner: -
--

CREATE TABLE health.dataset_sustainable_development_goals (
    id bigint NOT NULL,
    dataset_id bigint NOT NULL,
    sustainable_development_goal_id bigint NOT NULL,
    mapping_status health.mapping_status_type DEFAULT 'BETA'::health.mapping_status_type NOT NULL,
    slug character varying NOT NULL
);


--
-- Name: dataset_sustainable_development_goals_id_seq; Type: SEQUENCE; Schema: health; Owner: -
--

CREATE SEQUENCE health.dataset_sustainable_development_goals_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: dataset_sustainable_development_goals_id_seq; Type: SEQUENCE OWNED BY; Schema: health; Owner: -
--

ALTER SEQUENCE health.dataset_sustainable_development_goals_id_seq OWNED BY health.dataset_sustainable_development_goals.id;


--
-- Name: datasets; Type: TABLE; Schema: health; Owner: -
--

CREATE TABLE health.datasets (
    id bigint NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    aliases character varying[] DEFAULT '{}'::character varying[],
    website character varying NOT NULL,
    visualization_url character varying,
    tags character varying[] DEFAULT '{}'::character varying[],
    dataset_type character varying NOT NULL,
    geographic_coverage character varying,
    time_range character varying,
    manual_update boolean DEFAULT false,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    license character varying,
    languages character varying,
    data_format character varying
);


--
-- Name: datasets_countries; Type: TABLE; Schema: health; Owner: -
--

CREATE TABLE health.datasets_countries (
    id bigint NOT NULL,
    dataset_id bigint NOT NULL,
    country_id bigint NOT NULL
);


--
-- Name: datasets_countries_id_seq; Type: SEQUENCE; Schema: health; Owner: -
--

CREATE SEQUENCE health.datasets_countries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: datasets_countries_id_seq; Type: SEQUENCE OWNED BY; Schema: health; Owner: -
--

ALTER SEQUENCE health.datasets_countries_id_seq OWNED BY health.datasets_countries.id;


--
-- Name: datasets_id_seq; Type: SEQUENCE; Schema: health; Owner: -
--

CREATE SEQUENCE health.datasets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: datasets_id_seq; Type: SEQUENCE OWNED BY; Schema: health; Owner: -
--

ALTER SEQUENCE health.datasets_id_seq OWNED BY health.datasets.id;


--
-- Name: datasets_origins; Type: TABLE; Schema: health; Owner: -
--

CREATE TABLE health.datasets_origins (
    id bigint NOT NULL,
    dataset_id bigint NOT NULL,
    origin_id bigint NOT NULL
);


--
-- Name: datasets_origins_id_seq; Type: SEQUENCE; Schema: health; Owner: -
--

CREATE SEQUENCE health.datasets_origins_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: datasets_origins_id_seq; Type: SEQUENCE OWNED BY; Schema: health; Owner: -
--

ALTER SEQUENCE health.datasets_origins_id_seq OWNED BY health.datasets_origins.id;


--
-- Name: deploys; Type: TABLE; Schema: health; Owner: -
--

CREATE TABLE health.deploys (
    id bigint NOT NULL,
    user_id bigint,
    product_id bigint,
    provider character varying,
    instance_name character varying,
    auth_token character varying,
    status character varying,
    message character varying,
    url character varying,
    suite character varying,
    job_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: deploys_id_seq; Type: SEQUENCE; Schema: health; Owner: -
--

CREATE SEQUENCE health.deploys_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: deploys_id_seq; Type: SEQUENCE OWNED BY; Schema: health; Owner: -
--

ALTER SEQUENCE health.deploys_id_seq OWNED BY health.deploys.id;


--
-- Name: dial_spreadsheet_data; Type: TABLE; Schema: health; Owner: -
--

CREATE TABLE health.dial_spreadsheet_data (
    id bigint NOT NULL,
    slug character varying NOT NULL,
    spreadsheet_type character varying NOT NULL,
    spreadsheet_data jsonb DEFAULT '{}'::jsonb NOT NULL,
    deleted boolean DEFAULT false NOT NULL,
    updated_by bigint,
    updated_date timestamp without time zone
);


--
-- Name: dial_spreadsheet_data_id_seq; Type: SEQUENCE; Schema: health; Owner: -
--

CREATE SEQUENCE health.dial_spreadsheet_data_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: dial_spreadsheet_data_id_seq; Type: SEQUENCE OWNED BY; Schema: health; Owner: -
--

ALTER SEQUENCE health.dial_spreadsheet_data_id_seq OWNED BY health.dial_spreadsheet_data.id;


--
-- Name: digital_principles; Type: TABLE; Schema: health; Owner: -
--

CREATE TABLE health.digital_principles (
    id bigint NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    url character varying NOT NULL,
    phase character varying
);


--
-- Name: digital_principles_id_seq; Type: SEQUENCE; Schema: health; Owner: -
--

CREATE SEQUENCE health.digital_principles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: digital_principles_id_seq; Type: SEQUENCE OWNED BY; Schema: health; Owner: -
--

ALTER SEQUENCE health.digital_principles_id_seq OWNED BY health.digital_principles.id;


--
-- Name: districts; Type: TABLE; Schema: health; Owner: -
--

CREATE TABLE health.districts (
    id bigint NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    province_id bigint NOT NULL,
    latitude numeric NOT NULL,
    longitude numeric NOT NULL,
    aliases character varying[] DEFAULT '{}'::character varying[],
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: districts_id_seq; Type: SEQUENCE; Schema: health; Owner: -
--

CREATE SEQUENCE health.districts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: districts_id_seq; Type: SEQUENCE OWNED BY; Schema: health; Owner: -
--

ALTER SEQUENCE health.districts_id_seq OWNED BY health.districts.id;


--
-- Name: endorsers; Type: TABLE; Schema: health; Owner: -
--

CREATE TABLE health.endorsers (
    id bigint NOT NULL,
    slug character varying NOT NULL,
    name character varying NOT NULL,
    description character varying
);


--
-- Name: endorsers_id_seq; Type: SEQUENCE; Schema: health; Owner: -
--

CREATE SEQUENCE health.endorsers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: endorsers_id_seq; Type: SEQUENCE OWNED BY; Schema: health; Owner: -
--

ALTER SEQUENCE health.endorsers_id_seq OWNED BY health.endorsers.id;


--
-- Name: exchange_tenants; Type: TABLE; Schema: health; Owner: -
--

CREATE TABLE health.exchange_tenants (
    id bigint NOT NULL,
    tenant_name character varying,
    domain character varying,
    postgres_config jsonb,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    allow_unsecure_read boolean DEFAULT true NOT NULL
);


--
-- Name: exchange_tenants_id_seq; Type: SEQUENCE; Schema: health; Owner: -
--

CREATE SEQUENCE health.exchange_tenants_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: exchange_tenants_id_seq; Type: SEQUENCE OWNED BY; Schema: health; Owner: -
--

ALTER SEQUENCE health.exchange_tenants_id_seq OWNED BY health.exchange_tenants.id;


--
-- Name: froala_images; Type: TABLE; Schema: health; Owner: -
--

CREATE TABLE health.froala_images (
    id bigint NOT NULL,
    picture character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: froala_images_id_seq; Type: SEQUENCE; Schema: health; Owner: -
--

CREATE SEQUENCE health.froala_images_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: froala_images_id_seq; Type: SEQUENCE OWNED BY; Schema: health; Owner: -
--

ALTER SEQUENCE health.froala_images_id_seq OWNED BY health.froala_images.id;


--
-- Name: glossaries; Type: TABLE; Schema: health; Owner: -
--

CREATE TABLE health.glossaries (
    id bigint NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    locale character varying NOT NULL,
    description character varying DEFAULT ''::character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: glossaries_id_seq; Type: SEQUENCE; Schema: health; Owner: -
--

CREATE SEQUENCE health.glossaries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: glossaries_id_seq; Type: SEQUENCE OWNED BY; Schema: health; Owner: -
--

ALTER SEQUENCE health.glossaries_id_seq OWNED BY health.glossaries.id;


--
-- Name: handbook_answers; Type: TABLE; Schema: health; Owner: -
--

CREATE TABLE health.handbook_answers (
    id bigint NOT NULL,
    answer_text character varying NOT NULL,
    action character varying NOT NULL,
    locale character varying DEFAULT 'en'::character varying NOT NULL,
    handbook_question_id bigint
);


--
-- Name: handbook_answers_id_seq; Type: SEQUENCE; Schema: health; Owner: -
--

CREATE SEQUENCE health.handbook_answers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: handbook_answers_id_seq; Type: SEQUENCE OWNED BY; Schema: health; Owner: -
--

ALTER SEQUENCE health.handbook_answers_id_seq OWNED BY health.handbook_answers.id;


--
-- Name: handbook_descriptions; Type: TABLE; Schema: health; Owner: -
--

CREATE TABLE health.handbook_descriptions (
    id bigint NOT NULL,
    handbook_id bigint,
    locale character varying NOT NULL,
    overview character varying DEFAULT ''::character varying NOT NULL,
    audience character varying DEFAULT ''::character varying NOT NULL,
    outcomes character varying DEFAULT ''::character varying NOT NULL,
    cover character varying
);


--
-- Name: handbook_descriptions_id_seq; Type: SEQUENCE; Schema: health; Owner: -
--

CREATE SEQUENCE health.handbook_descriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: handbook_descriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: health; Owner: -
--

ALTER SEQUENCE health.handbook_descriptions_id_seq OWNED BY health.handbook_descriptions.id;


--
-- Name: handbook_pages; Type: TABLE; Schema: health; Owner: -
--

CREATE TABLE health.handbook_pages (
    id bigint NOT NULL,
    handbook_id bigint NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    phase character varying,
    page_order integer,
    parent_page_id bigint,
    handbook_questions_id bigint,
    resources jsonb DEFAULT '[]'::jsonb NOT NULL,
    media_url character varying
);


--
-- Name: handbook_pages_id_seq; Type: SEQUENCE; Schema: health; Owner: -
--

CREATE SEQUENCE health.handbook_pages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: handbook_pages_id_seq; Type: SEQUENCE OWNED BY; Schema: health; Owner: -
--

ALTER SEQUENCE health.handbook_pages_id_seq OWNED BY health.handbook_pages.id;


--
-- Name: handbook_questions; Type: TABLE; Schema: health; Owner: -
--

CREATE TABLE health.handbook_questions (
    id bigint NOT NULL,
    question_text character varying NOT NULL,
    locale character varying DEFAULT 'en'::character varying NOT NULL,
    handbook_page_id bigint
);


--
-- Name: handbook_questions_id_seq; Type: SEQUENCE; Schema: health; Owner: -
--

CREATE SEQUENCE health.handbook_questions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: handbook_questions_id_seq; Type: SEQUENCE OWNED BY; Schema: health; Owner: -
--

ALTER SEQUENCE health.handbook_questions_id_seq OWNED BY health.handbook_questions.id;


--
-- Name: handbooks; Type: TABLE; Schema: health; Owner: -
--

CREATE TABLE health.handbooks (
    id bigint NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    phases jsonb DEFAULT '[]'::jsonb NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    maturity character varying DEFAULT 'Beta'::character varying,
    pdf_url character varying
);


--
-- Name: handbooks_id_seq; Type: SEQUENCE; Schema: health; Owner: -
--

CREATE SEQUENCE health.handbooks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: handbooks_id_seq; Type: SEQUENCE OWNED BY; Schema: health; Owner: -
--

ALTER SEQUENCE health.handbooks_id_seq OWNED BY health.handbooks.id;


--
-- Name: messages; Type: TABLE; Schema: health; Owner: -
--

CREATE TABLE health.messages (
    id bigint NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    message_type character varying NOT NULL,
    message_template character varying NOT NULL,
    message_datetime timestamp(6) without time zone NOT NULL,
    visible boolean DEFAULT false NOT NULL,
    location character varying,
    location_type character varying,
    created_by_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: messages_id_seq; Type: SEQUENCE; Schema: health; Owner: -
--

CREATE SEQUENCE health.messages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: messages_id_seq; Type: SEQUENCE OWNED BY; Schema: health; Owner: -
--

ALTER SEQUENCE health.messages_id_seq OWNED BY health.messages.id;


--
-- Name: offices; Type: TABLE; Schema: health; Owner: -
--

CREATE TABLE health.offices (
    id bigint NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    latitude numeric NOT NULL,
    longitude numeric NOT NULL,
    city character varying NOT NULL,
    organization_id bigint NOT NULL,
    province_id bigint,
    country_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: offices_id_seq; Type: SEQUENCE; Schema: health; Owner: -
--

CREATE SEQUENCE health.offices_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: offices_id_seq; Type: SEQUENCE OWNED BY; Schema: health; Owner: -
--

ALTER SEQUENCE health.offices_id_seq OWNED BY health.offices.id;


--
-- Name: operator_services; Type: TABLE; Schema: health; Owner: -
--

CREATE TABLE health.operator_services (
    id bigint NOT NULL,
    name character varying,
    service health.mobile_services,
    country_id bigint,
    country_name character varying
);


--
-- Name: operator_services_id_seq; Type: SEQUENCE; Schema: health; Owner: -
--

CREATE SEQUENCE health.operator_services_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: operator_services_id_seq; Type: SEQUENCE OWNED BY; Schema: health; Owner: -
--

ALTER SEQUENCE health.operator_services_id_seq OWNED BY health.operator_services.id;


--
-- Name: opportunities; Type: TABLE; Schema: health; Owner: -
--

CREATE TABLE health.opportunities (
    id bigint NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    description character varying NOT NULL,
    contact_name character varying NOT NULL,
    contact_email character varying NOT NULL,
    opening_date timestamp without time zone,
    closing_date timestamp without time zone,
    opportunity_type health.opportunity_type_type DEFAULT 'OTHER'::health.opportunity_type_type NOT NULL,
    opportunity_status health.opportunity_status_type DEFAULT 'UPCOMING'::health.opportunity_status_type NOT NULL,
    web_address character varying,
    requirements character varying,
    budget numeric(12,2),
    tags character varying[] DEFAULT '{}'::character varying[],
    origin_id bigint,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    gov_stack_entity boolean DEFAULT false NOT NULL
);


--
-- Name: opportunities_building_blocks; Type: TABLE; Schema: health; Owner: -
--

CREATE TABLE health.opportunities_building_blocks (
    building_block_id bigint,
    opportunity_id bigint
);


--
-- Name: opportunities_countries; Type: TABLE; Schema: health; Owner: -
--

CREATE TABLE health.opportunities_countries (
    country_id bigint,
    opportunity_id bigint
);


--
-- Name: opportunities_id_seq; Type: SEQUENCE; Schema: health; Owner: -
--

CREATE SEQUENCE health.opportunities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: opportunities_id_seq; Type: SEQUENCE OWNED BY; Schema: health; Owner: -
--

ALTER SEQUENCE health.opportunities_id_seq OWNED BY health.opportunities.id;


--
-- Name: opportunities_organizations; Type: TABLE; Schema: health; Owner: -
--

CREATE TABLE health.opportunities_organizations (
    organization_id bigint,
    opportunity_id bigint
);


--
-- Name: opportunities_sectors; Type: TABLE; Schema: health; Owner: -
--

CREATE TABLE health.opportunities_sectors (
    sector_id bigint,
    opportunity_id bigint
);


--
-- Name: opportunities_use_cases; Type: TABLE; Schema: health; Owner: -
--

CREATE TABLE health.opportunities_use_cases (
    use_case_id bigint,
    opportunity_id bigint
);


--
-- Name: organization_contacts; Type: TABLE; Schema: health; Owner: -
--

CREATE TABLE health.organization_contacts (
    organization_id bigint NOT NULL,
    contact_id bigint NOT NULL,
    started_at timestamp without time zone,
    ended_at timestamp without time zone,
    id bigint NOT NULL,
    slug character varying NOT NULL,
    main_contact boolean DEFAULT false NOT NULL
);


--
-- Name: organization_contacts_id_seq; Type: SEQUENCE; Schema: health; Owner: -
--

CREATE SEQUENCE health.organization_contacts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: organization_contacts_id_seq; Type: SEQUENCE OWNED BY; Schema: health; Owner: -
--

ALTER SEQUENCE health.organization_contacts_id_seq OWNED BY health.organization_contacts.id;


--
-- Name: organization_datasets; Type: TABLE; Schema: health; Owner: -
--

CREATE TABLE health.organization_datasets (
    id bigint NOT NULL,
    organization_id bigint NOT NULL,
    dataset_id bigint NOT NULL,
    organization_type health.org_type DEFAULT 'owner'::health.org_type NOT NULL,
    slug character varying NOT NULL
);


--
-- Name: organization_datasets_id_seq; Type: SEQUENCE; Schema: health; Owner: -
--

CREATE SEQUENCE health.organization_datasets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: organization_datasets_id_seq; Type: SEQUENCE OWNED BY; Schema: health; Owner: -
--

ALTER SEQUENCE health.organization_datasets_id_seq OWNED BY health.organization_datasets.id;


--
-- Name: organization_descriptions; Type: TABLE; Schema: health; Owner: -
--

CREATE TABLE health.organization_descriptions (
    id bigint NOT NULL,
    organization_id bigint NOT NULL,
    locale character varying NOT NULL,
    description character varying DEFAULT ''::character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: organization_descriptions_id_seq; Type: SEQUENCE; Schema: health; Owner: -
--

CREATE SEQUENCE health.organization_descriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: organization_descriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: health; Owner: -
--

ALTER SEQUENCE health.organization_descriptions_id_seq OWNED BY health.organization_descriptions.id;


--
-- Name: organization_products; Type: TABLE; Schema: health; Owner: -
--

CREATE TABLE health.organization_products (
    organization_id bigint NOT NULL,
    product_id bigint NOT NULL,
    id bigint NOT NULL,
    slug character varying NOT NULL,
    org_type health.org_type DEFAULT 'owner'::health.org_type
);


--
-- Name: organization_products_id_seq; Type: SEQUENCE; Schema: health; Owner: -
--

CREATE SEQUENCE health.organization_products_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: organization_products_id_seq; Type: SEQUENCE OWNED BY; Schema: health; Owner: -
--

ALTER SEQUENCE health.organization_products_id_seq OWNED BY health.organization_products.id;


--
-- Name: organizations; Type: TABLE; Schema: health; Owner: -
--

CREATE TABLE health.organizations (
    id bigint NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    when_endorsed timestamp without time zone,
    website character varying,
    is_endorser boolean DEFAULT false,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    is_mni boolean DEFAULT false,
    aliases character varying[] DEFAULT '{}'::character varying[],
    endorser_level health.endorser_type DEFAULT 'none'::health.endorser_type,
    has_storefront boolean DEFAULT false NOT NULL,
    hero_url character varying,
    specialties jsonb DEFAULT '[]'::jsonb NOT NULL,
    certifications jsonb DEFAULT '[]'::jsonb NOT NULL,
    building_blocks jsonb DEFAULT '[]'::jsonb NOT NULL
);


--
-- Name: organizations_countries; Type: TABLE; Schema: health; Owner: -
--

CREATE TABLE health.organizations_countries (
    id bigint NOT NULL,
    organization_id bigint NOT NULL,
    country_id bigint NOT NULL
);


--
-- Name: organizations_countries_id_seq; Type: SEQUENCE; Schema: health; Owner: -
--

CREATE SEQUENCE health.organizations_countries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: organizations_countries_id_seq; Type: SEQUENCE OWNED BY; Schema: health; Owner: -
--

ALTER SEQUENCE health.organizations_countries_id_seq OWNED BY health.organizations_countries.id;


--
-- Name: organizations_id_seq; Type: SEQUENCE; Schema: health; Owner: -
--

CREATE SEQUENCE health.organizations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: organizations_id_seq; Type: SEQUENCE OWNED BY; Schema: health; Owner: -
--

ALTER SEQUENCE health.organizations_id_seq OWNED BY health.organizations.id;


--
-- Name: organizations_resources; Type: TABLE; Schema: health; Owner: -
--

CREATE TABLE health.organizations_resources (
    id bigint NOT NULL,
    organization_id bigint NOT NULL,
    resource_id bigint NOT NULL
);


--
-- Name: organizations_resources_id_seq; Type: SEQUENCE; Schema: health; Owner: -
--

CREATE SEQUENCE health.organizations_resources_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: organizations_resources_id_seq; Type: SEQUENCE OWNED BY; Schema: health; Owner: -
--

ALTER SEQUENCE health.organizations_resources_id_seq OWNED BY health.organizations_resources.id;


--
-- Name: organizations_sectors; Type: TABLE; Schema: health; Owner: -
--

CREATE TABLE health.organizations_sectors (
    sector_id bigint NOT NULL,
    organization_id bigint NOT NULL
);


--
-- Name: origins; Type: TABLE; Schema: health; Owner: -
--

CREATE TABLE health.origins (
    id bigint NOT NULL,
    organization_id bigint,
    name character varying,
    slug character varying,
    description character varying,
    last_synced timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: origins_id_seq; Type: SEQUENCE; Schema: health; Owner: -
--

CREATE SEQUENCE health.origins_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: origins_id_seq; Type: SEQUENCE OWNED BY; Schema: health; Owner: -
--

ALTER SEQUENCE health.origins_id_seq OWNED BY health.origins.id;


--
-- Name: page_contents; Type: TABLE; Schema: health; Owner: -
--

CREATE TABLE health.page_contents (
    id bigint NOT NULL,
    handbook_page_id bigint,
    locale character varying NOT NULL,
    html character varying NOT NULL,
    css character varying NOT NULL,
    components character varying,
    assets character varying,
    styles character varying,
    editor_type character varying
);


--
-- Name: page_contents_id_seq; Type: SEQUENCE; Schema: health; Owner: -
--

CREATE SEQUENCE health.page_contents_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: page_contents_id_seq; Type: SEQUENCE OWNED BY; Schema: health; Owner: -
--

ALTER SEQUENCE health.page_contents_id_seq OWNED BY health.page_contents.id;


--
-- Name: play_descriptions; Type: TABLE; Schema: health; Owner: -
--

CREATE TABLE health.play_descriptions (
    id bigint NOT NULL,
    play_id bigint,
    locale character varying NOT NULL,
    description character varying NOT NULL
);


--
-- Name: play_descriptions_id_seq; Type: SEQUENCE; Schema: health; Owner: -
--

CREATE SEQUENCE health.play_descriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: play_descriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: health; Owner: -
--

ALTER SEQUENCE health.play_descriptions_id_seq OWNED BY health.play_descriptions.id;


--
-- Name: play_move_descriptions; Type: TABLE; Schema: health; Owner: -
--

CREATE TABLE health.play_move_descriptions (
    id bigint NOT NULL,
    play_move_id bigint,
    locale character varying NOT NULL,
    description character varying NOT NULL,
    prerequisites character varying DEFAULT ''::character varying NOT NULL,
    outcomes character varying DEFAULT ''::character varying NOT NULL
);


--
-- Name: play_move_descriptions_id_seq; Type: SEQUENCE; Schema: health; Owner: -
--

CREATE SEQUENCE health.play_move_descriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: play_move_descriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: health; Owner: -
--

ALTER SEQUENCE health.play_move_descriptions_id_seq OWNED BY health.play_move_descriptions.id;


--
-- Name: play_moves; Type: TABLE; Schema: health; Owner: -
--

CREATE TABLE health.play_moves (
    id bigint NOT NULL,
    play_id bigint,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    move_order integer DEFAULT 0 NOT NULL,
    inline_resources jsonb DEFAULT '[]'::jsonb NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: play_moves_id_seq; Type: SEQUENCE; Schema: health; Owner: -
--

CREATE SEQUENCE health.play_moves_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: play_moves_id_seq; Type: SEQUENCE OWNED BY; Schema: health; Owner: -
--

ALTER SEQUENCE health.play_moves_id_seq OWNED BY health.play_moves.id;


--
-- Name: play_moves_resources; Type: TABLE; Schema: health; Owner: -
--

CREATE TABLE health.play_moves_resources (
    id bigint NOT NULL,
    play_move_id bigint NOT NULL,
    resource_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: play_moves_resources_id_seq; Type: SEQUENCE; Schema: health; Owner: -
--

CREATE SEQUENCE health.play_moves_resources_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: play_moves_resources_id_seq; Type: SEQUENCE OWNED BY; Schema: health; Owner: -
--

ALTER SEQUENCE health.play_moves_resources_id_seq OWNED BY health.play_moves_resources.id;


--
-- Name: playbook_descriptions; Type: TABLE; Schema: health; Owner: -
--

CREATE TABLE health.playbook_descriptions (
    id bigint NOT NULL,
    playbook_id bigint,
    locale character varying NOT NULL,
    overview character varying NOT NULL,
    audience character varying NOT NULL,
    outcomes character varying NOT NULL
);


--
-- Name: playbook_descriptions_id_seq; Type: SEQUENCE; Schema: health; Owner: -
--

CREATE SEQUENCE health.playbook_descriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: playbook_descriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: health; Owner: -
--

ALTER SEQUENCE health.playbook_descriptions_id_seq OWNED BY health.playbook_descriptions.id;


--
-- Name: playbook_plays; Type: TABLE; Schema: health; Owner: -
--

CREATE TABLE health.playbook_plays (
    id bigint NOT NULL,
    playbook_id bigint NOT NULL,
    play_id bigint NOT NULL,
    phase character varying,
    play_order integer DEFAULT 0 NOT NULL
);


--
-- Name: playbook_plays_id_seq; Type: SEQUENCE; Schema: health; Owner: -
--

CREATE SEQUENCE health.playbook_plays_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: playbook_plays_id_seq; Type: SEQUENCE OWNED BY; Schema: health; Owner: -
--

ALTER SEQUENCE health.playbook_plays_id_seq OWNED BY health.playbook_plays.id;


--
-- Name: playbooks; Type: TABLE; Schema: health; Owner: -
--

CREATE TABLE health.playbooks (
    id bigint NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    phases jsonb DEFAULT '[]'::jsonb NOT NULL,
    tags character varying[] DEFAULT '{}'::character varying[],
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    draft boolean DEFAULT true NOT NULL,
    author character varying,
    owned_by character varying DEFAULT 'public'::character varying
);


--
-- Name: playbooks_id_seq; Type: SEQUENCE; Schema: health; Owner: -
--

CREATE SEQUENCE health.playbooks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: playbooks_id_seq; Type: SEQUENCE OWNED BY; Schema: health; Owner: -
--

ALTER SEQUENCE health.playbooks_id_seq OWNED BY health.playbooks.id;


--
-- Name: playbooks_sectors; Type: TABLE; Schema: health; Owner: -
--

CREATE TABLE health.playbooks_sectors (
    playbook_id bigint NOT NULL,
    sector_id bigint NOT NULL
);


--
-- Name: plays; Type: TABLE; Schema: health; Owner: -
--

CREATE TABLE health.plays (
    id bigint NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    author character varying,
    resources jsonb DEFAULT '[]'::jsonb NOT NULL,
    tags character varying[] DEFAULT '{}'::character varying[],
    version character varying DEFAULT '1.0'::character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    owned_by character varying DEFAULT 'public'::character varying,
    draft boolean DEFAULT false
);


--
-- Name: plays_building_blocks; Type: TABLE; Schema: health; Owner: -
--

CREATE TABLE health.plays_building_blocks (
    id bigint NOT NULL,
    play_id bigint,
    building_block_id bigint
);


--
-- Name: plays_building_blocks_id_seq; Type: SEQUENCE; Schema: health; Owner: -
--

CREATE SEQUENCE health.plays_building_blocks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: plays_building_blocks_id_seq; Type: SEQUENCE OWNED BY; Schema: health; Owner: -
--

ALTER SEQUENCE health.plays_building_blocks_id_seq OWNED BY health.plays_building_blocks.id;


--
-- Name: plays_id_seq; Type: SEQUENCE; Schema: health; Owner: -
--

CREATE SEQUENCE health.plays_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: plays_id_seq; Type: SEQUENCE OWNED BY; Schema: health; Owner: -
--

ALTER SEQUENCE health.plays_id_seq OWNED BY health.plays.id;


--
-- Name: plays_products; Type: TABLE; Schema: health; Owner: -
--

CREATE TABLE health.plays_products (
    id bigint NOT NULL,
    play_id bigint,
    product_id bigint
);


--
-- Name: plays_products_id_seq; Type: SEQUENCE; Schema: health; Owner: -
--

CREATE SEQUENCE health.plays_products_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: plays_products_id_seq; Type: SEQUENCE OWNED BY; Schema: health; Owner: -
--

ALTER SEQUENCE health.plays_products_id_seq OWNED BY health.plays_products.id;


--
-- Name: plays_subplays; Type: TABLE; Schema: health; Owner: -
--

CREATE TABLE health.plays_subplays (
    id bigint NOT NULL,
    parent_play_id bigint NOT NULL,
    child_play_id bigint NOT NULL,
    "order" integer
);


--
-- Name: plays_subplays_id_seq; Type: SEQUENCE; Schema: health; Owner: -
--

CREATE SEQUENCE health.plays_subplays_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: plays_subplays_id_seq; Type: SEQUENCE OWNED BY; Schema: health; Owner: -
--

ALTER SEQUENCE health.plays_subplays_id_seq OWNED BY health.plays_subplays.id;


--
-- Name: portal_views; Type: TABLE; Schema: health; Owner: -
--

CREATE TABLE health.portal_views (
    id bigint NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    description character varying NOT NULL,
    top_navs character varying[] DEFAULT '{}'::character varying[],
    filter_navs character varying[] DEFAULT '{}'::character varying[],
    user_roles character varying[] DEFAULT '{}'::character varying[],
    product_views character varying[] DEFAULT '{}'::character varying[],
    organization_views character varying[] DEFAULT '{}'::character varying[],
    subdomain character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: portal_views_id_seq; Type: SEQUENCE; Schema: health; Owner: -
--

CREATE SEQUENCE health.portal_views_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: portal_views_id_seq; Type: SEQUENCE OWNED BY; Schema: health; Owner: -
--

ALTER SEQUENCE health.portal_views_id_seq OWNED BY health.portal_views.id;


--
-- Name: principle_descriptions; Type: TABLE; Schema: health; Owner: -
--

CREATE TABLE health.principle_descriptions (
    id bigint NOT NULL,
    digital_principle_id bigint,
    locale character varying NOT NULL,
    description character varying DEFAULT ''::character varying NOT NULL
);


--
-- Name: principle_descriptions_id_seq; Type: SEQUENCE; Schema: health; Owner: -
--

CREATE SEQUENCE health.principle_descriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: principle_descriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: health; Owner: -
--

ALTER SEQUENCE health.principle_descriptions_id_seq OWNED BY health.principle_descriptions.id;


--
-- Name: product_building_blocks; Type: TABLE; Schema: health; Owner: -
--

CREATE TABLE health.product_building_blocks (
    building_block_id bigint NOT NULL,
    product_id bigint NOT NULL,
    mapping_status health.mapping_status_type DEFAULT 'BETA'::health.mapping_status_type NOT NULL,
    id bigint NOT NULL,
    slug character varying NOT NULL
);


--
-- Name: product_building_blocks_id_seq; Type: SEQUENCE; Schema: health; Owner: -
--

CREATE SEQUENCE health.product_building_blocks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: product_building_blocks_id_seq; Type: SEQUENCE OWNED BY; Schema: health; Owner: -
--

ALTER SEQUENCE health.product_building_blocks_id_seq OWNED BY health.product_building_blocks.id;


--
-- Name: product_categories; Type: TABLE; Schema: health; Owner: -
--

CREATE TABLE health.product_categories (
    product_id bigint,
    software_category_id bigint
);


--
-- Name: product_classifications; Type: TABLE; Schema: health; Owner: -
--

CREATE TABLE health.product_classifications (
    id bigint NOT NULL,
    product_id bigint,
    classification_id bigint
);


--
-- Name: product_classifications_id_seq; Type: SEQUENCE; Schema: health; Owner: -
--

CREATE SEQUENCE health.product_classifications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: product_classifications_id_seq; Type: SEQUENCE OWNED BY; Schema: health; Owner: -
--

ALTER SEQUENCE health.product_classifications_id_seq OWNED BY health.product_classifications.id;


--
-- Name: product_descriptions; Type: TABLE; Schema: health; Owner: -
--

CREATE TABLE health.product_descriptions (
    id bigint NOT NULL,
    product_id bigint NOT NULL,
    locale character varying NOT NULL,
    description character varying DEFAULT ''::character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: product_descriptions_id_seq; Type: SEQUENCE; Schema: health; Owner: -
--

CREATE SEQUENCE health.product_descriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: product_descriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: health; Owner: -
--

ALTER SEQUENCE health.product_descriptions_id_seq OWNED BY health.product_descriptions.id;


--
-- Name: product_features; Type: TABLE; Schema: health; Owner: -
--

CREATE TABLE health.product_features (
    product_id bigint,
    software_feature_id bigint
);


--
-- Name: product_indicators; Type: TABLE; Schema: health; Owner: -
--

CREATE TABLE health.product_indicators (
    id bigint NOT NULL,
    product_id bigint NOT NULL,
    category_indicator_id bigint NOT NULL,
    indicator_value character varying NOT NULL,
    updated_at timestamp without time zone
);


--
-- Name: product_indicators_id_seq; Type: SEQUENCE; Schema: health; Owner: -
--

CREATE SEQUENCE health.product_indicators_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: product_indicators_id_seq; Type: SEQUENCE OWNED BY; Schema: health; Owner: -
--

ALTER SEQUENCE health.product_indicators_id_seq OWNED BY health.product_indicators.id;


--
-- Name: product_product_relationships; Type: TABLE; Schema: health; Owner: -
--

CREATE TABLE health.product_product_relationships (
    id bigint NOT NULL,
    from_product_id bigint NOT NULL,
    to_product_id bigint NOT NULL,
    relationship_type health.relationship_type NOT NULL,
    slug character varying NOT NULL
);


--
-- Name: product_product_relationships_id_seq; Type: SEQUENCE; Schema: health; Owner: -
--

CREATE SEQUENCE health.product_product_relationships_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: product_product_relationships_id_seq; Type: SEQUENCE OWNED BY; Schema: health; Owner: -
--

ALTER SEQUENCE health.product_product_relationships_id_seq OWNED BY health.product_product_relationships.id;


--
-- Name: product_repositories; Type: TABLE; Schema: health; Owner: -
--

CREATE TABLE health.product_repositories (
    id bigint NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    product_id bigint NOT NULL,
    absolute_url character varying NOT NULL,
    description character varying NOT NULL,
    main_repository boolean DEFAULT false NOT NULL,
    dpga_data jsonb DEFAULT '{}'::jsonb NOT NULL,
    language_data jsonb DEFAULT '{}'::jsonb NOT NULL,
    statistical_data jsonb DEFAULT '{}'::jsonb NOT NULL,
    license_data jsonb DEFAULT '{}'::jsonb NOT NULL,
    license character varying DEFAULT 'NA'::character varying NOT NULL,
    code_lines integer,
    cocomo integer,
    est_hosting integer,
    est_invested integer,
    updated_at timestamp without time zone NOT NULL,
    updated_by bigint,
    deleted boolean DEFAULT false NOT NULL,
    deleted_at timestamp without time zone,
    deleted_by bigint,
    created_at timestamp without time zone NOT NULL
);


--
-- Name: product_repositories_id_seq; Type: SEQUENCE; Schema: health; Owner: -
--

CREATE SEQUENCE health.product_repositories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: product_repositories_id_seq; Type: SEQUENCE OWNED BY; Schema: health; Owner: -
--

ALTER SEQUENCE health.product_repositories_id_seq OWNED BY health.product_repositories.id;


--
-- Name: product_sectors; Type: TABLE; Schema: health; Owner: -
--

CREATE TABLE health.product_sectors (
    product_id bigint NOT NULL,
    sector_id bigint NOT NULL,
    mapping_status health.mapping_status_type DEFAULT 'BETA'::health.mapping_status_type NOT NULL,
    id bigint NOT NULL,
    slug character varying NOT NULL
);


--
-- Name: product_sectors_id_seq; Type: SEQUENCE; Schema: health; Owner: -
--

CREATE SEQUENCE health.product_sectors_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: product_sectors_id_seq; Type: SEQUENCE OWNED BY; Schema: health; Owner: -
--

ALTER SEQUENCE health.product_sectors_id_seq OWNED BY health.product_sectors.id;


--
-- Name: product_sustainable_development_goals; Type: TABLE; Schema: health; Owner: -
--

CREATE TABLE health.product_sustainable_development_goals (
    product_id bigint NOT NULL,
    sustainable_development_goal_id bigint NOT NULL,
    mapping_status health.mapping_status_type DEFAULT 'BETA'::health.mapping_status_type NOT NULL,
    id bigint NOT NULL,
    slug character varying NOT NULL
);


--
-- Name: product_sustainable_development_goals_id_seq; Type: SEQUENCE; Schema: health; Owner: -
--

CREATE SEQUENCE health.product_sustainable_development_goals_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: product_sustainable_development_goals_id_seq; Type: SEQUENCE OWNED BY; Schema: health; Owner: -
--

ALTER SEQUENCE health.product_sustainable_development_goals_id_seq OWNED BY health.product_sustainable_development_goals.id;


--
-- Name: products; Type: TABLE; Schema: health; Owner: -
--

CREATE TABLE health.products (
    id bigint NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    website character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    is_launchable boolean DEFAULT false,
    start_assessment boolean DEFAULT false,
    default_url character varying DEFAULT 'http://<host_ip>'::character varying NOT NULL,
    aliases character varying[] DEFAULT '{}'::character varying[],
    tags character varying[] DEFAULT '{}'::character varying[],
    maturity_score jsonb,
    product_type character varying(20) DEFAULT 'product'::health.product_type_save,
    manual_update boolean DEFAULT false,
    commercial_product boolean DEFAULT false,
    pricing_model character varying,
    pricing_details character varying,
    hosting_model character varying,
    pricing_date date,
    pricing_url character varying,
    languages jsonb,
    gov_stack_entity boolean DEFAULT false NOT NULL,
    extra_attributes jsonb DEFAULT '[]'::jsonb,
    product_stage character varying
);


--
-- Name: products_countries; Type: TABLE; Schema: health; Owner: -
--

CREATE TABLE health.products_countries (
    id bigint NOT NULL,
    product_id bigint NOT NULL,
    country_id bigint NOT NULL
);


--
-- Name: products_countries_id_seq; Type: SEQUENCE; Schema: health; Owner: -
--

CREATE SEQUENCE health.products_countries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: products_countries_id_seq; Type: SEQUENCE OWNED BY; Schema: health; Owner: -
--

ALTER SEQUENCE health.products_countries_id_seq OWNED BY health.products_countries.id;


--
-- Name: products_endorsers; Type: TABLE; Schema: health; Owner: -
--

CREATE TABLE health.products_endorsers (
    id bigint NOT NULL,
    product_id bigint NOT NULL,
    endorser_id bigint NOT NULL
);


--
-- Name: products_endorsers_id_seq; Type: SEQUENCE; Schema: health; Owner: -
--

CREATE SEQUENCE health.products_endorsers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: products_endorsers_id_seq; Type: SEQUENCE OWNED BY; Schema: health; Owner: -
--

ALTER SEQUENCE health.products_endorsers_id_seq OWNED BY health.products_endorsers.id;


--
-- Name: products_id_seq; Type: SEQUENCE; Schema: health; Owner: -
--

CREATE SEQUENCE health.products_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: products_id_seq; Type: SEQUENCE OWNED BY; Schema: health; Owner: -
--

ALTER SEQUENCE health.products_id_seq OWNED BY health.products.id;


--
-- Name: products_origins; Type: TABLE; Schema: health; Owner: -
--

CREATE TABLE health.products_origins (
    product_id bigint NOT NULL,
    origin_id bigint NOT NULL
);


--
-- Name: products_resources; Type: TABLE; Schema: health; Owner: -
--

CREATE TABLE health.products_resources (
    product_id bigint NOT NULL,
    resource_id bigint NOT NULL
);


--
-- Name: project_descriptions; Type: TABLE; Schema: health; Owner: -
--

CREATE TABLE health.project_descriptions (
    id bigint NOT NULL,
    project_id bigint NOT NULL,
    locale character varying NOT NULL,
    description character varying DEFAULT ''::character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: project_descriptions_id_seq; Type: SEQUENCE; Schema: health; Owner: -
--

CREATE SEQUENCE health.project_descriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: project_descriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: health; Owner: -
--

ALTER SEQUENCE health.project_descriptions_id_seq OWNED BY health.project_descriptions.id;


--
-- Name: projects; Type: TABLE; Schema: health; Owner: -
--

CREATE TABLE health.projects (
    id bigint NOT NULL,
    origin_id bigint,
    start_date date,
    end_date date,
    budget numeric(12,2),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    project_url character varying,
    tags character varying[] DEFAULT '{}'::character varying[]
);


--
-- Name: projects_countries; Type: TABLE; Schema: health; Owner: -
--

CREATE TABLE health.projects_countries (
    id bigint NOT NULL,
    project_id bigint NOT NULL,
    country_id bigint NOT NULL
);


--
-- Name: projects_countries_id_seq; Type: SEQUENCE; Schema: health; Owner: -
--

CREATE SEQUENCE health.projects_countries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: projects_countries_id_seq; Type: SEQUENCE OWNED BY; Schema: health; Owner: -
--

ALTER SEQUENCE health.projects_countries_id_seq OWNED BY health.projects_countries.id;


--
-- Name: projects_digital_principles; Type: TABLE; Schema: health; Owner: -
--

CREATE TABLE health.projects_digital_principles (
    id bigint NOT NULL,
    project_id bigint NOT NULL,
    digital_principle_id bigint NOT NULL
);


--
-- Name: projects_digital_principles_id_seq; Type: SEQUENCE; Schema: health; Owner: -
--

CREATE SEQUENCE health.projects_digital_principles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: projects_digital_principles_id_seq; Type: SEQUENCE OWNED BY; Schema: health; Owner: -
--

ALTER SEQUENCE health.projects_digital_principles_id_seq OWNED BY health.projects_digital_principles.id;


--
-- Name: projects_id_seq; Type: SEQUENCE; Schema: health; Owner: -
--

CREATE SEQUENCE health.projects_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: projects_id_seq; Type: SEQUENCE OWNED BY; Schema: health; Owner: -
--

ALTER SEQUENCE health.projects_id_seq OWNED BY health.projects.id;


--
-- Name: projects_organizations; Type: TABLE; Schema: health; Owner: -
--

CREATE TABLE health.projects_organizations (
    project_id bigint NOT NULL,
    organization_id bigint NOT NULL,
    org_type health.org_type DEFAULT 'owner'::health.org_type,
    featured_project boolean DEFAULT false NOT NULL
);


--
-- Name: projects_products; Type: TABLE; Schema: health; Owner: -
--

CREATE TABLE health.projects_products (
    project_id bigint NOT NULL,
    product_id bigint NOT NULL
);


--
-- Name: projects_sdgs; Type: TABLE; Schema: health; Owner: -
--

CREATE TABLE health.projects_sdgs (
    project_id bigint NOT NULL,
    sdg_id bigint NOT NULL
);


--
-- Name: projects_sectors; Type: TABLE; Schema: health; Owner: -
--

CREATE TABLE health.projects_sectors (
    project_id bigint NOT NULL,
    sector_id bigint NOT NULL
);


--
-- Name: provinces; Type: TABLE; Schema: health; Owner: -
--

CREATE TABLE health.provinces (
    id bigint NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    country_id bigint NOT NULL,
    latitude numeric NOT NULL,
    longitude numeric NOT NULL,
    aliases character varying[] DEFAULT '{}'::character varying[],
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: provinces_id_seq; Type: SEQUENCE; Schema: health; Owner: -
--

CREATE SEQUENCE health.provinces_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: provinces_id_seq; Type: SEQUENCE OWNED BY; Schema: health; Owner: -
--

ALTER SEQUENCE health.provinces_id_seq OWNED BY health.provinces.id;


--
-- Name: regions; Type: TABLE; Schema: health; Owner: -
--

CREATE TABLE health.regions (
    id bigint NOT NULL,
    slug character varying NOT NULL,
    name character varying NOT NULL,
    description character varying NOT NULL,
    aliases character varying[] DEFAULT '{}'::character varying[],
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: regions_countries; Type: TABLE; Schema: health; Owner: -
--

CREATE TABLE health.regions_countries (
    region_id bigint NOT NULL,
    country_id bigint NOT NULL
);


--
-- Name: regions_id_seq; Type: SEQUENCE; Schema: health; Owner: -
--

CREATE SEQUENCE health.regions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: regions_id_seq; Type: SEQUENCE OWNED BY; Schema: health; Owner: -
--

ALTER SEQUENCE health.regions_id_seq OWNED BY health.regions.id;


--
-- Name: resource_building_blocks; Type: TABLE; Schema: health; Owner: -
--

CREATE TABLE health.resource_building_blocks (
    id bigint NOT NULL,
    resource_id bigint NOT NULL,
    building_block_id bigint NOT NULL,
    mapping_status health.mapping_status_type DEFAULT 'BETA'::health.mapping_status_type,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: resource_building_blocks_id_seq; Type: SEQUENCE; Schema: health; Owner: -
--

CREATE SEQUENCE health.resource_building_blocks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: resource_building_blocks_id_seq; Type: SEQUENCE OWNED BY; Schema: health; Owner: -
--

ALTER SEQUENCE health.resource_building_blocks_id_seq OWNED BY health.resource_building_blocks.id;


--
-- Name: resource_topic_descriptions; Type: TABLE; Schema: health; Owner: -
--

CREATE TABLE health.resource_topic_descriptions (
    id bigint NOT NULL,
    locale character varying NOT NULL,
    description character varying NOT NULL,
    resource_topic_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: resource_topic_descriptions_id_seq; Type: SEQUENCE; Schema: health; Owner: -
--

CREATE SEQUENCE health.resource_topic_descriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: resource_topic_descriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: health; Owner: -
--

ALTER SEQUENCE health.resource_topic_descriptions_id_seq OWNED BY health.resource_topic_descriptions.id;


--
-- Name: resource_topics; Type: TABLE; Schema: health; Owner: -
--

CREATE TABLE health.resource_topics (
    id bigint NOT NULL,
    slug character varying NOT NULL,
    name character varying NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    parent_topic_id bigint
);


--
-- Name: resource_topics_id_seq; Type: SEQUENCE; Schema: health; Owner: -
--

CREATE SEQUENCE health.resource_topics_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: resource_topics_id_seq; Type: SEQUENCE OWNED BY; Schema: health; Owner: -
--

ALTER SEQUENCE health.resource_topics_id_seq OWNED BY health.resource_topics.id;


--
-- Name: resource_types; Type: TABLE; Schema: health; Owner: -
--

CREATE TABLE health.resource_types (
    id bigint NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    description character varying NOT NULL,
    locale character varying DEFAULT 'en'::character varying NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: resource_types_id_seq; Type: SEQUENCE; Schema: health; Owner: -
--

CREATE SEQUENCE health.resource_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: resource_types_id_seq; Type: SEQUENCE OWNED BY; Schema: health; Owner: -
--

ALTER SEQUENCE health.resource_types_id_seq OWNED BY health.resource_types.id;


--
-- Name: resources; Type: TABLE; Schema: health; Owner: -
--

CREATE TABLE health.resources (
    id bigint NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    phase character varying NOT NULL,
    image_url character varying,
    resource_link character varying,
    description character varying,
    show_in_wizard boolean DEFAULT false NOT NULL,
    show_in_exchange boolean DEFAULT false NOT NULL,
    link_description character varying,
    tags character varying[] DEFAULT '{}'::character varying[],
    resource_type character varying,
    published_date timestamp(6) without time zone,
    featured boolean DEFAULT false NOT NULL,
    resource_filename character varying,
    resource_topics character varying[] DEFAULT '{}'::character varying[],
    organization_id bigint,
    submitted_by_id bigint
);


--
-- Name: resources_authors; Type: TABLE; Schema: health; Owner: -
--

CREATE TABLE health.resources_authors (
    resource_id bigint NOT NULL,
    author_id bigint NOT NULL
);


--
-- Name: resources_countries; Type: TABLE; Schema: health; Owner: -
--

CREATE TABLE health.resources_countries (
    resource_id bigint NOT NULL,
    country_id bigint NOT NULL
);


--
-- Name: resources_id_seq; Type: SEQUENCE; Schema: health; Owner: -
--

CREATE SEQUENCE health.resources_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: resources_id_seq; Type: SEQUENCE OWNED BY; Schema: health; Owner: -
--

ALTER SEQUENCE health.resources_id_seq OWNED BY health.resources.id;


--
-- Name: resources_use_cases; Type: TABLE; Schema: health; Owner: -
--

CREATE TABLE health.resources_use_cases (
    id bigint NOT NULL,
    resource_id bigint NOT NULL,
    use_case_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: resources_use_cases_id_seq; Type: SEQUENCE; Schema: health; Owner: -
--

CREATE SEQUENCE health.resources_use_cases_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: resources_use_cases_id_seq; Type: SEQUENCE OWNED BY; Schema: health; Owner: -
--

ALTER SEQUENCE health.resources_use_cases_id_seq OWNED BY health.resources_use_cases.id;


--
-- Name: rubric_categories; Type: TABLE; Schema: health; Owner: -
--

CREATE TABLE health.rubric_categories (
    id bigint NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    weight numeric DEFAULT 0 NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: rubric_categories_id_seq; Type: SEQUENCE; Schema: health; Owner: -
--

CREATE SEQUENCE health.rubric_categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: rubric_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: health; Owner: -
--

ALTER SEQUENCE health.rubric_categories_id_seq OWNED BY health.rubric_categories.id;


--
-- Name: rubric_category_descriptions; Type: TABLE; Schema: health; Owner: -
--

CREATE TABLE health.rubric_category_descriptions (
    id bigint NOT NULL,
    rubric_category_id bigint NOT NULL,
    locale character varying NOT NULL,
    description character varying DEFAULT ''::character varying NOT NULL
);


--
-- Name: rubric_category_descriptions_id_seq; Type: SEQUENCE; Schema: health; Owner: -
--

CREATE SEQUENCE health.rubric_category_descriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: rubric_category_descriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: health; Owner: -
--

ALTER SEQUENCE health.rubric_category_descriptions_id_seq OWNED BY health.rubric_category_descriptions.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: health; Owner: -
--

CREATE TABLE health.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: sdg_targets; Type: TABLE; Schema: health; Owner: -
--

CREATE TABLE health.sdg_targets (
    id bigint NOT NULL,
    name character varying NOT NULL,
    target_number character varying NOT NULL,
    slug character varying,
    sdg_number integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: sdg_targets_id_seq; Type: SEQUENCE; Schema: health; Owner: -
--

CREATE SEQUENCE health.sdg_targets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sdg_targets_id_seq; Type: SEQUENCE OWNED BY; Schema: health; Owner: -
--

ALTER SEQUENCE health.sdg_targets_id_seq OWNED BY health.sdg_targets.id;


--
-- Name: sectors; Type: TABLE; Schema: health; Owner: -
--

CREATE TABLE health.sectors (
    id bigint NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    is_displayable boolean,
    parent_sector_id bigint,
    origin_id bigint,
    locale character varying DEFAULT 'en'::character varying
);


--
-- Name: sectors_id_seq; Type: SEQUENCE; Schema: health; Owner: -
--

CREATE SEQUENCE health.sectors_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sectors_id_seq; Type: SEQUENCE OWNED BY; Schema: health; Owner: -
--

ALTER SEQUENCE health.sectors_id_seq OWNED BY health.sectors.id;


--
-- Name: sessions; Type: TABLE; Schema: health; Owner: -
--

CREATE TABLE health.sessions (
    id bigint NOT NULL,
    session_id character varying NOT NULL,
    data text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: sessions_id_seq; Type: SEQUENCE; Schema: health; Owner: -
--

CREATE SEQUENCE health.sessions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sessions_id_seq; Type: SEQUENCE OWNED BY; Schema: health; Owner: -
--

ALTER SEQUENCE health.sessions_id_seq OWNED BY health.sessions.id;


--
-- Name: settings; Type: TABLE; Schema: health; Owner: -
--

CREATE TABLE health.settings (
    id bigint NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    description character varying NOT NULL,
    value text NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: settings_id_seq; Type: SEQUENCE; Schema: health; Owner: -
--

CREATE SEQUENCE health.settings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: settings_id_seq; Type: SEQUENCE OWNED BY; Schema: health; Owner: -
--

ALTER SEQUENCE health.settings_id_seq OWNED BY health.settings.id;


--
-- Name: software_categories; Type: TABLE; Schema: health; Owner: -
--

CREATE TABLE health.software_categories (
    id bigint NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    description character varying NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: software_categories_id_seq; Type: SEQUENCE; Schema: health; Owner: -
--

CREATE SEQUENCE health.software_categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: software_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: health; Owner: -
--

ALTER SEQUENCE health.software_categories_id_seq OWNED BY health.software_categories.id;


--
-- Name: software_features; Type: TABLE; Schema: health; Owner: -
--

CREATE TABLE health.software_features (
    id bigint NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    description character varying NOT NULL,
    facility_scale integer,
    software_category_id bigint,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: software_features_id_seq; Type: SEQUENCE; Schema: health; Owner: -
--

CREATE SEQUENCE health.software_features_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: software_features_id_seq; Type: SEQUENCE OWNED BY; Schema: health; Owner: -
--

ALTER SEQUENCE health.software_features_id_seq OWNED BY health.software_features.id;


--
-- Name: starred_objects; Type: TABLE; Schema: health; Owner: -
--

CREATE TABLE health.starred_objects (
    id bigint NOT NULL,
    starred_object_type character varying NOT NULL,
    starred_object_value character varying NOT NULL,
    source_object_type character varying NOT NULL,
    source_object_value character varying NOT NULL,
    starred_by_id bigint,
    starred_date timestamp(6) without time zone NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: starred_objects_id_seq; Type: SEQUENCE; Schema: health; Owner: -
--

CREATE SEQUENCE health.starred_objects_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: starred_objects_id_seq; Type: SEQUENCE OWNED BY; Schema: health; Owner: -
--

ALTER SEQUENCE health.starred_objects_id_seq OWNED BY health.starred_objects.id;


--
-- Name: stylesheets; Type: TABLE; Schema: health; Owner: -
--

CREATE TABLE health.stylesheets (
    id bigint NOT NULL,
    portal character varying,
    background_color character varying,
    about_page character varying DEFAULT ''::character varying NOT NULL,
    footer_content character varying DEFAULT ''::character varying NOT NULL,
    header_logo character varying
);


--
-- Name: stylesheets_id_seq; Type: SEQUENCE; Schema: health; Owner: -
--

CREATE SEQUENCE health.stylesheets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: stylesheets_id_seq; Type: SEQUENCE OWNED BY; Schema: health; Owner: -
--

ALTER SEQUENCE health.stylesheets_id_seq OWNED BY health.stylesheets.id;


--
-- Name: sustainable_development_goals; Type: TABLE; Schema: health; Owner: -
--

CREATE TABLE health.sustainable_development_goals (
    id bigint NOT NULL,
    slug character varying NOT NULL,
    name character varying NOT NULL,
    long_title character varying NOT NULL,
    number integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: sustainable_development_goals_id_seq; Type: SEQUENCE; Schema: health; Owner: -
--

CREATE SEQUENCE health.sustainable_development_goals_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sustainable_development_goals_id_seq; Type: SEQUENCE OWNED BY; Schema: health; Owner: -
--

ALTER SEQUENCE health.sustainable_development_goals_id_seq OWNED BY health.sustainable_development_goals.id;


--
-- Name: tag_descriptions; Type: TABLE; Schema: health; Owner: -
--

CREATE TABLE health.tag_descriptions (
    id bigint NOT NULL,
    tag_id bigint NOT NULL,
    locale character varying NOT NULL,
    description character varying DEFAULT ''::character varying NOT NULL
);


--
-- Name: tag_descriptions_id_seq; Type: SEQUENCE; Schema: health; Owner: -
--

CREATE SEQUENCE health.tag_descriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tag_descriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: health; Owner: -
--

ALTER SEQUENCE health.tag_descriptions_id_seq OWNED BY health.tag_descriptions.id;


--
-- Name: tags; Type: TABLE; Schema: health; Owner: -
--

CREATE TABLE health.tags (
    id bigint NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: tags_id_seq; Type: SEQUENCE; Schema: health; Owner: -
--

CREATE SEQUENCE health.tags_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tags_id_seq; Type: SEQUENCE OWNED BY; Schema: health; Owner: -
--

ALTER SEQUENCE health.tags_id_seq OWNED BY health.tags.id;


--
-- Name: task_tracker_descriptions; Type: TABLE; Schema: health; Owner: -
--

CREATE TABLE health.task_tracker_descriptions (
    id bigint NOT NULL,
    task_tracker_id bigint NOT NULL,
    locale character varying NOT NULL,
    description character varying DEFAULT '{}'::jsonb NOT NULL
);


--
-- Name: task_tracker_descriptions_id_seq; Type: SEQUENCE; Schema: health; Owner: -
--

CREATE SEQUENCE health.task_tracker_descriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: task_tracker_descriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: health; Owner: -
--

ALTER SEQUENCE health.task_tracker_descriptions_id_seq OWNED BY health.task_tracker_descriptions.id;


--
-- Name: task_trackers; Type: TABLE; Schema: health; Owner: -
--

CREATE TABLE health.task_trackers (
    id bigint NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    last_started_date timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    last_received_message character varying NOT NULL,
    task_completed boolean DEFAULT false NOT NULL
);


--
-- Name: task_trackers_id_seq; Type: SEQUENCE; Schema: health; Owner: -
--

CREATE SEQUENCE health.task_trackers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: task_trackers_id_seq; Type: SEQUENCE OWNED BY; Schema: health; Owner: -
--

ALTER SEQUENCE health.task_trackers_id_seq OWNED BY health.task_trackers.id;


--
-- Name: tenant_sync_configurations; Type: TABLE; Schema: health; Owner: -
--

CREATE TABLE health.tenant_sync_configurations (
    id bigint NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    description character varying NOT NULL,
    tenant_source character varying NOT NULL,
    tenant_destination character varying NOT NULL,
    sync_enabled boolean DEFAULT true NOT NULL,
    sync_configuration json DEFAULT '{}'::json NOT NULL,
    last_sync_at timestamp(6) without time zone,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: tenant_sync_configurations_id_seq; Type: SEQUENCE; Schema: health; Owner: -
--

CREATE SEQUENCE health.tenant_sync_configurations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tenant_sync_configurations_id_seq; Type: SEQUENCE OWNED BY; Schema: health; Owner: -
--

ALTER SEQUENCE health.tenant_sync_configurations_id_seq OWNED BY health.tenant_sync_configurations.id;


--
-- Name: use_case_descriptions; Type: TABLE; Schema: health; Owner: -
--

CREATE TABLE health.use_case_descriptions (
    id bigint NOT NULL,
    use_case_id bigint NOT NULL,
    locale character varying NOT NULL,
    description character varying DEFAULT ''::character varying NOT NULL
);


--
-- Name: use_case_descriptions_id_seq; Type: SEQUENCE; Schema: health; Owner: -
--

CREATE SEQUENCE health.use_case_descriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: use_case_descriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: health; Owner: -
--

ALTER SEQUENCE health.use_case_descriptions_id_seq OWNED BY health.use_case_descriptions.id;


--
-- Name: use_case_headers; Type: TABLE; Schema: health; Owner: -
--

CREATE TABLE health.use_case_headers (
    id bigint NOT NULL,
    use_case_id bigint NOT NULL,
    locale character varying NOT NULL,
    header character varying DEFAULT ''::character varying NOT NULL
);


--
-- Name: use_case_headers_id_seq; Type: SEQUENCE; Schema: health; Owner: -
--

CREATE SEQUENCE health.use_case_headers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: use_case_headers_id_seq; Type: SEQUENCE OWNED BY; Schema: health; Owner: -
--

ALTER SEQUENCE health.use_case_headers_id_seq OWNED BY health.use_case_headers.id;


--
-- Name: use_case_step_descriptions; Type: TABLE; Schema: health; Owner: -
--

CREATE TABLE health.use_case_step_descriptions (
    id bigint NOT NULL,
    use_case_step_id bigint NOT NULL,
    locale character varying NOT NULL,
    description character varying DEFAULT ''::character varying NOT NULL
);


--
-- Name: use_case_step_descriptions_id_seq; Type: SEQUENCE; Schema: health; Owner: -
--

CREATE SEQUENCE health.use_case_step_descriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: use_case_step_descriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: health; Owner: -
--

ALTER SEQUENCE health.use_case_step_descriptions_id_seq OWNED BY health.use_case_step_descriptions.id;


--
-- Name: use_case_steps; Type: TABLE; Schema: health; Owner: -
--

CREATE TABLE health.use_case_steps (
    id bigint NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    step_number integer NOT NULL,
    use_case_id bigint NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    example_implementation character varying
);


--
-- Name: use_case_steps_building_blocks; Type: TABLE; Schema: health; Owner: -
--

CREATE TABLE health.use_case_steps_building_blocks (
    id bigint NOT NULL,
    use_case_step_id bigint NOT NULL,
    building_block_id bigint NOT NULL
);


--
-- Name: use_case_steps_building_blocks_id_seq; Type: SEQUENCE; Schema: health; Owner: -
--

CREATE SEQUENCE health.use_case_steps_building_blocks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: use_case_steps_building_blocks_id_seq; Type: SEQUENCE OWNED BY; Schema: health; Owner: -
--

ALTER SEQUENCE health.use_case_steps_building_blocks_id_seq OWNED BY health.use_case_steps_building_blocks.id;


--
-- Name: use_case_steps_datasets; Type: TABLE; Schema: health; Owner: -
--

CREATE TABLE health.use_case_steps_datasets (
    id bigint NOT NULL,
    use_case_step_id bigint NOT NULL,
    dataset_id bigint NOT NULL
);


--
-- Name: use_case_steps_datasets_id_seq; Type: SEQUENCE; Schema: health; Owner: -
--

CREATE SEQUENCE health.use_case_steps_datasets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: use_case_steps_datasets_id_seq; Type: SEQUENCE OWNED BY; Schema: health; Owner: -
--

ALTER SEQUENCE health.use_case_steps_datasets_id_seq OWNED BY health.use_case_steps_datasets.id;


--
-- Name: use_case_steps_id_seq; Type: SEQUENCE; Schema: health; Owner: -
--

CREATE SEQUENCE health.use_case_steps_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: use_case_steps_id_seq; Type: SEQUENCE OWNED BY; Schema: health; Owner: -
--

ALTER SEQUENCE health.use_case_steps_id_seq OWNED BY health.use_case_steps.id;


--
-- Name: use_case_steps_products; Type: TABLE; Schema: health; Owner: -
--

CREATE TABLE health.use_case_steps_products (
    id bigint NOT NULL,
    use_case_step_id bigint NOT NULL,
    product_id bigint NOT NULL
);


--
-- Name: use_case_steps_products_id_seq; Type: SEQUENCE; Schema: health; Owner: -
--

CREATE SEQUENCE health.use_case_steps_products_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: use_case_steps_products_id_seq; Type: SEQUENCE OWNED BY; Schema: health; Owner: -
--

ALTER SEQUENCE health.use_case_steps_products_id_seq OWNED BY health.use_case_steps_products.id;


--
-- Name: use_case_steps_workflows; Type: TABLE; Schema: health; Owner: -
--

CREATE TABLE health.use_case_steps_workflows (
    use_case_step_id bigint NOT NULL,
    workflow_id bigint NOT NULL
);


--
-- Name: use_cases; Type: TABLE; Schema: health; Owner: -
--

CREATE TABLE health.use_cases (
    id bigint NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    sector_id bigint NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    description jsonb DEFAULT '{}'::jsonb NOT NULL,
    maturity health.entity_status_type DEFAULT 'DRAFT'::health.entity_status_type NOT NULL,
    tags character varying[] DEFAULT '{}'::character varying[],
    markdown_url character varying,
    gov_stack_entity boolean DEFAULT false NOT NULL
);


--
-- Name: use_cases_id_seq; Type: SEQUENCE; Schema: health; Owner: -
--

CREATE SEQUENCE health.use_cases_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: use_cases_id_seq; Type: SEQUENCE OWNED BY; Schema: health; Owner: -
--

ALTER SEQUENCE health.use_cases_id_seq OWNED BY health.use_cases.id;


--
-- Name: use_cases_sdg_targets; Type: TABLE; Schema: health; Owner: -
--

CREATE TABLE health.use_cases_sdg_targets (
    use_case_id bigint NOT NULL,
    sdg_target_id bigint NOT NULL
);


--
-- Name: user_events; Type: TABLE; Schema: health; Owner: -
--

CREATE TABLE health.user_events (
    id bigint NOT NULL,
    identifier character varying NOT NULL,
    email character varying,
    event_datetime timestamp without time zone NOT NULL,
    event_type character varying NOT NULL,
    extended_data jsonb DEFAULT '{}'::jsonb NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: user_events_id_seq; Type: SEQUENCE; Schema: health; Owner: -
--

CREATE SEQUENCE health.user_events_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: user_events_id_seq; Type: SEQUENCE OWNED BY; Schema: health; Owner: -
--

ALTER SEQUENCE health.user_events_id_seq OWNED BY health.user_events.id;


--
-- Name: user_messages; Type: TABLE; Schema: health; Owner: -
--

CREATE TABLE health.user_messages (
    id bigint NOT NULL,
    message_id bigint NOT NULL,
    received_by_id bigint NOT NULL,
    read boolean DEFAULT false NOT NULL,
    visible boolean DEFAULT false NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: user_messages_id_seq; Type: SEQUENCE; Schema: health; Owner: -
--

CREATE SEQUENCE health.user_messages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: user_messages_id_seq; Type: SEQUENCE OWNED BY; Schema: health; Owner: -
--

ALTER SEQUENCE health.user_messages_id_seq OWNED BY health.user_messages.id;


--
-- Name: users; Type: TABLE; Schema: health; Owner: -
--

CREATE TABLE health.users (
    id bigint NOT NULL,
    email character varying DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    confirmation_token character varying,
    confirmed_at timestamp without time zone,
    confirmation_sent_at timestamp without time zone,
    unconfirmed_email character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    receive_backup boolean DEFAULT false,
    organization_id bigint,
    expired boolean,
    expired_at timestamp without time zone,
    saved_products bigint[] DEFAULT '{}'::bigint[],
    saved_use_cases bigint[] DEFAULT '{}'::bigint[],
    saved_projects bigint[] DEFAULT '{}'::bigint[],
    saved_urls character varying[] DEFAULT '{}'::character varying[],
    roles health.user_role[] DEFAULT '{}'::health.user_role[],
    authentication_token text,
    authentication_token_created_at timestamp without time zone,
    user_products bigint[] DEFAULT '{}'::bigint[],
    receive_admin_emails boolean DEFAULT false,
    username character varying,
    user_datasets bigint[] DEFAULT '{}'::bigint[],
    saved_building_blocks bigint[] DEFAULT '{}'::bigint[] NOT NULL
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: health; Owner: -
--

CREATE SEQUENCE health.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: health; Owner: -
--

ALTER SEQUENCE health.users_id_seq OWNED BY health.users.id;


--
-- Name: workflow_descriptions; Type: TABLE; Schema: health; Owner: -
--

CREATE TABLE health.workflow_descriptions (
    id bigint NOT NULL,
    workflow_id bigint NOT NULL,
    locale character varying NOT NULL,
    description character varying DEFAULT ''::character varying NOT NULL
);


--
-- Name: workflow_descriptions_id_seq; Type: SEQUENCE; Schema: health; Owner: -
--

CREATE SEQUENCE health.workflow_descriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: workflow_descriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: health; Owner: -
--

ALTER SEQUENCE health.workflow_descriptions_id_seq OWNED BY health.workflow_descriptions.id;


--
-- Name: workflows; Type: TABLE; Schema: health; Owner: -
--

CREATE TABLE health.workflows (
    id bigint NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    description jsonb DEFAULT '{}'::jsonb NOT NULL
);


--
-- Name: workflows_building_blocks; Type: TABLE; Schema: health; Owner: -
--

CREATE TABLE health.workflows_building_blocks (
    workflow_id bigint NOT NULL,
    building_block_id bigint NOT NULL
);


--
-- Name: workflows_id_seq; Type: SEQUENCE; Schema: health; Owner: -
--

CREATE SEQUENCE health.workflows_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: workflows_id_seq; Type: SEQUENCE OWNED BY; Schema: health; Owner: -
--

ALTER SEQUENCE health.workflows_id_seq OWNED BY health.workflows.id;


--
-- Name: workflows_use_cases; Type: TABLE; Schema: health; Owner: -
--

CREATE TABLE health.workflows_use_cases (
    workflow_id bigint NOT NULL,
    use_case_id bigint NOT NULL
);


--
-- Name: aggregator_capabilities; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.aggregator_capabilities (
    id bigint NOT NULL,
    aggregator_id bigint,
    operator_services_id bigint,
    service public.mobile_services,
    capability public.agg_capabilities,
    country_name character varying,
    country_id bigint
);


--
-- Name: aggregator_capabilities_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.aggregator_capabilities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: aggregator_capabilities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.aggregator_capabilities_id_seq OWNED BY public.aggregator_capabilities.id;


--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: audits; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.audits (
    id bigint NOT NULL,
    associated_id character varying,
    associated_type character varying,
    user_id integer,
    user_role character varying,
    username character varying,
    action character varying,
    audit_changes jsonb,
    version integer DEFAULT 0,
    comment character varying,
    created_at timestamp without time zone
);


--
-- Name: audits_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.audits_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: audits_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.audits_id_seq OWNED BY public.audits.id;


--
-- Name: authors; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.authors (
    id bigint NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    email character varying,
    picture character varying NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: authors_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.authors_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: authors_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.authors_id_seq OWNED BY public.authors.id;


--
-- Name: building_block_descriptions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.building_block_descriptions (
    id bigint NOT NULL,
    building_block_id bigint NOT NULL,
    locale character varying NOT NULL,
    description character varying DEFAULT ''::character varying NOT NULL
);


--
-- Name: building_block_descriptions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.building_block_descriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: building_block_descriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.building_block_descriptions_id_seq OWNED BY public.building_block_descriptions.id;


--
-- Name: building_blocks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.building_blocks (
    id bigint NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    description jsonb DEFAULT '{}'::jsonb NOT NULL,
    maturity public.entity_status_type DEFAULT 'DRAFT'::public.entity_status_type NOT NULL,
    spec_url character varying,
    category public.category_type,
    display_order integer DEFAULT 0 NOT NULL,
    gov_stack_entity boolean DEFAULT false NOT NULL
);


--
-- Name: building_blocks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.building_blocks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: building_blocks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.building_blocks_id_seq OWNED BY public.building_blocks.id;


--
-- Name: candidate_datasets; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.candidate_datasets (
    id bigint NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    website character varying NOT NULL,
    visualization_url character varying,
    dataset_type character varying NOT NULL,
    submitter_email character varying NOT NULL,
    description character varying NOT NULL,
    rejected boolean,
    rejected_date timestamp without time zone,
    rejected_by_id bigint,
    approved_date timestamp without time zone,
    approved_by_id bigint,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: candidate_datasets_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.candidate_datasets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: candidate_datasets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.candidate_datasets_id_seq OWNED BY public.candidate_datasets.id;


--
-- Name: candidate_organizations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.candidate_organizations (
    id bigint NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    website text,
    rejected boolean,
    rejected_date timestamp without time zone,
    rejected_by_id bigint,
    approved_date timestamp without time zone,
    approved_by_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    description character varying,
    create_storefront boolean DEFAULT false NOT NULL
);


--
-- Name: candidate_organizations_contacts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.candidate_organizations_contacts (
    candidate_organization_id bigint NOT NULL,
    contact_id bigint NOT NULL,
    started_at timestamp without time zone,
    ended_at timestamp without time zone
);


--
-- Name: candidate_organizations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.candidate_organizations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: candidate_organizations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.candidate_organizations_id_seq OWNED BY public.candidate_organizations.id;


--
-- Name: candidate_products; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.candidate_products (
    id bigint NOT NULL,
    slug character varying NOT NULL,
    name character varying NOT NULL,
    website character varying NOT NULL,
    repository character varying NOT NULL,
    submitter_email character varying NOT NULL,
    rejected boolean,
    rejected_date timestamp without time zone,
    rejected_by_id bigint,
    approved_date timestamp without time zone,
    approved_by_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    description character varying,
    commercial_product boolean DEFAULT false NOT NULL
);


--
-- Name: candidate_products_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.candidate_products_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: candidate_products_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.candidate_products_id_seq OWNED BY public.candidate_products.id;


--
-- Name: candidate_resources; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.candidate_resources (
    id bigint NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    description character varying NOT NULL,
    published_date timestamp(6) without time zone DEFAULT '2024-08-27 00:00:00'::timestamp without time zone NOT NULL,
    resource_type character varying NOT NULL,
    resource_link character varying NOT NULL,
    link_description character varying NOT NULL,
    submitter_email character varying NOT NULL,
    rejected boolean,
    rejected_date timestamp(6) without time zone,
    rejected_by_id bigint,
    approved_date timestamp(6) without time zone,
    approved_by_id bigint,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: candidate_resources_countries; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.candidate_resources_countries (
    id bigint NOT NULL,
    candidate_resource_id bigint NOT NULL,
    country_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: candidate_resources_countries_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.candidate_resources_countries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: candidate_resources_countries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.candidate_resources_countries_id_seq OWNED BY public.candidate_resources_countries.id;


--
-- Name: candidate_resources_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.candidate_resources_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: candidate_resources_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.candidate_resources_id_seq OWNED BY public.candidate_resources.id;


--
-- Name: candidate_roles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.candidate_roles (
    id bigint NOT NULL,
    email character varying NOT NULL,
    roles public.user_role[] DEFAULT '{}'::public.user_role[],
    description character varying NOT NULL,
    rejected boolean,
    rejected_date timestamp without time zone,
    rejected_by_id bigint,
    approved_date timestamp without time zone,
    approved_by_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    product_id integer,
    organization_id integer,
    dataset_id bigint
);


--
-- Name: candidate_roles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.candidate_roles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: candidate_roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.candidate_roles_id_seq OWNED BY public.candidate_roles.id;


--
-- Name: category_indicator_descriptions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.category_indicator_descriptions (
    id bigint NOT NULL,
    category_indicator_id bigint NOT NULL,
    locale character varying NOT NULL,
    description character varying DEFAULT ''::character varying NOT NULL
);


--
-- Name: category_indicator_descriptions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.category_indicator_descriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: category_indicator_descriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.category_indicator_descriptions_id_seq OWNED BY public.category_indicator_descriptions.id;


--
-- Name: category_indicators; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.category_indicators (
    id bigint NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    indicator_type public.category_indicator_type,
    weight numeric DEFAULT 0 NOT NULL,
    rubric_category_id bigint,
    data_source character varying,
    source_indicator character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    script_name character varying
);


--
-- Name: category_indicators_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.category_indicators_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: category_indicators_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.category_indicators_id_seq OWNED BY public.category_indicators.id;


--
-- Name: chatbot_conversations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.chatbot_conversations (
    id bigint NOT NULL,
    identifier character varying NOT NULL,
    session_identifier character varying NOT NULL,
    chatbot_question character varying NOT NULL,
    chatbot_answer character varying NOT NULL,
    user_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    chatbot_response jsonb DEFAULT '{}'::jsonb
);


--
-- Name: chatbot_conversations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.chatbot_conversations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: chatbot_conversations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.chatbot_conversations_id_seq OWNED BY public.chatbot_conversations.id;


--
-- Name: cities; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.cities (
    id bigint NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    province_id bigint,
    latitude numeric NOT NULL,
    longitude numeric NOT NULL,
    aliases character varying[] DEFAULT '{}'::character varying[],
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: cities_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.cities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.cities_id_seq OWNED BY public.cities.id;


--
-- Name: ckeditor_assets; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ckeditor_assets (
    id bigint NOT NULL,
    data_file_name character varying NOT NULL,
    data_content_type character varying,
    data_file_size integer,
    type character varying(30),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: ckeditor_assets_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.ckeditor_assets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ckeditor_assets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.ckeditor_assets_id_seq OWNED BY public.ckeditor_assets.id;


--
-- Name: classifications; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.classifications (
    id bigint NOT NULL,
    name character varying,
    indicator character varying,
    description character varying,
    source character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: classifications_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.classifications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: classifications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.classifications_id_seq OWNED BY public.classifications.id;


--
-- Name: comments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.comments (
    id bigint NOT NULL,
    comment_object_id integer NOT NULL,
    author jsonb NOT NULL,
    text character varying NOT NULL,
    comment_id character varying NOT NULL,
    parent_comment_id character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    comment_object_type public.comment_object_type NOT NULL
);


--
-- Name: comments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.comments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: comments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.comments_id_seq OWNED BY public.comments.id;


--
-- Name: contacts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.contacts (
    id bigint NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    email character varying,
    title character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    biography text,
    social_networking_services jsonb DEFAULT '[]'::jsonb,
    source character varying DEFAULT 'exchange'::character varying,
    extended_data jsonb DEFAULT '[]'::jsonb
);


--
-- Name: contacts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.contacts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: contacts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.contacts_id_seq OWNED BY public.contacts.id;


--
-- Name: countries; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.countries (
    id bigint NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    code character varying NOT NULL,
    code_longer character varying NOT NULL,
    latitude numeric NOT NULL,
    longitude numeric NOT NULL,
    aliases character varying[] DEFAULT '{}'::character varying[],
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    description character varying
);


--
-- Name: countries_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.countries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: countries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.countries_id_seq OWNED BY public.countries.id;


--
-- Name: dataset_descriptions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dataset_descriptions (
    id bigint NOT NULL,
    dataset_id bigint,
    locale character varying NOT NULL,
    description character varying DEFAULT ''::character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: dataset_descriptions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.dataset_descriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: dataset_descriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.dataset_descriptions_id_seq OWNED BY public.dataset_descriptions.id;


--
-- Name: dataset_sectors; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dataset_sectors (
    id bigint NOT NULL,
    dataset_id bigint NOT NULL,
    sector_id bigint NOT NULL,
    mapping_status public.mapping_status_type DEFAULT 'BETA'::public.mapping_status_type NOT NULL,
    slug character varying NOT NULL
);


--
-- Name: dataset_sectors_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.dataset_sectors_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: dataset_sectors_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.dataset_sectors_id_seq OWNED BY public.dataset_sectors.id;


--
-- Name: dataset_sustainable_development_goals; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dataset_sustainable_development_goals (
    id bigint NOT NULL,
    dataset_id bigint NOT NULL,
    sustainable_development_goal_id bigint NOT NULL,
    mapping_status public.mapping_status_type DEFAULT 'BETA'::public.mapping_status_type NOT NULL,
    slug character varying NOT NULL
);


--
-- Name: dataset_sustainable_development_goals_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.dataset_sustainable_development_goals_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: dataset_sustainable_development_goals_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.dataset_sustainable_development_goals_id_seq OWNED BY public.dataset_sustainable_development_goals.id;


--
-- Name: datasets; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.datasets (
    id bigint NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    aliases character varying[] DEFAULT '{}'::character varying[],
    website character varying NOT NULL,
    visualization_url character varying,
    tags character varying[] DEFAULT '{}'::character varying[],
    dataset_type character varying NOT NULL,
    geographic_coverage character varying,
    time_range character varying,
    manual_update boolean DEFAULT false,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    license character varying,
    languages character varying,
    data_format character varying
);


--
-- Name: datasets_countries; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.datasets_countries (
    id bigint NOT NULL,
    dataset_id bigint NOT NULL,
    country_id bigint NOT NULL
);


--
-- Name: datasets_countries_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.datasets_countries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: datasets_countries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.datasets_countries_id_seq OWNED BY public.datasets_countries.id;


--
-- Name: datasets_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.datasets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: datasets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.datasets_id_seq OWNED BY public.datasets.id;


--
-- Name: datasets_origins; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.datasets_origins (
    id bigint NOT NULL,
    dataset_id bigint NOT NULL,
    origin_id bigint NOT NULL
);


--
-- Name: datasets_origins_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.datasets_origins_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: datasets_origins_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.datasets_origins_id_seq OWNED BY public.datasets_origins.id;


--
-- Name: deploys; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.deploys (
    id bigint NOT NULL,
    user_id bigint,
    product_id bigint,
    provider character varying,
    instance_name character varying,
    auth_token character varying,
    status character varying,
    message character varying,
    url character varying,
    suite character varying,
    job_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: deploys_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.deploys_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: deploys_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.deploys_id_seq OWNED BY public.deploys.id;


--
-- Name: dial_spreadsheet_data; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dial_spreadsheet_data (
    id bigint NOT NULL,
    slug character varying NOT NULL,
    spreadsheet_type character varying NOT NULL,
    spreadsheet_data jsonb DEFAULT '{}'::jsonb NOT NULL,
    deleted boolean DEFAULT false NOT NULL,
    updated_by bigint,
    updated_date timestamp without time zone
);


--
-- Name: dial_spreadsheet_data_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.dial_spreadsheet_data_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: dial_spreadsheet_data_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.dial_spreadsheet_data_id_seq OWNED BY public.dial_spreadsheet_data.id;


--
-- Name: digital_principles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.digital_principles (
    id bigint NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    url character varying NOT NULL,
    phase character varying
);


--
-- Name: digital_principles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.digital_principles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: digital_principles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.digital_principles_id_seq OWNED BY public.digital_principles.id;


--
-- Name: districts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.districts (
    id bigint NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    province_id bigint NOT NULL,
    latitude numeric NOT NULL,
    longitude numeric NOT NULL,
    aliases character varying[] DEFAULT '{}'::character varying[],
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: districts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.districts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: districts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.districts_id_seq OWNED BY public.districts.id;


--
-- Name: endorsers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.endorsers (
    id bigint NOT NULL,
    slug character varying NOT NULL,
    name character varying NOT NULL,
    description character varying
);


--
-- Name: endorsers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.endorsers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: endorsers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.endorsers_id_seq OWNED BY public.endorsers.id;


--
-- Name: exchange_tenants; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.exchange_tenants (
    id bigint NOT NULL,
    tenant_name character varying,
    domain character varying,
    postgres_config jsonb,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    allow_unsecure_read boolean DEFAULT true NOT NULL
);


--
-- Name: exchange_tenants_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.exchange_tenants_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: exchange_tenants_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.exchange_tenants_id_seq OWNED BY public.exchange_tenants.id;


--
-- Name: froala_images; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.froala_images (
    id bigint NOT NULL,
    picture character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: froala_images_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.froala_images_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: froala_images_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.froala_images_id_seq OWNED BY public.froala_images.id;


--
-- Name: glossaries; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.glossaries (
    id bigint NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    locale character varying NOT NULL,
    description character varying DEFAULT ''::character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: glossaries_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.glossaries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: glossaries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.glossaries_id_seq OWNED BY public.glossaries.id;


--
-- Name: handbook_answers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.handbook_answers (
    id bigint NOT NULL,
    answer_text character varying NOT NULL,
    action character varying NOT NULL,
    locale character varying DEFAULT 'en'::character varying NOT NULL,
    handbook_question_id bigint
);


--
-- Name: handbook_answers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.handbook_answers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: handbook_answers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.handbook_answers_id_seq OWNED BY public.handbook_answers.id;


--
-- Name: handbook_descriptions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.handbook_descriptions (
    id bigint NOT NULL,
    handbook_id bigint,
    locale character varying NOT NULL,
    overview character varying DEFAULT ''::character varying NOT NULL,
    audience character varying DEFAULT ''::character varying NOT NULL,
    outcomes character varying DEFAULT ''::character varying NOT NULL,
    cover character varying
);


--
-- Name: handbook_descriptions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.handbook_descriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: handbook_descriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.handbook_descriptions_id_seq OWNED BY public.handbook_descriptions.id;


--
-- Name: handbook_pages; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.handbook_pages (
    id bigint NOT NULL,
    handbook_id bigint NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    phase character varying,
    page_order integer,
    parent_page_id bigint,
    handbook_questions_id bigint,
    resources jsonb DEFAULT '[]'::jsonb NOT NULL,
    media_url character varying
);


--
-- Name: handbook_pages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.handbook_pages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: handbook_pages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.handbook_pages_id_seq OWNED BY public.handbook_pages.id;


--
-- Name: handbook_questions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.handbook_questions (
    id bigint NOT NULL,
    question_text character varying NOT NULL,
    locale character varying DEFAULT 'en'::character varying NOT NULL,
    handbook_page_id bigint
);


--
-- Name: handbook_questions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.handbook_questions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: handbook_questions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.handbook_questions_id_seq OWNED BY public.handbook_questions.id;


--
-- Name: handbooks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.handbooks (
    id bigint NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    phases jsonb DEFAULT '[]'::jsonb NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    maturity character varying DEFAULT 'Beta'::character varying,
    pdf_url character varying
);


--
-- Name: handbooks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.handbooks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: handbooks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.handbooks_id_seq OWNED BY public.handbooks.id;


--
-- Name: messages; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.messages (
    id bigint NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    message_type character varying NOT NULL,
    message_template character varying NOT NULL,
    message_datetime timestamp(6) without time zone NOT NULL,
    visible boolean DEFAULT false NOT NULL,
    location character varying,
    location_type character varying,
    created_by_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: messages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.messages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: messages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.messages_id_seq OWNED BY public.messages.id;


--
-- Name: offices; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.offices (
    id bigint NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    latitude numeric NOT NULL,
    longitude numeric NOT NULL,
    city character varying NOT NULL,
    organization_id bigint NOT NULL,
    province_id bigint,
    country_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: offices_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.offices_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: offices_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.offices_id_seq OWNED BY public.offices.id;


--
-- Name: operator_services; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.operator_services (
    id bigint NOT NULL,
    name character varying,
    service public.mobile_services,
    country_id bigint,
    country_name character varying
);


--
-- Name: operator_services_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.operator_services_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: operator_services_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.operator_services_id_seq OWNED BY public.operator_services.id;


--
-- Name: opportunities; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.opportunities (
    id bigint NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    description character varying NOT NULL,
    contact_name character varying NOT NULL,
    contact_email character varying NOT NULL,
    opening_date timestamp without time zone,
    closing_date timestamp without time zone,
    opportunity_type public.opportunity_type_type DEFAULT 'OTHER'::public.opportunity_type_type NOT NULL,
    opportunity_status public.opportunity_status_type DEFAULT 'UPCOMING'::public.opportunity_status_type NOT NULL,
    web_address character varying,
    requirements character varying,
    budget numeric(12,2),
    tags character varying[] DEFAULT '{}'::character varying[],
    origin_id bigint,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    gov_stack_entity boolean DEFAULT false NOT NULL
);


--
-- Name: opportunities_building_blocks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.opportunities_building_blocks (
    building_block_id bigint,
    opportunity_id bigint
);


--
-- Name: opportunities_countries; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.opportunities_countries (
    country_id bigint,
    opportunity_id bigint
);


--
-- Name: opportunities_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.opportunities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: opportunities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.opportunities_id_seq OWNED BY public.opportunities.id;


--
-- Name: opportunities_organizations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.opportunities_organizations (
    organization_id bigint,
    opportunity_id bigint
);


--
-- Name: opportunities_sectors; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.opportunities_sectors (
    sector_id bigint,
    opportunity_id bigint
);


--
-- Name: opportunities_use_cases; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.opportunities_use_cases (
    use_case_id bigint,
    opportunity_id bigint
);


--
-- Name: organization_contacts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.organization_contacts (
    organization_id bigint NOT NULL,
    contact_id bigint NOT NULL,
    started_at timestamp without time zone,
    ended_at timestamp without time zone,
    id bigint NOT NULL,
    slug character varying NOT NULL,
    main_contact boolean DEFAULT false NOT NULL
);


--
-- Name: organization_contacts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.organization_contacts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: organization_contacts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.organization_contacts_id_seq OWNED BY public.organization_contacts.id;


--
-- Name: organization_datasets; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.organization_datasets (
    id bigint NOT NULL,
    organization_id bigint NOT NULL,
    dataset_id bigint NOT NULL,
    organization_type public.org_type DEFAULT 'owner'::public.org_type NOT NULL,
    slug character varying NOT NULL
);


--
-- Name: organization_datasets_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.organization_datasets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: organization_datasets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.organization_datasets_id_seq OWNED BY public.organization_datasets.id;


--
-- Name: organization_descriptions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.organization_descriptions (
    id bigint NOT NULL,
    organization_id bigint NOT NULL,
    locale character varying NOT NULL,
    description character varying DEFAULT ''::character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: organization_descriptions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.organization_descriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: organization_descriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.organization_descriptions_id_seq OWNED BY public.organization_descriptions.id;


--
-- Name: organization_products; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.organization_products (
    organization_id bigint NOT NULL,
    product_id bigint NOT NULL,
    id bigint NOT NULL,
    slug character varying NOT NULL,
    org_type public.org_type DEFAULT 'owner'::public.org_type
);


--
-- Name: organization_products_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.organization_products_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: organization_products_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.organization_products_id_seq OWNED BY public.organization_products.id;


--
-- Name: organizations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.organizations (
    id bigint NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    when_endorsed timestamp without time zone,
    website character varying,
    is_endorser boolean DEFAULT false,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    is_mni boolean DEFAULT false,
    aliases character varying[] DEFAULT '{}'::character varying[],
    endorser_level public.endorser_type DEFAULT 'none'::public.endorser_type,
    has_storefront boolean DEFAULT false NOT NULL,
    hero_url character varying,
    specialties jsonb DEFAULT '[]'::jsonb NOT NULL,
    certifications jsonb DEFAULT '[]'::jsonb NOT NULL,
    building_blocks jsonb DEFAULT '[]'::jsonb NOT NULL
);


--
-- Name: organizations_countries; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.organizations_countries (
    id bigint NOT NULL,
    organization_id bigint NOT NULL,
    country_id bigint NOT NULL
);


--
-- Name: organizations_countries_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.organizations_countries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: organizations_countries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.organizations_countries_id_seq OWNED BY public.organizations_countries.id;


--
-- Name: organizations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.organizations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: organizations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.organizations_id_seq OWNED BY public.organizations.id;


--
-- Name: organizations_resources; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.organizations_resources (
    id bigint NOT NULL,
    organization_id bigint NOT NULL,
    resource_id bigint NOT NULL
);


--
-- Name: organizations_resources_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.organizations_resources_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: organizations_resources_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.organizations_resources_id_seq OWNED BY public.organizations_resources.id;


--
-- Name: organizations_sectors; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.organizations_sectors (
    sector_id bigint NOT NULL,
    organization_id bigint NOT NULL
);


--
-- Name: origins; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.origins (
    id bigint NOT NULL,
    organization_id bigint,
    name character varying,
    slug character varying,
    description character varying,
    last_synced timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: origins_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.origins_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: origins_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.origins_id_seq OWNED BY public.origins.id;


--
-- Name: page_contents; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.page_contents (
    id bigint NOT NULL,
    handbook_page_id bigint,
    locale character varying NOT NULL,
    html character varying NOT NULL,
    css character varying NOT NULL,
    components character varying,
    assets character varying,
    styles character varying,
    editor_type character varying
);


--
-- Name: page_contents_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.page_contents_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: page_contents_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.page_contents_id_seq OWNED BY public.page_contents.id;


--
-- Name: play_descriptions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.play_descriptions (
    id bigint NOT NULL,
    play_id bigint,
    locale character varying NOT NULL,
    description character varying NOT NULL
);


--
-- Name: play_descriptions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.play_descriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: play_descriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.play_descriptions_id_seq OWNED BY public.play_descriptions.id;


--
-- Name: play_move_descriptions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.play_move_descriptions (
    id bigint NOT NULL,
    play_move_id bigint,
    locale character varying NOT NULL,
    description character varying NOT NULL,
    prerequisites character varying DEFAULT ''::character varying NOT NULL,
    outcomes character varying DEFAULT ''::character varying NOT NULL
);


--
-- Name: play_move_descriptions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.play_move_descriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: play_move_descriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.play_move_descriptions_id_seq OWNED BY public.play_move_descriptions.id;


--
-- Name: play_moves; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.play_moves (
    id bigint NOT NULL,
    play_id bigint,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    move_order integer DEFAULT 0 NOT NULL,
    inline_resources jsonb DEFAULT '[]'::jsonb NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: play_moves_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.play_moves_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: play_moves_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.play_moves_id_seq OWNED BY public.play_moves.id;


--
-- Name: play_moves_resources; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.play_moves_resources (
    id bigint NOT NULL,
    play_move_id bigint NOT NULL,
    resource_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: play_moves_resources_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.play_moves_resources_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: play_moves_resources_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.play_moves_resources_id_seq OWNED BY public.play_moves_resources.id;


--
-- Name: playbook_descriptions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.playbook_descriptions (
    id bigint NOT NULL,
    playbook_id bigint,
    locale character varying NOT NULL,
    overview character varying NOT NULL,
    audience character varying NOT NULL,
    outcomes character varying NOT NULL
);


--
-- Name: playbook_descriptions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.playbook_descriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: playbook_descriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.playbook_descriptions_id_seq OWNED BY public.playbook_descriptions.id;


--
-- Name: playbook_plays; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.playbook_plays (
    id bigint NOT NULL,
    playbook_id bigint NOT NULL,
    play_id bigint NOT NULL,
    phase character varying,
    play_order integer DEFAULT 0 NOT NULL
);


--
-- Name: playbook_plays_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.playbook_plays_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: playbook_plays_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.playbook_plays_id_seq OWNED BY public.playbook_plays.id;


--
-- Name: playbooks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.playbooks (
    id bigint NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    phases jsonb DEFAULT '[]'::jsonb NOT NULL,
    tags character varying[] DEFAULT '{}'::character varying[],
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    draft boolean DEFAULT true NOT NULL,
    author character varying,
    owned_by character varying DEFAULT 'public'::character varying
);


--
-- Name: playbooks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.playbooks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: playbooks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.playbooks_id_seq OWNED BY public.playbooks.id;


--
-- Name: playbooks_sectors; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.playbooks_sectors (
    playbook_id bigint NOT NULL,
    sector_id bigint NOT NULL
);


--
-- Name: plays; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.plays (
    id bigint NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    author character varying,
    resources jsonb DEFAULT '[]'::jsonb NOT NULL,
    tags character varying[] DEFAULT '{}'::character varying[],
    version character varying DEFAULT '1.0'::character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    owned_by character varying DEFAULT 'public'::character varying,
    draft boolean DEFAULT false
);


--
-- Name: plays_building_blocks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.plays_building_blocks (
    id bigint NOT NULL,
    play_id bigint,
    building_block_id bigint
);


--
-- Name: plays_building_blocks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.plays_building_blocks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: plays_building_blocks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.plays_building_blocks_id_seq OWNED BY public.plays_building_blocks.id;


--
-- Name: plays_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.plays_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: plays_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.plays_id_seq OWNED BY public.plays.id;


--
-- Name: plays_products; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.plays_products (
    id bigint NOT NULL,
    play_id bigint,
    product_id bigint
);


--
-- Name: plays_products_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.plays_products_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: plays_products_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.plays_products_id_seq OWNED BY public.plays_products.id;


--
-- Name: plays_subplays; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.plays_subplays (
    id bigint NOT NULL,
    parent_play_id bigint NOT NULL,
    child_play_id bigint NOT NULL,
    "order" integer
);


--
-- Name: plays_subplays_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.plays_subplays_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: plays_subplays_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.plays_subplays_id_seq OWNED BY public.plays_subplays.id;


--
-- Name: portal_views; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.portal_views (
    id bigint NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    description character varying NOT NULL,
    top_navs character varying[] DEFAULT '{}'::character varying[],
    filter_navs character varying[] DEFAULT '{}'::character varying[],
    user_roles character varying[] DEFAULT '{}'::character varying[],
    product_views character varying[] DEFAULT '{}'::character varying[],
    organization_views character varying[] DEFAULT '{}'::character varying[],
    subdomain character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: portal_views_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.portal_views_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: portal_views_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.portal_views_id_seq OWNED BY public.portal_views.id;


--
-- Name: principle_descriptions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.principle_descriptions (
    id bigint NOT NULL,
    digital_principle_id bigint,
    locale character varying NOT NULL,
    description character varying DEFAULT ''::character varying NOT NULL
);


--
-- Name: principle_descriptions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.principle_descriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: principle_descriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.principle_descriptions_id_seq OWNED BY public.principle_descriptions.id;


--
-- Name: product_building_blocks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.product_building_blocks (
    building_block_id bigint NOT NULL,
    product_id bigint NOT NULL,
    mapping_status public.mapping_status_type DEFAULT 'BETA'::public.mapping_status_type NOT NULL,
    id bigint NOT NULL,
    slug character varying NOT NULL
);


--
-- Name: product_building_blocks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.product_building_blocks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: product_building_blocks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.product_building_blocks_id_seq OWNED BY public.product_building_blocks.id;


--
-- Name: product_categories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.product_categories (
    product_id bigint,
    software_category_id bigint
);


--
-- Name: product_classifications; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.product_classifications (
    id bigint NOT NULL,
    product_id bigint,
    classification_id bigint
);


--
-- Name: product_classifications_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.product_classifications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: product_classifications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.product_classifications_id_seq OWNED BY public.product_classifications.id;


--
-- Name: product_descriptions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.product_descriptions (
    id bigint NOT NULL,
    product_id bigint NOT NULL,
    locale character varying NOT NULL,
    description character varying DEFAULT ''::character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: product_descriptions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.product_descriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: product_descriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.product_descriptions_id_seq OWNED BY public.product_descriptions.id;


--
-- Name: product_features; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.product_features (
    product_id bigint,
    software_feature_id bigint
);


--
-- Name: product_indicators; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.product_indicators (
    id bigint NOT NULL,
    product_id bigint NOT NULL,
    category_indicator_id bigint NOT NULL,
    indicator_value character varying NOT NULL,
    updated_at timestamp without time zone
);


--
-- Name: product_indicators_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.product_indicators_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: product_indicators_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.product_indicators_id_seq OWNED BY public.product_indicators.id;


--
-- Name: product_product_relationships; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.product_product_relationships (
    id bigint NOT NULL,
    from_product_id bigint NOT NULL,
    to_product_id bigint NOT NULL,
    relationship_type public.relationship_type NOT NULL,
    slug character varying NOT NULL
);


--
-- Name: product_product_relationships_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.product_product_relationships_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: product_product_relationships_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.product_product_relationships_id_seq OWNED BY public.product_product_relationships.id;


--
-- Name: product_repositories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.product_repositories (
    id bigint NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    product_id bigint NOT NULL,
    absolute_url character varying NOT NULL,
    description character varying NOT NULL,
    main_repository boolean DEFAULT false NOT NULL,
    dpga_data jsonb DEFAULT '{}'::jsonb NOT NULL,
    language_data jsonb DEFAULT '{}'::jsonb NOT NULL,
    statistical_data jsonb DEFAULT '{}'::jsonb NOT NULL,
    license_data jsonb DEFAULT '{}'::jsonb NOT NULL,
    license character varying DEFAULT 'NA'::character varying NOT NULL,
    code_lines integer,
    cocomo integer,
    est_hosting integer,
    est_invested integer,
    updated_at timestamp without time zone NOT NULL,
    updated_by bigint,
    deleted boolean DEFAULT false NOT NULL,
    deleted_at timestamp without time zone,
    deleted_by bigint,
    created_at timestamp without time zone NOT NULL
);


--
-- Name: product_repositories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.product_repositories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: product_repositories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.product_repositories_id_seq OWNED BY public.product_repositories.id;


--
-- Name: product_sectors; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.product_sectors (
    product_id bigint NOT NULL,
    sector_id bigint NOT NULL,
    mapping_status public.mapping_status_type DEFAULT 'BETA'::public.mapping_status_type NOT NULL,
    id bigint NOT NULL,
    slug character varying NOT NULL
);


--
-- Name: product_sectors_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.product_sectors_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: product_sectors_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.product_sectors_id_seq OWNED BY public.product_sectors.id;


--
-- Name: product_sustainable_development_goals; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.product_sustainable_development_goals (
    product_id bigint NOT NULL,
    sustainable_development_goal_id bigint NOT NULL,
    mapping_status public.mapping_status_type DEFAULT 'BETA'::public.mapping_status_type NOT NULL,
    id bigint NOT NULL,
    slug character varying NOT NULL
);


--
-- Name: product_sustainable_development_goals_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.product_sustainable_development_goals_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: product_sustainable_development_goals_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.product_sustainable_development_goals_id_seq OWNED BY public.product_sustainable_development_goals.id;


--
-- Name: products; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.products (
    id bigint NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    website character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    is_launchable boolean DEFAULT false,
    start_assessment boolean DEFAULT false,
    default_url character varying DEFAULT 'http://<host_ip>'::character varying NOT NULL,
    aliases character varying[] DEFAULT '{}'::character varying[],
    tags character varying[] DEFAULT '{}'::character varying[],
    maturity_score jsonb,
    product_type public.product_type_save DEFAULT 'product'::public.product_type_save,
    manual_update boolean DEFAULT false,
    commercial_product boolean DEFAULT false,
    pricing_model character varying,
    pricing_details character varying,
    hosting_model character varying,
    pricing_date date,
    pricing_url character varying,
    languages jsonb,
    gov_stack_entity boolean DEFAULT false NOT NULL,
    extra_attributes jsonb DEFAULT '[]'::jsonb,
    product_stage character varying,
    featured boolean DEFAULT false,
    contact character varying
);


--
-- Name: products_countries; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.products_countries (
    id bigint NOT NULL,
    product_id bigint NOT NULL,
    country_id bigint NOT NULL
);


--
-- Name: products_countries_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.products_countries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: products_countries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.products_countries_id_seq OWNED BY public.products_countries.id;


--
-- Name: products_endorsers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.products_endorsers (
    id bigint NOT NULL,
    product_id bigint NOT NULL,
    endorser_id bigint NOT NULL
);


--
-- Name: products_endorsers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.products_endorsers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: products_endorsers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.products_endorsers_id_seq OWNED BY public.products_endorsers.id;


--
-- Name: products_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.products_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: products_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.products_id_seq OWNED BY public.products.id;


--
-- Name: products_origins; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.products_origins (
    product_id bigint NOT NULL,
    origin_id bigint NOT NULL
);


--
-- Name: products_resources; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.products_resources (
    product_id bigint NOT NULL,
    resource_id bigint NOT NULL
);


--
-- Name: project_descriptions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.project_descriptions (
    id bigint NOT NULL,
    project_id bigint NOT NULL,
    locale character varying NOT NULL,
    description character varying DEFAULT ''::character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: project_descriptions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.project_descriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: project_descriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.project_descriptions_id_seq OWNED BY public.project_descriptions.id;


--
-- Name: projects; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.projects (
    id bigint NOT NULL,
    origin_id bigint,
    start_date date,
    end_date date,
    budget numeric(12,2),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    project_url character varying,
    tags character varying[] DEFAULT '{}'::character varying[]
);


--
-- Name: projects_countries; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.projects_countries (
    id bigint NOT NULL,
    project_id bigint NOT NULL,
    country_id bigint NOT NULL
);


--
-- Name: projects_countries_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.projects_countries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: projects_countries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.projects_countries_id_seq OWNED BY public.projects_countries.id;


--
-- Name: projects_digital_principles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.projects_digital_principles (
    id bigint NOT NULL,
    project_id bigint NOT NULL,
    digital_principle_id bigint NOT NULL
);


--
-- Name: projects_digital_principles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.projects_digital_principles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: projects_digital_principles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.projects_digital_principles_id_seq OWNED BY public.projects_digital_principles.id;


--
-- Name: projects_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.projects_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: projects_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.projects_id_seq OWNED BY public.projects.id;


--
-- Name: projects_organizations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.projects_organizations (
    project_id bigint NOT NULL,
    organization_id bigint NOT NULL,
    org_type public.org_type DEFAULT 'owner'::public.org_type,
    featured_project boolean DEFAULT false NOT NULL
);


--
-- Name: projects_products; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.projects_products (
    project_id bigint NOT NULL,
    product_id bigint NOT NULL
);


--
-- Name: projects_sdgs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.projects_sdgs (
    project_id bigint NOT NULL,
    sdg_id bigint NOT NULL
);


--
-- Name: projects_sectors; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.projects_sectors (
    project_id bigint NOT NULL,
    sector_id bigint NOT NULL
);


--
-- Name: provinces; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.provinces (
    id bigint NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    country_id bigint NOT NULL,
    latitude numeric NOT NULL,
    longitude numeric NOT NULL,
    aliases character varying[] DEFAULT '{}'::character varying[],
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: provinces_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.provinces_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: provinces_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.provinces_id_seq OWNED BY public.provinces.id;


--
-- Name: regions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.regions (
    id bigint NOT NULL,
    slug character varying NOT NULL,
    name character varying NOT NULL,
    description character varying NOT NULL,
    aliases character varying[] DEFAULT '{}'::character varying[],
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: regions_countries; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.regions_countries (
    region_id bigint NOT NULL,
    country_id bigint NOT NULL
);


--
-- Name: regions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.regions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: regions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.regions_id_seq OWNED BY public.regions.id;


--
-- Name: resource_building_blocks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.resource_building_blocks (
    id bigint NOT NULL,
    resource_id bigint NOT NULL,
    building_block_id bigint NOT NULL,
    mapping_status public.mapping_status_type DEFAULT 'BETA'::public.mapping_status_type,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: resource_building_blocks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.resource_building_blocks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: resource_building_blocks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.resource_building_blocks_id_seq OWNED BY public.resource_building_blocks.id;


--
-- Name: resource_topic_descriptions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.resource_topic_descriptions (
    id bigint NOT NULL,
    locale character varying NOT NULL,
    description character varying NOT NULL,
    resource_topic_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: resource_topic_descriptions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.resource_topic_descriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: resource_topic_descriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.resource_topic_descriptions_id_seq OWNED BY public.resource_topic_descriptions.id;


--
-- Name: resource_topics; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.resource_topics (
    id bigint NOT NULL,
    slug character varying NOT NULL,
    name character varying NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    parent_topic_id bigint
);


--
-- Name: resource_topics_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.resource_topics_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: resource_topics_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.resource_topics_id_seq OWNED BY public.resource_topics.id;


--
-- Name: resource_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.resource_types (
    id bigint NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    description character varying NOT NULL,
    locale character varying DEFAULT 'en'::character varying NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: resource_types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.resource_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: resource_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.resource_types_id_seq OWNED BY public.resource_types.id;


--
-- Name: resources; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.resources (
    id bigint NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    phase character varying NOT NULL,
    image_url character varying,
    resource_link character varying,
    description character varying,
    show_in_wizard boolean DEFAULT false NOT NULL,
    show_in_exchange boolean DEFAULT false NOT NULL,
    link_description character varying,
    tags character varying[] DEFAULT '{}'::character varying[],
    resource_type character varying,
    published_date timestamp(6) without time zone,
    featured boolean DEFAULT false NOT NULL,
    resource_filename character varying,
    resource_topics character varying[] DEFAULT '{}'::character varying[],
    organization_id bigint,
    submitted_by_id bigint
);


--
-- Name: resources_authors; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.resources_authors (
    resource_id bigint NOT NULL,
    author_id bigint NOT NULL
);


--
-- Name: resources_countries; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.resources_countries (
    resource_id bigint NOT NULL,
    country_id bigint NOT NULL
);


--
-- Name: resources_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.resources_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: resources_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.resources_id_seq OWNED BY public.resources.id;


--
-- Name: resources_use_cases; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.resources_use_cases (
    id bigint NOT NULL,
    resource_id bigint NOT NULL,
    use_case_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: resources_use_cases_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.resources_use_cases_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: resources_use_cases_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.resources_use_cases_id_seq OWNED BY public.resources_use_cases.id;


--
-- Name: rubric_categories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.rubric_categories (
    id bigint NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    weight numeric DEFAULT 0 NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: rubric_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.rubric_categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: rubric_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.rubric_categories_id_seq OWNED BY public.rubric_categories.id;


--
-- Name: rubric_category_descriptions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.rubric_category_descriptions (
    id bigint NOT NULL,
    rubric_category_id bigint NOT NULL,
    locale character varying NOT NULL,
    description character varying DEFAULT ''::character varying NOT NULL
);


--
-- Name: rubric_category_descriptions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.rubric_category_descriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: rubric_category_descriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.rubric_category_descriptions_id_seq OWNED BY public.rubric_category_descriptions.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: sdg_targets; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sdg_targets (
    id bigint NOT NULL,
    name character varying NOT NULL,
    target_number character varying NOT NULL,
    slug character varying,
    sdg_number integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: sdg_targets_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sdg_targets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sdg_targets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sdg_targets_id_seq OWNED BY public.sdg_targets.id;


--
-- Name: sectors; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sectors (
    id bigint NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    is_displayable boolean,
    parent_sector_id bigint,
    origin_id bigint,
    locale character varying DEFAULT 'en'::character varying
);


--
-- Name: sectors_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sectors_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sectors_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sectors_id_seq OWNED BY public.sectors.id;


--
-- Name: sessions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sessions (
    id bigint NOT NULL,
    session_id character varying NOT NULL,
    data text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: sessions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sessions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sessions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sessions_id_seq OWNED BY public.sessions.id;


--
-- Name: settings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.settings (
    id bigint NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    description character varying NOT NULL,
    value text NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: settings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.settings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: settings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.settings_id_seq OWNED BY public.settings.id;


--
-- Name: software_categories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.software_categories (
    id bigint NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    description character varying NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: software_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.software_categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: software_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.software_categories_id_seq OWNED BY public.software_categories.id;


--
-- Name: software_features; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.software_features (
    id bigint NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    description character varying NOT NULL,
    facility_scale integer,
    software_category_id bigint,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: software_features_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.software_features_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: software_features_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.software_features_id_seq OWNED BY public.software_features.id;


--
-- Name: starred_objects; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.starred_objects (
    id bigint NOT NULL,
    starred_object_type character varying NOT NULL,
    starred_object_value character varying NOT NULL,
    source_object_type character varying NOT NULL,
    source_object_value character varying NOT NULL,
    starred_by_id bigint,
    starred_date timestamp(6) without time zone NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: starred_objects_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.starred_objects_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: starred_objects_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.starred_objects_id_seq OWNED BY public.starred_objects.id;


--
-- Name: stylesheets; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.stylesheets (
    id bigint NOT NULL,
    portal character varying,
    background_color character varying,
    about_page character varying DEFAULT ''::character varying NOT NULL,
    footer_content character varying DEFAULT ''::character varying NOT NULL,
    header_logo character varying
);


--
-- Name: stylesheets_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.stylesheets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: stylesheets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.stylesheets_id_seq OWNED BY public.stylesheets.id;


--
-- Name: sustainable_development_goals; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sustainable_development_goals (
    id bigint NOT NULL,
    slug character varying NOT NULL,
    name character varying NOT NULL,
    long_title character varying NOT NULL,
    number integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: sustainable_development_goals_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sustainable_development_goals_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sustainable_development_goals_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sustainable_development_goals_id_seq OWNED BY public.sustainable_development_goals.id;


--
-- Name: tag_descriptions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tag_descriptions (
    id bigint NOT NULL,
    tag_id bigint NOT NULL,
    locale character varying NOT NULL,
    description character varying DEFAULT ''::character varying NOT NULL
);


--
-- Name: tag_descriptions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.tag_descriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tag_descriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.tag_descriptions_id_seq OWNED BY public.tag_descriptions.id;


--
-- Name: tags; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tags (
    id bigint NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: tags_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.tags_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.tags_id_seq OWNED BY public.tags.id;


--
-- Name: task_tracker_descriptions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.task_tracker_descriptions (
    id bigint NOT NULL,
    task_tracker_id bigint NOT NULL,
    locale character varying NOT NULL,
    description character varying DEFAULT '{}'::jsonb NOT NULL
);


--
-- Name: task_tracker_descriptions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.task_tracker_descriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: task_tracker_descriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.task_tracker_descriptions_id_seq OWNED BY public.task_tracker_descriptions.id;


--
-- Name: task_trackers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.task_trackers (
    id bigint NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    last_started_date timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    last_received_message character varying NOT NULL,
    task_completed boolean DEFAULT false NOT NULL
);


--
-- Name: task_trackers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.task_trackers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: task_trackers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.task_trackers_id_seq OWNED BY public.task_trackers.id;


--
-- Name: tenant_sync_configurations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tenant_sync_configurations (
    id bigint NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    description character varying NOT NULL,
    tenant_source character varying NOT NULL,
    tenant_destination character varying NOT NULL,
    sync_enabled boolean DEFAULT true NOT NULL,
    sync_configuration json DEFAULT '{}'::json NOT NULL,
    last_sync_at timestamp(6) without time zone,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: tenant_sync_configurations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.tenant_sync_configurations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tenant_sync_configurations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.tenant_sync_configurations_id_seq OWNED BY public.tenant_sync_configurations.id;


--
-- Name: use_case_descriptions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.use_case_descriptions (
    id bigint NOT NULL,
    use_case_id bigint NOT NULL,
    locale character varying NOT NULL,
    description character varying DEFAULT ''::character varying NOT NULL
);


--
-- Name: use_case_descriptions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.use_case_descriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: use_case_descriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.use_case_descriptions_id_seq OWNED BY public.use_case_descriptions.id;


--
-- Name: use_case_headers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.use_case_headers (
    id bigint NOT NULL,
    use_case_id bigint NOT NULL,
    locale character varying NOT NULL,
    header character varying DEFAULT ''::character varying NOT NULL
);


--
-- Name: use_case_headers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.use_case_headers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: use_case_headers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.use_case_headers_id_seq OWNED BY public.use_case_headers.id;


--
-- Name: use_case_step_descriptions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.use_case_step_descriptions (
    id bigint NOT NULL,
    use_case_step_id bigint NOT NULL,
    locale character varying NOT NULL,
    description character varying DEFAULT ''::character varying NOT NULL
);


--
-- Name: use_case_step_descriptions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.use_case_step_descriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: use_case_step_descriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.use_case_step_descriptions_id_seq OWNED BY public.use_case_step_descriptions.id;


--
-- Name: use_case_steps; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.use_case_steps (
    id bigint NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    step_number integer NOT NULL,
    use_case_id bigint NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    example_implementation character varying
);


--
-- Name: use_case_steps_building_blocks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.use_case_steps_building_blocks (
    id bigint NOT NULL,
    use_case_step_id bigint NOT NULL,
    building_block_id bigint NOT NULL
);


--
-- Name: use_case_steps_building_blocks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.use_case_steps_building_blocks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: use_case_steps_building_blocks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.use_case_steps_building_blocks_id_seq OWNED BY public.use_case_steps_building_blocks.id;


--
-- Name: use_case_steps_datasets; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.use_case_steps_datasets (
    id bigint NOT NULL,
    use_case_step_id bigint NOT NULL,
    dataset_id bigint NOT NULL
);


--
-- Name: use_case_steps_datasets_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.use_case_steps_datasets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: use_case_steps_datasets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.use_case_steps_datasets_id_seq OWNED BY public.use_case_steps_datasets.id;


--
-- Name: use_case_steps_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.use_case_steps_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: use_case_steps_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.use_case_steps_id_seq OWNED BY public.use_case_steps.id;


--
-- Name: use_case_steps_products; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.use_case_steps_products (
    id bigint NOT NULL,
    use_case_step_id bigint NOT NULL,
    product_id bigint NOT NULL
);


--
-- Name: use_case_steps_products_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.use_case_steps_products_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: use_case_steps_products_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.use_case_steps_products_id_seq OWNED BY public.use_case_steps_products.id;


--
-- Name: use_case_steps_workflows; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.use_case_steps_workflows (
    use_case_step_id bigint NOT NULL,
    workflow_id bigint NOT NULL
);


--
-- Name: use_cases; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.use_cases (
    id bigint NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    sector_id bigint NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    description jsonb DEFAULT '{}'::jsonb NOT NULL,
    maturity public.entity_status_type DEFAULT 'DRAFT'::public.entity_status_type NOT NULL,
    tags character varying[] DEFAULT '{}'::character varying[],
    markdown_url character varying,
    gov_stack_entity boolean DEFAULT false NOT NULL
);


--
-- Name: use_cases_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.use_cases_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: use_cases_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.use_cases_id_seq OWNED BY public.use_cases.id;


--
-- Name: use_cases_sdg_targets; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.use_cases_sdg_targets (
    use_case_id bigint NOT NULL,
    sdg_target_id bigint NOT NULL
);


--
-- Name: user_events; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_events (
    id bigint NOT NULL,
    identifier character varying NOT NULL,
    email character varying,
    event_datetime timestamp without time zone NOT NULL,
    event_type character varying NOT NULL,
    extended_data jsonb DEFAULT '{}'::jsonb NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: user_events_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.user_events_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: user_events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.user_events_id_seq OWNED BY public.user_events.id;


--
-- Name: user_messages; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_messages (
    id bigint NOT NULL,
    message_id bigint NOT NULL,
    received_by_id bigint NOT NULL,
    read boolean DEFAULT false NOT NULL,
    visible boolean DEFAULT false NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: user_messages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.user_messages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: user_messages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.user_messages_id_seq OWNED BY public.user_messages.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    email character varying DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    confirmation_token character varying,
    confirmed_at timestamp without time zone,
    confirmation_sent_at timestamp without time zone,
    unconfirmed_email character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    receive_backup boolean DEFAULT false,
    organization_id bigint,
    expired boolean,
    expired_at timestamp without time zone,
    saved_products bigint[] DEFAULT '{}'::bigint[],
    saved_use_cases bigint[] DEFAULT '{}'::bigint[],
    saved_projects bigint[] DEFAULT '{}'::bigint[],
    saved_urls character varying[] DEFAULT '{}'::character varying[],
    roles public.user_role[] DEFAULT '{}'::public.user_role[],
    authentication_token text,
    authentication_token_created_at timestamp without time zone,
    user_products bigint[] DEFAULT '{}'::bigint[],
    receive_admin_emails boolean DEFAULT false,
    username character varying,
    user_datasets bigint[] DEFAULT '{}'::bigint[],
    saved_building_blocks bigint[] DEFAULT '{}'::bigint[] NOT NULL
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: workflow_descriptions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.workflow_descriptions (
    id bigint NOT NULL,
    workflow_id bigint NOT NULL,
    locale character varying NOT NULL,
    description character varying DEFAULT ''::character varying NOT NULL
);


--
-- Name: workflow_descriptions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.workflow_descriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: workflow_descriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.workflow_descriptions_id_seq OWNED BY public.workflow_descriptions.id;


--
-- Name: workflows; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.workflows (
    id bigint NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    description jsonb DEFAULT '{}'::jsonb NOT NULL
);


--
-- Name: workflows_building_blocks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.workflows_building_blocks (
    workflow_id bigint NOT NULL,
    building_block_id bigint NOT NULL
);


--
-- Name: workflows_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.workflows_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: workflows_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.workflows_id_seq OWNED BY public.workflows.id;


--
-- Name: workflows_use_cases; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.workflows_use_cases (
    workflow_id bigint NOT NULL,
    use_case_id bigint NOT NULL
);


--
-- Name: aggregator_capabilities id; Type: DEFAULT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.aggregator_capabilities ALTER COLUMN id SET DEFAULT nextval('fao.aggregator_capabilities_id_seq'::regclass);


--
-- Name: audits id; Type: DEFAULT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.audits ALTER COLUMN id SET DEFAULT nextval('fao.audits_id_seq'::regclass);


--
-- Name: authors id; Type: DEFAULT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.authors ALTER COLUMN id SET DEFAULT nextval('fao.authors_id_seq'::regclass);


--
-- Name: building_block_descriptions id; Type: DEFAULT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.building_block_descriptions ALTER COLUMN id SET DEFAULT nextval('fao.building_block_descriptions_id_seq'::regclass);


--
-- Name: building_blocks id; Type: DEFAULT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.building_blocks ALTER COLUMN id SET DEFAULT nextval('fao.building_blocks_id_seq'::regclass);


--
-- Name: candidate_datasets id; Type: DEFAULT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.candidate_datasets ALTER COLUMN id SET DEFAULT nextval('fao.candidate_datasets_id_seq'::regclass);


--
-- Name: candidate_organizations id; Type: DEFAULT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.candidate_organizations ALTER COLUMN id SET DEFAULT nextval('fao.candidate_organizations_id_seq'::regclass);


--
-- Name: candidate_products id; Type: DEFAULT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.candidate_products ALTER COLUMN id SET DEFAULT nextval('fao.candidate_products_id_seq'::regclass);


--
-- Name: candidate_resources id; Type: DEFAULT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.candidate_resources ALTER COLUMN id SET DEFAULT nextval('fao.candidate_resources_id_seq'::regclass);


--
-- Name: candidate_resources_countries id; Type: DEFAULT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.candidate_resources_countries ALTER COLUMN id SET DEFAULT nextval('fao.candidate_resources_countries_id_seq'::regclass);


--
-- Name: candidate_roles id; Type: DEFAULT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.candidate_roles ALTER COLUMN id SET DEFAULT nextval('fao.candidate_roles_id_seq'::regclass);


--
-- Name: category_indicator_descriptions id; Type: DEFAULT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.category_indicator_descriptions ALTER COLUMN id SET DEFAULT nextval('fao.category_indicator_descriptions_id_seq'::regclass);


--
-- Name: category_indicators id; Type: DEFAULT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.category_indicators ALTER COLUMN id SET DEFAULT nextval('fao.category_indicators_id_seq'::regclass);


--
-- Name: chatbot_conversations id; Type: DEFAULT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.chatbot_conversations ALTER COLUMN id SET DEFAULT nextval('fao.chatbot_conversations_id_seq'::regclass);


--
-- Name: cities id; Type: DEFAULT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.cities ALTER COLUMN id SET DEFAULT nextval('fao.cities_id_seq'::regclass);


--
-- Name: ckeditor_assets id; Type: DEFAULT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.ckeditor_assets ALTER COLUMN id SET DEFAULT nextval('fao.ckeditor_assets_id_seq'::regclass);


--
-- Name: classifications id; Type: DEFAULT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.classifications ALTER COLUMN id SET DEFAULT nextval('fao.classifications_id_seq'::regclass);


--
-- Name: comments id; Type: DEFAULT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.comments ALTER COLUMN id SET DEFAULT nextval('fao.comments_id_seq'::regclass);


--
-- Name: contacts id; Type: DEFAULT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.contacts ALTER COLUMN id SET DEFAULT nextval('fao.contacts_id_seq'::regclass);


--
-- Name: countries id; Type: DEFAULT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.countries ALTER COLUMN id SET DEFAULT nextval('fao.countries_id_seq'::regclass);


--
-- Name: dataset_descriptions id; Type: DEFAULT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.dataset_descriptions ALTER COLUMN id SET DEFAULT nextval('fao.dataset_descriptions_id_seq'::regclass);


--
-- Name: dataset_sectors id; Type: DEFAULT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.dataset_sectors ALTER COLUMN id SET DEFAULT nextval('fao.dataset_sectors_id_seq'::regclass);


--
-- Name: dataset_sustainable_development_goals id; Type: DEFAULT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.dataset_sustainable_development_goals ALTER COLUMN id SET DEFAULT nextval('fao.dataset_sustainable_development_goals_id_seq'::regclass);


--
-- Name: datasets id; Type: DEFAULT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.datasets ALTER COLUMN id SET DEFAULT nextval('fao.datasets_id_seq'::regclass);


--
-- Name: datasets_countries id; Type: DEFAULT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.datasets_countries ALTER COLUMN id SET DEFAULT nextval('fao.datasets_countries_id_seq'::regclass);


--
-- Name: datasets_origins id; Type: DEFAULT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.datasets_origins ALTER COLUMN id SET DEFAULT nextval('fao.datasets_origins_id_seq'::regclass);


--
-- Name: deploys id; Type: DEFAULT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.deploys ALTER COLUMN id SET DEFAULT nextval('fao.deploys_id_seq'::regclass);


--
-- Name: dial_spreadsheet_data id; Type: DEFAULT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.dial_spreadsheet_data ALTER COLUMN id SET DEFAULT nextval('fao.dial_spreadsheet_data_id_seq'::regclass);


--
-- Name: digital_principles id; Type: DEFAULT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.digital_principles ALTER COLUMN id SET DEFAULT nextval('fao.digital_principles_id_seq'::regclass);


--
-- Name: districts id; Type: DEFAULT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.districts ALTER COLUMN id SET DEFAULT nextval('fao.districts_id_seq'::regclass);


--
-- Name: endorsers id; Type: DEFAULT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.endorsers ALTER COLUMN id SET DEFAULT nextval('fao.endorsers_id_seq'::regclass);


--
-- Name: exchange_tenants id; Type: DEFAULT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.exchange_tenants ALTER COLUMN id SET DEFAULT nextval('fao.exchange_tenants_id_seq'::regclass);


--
-- Name: froala_images id; Type: DEFAULT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.froala_images ALTER COLUMN id SET DEFAULT nextval('fao.froala_images_id_seq'::regclass);


--
-- Name: glossaries id; Type: DEFAULT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.glossaries ALTER COLUMN id SET DEFAULT nextval('fao.glossaries_id_seq'::regclass);


--
-- Name: handbook_answers id; Type: DEFAULT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.handbook_answers ALTER COLUMN id SET DEFAULT nextval('fao.handbook_answers_id_seq'::regclass);


--
-- Name: handbook_descriptions id; Type: DEFAULT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.handbook_descriptions ALTER COLUMN id SET DEFAULT nextval('fao.handbook_descriptions_id_seq'::regclass);


--
-- Name: handbook_pages id; Type: DEFAULT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.handbook_pages ALTER COLUMN id SET DEFAULT nextval('fao.handbook_pages_id_seq'::regclass);


--
-- Name: handbook_questions id; Type: DEFAULT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.handbook_questions ALTER COLUMN id SET DEFAULT nextval('fao.handbook_questions_id_seq'::regclass);


--
-- Name: handbooks id; Type: DEFAULT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.handbooks ALTER COLUMN id SET DEFAULT nextval('fao.handbooks_id_seq'::regclass);


--
-- Name: messages id; Type: DEFAULT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.messages ALTER COLUMN id SET DEFAULT nextval('fao.messages_id_seq'::regclass);


--
-- Name: offices id; Type: DEFAULT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.offices ALTER COLUMN id SET DEFAULT nextval('fao.offices_id_seq'::regclass);


--
-- Name: operator_services id; Type: DEFAULT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.operator_services ALTER COLUMN id SET DEFAULT nextval('fao.operator_services_id_seq'::regclass);


--
-- Name: opportunities id; Type: DEFAULT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.opportunities ALTER COLUMN id SET DEFAULT nextval('fao.opportunities_id_seq'::regclass);


--
-- Name: organization_contacts id; Type: DEFAULT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.organization_contacts ALTER COLUMN id SET DEFAULT nextval('fao.organization_contacts_id_seq'::regclass);


--
-- Name: organization_datasets id; Type: DEFAULT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.organization_datasets ALTER COLUMN id SET DEFAULT nextval('fao.organization_datasets_id_seq'::regclass);


--
-- Name: organization_descriptions id; Type: DEFAULT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.organization_descriptions ALTER COLUMN id SET DEFAULT nextval('fao.organization_descriptions_id_seq'::regclass);


--
-- Name: organization_products id; Type: DEFAULT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.organization_products ALTER COLUMN id SET DEFAULT nextval('fao.organization_products_id_seq'::regclass);


--
-- Name: organizations id; Type: DEFAULT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.organizations ALTER COLUMN id SET DEFAULT nextval('fao.organizations_id_seq'::regclass);


--
-- Name: organizations_countries id; Type: DEFAULT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.organizations_countries ALTER COLUMN id SET DEFAULT nextval('fao.organizations_countries_id_seq'::regclass);


--
-- Name: organizations_resources id; Type: DEFAULT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.organizations_resources ALTER COLUMN id SET DEFAULT nextval('fao.organizations_resources_id_seq'::regclass);


--
-- Name: origins id; Type: DEFAULT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.origins ALTER COLUMN id SET DEFAULT nextval('fao.origins_id_seq'::regclass);


--
-- Name: page_contents id; Type: DEFAULT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.page_contents ALTER COLUMN id SET DEFAULT nextval('fao.page_contents_id_seq'::regclass);


--
-- Name: play_descriptions id; Type: DEFAULT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.play_descriptions ALTER COLUMN id SET DEFAULT nextval('fao.play_descriptions_id_seq'::regclass);


--
-- Name: play_move_descriptions id; Type: DEFAULT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.play_move_descriptions ALTER COLUMN id SET DEFAULT nextval('fao.play_move_descriptions_id_seq'::regclass);


--
-- Name: play_moves id; Type: DEFAULT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.play_moves ALTER COLUMN id SET DEFAULT nextval('fao.play_moves_id_seq'::regclass);


--
-- Name: play_moves_resources id; Type: DEFAULT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.play_moves_resources ALTER COLUMN id SET DEFAULT nextval('fao.play_moves_resources_id_seq'::regclass);


--
-- Name: playbook_descriptions id; Type: DEFAULT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.playbook_descriptions ALTER COLUMN id SET DEFAULT nextval('fao.playbook_descriptions_id_seq'::regclass);


--
-- Name: playbook_plays id; Type: DEFAULT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.playbook_plays ALTER COLUMN id SET DEFAULT nextval('fao.playbook_plays_id_seq'::regclass);


--
-- Name: playbooks id; Type: DEFAULT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.playbooks ALTER COLUMN id SET DEFAULT nextval('fao.playbooks_id_seq'::regclass);


--
-- Name: plays id; Type: DEFAULT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.plays ALTER COLUMN id SET DEFAULT nextval('fao.plays_id_seq'::regclass);


--
-- Name: plays_building_blocks id; Type: DEFAULT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.plays_building_blocks ALTER COLUMN id SET DEFAULT nextval('fao.plays_building_blocks_id_seq'::regclass);


--
-- Name: plays_products id; Type: DEFAULT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.plays_products ALTER COLUMN id SET DEFAULT nextval('fao.plays_products_id_seq'::regclass);


--
-- Name: plays_subplays id; Type: DEFAULT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.plays_subplays ALTER COLUMN id SET DEFAULT nextval('fao.plays_subplays_id_seq'::regclass);


--
-- Name: portal_views id; Type: DEFAULT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.portal_views ALTER COLUMN id SET DEFAULT nextval('fao.portal_views_id_seq'::regclass);


--
-- Name: principle_descriptions id; Type: DEFAULT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.principle_descriptions ALTER COLUMN id SET DEFAULT nextval('fao.principle_descriptions_id_seq'::regclass);


--
-- Name: product_building_blocks id; Type: DEFAULT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.product_building_blocks ALTER COLUMN id SET DEFAULT nextval('fao.product_building_blocks_id_seq'::regclass);


--
-- Name: product_classifications id; Type: DEFAULT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.product_classifications ALTER COLUMN id SET DEFAULT nextval('fao.product_classifications_id_seq'::regclass);


--
-- Name: product_descriptions id; Type: DEFAULT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.product_descriptions ALTER COLUMN id SET DEFAULT nextval('fao.product_descriptions_id_seq'::regclass);


--
-- Name: product_indicators id; Type: DEFAULT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.product_indicators ALTER COLUMN id SET DEFAULT nextval('fao.product_indicators_id_seq'::regclass);


--
-- Name: product_product_relationships id; Type: DEFAULT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.product_product_relationships ALTER COLUMN id SET DEFAULT nextval('fao.product_product_relationships_id_seq'::regclass);


--
-- Name: product_repositories id; Type: DEFAULT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.product_repositories ALTER COLUMN id SET DEFAULT nextval('fao.product_repositories_id_seq'::regclass);


--
-- Name: product_sectors id; Type: DEFAULT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.product_sectors ALTER COLUMN id SET DEFAULT nextval('fao.product_sectors_id_seq'::regclass);


--
-- Name: product_sustainable_development_goals id; Type: DEFAULT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.product_sustainable_development_goals ALTER COLUMN id SET DEFAULT nextval('fao.product_sustainable_development_goals_id_seq'::regclass);


--
-- Name: products id; Type: DEFAULT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.products ALTER COLUMN id SET DEFAULT nextval('fao.products_id_seq'::regclass);


--
-- Name: products_countries id; Type: DEFAULT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.products_countries ALTER COLUMN id SET DEFAULT nextval('fao.products_countries_id_seq'::regclass);


--
-- Name: products_endorsers id; Type: DEFAULT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.products_endorsers ALTER COLUMN id SET DEFAULT nextval('fao.products_endorsers_id_seq'::regclass);


--
-- Name: project_descriptions id; Type: DEFAULT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.project_descriptions ALTER COLUMN id SET DEFAULT nextval('fao.project_descriptions_id_seq'::regclass);


--
-- Name: projects id; Type: DEFAULT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.projects ALTER COLUMN id SET DEFAULT nextval('fao.projects_id_seq'::regclass);


--
-- Name: projects_countries id; Type: DEFAULT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.projects_countries ALTER COLUMN id SET DEFAULT nextval('fao.projects_countries_id_seq'::regclass);


--
-- Name: projects_digital_principles id; Type: DEFAULT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.projects_digital_principles ALTER COLUMN id SET DEFAULT nextval('fao.projects_digital_principles_id_seq'::regclass);


--
-- Name: provinces id; Type: DEFAULT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.provinces ALTER COLUMN id SET DEFAULT nextval('fao.provinces_id_seq'::regclass);


--
-- Name: regions id; Type: DEFAULT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.regions ALTER COLUMN id SET DEFAULT nextval('fao.regions_id_seq'::regclass);


--
-- Name: resource_building_blocks id; Type: DEFAULT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.resource_building_blocks ALTER COLUMN id SET DEFAULT nextval('fao.resource_building_blocks_id_seq'::regclass);


--
-- Name: resource_topic_descriptions id; Type: DEFAULT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.resource_topic_descriptions ALTER COLUMN id SET DEFAULT nextval('fao.resource_topic_descriptions_id_seq'::regclass);


--
-- Name: resource_topics id; Type: DEFAULT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.resource_topics ALTER COLUMN id SET DEFAULT nextval('fao.resource_topics_id_seq'::regclass);


--
-- Name: resource_types id; Type: DEFAULT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.resource_types ALTER COLUMN id SET DEFAULT nextval('fao.resource_types_id_seq'::regclass);


--
-- Name: resources id; Type: DEFAULT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.resources ALTER COLUMN id SET DEFAULT nextval('fao.resources_id_seq'::regclass);


--
-- Name: resources_use_cases id; Type: DEFAULT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.resources_use_cases ALTER COLUMN id SET DEFAULT nextval('fao.resources_use_cases_id_seq'::regclass);


--
-- Name: rubric_categories id; Type: DEFAULT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.rubric_categories ALTER COLUMN id SET DEFAULT nextval('fao.rubric_categories_id_seq'::regclass);


--
-- Name: rubric_category_descriptions id; Type: DEFAULT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.rubric_category_descriptions ALTER COLUMN id SET DEFAULT nextval('fao.rubric_category_descriptions_id_seq'::regclass);


--
-- Name: sdg_targets id; Type: DEFAULT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.sdg_targets ALTER COLUMN id SET DEFAULT nextval('fao.sdg_targets_id_seq'::regclass);


--
-- Name: sectors id; Type: DEFAULT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.sectors ALTER COLUMN id SET DEFAULT nextval('fao.sectors_id_seq'::regclass);


--
-- Name: sessions id; Type: DEFAULT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.sessions ALTER COLUMN id SET DEFAULT nextval('fao.sessions_id_seq'::regclass);


--
-- Name: settings id; Type: DEFAULT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.settings ALTER COLUMN id SET DEFAULT nextval('fao.settings_id_seq'::regclass);


--
-- Name: software_categories id; Type: DEFAULT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.software_categories ALTER COLUMN id SET DEFAULT nextval('fao.software_categories_id_seq'::regclass);


--
-- Name: software_features id; Type: DEFAULT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.software_features ALTER COLUMN id SET DEFAULT nextval('fao.software_features_id_seq'::regclass);


--
-- Name: starred_objects id; Type: DEFAULT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.starred_objects ALTER COLUMN id SET DEFAULT nextval('fao.starred_objects_id_seq'::regclass);


--
-- Name: stylesheets id; Type: DEFAULT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.stylesheets ALTER COLUMN id SET DEFAULT nextval('fao.stylesheets_id_seq'::regclass);


--
-- Name: sustainable_development_goals id; Type: DEFAULT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.sustainable_development_goals ALTER COLUMN id SET DEFAULT nextval('fao.sustainable_development_goals_id_seq'::regclass);


--
-- Name: tag_descriptions id; Type: DEFAULT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.tag_descriptions ALTER COLUMN id SET DEFAULT nextval('fao.tag_descriptions_id_seq'::regclass);


--
-- Name: tags id; Type: DEFAULT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.tags ALTER COLUMN id SET DEFAULT nextval('fao.tags_id_seq'::regclass);


--
-- Name: task_tracker_descriptions id; Type: DEFAULT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.task_tracker_descriptions ALTER COLUMN id SET DEFAULT nextval('fao.task_tracker_descriptions_id_seq'::regclass);


--
-- Name: task_trackers id; Type: DEFAULT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.task_trackers ALTER COLUMN id SET DEFAULT nextval('fao.task_trackers_id_seq'::regclass);


--
-- Name: tenant_sync_configurations id; Type: DEFAULT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.tenant_sync_configurations ALTER COLUMN id SET DEFAULT nextval('fao.tenant_sync_configurations_id_seq'::regclass);


--
-- Name: use_case_descriptions id; Type: DEFAULT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.use_case_descriptions ALTER COLUMN id SET DEFAULT nextval('fao.use_case_descriptions_id_seq'::regclass);


--
-- Name: use_case_headers id; Type: DEFAULT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.use_case_headers ALTER COLUMN id SET DEFAULT nextval('fao.use_case_headers_id_seq'::regclass);


--
-- Name: use_case_step_descriptions id; Type: DEFAULT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.use_case_step_descriptions ALTER COLUMN id SET DEFAULT nextval('fao.use_case_step_descriptions_id_seq'::regclass);


--
-- Name: use_case_steps id; Type: DEFAULT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.use_case_steps ALTER COLUMN id SET DEFAULT nextval('fao.use_case_steps_id_seq'::regclass);


--
-- Name: use_case_steps_building_blocks id; Type: DEFAULT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.use_case_steps_building_blocks ALTER COLUMN id SET DEFAULT nextval('fao.use_case_steps_building_blocks_id_seq'::regclass);


--
-- Name: use_case_steps_datasets id; Type: DEFAULT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.use_case_steps_datasets ALTER COLUMN id SET DEFAULT nextval('fao.use_case_steps_datasets_id_seq'::regclass);


--
-- Name: use_case_steps_products id; Type: DEFAULT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.use_case_steps_products ALTER COLUMN id SET DEFAULT nextval('fao.use_case_steps_products_id_seq'::regclass);


--
-- Name: use_cases id; Type: DEFAULT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.use_cases ALTER COLUMN id SET DEFAULT nextval('fao.use_cases_id_seq'::regclass);


--
-- Name: user_events id; Type: DEFAULT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.user_events ALTER COLUMN id SET DEFAULT nextval('fao.user_events_id_seq'::regclass);


--
-- Name: user_messages id; Type: DEFAULT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.user_messages ALTER COLUMN id SET DEFAULT nextval('fao.user_messages_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.users ALTER COLUMN id SET DEFAULT nextval('fao.users_id_seq'::regclass);


--
-- Name: workflow_descriptions id; Type: DEFAULT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.workflow_descriptions ALTER COLUMN id SET DEFAULT nextval('fao.workflow_descriptions_id_seq'::regclass);


--
-- Name: workflows id; Type: DEFAULT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.workflows ALTER COLUMN id SET DEFAULT nextval('fao.workflows_id_seq'::regclass);


--
-- Name: aggregator_capabilities id; Type: DEFAULT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.aggregator_capabilities ALTER COLUMN id SET DEFAULT nextval('health.aggregator_capabilities_id_seq'::regclass);


--
-- Name: audits id; Type: DEFAULT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.audits ALTER COLUMN id SET DEFAULT nextval('health.audits_id_seq'::regclass);


--
-- Name: authors id; Type: DEFAULT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.authors ALTER COLUMN id SET DEFAULT nextval('health.authors_id_seq'::regclass);


--
-- Name: building_block_descriptions id; Type: DEFAULT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.building_block_descriptions ALTER COLUMN id SET DEFAULT nextval('health.building_block_descriptions_id_seq'::regclass);


--
-- Name: building_blocks id; Type: DEFAULT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.building_blocks ALTER COLUMN id SET DEFAULT nextval('health.building_blocks_id_seq'::regclass);


--
-- Name: candidate_datasets id; Type: DEFAULT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.candidate_datasets ALTER COLUMN id SET DEFAULT nextval('health.candidate_datasets_id_seq'::regclass);


--
-- Name: candidate_organizations id; Type: DEFAULT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.candidate_organizations ALTER COLUMN id SET DEFAULT nextval('health.candidate_organizations_id_seq'::regclass);


--
-- Name: candidate_products id; Type: DEFAULT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.candidate_products ALTER COLUMN id SET DEFAULT nextval('health.candidate_products_id_seq'::regclass);


--
-- Name: candidate_resources id; Type: DEFAULT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.candidate_resources ALTER COLUMN id SET DEFAULT nextval('health.candidate_resources_id_seq'::regclass);


--
-- Name: candidate_resources_countries id; Type: DEFAULT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.candidate_resources_countries ALTER COLUMN id SET DEFAULT nextval('health.candidate_resources_countries_id_seq'::regclass);


--
-- Name: candidate_roles id; Type: DEFAULT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.candidate_roles ALTER COLUMN id SET DEFAULT nextval('health.candidate_roles_id_seq'::regclass);


--
-- Name: category_indicator_descriptions id; Type: DEFAULT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.category_indicator_descriptions ALTER COLUMN id SET DEFAULT nextval('health.category_indicator_descriptions_id_seq'::regclass);


--
-- Name: category_indicators id; Type: DEFAULT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.category_indicators ALTER COLUMN id SET DEFAULT nextval('health.category_indicators_id_seq'::regclass);


--
-- Name: chatbot_conversations id; Type: DEFAULT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.chatbot_conversations ALTER COLUMN id SET DEFAULT nextval('health.chatbot_conversations_id_seq'::regclass);


--
-- Name: cities id; Type: DEFAULT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.cities ALTER COLUMN id SET DEFAULT nextval('health.cities_id_seq'::regclass);


--
-- Name: ckeditor_assets id; Type: DEFAULT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.ckeditor_assets ALTER COLUMN id SET DEFAULT nextval('health.ckeditor_assets_id_seq'::regclass);


--
-- Name: classifications id; Type: DEFAULT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.classifications ALTER COLUMN id SET DEFAULT nextval('health.classifications_id_seq'::regclass);


--
-- Name: comments id; Type: DEFAULT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.comments ALTER COLUMN id SET DEFAULT nextval('health.comments_id_seq'::regclass);


--
-- Name: contacts id; Type: DEFAULT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.contacts ALTER COLUMN id SET DEFAULT nextval('health.contacts_id_seq'::regclass);


--
-- Name: countries id; Type: DEFAULT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.countries ALTER COLUMN id SET DEFAULT nextval('health.countries_id_seq'::regclass);


--
-- Name: dataset_descriptions id; Type: DEFAULT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.dataset_descriptions ALTER COLUMN id SET DEFAULT nextval('health.dataset_descriptions_id_seq'::regclass);


--
-- Name: dataset_sectors id; Type: DEFAULT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.dataset_sectors ALTER COLUMN id SET DEFAULT nextval('health.dataset_sectors_id_seq'::regclass);


--
-- Name: dataset_sustainable_development_goals id; Type: DEFAULT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.dataset_sustainable_development_goals ALTER COLUMN id SET DEFAULT nextval('health.dataset_sustainable_development_goals_id_seq'::regclass);


--
-- Name: datasets id; Type: DEFAULT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.datasets ALTER COLUMN id SET DEFAULT nextval('health.datasets_id_seq'::regclass);


--
-- Name: datasets_countries id; Type: DEFAULT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.datasets_countries ALTER COLUMN id SET DEFAULT nextval('health.datasets_countries_id_seq'::regclass);


--
-- Name: datasets_origins id; Type: DEFAULT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.datasets_origins ALTER COLUMN id SET DEFAULT nextval('health.datasets_origins_id_seq'::regclass);


--
-- Name: deploys id; Type: DEFAULT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.deploys ALTER COLUMN id SET DEFAULT nextval('health.deploys_id_seq'::regclass);


--
-- Name: dial_spreadsheet_data id; Type: DEFAULT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.dial_spreadsheet_data ALTER COLUMN id SET DEFAULT nextval('health.dial_spreadsheet_data_id_seq'::regclass);


--
-- Name: digital_principles id; Type: DEFAULT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.digital_principles ALTER COLUMN id SET DEFAULT nextval('health.digital_principles_id_seq'::regclass);


--
-- Name: districts id; Type: DEFAULT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.districts ALTER COLUMN id SET DEFAULT nextval('health.districts_id_seq'::regclass);


--
-- Name: endorsers id; Type: DEFAULT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.endorsers ALTER COLUMN id SET DEFAULT nextval('health.endorsers_id_seq'::regclass);


--
-- Name: exchange_tenants id; Type: DEFAULT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.exchange_tenants ALTER COLUMN id SET DEFAULT nextval('health.exchange_tenants_id_seq'::regclass);


--
-- Name: froala_images id; Type: DEFAULT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.froala_images ALTER COLUMN id SET DEFAULT nextval('health.froala_images_id_seq'::regclass);


--
-- Name: glossaries id; Type: DEFAULT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.glossaries ALTER COLUMN id SET DEFAULT nextval('health.glossaries_id_seq'::regclass);


--
-- Name: handbook_answers id; Type: DEFAULT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.handbook_answers ALTER COLUMN id SET DEFAULT nextval('health.handbook_answers_id_seq'::regclass);


--
-- Name: handbook_descriptions id; Type: DEFAULT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.handbook_descriptions ALTER COLUMN id SET DEFAULT nextval('health.handbook_descriptions_id_seq'::regclass);


--
-- Name: handbook_pages id; Type: DEFAULT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.handbook_pages ALTER COLUMN id SET DEFAULT nextval('health.handbook_pages_id_seq'::regclass);


--
-- Name: handbook_questions id; Type: DEFAULT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.handbook_questions ALTER COLUMN id SET DEFAULT nextval('health.handbook_questions_id_seq'::regclass);


--
-- Name: handbooks id; Type: DEFAULT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.handbooks ALTER COLUMN id SET DEFAULT nextval('health.handbooks_id_seq'::regclass);


--
-- Name: messages id; Type: DEFAULT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.messages ALTER COLUMN id SET DEFAULT nextval('health.messages_id_seq'::regclass);


--
-- Name: offices id; Type: DEFAULT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.offices ALTER COLUMN id SET DEFAULT nextval('health.offices_id_seq'::regclass);


--
-- Name: operator_services id; Type: DEFAULT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.operator_services ALTER COLUMN id SET DEFAULT nextval('health.operator_services_id_seq'::regclass);


--
-- Name: opportunities id; Type: DEFAULT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.opportunities ALTER COLUMN id SET DEFAULT nextval('health.opportunities_id_seq'::regclass);


--
-- Name: organization_contacts id; Type: DEFAULT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.organization_contacts ALTER COLUMN id SET DEFAULT nextval('health.organization_contacts_id_seq'::regclass);


--
-- Name: organization_datasets id; Type: DEFAULT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.organization_datasets ALTER COLUMN id SET DEFAULT nextval('health.organization_datasets_id_seq'::regclass);


--
-- Name: organization_descriptions id; Type: DEFAULT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.organization_descriptions ALTER COLUMN id SET DEFAULT nextval('health.organization_descriptions_id_seq'::regclass);


--
-- Name: organization_products id; Type: DEFAULT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.organization_products ALTER COLUMN id SET DEFAULT nextval('health.organization_products_id_seq'::regclass);


--
-- Name: organizations id; Type: DEFAULT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.organizations ALTER COLUMN id SET DEFAULT nextval('health.organizations_id_seq'::regclass);


--
-- Name: organizations_countries id; Type: DEFAULT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.organizations_countries ALTER COLUMN id SET DEFAULT nextval('health.organizations_countries_id_seq'::regclass);


--
-- Name: organizations_resources id; Type: DEFAULT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.organizations_resources ALTER COLUMN id SET DEFAULT nextval('health.organizations_resources_id_seq'::regclass);


--
-- Name: origins id; Type: DEFAULT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.origins ALTER COLUMN id SET DEFAULT nextval('health.origins_id_seq'::regclass);


--
-- Name: page_contents id; Type: DEFAULT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.page_contents ALTER COLUMN id SET DEFAULT nextval('health.page_contents_id_seq'::regclass);


--
-- Name: play_descriptions id; Type: DEFAULT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.play_descriptions ALTER COLUMN id SET DEFAULT nextval('health.play_descriptions_id_seq'::regclass);


--
-- Name: play_move_descriptions id; Type: DEFAULT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.play_move_descriptions ALTER COLUMN id SET DEFAULT nextval('health.play_move_descriptions_id_seq'::regclass);


--
-- Name: play_moves id; Type: DEFAULT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.play_moves ALTER COLUMN id SET DEFAULT nextval('health.play_moves_id_seq'::regclass);


--
-- Name: play_moves_resources id; Type: DEFAULT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.play_moves_resources ALTER COLUMN id SET DEFAULT nextval('health.play_moves_resources_id_seq'::regclass);


--
-- Name: playbook_descriptions id; Type: DEFAULT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.playbook_descriptions ALTER COLUMN id SET DEFAULT nextval('health.playbook_descriptions_id_seq'::regclass);


--
-- Name: playbook_plays id; Type: DEFAULT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.playbook_plays ALTER COLUMN id SET DEFAULT nextval('health.playbook_plays_id_seq'::regclass);


--
-- Name: playbooks id; Type: DEFAULT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.playbooks ALTER COLUMN id SET DEFAULT nextval('health.playbooks_id_seq'::regclass);


--
-- Name: plays id; Type: DEFAULT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.plays ALTER COLUMN id SET DEFAULT nextval('health.plays_id_seq'::regclass);


--
-- Name: plays_building_blocks id; Type: DEFAULT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.plays_building_blocks ALTER COLUMN id SET DEFAULT nextval('health.plays_building_blocks_id_seq'::regclass);


--
-- Name: plays_products id; Type: DEFAULT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.plays_products ALTER COLUMN id SET DEFAULT nextval('health.plays_products_id_seq'::regclass);


--
-- Name: plays_subplays id; Type: DEFAULT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.plays_subplays ALTER COLUMN id SET DEFAULT nextval('health.plays_subplays_id_seq'::regclass);


--
-- Name: portal_views id; Type: DEFAULT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.portal_views ALTER COLUMN id SET DEFAULT nextval('health.portal_views_id_seq'::regclass);


--
-- Name: principle_descriptions id; Type: DEFAULT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.principle_descriptions ALTER COLUMN id SET DEFAULT nextval('health.principle_descriptions_id_seq'::regclass);


--
-- Name: product_building_blocks id; Type: DEFAULT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.product_building_blocks ALTER COLUMN id SET DEFAULT nextval('health.product_building_blocks_id_seq'::regclass);


--
-- Name: product_classifications id; Type: DEFAULT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.product_classifications ALTER COLUMN id SET DEFAULT nextval('health.product_classifications_id_seq'::regclass);


--
-- Name: product_descriptions id; Type: DEFAULT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.product_descriptions ALTER COLUMN id SET DEFAULT nextval('health.product_descriptions_id_seq'::regclass);


--
-- Name: product_indicators id; Type: DEFAULT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.product_indicators ALTER COLUMN id SET DEFAULT nextval('health.product_indicators_id_seq'::regclass);


--
-- Name: product_product_relationships id; Type: DEFAULT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.product_product_relationships ALTER COLUMN id SET DEFAULT nextval('health.product_product_relationships_id_seq'::regclass);


--
-- Name: product_repositories id; Type: DEFAULT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.product_repositories ALTER COLUMN id SET DEFAULT nextval('health.product_repositories_id_seq'::regclass);


--
-- Name: product_sectors id; Type: DEFAULT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.product_sectors ALTER COLUMN id SET DEFAULT nextval('health.product_sectors_id_seq'::regclass);


--
-- Name: product_sustainable_development_goals id; Type: DEFAULT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.product_sustainable_development_goals ALTER COLUMN id SET DEFAULT nextval('health.product_sustainable_development_goals_id_seq'::regclass);


--
-- Name: products id; Type: DEFAULT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.products ALTER COLUMN id SET DEFAULT nextval('health.products_id_seq'::regclass);


--
-- Name: products_countries id; Type: DEFAULT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.products_countries ALTER COLUMN id SET DEFAULT nextval('health.products_countries_id_seq'::regclass);


--
-- Name: products_endorsers id; Type: DEFAULT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.products_endorsers ALTER COLUMN id SET DEFAULT nextval('health.products_endorsers_id_seq'::regclass);


--
-- Name: project_descriptions id; Type: DEFAULT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.project_descriptions ALTER COLUMN id SET DEFAULT nextval('health.project_descriptions_id_seq'::regclass);


--
-- Name: projects id; Type: DEFAULT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.projects ALTER COLUMN id SET DEFAULT nextval('health.projects_id_seq'::regclass);


--
-- Name: projects_countries id; Type: DEFAULT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.projects_countries ALTER COLUMN id SET DEFAULT nextval('health.projects_countries_id_seq'::regclass);


--
-- Name: projects_digital_principles id; Type: DEFAULT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.projects_digital_principles ALTER COLUMN id SET DEFAULT nextval('health.projects_digital_principles_id_seq'::regclass);


--
-- Name: provinces id; Type: DEFAULT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.provinces ALTER COLUMN id SET DEFAULT nextval('health.provinces_id_seq'::regclass);


--
-- Name: regions id; Type: DEFAULT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.regions ALTER COLUMN id SET DEFAULT nextval('health.regions_id_seq'::regclass);


--
-- Name: resource_building_blocks id; Type: DEFAULT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.resource_building_blocks ALTER COLUMN id SET DEFAULT nextval('health.resource_building_blocks_id_seq'::regclass);


--
-- Name: resource_topic_descriptions id; Type: DEFAULT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.resource_topic_descriptions ALTER COLUMN id SET DEFAULT nextval('health.resource_topic_descriptions_id_seq'::regclass);


--
-- Name: resource_topics id; Type: DEFAULT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.resource_topics ALTER COLUMN id SET DEFAULT nextval('health.resource_topics_id_seq'::regclass);


--
-- Name: resource_types id; Type: DEFAULT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.resource_types ALTER COLUMN id SET DEFAULT nextval('health.resource_types_id_seq'::regclass);


--
-- Name: resources id; Type: DEFAULT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.resources ALTER COLUMN id SET DEFAULT nextval('health.resources_id_seq'::regclass);


--
-- Name: resources_use_cases id; Type: DEFAULT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.resources_use_cases ALTER COLUMN id SET DEFAULT nextval('health.resources_use_cases_id_seq'::regclass);


--
-- Name: rubric_categories id; Type: DEFAULT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.rubric_categories ALTER COLUMN id SET DEFAULT nextval('health.rubric_categories_id_seq'::regclass);


--
-- Name: rubric_category_descriptions id; Type: DEFAULT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.rubric_category_descriptions ALTER COLUMN id SET DEFAULT nextval('health.rubric_category_descriptions_id_seq'::regclass);


--
-- Name: sdg_targets id; Type: DEFAULT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.sdg_targets ALTER COLUMN id SET DEFAULT nextval('health.sdg_targets_id_seq'::regclass);


--
-- Name: sectors id; Type: DEFAULT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.sectors ALTER COLUMN id SET DEFAULT nextval('health.sectors_id_seq'::regclass);


--
-- Name: sessions id; Type: DEFAULT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.sessions ALTER COLUMN id SET DEFAULT nextval('health.sessions_id_seq'::regclass);


--
-- Name: settings id; Type: DEFAULT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.settings ALTER COLUMN id SET DEFAULT nextval('health.settings_id_seq'::regclass);


--
-- Name: software_categories id; Type: DEFAULT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.software_categories ALTER COLUMN id SET DEFAULT nextval('health.software_categories_id_seq'::regclass);


--
-- Name: software_features id; Type: DEFAULT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.software_features ALTER COLUMN id SET DEFAULT nextval('health.software_features_id_seq'::regclass);


--
-- Name: starred_objects id; Type: DEFAULT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.starred_objects ALTER COLUMN id SET DEFAULT nextval('health.starred_objects_id_seq'::regclass);


--
-- Name: stylesheets id; Type: DEFAULT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.stylesheets ALTER COLUMN id SET DEFAULT nextval('health.stylesheets_id_seq'::regclass);


--
-- Name: sustainable_development_goals id; Type: DEFAULT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.sustainable_development_goals ALTER COLUMN id SET DEFAULT nextval('health.sustainable_development_goals_id_seq'::regclass);


--
-- Name: tag_descriptions id; Type: DEFAULT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.tag_descriptions ALTER COLUMN id SET DEFAULT nextval('health.tag_descriptions_id_seq'::regclass);


--
-- Name: tags id; Type: DEFAULT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.tags ALTER COLUMN id SET DEFAULT nextval('health.tags_id_seq'::regclass);


--
-- Name: task_tracker_descriptions id; Type: DEFAULT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.task_tracker_descriptions ALTER COLUMN id SET DEFAULT nextval('health.task_tracker_descriptions_id_seq'::regclass);


--
-- Name: task_trackers id; Type: DEFAULT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.task_trackers ALTER COLUMN id SET DEFAULT nextval('health.task_trackers_id_seq'::regclass);


--
-- Name: tenant_sync_configurations id; Type: DEFAULT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.tenant_sync_configurations ALTER COLUMN id SET DEFAULT nextval('health.tenant_sync_configurations_id_seq'::regclass);


--
-- Name: use_case_descriptions id; Type: DEFAULT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.use_case_descriptions ALTER COLUMN id SET DEFAULT nextval('health.use_case_descriptions_id_seq'::regclass);


--
-- Name: use_case_headers id; Type: DEFAULT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.use_case_headers ALTER COLUMN id SET DEFAULT nextval('health.use_case_headers_id_seq'::regclass);


--
-- Name: use_case_step_descriptions id; Type: DEFAULT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.use_case_step_descriptions ALTER COLUMN id SET DEFAULT nextval('health.use_case_step_descriptions_id_seq'::regclass);


--
-- Name: use_case_steps id; Type: DEFAULT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.use_case_steps ALTER COLUMN id SET DEFAULT nextval('health.use_case_steps_id_seq'::regclass);


--
-- Name: use_case_steps_building_blocks id; Type: DEFAULT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.use_case_steps_building_blocks ALTER COLUMN id SET DEFAULT nextval('health.use_case_steps_building_blocks_id_seq'::regclass);


--
-- Name: use_case_steps_datasets id; Type: DEFAULT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.use_case_steps_datasets ALTER COLUMN id SET DEFAULT nextval('health.use_case_steps_datasets_id_seq'::regclass);


--
-- Name: use_case_steps_products id; Type: DEFAULT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.use_case_steps_products ALTER COLUMN id SET DEFAULT nextval('health.use_case_steps_products_id_seq'::regclass);


--
-- Name: use_cases id; Type: DEFAULT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.use_cases ALTER COLUMN id SET DEFAULT nextval('health.use_cases_id_seq'::regclass);


--
-- Name: user_events id; Type: DEFAULT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.user_events ALTER COLUMN id SET DEFAULT nextval('health.user_events_id_seq'::regclass);


--
-- Name: user_messages id; Type: DEFAULT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.user_messages ALTER COLUMN id SET DEFAULT nextval('health.user_messages_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.users ALTER COLUMN id SET DEFAULT nextval('health.users_id_seq'::regclass);


--
-- Name: workflow_descriptions id; Type: DEFAULT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.workflow_descriptions ALTER COLUMN id SET DEFAULT nextval('health.workflow_descriptions_id_seq'::regclass);


--
-- Name: workflows id; Type: DEFAULT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.workflows ALTER COLUMN id SET DEFAULT nextval('health.workflows_id_seq'::regclass);


--
-- Name: aggregator_capabilities id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.aggregator_capabilities ALTER COLUMN id SET DEFAULT nextval('public.aggregator_capabilities_id_seq'::regclass);


--
-- Name: audits id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.audits ALTER COLUMN id SET DEFAULT nextval('public.audits_id_seq'::regclass);


--
-- Name: authors id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.authors ALTER COLUMN id SET DEFAULT nextval('public.authors_id_seq'::regclass);


--
-- Name: building_block_descriptions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.building_block_descriptions ALTER COLUMN id SET DEFAULT nextval('public.building_block_descriptions_id_seq'::regclass);


--
-- Name: building_blocks id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.building_blocks ALTER COLUMN id SET DEFAULT nextval('public.building_blocks_id_seq'::regclass);


--
-- Name: candidate_datasets id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.candidate_datasets ALTER COLUMN id SET DEFAULT nextval('public.candidate_datasets_id_seq'::regclass);


--
-- Name: candidate_organizations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.candidate_organizations ALTER COLUMN id SET DEFAULT nextval('public.candidate_organizations_id_seq'::regclass);


--
-- Name: candidate_products id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.candidate_products ALTER COLUMN id SET DEFAULT nextval('public.candidate_products_id_seq'::regclass);


--
-- Name: candidate_resources id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.candidate_resources ALTER COLUMN id SET DEFAULT nextval('public.candidate_resources_id_seq'::regclass);


--
-- Name: candidate_resources_countries id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.candidate_resources_countries ALTER COLUMN id SET DEFAULT nextval('public.candidate_resources_countries_id_seq'::regclass);


--
-- Name: candidate_roles id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.candidate_roles ALTER COLUMN id SET DEFAULT nextval('public.candidate_roles_id_seq'::regclass);


--
-- Name: category_indicator_descriptions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.category_indicator_descriptions ALTER COLUMN id SET DEFAULT nextval('public.category_indicator_descriptions_id_seq'::regclass);


--
-- Name: category_indicators id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.category_indicators ALTER COLUMN id SET DEFAULT nextval('public.category_indicators_id_seq'::regclass);


--
-- Name: chatbot_conversations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chatbot_conversations ALTER COLUMN id SET DEFAULT nextval('public.chatbot_conversations_id_seq'::regclass);


--
-- Name: cities id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cities ALTER COLUMN id SET DEFAULT nextval('public.cities_id_seq'::regclass);


--
-- Name: ckeditor_assets id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ckeditor_assets ALTER COLUMN id SET DEFAULT nextval('public.ckeditor_assets_id_seq'::regclass);


--
-- Name: classifications id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.classifications ALTER COLUMN id SET DEFAULT nextval('public.classifications_id_seq'::regclass);


--
-- Name: comments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.comments ALTER COLUMN id SET DEFAULT nextval('public.comments_id_seq'::regclass);


--
-- Name: contacts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.contacts ALTER COLUMN id SET DEFAULT nextval('public.contacts_id_seq'::regclass);


--
-- Name: countries id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.countries ALTER COLUMN id SET DEFAULT nextval('public.countries_id_seq'::regclass);


--
-- Name: dataset_descriptions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dataset_descriptions ALTER COLUMN id SET DEFAULT nextval('public.dataset_descriptions_id_seq'::regclass);


--
-- Name: dataset_sectors id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dataset_sectors ALTER COLUMN id SET DEFAULT nextval('public.dataset_sectors_id_seq'::regclass);


--
-- Name: dataset_sustainable_development_goals id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dataset_sustainable_development_goals ALTER COLUMN id SET DEFAULT nextval('public.dataset_sustainable_development_goals_id_seq'::regclass);


--
-- Name: datasets id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.datasets ALTER COLUMN id SET DEFAULT nextval('public.datasets_id_seq'::regclass);


--
-- Name: datasets_countries id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.datasets_countries ALTER COLUMN id SET DEFAULT nextval('public.datasets_countries_id_seq'::regclass);


--
-- Name: datasets_origins id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.datasets_origins ALTER COLUMN id SET DEFAULT nextval('public.datasets_origins_id_seq'::regclass);


--
-- Name: deploys id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.deploys ALTER COLUMN id SET DEFAULT nextval('public.deploys_id_seq'::regclass);


--
-- Name: dial_spreadsheet_data id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dial_spreadsheet_data ALTER COLUMN id SET DEFAULT nextval('public.dial_spreadsheet_data_id_seq'::regclass);


--
-- Name: digital_principles id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.digital_principles ALTER COLUMN id SET DEFAULT nextval('public.digital_principles_id_seq'::regclass);


--
-- Name: districts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.districts ALTER COLUMN id SET DEFAULT nextval('public.districts_id_seq'::regclass);


--
-- Name: endorsers id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.endorsers ALTER COLUMN id SET DEFAULT nextval('public.endorsers_id_seq'::regclass);


--
-- Name: exchange_tenants id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.exchange_tenants ALTER COLUMN id SET DEFAULT nextval('public.exchange_tenants_id_seq'::regclass);


--
-- Name: froala_images id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.froala_images ALTER COLUMN id SET DEFAULT nextval('public.froala_images_id_seq'::regclass);


--
-- Name: glossaries id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.glossaries ALTER COLUMN id SET DEFAULT nextval('public.glossaries_id_seq'::regclass);


--
-- Name: handbook_answers id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.handbook_answers ALTER COLUMN id SET DEFAULT nextval('public.handbook_answers_id_seq'::regclass);


--
-- Name: handbook_descriptions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.handbook_descriptions ALTER COLUMN id SET DEFAULT nextval('public.handbook_descriptions_id_seq'::regclass);


--
-- Name: handbook_pages id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.handbook_pages ALTER COLUMN id SET DEFAULT nextval('public.handbook_pages_id_seq'::regclass);


--
-- Name: handbook_questions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.handbook_questions ALTER COLUMN id SET DEFAULT nextval('public.handbook_questions_id_seq'::regclass);


--
-- Name: handbooks id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.handbooks ALTER COLUMN id SET DEFAULT nextval('public.handbooks_id_seq'::regclass);


--
-- Name: messages id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.messages ALTER COLUMN id SET DEFAULT nextval('public.messages_id_seq'::regclass);


--
-- Name: offices id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.offices ALTER COLUMN id SET DEFAULT nextval('public.offices_id_seq'::regclass);


--
-- Name: operator_services id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.operator_services ALTER COLUMN id SET DEFAULT nextval('public.operator_services_id_seq'::regclass);


--
-- Name: opportunities id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.opportunities ALTER COLUMN id SET DEFAULT nextval('public.opportunities_id_seq'::regclass);


--
-- Name: organization_contacts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organization_contacts ALTER COLUMN id SET DEFAULT nextval('public.organization_contacts_id_seq'::regclass);


--
-- Name: organization_datasets id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organization_datasets ALTER COLUMN id SET DEFAULT nextval('public.organization_datasets_id_seq'::regclass);


--
-- Name: organization_descriptions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organization_descriptions ALTER COLUMN id SET DEFAULT nextval('public.organization_descriptions_id_seq'::regclass);


--
-- Name: organization_products id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organization_products ALTER COLUMN id SET DEFAULT nextval('public.organization_products_id_seq'::regclass);


--
-- Name: organizations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organizations ALTER COLUMN id SET DEFAULT nextval('public.organizations_id_seq'::regclass);


--
-- Name: organizations_countries id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organizations_countries ALTER COLUMN id SET DEFAULT nextval('public.organizations_countries_id_seq'::regclass);


--
-- Name: organizations_resources id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organizations_resources ALTER COLUMN id SET DEFAULT nextval('public.organizations_resources_id_seq'::regclass);


--
-- Name: origins id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.origins ALTER COLUMN id SET DEFAULT nextval('public.origins_id_seq'::regclass);


--
-- Name: page_contents id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.page_contents ALTER COLUMN id SET DEFAULT nextval('public.page_contents_id_seq'::regclass);


--
-- Name: play_descriptions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.play_descriptions ALTER COLUMN id SET DEFAULT nextval('public.play_descriptions_id_seq'::regclass);


--
-- Name: play_move_descriptions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.play_move_descriptions ALTER COLUMN id SET DEFAULT nextval('public.play_move_descriptions_id_seq'::regclass);


--
-- Name: play_moves id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.play_moves ALTER COLUMN id SET DEFAULT nextval('public.play_moves_id_seq'::regclass);


--
-- Name: play_moves_resources id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.play_moves_resources ALTER COLUMN id SET DEFAULT nextval('public.play_moves_resources_id_seq'::regclass);


--
-- Name: playbook_descriptions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.playbook_descriptions ALTER COLUMN id SET DEFAULT nextval('public.playbook_descriptions_id_seq'::regclass);


--
-- Name: playbook_plays id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.playbook_plays ALTER COLUMN id SET DEFAULT nextval('public.playbook_plays_id_seq'::regclass);


--
-- Name: playbooks id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.playbooks ALTER COLUMN id SET DEFAULT nextval('public.playbooks_id_seq'::regclass);


--
-- Name: plays id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.plays ALTER COLUMN id SET DEFAULT nextval('public.plays_id_seq'::regclass);


--
-- Name: plays_building_blocks id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.plays_building_blocks ALTER COLUMN id SET DEFAULT nextval('public.plays_building_blocks_id_seq'::regclass);


--
-- Name: plays_products id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.plays_products ALTER COLUMN id SET DEFAULT nextval('public.plays_products_id_seq'::regclass);


--
-- Name: plays_subplays id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.plays_subplays ALTER COLUMN id SET DEFAULT nextval('public.plays_subplays_id_seq'::regclass);


--
-- Name: portal_views id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.portal_views ALTER COLUMN id SET DEFAULT nextval('public.portal_views_id_seq'::regclass);


--
-- Name: principle_descriptions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.principle_descriptions ALTER COLUMN id SET DEFAULT nextval('public.principle_descriptions_id_seq'::regclass);


--
-- Name: product_building_blocks id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_building_blocks ALTER COLUMN id SET DEFAULT nextval('public.product_building_blocks_id_seq'::regclass);


--
-- Name: product_classifications id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_classifications ALTER COLUMN id SET DEFAULT nextval('public.product_classifications_id_seq'::regclass);


--
-- Name: product_descriptions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_descriptions ALTER COLUMN id SET DEFAULT nextval('public.product_descriptions_id_seq'::regclass);


--
-- Name: product_indicators id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_indicators ALTER COLUMN id SET DEFAULT nextval('public.product_indicators_id_seq'::regclass);


--
-- Name: product_product_relationships id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_product_relationships ALTER COLUMN id SET DEFAULT nextval('public.product_product_relationships_id_seq'::regclass);


--
-- Name: product_repositories id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_repositories ALTER COLUMN id SET DEFAULT nextval('public.product_repositories_id_seq'::regclass);


--
-- Name: product_sectors id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_sectors ALTER COLUMN id SET DEFAULT nextval('public.product_sectors_id_seq'::regclass);


--
-- Name: product_sustainable_development_goals id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_sustainable_development_goals ALTER COLUMN id SET DEFAULT nextval('public.product_sustainable_development_goals_id_seq'::regclass);


--
-- Name: products id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.products ALTER COLUMN id SET DEFAULT nextval('public.products_id_seq'::regclass);


--
-- Name: products_countries id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.products_countries ALTER COLUMN id SET DEFAULT nextval('public.products_countries_id_seq'::regclass);


--
-- Name: products_endorsers id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.products_endorsers ALTER COLUMN id SET DEFAULT nextval('public.products_endorsers_id_seq'::regclass);


--
-- Name: project_descriptions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.project_descriptions ALTER COLUMN id SET DEFAULT nextval('public.project_descriptions_id_seq'::regclass);


--
-- Name: projects id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.projects ALTER COLUMN id SET DEFAULT nextval('public.projects_id_seq'::regclass);


--
-- Name: projects_countries id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.projects_countries ALTER COLUMN id SET DEFAULT nextval('public.projects_countries_id_seq'::regclass);


--
-- Name: projects_digital_principles id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.projects_digital_principles ALTER COLUMN id SET DEFAULT nextval('public.projects_digital_principles_id_seq'::regclass);


--
-- Name: provinces id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.provinces ALTER COLUMN id SET DEFAULT nextval('public.provinces_id_seq'::regclass);


--
-- Name: regions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.regions ALTER COLUMN id SET DEFAULT nextval('public.regions_id_seq'::regclass);


--
-- Name: resource_building_blocks id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.resource_building_blocks ALTER COLUMN id SET DEFAULT nextval('public.resource_building_blocks_id_seq'::regclass);


--
-- Name: resource_topic_descriptions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.resource_topic_descriptions ALTER COLUMN id SET DEFAULT nextval('public.resource_topic_descriptions_id_seq'::regclass);


--
-- Name: resource_topics id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.resource_topics ALTER COLUMN id SET DEFAULT nextval('public.resource_topics_id_seq'::regclass);


--
-- Name: resource_types id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.resource_types ALTER COLUMN id SET DEFAULT nextval('public.resource_types_id_seq'::regclass);


--
-- Name: resources id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.resources ALTER COLUMN id SET DEFAULT nextval('public.resources_id_seq'::regclass);


--
-- Name: resources_use_cases id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.resources_use_cases ALTER COLUMN id SET DEFAULT nextval('public.resources_use_cases_id_seq'::regclass);


--
-- Name: rubric_categories id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rubric_categories ALTER COLUMN id SET DEFAULT nextval('public.rubric_categories_id_seq'::regclass);


--
-- Name: rubric_category_descriptions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rubric_category_descriptions ALTER COLUMN id SET DEFAULT nextval('public.rubric_category_descriptions_id_seq'::regclass);


--
-- Name: sdg_targets id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sdg_targets ALTER COLUMN id SET DEFAULT nextval('public.sdg_targets_id_seq'::regclass);


--
-- Name: sectors id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sectors ALTER COLUMN id SET DEFAULT nextval('public.sectors_id_seq'::regclass);


--
-- Name: sessions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sessions ALTER COLUMN id SET DEFAULT nextval('public.sessions_id_seq'::regclass);


--
-- Name: settings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.settings ALTER COLUMN id SET DEFAULT nextval('public.settings_id_seq'::regclass);


--
-- Name: software_categories id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.software_categories ALTER COLUMN id SET DEFAULT nextval('public.software_categories_id_seq'::regclass);


--
-- Name: software_features id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.software_features ALTER COLUMN id SET DEFAULT nextval('public.software_features_id_seq'::regclass);


--
-- Name: starred_objects id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.starred_objects ALTER COLUMN id SET DEFAULT nextval('public.starred_objects_id_seq'::regclass);


--
-- Name: stylesheets id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stylesheets ALTER COLUMN id SET DEFAULT nextval('public.stylesheets_id_seq'::regclass);


--
-- Name: sustainable_development_goals id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sustainable_development_goals ALTER COLUMN id SET DEFAULT nextval('public.sustainable_development_goals_id_seq'::regclass);


--
-- Name: tag_descriptions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tag_descriptions ALTER COLUMN id SET DEFAULT nextval('public.tag_descriptions_id_seq'::regclass);


--
-- Name: tags id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tags ALTER COLUMN id SET DEFAULT nextval('public.tags_id_seq'::regclass);


--
-- Name: task_tracker_descriptions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.task_tracker_descriptions ALTER COLUMN id SET DEFAULT nextval('public.task_tracker_descriptions_id_seq'::regclass);


--
-- Name: task_trackers id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.task_trackers ALTER COLUMN id SET DEFAULT nextval('public.task_trackers_id_seq'::regclass);


--
-- Name: tenant_sync_configurations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tenant_sync_configurations ALTER COLUMN id SET DEFAULT nextval('public.tenant_sync_configurations_id_seq'::regclass);


--
-- Name: use_case_descriptions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.use_case_descriptions ALTER COLUMN id SET DEFAULT nextval('public.use_case_descriptions_id_seq'::regclass);


--
-- Name: use_case_headers id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.use_case_headers ALTER COLUMN id SET DEFAULT nextval('public.use_case_headers_id_seq'::regclass);


--
-- Name: use_case_step_descriptions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.use_case_step_descriptions ALTER COLUMN id SET DEFAULT nextval('public.use_case_step_descriptions_id_seq'::regclass);


--
-- Name: use_case_steps id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.use_case_steps ALTER COLUMN id SET DEFAULT nextval('public.use_case_steps_id_seq'::regclass);


--
-- Name: use_case_steps_building_blocks id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.use_case_steps_building_blocks ALTER COLUMN id SET DEFAULT nextval('public.use_case_steps_building_blocks_id_seq'::regclass);


--
-- Name: use_case_steps_datasets id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.use_case_steps_datasets ALTER COLUMN id SET DEFAULT nextval('public.use_case_steps_datasets_id_seq'::regclass);


--
-- Name: use_case_steps_products id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.use_case_steps_products ALTER COLUMN id SET DEFAULT nextval('public.use_case_steps_products_id_seq'::regclass);


--
-- Name: use_cases id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.use_cases ALTER COLUMN id SET DEFAULT nextval('public.use_cases_id_seq'::regclass);


--
-- Name: user_events id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_events ALTER COLUMN id SET DEFAULT nextval('public.user_events_id_seq'::regclass);


--
-- Name: user_messages id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_messages ALTER COLUMN id SET DEFAULT nextval('public.user_messages_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: workflow_descriptions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.workflow_descriptions ALTER COLUMN id SET DEFAULT nextval('public.workflow_descriptions_id_seq'::regclass);


--
-- Name: workflows id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.workflows ALTER COLUMN id SET DEFAULT nextval('public.workflows_id_seq'::regclass);


--
-- Name: aggregator_capabilities aggregator_capabilities_pkey; Type: CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.aggregator_capabilities
    ADD CONSTRAINT aggregator_capabilities_pkey PRIMARY KEY (id);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: audits audits_pkey; Type: CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.audits
    ADD CONSTRAINT audits_pkey PRIMARY KEY (id);


--
-- Name: authors authors_pkey; Type: CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.authors
    ADD CONSTRAINT authors_pkey PRIMARY KEY (id);


--
-- Name: building_block_descriptions building_block_descriptions_pkey; Type: CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.building_block_descriptions
    ADD CONSTRAINT building_block_descriptions_pkey PRIMARY KEY (id);


--
-- Name: building_blocks building_blocks_pkey; Type: CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.building_blocks
    ADD CONSTRAINT building_blocks_pkey PRIMARY KEY (id);


--
-- Name: candidate_datasets candidate_datasets_pkey; Type: CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.candidate_datasets
    ADD CONSTRAINT candidate_datasets_pkey PRIMARY KEY (id);


--
-- Name: candidate_organizations candidate_organizations_pkey; Type: CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.candidate_organizations
    ADD CONSTRAINT candidate_organizations_pkey PRIMARY KEY (id);


--
-- Name: candidate_products candidate_products_pkey; Type: CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.candidate_products
    ADD CONSTRAINT candidate_products_pkey PRIMARY KEY (id);


--
-- Name: candidate_resources_countries candidate_resources_countries_pkey; Type: CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.candidate_resources_countries
    ADD CONSTRAINT candidate_resources_countries_pkey PRIMARY KEY (id);


--
-- Name: candidate_resources candidate_resources_pkey; Type: CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.candidate_resources
    ADD CONSTRAINT candidate_resources_pkey PRIMARY KEY (id);


--
-- Name: candidate_roles candidate_roles_pkey; Type: CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.candidate_roles
    ADD CONSTRAINT candidate_roles_pkey PRIMARY KEY (id);


--
-- Name: category_indicator_descriptions category_indicator_descriptions_pkey; Type: CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.category_indicator_descriptions
    ADD CONSTRAINT category_indicator_descriptions_pkey PRIMARY KEY (id);


--
-- Name: category_indicators category_indicators_pkey; Type: CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.category_indicators
    ADD CONSTRAINT category_indicators_pkey PRIMARY KEY (id);


--
-- Name: chatbot_conversations chatbot_conversations_pkey; Type: CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.chatbot_conversations
    ADD CONSTRAINT chatbot_conversations_pkey PRIMARY KEY (id);


--
-- Name: cities cities_pkey; Type: CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.cities
    ADD CONSTRAINT cities_pkey PRIMARY KEY (id);


--
-- Name: ckeditor_assets ckeditor_assets_pkey; Type: CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.ckeditor_assets
    ADD CONSTRAINT ckeditor_assets_pkey PRIMARY KEY (id);


--
-- Name: classifications classifications_pkey; Type: CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.classifications
    ADD CONSTRAINT classifications_pkey PRIMARY KEY (id);


--
-- Name: comments comments_pkey; Type: CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.comments
    ADD CONSTRAINT comments_pkey PRIMARY KEY (id);


--
-- Name: contacts contacts_pkey; Type: CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.contacts
    ADD CONSTRAINT contacts_pkey PRIMARY KEY (id);


--
-- Name: countries countries_pkey; Type: CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.countries
    ADD CONSTRAINT countries_pkey PRIMARY KEY (id);


--
-- Name: dataset_descriptions dataset_descriptions_pkey; Type: CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.dataset_descriptions
    ADD CONSTRAINT dataset_descriptions_pkey PRIMARY KEY (id);


--
-- Name: dataset_sectors dataset_sectors_pkey; Type: CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.dataset_sectors
    ADD CONSTRAINT dataset_sectors_pkey PRIMARY KEY (id);


--
-- Name: dataset_sustainable_development_goals dataset_sustainable_development_goals_pkey; Type: CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.dataset_sustainable_development_goals
    ADD CONSTRAINT dataset_sustainable_development_goals_pkey PRIMARY KEY (id);


--
-- Name: datasets_countries datasets_countries_pkey; Type: CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.datasets_countries
    ADD CONSTRAINT datasets_countries_pkey PRIMARY KEY (id);


--
-- Name: datasets_origins datasets_origins_pkey; Type: CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.datasets_origins
    ADD CONSTRAINT datasets_origins_pkey PRIMARY KEY (id);


--
-- Name: datasets datasets_pkey; Type: CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.datasets
    ADD CONSTRAINT datasets_pkey PRIMARY KEY (id);


--
-- Name: deploys deploys_pkey; Type: CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.deploys
    ADD CONSTRAINT deploys_pkey PRIMARY KEY (id);


--
-- Name: dial_spreadsheet_data dial_spreadsheet_data_pkey; Type: CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.dial_spreadsheet_data
    ADD CONSTRAINT dial_spreadsheet_data_pkey PRIMARY KEY (id);


--
-- Name: digital_principles digital_principles_pkey; Type: CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.digital_principles
    ADD CONSTRAINT digital_principles_pkey PRIMARY KEY (id);


--
-- Name: districts districts_pkey; Type: CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.districts
    ADD CONSTRAINT districts_pkey PRIMARY KEY (id);


--
-- Name: endorsers endorsers_pkey; Type: CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.endorsers
    ADD CONSTRAINT endorsers_pkey PRIMARY KEY (id);


--
-- Name: exchange_tenants exchange_tenants_pkey; Type: CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.exchange_tenants
    ADD CONSTRAINT exchange_tenants_pkey PRIMARY KEY (id);


--
-- Name: froala_images froala_images_pkey; Type: CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.froala_images
    ADD CONSTRAINT froala_images_pkey PRIMARY KEY (id);


--
-- Name: glossaries glossaries_pkey; Type: CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.glossaries
    ADD CONSTRAINT glossaries_pkey PRIMARY KEY (id);


--
-- Name: handbook_answers handbook_answers_pkey; Type: CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.handbook_answers
    ADD CONSTRAINT handbook_answers_pkey PRIMARY KEY (id);


--
-- Name: handbook_descriptions handbook_descriptions_pkey; Type: CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.handbook_descriptions
    ADD CONSTRAINT handbook_descriptions_pkey PRIMARY KEY (id);


--
-- Name: handbook_pages handbook_pages_pkey; Type: CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.handbook_pages
    ADD CONSTRAINT handbook_pages_pkey PRIMARY KEY (id);


--
-- Name: handbook_questions handbook_questions_pkey; Type: CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.handbook_questions
    ADD CONSTRAINT handbook_questions_pkey PRIMARY KEY (id);


--
-- Name: handbooks handbooks_pkey; Type: CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.handbooks
    ADD CONSTRAINT handbooks_pkey PRIMARY KEY (id);


--
-- Name: messages messages_pkey; Type: CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.messages
    ADD CONSTRAINT messages_pkey PRIMARY KEY (id);


--
-- Name: offices offices_pkey; Type: CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.offices
    ADD CONSTRAINT offices_pkey PRIMARY KEY (id);


--
-- Name: operator_services operator_services_pkey; Type: CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.operator_services
    ADD CONSTRAINT operator_services_pkey PRIMARY KEY (id);


--
-- Name: opportunities opportunities_pkey; Type: CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.opportunities
    ADD CONSTRAINT opportunities_pkey PRIMARY KEY (id);


--
-- Name: organization_contacts organization_contacts_pkey; Type: CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.organization_contacts
    ADD CONSTRAINT organization_contacts_pkey PRIMARY KEY (id);


--
-- Name: organization_datasets organization_datasets_pkey; Type: CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.organization_datasets
    ADD CONSTRAINT organization_datasets_pkey PRIMARY KEY (id);


--
-- Name: organization_descriptions organization_descriptions_pkey; Type: CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.organization_descriptions
    ADD CONSTRAINT organization_descriptions_pkey PRIMARY KEY (id);


--
-- Name: organization_products organization_products_pkey; Type: CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.organization_products
    ADD CONSTRAINT organization_products_pkey PRIMARY KEY (id);


--
-- Name: organizations_countries organizations_countries_pkey; Type: CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.organizations_countries
    ADD CONSTRAINT organizations_countries_pkey PRIMARY KEY (id);


--
-- Name: organizations organizations_pkey; Type: CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.organizations
    ADD CONSTRAINT organizations_pkey PRIMARY KEY (id);


--
-- Name: organizations_resources organizations_resources_pkey; Type: CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.organizations_resources
    ADD CONSTRAINT organizations_resources_pkey PRIMARY KEY (id);


--
-- Name: origins origins_pkey; Type: CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.origins
    ADD CONSTRAINT origins_pkey PRIMARY KEY (id);


--
-- Name: page_contents page_contents_pkey; Type: CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.page_contents
    ADD CONSTRAINT page_contents_pkey PRIMARY KEY (id);


--
-- Name: play_descriptions play_descriptions_pkey; Type: CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.play_descriptions
    ADD CONSTRAINT play_descriptions_pkey PRIMARY KEY (id);


--
-- Name: play_move_descriptions play_move_descriptions_pkey; Type: CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.play_move_descriptions
    ADD CONSTRAINT play_move_descriptions_pkey PRIMARY KEY (id);


--
-- Name: play_moves play_moves_pkey; Type: CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.play_moves
    ADD CONSTRAINT play_moves_pkey PRIMARY KEY (id);


--
-- Name: play_moves_resources play_moves_resources_pkey; Type: CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.play_moves_resources
    ADD CONSTRAINT play_moves_resources_pkey PRIMARY KEY (id);


--
-- Name: playbook_descriptions playbook_descriptions_pkey; Type: CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.playbook_descriptions
    ADD CONSTRAINT playbook_descriptions_pkey PRIMARY KEY (id);


--
-- Name: playbook_plays playbook_plays_pkey; Type: CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.playbook_plays
    ADD CONSTRAINT playbook_plays_pkey PRIMARY KEY (id);


--
-- Name: playbooks playbooks_pkey; Type: CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.playbooks
    ADD CONSTRAINT playbooks_pkey PRIMARY KEY (id);


--
-- Name: plays_building_blocks plays_building_blocks_pkey; Type: CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.plays_building_blocks
    ADD CONSTRAINT plays_building_blocks_pkey PRIMARY KEY (id);


--
-- Name: plays plays_pkey; Type: CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.plays
    ADD CONSTRAINT plays_pkey PRIMARY KEY (id);


--
-- Name: plays_products plays_products_pkey; Type: CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.plays_products
    ADD CONSTRAINT plays_products_pkey PRIMARY KEY (id);


--
-- Name: plays_subplays plays_subplays_pkey; Type: CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.plays_subplays
    ADD CONSTRAINT plays_subplays_pkey PRIMARY KEY (id);


--
-- Name: portal_views portal_views_pkey; Type: CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.portal_views
    ADD CONSTRAINT portal_views_pkey PRIMARY KEY (id);


--
-- Name: principle_descriptions principle_descriptions_pkey; Type: CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.principle_descriptions
    ADD CONSTRAINT principle_descriptions_pkey PRIMARY KEY (id);


--
-- Name: product_building_blocks product_building_blocks_pkey; Type: CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.product_building_blocks
    ADD CONSTRAINT product_building_blocks_pkey PRIMARY KEY (id);


--
-- Name: product_classifications product_classifications_pkey; Type: CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.product_classifications
    ADD CONSTRAINT product_classifications_pkey PRIMARY KEY (id);


--
-- Name: product_descriptions product_descriptions_pkey; Type: CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.product_descriptions
    ADD CONSTRAINT product_descriptions_pkey PRIMARY KEY (id);


--
-- Name: product_indicators product_indicators_pkey; Type: CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.product_indicators
    ADD CONSTRAINT product_indicators_pkey PRIMARY KEY (id);


--
-- Name: product_product_relationships product_product_relationships_pkey; Type: CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.product_product_relationships
    ADD CONSTRAINT product_product_relationships_pkey PRIMARY KEY (id);


--
-- Name: product_repositories product_repositories_pkey; Type: CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.product_repositories
    ADD CONSTRAINT product_repositories_pkey PRIMARY KEY (id);


--
-- Name: product_sectors product_sectors_pkey; Type: CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.product_sectors
    ADD CONSTRAINT product_sectors_pkey PRIMARY KEY (id);


--
-- Name: product_sustainable_development_goals product_sustainable_development_goals_pkey; Type: CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.product_sustainable_development_goals
    ADD CONSTRAINT product_sustainable_development_goals_pkey PRIMARY KEY (id);


--
-- Name: products_countries products_countries_pkey; Type: CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.products_countries
    ADD CONSTRAINT products_countries_pkey PRIMARY KEY (id);


--
-- Name: products_endorsers products_endorsers_pkey; Type: CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.products_endorsers
    ADD CONSTRAINT products_endorsers_pkey PRIMARY KEY (id);


--
-- Name: products products_pkey; Type: CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (id);


--
-- Name: project_descriptions project_descriptions_pkey; Type: CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.project_descriptions
    ADD CONSTRAINT project_descriptions_pkey PRIMARY KEY (id);


--
-- Name: projects_countries projects_countries_pkey; Type: CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.projects_countries
    ADD CONSTRAINT projects_countries_pkey PRIMARY KEY (id);


--
-- Name: projects_digital_principles projects_digital_principles_pkey; Type: CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.projects_digital_principles
    ADD CONSTRAINT projects_digital_principles_pkey PRIMARY KEY (id);


--
-- Name: projects projects_pkey; Type: CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.projects
    ADD CONSTRAINT projects_pkey PRIMARY KEY (id);


--
-- Name: provinces provinces_pkey; Type: CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.provinces
    ADD CONSTRAINT provinces_pkey PRIMARY KEY (id);


--
-- Name: regions regions_pkey; Type: CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.regions
    ADD CONSTRAINT regions_pkey PRIMARY KEY (id);


--
-- Name: resource_building_blocks resource_building_blocks_pkey; Type: CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.resource_building_blocks
    ADD CONSTRAINT resource_building_blocks_pkey PRIMARY KEY (id);


--
-- Name: resource_topic_descriptions resource_topic_descriptions_pkey; Type: CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.resource_topic_descriptions
    ADD CONSTRAINT resource_topic_descriptions_pkey PRIMARY KEY (id);


--
-- Name: resource_topics resource_topics_pkey; Type: CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.resource_topics
    ADD CONSTRAINT resource_topics_pkey PRIMARY KEY (id);


--
-- Name: resource_types resource_types_pkey; Type: CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.resource_types
    ADD CONSTRAINT resource_types_pkey PRIMARY KEY (id);


--
-- Name: resources resources_pkey; Type: CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.resources
    ADD CONSTRAINT resources_pkey PRIMARY KEY (id);


--
-- Name: resources_use_cases resources_use_cases_pkey; Type: CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.resources_use_cases
    ADD CONSTRAINT resources_use_cases_pkey PRIMARY KEY (id);


--
-- Name: rubric_categories rubric_categories_pkey; Type: CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.rubric_categories
    ADD CONSTRAINT rubric_categories_pkey PRIMARY KEY (id);


--
-- Name: rubric_category_descriptions rubric_category_descriptions_pkey; Type: CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.rubric_category_descriptions
    ADD CONSTRAINT rubric_category_descriptions_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: sdg_targets sdg_targets_pkey; Type: CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.sdg_targets
    ADD CONSTRAINT sdg_targets_pkey PRIMARY KEY (id);


--
-- Name: sectors sectors_pkey; Type: CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.sectors
    ADD CONSTRAINT sectors_pkey PRIMARY KEY (id);


--
-- Name: sessions sessions_pkey; Type: CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


--
-- Name: settings settings_pkey; Type: CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.settings
    ADD CONSTRAINT settings_pkey PRIMARY KEY (id);


--
-- Name: software_categories software_categories_pkey; Type: CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.software_categories
    ADD CONSTRAINT software_categories_pkey PRIMARY KEY (id);


--
-- Name: software_features software_features_pkey; Type: CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.software_features
    ADD CONSTRAINT software_features_pkey PRIMARY KEY (id);


--
-- Name: starred_objects starred_objects_pkey; Type: CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.starred_objects
    ADD CONSTRAINT starred_objects_pkey PRIMARY KEY (id);


--
-- Name: stylesheets stylesheets_pkey; Type: CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.stylesheets
    ADD CONSTRAINT stylesheets_pkey PRIMARY KEY (id);


--
-- Name: sustainable_development_goals sustainable_development_goals_pkey; Type: CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.sustainable_development_goals
    ADD CONSTRAINT sustainable_development_goals_pkey PRIMARY KEY (id);


--
-- Name: tag_descriptions tag_descriptions_pkey; Type: CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.tag_descriptions
    ADD CONSTRAINT tag_descriptions_pkey PRIMARY KEY (id);


--
-- Name: tags tags_pkey; Type: CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.tags
    ADD CONSTRAINT tags_pkey PRIMARY KEY (id);


--
-- Name: task_tracker_descriptions task_tracker_descriptions_pkey; Type: CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.task_tracker_descriptions
    ADD CONSTRAINT task_tracker_descriptions_pkey PRIMARY KEY (id);


--
-- Name: task_trackers task_trackers_pkey; Type: CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.task_trackers
    ADD CONSTRAINT task_trackers_pkey PRIMARY KEY (id);


--
-- Name: tenant_sync_configurations tenant_sync_configurations_pkey; Type: CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.tenant_sync_configurations
    ADD CONSTRAINT tenant_sync_configurations_pkey PRIMARY KEY (id);


--
-- Name: use_case_descriptions use_case_descriptions_pkey; Type: CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.use_case_descriptions
    ADD CONSTRAINT use_case_descriptions_pkey PRIMARY KEY (id);


--
-- Name: use_case_headers use_case_headers_pkey; Type: CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.use_case_headers
    ADD CONSTRAINT use_case_headers_pkey PRIMARY KEY (id);


--
-- Name: use_case_step_descriptions use_case_step_descriptions_pkey; Type: CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.use_case_step_descriptions
    ADD CONSTRAINT use_case_step_descriptions_pkey PRIMARY KEY (id);


--
-- Name: use_case_steps_building_blocks use_case_steps_building_blocks_pkey; Type: CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.use_case_steps_building_blocks
    ADD CONSTRAINT use_case_steps_building_blocks_pkey PRIMARY KEY (id);


--
-- Name: use_case_steps_datasets use_case_steps_datasets_pkey; Type: CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.use_case_steps_datasets
    ADD CONSTRAINT use_case_steps_datasets_pkey PRIMARY KEY (id);


--
-- Name: use_case_steps use_case_steps_pkey; Type: CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.use_case_steps
    ADD CONSTRAINT use_case_steps_pkey PRIMARY KEY (id);


--
-- Name: use_case_steps_products use_case_steps_products_pkey; Type: CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.use_case_steps_products
    ADD CONSTRAINT use_case_steps_products_pkey PRIMARY KEY (id);


--
-- Name: use_cases use_cases_pkey; Type: CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.use_cases
    ADD CONSTRAINT use_cases_pkey PRIMARY KEY (id);


--
-- Name: user_events user_events_pkey; Type: CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.user_events
    ADD CONSTRAINT user_events_pkey PRIMARY KEY (id);


--
-- Name: user_messages user_messages_pkey; Type: CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.user_messages
    ADD CONSTRAINT user_messages_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: workflow_descriptions workflow_descriptions_pkey; Type: CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.workflow_descriptions
    ADD CONSTRAINT workflow_descriptions_pkey PRIMARY KEY (id);


--
-- Name: workflows workflows_pkey; Type: CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.workflows
    ADD CONSTRAINT workflows_pkey PRIMARY KEY (id);


--
-- Name: aggregator_capabilities aggregator_capabilities_pkey; Type: CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.aggregator_capabilities
    ADD CONSTRAINT aggregator_capabilities_pkey PRIMARY KEY (id);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: audits audits_pkey; Type: CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.audits
    ADD CONSTRAINT audits_pkey PRIMARY KEY (id);


--
-- Name: authors authors_pkey; Type: CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.authors
    ADD CONSTRAINT authors_pkey PRIMARY KEY (id);


--
-- Name: building_block_descriptions building_block_descriptions_pkey; Type: CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.building_block_descriptions
    ADD CONSTRAINT building_block_descriptions_pkey PRIMARY KEY (id);


--
-- Name: building_blocks building_blocks_pkey; Type: CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.building_blocks
    ADD CONSTRAINT building_blocks_pkey PRIMARY KEY (id);


--
-- Name: candidate_datasets candidate_datasets_pkey; Type: CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.candidate_datasets
    ADD CONSTRAINT candidate_datasets_pkey PRIMARY KEY (id);


--
-- Name: candidate_organizations candidate_organizations_pkey; Type: CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.candidate_organizations
    ADD CONSTRAINT candidate_organizations_pkey PRIMARY KEY (id);


--
-- Name: candidate_products candidate_products_pkey; Type: CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.candidate_products
    ADD CONSTRAINT candidate_products_pkey PRIMARY KEY (id);


--
-- Name: candidate_resources_countries candidate_resources_countries_pkey; Type: CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.candidate_resources_countries
    ADD CONSTRAINT candidate_resources_countries_pkey PRIMARY KEY (id);


--
-- Name: candidate_resources candidate_resources_pkey; Type: CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.candidate_resources
    ADD CONSTRAINT candidate_resources_pkey PRIMARY KEY (id);


--
-- Name: candidate_roles candidate_roles_pkey; Type: CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.candidate_roles
    ADD CONSTRAINT candidate_roles_pkey PRIMARY KEY (id);


--
-- Name: category_indicator_descriptions category_indicator_descriptions_pkey; Type: CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.category_indicator_descriptions
    ADD CONSTRAINT category_indicator_descriptions_pkey PRIMARY KEY (id);


--
-- Name: category_indicators category_indicators_pkey; Type: CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.category_indicators
    ADD CONSTRAINT category_indicators_pkey PRIMARY KEY (id);


--
-- Name: chatbot_conversations chatbot_conversations_pkey; Type: CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.chatbot_conversations
    ADD CONSTRAINT chatbot_conversations_pkey PRIMARY KEY (id);


--
-- Name: cities cities_pkey; Type: CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.cities
    ADD CONSTRAINT cities_pkey PRIMARY KEY (id);


--
-- Name: ckeditor_assets ckeditor_assets_pkey; Type: CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.ckeditor_assets
    ADD CONSTRAINT ckeditor_assets_pkey PRIMARY KEY (id);


--
-- Name: classifications classifications_pkey; Type: CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.classifications
    ADD CONSTRAINT classifications_pkey PRIMARY KEY (id);


--
-- Name: comments comments_pkey; Type: CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.comments
    ADD CONSTRAINT comments_pkey PRIMARY KEY (id);


--
-- Name: contacts contacts_pkey; Type: CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.contacts
    ADD CONSTRAINT contacts_pkey PRIMARY KEY (id);


--
-- Name: countries countries_pkey; Type: CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.countries
    ADD CONSTRAINT countries_pkey PRIMARY KEY (id);


--
-- Name: dataset_descriptions dataset_descriptions_pkey; Type: CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.dataset_descriptions
    ADD CONSTRAINT dataset_descriptions_pkey PRIMARY KEY (id);


--
-- Name: dataset_sectors dataset_sectors_pkey; Type: CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.dataset_sectors
    ADD CONSTRAINT dataset_sectors_pkey PRIMARY KEY (id);


--
-- Name: dataset_sustainable_development_goals dataset_sustainable_development_goals_pkey; Type: CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.dataset_sustainable_development_goals
    ADD CONSTRAINT dataset_sustainable_development_goals_pkey PRIMARY KEY (id);


--
-- Name: datasets_countries datasets_countries_pkey; Type: CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.datasets_countries
    ADD CONSTRAINT datasets_countries_pkey PRIMARY KEY (id);


--
-- Name: datasets_origins datasets_origins_pkey; Type: CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.datasets_origins
    ADD CONSTRAINT datasets_origins_pkey PRIMARY KEY (id);


--
-- Name: datasets datasets_pkey; Type: CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.datasets
    ADD CONSTRAINT datasets_pkey PRIMARY KEY (id);


--
-- Name: deploys deploys_pkey; Type: CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.deploys
    ADD CONSTRAINT deploys_pkey PRIMARY KEY (id);


--
-- Name: dial_spreadsheet_data dial_spreadsheet_data_pkey; Type: CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.dial_spreadsheet_data
    ADD CONSTRAINT dial_spreadsheet_data_pkey PRIMARY KEY (id);


--
-- Name: digital_principles digital_principles_pkey; Type: CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.digital_principles
    ADD CONSTRAINT digital_principles_pkey PRIMARY KEY (id);


--
-- Name: districts districts_pkey; Type: CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.districts
    ADD CONSTRAINT districts_pkey PRIMARY KEY (id);


--
-- Name: endorsers endorsers_pkey; Type: CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.endorsers
    ADD CONSTRAINT endorsers_pkey PRIMARY KEY (id);


--
-- Name: exchange_tenants exchange_tenants_pkey; Type: CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.exchange_tenants
    ADD CONSTRAINT exchange_tenants_pkey PRIMARY KEY (id);


--
-- Name: froala_images froala_images_pkey; Type: CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.froala_images
    ADD CONSTRAINT froala_images_pkey PRIMARY KEY (id);


--
-- Name: glossaries glossaries_pkey; Type: CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.glossaries
    ADD CONSTRAINT glossaries_pkey PRIMARY KEY (id);


--
-- Name: handbook_answers handbook_answers_pkey; Type: CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.handbook_answers
    ADD CONSTRAINT handbook_answers_pkey PRIMARY KEY (id);


--
-- Name: handbook_descriptions handbook_descriptions_pkey; Type: CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.handbook_descriptions
    ADD CONSTRAINT handbook_descriptions_pkey PRIMARY KEY (id);


--
-- Name: handbook_pages handbook_pages_pkey; Type: CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.handbook_pages
    ADD CONSTRAINT handbook_pages_pkey PRIMARY KEY (id);


--
-- Name: handbook_questions handbook_questions_pkey; Type: CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.handbook_questions
    ADD CONSTRAINT handbook_questions_pkey PRIMARY KEY (id);


--
-- Name: handbooks handbooks_pkey; Type: CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.handbooks
    ADD CONSTRAINT handbooks_pkey PRIMARY KEY (id);


--
-- Name: messages messages_pkey; Type: CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.messages
    ADD CONSTRAINT messages_pkey PRIMARY KEY (id);


--
-- Name: offices offices_pkey; Type: CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.offices
    ADD CONSTRAINT offices_pkey PRIMARY KEY (id);


--
-- Name: operator_services operator_services_pkey; Type: CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.operator_services
    ADD CONSTRAINT operator_services_pkey PRIMARY KEY (id);


--
-- Name: opportunities opportunities_pkey; Type: CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.opportunities
    ADD CONSTRAINT opportunities_pkey PRIMARY KEY (id);


--
-- Name: organization_contacts organization_contacts_pkey; Type: CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.organization_contacts
    ADD CONSTRAINT organization_contacts_pkey PRIMARY KEY (id);


--
-- Name: organization_datasets organization_datasets_pkey; Type: CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.organization_datasets
    ADD CONSTRAINT organization_datasets_pkey PRIMARY KEY (id);


--
-- Name: organization_descriptions organization_descriptions_pkey; Type: CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.organization_descriptions
    ADD CONSTRAINT organization_descriptions_pkey PRIMARY KEY (id);


--
-- Name: organization_products organization_products_pkey; Type: CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.organization_products
    ADD CONSTRAINT organization_products_pkey PRIMARY KEY (id);


--
-- Name: organizations_countries organizations_countries_pkey; Type: CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.organizations_countries
    ADD CONSTRAINT organizations_countries_pkey PRIMARY KEY (id);


--
-- Name: organizations organizations_pkey; Type: CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.organizations
    ADD CONSTRAINT organizations_pkey PRIMARY KEY (id);


--
-- Name: organizations_resources organizations_resources_pkey; Type: CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.organizations_resources
    ADD CONSTRAINT organizations_resources_pkey PRIMARY KEY (id);


--
-- Name: origins origins_pkey; Type: CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.origins
    ADD CONSTRAINT origins_pkey PRIMARY KEY (id);


--
-- Name: page_contents page_contents_pkey; Type: CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.page_contents
    ADD CONSTRAINT page_contents_pkey PRIMARY KEY (id);


--
-- Name: play_descriptions play_descriptions_pkey; Type: CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.play_descriptions
    ADD CONSTRAINT play_descriptions_pkey PRIMARY KEY (id);


--
-- Name: play_move_descriptions play_move_descriptions_pkey; Type: CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.play_move_descriptions
    ADD CONSTRAINT play_move_descriptions_pkey PRIMARY KEY (id);


--
-- Name: play_moves play_moves_pkey; Type: CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.play_moves
    ADD CONSTRAINT play_moves_pkey PRIMARY KEY (id);


--
-- Name: play_moves_resources play_moves_resources_pkey; Type: CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.play_moves_resources
    ADD CONSTRAINT play_moves_resources_pkey PRIMARY KEY (id);


--
-- Name: playbook_descriptions playbook_descriptions_pkey; Type: CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.playbook_descriptions
    ADD CONSTRAINT playbook_descriptions_pkey PRIMARY KEY (id);


--
-- Name: playbook_plays playbook_plays_pkey; Type: CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.playbook_plays
    ADD CONSTRAINT playbook_plays_pkey PRIMARY KEY (id);


--
-- Name: playbooks playbooks_pkey; Type: CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.playbooks
    ADD CONSTRAINT playbooks_pkey PRIMARY KEY (id);


--
-- Name: plays_building_blocks plays_building_blocks_pkey; Type: CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.plays_building_blocks
    ADD CONSTRAINT plays_building_blocks_pkey PRIMARY KEY (id);


--
-- Name: plays plays_pkey; Type: CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.plays
    ADD CONSTRAINT plays_pkey PRIMARY KEY (id);


--
-- Name: plays_products plays_products_pkey; Type: CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.plays_products
    ADD CONSTRAINT plays_products_pkey PRIMARY KEY (id);


--
-- Name: plays_subplays plays_subplays_pkey; Type: CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.plays_subplays
    ADD CONSTRAINT plays_subplays_pkey PRIMARY KEY (id);


--
-- Name: portal_views portal_views_pkey; Type: CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.portal_views
    ADD CONSTRAINT portal_views_pkey PRIMARY KEY (id);


--
-- Name: principle_descriptions principle_descriptions_pkey; Type: CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.principle_descriptions
    ADD CONSTRAINT principle_descriptions_pkey PRIMARY KEY (id);


--
-- Name: product_building_blocks product_building_blocks_pkey; Type: CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.product_building_blocks
    ADD CONSTRAINT product_building_blocks_pkey PRIMARY KEY (id);


--
-- Name: product_classifications product_classifications_pkey; Type: CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.product_classifications
    ADD CONSTRAINT product_classifications_pkey PRIMARY KEY (id);


--
-- Name: product_descriptions product_descriptions_pkey; Type: CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.product_descriptions
    ADD CONSTRAINT product_descriptions_pkey PRIMARY KEY (id);


--
-- Name: product_indicators product_indicators_pkey; Type: CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.product_indicators
    ADD CONSTRAINT product_indicators_pkey PRIMARY KEY (id);


--
-- Name: product_product_relationships product_product_relationships_pkey; Type: CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.product_product_relationships
    ADD CONSTRAINT product_product_relationships_pkey PRIMARY KEY (id);


--
-- Name: product_repositories product_repositories_pkey; Type: CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.product_repositories
    ADD CONSTRAINT product_repositories_pkey PRIMARY KEY (id);


--
-- Name: product_sectors product_sectors_pkey; Type: CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.product_sectors
    ADD CONSTRAINT product_sectors_pkey PRIMARY KEY (id);


--
-- Name: product_sustainable_development_goals product_sustainable_development_goals_pkey; Type: CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.product_sustainable_development_goals
    ADD CONSTRAINT product_sustainable_development_goals_pkey PRIMARY KEY (id);


--
-- Name: products_countries products_countries_pkey; Type: CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.products_countries
    ADD CONSTRAINT products_countries_pkey PRIMARY KEY (id);


--
-- Name: products_endorsers products_endorsers_pkey; Type: CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.products_endorsers
    ADD CONSTRAINT products_endorsers_pkey PRIMARY KEY (id);


--
-- Name: products products_pkey; Type: CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (id);


--
-- Name: project_descriptions project_descriptions_pkey; Type: CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.project_descriptions
    ADD CONSTRAINT project_descriptions_pkey PRIMARY KEY (id);


--
-- Name: projects_countries projects_countries_pkey; Type: CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.projects_countries
    ADD CONSTRAINT projects_countries_pkey PRIMARY KEY (id);


--
-- Name: projects_digital_principles projects_digital_principles_pkey; Type: CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.projects_digital_principles
    ADD CONSTRAINT projects_digital_principles_pkey PRIMARY KEY (id);


--
-- Name: projects projects_pkey; Type: CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.projects
    ADD CONSTRAINT projects_pkey PRIMARY KEY (id);


--
-- Name: provinces provinces_pkey; Type: CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.provinces
    ADD CONSTRAINT provinces_pkey PRIMARY KEY (id);


--
-- Name: regions regions_pkey; Type: CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.regions
    ADD CONSTRAINT regions_pkey PRIMARY KEY (id);


--
-- Name: resource_building_blocks resource_building_blocks_pkey; Type: CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.resource_building_blocks
    ADD CONSTRAINT resource_building_blocks_pkey PRIMARY KEY (id);


--
-- Name: resource_topic_descriptions resource_topic_descriptions_pkey; Type: CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.resource_topic_descriptions
    ADD CONSTRAINT resource_topic_descriptions_pkey PRIMARY KEY (id);


--
-- Name: resource_topics resource_topics_pkey; Type: CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.resource_topics
    ADD CONSTRAINT resource_topics_pkey PRIMARY KEY (id);


--
-- Name: resource_types resource_types_pkey; Type: CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.resource_types
    ADD CONSTRAINT resource_types_pkey PRIMARY KEY (id);


--
-- Name: resources resources_pkey; Type: CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.resources
    ADD CONSTRAINT resources_pkey PRIMARY KEY (id);


--
-- Name: resources_use_cases resources_use_cases_pkey; Type: CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.resources_use_cases
    ADD CONSTRAINT resources_use_cases_pkey PRIMARY KEY (id);


--
-- Name: rubric_categories rubric_categories_pkey; Type: CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.rubric_categories
    ADD CONSTRAINT rubric_categories_pkey PRIMARY KEY (id);


--
-- Name: rubric_category_descriptions rubric_category_descriptions_pkey; Type: CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.rubric_category_descriptions
    ADD CONSTRAINT rubric_category_descriptions_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: sdg_targets sdg_targets_pkey; Type: CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.sdg_targets
    ADD CONSTRAINT sdg_targets_pkey PRIMARY KEY (id);


--
-- Name: sectors sectors_pkey; Type: CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.sectors
    ADD CONSTRAINT sectors_pkey PRIMARY KEY (id);


--
-- Name: sessions sessions_pkey; Type: CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


--
-- Name: settings settings_pkey; Type: CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.settings
    ADD CONSTRAINT settings_pkey PRIMARY KEY (id);


--
-- Name: software_categories software_categories_pkey; Type: CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.software_categories
    ADD CONSTRAINT software_categories_pkey PRIMARY KEY (id);


--
-- Name: software_features software_features_pkey; Type: CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.software_features
    ADD CONSTRAINT software_features_pkey PRIMARY KEY (id);


--
-- Name: starred_objects starred_objects_pkey; Type: CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.starred_objects
    ADD CONSTRAINT starred_objects_pkey PRIMARY KEY (id);


--
-- Name: stylesheets stylesheets_pkey; Type: CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.stylesheets
    ADD CONSTRAINT stylesheets_pkey PRIMARY KEY (id);


--
-- Name: sustainable_development_goals sustainable_development_goals_pkey; Type: CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.sustainable_development_goals
    ADD CONSTRAINT sustainable_development_goals_pkey PRIMARY KEY (id);


--
-- Name: tag_descriptions tag_descriptions_pkey; Type: CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.tag_descriptions
    ADD CONSTRAINT tag_descriptions_pkey PRIMARY KEY (id);


--
-- Name: tags tags_pkey; Type: CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.tags
    ADD CONSTRAINT tags_pkey PRIMARY KEY (id);


--
-- Name: task_tracker_descriptions task_tracker_descriptions_pkey; Type: CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.task_tracker_descriptions
    ADD CONSTRAINT task_tracker_descriptions_pkey PRIMARY KEY (id);


--
-- Name: task_trackers task_trackers_pkey; Type: CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.task_trackers
    ADD CONSTRAINT task_trackers_pkey PRIMARY KEY (id);


--
-- Name: tenant_sync_configurations tenant_sync_configurations_pkey; Type: CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.tenant_sync_configurations
    ADD CONSTRAINT tenant_sync_configurations_pkey PRIMARY KEY (id);


--
-- Name: use_case_descriptions use_case_descriptions_pkey; Type: CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.use_case_descriptions
    ADD CONSTRAINT use_case_descriptions_pkey PRIMARY KEY (id);


--
-- Name: use_case_headers use_case_headers_pkey; Type: CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.use_case_headers
    ADD CONSTRAINT use_case_headers_pkey PRIMARY KEY (id);


--
-- Name: use_case_step_descriptions use_case_step_descriptions_pkey; Type: CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.use_case_step_descriptions
    ADD CONSTRAINT use_case_step_descriptions_pkey PRIMARY KEY (id);


--
-- Name: use_case_steps_building_blocks use_case_steps_building_blocks_pkey; Type: CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.use_case_steps_building_blocks
    ADD CONSTRAINT use_case_steps_building_blocks_pkey PRIMARY KEY (id);


--
-- Name: use_case_steps_datasets use_case_steps_datasets_pkey; Type: CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.use_case_steps_datasets
    ADD CONSTRAINT use_case_steps_datasets_pkey PRIMARY KEY (id);


--
-- Name: use_case_steps use_case_steps_pkey; Type: CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.use_case_steps
    ADD CONSTRAINT use_case_steps_pkey PRIMARY KEY (id);


--
-- Name: use_case_steps_products use_case_steps_products_pkey; Type: CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.use_case_steps_products
    ADD CONSTRAINT use_case_steps_products_pkey PRIMARY KEY (id);


--
-- Name: use_cases use_cases_pkey; Type: CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.use_cases
    ADD CONSTRAINT use_cases_pkey PRIMARY KEY (id);


--
-- Name: user_events user_events_pkey; Type: CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.user_events
    ADD CONSTRAINT user_events_pkey PRIMARY KEY (id);


--
-- Name: user_messages user_messages_pkey; Type: CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.user_messages
    ADD CONSTRAINT user_messages_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: workflow_descriptions workflow_descriptions_pkey; Type: CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.workflow_descriptions
    ADD CONSTRAINT workflow_descriptions_pkey PRIMARY KEY (id);


--
-- Name: workflows workflows_pkey; Type: CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.workflows
    ADD CONSTRAINT workflows_pkey PRIMARY KEY (id);


--
-- Name: aggregator_capabilities aggregator_capabilities_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.aggregator_capabilities
    ADD CONSTRAINT aggregator_capabilities_pkey PRIMARY KEY (id);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: audits audits_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.audits
    ADD CONSTRAINT audits_pkey PRIMARY KEY (id);


--
-- Name: authors authors_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.authors
    ADD CONSTRAINT authors_pkey PRIMARY KEY (id);


--
-- Name: building_block_descriptions building_block_descriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.building_block_descriptions
    ADD CONSTRAINT building_block_descriptions_pkey PRIMARY KEY (id);


--
-- Name: building_blocks building_blocks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.building_blocks
    ADD CONSTRAINT building_blocks_pkey PRIMARY KEY (id);


--
-- Name: candidate_datasets candidate_datasets_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.candidate_datasets
    ADD CONSTRAINT candidate_datasets_pkey PRIMARY KEY (id);


--
-- Name: candidate_organizations candidate_organizations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.candidate_organizations
    ADD CONSTRAINT candidate_organizations_pkey PRIMARY KEY (id);


--
-- Name: candidate_products candidate_products_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.candidate_products
    ADD CONSTRAINT candidate_products_pkey PRIMARY KEY (id);


--
-- Name: candidate_resources_countries candidate_resources_countries_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.candidate_resources_countries
    ADD CONSTRAINT candidate_resources_countries_pkey PRIMARY KEY (id);


--
-- Name: candidate_resources candidate_resources_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.candidate_resources
    ADD CONSTRAINT candidate_resources_pkey PRIMARY KEY (id);


--
-- Name: candidate_roles candidate_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.candidate_roles
    ADD CONSTRAINT candidate_roles_pkey PRIMARY KEY (id);


--
-- Name: category_indicator_descriptions category_indicator_descriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.category_indicator_descriptions
    ADD CONSTRAINT category_indicator_descriptions_pkey PRIMARY KEY (id);


--
-- Name: category_indicators category_indicators_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.category_indicators
    ADD CONSTRAINT category_indicators_pkey PRIMARY KEY (id);


--
-- Name: chatbot_conversations chatbot_conversations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chatbot_conversations
    ADD CONSTRAINT chatbot_conversations_pkey PRIMARY KEY (id);


--
-- Name: cities cities_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cities
    ADD CONSTRAINT cities_pkey PRIMARY KEY (id);


--
-- Name: ckeditor_assets ckeditor_assets_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ckeditor_assets
    ADD CONSTRAINT ckeditor_assets_pkey PRIMARY KEY (id);


--
-- Name: classifications classifications_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.classifications
    ADD CONSTRAINT classifications_pkey PRIMARY KEY (id);


--
-- Name: comments comments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT comments_pkey PRIMARY KEY (id);


--
-- Name: contacts contacts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.contacts
    ADD CONSTRAINT contacts_pkey PRIMARY KEY (id);


--
-- Name: countries countries_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.countries
    ADD CONSTRAINT countries_pkey PRIMARY KEY (id);


--
-- Name: dataset_descriptions dataset_descriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dataset_descriptions
    ADD CONSTRAINT dataset_descriptions_pkey PRIMARY KEY (id);


--
-- Name: dataset_sectors dataset_sectors_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dataset_sectors
    ADD CONSTRAINT dataset_sectors_pkey PRIMARY KEY (id);


--
-- Name: dataset_sustainable_development_goals dataset_sustainable_development_goals_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dataset_sustainable_development_goals
    ADD CONSTRAINT dataset_sustainable_development_goals_pkey PRIMARY KEY (id);


--
-- Name: datasets_countries datasets_countries_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.datasets_countries
    ADD CONSTRAINT datasets_countries_pkey PRIMARY KEY (id);


--
-- Name: datasets_origins datasets_origins_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.datasets_origins
    ADD CONSTRAINT datasets_origins_pkey PRIMARY KEY (id);


--
-- Name: datasets datasets_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.datasets
    ADD CONSTRAINT datasets_pkey PRIMARY KEY (id);


--
-- Name: deploys deploys_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.deploys
    ADD CONSTRAINT deploys_pkey PRIMARY KEY (id);


--
-- Name: dial_spreadsheet_data dial_spreadsheet_data_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dial_spreadsheet_data
    ADD CONSTRAINT dial_spreadsheet_data_pkey PRIMARY KEY (id);


--
-- Name: digital_principles digital_principles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.digital_principles
    ADD CONSTRAINT digital_principles_pkey PRIMARY KEY (id);


--
-- Name: districts districts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.districts
    ADD CONSTRAINT districts_pkey PRIMARY KEY (id);


--
-- Name: endorsers endorsers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.endorsers
    ADD CONSTRAINT endorsers_pkey PRIMARY KEY (id);


--
-- Name: exchange_tenants exchange_tenants_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.exchange_tenants
    ADD CONSTRAINT exchange_tenants_pkey PRIMARY KEY (id);


--
-- Name: froala_images froala_images_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.froala_images
    ADD CONSTRAINT froala_images_pkey PRIMARY KEY (id);


--
-- Name: glossaries glossaries_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.glossaries
    ADD CONSTRAINT glossaries_pkey PRIMARY KEY (id);


--
-- Name: handbook_answers handbook_answers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.handbook_answers
    ADD CONSTRAINT handbook_answers_pkey PRIMARY KEY (id);


--
-- Name: handbook_descriptions handbook_descriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.handbook_descriptions
    ADD CONSTRAINT handbook_descriptions_pkey PRIMARY KEY (id);


--
-- Name: handbook_pages handbook_pages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.handbook_pages
    ADD CONSTRAINT handbook_pages_pkey PRIMARY KEY (id);


--
-- Name: handbook_questions handbook_questions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.handbook_questions
    ADD CONSTRAINT handbook_questions_pkey PRIMARY KEY (id);


--
-- Name: handbooks handbooks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.handbooks
    ADD CONSTRAINT handbooks_pkey PRIMARY KEY (id);


--
-- Name: messages messages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT messages_pkey PRIMARY KEY (id);


--
-- Name: offices offices_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.offices
    ADD CONSTRAINT offices_pkey PRIMARY KEY (id);


--
-- Name: operator_services operator_services_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.operator_services
    ADD CONSTRAINT operator_services_pkey PRIMARY KEY (id);


--
-- Name: opportunities opportunities_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.opportunities
    ADD CONSTRAINT opportunities_pkey PRIMARY KEY (id);


--
-- Name: organization_contacts organization_contacts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organization_contacts
    ADD CONSTRAINT organization_contacts_pkey PRIMARY KEY (id);


--
-- Name: organization_datasets organization_datasets_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organization_datasets
    ADD CONSTRAINT organization_datasets_pkey PRIMARY KEY (id);


--
-- Name: organization_descriptions organization_descriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organization_descriptions
    ADD CONSTRAINT organization_descriptions_pkey PRIMARY KEY (id);


--
-- Name: organization_products organization_products_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organization_products
    ADD CONSTRAINT organization_products_pkey PRIMARY KEY (id);


--
-- Name: organizations_countries organizations_countries_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organizations_countries
    ADD CONSTRAINT organizations_countries_pkey PRIMARY KEY (id);


--
-- Name: organizations organizations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organizations
    ADD CONSTRAINT organizations_pkey PRIMARY KEY (id);


--
-- Name: organizations_resources organizations_resources_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organizations_resources
    ADD CONSTRAINT organizations_resources_pkey PRIMARY KEY (id);


--
-- Name: origins origins_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.origins
    ADD CONSTRAINT origins_pkey PRIMARY KEY (id);


--
-- Name: page_contents page_contents_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.page_contents
    ADD CONSTRAINT page_contents_pkey PRIMARY KEY (id);


--
-- Name: play_descriptions play_descriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.play_descriptions
    ADD CONSTRAINT play_descriptions_pkey PRIMARY KEY (id);


--
-- Name: play_move_descriptions play_move_descriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.play_move_descriptions
    ADD CONSTRAINT play_move_descriptions_pkey PRIMARY KEY (id);


--
-- Name: play_moves play_moves_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.play_moves
    ADD CONSTRAINT play_moves_pkey PRIMARY KEY (id);


--
-- Name: play_moves_resources play_moves_resources_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.play_moves_resources
    ADD CONSTRAINT play_moves_resources_pkey PRIMARY KEY (id);


--
-- Name: playbook_descriptions playbook_descriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.playbook_descriptions
    ADD CONSTRAINT playbook_descriptions_pkey PRIMARY KEY (id);


--
-- Name: playbook_plays playbook_plays_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.playbook_plays
    ADD CONSTRAINT playbook_plays_pkey PRIMARY KEY (id);


--
-- Name: playbooks playbooks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.playbooks
    ADD CONSTRAINT playbooks_pkey PRIMARY KEY (id);


--
-- Name: plays_building_blocks plays_building_blocks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.plays_building_blocks
    ADD CONSTRAINT plays_building_blocks_pkey PRIMARY KEY (id);


--
-- Name: plays plays_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.plays
    ADD CONSTRAINT plays_pkey PRIMARY KEY (id);


--
-- Name: plays_products plays_products_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.plays_products
    ADD CONSTRAINT plays_products_pkey PRIMARY KEY (id);


--
-- Name: plays_subplays plays_subplays_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.plays_subplays
    ADD CONSTRAINT plays_subplays_pkey PRIMARY KEY (id);


--
-- Name: portal_views portal_views_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.portal_views
    ADD CONSTRAINT portal_views_pkey PRIMARY KEY (id);


--
-- Name: principle_descriptions principle_descriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.principle_descriptions
    ADD CONSTRAINT principle_descriptions_pkey PRIMARY KEY (id);


--
-- Name: product_building_blocks product_building_blocks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_building_blocks
    ADD CONSTRAINT product_building_blocks_pkey PRIMARY KEY (id);


--
-- Name: product_classifications product_classifications_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_classifications
    ADD CONSTRAINT product_classifications_pkey PRIMARY KEY (id);


--
-- Name: product_descriptions product_descriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_descriptions
    ADD CONSTRAINT product_descriptions_pkey PRIMARY KEY (id);


--
-- Name: product_indicators product_indicators_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_indicators
    ADD CONSTRAINT product_indicators_pkey PRIMARY KEY (id);


--
-- Name: product_product_relationships product_product_relationships_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_product_relationships
    ADD CONSTRAINT product_product_relationships_pkey PRIMARY KEY (id);


--
-- Name: product_repositories product_repositories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_repositories
    ADD CONSTRAINT product_repositories_pkey PRIMARY KEY (id);


--
-- Name: product_sectors product_sectors_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_sectors
    ADD CONSTRAINT product_sectors_pkey PRIMARY KEY (id);


--
-- Name: product_sustainable_development_goals product_sustainable_development_goals_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_sustainable_development_goals
    ADD CONSTRAINT product_sustainable_development_goals_pkey PRIMARY KEY (id);


--
-- Name: products_countries products_countries_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.products_countries
    ADD CONSTRAINT products_countries_pkey PRIMARY KEY (id);


--
-- Name: products_endorsers products_endorsers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.products_endorsers
    ADD CONSTRAINT products_endorsers_pkey PRIMARY KEY (id);


--
-- Name: products products_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (id);


--
-- Name: project_descriptions project_descriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.project_descriptions
    ADD CONSTRAINT project_descriptions_pkey PRIMARY KEY (id);


--
-- Name: projects_countries projects_countries_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.projects_countries
    ADD CONSTRAINT projects_countries_pkey PRIMARY KEY (id);


--
-- Name: projects_digital_principles projects_digital_principles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.projects_digital_principles
    ADD CONSTRAINT projects_digital_principles_pkey PRIMARY KEY (id);


--
-- Name: projects projects_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.projects
    ADD CONSTRAINT projects_pkey PRIMARY KEY (id);


--
-- Name: provinces provinces_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.provinces
    ADD CONSTRAINT provinces_pkey PRIMARY KEY (id);


--
-- Name: regions regions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.regions
    ADD CONSTRAINT regions_pkey PRIMARY KEY (id);


--
-- Name: resource_building_blocks resource_building_blocks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.resource_building_blocks
    ADD CONSTRAINT resource_building_blocks_pkey PRIMARY KEY (id);


--
-- Name: resource_topic_descriptions resource_topic_descriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.resource_topic_descriptions
    ADD CONSTRAINT resource_topic_descriptions_pkey PRIMARY KEY (id);


--
-- Name: resource_topics resource_topics_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.resource_topics
    ADD CONSTRAINT resource_topics_pkey PRIMARY KEY (id);


--
-- Name: resource_types resource_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.resource_types
    ADD CONSTRAINT resource_types_pkey PRIMARY KEY (id);


--
-- Name: resources resources_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.resources
    ADD CONSTRAINT resources_pkey PRIMARY KEY (id);


--
-- Name: resources_use_cases resources_use_cases_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.resources_use_cases
    ADD CONSTRAINT resources_use_cases_pkey PRIMARY KEY (id);


--
-- Name: rubric_categories rubric_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rubric_categories
    ADD CONSTRAINT rubric_categories_pkey PRIMARY KEY (id);


--
-- Name: rubric_category_descriptions rubric_category_descriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rubric_category_descriptions
    ADD CONSTRAINT rubric_category_descriptions_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: sdg_targets sdg_targets_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sdg_targets
    ADD CONSTRAINT sdg_targets_pkey PRIMARY KEY (id);


--
-- Name: sectors sectors_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sectors
    ADD CONSTRAINT sectors_pkey PRIMARY KEY (id);


--
-- Name: sessions sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


--
-- Name: settings settings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.settings
    ADD CONSTRAINT settings_pkey PRIMARY KEY (id);


--
-- Name: software_categories software_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.software_categories
    ADD CONSTRAINT software_categories_pkey PRIMARY KEY (id);


--
-- Name: software_features software_features_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.software_features
    ADD CONSTRAINT software_features_pkey PRIMARY KEY (id);


--
-- Name: starred_objects starred_objects_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.starred_objects
    ADD CONSTRAINT starred_objects_pkey PRIMARY KEY (id);


--
-- Name: stylesheets stylesheets_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stylesheets
    ADD CONSTRAINT stylesheets_pkey PRIMARY KEY (id);


--
-- Name: sustainable_development_goals sustainable_development_goals_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sustainable_development_goals
    ADD CONSTRAINT sustainable_development_goals_pkey PRIMARY KEY (id);


--
-- Name: tag_descriptions tag_descriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tag_descriptions
    ADD CONSTRAINT tag_descriptions_pkey PRIMARY KEY (id);


--
-- Name: tags tags_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tags
    ADD CONSTRAINT tags_pkey PRIMARY KEY (id);


--
-- Name: task_tracker_descriptions task_tracker_descriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.task_tracker_descriptions
    ADD CONSTRAINT task_tracker_descriptions_pkey PRIMARY KEY (id);


--
-- Name: task_trackers task_trackers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.task_trackers
    ADD CONSTRAINT task_trackers_pkey PRIMARY KEY (id);


--
-- Name: tenant_sync_configurations tenant_sync_configurations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tenant_sync_configurations
    ADD CONSTRAINT tenant_sync_configurations_pkey PRIMARY KEY (id);


--
-- Name: use_case_descriptions use_case_descriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.use_case_descriptions
    ADD CONSTRAINT use_case_descriptions_pkey PRIMARY KEY (id);


--
-- Name: use_case_headers use_case_headers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.use_case_headers
    ADD CONSTRAINT use_case_headers_pkey PRIMARY KEY (id);


--
-- Name: use_case_step_descriptions use_case_step_descriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.use_case_step_descriptions
    ADD CONSTRAINT use_case_step_descriptions_pkey PRIMARY KEY (id);


--
-- Name: use_case_steps_building_blocks use_case_steps_building_blocks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.use_case_steps_building_blocks
    ADD CONSTRAINT use_case_steps_building_blocks_pkey PRIMARY KEY (id);


--
-- Name: use_case_steps_datasets use_case_steps_datasets_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.use_case_steps_datasets
    ADD CONSTRAINT use_case_steps_datasets_pkey PRIMARY KEY (id);


--
-- Name: use_case_steps use_case_steps_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.use_case_steps
    ADD CONSTRAINT use_case_steps_pkey PRIMARY KEY (id);


--
-- Name: use_case_steps_products use_case_steps_products_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.use_case_steps_products
    ADD CONSTRAINT use_case_steps_products_pkey PRIMARY KEY (id);


--
-- Name: use_cases use_cases_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.use_cases
    ADD CONSTRAINT use_cases_pkey PRIMARY KEY (id);


--
-- Name: user_events user_events_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_events
    ADD CONSTRAINT user_events_pkey PRIMARY KEY (id);


--
-- Name: user_messages user_messages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_messages
    ADD CONSTRAINT user_messages_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: workflow_descriptions workflow_descriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.workflow_descriptions
    ADD CONSTRAINT workflow_descriptions_pkey PRIMARY KEY (id);


--
-- Name: workflows workflows_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.workflows
    ADD CONSTRAINT workflows_pkey PRIMARY KEY (id);


--
-- Name: agg_cap_operator_capability_index; Type: INDEX; Schema: fao; Owner: -
--

CREATE UNIQUE INDEX agg_cap_operator_capability_index ON fao.aggregator_capabilities USING btree (aggregator_id, operator_services_id, capability);


--
-- Name: associated_index; Type: INDEX; Schema: fao; Owner: -
--

CREATE INDEX associated_index ON fao.audits USING btree (associated_type, associated_id);


--
-- Name: auditable_index; Type: INDEX; Schema: fao; Owner: -
--

CREATE INDEX auditable_index ON fao.audits USING btree (action, id, version);


--
-- Name: authors_unique_slug; Type: INDEX; Schema: fao; Owner: -
--

CREATE UNIQUE INDEX authors_unique_slug ON fao.authors USING btree (slug);


--
-- Name: bbs_plays_idx; Type: INDEX; Schema: fao; Owner: -
--

CREATE UNIQUE INDEX bbs_plays_idx ON fao.plays_building_blocks USING btree (building_block_id, play_id);


--
-- Name: bbs_workflows; Type: INDEX; Schema: fao; Owner: -
--

CREATE UNIQUE INDEX bbs_workflows ON fao.workflows_building_blocks USING btree (building_block_id, workflow_id);


--
-- Name: block_prods; Type: INDEX; Schema: fao; Owner: -
--

CREATE UNIQUE INDEX block_prods ON fao.product_building_blocks USING btree (building_block_id, product_id);


--
-- Name: building_blocks_use_case_steps_idx; Type: INDEX; Schema: fao; Owner: -
--

CREATE UNIQUE INDEX building_blocks_use_case_steps_idx ON fao.use_case_steps_building_blocks USING btree (building_block_id, use_case_step_id);


--
-- Name: candidate_resources_countries_idx; Type: INDEX; Schema: fao; Owner: -
--

CREATE UNIQUE INDEX candidate_resources_countries_idx ON fao.candidate_resources_countries USING btree (candidate_resource_id, country_id);


--
-- Name: candidate_roles_unique_fields; Type: INDEX; Schema: fao; Owner: -
--

CREATE UNIQUE INDEX candidate_roles_unique_fields ON fao.candidate_roles USING btree (email, roles, organization_id, product_id);


--
-- Name: classifications_products_idx; Type: INDEX; Schema: fao; Owner: -
--

CREATE UNIQUE INDEX classifications_products_idx ON fao.product_classifications USING btree (classification_id, product_id);


--
-- Name: countries_candidate_resources_idx; Type: INDEX; Schema: fao; Owner: -
--

CREATE UNIQUE INDEX countries_candidate_resources_idx ON fao.candidate_resources_countries USING btree (country_id, candidate_resource_id);


--
-- Name: countries_product_idx; Type: INDEX; Schema: fao; Owner: -
--

CREATE UNIQUE INDEX countries_product_idx ON fao.products_countries USING btree (country_id, product_id);


--
-- Name: dataset_sdg_index_on_sdg_id; Type: INDEX; Schema: fao; Owner: -
--

CREATE INDEX dataset_sdg_index_on_sdg_id ON fao.dataset_sustainable_development_goals USING btree (sustainable_development_goal_id);


--
-- Name: datasets_use_case_steps_idx; Type: INDEX; Schema: fao; Owner: -
--

CREATE UNIQUE INDEX datasets_use_case_steps_idx ON fao.use_case_steps_datasets USING btree (dataset_id, use_case_step_id);


--
-- Name: index_aggregator_capabilities_on_aggregator_id; Type: INDEX; Schema: fao; Owner: -
--

CREATE INDEX index_aggregator_capabilities_on_aggregator_id ON fao.aggregator_capabilities USING btree (aggregator_id);


--
-- Name: index_aggregator_capabilities_on_country_id; Type: INDEX; Schema: fao; Owner: -
--

CREATE INDEX index_aggregator_capabilities_on_country_id ON fao.aggregator_capabilities USING btree (country_id);


--
-- Name: index_aggregator_capabilities_on_operator_services_id; Type: INDEX; Schema: fao; Owner: -
--

CREATE INDEX index_aggregator_capabilities_on_operator_services_id ON fao.aggregator_capabilities USING btree (operator_services_id);


--
-- Name: index_audits_on_created_at; Type: INDEX; Schema: fao; Owner: -
--

CREATE INDEX index_audits_on_created_at ON fao.audits USING btree (created_at);


--
-- Name: index_building_block_descriptions_on_building_block_id; Type: INDEX; Schema: fao; Owner: -
--

CREATE INDEX index_building_block_descriptions_on_building_block_id ON fao.building_block_descriptions USING btree (building_block_id);


--
-- Name: index_building_blocks_on_slug; Type: INDEX; Schema: fao; Owner: -
--

CREATE UNIQUE INDEX index_building_blocks_on_slug ON fao.building_blocks USING btree (slug);


--
-- Name: index_candidate_contacts_on_candidate_id_and_contact_id; Type: INDEX; Schema: fao; Owner: -
--

CREATE INDEX index_candidate_contacts_on_candidate_id_and_contact_id ON fao.candidate_organizations_contacts USING btree (candidate_organization_id, contact_id);


--
-- Name: index_candidate_contacts_on_contact_id_and_candidate_id; Type: INDEX; Schema: fao; Owner: -
--

CREATE INDEX index_candidate_contacts_on_contact_id_and_candidate_id ON fao.candidate_organizations_contacts USING btree (contact_id, candidate_organization_id);


--
-- Name: index_candidate_datasets_on_approved_by_id; Type: INDEX; Schema: fao; Owner: -
--

CREATE INDEX index_candidate_datasets_on_approved_by_id ON fao.candidate_datasets USING btree (approved_by_id);


--
-- Name: index_candidate_datasets_on_rejected_by_id; Type: INDEX; Schema: fao; Owner: -
--

CREATE INDEX index_candidate_datasets_on_rejected_by_id ON fao.candidate_datasets USING btree (rejected_by_id);


--
-- Name: index_candidate_organizations_on_approved_by_id; Type: INDEX; Schema: fao; Owner: -
--

CREATE INDEX index_candidate_organizations_on_approved_by_id ON fao.candidate_organizations USING btree (approved_by_id);


--
-- Name: index_candidate_organizations_on_rejected_by_id; Type: INDEX; Schema: fao; Owner: -
--

CREATE INDEX index_candidate_organizations_on_rejected_by_id ON fao.candidate_organizations USING btree (rejected_by_id);


--
-- Name: index_candidate_products_on_approved_by_id; Type: INDEX; Schema: fao; Owner: -
--

CREATE INDEX index_candidate_products_on_approved_by_id ON fao.candidate_products USING btree (approved_by_id);


--
-- Name: index_candidate_products_on_rejected_by_id; Type: INDEX; Schema: fao; Owner: -
--

CREATE INDEX index_candidate_products_on_rejected_by_id ON fao.candidate_products USING btree (rejected_by_id);


--
-- Name: index_candidate_resources_on_approved_by_id; Type: INDEX; Schema: fao; Owner: -
--

CREATE INDEX index_candidate_resources_on_approved_by_id ON fao.candidate_resources USING btree (approved_by_id);


--
-- Name: index_candidate_resources_on_rejected_by_id; Type: INDEX; Schema: fao; Owner: -
--

CREATE INDEX index_candidate_resources_on_rejected_by_id ON fao.candidate_resources USING btree (rejected_by_id);


--
-- Name: index_candidate_roles_on_approved_by_id; Type: INDEX; Schema: fao; Owner: -
--

CREATE INDEX index_candidate_roles_on_approved_by_id ON fao.candidate_roles USING btree (approved_by_id);


--
-- Name: index_candidate_roles_on_dataset_id; Type: INDEX; Schema: fao; Owner: -
--

CREATE INDEX index_candidate_roles_on_dataset_id ON fao.candidate_roles USING btree (dataset_id);


--
-- Name: index_candidate_roles_on_rejected_by_id; Type: INDEX; Schema: fao; Owner: -
--

CREATE INDEX index_candidate_roles_on_rejected_by_id ON fao.candidate_roles USING btree (rejected_by_id);


--
-- Name: index_category_indicator_descriptions_on_category_indicator_id; Type: INDEX; Schema: fao; Owner: -
--

CREATE INDEX index_category_indicator_descriptions_on_category_indicator_id ON fao.category_indicator_descriptions USING btree (category_indicator_id);


--
-- Name: index_category_indicators_on_rubric_category_id; Type: INDEX; Schema: fao; Owner: -
--

CREATE INDEX index_category_indicators_on_rubric_category_id ON fao.category_indicators USING btree (rubric_category_id);


--
-- Name: index_chatbot_conversations_on_user_id; Type: INDEX; Schema: fao; Owner: -
--

CREATE INDEX index_chatbot_conversations_on_user_id ON fao.chatbot_conversations USING btree (user_id);


--
-- Name: index_cities_on_province_id; Type: INDEX; Schema: fao; Owner: -
--

CREATE INDEX index_cities_on_province_id ON fao.cities USING btree (province_id);


--
-- Name: index_ckeditor_assets_on_type; Type: INDEX; Schema: fao; Owner: -
--

CREATE INDEX index_ckeditor_assets_on_type ON fao.ckeditor_assets USING btree (type);


--
-- Name: index_contacts_on_slug; Type: INDEX; Schema: fao; Owner: -
--

CREATE UNIQUE INDEX index_contacts_on_slug ON fao.contacts USING btree (slug);


--
-- Name: index_dataset_descriptions_on_dataset_id; Type: INDEX; Schema: fao; Owner: -
--

CREATE INDEX index_dataset_descriptions_on_dataset_id ON fao.dataset_descriptions USING btree (dataset_id);


--
-- Name: index_dataset_sectors_on_dataset_id; Type: INDEX; Schema: fao; Owner: -
--

CREATE INDEX index_dataset_sectors_on_dataset_id ON fao.dataset_sectors USING btree (dataset_id);


--
-- Name: index_dataset_sectors_on_sector_id; Type: INDEX; Schema: fao; Owner: -
--

CREATE INDEX index_dataset_sectors_on_sector_id ON fao.dataset_sectors USING btree (sector_id);


--
-- Name: index_dataset_sustainable_development_goals_on_dataset_id; Type: INDEX; Schema: fao; Owner: -
--

CREATE INDEX index_dataset_sustainable_development_goals_on_dataset_id ON fao.dataset_sustainable_development_goals USING btree (dataset_id);


--
-- Name: index_datasets_countries_on_country_id; Type: INDEX; Schema: fao; Owner: -
--

CREATE INDEX index_datasets_countries_on_country_id ON fao.datasets_countries USING btree (country_id);


--
-- Name: index_datasets_countries_on_dataset_id; Type: INDEX; Schema: fao; Owner: -
--

CREATE INDEX index_datasets_countries_on_dataset_id ON fao.datasets_countries USING btree (dataset_id);


--
-- Name: index_datasets_origins_on_dataset_id; Type: INDEX; Schema: fao; Owner: -
--

CREATE INDEX index_datasets_origins_on_dataset_id ON fao.datasets_origins USING btree (dataset_id);


--
-- Name: index_datasets_origins_on_origin_id; Type: INDEX; Schema: fao; Owner: -
--

CREATE INDEX index_datasets_origins_on_origin_id ON fao.datasets_origins USING btree (origin_id);


--
-- Name: index_deploys_on_product_id; Type: INDEX; Schema: fao; Owner: -
--

CREATE INDEX index_deploys_on_product_id ON fao.deploys USING btree (product_id);


--
-- Name: index_deploys_on_user_id; Type: INDEX; Schema: fao; Owner: -
--

CREATE INDEX index_deploys_on_user_id ON fao.deploys USING btree (user_id);


--
-- Name: index_districts_on_province_id; Type: INDEX; Schema: fao; Owner: -
--

CREATE INDEX index_districts_on_province_id ON fao.districts USING btree (province_id);


--
-- Name: index_handbook_answers_on_handbook_question_id; Type: INDEX; Schema: fao; Owner: -
--

CREATE INDEX index_handbook_answers_on_handbook_question_id ON fao.handbook_answers USING btree (handbook_question_id);


--
-- Name: index_handbook_descriptions_on_handbook_id; Type: INDEX; Schema: fao; Owner: -
--

CREATE INDEX index_handbook_descriptions_on_handbook_id ON fao.handbook_descriptions USING btree (handbook_id);


--
-- Name: index_handbook_pages_on_handbook_id; Type: INDEX; Schema: fao; Owner: -
--

CREATE INDEX index_handbook_pages_on_handbook_id ON fao.handbook_pages USING btree (handbook_id);


--
-- Name: index_handbook_pages_on_handbook_questions_id; Type: INDEX; Schema: fao; Owner: -
--

CREATE INDEX index_handbook_pages_on_handbook_questions_id ON fao.handbook_pages USING btree (handbook_questions_id);


--
-- Name: index_handbook_pages_on_parent_page_id; Type: INDEX; Schema: fao; Owner: -
--

CREATE INDEX index_handbook_pages_on_parent_page_id ON fao.handbook_pages USING btree (parent_page_id);


--
-- Name: index_handbook_questions_on_handbook_page_id; Type: INDEX; Schema: fao; Owner: -
--

CREATE INDEX index_handbook_questions_on_handbook_page_id ON fao.handbook_questions USING btree (handbook_page_id);


--
-- Name: index_messages_on_created_by_id; Type: INDEX; Schema: fao; Owner: -
--

CREATE INDEX index_messages_on_created_by_id ON fao.messages USING btree (created_by_id);


--
-- Name: index_offices_on_country_id; Type: INDEX; Schema: fao; Owner: -
--

CREATE INDEX index_offices_on_country_id ON fao.offices USING btree (country_id);


--
-- Name: index_offices_on_organization_id; Type: INDEX; Schema: fao; Owner: -
--

CREATE INDEX index_offices_on_organization_id ON fao.offices USING btree (organization_id);


--
-- Name: index_offices_on_province_id; Type: INDEX; Schema: fao; Owner: -
--

CREATE INDEX index_offices_on_province_id ON fao.offices USING btree (province_id);


--
-- Name: index_operator_services_on_country_id; Type: INDEX; Schema: fao; Owner: -
--

CREATE INDEX index_operator_services_on_country_id ON fao.operator_services USING btree (country_id);


--
-- Name: index_opportunities_building_blocks_on_building_block_id; Type: INDEX; Schema: fao; Owner: -
--

CREATE INDEX index_opportunities_building_blocks_on_building_block_id ON fao.opportunities_building_blocks USING btree (building_block_id);


--
-- Name: index_opportunities_building_blocks_on_opportunity_id; Type: INDEX; Schema: fao; Owner: -
--

CREATE INDEX index_opportunities_building_blocks_on_opportunity_id ON fao.opportunities_building_blocks USING btree (opportunity_id);


--
-- Name: index_opportunities_countries_on_country_id; Type: INDEX; Schema: fao; Owner: -
--

CREATE INDEX index_opportunities_countries_on_country_id ON fao.opportunities_countries USING btree (country_id);


--
-- Name: index_opportunities_countries_on_opportunity_id; Type: INDEX; Schema: fao; Owner: -
--

CREATE INDEX index_opportunities_countries_on_opportunity_id ON fao.opportunities_countries USING btree (opportunity_id);


--
-- Name: index_opportunities_on_origin_id; Type: INDEX; Schema: fao; Owner: -
--

CREATE INDEX index_opportunities_on_origin_id ON fao.opportunities USING btree (origin_id);


--
-- Name: index_opportunities_organizations_on_opportunity_id; Type: INDEX; Schema: fao; Owner: -
--

CREATE INDEX index_opportunities_organizations_on_opportunity_id ON fao.opportunities_organizations USING btree (opportunity_id);


--
-- Name: index_opportunities_organizations_on_organization_id; Type: INDEX; Schema: fao; Owner: -
--

CREATE INDEX index_opportunities_organizations_on_organization_id ON fao.opportunities_organizations USING btree (organization_id);


--
-- Name: index_opportunities_sectors_on_opportunity_id; Type: INDEX; Schema: fao; Owner: -
--

CREATE INDEX index_opportunities_sectors_on_opportunity_id ON fao.opportunities_sectors USING btree (opportunity_id);


--
-- Name: index_opportunities_sectors_on_sector_id; Type: INDEX; Schema: fao; Owner: -
--

CREATE INDEX index_opportunities_sectors_on_sector_id ON fao.opportunities_sectors USING btree (sector_id);


--
-- Name: index_opportunities_use_cases_on_opportunity_id; Type: INDEX; Schema: fao; Owner: -
--

CREATE INDEX index_opportunities_use_cases_on_opportunity_id ON fao.opportunities_use_cases USING btree (opportunity_id);


--
-- Name: index_opportunities_use_cases_on_use_case_id; Type: INDEX; Schema: fao; Owner: -
--

CREATE INDEX index_opportunities_use_cases_on_use_case_id ON fao.opportunities_use_cases USING btree (use_case_id);


--
-- Name: index_organization_datasets_on_dataset_id; Type: INDEX; Schema: fao; Owner: -
--

CREATE INDEX index_organization_datasets_on_dataset_id ON fao.organization_datasets USING btree (dataset_id);


--
-- Name: index_organization_datasets_on_organization_id; Type: INDEX; Schema: fao; Owner: -
--

CREATE INDEX index_organization_datasets_on_organization_id ON fao.organization_datasets USING btree (organization_id);


--
-- Name: index_organization_descriptions_on_organization_id; Type: INDEX; Schema: fao; Owner: -
--

CREATE INDEX index_organization_descriptions_on_organization_id ON fao.organization_descriptions USING btree (organization_id);


--
-- Name: index_organization_products_on_organization_id_and_product_id; Type: INDEX; Schema: fao; Owner: -
--

CREATE UNIQUE INDEX index_organization_products_on_organization_id_and_product_id ON fao.organization_products USING btree (organization_id, product_id);


--
-- Name: index_organization_products_on_product_id_and_organization_id; Type: INDEX; Schema: fao; Owner: -
--

CREATE UNIQUE INDEX index_organization_products_on_product_id_and_organization_id ON fao.organization_products USING btree (product_id, organization_id);


--
-- Name: index_organizations_countries_on_country_id; Type: INDEX; Schema: fao; Owner: -
--

CREATE INDEX index_organizations_countries_on_country_id ON fao.organizations_countries USING btree (country_id);


--
-- Name: index_organizations_countries_on_organization_id; Type: INDEX; Schema: fao; Owner: -
--

CREATE INDEX index_organizations_countries_on_organization_id ON fao.organizations_countries USING btree (organization_id);


--
-- Name: index_organizations_on_slug; Type: INDEX; Schema: fao; Owner: -
--

CREATE UNIQUE INDEX index_organizations_on_slug ON fao.organizations USING btree (slug);


--
-- Name: index_origins_on_organization_id; Type: INDEX; Schema: fao; Owner: -
--

CREATE INDEX index_origins_on_organization_id ON fao.origins USING btree (organization_id);


--
-- Name: index_page_contents_on_handbook_page_id; Type: INDEX; Schema: fao; Owner: -
--

CREATE INDEX index_page_contents_on_handbook_page_id ON fao.page_contents USING btree (handbook_page_id);


--
-- Name: index_play_descriptions_on_play_id; Type: INDEX; Schema: fao; Owner: -
--

CREATE INDEX index_play_descriptions_on_play_id ON fao.play_descriptions USING btree (play_id);


--
-- Name: index_play_move_descriptions_on_play_move_id; Type: INDEX; Schema: fao; Owner: -
--

CREATE INDEX index_play_move_descriptions_on_play_move_id ON fao.play_move_descriptions USING btree (play_move_id);


--
-- Name: index_play_moves_on_play_id; Type: INDEX; Schema: fao; Owner: -
--

CREATE INDEX index_play_moves_on_play_id ON fao.play_moves USING btree (play_id);


--
-- Name: index_play_moves_resources; Type: INDEX; Schema: fao; Owner: -
--

CREATE UNIQUE INDEX index_play_moves_resources ON fao.play_moves_resources USING btree (play_move_id, resource_id);


--
-- Name: index_play_moves_resources_on_play_move_id; Type: INDEX; Schema: fao; Owner: -
--

CREATE INDEX index_play_moves_resources_on_play_move_id ON fao.play_moves_resources USING btree (play_move_id);


--
-- Name: index_play_moves_resources_on_resource_id; Type: INDEX; Schema: fao; Owner: -
--

CREATE INDEX index_play_moves_resources_on_resource_id ON fao.play_moves_resources USING btree (resource_id);


--
-- Name: index_playbook_descriptions_on_playbook_id; Type: INDEX; Schema: fao; Owner: -
--

CREATE INDEX index_playbook_descriptions_on_playbook_id ON fao.playbook_descriptions USING btree (playbook_id);


--
-- Name: index_playbook_plays_on_play_id; Type: INDEX; Schema: fao; Owner: -
--

CREATE INDEX index_playbook_plays_on_play_id ON fao.playbook_plays USING btree (play_id);


--
-- Name: index_playbook_plays_on_playbook_id; Type: INDEX; Schema: fao; Owner: -
--

CREATE INDEX index_playbook_plays_on_playbook_id ON fao.playbook_plays USING btree (playbook_id);


--
-- Name: index_plays_building_blocks_on_building_block_id; Type: INDEX; Schema: fao; Owner: -
--

CREATE INDEX index_plays_building_blocks_on_building_block_id ON fao.plays_building_blocks USING btree (building_block_id);


--
-- Name: index_plays_building_blocks_on_play_id; Type: INDEX; Schema: fao; Owner: -
--

CREATE INDEX index_plays_building_blocks_on_play_id ON fao.plays_building_blocks USING btree (play_id);


--
-- Name: index_plays_products_on_play_id; Type: INDEX; Schema: fao; Owner: -
--

CREATE INDEX index_plays_products_on_play_id ON fao.plays_products USING btree (play_id);


--
-- Name: index_plays_products_on_product_id; Type: INDEX; Schema: fao; Owner: -
--

CREATE INDEX index_plays_products_on_product_id ON fao.plays_products USING btree (product_id);


--
-- Name: index_principle_descriptions_on_digital_principle_id; Type: INDEX; Schema: fao; Owner: -
--

CREATE INDEX index_principle_descriptions_on_digital_principle_id ON fao.principle_descriptions USING btree (digital_principle_id);


--
-- Name: index_product_categories_on_product_id; Type: INDEX; Schema: fao; Owner: -
--

CREATE INDEX index_product_categories_on_product_id ON fao.product_categories USING btree (product_id);


--
-- Name: index_product_categories_on_software_category_id; Type: INDEX; Schema: fao; Owner: -
--

CREATE INDEX index_product_categories_on_software_category_id ON fao.product_categories USING btree (software_category_id);


--
-- Name: index_product_classifications_on_classification_id; Type: INDEX; Schema: fao; Owner: -
--

CREATE INDEX index_product_classifications_on_classification_id ON fao.product_classifications USING btree (classification_id);


--
-- Name: index_product_classifications_on_product_id; Type: INDEX; Schema: fao; Owner: -
--

CREATE INDEX index_product_classifications_on_product_id ON fao.product_classifications USING btree (product_id);


--
-- Name: index_product_descriptions_on_product_id; Type: INDEX; Schema: fao; Owner: -
--

CREATE INDEX index_product_descriptions_on_product_id ON fao.product_descriptions USING btree (product_id);


--
-- Name: index_product_features_on_product_id; Type: INDEX; Schema: fao; Owner: -
--

CREATE INDEX index_product_features_on_product_id ON fao.product_features USING btree (product_id);


--
-- Name: index_product_features_on_software_feature_id; Type: INDEX; Schema: fao; Owner: -
--

CREATE INDEX index_product_features_on_software_feature_id ON fao.product_features USING btree (software_feature_id);


--
-- Name: index_product_indicators_on_category_indicator_id; Type: INDEX; Schema: fao; Owner: -
--

CREATE INDEX index_product_indicators_on_category_indicator_id ON fao.product_indicators USING btree (category_indicator_id);


--
-- Name: index_product_indicators_on_product_id; Type: INDEX; Schema: fao; Owner: -
--

CREATE INDEX index_product_indicators_on_product_id ON fao.product_indicators USING btree (product_id);


--
-- Name: index_product_repositories_on_product_id; Type: INDEX; Schema: fao; Owner: -
--

CREATE INDEX index_product_repositories_on_product_id ON fao.product_repositories USING btree (product_id);


--
-- Name: index_product_sectors_on_product_id_and_sector_id; Type: INDEX; Schema: fao; Owner: -
--

CREATE INDEX index_product_sectors_on_product_id_and_sector_id ON fao.product_sectors USING btree (product_id, sector_id);


--
-- Name: index_product_sectors_on_sector_id_and_product_id; Type: INDEX; Schema: fao; Owner: -
--

CREATE INDEX index_product_sectors_on_sector_id_and_product_id ON fao.product_sectors USING btree (sector_id, product_id);


--
-- Name: index_products_endorsers_on_endorser_id; Type: INDEX; Schema: fao; Owner: -
--

CREATE INDEX index_products_endorsers_on_endorser_id ON fao.products_endorsers USING btree (endorser_id);


--
-- Name: index_products_endorsers_on_product_id; Type: INDEX; Schema: fao; Owner: -
--

CREATE INDEX index_products_endorsers_on_product_id ON fao.products_endorsers USING btree (product_id);


--
-- Name: index_products_on_slug; Type: INDEX; Schema: fao; Owner: -
--

CREATE UNIQUE INDEX index_products_on_slug ON fao.products USING btree (slug);


--
-- Name: index_products_resources_on_product_id; Type: INDEX; Schema: fao; Owner: -
--

CREATE INDEX index_products_resources_on_product_id ON fao.products_resources USING btree (product_id);


--
-- Name: index_products_resources_on_resource_id; Type: INDEX; Schema: fao; Owner: -
--

CREATE INDEX index_products_resources_on_resource_id ON fao.products_resources USING btree (resource_id);


--
-- Name: index_project_descriptions_on_project_id; Type: INDEX; Schema: fao; Owner: -
--

CREATE INDEX index_project_descriptions_on_project_id ON fao.project_descriptions USING btree (project_id);


--
-- Name: index_projects_countries_on_country_id; Type: INDEX; Schema: fao; Owner: -
--

CREATE INDEX index_projects_countries_on_country_id ON fao.projects_countries USING btree (country_id);


--
-- Name: index_projects_countries_on_project_id; Type: INDEX; Schema: fao; Owner: -
--

CREATE INDEX index_projects_countries_on_project_id ON fao.projects_countries USING btree (project_id);


--
-- Name: index_projects_digital_principles_on_digital_principle_id; Type: INDEX; Schema: fao; Owner: -
--

CREATE INDEX index_projects_digital_principles_on_digital_principle_id ON fao.projects_digital_principles USING btree (digital_principle_id);


--
-- Name: index_projects_digital_principles_on_project_id; Type: INDEX; Schema: fao; Owner: -
--

CREATE INDEX index_projects_digital_principles_on_project_id ON fao.projects_digital_principles USING btree (project_id);


--
-- Name: index_projects_on_origin_id; Type: INDEX; Schema: fao; Owner: -
--

CREATE INDEX index_projects_on_origin_id ON fao.projects USING btree (origin_id);


--
-- Name: index_provinces_on_country_id; Type: INDEX; Schema: fao; Owner: -
--

CREATE INDEX index_provinces_on_country_id ON fao.provinces USING btree (country_id);


--
-- Name: index_regions_countries; Type: INDEX; Schema: fao; Owner: -
--

CREATE UNIQUE INDEX index_regions_countries ON fao.regions_countries USING btree (region_id, country_id);


--
-- Name: index_regions_on_slug; Type: INDEX; Schema: fao; Owner: -
--

CREATE UNIQUE INDEX index_regions_on_slug ON fao.regions USING btree (slug);


--
-- Name: index_resource_building_blocks; Type: INDEX; Schema: fao; Owner: -
--

CREATE UNIQUE INDEX index_resource_building_blocks ON fao.resource_building_blocks USING btree (resource_id, building_block_id);


--
-- Name: index_resource_building_blocks_on_building_block_id; Type: INDEX; Schema: fao; Owner: -
--

CREATE INDEX index_resource_building_blocks_on_building_block_id ON fao.resource_building_blocks USING btree (building_block_id);


--
-- Name: index_resource_building_blocks_on_resource_id; Type: INDEX; Schema: fao; Owner: -
--

CREATE INDEX index_resource_building_blocks_on_resource_id ON fao.resource_building_blocks USING btree (resource_id);


--
-- Name: index_resource_topic_descriptions_on_resource_topic_id; Type: INDEX; Schema: fao; Owner: -
--

CREATE INDEX index_resource_topic_descriptions_on_resource_topic_id ON fao.resource_topic_descriptions USING btree (resource_topic_id);


--
-- Name: index_resource_topics_on_parent_topic_id; Type: INDEX; Schema: fao; Owner: -
--

CREATE INDEX index_resource_topics_on_parent_topic_id ON fao.resource_topics USING btree (parent_topic_id);


--
-- Name: index_resource_topics_on_slug; Type: INDEX; Schema: fao; Owner: -
--

CREATE UNIQUE INDEX index_resource_topics_on_slug ON fao.resource_topics USING btree (slug);


--
-- Name: index_resources_authors_on_author_id; Type: INDEX; Schema: fao; Owner: -
--

CREATE INDEX index_resources_authors_on_author_id ON fao.resources_authors USING btree (author_id);


--
-- Name: index_resources_authors_on_resource_id; Type: INDEX; Schema: fao; Owner: -
--

CREATE INDEX index_resources_authors_on_resource_id ON fao.resources_authors USING btree (resource_id);


--
-- Name: index_resources_countries_on_country_id; Type: INDEX; Schema: fao; Owner: -
--

CREATE INDEX index_resources_countries_on_country_id ON fao.resources_countries USING btree (country_id);


--
-- Name: index_resources_countries_on_resource_id; Type: INDEX; Schema: fao; Owner: -
--

CREATE INDEX index_resources_countries_on_resource_id ON fao.resources_countries USING btree (resource_id);


--
-- Name: index_resources_on_organization_id; Type: INDEX; Schema: fao; Owner: -
--

CREATE INDEX index_resources_on_organization_id ON fao.resources USING btree (organization_id);


--
-- Name: index_resources_on_submitted_by_id; Type: INDEX; Schema: fao; Owner: -
--

CREATE INDEX index_resources_on_submitted_by_id ON fao.resources USING btree (submitted_by_id);


--
-- Name: index_resources_use_cases; Type: INDEX; Schema: fao; Owner: -
--

CREATE UNIQUE INDEX index_resources_use_cases ON fao.resources_use_cases USING btree (resource_id, use_case_id);


--
-- Name: index_resources_use_cases_on_resource_id; Type: INDEX; Schema: fao; Owner: -
--

CREATE INDEX index_resources_use_cases_on_resource_id ON fao.resources_use_cases USING btree (resource_id);


--
-- Name: index_resources_use_cases_on_use_case_id; Type: INDEX; Schema: fao; Owner: -
--

CREATE INDEX index_resources_use_cases_on_use_case_id ON fao.resources_use_cases USING btree (use_case_id);


--
-- Name: index_rubric_category_descriptions_on_rubric_category_id; Type: INDEX; Schema: fao; Owner: -
--

CREATE INDEX index_rubric_category_descriptions_on_rubric_category_id ON fao.rubric_category_descriptions USING btree (rubric_category_id);


--
-- Name: index_sdgs_on_slug; Type: INDEX; Schema: fao; Owner: -
--

CREATE UNIQUE INDEX index_sdgs_on_slug ON fao.sustainable_development_goals USING btree (slug);


--
-- Name: index_sector_slug_unique; Type: INDEX; Schema: fao; Owner: -
--

CREATE UNIQUE INDEX index_sector_slug_unique ON fao.sectors USING btree (slug, origin_id, parent_sector_id, locale);


--
-- Name: index_sectors_on_origin_id; Type: INDEX; Schema: fao; Owner: -
--

CREATE INDEX index_sectors_on_origin_id ON fao.sectors USING btree (origin_id);


--
-- Name: index_sectors_on_parent_sector_id; Type: INDEX; Schema: fao; Owner: -
--

CREATE INDEX index_sectors_on_parent_sector_id ON fao.sectors USING btree (parent_sector_id);


--
-- Name: index_sessions_on_session_id; Type: INDEX; Schema: fao; Owner: -
--

CREATE UNIQUE INDEX index_sessions_on_session_id ON fao.sessions USING btree (session_id);


--
-- Name: index_sessions_on_updated_at; Type: INDEX; Schema: fao; Owner: -
--

CREATE INDEX index_sessions_on_updated_at ON fao.sessions USING btree (updated_at);


--
-- Name: index_software_features_on_software_category_id; Type: INDEX; Schema: fao; Owner: -
--

CREATE INDEX index_software_features_on_software_category_id ON fao.software_features USING btree (software_category_id);


--
-- Name: index_starred_object_record; Type: INDEX; Schema: fao; Owner: -
--

CREATE UNIQUE INDEX index_starred_object_record ON fao.starred_objects USING btree (starred_object_type, starred_object_value, source_object_type, source_object_value);


--
-- Name: index_starred_objects_on_starred_by_id; Type: INDEX; Schema: fao; Owner: -
--

CREATE INDEX index_starred_objects_on_starred_by_id ON fao.starred_objects USING btree (starred_by_id);


--
-- Name: index_tag_descriptions_on_tag_id; Type: INDEX; Schema: fao; Owner: -
--

CREATE INDEX index_tag_descriptions_on_tag_id ON fao.tag_descriptions USING btree (tag_id);


--
-- Name: index_task_tracker_descriptions_on_task_tracker_id; Type: INDEX; Schema: fao; Owner: -
--

CREATE INDEX index_task_tracker_descriptions_on_task_tracker_id ON fao.task_tracker_descriptions USING btree (task_tracker_id);


--
-- Name: index_use_case_descriptions_on_use_case_id; Type: INDEX; Schema: fao; Owner: -
--

CREATE INDEX index_use_case_descriptions_on_use_case_id ON fao.use_case_descriptions USING btree (use_case_id);


--
-- Name: index_use_case_headers_on_use_case_id; Type: INDEX; Schema: fao; Owner: -
--

CREATE INDEX index_use_case_headers_on_use_case_id ON fao.use_case_headers USING btree (use_case_id);


--
-- Name: index_use_case_step_descriptions_on_use_case_step_id; Type: INDEX; Schema: fao; Owner: -
--

CREATE INDEX index_use_case_step_descriptions_on_use_case_step_id ON fao.use_case_step_descriptions USING btree (use_case_step_id);


--
-- Name: index_use_case_steps_on_use_case_id; Type: INDEX; Schema: fao; Owner: -
--

CREATE INDEX index_use_case_steps_on_use_case_id ON fao.use_case_steps USING btree (use_case_id);


--
-- Name: index_use_cases_on_sector_id; Type: INDEX; Schema: fao; Owner: -
--

CREATE INDEX index_use_cases_on_sector_id ON fao.use_cases USING btree (sector_id);


--
-- Name: index_user_messages_on_message_id; Type: INDEX; Schema: fao; Owner: -
--

CREATE INDEX index_user_messages_on_message_id ON fao.user_messages USING btree (message_id);


--
-- Name: index_user_messages_on_received_by_id; Type: INDEX; Schema: fao; Owner: -
--

CREATE INDEX index_user_messages_on_received_by_id ON fao.user_messages USING btree (received_by_id);


--
-- Name: index_users_on_authentication_token; Type: INDEX; Schema: fao; Owner: -
--

CREATE UNIQUE INDEX index_users_on_authentication_token ON fao.users USING btree (authentication_token);


--
-- Name: index_users_on_confirmation_token; Type: INDEX; Schema: fao; Owner: -
--

CREATE UNIQUE INDEX index_users_on_confirmation_token ON fao.users USING btree (confirmation_token);


--
-- Name: index_users_on_email; Type: INDEX; Schema: fao; Owner: -
--

CREATE UNIQUE INDEX index_users_on_email ON fao.users USING btree (email);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: fao; Owner: -
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON fao.users USING btree (reset_password_token);


--
-- Name: index_workflow_descriptions_on_workflow_id; Type: INDEX; Schema: fao; Owner: -
--

CREATE INDEX index_workflow_descriptions_on_workflow_id ON fao.workflow_descriptions USING btree (workflow_id);


--
-- Name: opportunities_unique_slug; Type: INDEX; Schema: fao; Owner: -
--

CREATE UNIQUE INDEX opportunities_unique_slug ON fao.opportunities USING btree (slug);


--
-- Name: org_sectors; Type: INDEX; Schema: fao; Owner: -
--

CREATE UNIQUE INDEX org_sectors ON fao.organizations_sectors USING btree (organization_id, sector_id);


--
-- Name: organizations_projects_idx; Type: INDEX; Schema: fao; Owner: -
--

CREATE UNIQUE INDEX organizations_projects_idx ON fao.projects_organizations USING btree (organization_id, project_id);


--
-- Name: organizations_resources_idx; Type: INDEX; Schema: fao; Owner: -
--

CREATE UNIQUE INDEX organizations_resources_idx ON fao.organizations_resources USING btree (organization_id, resource_id);


--
-- Name: origins_products_idx; Type: INDEX; Schema: fao; Owner: -
--

CREATE UNIQUE INDEX origins_products_idx ON fao.products_origins USING btree (origin_id, product_id);


--
-- Name: play_rel_index; Type: INDEX; Schema: fao; Owner: -
--

CREATE UNIQUE INDEX play_rel_index ON fao.plays_subplays USING btree (parent_play_id, child_play_id);


--
-- Name: playbooks_sectors_idx; Type: INDEX; Schema: fao; Owner: -
--

CREATE UNIQUE INDEX playbooks_sectors_idx ON fao.playbooks_sectors USING btree (playbook_id, sector_id);


--
-- Name: plays_bbs_idx; Type: INDEX; Schema: fao; Owner: -
--

CREATE UNIQUE INDEX plays_bbs_idx ON fao.plays_building_blocks USING btree (play_id, building_block_id);


--
-- Name: plays_products_idx; Type: INDEX; Schema: fao; Owner: -
--

CREATE UNIQUE INDEX plays_products_idx ON fao.plays_products USING btree (play_id, product_id);


--
-- Name: prod_blocks; Type: INDEX; Schema: fao; Owner: -
--

CREATE UNIQUE INDEX prod_blocks ON fao.product_building_blocks USING btree (product_id, building_block_id);


--
-- Name: prod_sdgs; Type: INDEX; Schema: fao; Owner: -
--

CREATE UNIQUE INDEX prod_sdgs ON fao.product_sustainable_development_goals USING btree (product_id, sustainable_development_goal_id);


--
-- Name: product_countries_idx; Type: INDEX; Schema: fao; Owner: -
--

CREATE UNIQUE INDEX product_countries_idx ON fao.products_countries USING btree (product_id, country_id);


--
-- Name: product_rel_index; Type: INDEX; Schema: fao; Owner: -
--

CREATE UNIQUE INDEX product_rel_index ON fao.product_product_relationships USING btree (from_product_id, to_product_id);


--
-- Name: products_classifications_idx; Type: INDEX; Schema: fao; Owner: -
--

CREATE UNIQUE INDEX products_classifications_idx ON fao.product_classifications USING btree (product_id, classification_id);


--
-- Name: products_origins_idx; Type: INDEX; Schema: fao; Owner: -
--

CREATE UNIQUE INDEX products_origins_idx ON fao.products_origins USING btree (product_id, origin_id);


--
-- Name: products_plays_idx; Type: INDEX; Schema: fao; Owner: -
--

CREATE UNIQUE INDEX products_plays_idx ON fao.plays_products USING btree (product_id, play_id);


--
-- Name: products_projects_idx; Type: INDEX; Schema: fao; Owner: -
--

CREATE UNIQUE INDEX products_projects_idx ON fao.projects_products USING btree (product_id, project_id);


--
-- Name: products_use_case_steps_idx; Type: INDEX; Schema: fao; Owner: -
--

CREATE UNIQUE INDEX products_use_case_steps_idx ON fao.use_case_steps_products USING btree (product_id, use_case_step_id);


--
-- Name: projects_organizations_idx; Type: INDEX; Schema: fao; Owner: -
--

CREATE UNIQUE INDEX projects_organizations_idx ON fao.projects_organizations USING btree (project_id, organization_id);


--
-- Name: projects_products_idx; Type: INDEX; Schema: fao; Owner: -
--

CREATE UNIQUE INDEX projects_products_idx ON fao.projects_products USING btree (project_id, product_id);


--
-- Name: projects_sdgs_idx; Type: INDEX; Schema: fao; Owner: -
--

CREATE UNIQUE INDEX projects_sdgs_idx ON fao.projects_sdgs USING btree (project_id, sdg_id);


--
-- Name: projects_sectors_idx; Type: INDEX; Schema: fao; Owner: -
--

CREATE UNIQUE INDEX projects_sectors_idx ON fao.projects_sectors USING btree (project_id, sector_id);


--
-- Name: resources_organizations_idx; Type: INDEX; Schema: fao; Owner: -
--

CREATE UNIQUE INDEX resources_organizations_idx ON fao.organizations_resources USING btree (resource_id, organization_id);


--
-- Name: sdgs_prods; Type: INDEX; Schema: fao; Owner: -
--

CREATE UNIQUE INDEX sdgs_prods ON fao.product_sustainable_development_goals USING btree (sustainable_development_goal_id, product_id);


--
-- Name: sdgs_projects_idx; Type: INDEX; Schema: fao; Owner: -
--

CREATE UNIQUE INDEX sdgs_projects_idx ON fao.projects_sdgs USING btree (sdg_id, project_id);


--
-- Name: sdgs_usecases; Type: INDEX; Schema: fao; Owner: -
--

CREATE UNIQUE INDEX sdgs_usecases ON fao.use_cases_sdg_targets USING btree (sdg_target_id, use_case_id);


--
-- Name: sector_orcs; Type: INDEX; Schema: fao; Owner: -
--

CREATE UNIQUE INDEX sector_orcs ON fao.organizations_sectors USING btree (sector_id, organization_id);


--
-- Name: sectors_playbooks_idx; Type: INDEX; Schema: fao; Owner: -
--

CREATE UNIQUE INDEX sectors_playbooks_idx ON fao.playbooks_sectors USING btree (sector_id, playbook_id);


--
-- Name: sectors_projects_idx; Type: INDEX; Schema: fao; Owner: -
--

CREATE UNIQUE INDEX sectors_projects_idx ON fao.projects_sectors USING btree (sector_id, project_id);


--
-- Name: unique_on_resource_topic_id_and_locale; Type: INDEX; Schema: fao; Owner: -
--

CREATE UNIQUE INDEX unique_on_resource_topic_id_and_locale ON fao.resource_topic_descriptions USING btree (resource_topic_id, locale);


--
-- Name: use_case_steps_building_blocks_idx; Type: INDEX; Schema: fao; Owner: -
--

CREATE UNIQUE INDEX use_case_steps_building_blocks_idx ON fao.use_case_steps_building_blocks USING btree (use_case_step_id, building_block_id);


--
-- Name: use_case_steps_datasets_idx; Type: INDEX; Schema: fao; Owner: -
--

CREATE UNIQUE INDEX use_case_steps_datasets_idx ON fao.use_case_steps_datasets USING btree (use_case_step_id, dataset_id);


--
-- Name: use_case_steps_products_idx; Type: INDEX; Schema: fao; Owner: -
--

CREATE UNIQUE INDEX use_case_steps_products_idx ON fao.use_case_steps_products USING btree (use_case_step_id, product_id);


--
-- Name: use_case_steps_workflows_idx; Type: INDEX; Schema: fao; Owner: -
--

CREATE UNIQUE INDEX use_case_steps_workflows_idx ON fao.use_case_steps_workflows USING btree (use_case_step_id, workflow_id);


--
-- Name: usecases_sdgs; Type: INDEX; Schema: fao; Owner: -
--

CREATE UNIQUE INDEX usecases_sdgs ON fao.use_cases_sdg_targets USING btree (use_case_id, sdg_target_id);


--
-- Name: usecases_workflows; Type: INDEX; Schema: fao; Owner: -
--

CREATE UNIQUE INDEX usecases_workflows ON fao.workflows_use_cases USING btree (use_case_id, workflow_id);


--
-- Name: user_index; Type: INDEX; Schema: fao; Owner: -
--

CREATE INDEX user_index ON fao.audits USING btree (user_id, user_role);


--
-- Name: workflows_bbs; Type: INDEX; Schema: fao; Owner: -
--

CREATE UNIQUE INDEX workflows_bbs ON fao.workflows_building_blocks USING btree (workflow_id, building_block_id);


--
-- Name: workflows_use_case_steps_idx; Type: INDEX; Schema: fao; Owner: -
--

CREATE UNIQUE INDEX workflows_use_case_steps_idx ON fao.use_case_steps_workflows USING btree (workflow_id, use_case_step_id);


--
-- Name: workflows_usecases; Type: INDEX; Schema: fao; Owner: -
--

CREATE UNIQUE INDEX workflows_usecases ON fao.workflows_use_cases USING btree (workflow_id, use_case_id);


--
-- Name: agg_cap_operator_capability_index; Type: INDEX; Schema: health; Owner: -
--

CREATE UNIQUE INDEX agg_cap_operator_capability_index ON health.aggregator_capabilities USING btree (aggregator_id, operator_services_id, capability);


--
-- Name: associated_index; Type: INDEX; Schema: health; Owner: -
--

CREATE INDEX associated_index ON health.audits USING btree (associated_type, associated_id);


--
-- Name: auditable_index; Type: INDEX; Schema: health; Owner: -
--

CREATE INDEX auditable_index ON health.audits USING btree (action, id, version);


--
-- Name: authors_unique_slug; Type: INDEX; Schema: health; Owner: -
--

CREATE UNIQUE INDEX authors_unique_slug ON health.authors USING btree (slug);


--
-- Name: bbs_plays_idx; Type: INDEX; Schema: health; Owner: -
--

CREATE UNIQUE INDEX bbs_plays_idx ON health.plays_building_blocks USING btree (building_block_id, play_id);


--
-- Name: bbs_workflows; Type: INDEX; Schema: health; Owner: -
--

CREATE UNIQUE INDEX bbs_workflows ON health.workflows_building_blocks USING btree (building_block_id, workflow_id);


--
-- Name: block_prods; Type: INDEX; Schema: health; Owner: -
--

CREATE UNIQUE INDEX block_prods ON health.product_building_blocks USING btree (building_block_id, product_id);


--
-- Name: building_blocks_use_case_steps_idx; Type: INDEX; Schema: health; Owner: -
--

CREATE UNIQUE INDEX building_blocks_use_case_steps_idx ON health.use_case_steps_building_blocks USING btree (building_block_id, use_case_step_id);


--
-- Name: candidate_resources_countries_idx; Type: INDEX; Schema: health; Owner: -
--

CREATE UNIQUE INDEX candidate_resources_countries_idx ON health.candidate_resources_countries USING btree (candidate_resource_id, country_id);


--
-- Name: candidate_roles_unique_fields; Type: INDEX; Schema: health; Owner: -
--

CREATE UNIQUE INDEX candidate_roles_unique_fields ON health.candidate_roles USING btree (email, roles, organization_id, product_id);


--
-- Name: classifications_products_idx; Type: INDEX; Schema: health; Owner: -
--

CREATE UNIQUE INDEX classifications_products_idx ON health.product_classifications USING btree (classification_id, product_id);


--
-- Name: countries_candidate_resources_idx; Type: INDEX; Schema: health; Owner: -
--

CREATE UNIQUE INDEX countries_candidate_resources_idx ON health.candidate_resources_countries USING btree (country_id, candidate_resource_id);


--
-- Name: countries_product_idx; Type: INDEX; Schema: health; Owner: -
--

CREATE UNIQUE INDEX countries_product_idx ON health.products_countries USING btree (country_id, product_id);


--
-- Name: dataset_sdg_index_on_sdg_id; Type: INDEX; Schema: health; Owner: -
--

CREATE INDEX dataset_sdg_index_on_sdg_id ON health.dataset_sustainable_development_goals USING btree (sustainable_development_goal_id);


--
-- Name: datasets_use_case_steps_idx; Type: INDEX; Schema: health; Owner: -
--

CREATE UNIQUE INDEX datasets_use_case_steps_idx ON health.use_case_steps_datasets USING btree (dataset_id, use_case_step_id);


--
-- Name: index_aggregator_capabilities_on_aggregator_id; Type: INDEX; Schema: health; Owner: -
--

CREATE INDEX index_aggregator_capabilities_on_aggregator_id ON health.aggregator_capabilities USING btree (aggregator_id);


--
-- Name: index_aggregator_capabilities_on_country_id; Type: INDEX; Schema: health; Owner: -
--

CREATE INDEX index_aggregator_capabilities_on_country_id ON health.aggregator_capabilities USING btree (country_id);


--
-- Name: index_aggregator_capabilities_on_operator_services_id; Type: INDEX; Schema: health; Owner: -
--

CREATE INDEX index_aggregator_capabilities_on_operator_services_id ON health.aggregator_capabilities USING btree (operator_services_id);


--
-- Name: index_audits_on_created_at; Type: INDEX; Schema: health; Owner: -
--

CREATE INDEX index_audits_on_created_at ON health.audits USING btree (created_at);


--
-- Name: index_building_block_descriptions_on_building_block_id; Type: INDEX; Schema: health; Owner: -
--

CREATE INDEX index_building_block_descriptions_on_building_block_id ON health.building_block_descriptions USING btree (building_block_id);


--
-- Name: index_building_blocks_on_slug; Type: INDEX; Schema: health; Owner: -
--

CREATE UNIQUE INDEX index_building_blocks_on_slug ON health.building_blocks USING btree (slug);


--
-- Name: index_candidate_contacts_on_candidate_id_and_contact_id; Type: INDEX; Schema: health; Owner: -
--

CREATE INDEX index_candidate_contacts_on_candidate_id_and_contact_id ON health.candidate_organizations_contacts USING btree (candidate_organization_id, contact_id);


--
-- Name: index_candidate_contacts_on_contact_id_and_candidate_id; Type: INDEX; Schema: health; Owner: -
--

CREATE INDEX index_candidate_contacts_on_contact_id_and_candidate_id ON health.candidate_organizations_contacts USING btree (contact_id, candidate_organization_id);


--
-- Name: index_candidate_datasets_on_approved_by_id; Type: INDEX; Schema: health; Owner: -
--

CREATE INDEX index_candidate_datasets_on_approved_by_id ON health.candidate_datasets USING btree (approved_by_id);


--
-- Name: index_candidate_datasets_on_rejected_by_id; Type: INDEX; Schema: health; Owner: -
--

CREATE INDEX index_candidate_datasets_on_rejected_by_id ON health.candidate_datasets USING btree (rejected_by_id);


--
-- Name: index_candidate_organizations_on_approved_by_id; Type: INDEX; Schema: health; Owner: -
--

CREATE INDEX index_candidate_organizations_on_approved_by_id ON health.candidate_organizations USING btree (approved_by_id);


--
-- Name: index_candidate_organizations_on_rejected_by_id; Type: INDEX; Schema: health; Owner: -
--

CREATE INDEX index_candidate_organizations_on_rejected_by_id ON health.candidate_organizations USING btree (rejected_by_id);


--
-- Name: index_candidate_products_on_approved_by_id; Type: INDEX; Schema: health; Owner: -
--

CREATE INDEX index_candidate_products_on_approved_by_id ON health.candidate_products USING btree (approved_by_id);


--
-- Name: index_candidate_products_on_rejected_by_id; Type: INDEX; Schema: health; Owner: -
--

CREATE INDEX index_candidate_products_on_rejected_by_id ON health.candidate_products USING btree (rejected_by_id);


--
-- Name: index_candidate_resources_on_approved_by_id; Type: INDEX; Schema: health; Owner: -
--

CREATE INDEX index_candidate_resources_on_approved_by_id ON health.candidate_resources USING btree (approved_by_id);


--
-- Name: index_candidate_resources_on_rejected_by_id; Type: INDEX; Schema: health; Owner: -
--

CREATE INDEX index_candidate_resources_on_rejected_by_id ON health.candidate_resources USING btree (rejected_by_id);


--
-- Name: index_candidate_roles_on_approved_by_id; Type: INDEX; Schema: health; Owner: -
--

CREATE INDEX index_candidate_roles_on_approved_by_id ON health.candidate_roles USING btree (approved_by_id);


--
-- Name: index_candidate_roles_on_dataset_id; Type: INDEX; Schema: health; Owner: -
--

CREATE INDEX index_candidate_roles_on_dataset_id ON health.candidate_roles USING btree (dataset_id);


--
-- Name: index_candidate_roles_on_rejected_by_id; Type: INDEX; Schema: health; Owner: -
--

CREATE INDEX index_candidate_roles_on_rejected_by_id ON health.candidate_roles USING btree (rejected_by_id);


--
-- Name: index_category_indicator_descriptions_on_category_indicator_id; Type: INDEX; Schema: health; Owner: -
--

CREATE INDEX index_category_indicator_descriptions_on_category_indicator_id ON health.category_indicator_descriptions USING btree (category_indicator_id);


--
-- Name: index_category_indicators_on_rubric_category_id; Type: INDEX; Schema: health; Owner: -
--

CREATE INDEX index_category_indicators_on_rubric_category_id ON health.category_indicators USING btree (rubric_category_id);


--
-- Name: index_chatbot_conversations_on_user_id; Type: INDEX; Schema: health; Owner: -
--

CREATE INDEX index_chatbot_conversations_on_user_id ON health.chatbot_conversations USING btree (user_id);


--
-- Name: index_cities_on_province_id; Type: INDEX; Schema: health; Owner: -
--

CREATE INDEX index_cities_on_province_id ON health.cities USING btree (province_id);


--
-- Name: index_ckeditor_assets_on_type; Type: INDEX; Schema: health; Owner: -
--

CREATE INDEX index_ckeditor_assets_on_type ON health.ckeditor_assets USING btree (type);


--
-- Name: index_contacts_on_slug; Type: INDEX; Schema: health; Owner: -
--

CREATE UNIQUE INDEX index_contacts_on_slug ON health.contacts USING btree (slug);


--
-- Name: index_dataset_descriptions_on_dataset_id; Type: INDEX; Schema: health; Owner: -
--

CREATE INDEX index_dataset_descriptions_on_dataset_id ON health.dataset_descriptions USING btree (dataset_id);


--
-- Name: index_dataset_sectors_on_dataset_id; Type: INDEX; Schema: health; Owner: -
--

CREATE INDEX index_dataset_sectors_on_dataset_id ON health.dataset_sectors USING btree (dataset_id);


--
-- Name: index_dataset_sectors_on_sector_id; Type: INDEX; Schema: health; Owner: -
--

CREATE INDEX index_dataset_sectors_on_sector_id ON health.dataset_sectors USING btree (sector_id);


--
-- Name: index_dataset_sustainable_development_goals_on_dataset_id; Type: INDEX; Schema: health; Owner: -
--

CREATE INDEX index_dataset_sustainable_development_goals_on_dataset_id ON health.dataset_sustainable_development_goals USING btree (dataset_id);


--
-- Name: index_datasets_countries_on_country_id; Type: INDEX; Schema: health; Owner: -
--

CREATE INDEX index_datasets_countries_on_country_id ON health.datasets_countries USING btree (country_id);


--
-- Name: index_datasets_countries_on_dataset_id; Type: INDEX; Schema: health; Owner: -
--

CREATE INDEX index_datasets_countries_on_dataset_id ON health.datasets_countries USING btree (dataset_id);


--
-- Name: index_datasets_origins_on_dataset_id; Type: INDEX; Schema: health; Owner: -
--

CREATE INDEX index_datasets_origins_on_dataset_id ON health.datasets_origins USING btree (dataset_id);


--
-- Name: index_datasets_origins_on_origin_id; Type: INDEX; Schema: health; Owner: -
--

CREATE INDEX index_datasets_origins_on_origin_id ON health.datasets_origins USING btree (origin_id);


--
-- Name: index_deploys_on_product_id; Type: INDEX; Schema: health; Owner: -
--

CREATE INDEX index_deploys_on_product_id ON health.deploys USING btree (product_id);


--
-- Name: index_deploys_on_user_id; Type: INDEX; Schema: health; Owner: -
--

CREATE INDEX index_deploys_on_user_id ON health.deploys USING btree (user_id);


--
-- Name: index_districts_on_province_id; Type: INDEX; Schema: health; Owner: -
--

CREATE INDEX index_districts_on_province_id ON health.districts USING btree (province_id);


--
-- Name: index_handbook_answers_on_handbook_question_id; Type: INDEX; Schema: health; Owner: -
--

CREATE INDEX index_handbook_answers_on_handbook_question_id ON health.handbook_answers USING btree (handbook_question_id);


--
-- Name: index_handbook_descriptions_on_handbook_id; Type: INDEX; Schema: health; Owner: -
--

CREATE INDEX index_handbook_descriptions_on_handbook_id ON health.handbook_descriptions USING btree (handbook_id);


--
-- Name: index_handbook_pages_on_handbook_id; Type: INDEX; Schema: health; Owner: -
--

CREATE INDEX index_handbook_pages_on_handbook_id ON health.handbook_pages USING btree (handbook_id);


--
-- Name: index_handbook_pages_on_handbook_questions_id; Type: INDEX; Schema: health; Owner: -
--

CREATE INDEX index_handbook_pages_on_handbook_questions_id ON health.handbook_pages USING btree (handbook_questions_id);


--
-- Name: index_handbook_pages_on_parent_page_id; Type: INDEX; Schema: health; Owner: -
--

CREATE INDEX index_handbook_pages_on_parent_page_id ON health.handbook_pages USING btree (parent_page_id);


--
-- Name: index_handbook_questions_on_handbook_page_id; Type: INDEX; Schema: health; Owner: -
--

CREATE INDEX index_handbook_questions_on_handbook_page_id ON health.handbook_questions USING btree (handbook_page_id);


--
-- Name: index_messages_on_created_by_id; Type: INDEX; Schema: health; Owner: -
--

CREATE INDEX index_messages_on_created_by_id ON health.messages USING btree (created_by_id);


--
-- Name: index_offices_on_country_id; Type: INDEX; Schema: health; Owner: -
--

CREATE INDEX index_offices_on_country_id ON health.offices USING btree (country_id);


--
-- Name: index_offices_on_organization_id; Type: INDEX; Schema: health; Owner: -
--

CREATE INDEX index_offices_on_organization_id ON health.offices USING btree (organization_id);


--
-- Name: index_offices_on_province_id; Type: INDEX; Schema: health; Owner: -
--

CREATE INDEX index_offices_on_province_id ON health.offices USING btree (province_id);


--
-- Name: index_operator_services_on_country_id; Type: INDEX; Schema: health; Owner: -
--

CREATE INDEX index_operator_services_on_country_id ON health.operator_services USING btree (country_id);


--
-- Name: index_opportunities_building_blocks_on_building_block_id; Type: INDEX; Schema: health; Owner: -
--

CREATE INDEX index_opportunities_building_blocks_on_building_block_id ON health.opportunities_building_blocks USING btree (building_block_id);


--
-- Name: index_opportunities_building_blocks_on_opportunity_id; Type: INDEX; Schema: health; Owner: -
--

CREATE INDEX index_opportunities_building_blocks_on_opportunity_id ON health.opportunities_building_blocks USING btree (opportunity_id);


--
-- Name: index_opportunities_countries_on_country_id; Type: INDEX; Schema: health; Owner: -
--

CREATE INDEX index_opportunities_countries_on_country_id ON health.opportunities_countries USING btree (country_id);


--
-- Name: index_opportunities_countries_on_opportunity_id; Type: INDEX; Schema: health; Owner: -
--

CREATE INDEX index_opportunities_countries_on_opportunity_id ON health.opportunities_countries USING btree (opportunity_id);


--
-- Name: index_opportunities_on_origin_id; Type: INDEX; Schema: health; Owner: -
--

CREATE INDEX index_opportunities_on_origin_id ON health.opportunities USING btree (origin_id);


--
-- Name: index_opportunities_organizations_on_opportunity_id; Type: INDEX; Schema: health; Owner: -
--

CREATE INDEX index_opportunities_organizations_on_opportunity_id ON health.opportunities_organizations USING btree (opportunity_id);


--
-- Name: index_opportunities_organizations_on_organization_id; Type: INDEX; Schema: health; Owner: -
--

CREATE INDEX index_opportunities_organizations_on_organization_id ON health.opportunities_organizations USING btree (organization_id);


--
-- Name: index_opportunities_sectors_on_opportunity_id; Type: INDEX; Schema: health; Owner: -
--

CREATE INDEX index_opportunities_sectors_on_opportunity_id ON health.opportunities_sectors USING btree (opportunity_id);


--
-- Name: index_opportunities_sectors_on_sector_id; Type: INDEX; Schema: health; Owner: -
--

CREATE INDEX index_opportunities_sectors_on_sector_id ON health.opportunities_sectors USING btree (sector_id);


--
-- Name: index_opportunities_use_cases_on_opportunity_id; Type: INDEX; Schema: health; Owner: -
--

CREATE INDEX index_opportunities_use_cases_on_opportunity_id ON health.opportunities_use_cases USING btree (opportunity_id);


--
-- Name: index_opportunities_use_cases_on_use_case_id; Type: INDEX; Schema: health; Owner: -
--

CREATE INDEX index_opportunities_use_cases_on_use_case_id ON health.opportunities_use_cases USING btree (use_case_id);


--
-- Name: index_organization_datasets_on_dataset_id; Type: INDEX; Schema: health; Owner: -
--

CREATE INDEX index_organization_datasets_on_dataset_id ON health.organization_datasets USING btree (dataset_id);


--
-- Name: index_organization_datasets_on_organization_id; Type: INDEX; Schema: health; Owner: -
--

CREATE INDEX index_organization_datasets_on_organization_id ON health.organization_datasets USING btree (organization_id);


--
-- Name: index_organization_descriptions_on_organization_id; Type: INDEX; Schema: health; Owner: -
--

CREATE INDEX index_organization_descriptions_on_organization_id ON health.organization_descriptions USING btree (organization_id);


--
-- Name: index_organization_products_on_organization_id_and_product_id; Type: INDEX; Schema: health; Owner: -
--

CREATE UNIQUE INDEX index_organization_products_on_organization_id_and_product_id ON health.organization_products USING btree (organization_id, product_id);


--
-- Name: index_organization_products_on_product_id_and_organization_id; Type: INDEX; Schema: health; Owner: -
--

CREATE UNIQUE INDEX index_organization_products_on_product_id_and_organization_id ON health.organization_products USING btree (product_id, organization_id);


--
-- Name: index_organizations_countries_on_country_id; Type: INDEX; Schema: health; Owner: -
--

CREATE INDEX index_organizations_countries_on_country_id ON health.organizations_countries USING btree (country_id);


--
-- Name: index_organizations_countries_on_organization_id; Type: INDEX; Schema: health; Owner: -
--

CREATE INDEX index_organizations_countries_on_organization_id ON health.organizations_countries USING btree (organization_id);


--
-- Name: index_organizations_on_slug; Type: INDEX; Schema: health; Owner: -
--

CREATE UNIQUE INDEX index_organizations_on_slug ON health.organizations USING btree (slug);


--
-- Name: index_origins_on_organization_id; Type: INDEX; Schema: health; Owner: -
--

CREATE INDEX index_origins_on_organization_id ON health.origins USING btree (organization_id);


--
-- Name: index_page_contents_on_handbook_page_id; Type: INDEX; Schema: health; Owner: -
--

CREATE INDEX index_page_contents_on_handbook_page_id ON health.page_contents USING btree (handbook_page_id);


--
-- Name: index_play_descriptions_on_play_id; Type: INDEX; Schema: health; Owner: -
--

CREATE INDEX index_play_descriptions_on_play_id ON health.play_descriptions USING btree (play_id);


--
-- Name: index_play_move_descriptions_on_play_move_id; Type: INDEX; Schema: health; Owner: -
--

CREATE INDEX index_play_move_descriptions_on_play_move_id ON health.play_move_descriptions USING btree (play_move_id);


--
-- Name: index_play_moves_on_play_id; Type: INDEX; Schema: health; Owner: -
--

CREATE INDEX index_play_moves_on_play_id ON health.play_moves USING btree (play_id);


--
-- Name: index_play_moves_resources; Type: INDEX; Schema: health; Owner: -
--

CREATE UNIQUE INDEX index_play_moves_resources ON health.play_moves_resources USING btree (play_move_id, resource_id);


--
-- Name: index_play_moves_resources_on_play_move_id; Type: INDEX; Schema: health; Owner: -
--

CREATE INDEX index_play_moves_resources_on_play_move_id ON health.play_moves_resources USING btree (play_move_id);


--
-- Name: index_play_moves_resources_on_resource_id; Type: INDEX; Schema: health; Owner: -
--

CREATE INDEX index_play_moves_resources_on_resource_id ON health.play_moves_resources USING btree (resource_id);


--
-- Name: index_playbook_descriptions_on_playbook_id; Type: INDEX; Schema: health; Owner: -
--

CREATE INDEX index_playbook_descriptions_on_playbook_id ON health.playbook_descriptions USING btree (playbook_id);


--
-- Name: index_playbook_plays_on_play_id; Type: INDEX; Schema: health; Owner: -
--

CREATE INDEX index_playbook_plays_on_play_id ON health.playbook_plays USING btree (play_id);


--
-- Name: index_playbook_plays_on_playbook_id; Type: INDEX; Schema: health; Owner: -
--

CREATE INDEX index_playbook_plays_on_playbook_id ON health.playbook_plays USING btree (playbook_id);


--
-- Name: index_plays_building_blocks_on_building_block_id; Type: INDEX; Schema: health; Owner: -
--

CREATE INDEX index_plays_building_blocks_on_building_block_id ON health.plays_building_blocks USING btree (building_block_id);


--
-- Name: index_plays_building_blocks_on_play_id; Type: INDEX; Schema: health; Owner: -
--

CREATE INDEX index_plays_building_blocks_on_play_id ON health.plays_building_blocks USING btree (play_id);


--
-- Name: index_plays_products_on_play_id; Type: INDEX; Schema: health; Owner: -
--

CREATE INDEX index_plays_products_on_play_id ON health.plays_products USING btree (play_id);


--
-- Name: index_plays_products_on_product_id; Type: INDEX; Schema: health; Owner: -
--

CREATE INDEX index_plays_products_on_product_id ON health.plays_products USING btree (product_id);


--
-- Name: index_principle_descriptions_on_digital_principle_id; Type: INDEX; Schema: health; Owner: -
--

CREATE INDEX index_principle_descriptions_on_digital_principle_id ON health.principle_descriptions USING btree (digital_principle_id);


--
-- Name: index_product_categories_on_product_id; Type: INDEX; Schema: health; Owner: -
--

CREATE INDEX index_product_categories_on_product_id ON health.product_categories USING btree (product_id);


--
-- Name: index_product_categories_on_software_category_id; Type: INDEX; Schema: health; Owner: -
--

CREATE INDEX index_product_categories_on_software_category_id ON health.product_categories USING btree (software_category_id);


--
-- Name: index_product_classifications_on_classification_id; Type: INDEX; Schema: health; Owner: -
--

CREATE INDEX index_product_classifications_on_classification_id ON health.product_classifications USING btree (classification_id);


--
-- Name: index_product_classifications_on_product_id; Type: INDEX; Schema: health; Owner: -
--

CREATE INDEX index_product_classifications_on_product_id ON health.product_classifications USING btree (product_id);


--
-- Name: index_product_descriptions_on_product_id; Type: INDEX; Schema: health; Owner: -
--

CREATE INDEX index_product_descriptions_on_product_id ON health.product_descriptions USING btree (product_id);


--
-- Name: index_product_features_on_product_id; Type: INDEX; Schema: health; Owner: -
--

CREATE INDEX index_product_features_on_product_id ON health.product_features USING btree (product_id);


--
-- Name: index_product_features_on_software_feature_id; Type: INDEX; Schema: health; Owner: -
--

CREATE INDEX index_product_features_on_software_feature_id ON health.product_features USING btree (software_feature_id);


--
-- Name: index_product_indicators_on_category_indicator_id; Type: INDEX; Schema: health; Owner: -
--

CREATE INDEX index_product_indicators_on_category_indicator_id ON health.product_indicators USING btree (category_indicator_id);


--
-- Name: index_product_indicators_on_product_id; Type: INDEX; Schema: health; Owner: -
--

CREATE INDEX index_product_indicators_on_product_id ON health.product_indicators USING btree (product_id);


--
-- Name: index_product_repositories_on_product_id; Type: INDEX; Schema: health; Owner: -
--

CREATE INDEX index_product_repositories_on_product_id ON health.product_repositories USING btree (product_id);


--
-- Name: index_product_sectors_on_product_id_and_sector_id; Type: INDEX; Schema: health; Owner: -
--

CREATE INDEX index_product_sectors_on_product_id_and_sector_id ON health.product_sectors USING btree (product_id, sector_id);


--
-- Name: index_product_sectors_on_sector_id_and_product_id; Type: INDEX; Schema: health; Owner: -
--

CREATE INDEX index_product_sectors_on_sector_id_and_product_id ON health.product_sectors USING btree (sector_id, product_id);


--
-- Name: index_products_endorsers_on_endorser_id; Type: INDEX; Schema: health; Owner: -
--

CREATE INDEX index_products_endorsers_on_endorser_id ON health.products_endorsers USING btree (endorser_id);


--
-- Name: index_products_endorsers_on_product_id; Type: INDEX; Schema: health; Owner: -
--

CREATE INDEX index_products_endorsers_on_product_id ON health.products_endorsers USING btree (product_id);


--
-- Name: index_products_on_slug; Type: INDEX; Schema: health; Owner: -
--

CREATE UNIQUE INDEX index_products_on_slug ON health.products USING btree (slug);


--
-- Name: index_products_resources_on_product_id; Type: INDEX; Schema: health; Owner: -
--

CREATE INDEX index_products_resources_on_product_id ON health.products_resources USING btree (product_id);


--
-- Name: index_products_resources_on_resource_id; Type: INDEX; Schema: health; Owner: -
--

CREATE INDEX index_products_resources_on_resource_id ON health.products_resources USING btree (resource_id);


--
-- Name: index_project_descriptions_on_project_id; Type: INDEX; Schema: health; Owner: -
--

CREATE INDEX index_project_descriptions_on_project_id ON health.project_descriptions USING btree (project_id);


--
-- Name: index_projects_countries_on_country_id; Type: INDEX; Schema: health; Owner: -
--

CREATE INDEX index_projects_countries_on_country_id ON health.projects_countries USING btree (country_id);


--
-- Name: index_projects_countries_on_project_id; Type: INDEX; Schema: health; Owner: -
--

CREATE INDEX index_projects_countries_on_project_id ON health.projects_countries USING btree (project_id);


--
-- Name: index_projects_digital_principles_on_digital_principle_id; Type: INDEX; Schema: health; Owner: -
--

CREATE INDEX index_projects_digital_principles_on_digital_principle_id ON health.projects_digital_principles USING btree (digital_principle_id);


--
-- Name: index_projects_digital_principles_on_project_id; Type: INDEX; Schema: health; Owner: -
--

CREATE INDEX index_projects_digital_principles_on_project_id ON health.projects_digital_principles USING btree (project_id);


--
-- Name: index_projects_on_origin_id; Type: INDEX; Schema: health; Owner: -
--

CREATE INDEX index_projects_on_origin_id ON health.projects USING btree (origin_id);


--
-- Name: index_provinces_on_country_id; Type: INDEX; Schema: health; Owner: -
--

CREATE INDEX index_provinces_on_country_id ON health.provinces USING btree (country_id);


--
-- Name: index_regions_countries; Type: INDEX; Schema: health; Owner: -
--

CREATE UNIQUE INDEX index_regions_countries ON health.regions_countries USING btree (region_id, country_id);


--
-- Name: index_regions_on_slug; Type: INDEX; Schema: health; Owner: -
--

CREATE UNIQUE INDEX index_regions_on_slug ON health.regions USING btree (slug);


--
-- Name: index_resource_building_blocks; Type: INDEX; Schema: health; Owner: -
--

CREATE UNIQUE INDEX index_resource_building_blocks ON health.resource_building_blocks USING btree (resource_id, building_block_id);


--
-- Name: index_resource_building_blocks_on_building_block_id; Type: INDEX; Schema: health; Owner: -
--

CREATE INDEX index_resource_building_blocks_on_building_block_id ON health.resource_building_blocks USING btree (building_block_id);


--
-- Name: index_resource_building_blocks_on_resource_id; Type: INDEX; Schema: health; Owner: -
--

CREATE INDEX index_resource_building_blocks_on_resource_id ON health.resource_building_blocks USING btree (resource_id);


--
-- Name: index_resource_topic_descriptions_on_resource_topic_id; Type: INDEX; Schema: health; Owner: -
--

CREATE INDEX index_resource_topic_descriptions_on_resource_topic_id ON health.resource_topic_descriptions USING btree (resource_topic_id);


--
-- Name: index_resource_topics_on_parent_topic_id; Type: INDEX; Schema: health; Owner: -
--

CREATE INDEX index_resource_topics_on_parent_topic_id ON health.resource_topics USING btree (parent_topic_id);


--
-- Name: index_resource_topics_on_slug; Type: INDEX; Schema: health; Owner: -
--

CREATE UNIQUE INDEX index_resource_topics_on_slug ON health.resource_topics USING btree (slug);


--
-- Name: index_resources_authors_on_author_id; Type: INDEX; Schema: health; Owner: -
--

CREATE INDEX index_resources_authors_on_author_id ON health.resources_authors USING btree (author_id);


--
-- Name: index_resources_authors_on_resource_id; Type: INDEX; Schema: health; Owner: -
--

CREATE INDEX index_resources_authors_on_resource_id ON health.resources_authors USING btree (resource_id);


--
-- Name: index_resources_countries_on_country_id; Type: INDEX; Schema: health; Owner: -
--

CREATE INDEX index_resources_countries_on_country_id ON health.resources_countries USING btree (country_id);


--
-- Name: index_resources_countries_on_resource_id; Type: INDEX; Schema: health; Owner: -
--

CREATE INDEX index_resources_countries_on_resource_id ON health.resources_countries USING btree (resource_id);


--
-- Name: index_resources_on_organization_id; Type: INDEX; Schema: health; Owner: -
--

CREATE INDEX index_resources_on_organization_id ON health.resources USING btree (organization_id);


--
-- Name: index_resources_on_submitted_by_id; Type: INDEX; Schema: health; Owner: -
--

CREATE INDEX index_resources_on_submitted_by_id ON health.resources USING btree (submitted_by_id);


--
-- Name: index_resources_use_cases; Type: INDEX; Schema: health; Owner: -
--

CREATE UNIQUE INDEX index_resources_use_cases ON health.resources_use_cases USING btree (resource_id, use_case_id);


--
-- Name: index_resources_use_cases_on_resource_id; Type: INDEX; Schema: health; Owner: -
--

CREATE INDEX index_resources_use_cases_on_resource_id ON health.resources_use_cases USING btree (resource_id);


--
-- Name: index_resources_use_cases_on_use_case_id; Type: INDEX; Schema: health; Owner: -
--

CREATE INDEX index_resources_use_cases_on_use_case_id ON health.resources_use_cases USING btree (use_case_id);


--
-- Name: index_rubric_category_descriptions_on_rubric_category_id; Type: INDEX; Schema: health; Owner: -
--

CREATE INDEX index_rubric_category_descriptions_on_rubric_category_id ON health.rubric_category_descriptions USING btree (rubric_category_id);


--
-- Name: index_sdgs_on_slug; Type: INDEX; Schema: health; Owner: -
--

CREATE UNIQUE INDEX index_sdgs_on_slug ON health.sustainable_development_goals USING btree (slug);


--
-- Name: index_sector_slug_unique; Type: INDEX; Schema: health; Owner: -
--

CREATE UNIQUE INDEX index_sector_slug_unique ON health.sectors USING btree (slug, origin_id, parent_sector_id, locale);


--
-- Name: index_sectors_on_origin_id; Type: INDEX; Schema: health; Owner: -
--

CREATE INDEX index_sectors_on_origin_id ON health.sectors USING btree (origin_id);


--
-- Name: index_sectors_on_parent_sector_id; Type: INDEX; Schema: health; Owner: -
--

CREATE INDEX index_sectors_on_parent_sector_id ON health.sectors USING btree (parent_sector_id);


--
-- Name: index_sessions_on_session_id; Type: INDEX; Schema: health; Owner: -
--

CREATE UNIQUE INDEX index_sessions_on_session_id ON health.sessions USING btree (session_id);


--
-- Name: index_sessions_on_updated_at; Type: INDEX; Schema: health; Owner: -
--

CREATE INDEX index_sessions_on_updated_at ON health.sessions USING btree (updated_at);


--
-- Name: index_software_features_on_software_category_id; Type: INDEX; Schema: health; Owner: -
--

CREATE INDEX index_software_features_on_software_category_id ON health.software_features USING btree (software_category_id);


--
-- Name: index_starred_object_record; Type: INDEX; Schema: health; Owner: -
--

CREATE UNIQUE INDEX index_starred_object_record ON health.starred_objects USING btree (starred_object_type, starred_object_value, source_object_type, source_object_value);


--
-- Name: index_starred_objects_on_starred_by_id; Type: INDEX; Schema: health; Owner: -
--

CREATE INDEX index_starred_objects_on_starred_by_id ON health.starred_objects USING btree (starred_by_id);


--
-- Name: index_tag_descriptions_on_tag_id; Type: INDEX; Schema: health; Owner: -
--

CREATE INDEX index_tag_descriptions_on_tag_id ON health.tag_descriptions USING btree (tag_id);


--
-- Name: index_task_tracker_descriptions_on_task_tracker_id; Type: INDEX; Schema: health; Owner: -
--

CREATE INDEX index_task_tracker_descriptions_on_task_tracker_id ON health.task_tracker_descriptions USING btree (task_tracker_id);


--
-- Name: index_use_case_descriptions_on_use_case_id; Type: INDEX; Schema: health; Owner: -
--

CREATE INDEX index_use_case_descriptions_on_use_case_id ON health.use_case_descriptions USING btree (use_case_id);


--
-- Name: index_use_case_headers_on_use_case_id; Type: INDEX; Schema: health; Owner: -
--

CREATE INDEX index_use_case_headers_on_use_case_id ON health.use_case_headers USING btree (use_case_id);


--
-- Name: index_use_case_step_descriptions_on_use_case_step_id; Type: INDEX; Schema: health; Owner: -
--

CREATE INDEX index_use_case_step_descriptions_on_use_case_step_id ON health.use_case_step_descriptions USING btree (use_case_step_id);


--
-- Name: index_use_case_steps_on_use_case_id; Type: INDEX; Schema: health; Owner: -
--

CREATE INDEX index_use_case_steps_on_use_case_id ON health.use_case_steps USING btree (use_case_id);


--
-- Name: index_use_cases_on_sector_id; Type: INDEX; Schema: health; Owner: -
--

CREATE INDEX index_use_cases_on_sector_id ON health.use_cases USING btree (sector_id);


--
-- Name: index_user_messages_on_message_id; Type: INDEX; Schema: health; Owner: -
--

CREATE INDEX index_user_messages_on_message_id ON health.user_messages USING btree (message_id);


--
-- Name: index_user_messages_on_received_by_id; Type: INDEX; Schema: health; Owner: -
--

CREATE INDEX index_user_messages_on_received_by_id ON health.user_messages USING btree (received_by_id);


--
-- Name: index_users_on_authentication_token; Type: INDEX; Schema: health; Owner: -
--

CREATE UNIQUE INDEX index_users_on_authentication_token ON health.users USING btree (authentication_token);


--
-- Name: index_users_on_confirmation_token; Type: INDEX; Schema: health; Owner: -
--

CREATE UNIQUE INDEX index_users_on_confirmation_token ON health.users USING btree (confirmation_token);


--
-- Name: index_users_on_email; Type: INDEX; Schema: health; Owner: -
--

CREATE UNIQUE INDEX index_users_on_email ON health.users USING btree (email);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: health; Owner: -
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON health.users USING btree (reset_password_token);


--
-- Name: index_workflow_descriptions_on_workflow_id; Type: INDEX; Schema: health; Owner: -
--

CREATE INDEX index_workflow_descriptions_on_workflow_id ON health.workflow_descriptions USING btree (workflow_id);


--
-- Name: opportunities_unique_slug; Type: INDEX; Schema: health; Owner: -
--

CREATE UNIQUE INDEX opportunities_unique_slug ON health.opportunities USING btree (slug);


--
-- Name: org_sectors; Type: INDEX; Schema: health; Owner: -
--

CREATE UNIQUE INDEX org_sectors ON health.organizations_sectors USING btree (organization_id, sector_id);


--
-- Name: organizations_projects_idx; Type: INDEX; Schema: health; Owner: -
--

CREATE UNIQUE INDEX organizations_projects_idx ON health.projects_organizations USING btree (organization_id, project_id);


--
-- Name: organizations_resources_idx; Type: INDEX; Schema: health; Owner: -
--

CREATE UNIQUE INDEX organizations_resources_idx ON health.organizations_resources USING btree (organization_id, resource_id);


--
-- Name: origins_products_idx; Type: INDEX; Schema: health; Owner: -
--

CREATE UNIQUE INDEX origins_products_idx ON health.products_origins USING btree (origin_id, product_id);


--
-- Name: play_rel_index; Type: INDEX; Schema: health; Owner: -
--

CREATE UNIQUE INDEX play_rel_index ON health.plays_subplays USING btree (parent_play_id, child_play_id);


--
-- Name: playbooks_sectors_idx; Type: INDEX; Schema: health; Owner: -
--

CREATE UNIQUE INDEX playbooks_sectors_idx ON health.playbooks_sectors USING btree (playbook_id, sector_id);


--
-- Name: plays_bbs_idx; Type: INDEX; Schema: health; Owner: -
--

CREATE UNIQUE INDEX plays_bbs_idx ON health.plays_building_blocks USING btree (play_id, building_block_id);


--
-- Name: plays_products_idx; Type: INDEX; Schema: health; Owner: -
--

CREATE UNIQUE INDEX plays_products_idx ON health.plays_products USING btree (play_id, product_id);


--
-- Name: prod_blocks; Type: INDEX; Schema: health; Owner: -
--

CREATE UNIQUE INDEX prod_blocks ON health.product_building_blocks USING btree (product_id, building_block_id);


--
-- Name: prod_sdgs; Type: INDEX; Schema: health; Owner: -
--

CREATE UNIQUE INDEX prod_sdgs ON health.product_sustainable_development_goals USING btree (product_id, sustainable_development_goal_id);


--
-- Name: product_countries_idx; Type: INDEX; Schema: health; Owner: -
--

CREATE UNIQUE INDEX product_countries_idx ON health.products_countries USING btree (product_id, country_id);


--
-- Name: product_rel_index; Type: INDEX; Schema: health; Owner: -
--

CREATE UNIQUE INDEX product_rel_index ON health.product_product_relationships USING btree (from_product_id, to_product_id);


--
-- Name: products_classifications_idx; Type: INDEX; Schema: health; Owner: -
--

CREATE UNIQUE INDEX products_classifications_idx ON health.product_classifications USING btree (product_id, classification_id);


--
-- Name: products_origins_idx; Type: INDEX; Schema: health; Owner: -
--

CREATE UNIQUE INDEX products_origins_idx ON health.products_origins USING btree (product_id, origin_id);


--
-- Name: products_plays_idx; Type: INDEX; Schema: health; Owner: -
--

CREATE UNIQUE INDEX products_plays_idx ON health.plays_products USING btree (product_id, play_id);


--
-- Name: products_projects_idx; Type: INDEX; Schema: health; Owner: -
--

CREATE UNIQUE INDEX products_projects_idx ON health.projects_products USING btree (product_id, project_id);


--
-- Name: products_use_case_steps_idx; Type: INDEX; Schema: health; Owner: -
--

CREATE UNIQUE INDEX products_use_case_steps_idx ON health.use_case_steps_products USING btree (product_id, use_case_step_id);


--
-- Name: projects_organizations_idx; Type: INDEX; Schema: health; Owner: -
--

CREATE UNIQUE INDEX projects_organizations_idx ON health.projects_organizations USING btree (project_id, organization_id);


--
-- Name: projects_products_idx; Type: INDEX; Schema: health; Owner: -
--

CREATE UNIQUE INDEX projects_products_idx ON health.projects_products USING btree (project_id, product_id);


--
-- Name: projects_sdgs_idx; Type: INDEX; Schema: health; Owner: -
--

CREATE UNIQUE INDEX projects_sdgs_idx ON health.projects_sdgs USING btree (project_id, sdg_id);


--
-- Name: projects_sectors_idx; Type: INDEX; Schema: health; Owner: -
--

CREATE UNIQUE INDEX projects_sectors_idx ON health.projects_sectors USING btree (project_id, sector_id);


--
-- Name: resources_organizations_idx; Type: INDEX; Schema: health; Owner: -
--

CREATE UNIQUE INDEX resources_organizations_idx ON health.organizations_resources USING btree (resource_id, organization_id);


--
-- Name: sdgs_prods; Type: INDEX; Schema: health; Owner: -
--

CREATE UNIQUE INDEX sdgs_prods ON health.product_sustainable_development_goals USING btree (sustainable_development_goal_id, product_id);


--
-- Name: sdgs_projects_idx; Type: INDEX; Schema: health; Owner: -
--

CREATE UNIQUE INDEX sdgs_projects_idx ON health.projects_sdgs USING btree (sdg_id, project_id);


--
-- Name: sdgs_usecases; Type: INDEX; Schema: health; Owner: -
--

CREATE UNIQUE INDEX sdgs_usecases ON health.use_cases_sdg_targets USING btree (sdg_target_id, use_case_id);


--
-- Name: sector_orcs; Type: INDEX; Schema: health; Owner: -
--

CREATE UNIQUE INDEX sector_orcs ON health.organizations_sectors USING btree (sector_id, organization_id);


--
-- Name: sectors_playbooks_idx; Type: INDEX; Schema: health; Owner: -
--

CREATE UNIQUE INDEX sectors_playbooks_idx ON health.playbooks_sectors USING btree (sector_id, playbook_id);


--
-- Name: sectors_projects_idx; Type: INDEX; Schema: health; Owner: -
--

CREATE UNIQUE INDEX sectors_projects_idx ON health.projects_sectors USING btree (sector_id, project_id);


--
-- Name: unique_on_resource_topic_id_and_locale; Type: INDEX; Schema: health; Owner: -
--

CREATE UNIQUE INDEX unique_on_resource_topic_id_and_locale ON health.resource_topic_descriptions USING btree (resource_topic_id, locale);


--
-- Name: use_case_steps_building_blocks_idx; Type: INDEX; Schema: health; Owner: -
--

CREATE UNIQUE INDEX use_case_steps_building_blocks_idx ON health.use_case_steps_building_blocks USING btree (use_case_step_id, building_block_id);


--
-- Name: use_case_steps_datasets_idx; Type: INDEX; Schema: health; Owner: -
--

CREATE UNIQUE INDEX use_case_steps_datasets_idx ON health.use_case_steps_datasets USING btree (use_case_step_id, dataset_id);


--
-- Name: use_case_steps_products_idx; Type: INDEX; Schema: health; Owner: -
--

CREATE UNIQUE INDEX use_case_steps_products_idx ON health.use_case_steps_products USING btree (use_case_step_id, product_id);


--
-- Name: use_case_steps_workflows_idx; Type: INDEX; Schema: health; Owner: -
--

CREATE UNIQUE INDEX use_case_steps_workflows_idx ON health.use_case_steps_workflows USING btree (use_case_step_id, workflow_id);


--
-- Name: usecases_sdgs; Type: INDEX; Schema: health; Owner: -
--

CREATE UNIQUE INDEX usecases_sdgs ON health.use_cases_sdg_targets USING btree (use_case_id, sdg_target_id);


--
-- Name: usecases_workflows; Type: INDEX; Schema: health; Owner: -
--

CREATE UNIQUE INDEX usecases_workflows ON health.workflows_use_cases USING btree (use_case_id, workflow_id);


--
-- Name: user_index; Type: INDEX; Schema: health; Owner: -
--

CREATE INDEX user_index ON health.audits USING btree (user_id, user_role);


--
-- Name: workflows_bbs; Type: INDEX; Schema: health; Owner: -
--

CREATE UNIQUE INDEX workflows_bbs ON health.workflows_building_blocks USING btree (workflow_id, building_block_id);


--
-- Name: workflows_use_case_steps_idx; Type: INDEX; Schema: health; Owner: -
--

CREATE UNIQUE INDEX workflows_use_case_steps_idx ON health.use_case_steps_workflows USING btree (workflow_id, use_case_step_id);


--
-- Name: workflows_usecases; Type: INDEX; Schema: health; Owner: -
--

CREATE UNIQUE INDEX workflows_usecases ON health.workflows_use_cases USING btree (workflow_id, use_case_id);


--
-- Name: agg_cap_operator_capability_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX agg_cap_operator_capability_index ON public.aggregator_capabilities USING btree (aggregator_id, operator_services_id, capability);


--
-- Name: associated_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX associated_index ON public.audits USING btree (associated_type, associated_id);


--
-- Name: auditable_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX auditable_index ON public.audits USING btree (action, id, version);


--
-- Name: authors_unique_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX authors_unique_slug ON public.authors USING btree (slug);


--
-- Name: bbs_plays_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX bbs_plays_idx ON public.plays_building_blocks USING btree (building_block_id, play_id);


--
-- Name: bbs_workflows; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX bbs_workflows ON public.workflows_building_blocks USING btree (building_block_id, workflow_id);


--
-- Name: block_prods; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX block_prods ON public.product_building_blocks USING btree (building_block_id, product_id);


--
-- Name: building_blocks_use_case_steps_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX building_blocks_use_case_steps_idx ON public.use_case_steps_building_blocks USING btree (building_block_id, use_case_step_id);


--
-- Name: candidate_resources_countries_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX candidate_resources_countries_idx ON public.candidate_resources_countries USING btree (candidate_resource_id, country_id);


--
-- Name: candidate_roles_unique_fields; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX candidate_roles_unique_fields ON public.candidate_roles USING btree (email, roles, organization_id, product_id);


--
-- Name: classifications_products_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX classifications_products_idx ON public.product_classifications USING btree (classification_id, product_id);


--
-- Name: countries_candidate_resources_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX countries_candidate_resources_idx ON public.candidate_resources_countries USING btree (country_id, candidate_resource_id);


--
-- Name: countries_product_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX countries_product_idx ON public.products_countries USING btree (country_id, product_id);


--
-- Name: dataset_sdg_index_on_sdg_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX dataset_sdg_index_on_sdg_id ON public.dataset_sustainable_development_goals USING btree (sustainable_development_goal_id);


--
-- Name: datasets_use_case_steps_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX datasets_use_case_steps_idx ON public.use_case_steps_datasets USING btree (dataset_id, use_case_step_id);


--
-- Name: index_aggregator_capabilities_on_aggregator_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_aggregator_capabilities_on_aggregator_id ON public.aggregator_capabilities USING btree (aggregator_id);


--
-- Name: index_aggregator_capabilities_on_country_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_aggregator_capabilities_on_country_id ON public.aggregator_capabilities USING btree (country_id);


--
-- Name: index_aggregator_capabilities_on_operator_services_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_aggregator_capabilities_on_operator_services_id ON public.aggregator_capabilities USING btree (operator_services_id);


--
-- Name: index_audits_on_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_audits_on_created_at ON public.audits USING btree (created_at);


--
-- Name: index_building_block_descriptions_on_building_block_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_building_block_descriptions_on_building_block_id ON public.building_block_descriptions USING btree (building_block_id);


--
-- Name: index_building_blocks_on_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_building_blocks_on_slug ON public.building_blocks USING btree (slug);


--
-- Name: index_candidate_contacts_on_candidate_id_and_contact_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_candidate_contacts_on_candidate_id_and_contact_id ON public.candidate_organizations_contacts USING btree (candidate_organization_id, contact_id);


--
-- Name: index_candidate_contacts_on_contact_id_and_candidate_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_candidate_contacts_on_contact_id_and_candidate_id ON public.candidate_organizations_contacts USING btree (contact_id, candidate_organization_id);


--
-- Name: index_candidate_datasets_on_approved_by_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_candidate_datasets_on_approved_by_id ON public.candidate_datasets USING btree (approved_by_id);


--
-- Name: index_candidate_datasets_on_rejected_by_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_candidate_datasets_on_rejected_by_id ON public.candidate_datasets USING btree (rejected_by_id);


--
-- Name: index_candidate_organizations_on_approved_by_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_candidate_organizations_on_approved_by_id ON public.candidate_organizations USING btree (approved_by_id);


--
-- Name: index_candidate_organizations_on_rejected_by_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_candidate_organizations_on_rejected_by_id ON public.candidate_organizations USING btree (rejected_by_id);


--
-- Name: index_candidate_products_on_approved_by_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_candidate_products_on_approved_by_id ON public.candidate_products USING btree (approved_by_id);


--
-- Name: index_candidate_products_on_rejected_by_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_candidate_products_on_rejected_by_id ON public.candidate_products USING btree (rejected_by_id);


--
-- Name: index_candidate_resources_on_approved_by_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_candidate_resources_on_approved_by_id ON public.candidate_resources USING btree (approved_by_id);


--
-- Name: index_candidate_resources_on_rejected_by_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_candidate_resources_on_rejected_by_id ON public.candidate_resources USING btree (rejected_by_id);


--
-- Name: index_candidate_roles_on_approved_by_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_candidate_roles_on_approved_by_id ON public.candidate_roles USING btree (approved_by_id);


--
-- Name: index_candidate_roles_on_dataset_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_candidate_roles_on_dataset_id ON public.candidate_roles USING btree (dataset_id);


--
-- Name: index_candidate_roles_on_rejected_by_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_candidate_roles_on_rejected_by_id ON public.candidate_roles USING btree (rejected_by_id);


--
-- Name: index_category_indicator_descriptions_on_category_indicator_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_category_indicator_descriptions_on_category_indicator_id ON public.category_indicator_descriptions USING btree (category_indicator_id);


--
-- Name: index_category_indicators_on_rubric_category_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_category_indicators_on_rubric_category_id ON public.category_indicators USING btree (rubric_category_id);


--
-- Name: index_chatbot_conversations_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_chatbot_conversations_on_user_id ON public.chatbot_conversations USING btree (user_id);


--
-- Name: index_cities_on_province_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_cities_on_province_id ON public.cities USING btree (province_id);


--
-- Name: index_ckeditor_assets_on_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ckeditor_assets_on_type ON public.ckeditor_assets USING btree (type);


--
-- Name: index_contacts_on_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_contacts_on_slug ON public.contacts USING btree (slug);


--
-- Name: index_dataset_descriptions_on_dataset_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_dataset_descriptions_on_dataset_id ON public.dataset_descriptions USING btree (dataset_id);


--
-- Name: index_dataset_sectors_on_dataset_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_dataset_sectors_on_dataset_id ON public.dataset_sectors USING btree (dataset_id);


--
-- Name: index_dataset_sectors_on_sector_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_dataset_sectors_on_sector_id ON public.dataset_sectors USING btree (sector_id);


--
-- Name: index_dataset_sustainable_development_goals_on_dataset_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_dataset_sustainable_development_goals_on_dataset_id ON public.dataset_sustainable_development_goals USING btree (dataset_id);


--
-- Name: index_datasets_countries_on_country_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_datasets_countries_on_country_id ON public.datasets_countries USING btree (country_id);


--
-- Name: index_datasets_countries_on_dataset_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_datasets_countries_on_dataset_id ON public.datasets_countries USING btree (dataset_id);


--
-- Name: index_datasets_origins_on_dataset_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_datasets_origins_on_dataset_id ON public.datasets_origins USING btree (dataset_id);


--
-- Name: index_datasets_origins_on_origin_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_datasets_origins_on_origin_id ON public.datasets_origins USING btree (origin_id);


--
-- Name: index_deploys_on_product_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_deploys_on_product_id ON public.deploys USING btree (product_id);


--
-- Name: index_deploys_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_deploys_on_user_id ON public.deploys USING btree (user_id);


--
-- Name: index_districts_on_province_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_districts_on_province_id ON public.districts USING btree (province_id);


--
-- Name: index_handbook_answers_on_handbook_question_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_handbook_answers_on_handbook_question_id ON public.handbook_answers USING btree (handbook_question_id);


--
-- Name: index_handbook_descriptions_on_handbook_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_handbook_descriptions_on_handbook_id ON public.handbook_descriptions USING btree (handbook_id);


--
-- Name: index_handbook_pages_on_handbook_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_handbook_pages_on_handbook_id ON public.handbook_pages USING btree (handbook_id);


--
-- Name: index_handbook_pages_on_handbook_questions_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_handbook_pages_on_handbook_questions_id ON public.handbook_pages USING btree (handbook_questions_id);


--
-- Name: index_handbook_pages_on_parent_page_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_handbook_pages_on_parent_page_id ON public.handbook_pages USING btree (parent_page_id);


--
-- Name: index_handbook_questions_on_handbook_page_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_handbook_questions_on_handbook_page_id ON public.handbook_questions USING btree (handbook_page_id);


--
-- Name: index_messages_on_created_by_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_messages_on_created_by_id ON public.messages USING btree (created_by_id);


--
-- Name: index_offices_on_country_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_offices_on_country_id ON public.offices USING btree (country_id);


--
-- Name: index_offices_on_organization_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_offices_on_organization_id ON public.offices USING btree (organization_id);


--
-- Name: index_offices_on_province_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_offices_on_province_id ON public.offices USING btree (province_id);


--
-- Name: index_operator_services_on_country_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_operator_services_on_country_id ON public.operator_services USING btree (country_id);


--
-- Name: index_opportunities_building_blocks_on_building_block_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_opportunities_building_blocks_on_building_block_id ON public.opportunities_building_blocks USING btree (building_block_id);


--
-- Name: index_opportunities_building_blocks_on_opportunity_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_opportunities_building_blocks_on_opportunity_id ON public.opportunities_building_blocks USING btree (opportunity_id);


--
-- Name: index_opportunities_countries_on_country_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_opportunities_countries_on_country_id ON public.opportunities_countries USING btree (country_id);


--
-- Name: index_opportunities_countries_on_opportunity_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_opportunities_countries_on_opportunity_id ON public.opportunities_countries USING btree (opportunity_id);


--
-- Name: index_opportunities_on_origin_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_opportunities_on_origin_id ON public.opportunities USING btree (origin_id);


--
-- Name: index_opportunities_organizations_on_opportunity_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_opportunities_organizations_on_opportunity_id ON public.opportunities_organizations USING btree (opportunity_id);


--
-- Name: index_opportunities_organizations_on_organization_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_opportunities_organizations_on_organization_id ON public.opportunities_organizations USING btree (organization_id);


--
-- Name: index_opportunities_sectors_on_opportunity_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_opportunities_sectors_on_opportunity_id ON public.opportunities_sectors USING btree (opportunity_id);


--
-- Name: index_opportunities_sectors_on_sector_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_opportunities_sectors_on_sector_id ON public.opportunities_sectors USING btree (sector_id);


--
-- Name: index_opportunities_use_cases_on_opportunity_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_opportunities_use_cases_on_opportunity_id ON public.opportunities_use_cases USING btree (opportunity_id);


--
-- Name: index_opportunities_use_cases_on_use_case_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_opportunities_use_cases_on_use_case_id ON public.opportunities_use_cases USING btree (use_case_id);


--
-- Name: index_organization_datasets_on_dataset_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_organization_datasets_on_dataset_id ON public.organization_datasets USING btree (dataset_id);


--
-- Name: index_organization_datasets_on_organization_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_organization_datasets_on_organization_id ON public.organization_datasets USING btree (organization_id);


--
-- Name: index_organization_descriptions_on_organization_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_organization_descriptions_on_organization_id ON public.organization_descriptions USING btree (organization_id);


--
-- Name: index_organization_products_on_organization_id_and_product_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_organization_products_on_organization_id_and_product_id ON public.organization_products USING btree (organization_id, product_id);


--
-- Name: index_organization_products_on_product_id_and_organization_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_organization_products_on_product_id_and_organization_id ON public.organization_products USING btree (product_id, organization_id);


--
-- Name: index_organizations_countries_on_country_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_organizations_countries_on_country_id ON public.organizations_countries USING btree (country_id);


--
-- Name: index_organizations_countries_on_organization_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_organizations_countries_on_organization_id ON public.organizations_countries USING btree (organization_id);


--
-- Name: index_organizations_on_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_organizations_on_slug ON public.organizations USING btree (slug);


--
-- Name: index_origins_on_organization_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_origins_on_organization_id ON public.origins USING btree (organization_id);


--
-- Name: index_page_contents_on_handbook_page_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_page_contents_on_handbook_page_id ON public.page_contents USING btree (handbook_page_id);


--
-- Name: index_play_descriptions_on_play_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_play_descriptions_on_play_id ON public.play_descriptions USING btree (play_id);


--
-- Name: index_play_move_descriptions_on_play_move_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_play_move_descriptions_on_play_move_id ON public.play_move_descriptions USING btree (play_move_id);


--
-- Name: index_play_moves_on_play_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_play_moves_on_play_id ON public.play_moves USING btree (play_id);


--
-- Name: index_play_moves_resources; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_play_moves_resources ON public.play_moves_resources USING btree (play_move_id, resource_id);


--
-- Name: index_play_moves_resources_on_play_move_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_play_moves_resources_on_play_move_id ON public.play_moves_resources USING btree (play_move_id);


--
-- Name: index_play_moves_resources_on_resource_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_play_moves_resources_on_resource_id ON public.play_moves_resources USING btree (resource_id);


--
-- Name: index_playbook_descriptions_on_playbook_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_playbook_descriptions_on_playbook_id ON public.playbook_descriptions USING btree (playbook_id);


--
-- Name: index_playbook_plays_on_play_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_playbook_plays_on_play_id ON public.playbook_plays USING btree (play_id);


--
-- Name: index_playbook_plays_on_playbook_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_playbook_plays_on_playbook_id ON public.playbook_plays USING btree (playbook_id);


--
-- Name: index_plays_building_blocks_on_building_block_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_plays_building_blocks_on_building_block_id ON public.plays_building_blocks USING btree (building_block_id);


--
-- Name: index_plays_building_blocks_on_play_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_plays_building_blocks_on_play_id ON public.plays_building_blocks USING btree (play_id);


--
-- Name: index_plays_products_on_play_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_plays_products_on_play_id ON public.plays_products USING btree (play_id);


--
-- Name: index_plays_products_on_product_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_plays_products_on_product_id ON public.plays_products USING btree (product_id);


--
-- Name: index_principle_descriptions_on_digital_principle_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_principle_descriptions_on_digital_principle_id ON public.principle_descriptions USING btree (digital_principle_id);


--
-- Name: index_product_categories_on_product_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_product_categories_on_product_id ON public.product_categories USING btree (product_id);


--
-- Name: index_product_categories_on_software_category_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_product_categories_on_software_category_id ON public.product_categories USING btree (software_category_id);


--
-- Name: index_product_classifications_on_classification_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_product_classifications_on_classification_id ON public.product_classifications USING btree (classification_id);


--
-- Name: index_product_classifications_on_product_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_product_classifications_on_product_id ON public.product_classifications USING btree (product_id);


--
-- Name: index_product_descriptions_on_product_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_product_descriptions_on_product_id ON public.product_descriptions USING btree (product_id);


--
-- Name: index_product_features_on_product_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_product_features_on_product_id ON public.product_features USING btree (product_id);


--
-- Name: index_product_features_on_software_feature_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_product_features_on_software_feature_id ON public.product_features USING btree (software_feature_id);


--
-- Name: index_product_indicators_on_category_indicator_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_product_indicators_on_category_indicator_id ON public.product_indicators USING btree (category_indicator_id);


--
-- Name: index_product_indicators_on_product_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_product_indicators_on_product_id ON public.product_indicators USING btree (product_id);


--
-- Name: index_product_repositories_on_product_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_product_repositories_on_product_id ON public.product_repositories USING btree (product_id);


--
-- Name: index_product_sectors_on_product_id_and_sector_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_product_sectors_on_product_id_and_sector_id ON public.product_sectors USING btree (product_id, sector_id);


--
-- Name: index_product_sectors_on_sector_id_and_product_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_product_sectors_on_sector_id_and_product_id ON public.product_sectors USING btree (sector_id, product_id);


--
-- Name: index_products_endorsers_on_endorser_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_products_endorsers_on_endorser_id ON public.products_endorsers USING btree (endorser_id);


--
-- Name: index_products_endorsers_on_product_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_products_endorsers_on_product_id ON public.products_endorsers USING btree (product_id);


--
-- Name: index_products_on_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_products_on_slug ON public.products USING btree (slug);


--
-- Name: index_products_resources_on_product_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_products_resources_on_product_id ON public.products_resources USING btree (product_id);


--
-- Name: index_products_resources_on_resource_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_products_resources_on_resource_id ON public.products_resources USING btree (resource_id);


--
-- Name: index_project_descriptions_on_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_project_descriptions_on_project_id ON public.project_descriptions USING btree (project_id);


--
-- Name: index_projects_countries_on_country_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_projects_countries_on_country_id ON public.projects_countries USING btree (country_id);


--
-- Name: index_projects_countries_on_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_projects_countries_on_project_id ON public.projects_countries USING btree (project_id);


--
-- Name: index_projects_digital_principles_on_digital_principle_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_projects_digital_principles_on_digital_principle_id ON public.projects_digital_principles USING btree (digital_principle_id);


--
-- Name: index_projects_digital_principles_on_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_projects_digital_principles_on_project_id ON public.projects_digital_principles USING btree (project_id);


--
-- Name: index_projects_on_origin_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_projects_on_origin_id ON public.projects USING btree (origin_id);


--
-- Name: index_provinces_on_country_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_provinces_on_country_id ON public.provinces USING btree (country_id);


--
-- Name: index_regions_countries; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_regions_countries ON public.regions_countries USING btree (region_id, country_id);


--
-- Name: index_regions_on_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_regions_on_slug ON public.regions USING btree (slug);


--
-- Name: index_resource_building_blocks; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_resource_building_blocks ON public.resource_building_blocks USING btree (resource_id, building_block_id);


--
-- Name: index_resource_building_blocks_on_building_block_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_resource_building_blocks_on_building_block_id ON public.resource_building_blocks USING btree (building_block_id);


--
-- Name: index_resource_building_blocks_on_resource_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_resource_building_blocks_on_resource_id ON public.resource_building_blocks USING btree (resource_id);


--
-- Name: index_resource_topic_descriptions_on_resource_topic_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_resource_topic_descriptions_on_resource_topic_id ON public.resource_topic_descriptions USING btree (resource_topic_id);


--
-- Name: index_resource_topics_on_parent_topic_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_resource_topics_on_parent_topic_id ON public.resource_topics USING btree (parent_topic_id);


--
-- Name: index_resource_topics_on_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_resource_topics_on_slug ON public.resource_topics USING btree (slug);


--
-- Name: index_resources_authors_on_author_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_resources_authors_on_author_id ON public.resources_authors USING btree (author_id);


--
-- Name: index_resources_authors_on_resource_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_resources_authors_on_resource_id ON public.resources_authors USING btree (resource_id);


--
-- Name: index_resources_countries_on_country_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_resources_countries_on_country_id ON public.resources_countries USING btree (country_id);


--
-- Name: index_resources_countries_on_resource_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_resources_countries_on_resource_id ON public.resources_countries USING btree (resource_id);


--
-- Name: index_resources_on_organization_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_resources_on_organization_id ON public.resources USING btree (organization_id);


--
-- Name: index_resources_on_submitted_by_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_resources_on_submitted_by_id ON public.resources USING btree (submitted_by_id);


--
-- Name: index_resources_use_cases; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_resources_use_cases ON public.resources_use_cases USING btree (resource_id, use_case_id);


--
-- Name: index_resources_use_cases_on_resource_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_resources_use_cases_on_resource_id ON public.resources_use_cases USING btree (resource_id);


--
-- Name: index_resources_use_cases_on_use_case_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_resources_use_cases_on_use_case_id ON public.resources_use_cases USING btree (use_case_id);


--
-- Name: index_rubric_category_descriptions_on_rubric_category_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_rubric_category_descriptions_on_rubric_category_id ON public.rubric_category_descriptions USING btree (rubric_category_id);


--
-- Name: index_sdgs_on_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_sdgs_on_slug ON public.sustainable_development_goals USING btree (slug);


--
-- Name: index_sector_slug_unique; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_sector_slug_unique ON public.sectors USING btree (slug, origin_id, parent_sector_id, locale);


--
-- Name: index_sectors_on_origin_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_sectors_on_origin_id ON public.sectors USING btree (origin_id);


--
-- Name: index_sectors_on_parent_sector_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_sectors_on_parent_sector_id ON public.sectors USING btree (parent_sector_id);


--
-- Name: index_sessions_on_session_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_sessions_on_session_id ON public.sessions USING btree (session_id);


--
-- Name: index_sessions_on_updated_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_sessions_on_updated_at ON public.sessions USING btree (updated_at);


--
-- Name: index_software_features_on_software_category_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_software_features_on_software_category_id ON public.software_features USING btree (software_category_id);


--
-- Name: index_starred_object_record; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_starred_object_record ON public.starred_objects USING btree (starred_object_type, starred_object_value, source_object_type, source_object_value);


--
-- Name: index_starred_objects_on_starred_by_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_starred_objects_on_starred_by_id ON public.starred_objects USING btree (starred_by_id);


--
-- Name: index_tag_descriptions_on_tag_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_tag_descriptions_on_tag_id ON public.tag_descriptions USING btree (tag_id);


--
-- Name: index_task_tracker_descriptions_on_task_tracker_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_task_tracker_descriptions_on_task_tracker_id ON public.task_tracker_descriptions USING btree (task_tracker_id);


--
-- Name: index_use_case_descriptions_on_use_case_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_use_case_descriptions_on_use_case_id ON public.use_case_descriptions USING btree (use_case_id);


--
-- Name: index_use_case_headers_on_use_case_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_use_case_headers_on_use_case_id ON public.use_case_headers USING btree (use_case_id);


--
-- Name: index_use_case_step_descriptions_on_use_case_step_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_use_case_step_descriptions_on_use_case_step_id ON public.use_case_step_descriptions USING btree (use_case_step_id);


--
-- Name: index_use_case_steps_on_use_case_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_use_case_steps_on_use_case_id ON public.use_case_steps USING btree (use_case_id);


--
-- Name: index_use_cases_on_sector_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_use_cases_on_sector_id ON public.use_cases USING btree (sector_id);


--
-- Name: index_user_messages_on_message_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_user_messages_on_message_id ON public.user_messages USING btree (message_id);


--
-- Name: index_user_messages_on_received_by_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_user_messages_on_received_by_id ON public.user_messages USING btree (received_by_id);


--
-- Name: index_users_on_authentication_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_authentication_token ON public.users USING btree (authentication_token);


--
-- Name: index_users_on_confirmation_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_confirmation_token ON public.users USING btree (confirmation_token);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_email ON public.users USING btree (email);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON public.users USING btree (reset_password_token);


--
-- Name: index_workflow_descriptions_on_workflow_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_workflow_descriptions_on_workflow_id ON public.workflow_descriptions USING btree (workflow_id);


--
-- Name: opportunities_unique_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX opportunities_unique_slug ON public.opportunities USING btree (slug);


--
-- Name: org_sectors; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX org_sectors ON public.organizations_sectors USING btree (organization_id, sector_id);


--
-- Name: organizations_projects_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX organizations_projects_idx ON public.projects_organizations USING btree (organization_id, project_id);


--
-- Name: organizations_resources_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX organizations_resources_idx ON public.organizations_resources USING btree (organization_id, resource_id);


--
-- Name: origins_products_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX origins_products_idx ON public.products_origins USING btree (origin_id, product_id);


--
-- Name: play_rel_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX play_rel_index ON public.plays_subplays USING btree (parent_play_id, child_play_id);


--
-- Name: playbooks_sectors_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX playbooks_sectors_idx ON public.playbooks_sectors USING btree (playbook_id, sector_id);


--
-- Name: plays_bbs_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX plays_bbs_idx ON public.plays_building_blocks USING btree (play_id, building_block_id);


--
-- Name: plays_products_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX plays_products_idx ON public.plays_products USING btree (play_id, product_id);


--
-- Name: prod_blocks; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX prod_blocks ON public.product_building_blocks USING btree (product_id, building_block_id);


--
-- Name: prod_sdgs; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX prod_sdgs ON public.product_sustainable_development_goals USING btree (product_id, sustainable_development_goal_id);


--
-- Name: product_countries_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX product_countries_idx ON public.products_countries USING btree (product_id, country_id);


--
-- Name: product_rel_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX product_rel_index ON public.product_product_relationships USING btree (from_product_id, to_product_id);


--
-- Name: products_classifications_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX products_classifications_idx ON public.product_classifications USING btree (product_id, classification_id);


--
-- Name: products_origins_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX products_origins_idx ON public.products_origins USING btree (product_id, origin_id);


--
-- Name: products_plays_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX products_plays_idx ON public.plays_products USING btree (product_id, play_id);


--
-- Name: products_projects_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX products_projects_idx ON public.projects_products USING btree (product_id, project_id);


--
-- Name: products_use_case_steps_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX products_use_case_steps_idx ON public.use_case_steps_products USING btree (product_id, use_case_step_id);


--
-- Name: projects_organizations_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX projects_organizations_idx ON public.projects_organizations USING btree (project_id, organization_id);


--
-- Name: projects_products_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX projects_products_idx ON public.projects_products USING btree (project_id, product_id);


--
-- Name: projects_sdgs_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX projects_sdgs_idx ON public.projects_sdgs USING btree (project_id, sdg_id);


--
-- Name: projects_sectors_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX projects_sectors_idx ON public.projects_sectors USING btree (project_id, sector_id);


--
-- Name: resources_organizations_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX resources_organizations_idx ON public.organizations_resources USING btree (resource_id, organization_id);


--
-- Name: sdgs_prods; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX sdgs_prods ON public.product_sustainable_development_goals USING btree (sustainable_development_goal_id, product_id);


--
-- Name: sdgs_projects_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX sdgs_projects_idx ON public.projects_sdgs USING btree (sdg_id, project_id);


--
-- Name: sdgs_usecases; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX sdgs_usecases ON public.use_cases_sdg_targets USING btree (sdg_target_id, use_case_id);


--
-- Name: sector_orcs; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX sector_orcs ON public.organizations_sectors USING btree (sector_id, organization_id);


--
-- Name: sectors_playbooks_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX sectors_playbooks_idx ON public.playbooks_sectors USING btree (sector_id, playbook_id);


--
-- Name: sectors_projects_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX sectors_projects_idx ON public.projects_sectors USING btree (sector_id, project_id);


--
-- Name: unique_on_resource_topic_id_and_locale; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX unique_on_resource_topic_id_and_locale ON public.resource_topic_descriptions USING btree (resource_topic_id, locale);


--
-- Name: use_case_steps_building_blocks_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX use_case_steps_building_blocks_idx ON public.use_case_steps_building_blocks USING btree (use_case_step_id, building_block_id);


--
-- Name: use_case_steps_datasets_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX use_case_steps_datasets_idx ON public.use_case_steps_datasets USING btree (use_case_step_id, dataset_id);


--
-- Name: use_case_steps_products_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX use_case_steps_products_idx ON public.use_case_steps_products USING btree (use_case_step_id, product_id);


--
-- Name: use_case_steps_workflows_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX use_case_steps_workflows_idx ON public.use_case_steps_workflows USING btree (use_case_step_id, workflow_id);


--
-- Name: usecases_sdgs; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX usecases_sdgs ON public.use_cases_sdg_targets USING btree (use_case_id, sdg_target_id);


--
-- Name: usecases_workflows; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX usecases_workflows ON public.workflows_use_cases USING btree (use_case_id, workflow_id);


--
-- Name: user_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX user_index ON public.audits USING btree (user_id, user_role);


--
-- Name: workflows_bbs; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX workflows_bbs ON public.workflows_building_blocks USING btree (workflow_id, building_block_id);


--
-- Name: workflows_use_case_steps_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX workflows_use_case_steps_idx ON public.use_case_steps_workflows USING btree (workflow_id, use_case_step_id);


--
-- Name: workflows_usecases; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX workflows_usecases ON public.workflows_use_cases USING btree (workflow_id, use_case_id);


--
-- Name: plays_building_blocks bbs_plays_bb_fk; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.plays_building_blocks
    ADD CONSTRAINT bbs_plays_bb_fk FOREIGN KEY (building_block_id) REFERENCES fao.building_blocks(id);


--
-- Name: plays_building_blocks bbs_plays_play_fk; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.plays_building_blocks
    ADD CONSTRAINT bbs_plays_play_fk FOREIGN KEY (play_id) REFERENCES fao.plays(id);


--
-- Name: candidate_resources candidate_resources_approved_by_fk; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.candidate_resources
    ADD CONSTRAINT candidate_resources_approved_by_fk FOREIGN KEY (approved_by_id) REFERENCES fao.users(id);


--
-- Name: candidate_resources_countries candidate_resources_countries_candidate_resources_fk; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.candidate_resources_countries
    ADD CONSTRAINT candidate_resources_countries_candidate_resources_fk FOREIGN KEY (candidate_resource_id) REFERENCES fao.candidate_resources(id);


--
-- Name: candidate_resources_countries candidate_resources_countries_countries_fk; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.candidate_resources_countries
    ADD CONSTRAINT candidate_resources_countries_countries_fk FOREIGN KEY (country_id) REFERENCES fao.countries(id);


--
-- Name: candidate_resources candidate_resources_rejected_by_fk; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.candidate_resources
    ADD CONSTRAINT candidate_resources_rejected_by_fk FOREIGN KEY (rejected_by_id) REFERENCES fao.users(id);


--
-- Name: plays_subplays child_play_fk; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.plays_subplays
    ADD CONSTRAINT child_play_fk FOREIGN KEY (child_play_id) REFERENCES fao.plays(id);


--
-- Name: districts fk_rails_002fc30497; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.districts
    ADD CONSTRAINT fk_rails_002fc30497 FOREIGN KEY (province_id) REFERENCES fao.provinces(id);


--
-- Name: offices fk_rails_0722c0e4f7; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.offices
    ADD CONSTRAINT fk_rails_0722c0e4f7 FOREIGN KEY (province_id) REFERENCES fao.provinces(id);


--
-- Name: handbook_descriptions fk_rails_08320ee34e; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.handbook_descriptions
    ADD CONSTRAINT fk_rails_08320ee34e FOREIGN KEY (handbook_id) REFERENCES fao.handbooks(id);


--
-- Name: playbook_descriptions fk_rails_08320ee34e; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.playbook_descriptions
    ADD CONSTRAINT fk_rails_08320ee34e FOREIGN KEY (playbook_id) REFERENCES fao.playbooks(id);


--
-- Name: offices fk_rails_08e10b87a1; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.offices
    ADD CONSTRAINT fk_rails_08e10b87a1 FOREIGN KEY (organization_id) REFERENCES fao.organizations(id);


--
-- Name: sectors fk_rails_0c5b9fc834; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.sectors
    ADD CONSTRAINT fk_rails_0c5b9fc834 FOREIGN KEY (origin_id) REFERENCES fao.origins(id);


--
-- Name: handbook_pages fk_rails_0d854afcc1; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.handbook_pages
    ADD CONSTRAINT fk_rails_0d854afcc1 FOREIGN KEY (handbook_id) REFERENCES fao.handbooks(id);


--
-- Name: datasets_origins fk_rails_1000d63cee; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.datasets_origins
    ADD CONSTRAINT fk_rails_1000d63cee FOREIGN KEY (origin_id) REFERENCES fao.origins(id);


--
-- Name: product_categories fk_rails_156a781ad6; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.product_categories
    ADD CONSTRAINT fk_rails_156a781ad6 FOREIGN KEY (software_category_id) REFERENCES fao.software_categories(id);


--
-- Name: product_classifications fk_rails_16035b6309; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.product_classifications
    ADD CONSTRAINT fk_rails_16035b6309 FOREIGN KEY (classification_id) REFERENCES fao.classifications(id);


--
-- Name: chatbot_conversations fk_rails_17f52fc61f; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.chatbot_conversations
    ADD CONSTRAINT fk_rails_17f52fc61f FOREIGN KEY (user_id) REFERENCES fao.users(id);


--
-- Name: use_case_steps fk_rails_1ab85a3bb6; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.use_case_steps
    ADD CONSTRAINT fk_rails_1ab85a3bb6 FOREIGN KEY (use_case_id) REFERENCES fao.use_cases(id);


--
-- Name: software_features fk_rails_1aba49ed7b; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.software_features
    ADD CONSTRAINT fk_rails_1aba49ed7b FOREIGN KEY (software_category_id) REFERENCES fao.software_categories(id);


--
-- Name: play_moves_resources fk_rails_1ba13f968c; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.play_moves_resources
    ADD CONSTRAINT fk_rails_1ba13f968c FOREIGN KEY (resource_id) REFERENCES fao.resources(id);


--
-- Name: candidate_roles fk_rails_1c91ae1dbd; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.candidate_roles
    ADD CONSTRAINT fk_rails_1c91ae1dbd FOREIGN KEY (approved_by_id) REFERENCES fao.users(id);


--
-- Name: opportunities_organizations fk_rails_1e1b217e25; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.opportunities_organizations
    ADD CONSTRAINT fk_rails_1e1b217e25 FOREIGN KEY (opportunity_id) REFERENCES fao.opportunities(id);


--
-- Name: building_block_descriptions fk_rails_1e30d5f2cb; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.building_block_descriptions
    ADD CONSTRAINT fk_rails_1e30d5f2cb FOREIGN KEY (building_block_id) REFERENCES fao.building_blocks(id);


--
-- Name: candidate_products fk_rails_1f7a4bef04; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.candidate_products
    ADD CONSTRAINT fk_rails_1f7a4bef04 FOREIGN KEY (approved_by_id) REFERENCES fao.users(id);


--
-- Name: deploys fk_rails_1ffce4bab2; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.deploys
    ADD CONSTRAINT fk_rails_1ffce4bab2 FOREIGN KEY (product_id) REFERENCES fao.products(id);


--
-- Name: opportunities_building_blocks fk_rails_215b65662e; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.opportunities_building_blocks
    ADD CONSTRAINT fk_rails_215b65662e FOREIGN KEY (opportunity_id) REFERENCES fao.opportunities(id);


--
-- Name: candidate_organizations fk_rails_246998b230; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.candidate_organizations
    ADD CONSTRAINT fk_rails_246998b230 FOREIGN KEY (rejected_by_id) REFERENCES fao.users(id);


--
-- Name: play_descriptions fk_rails_26dd7253a6; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.play_descriptions
    ADD CONSTRAINT fk_rails_26dd7253a6 FOREIGN KEY (play_id) REFERENCES fao.plays(id);


--
-- Name: projects_digital_principles fk_rails_28bb8bf3f7; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.projects_digital_principles
    ADD CONSTRAINT fk_rails_28bb8bf3f7 FOREIGN KEY (project_id) REFERENCES fao.projects(id);


--
-- Name: product_indicators fk_rails_2c154e19b9; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.product_indicators
    ADD CONSTRAINT fk_rails_2c154e19b9 FOREIGN KEY (category_indicator_id) REFERENCES fao.category_indicators(id);


--
-- Name: sectors fk_rails_2fafddb8c8; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.sectors
    ADD CONSTRAINT fk_rails_2fafddb8c8 FOREIGN KEY (parent_sector_id) REFERENCES fao.sectors(id);


--
-- Name: candidate_roles fk_rails_31a769978d; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.candidate_roles
    ADD CONSTRAINT fk_rails_31a769978d FOREIGN KEY (product_id) REFERENCES fao.products(id);


--
-- Name: organization_datasets fk_rails_37920930c1; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.organization_datasets
    ADD CONSTRAINT fk_rails_37920930c1 FOREIGN KEY (dataset_id) REFERENCES fao.datasets(id);


--
-- Name: candidate_datasets fk_rails_393a906ad8; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.candidate_datasets
    ADD CONSTRAINT fk_rails_393a906ad8 FOREIGN KEY (rejected_by_id) REFERENCES fao.users(id);


--
-- Name: candidate_roles fk_rails_3a1d782b99; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.candidate_roles
    ADD CONSTRAINT fk_rails_3a1d782b99 FOREIGN KEY (dataset_id) REFERENCES fao.datasets(id);


--
-- Name: organization_descriptions fk_rails_3a6b8edce9; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.organization_descriptions
    ADD CONSTRAINT fk_rails_3a6b8edce9 FOREIGN KEY (organization_id) REFERENCES fao.organizations(id);


--
-- Name: projects_digital_principles fk_rails_3eb4109c7d; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.projects_digital_principles
    ADD CONSTRAINT fk_rails_3eb4109c7d FOREIGN KEY (digital_principle_id) REFERENCES fao.digital_principles(id);


--
-- Name: resources fk_rails_41c2c1001c; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.resources
    ADD CONSTRAINT fk_rails_41c2c1001c FOREIGN KEY (submitted_by_id) REFERENCES fao.users(id);


--
-- Name: projects fk_rails_45a5b9baa8; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.projects
    ADD CONSTRAINT fk_rails_45a5b9baa8 FOREIGN KEY (origin_id) REFERENCES fao.origins(id);


--
-- Name: tag_descriptions fk_rails_46e6dc893e; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.tag_descriptions
    ADD CONSTRAINT fk_rails_46e6dc893e FOREIGN KEY (tag_id) REFERENCES fao.tags(id);


--
-- Name: play_moves_resources fk_rails_48f1a17adf; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.play_moves_resources
    ADD CONSTRAINT fk_rails_48f1a17adf FOREIGN KEY (play_move_id) REFERENCES fao.play_moves(id);


--
-- Name: opportunities_countries fk_rails_49a664b2f7; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.opportunities_countries
    ADD CONSTRAINT fk_rails_49a664b2f7 FOREIGN KEY (opportunity_id) REFERENCES fao.opportunities(id);


--
-- Name: candidate_roles fk_rails_4aa113bd52; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.candidate_roles
    ADD CONSTRAINT fk_rails_4aa113bd52 FOREIGN KEY (organization_id) REFERENCES fao.organizations(id);


--
-- Name: plays_building_blocks fk_rails_4d36dad6d0; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.plays_building_blocks
    ADD CONSTRAINT fk_rails_4d36dad6d0 FOREIGN KEY (building_block_id) REFERENCES fao.building_blocks(id);


--
-- Name: dataset_sectors fk_rails_4d5afa2af0; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.dataset_sectors
    ADD CONSTRAINT fk_rails_4d5afa2af0 FOREIGN KEY (dataset_id) REFERENCES fao.datasets(id);


--
-- Name: opportunities_sectors fk_rails_572c40b423; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.opportunities_sectors
    ADD CONSTRAINT fk_rails_572c40b423 FOREIGN KEY (opportunity_id) REFERENCES fao.opportunities(id);


--
-- Name: operator_services fk_rails_5c31270ff7; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.operator_services
    ADD CONSTRAINT fk_rails_5c31270ff7 FOREIGN KEY (country_id) REFERENCES fao.countries(id);


--
-- Name: opportunities fk_rails_5f8d9a4134; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.opportunities
    ADD CONSTRAINT fk_rails_5f8d9a4134 FOREIGN KEY (origin_id) REFERENCES fao.origins(id);


--
-- Name: user_messages fk_rails_60e38b1531; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.user_messages
    ADD CONSTRAINT fk_rails_60e38b1531 FOREIGN KEY (received_by_id) REFERENCES fao.users(id);


--
-- Name: organizations_countries fk_rails_61354fe2dd; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.organizations_countries
    ADD CONSTRAINT fk_rails_61354fe2dd FOREIGN KEY (country_id) REFERENCES fao.countries(id);


--
-- Name: dataset_descriptions fk_rails_6233152996; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.dataset_descriptions
    ADD CONSTRAINT fk_rails_6233152996 FOREIGN KEY (dataset_id) REFERENCES fao.datasets(id);


--
-- Name: offices fk_rails_63e101f453; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.offices
    ADD CONSTRAINT fk_rails_63e101f453 FOREIGN KEY (country_id) REFERENCES fao.countries(id);


--
-- Name: handbook_pages fk_rails_6441d33616; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.handbook_pages
    ADD CONSTRAINT fk_rails_6441d33616 FOREIGN KEY (handbook_questions_id) REFERENCES fao.handbook_questions(id);


--
-- Name: task_tracker_descriptions fk_rails_64d4c2c34c; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.task_tracker_descriptions
    ADD CONSTRAINT fk_rails_64d4c2c34c FOREIGN KEY (task_tracker_id) REFERENCES fao.task_trackers(id);


--
-- Name: category_indicator_descriptions fk_rails_664858eff1; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.category_indicator_descriptions
    ADD CONSTRAINT fk_rails_664858eff1 FOREIGN KEY (category_indicator_id) REFERENCES fao.category_indicators(id);


--
-- Name: workflow_descriptions fk_rails_69d7772842; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.workflow_descriptions
    ADD CONSTRAINT fk_rails_69d7772842 FOREIGN KEY (workflow_id) REFERENCES fao.workflows(id);


--
-- Name: playbook_plays fk_rails_6b205fb457; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.playbook_plays
    ADD CONSTRAINT fk_rails_6b205fb457 FOREIGN KEY (playbook_id) REFERENCES fao.playbooks(id);


--
-- Name: datasets_countries fk_rails_6c45cff588; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.datasets_countries
    ADD CONSTRAINT fk_rails_6c45cff588 FOREIGN KEY (dataset_id) REFERENCES fao.datasets(id);


--
-- Name: product_indicators fk_rails_721e0e4ba1; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.product_indicators
    ADD CONSTRAINT fk_rails_721e0e4ba1 FOREIGN KEY (product_id) REFERENCES fao.products(id);


--
-- Name: category_indicators fk_rails_72ff36837c; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.category_indicators
    ADD CONSTRAINT fk_rails_72ff36837c FOREIGN KEY (rubric_category_id) REFERENCES fao.rubric_categories(id);


--
-- Name: opportunities_use_cases fk_rails_74085c04cd; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.opportunities_use_cases
    ADD CONSTRAINT fk_rails_74085c04cd FOREIGN KEY (opportunity_id) REFERENCES fao.opportunities(id);


--
-- Name: product_repositories fk_rails_76210df50f; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.product_repositories
    ADD CONSTRAINT fk_rails_76210df50f FOREIGN KEY (product_id) REFERENCES fao.products(id);


--
-- Name: projects_countries fk_rails_7940afe1fe; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.projects_countries
    ADD CONSTRAINT fk_rails_7940afe1fe FOREIGN KEY (project_id) REFERENCES fao.projects(id);


--
-- Name: deploys fk_rails_7995634207; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.deploys
    ADD CONSTRAINT fk_rails_7995634207 FOREIGN KEY (user_id) REFERENCES fao.users(id);


--
-- Name: use_case_step_descriptions fk_rails_7c6b0affba; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.use_case_step_descriptions
    ADD CONSTRAINT fk_rails_7c6b0affba FOREIGN KEY (use_case_step_id) REFERENCES fao.use_case_steps(id);


--
-- Name: rubric_category_descriptions fk_rails_7f79ec6842; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.rubric_category_descriptions
    ADD CONSTRAINT fk_rails_7f79ec6842 FOREIGN KEY (rubric_category_id) REFERENCES fao.rubric_categories(id);


--
-- Name: candidate_roles fk_rails_80a7b4e918; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.candidate_roles
    ADD CONSTRAINT fk_rails_80a7b4e918 FOREIGN KEY (rejected_by_id) REFERENCES fao.users(id);


--
-- Name: opportunities_use_cases fk_rails_8350c2b67e; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.opportunities_use_cases
    ADD CONSTRAINT fk_rails_8350c2b67e FOREIGN KEY (use_case_id) REFERENCES fao.use_cases(id);


--
-- Name: dataset_sectors fk_rails_8398ea4f75; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.dataset_sectors
    ADD CONSTRAINT fk_rails_8398ea4f75 FOREIGN KEY (sector_id) REFERENCES fao.sectors(id);


--
-- Name: projects_countries fk_rails_8fcd9cd60b; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.projects_countries
    ADD CONSTRAINT fk_rails_8fcd9cd60b FOREIGN KEY (country_id) REFERENCES fao.countries(id);


--
-- Name: product_features fk_rails_9019f50ede; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.product_features
    ADD CONSTRAINT fk_rails_9019f50ede FOREIGN KEY (product_id) REFERENCES fao.products(id);


--
-- Name: project_descriptions fk_rails_94cabf0709; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.project_descriptions
    ADD CONSTRAINT fk_rails_94cabf0709 FOREIGN KEY (project_id) REFERENCES fao.projects(id);


--
-- Name: use_case_descriptions fk_rails_94ea5f52ff; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.use_case_descriptions
    ADD CONSTRAINT fk_rails_94ea5f52ff FOREIGN KEY (use_case_id) REFERENCES fao.use_cases(id);


--
-- Name: opportunities_sectors fk_rails_973eb5ee0a; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.opportunities_sectors
    ADD CONSTRAINT fk_rails_973eb5ee0a FOREIGN KEY (sector_id) REFERENCES fao.sectors(id);


--
-- Name: product_categories fk_rails_98a9a32a41; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.product_categories
    ADD CONSTRAINT fk_rails_98a9a32a41 FOREIGN KEY (product_id) REFERENCES fao.products(id);


--
-- Name: product_features fk_rails_9cbbc9970e; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.product_features
    ADD CONSTRAINT fk_rails_9cbbc9970e FOREIGN KEY (software_feature_id) REFERENCES fao.software_features(id);


--
-- Name: playbook_plays fk_rails_9d1a7ebfec; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.playbook_plays
    ADD CONSTRAINT fk_rails_9d1a7ebfec FOREIGN KEY (play_id) REFERENCES fao.plays(id);


--
-- Name: products_endorsers fk_rails_9ebc436657; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.products_endorsers
    ADD CONSTRAINT fk_rails_9ebc436657 FOREIGN KEY (product_id) REFERENCES fao.products(id);


--
-- Name: play_move_descriptions fk_rails_9f26d2af9a; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.play_move_descriptions
    ADD CONSTRAINT fk_rails_9f26d2af9a FOREIGN KEY (play_move_id) REFERENCES fao.play_moves(id);


--
-- Name: aggregator_capabilities fk_rails_9fcd7b6d41; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.aggregator_capabilities
    ADD CONSTRAINT fk_rails_9fcd7b6d41 FOREIGN KEY (aggregator_id) REFERENCES fao.organizations(id);


--
-- Name: organizations_countries fk_rails_a044fbacef; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.organizations_countries
    ADD CONSTRAINT fk_rails_a044fbacef FOREIGN KEY (organization_id) REFERENCES fao.organizations(id);


--
-- Name: plays_products fk_rails_a0c000bc7e; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.plays_products
    ADD CONSTRAINT fk_rails_a0c000bc7e FOREIGN KEY (play_id) REFERENCES fao.plays(id);


--
-- Name: opportunities_organizations fk_rails_a699f03037; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.opportunities_organizations
    ADD CONSTRAINT fk_rails_a699f03037 FOREIGN KEY (organization_id) REFERENCES fao.organizations(id);


--
-- Name: products_endorsers fk_rails_a70896ae9e; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.products_endorsers
    ADD CONSTRAINT fk_rails_a70896ae9e FOREIGN KEY (endorser_id) REFERENCES fao.endorsers(id);


--
-- Name: plays_products fk_rails_a91dfa5414; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.plays_products
    ADD CONSTRAINT fk_rails_a91dfa5414 FOREIGN KEY (product_id) REFERENCES fao.products(id);


--
-- Name: aggregator_capabilities fk_rails_aa5b2f5e59; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.aggregator_capabilities
    ADD CONSTRAINT fk_rails_aa5b2f5e59 FOREIGN KEY (operator_services_id) REFERENCES fao.operator_services(id);


--
-- Name: resource_topic_descriptions fk_rails_ae0fcdfa4b; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.resource_topic_descriptions
    ADD CONSTRAINT fk_rails_ae0fcdfa4b FOREIGN KEY (resource_topic_id) REFERENCES fao.resource_topics(id);


--
-- Name: resource_topics fk_rails_af05504d30; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.resource_topics
    ADD CONSTRAINT fk_rails_af05504d30 FOREIGN KEY (parent_topic_id) REFERENCES fao.resource_topics(id) ON DELETE SET NULL;


--
-- Name: resources_use_cases fk_rails_b312c98a0b; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.resources_use_cases
    ADD CONSTRAINT fk_rails_b312c98a0b FOREIGN KEY (use_case_id) REFERENCES fao.use_cases(id);


--
-- Name: resources fk_rails_b7c74d1aaf; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.resources
    ADD CONSTRAINT fk_rails_b7c74d1aaf FOREIGN KEY (organization_id) REFERENCES fao.organizations(id) ON DELETE SET NULL;


--
-- Name: opportunities_building_blocks fk_rails_bd7e32857c; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.opportunities_building_blocks
    ADD CONSTRAINT fk_rails_bd7e32857c FOREIGN KEY (building_block_id) REFERENCES fao.building_blocks(id);


--
-- Name: product_descriptions fk_rails_c0bc9f9c8a; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.product_descriptions
    ADD CONSTRAINT fk_rails_c0bc9f9c8a FOREIGN KEY (product_id) REFERENCES fao.products(id);


--
-- Name: opportunities_countries fk_rails_c231d14160; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.opportunities_countries
    ADD CONSTRAINT fk_rails_c231d14160 FOREIGN KEY (country_id) REFERENCES fao.countries(id);


--
-- Name: resources_use_cases fk_rails_c51465b571; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.resources_use_cases
    ADD CONSTRAINT fk_rails_c51465b571 FOREIGN KEY (resource_id) REFERENCES fao.resources(id);


--
-- Name: resource_building_blocks fk_rails_c60c9cd0cf; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.resource_building_blocks
    ADD CONSTRAINT fk_rails_c60c9cd0cf FOREIGN KEY (building_block_id) REFERENCES fao.building_blocks(id);


--
-- Name: organization_datasets fk_rails_c82c326076; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.organization_datasets
    ADD CONSTRAINT fk_rails_c82c326076 FOREIGN KEY (organization_id) REFERENCES fao.organizations(id);


--
-- Name: datasets_countries fk_rails_c8d14ec1b4; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.datasets_countries
    ADD CONSTRAINT fk_rails_c8d14ec1b4 FOREIGN KEY (country_id) REFERENCES fao.countries(id);


--
-- Name: messages fk_rails_cd133c6420; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.messages
    ADD CONSTRAINT fk_rails_cd133c6420 FOREIGN KEY (created_by_id) REFERENCES fao.users(id);


--
-- Name: candidate_organizations fk_rails_d0cf117a92; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.candidate_organizations
    ADD CONSTRAINT fk_rails_d0cf117a92 FOREIGN KEY (approved_by_id) REFERENCES fao.users(id);


--
-- Name: use_cases fk_rails_d2fed50240; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.use_cases
    ADD CONSTRAINT fk_rails_d2fed50240 FOREIGN KEY (sector_id) REFERENCES fao.sectors(id);


--
-- Name: product_classifications fk_rails_d5306b6dc7; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.product_classifications
    ADD CONSTRAINT fk_rails_d5306b6dc7 FOREIGN KEY (product_id) REFERENCES fao.products(id);


--
-- Name: resource_building_blocks fk_rails_d574f6d18b; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.resource_building_blocks
    ADD CONSTRAINT fk_rails_d574f6d18b FOREIGN KEY (resource_id) REFERENCES fao.resources(id);


--
-- Name: datasets_origins fk_rails_d604ea34b3; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.datasets_origins
    ADD CONSTRAINT fk_rails_d604ea34b3 FOREIGN KEY (dataset_id) REFERENCES fao.datasets(id);


--
-- Name: use_case_headers fk_rails_de4b7a8ac2; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.use_case_headers
    ADD CONSTRAINT fk_rails_de4b7a8ac2 FOREIGN KEY (use_case_id) REFERENCES fao.use_cases(id);


--
-- Name: play_moves fk_rails_e067d6a17d; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.play_moves
    ADD CONSTRAINT fk_rails_e067d6a17d FOREIGN KEY (play_id) REFERENCES fao.plays(id);


--
-- Name: cities fk_rails_e0ef2914ca; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.cities
    ADD CONSTRAINT fk_rails_e0ef2914ca FOREIGN KEY (province_id) REFERENCES fao.provinces(id);


--
-- Name: user_messages fk_rails_e3535a825c; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.user_messages
    ADD CONSTRAINT fk_rails_e3535a825c FOREIGN KEY (message_id) REFERENCES fao.messages(id);


--
-- Name: handbook_pages fk_rails_edc977f5e7; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.handbook_pages
    ADD CONSTRAINT fk_rails_edc977f5e7 FOREIGN KEY (parent_page_id) REFERENCES fao.handbook_pages(id);


--
-- Name: aggregator_capabilities fk_rails_ee0ee7b8e7; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.aggregator_capabilities
    ADD CONSTRAINT fk_rails_ee0ee7b8e7 FOREIGN KEY (country_id) REFERENCES fao.countries(id);


--
-- Name: candidate_products fk_rails_eed5af50b9; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.candidate_products
    ADD CONSTRAINT fk_rails_eed5af50b9 FOREIGN KEY (rejected_by_id) REFERENCES fao.users(id);


--
-- Name: page_contents fk_rails_efc85b8fb4; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.page_contents
    ADD CONSTRAINT fk_rails_efc85b8fb4 FOREIGN KEY (handbook_page_id) REFERENCES fao.handbook_pages(id);


--
-- Name: principle_descriptions fk_rails_f1497d5d96; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.principle_descriptions
    ADD CONSTRAINT fk_rails_f1497d5d96 FOREIGN KEY (digital_principle_id) REFERENCES fao.digital_principles(id);


--
-- Name: starred_objects fk_rails_f18f95cc1b; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.starred_objects
    ADD CONSTRAINT fk_rails_f18f95cc1b FOREIGN KEY (starred_by_id) REFERENCES fao.users(id);


--
-- Name: provinces fk_rails_f2ba72ccee; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.provinces
    ADD CONSTRAINT fk_rails_f2ba72ccee FOREIGN KEY (country_id) REFERENCES fao.countries(id);


--
-- Name: candidate_datasets fk_rails_f460267737; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.candidate_datasets
    ADD CONSTRAINT fk_rails_f460267737 FOREIGN KEY (approved_by_id) REFERENCES fao.users(id);


--
-- Name: plays_building_blocks fk_rails_f47938caa0; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.plays_building_blocks
    ADD CONSTRAINT fk_rails_f47938caa0 FOREIGN KEY (play_id) REFERENCES fao.plays(id);


--
-- Name: product_product_relationships from_product_fk; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.product_product_relationships
    ADD CONSTRAINT from_product_fk FOREIGN KEY (from_product_id) REFERENCES fao.products(id);


--
-- Name: organization_contacts organizations_contacts_contact_fk; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.organization_contacts
    ADD CONSTRAINT organizations_contacts_contact_fk FOREIGN KEY (contact_id) REFERENCES fao.contacts(id);


--
-- Name: organization_contacts organizations_contacts_organization_fk; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.organization_contacts
    ADD CONSTRAINT organizations_contacts_organization_fk FOREIGN KEY (organization_id) REFERENCES fao.organizations(id);


--
-- Name: organization_products organizations_products_organization_fk; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.organization_products
    ADD CONSTRAINT organizations_products_organization_fk FOREIGN KEY (organization_id) REFERENCES fao.organizations(id);


--
-- Name: organization_products organizations_products_product_fk; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.organization_products
    ADD CONSTRAINT organizations_products_product_fk FOREIGN KEY (product_id) REFERENCES fao.products(id);


--
-- Name: organizations_resources organizations_resources_organization_fk; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.organizations_resources
    ADD CONSTRAINT organizations_resources_organization_fk FOREIGN KEY (organization_id) REFERENCES fao.organizations(id);


--
-- Name: organizations_resources organizations_resources_resource_fk; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.organizations_resources
    ADD CONSTRAINT organizations_resources_resource_fk FOREIGN KEY (resource_id) REFERENCES fao.resources(id);


--
-- Name: organizations_sectors organizations_sectors_organization_fk; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.organizations_sectors
    ADD CONSTRAINT organizations_sectors_organization_fk FOREIGN KEY (organization_id) REFERENCES fao.organizations(id);


--
-- Name: organizations_sectors organizations_sectors_sector_fk; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.organizations_sectors
    ADD CONSTRAINT organizations_sectors_sector_fk FOREIGN KEY (sector_id) REFERENCES fao.sectors(id);


--
-- Name: plays_subplays parent_play_fk; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.plays_subplays
    ADD CONSTRAINT parent_play_fk FOREIGN KEY (parent_play_id) REFERENCES fao.plays(id);


--
-- Name: playbooks_sectors playbooks_sectors_playbook_fk; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.playbooks_sectors
    ADD CONSTRAINT playbooks_sectors_playbook_fk FOREIGN KEY (playbook_id) REFERENCES fao.playbooks(id);


--
-- Name: playbooks_sectors playbooks_sectors_sector_fk; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.playbooks_sectors
    ADD CONSTRAINT playbooks_sectors_sector_fk FOREIGN KEY (sector_id) REFERENCES fao.sectors(id);


--
-- Name: product_classifications product_classifications_classification_fk; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.product_classifications
    ADD CONSTRAINT product_classifications_classification_fk FOREIGN KEY (classification_id) REFERENCES fao.classifications(id);


--
-- Name: product_classifications product_classifications_product_fk; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.product_classifications
    ADD CONSTRAINT product_classifications_product_fk FOREIGN KEY (product_id) REFERENCES fao.products(id);


--
-- Name: products_countries product_countries_country_fk; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.products_countries
    ADD CONSTRAINT product_countries_country_fk FOREIGN KEY (country_id) REFERENCES fao.countries(id);


--
-- Name: products_countries product_countries_product_fk; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.products_countries
    ADD CONSTRAINT product_countries_product_fk FOREIGN KEY (product_id) REFERENCES fao.products(id);


--
-- Name: product_building_blocks products_building_blocks_building_block_fk; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.product_building_blocks
    ADD CONSTRAINT products_building_blocks_building_block_fk FOREIGN KEY (building_block_id) REFERENCES fao.building_blocks(id);


--
-- Name: product_building_blocks products_building_blocks_product_fk; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.product_building_blocks
    ADD CONSTRAINT products_building_blocks_product_fk FOREIGN KEY (product_id) REFERENCES fao.products(id);


--
-- Name: products_origins products_origins_origin_fk; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.products_origins
    ADD CONSTRAINT products_origins_origin_fk FOREIGN KEY (origin_id) REFERENCES fao.origins(id);


--
-- Name: products_origins products_origins_product_fk; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.products_origins
    ADD CONSTRAINT products_origins_product_fk FOREIGN KEY (product_id) REFERENCES fao.products(id);


--
-- Name: plays_products products_plays_play_fk; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.plays_products
    ADD CONSTRAINT products_plays_play_fk FOREIGN KEY (play_id) REFERENCES fao.plays(id);


--
-- Name: plays_products products_plays_product_fk; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.plays_products
    ADD CONSTRAINT products_plays_product_fk FOREIGN KEY (product_id) REFERENCES fao.products(id);


--
-- Name: product_sustainable_development_goals products_sdgs_product_fk; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.product_sustainable_development_goals
    ADD CONSTRAINT products_sdgs_product_fk FOREIGN KEY (product_id) REFERENCES fao.products(id);


--
-- Name: product_sustainable_development_goals products_sdgs_sdg_fk; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.product_sustainable_development_goals
    ADD CONSTRAINT products_sdgs_sdg_fk FOREIGN KEY (sustainable_development_goal_id) REFERENCES fao.sustainable_development_goals(id);


--
-- Name: projects_organizations projects_organizations_organization_fk; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.projects_organizations
    ADD CONSTRAINT projects_organizations_organization_fk FOREIGN KEY (organization_id) REFERENCES fao.organizations(id);


--
-- Name: projects_organizations projects_organizations_project_fk; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.projects_organizations
    ADD CONSTRAINT projects_organizations_project_fk FOREIGN KEY (project_id) REFERENCES fao.projects(id);


--
-- Name: projects_products projects_products_product_fk; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.projects_products
    ADD CONSTRAINT projects_products_product_fk FOREIGN KEY (product_id) REFERENCES fao.products(id);


--
-- Name: projects_products projects_products_project_fk; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.projects_products
    ADD CONSTRAINT projects_products_project_fk FOREIGN KEY (project_id) REFERENCES fao.projects(id);


--
-- Name: projects_sdgs projects_sdgs_project_fk; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.projects_sdgs
    ADD CONSTRAINT projects_sdgs_project_fk FOREIGN KEY (project_id) REFERENCES fao.projects(id);


--
-- Name: projects_sdgs projects_sdgs_sdg_fk; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.projects_sdgs
    ADD CONSTRAINT projects_sdgs_sdg_fk FOREIGN KEY (sdg_id) REFERENCES fao.sustainable_development_goals(id);


--
-- Name: projects_sectors projects_sectors_project_fk; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.projects_sectors
    ADD CONSTRAINT projects_sectors_project_fk FOREIGN KEY (project_id) REFERENCES fao.projects(id);


--
-- Name: projects_sectors projects_sectors_sector_fk; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.projects_sectors
    ADD CONSTRAINT projects_sectors_sector_fk FOREIGN KEY (sector_id) REFERENCES fao.sectors(id);


--
-- Name: product_product_relationships to_product_fk; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.product_product_relationships
    ADD CONSTRAINT to_product_fk FOREIGN KEY (to_product_id) REFERENCES fao.products(id);


--
-- Name: use_case_steps_building_blocks use_case_steps_building_blocks_block_fk; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.use_case_steps_building_blocks
    ADD CONSTRAINT use_case_steps_building_blocks_block_fk FOREIGN KEY (building_block_id) REFERENCES fao.building_blocks(id);


--
-- Name: use_case_steps_building_blocks use_case_steps_building_blocks_step_fk; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.use_case_steps_building_blocks
    ADD CONSTRAINT use_case_steps_building_blocks_step_fk FOREIGN KEY (use_case_step_id) REFERENCES fao.use_case_steps(id);


--
-- Name: use_case_steps_datasets use_case_steps_datasets_dataset_fk; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.use_case_steps_datasets
    ADD CONSTRAINT use_case_steps_datasets_dataset_fk FOREIGN KEY (dataset_id) REFERENCES fao.datasets(id);


--
-- Name: use_case_steps_datasets use_case_steps_datasets_step_fk; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.use_case_steps_datasets
    ADD CONSTRAINT use_case_steps_datasets_step_fk FOREIGN KEY (use_case_step_id) REFERENCES fao.use_case_steps(id);


--
-- Name: use_case_steps_products use_case_steps_products_product_fk; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.use_case_steps_products
    ADD CONSTRAINT use_case_steps_products_product_fk FOREIGN KEY (product_id) REFERENCES fao.products(id);


--
-- Name: use_case_steps_products use_case_steps_products_step_fk; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.use_case_steps_products
    ADD CONSTRAINT use_case_steps_products_step_fk FOREIGN KEY (use_case_step_id) REFERENCES fao.use_case_steps(id);


--
-- Name: use_case_steps_workflows use_case_steps_workflows_step_fk; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.use_case_steps_workflows
    ADD CONSTRAINT use_case_steps_workflows_step_fk FOREIGN KEY (use_case_step_id) REFERENCES fao.use_case_steps(id);


--
-- Name: use_case_steps_workflows use_case_steps_workflows_workflow_fk; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.use_case_steps_workflows
    ADD CONSTRAINT use_case_steps_workflows_workflow_fk FOREIGN KEY (workflow_id) REFERENCES fao.workflows(id);


--
-- Name: use_cases_sdg_targets usecases_sdgs_sdg_fk; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.use_cases_sdg_targets
    ADD CONSTRAINT usecases_sdgs_sdg_fk FOREIGN KEY (sdg_target_id) REFERENCES fao.sdg_targets(id);


--
-- Name: use_cases_sdg_targets usecases_sdgs_usecase_fk; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.use_cases_sdg_targets
    ADD CONSTRAINT usecases_sdgs_usecase_fk FOREIGN KEY (use_case_id) REFERENCES fao.use_cases(id);


--
-- Name: users user_organization_fk; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.users
    ADD CONSTRAINT user_organization_fk FOREIGN KEY (organization_id) REFERENCES fao.organizations(id);


--
-- Name: workflows_building_blocks workflows_bbs_bb_fk; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.workflows_building_blocks
    ADD CONSTRAINT workflows_bbs_bb_fk FOREIGN KEY (building_block_id) REFERENCES fao.building_blocks(id);


--
-- Name: workflows_building_blocks workflows_bbs_workflow_fk; Type: FK CONSTRAINT; Schema: fao; Owner: -
--

ALTER TABLE ONLY fao.workflows_building_blocks
    ADD CONSTRAINT workflows_bbs_workflow_fk FOREIGN KEY (workflow_id) REFERENCES fao.workflows(id);


--
-- Name: plays_building_blocks bbs_plays_bb_fk; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.plays_building_blocks
    ADD CONSTRAINT bbs_plays_bb_fk FOREIGN KEY (building_block_id) REFERENCES health.building_blocks(id);


--
-- Name: plays_building_blocks bbs_plays_play_fk; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.plays_building_blocks
    ADD CONSTRAINT bbs_plays_play_fk FOREIGN KEY (play_id) REFERENCES health.plays(id);


--
-- Name: candidate_resources candidate_resources_approved_by_fk; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.candidate_resources
    ADD CONSTRAINT candidate_resources_approved_by_fk FOREIGN KEY (approved_by_id) REFERENCES health.users(id);


--
-- Name: candidate_resources_countries candidate_resources_countries_candidate_resources_fk; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.candidate_resources_countries
    ADD CONSTRAINT candidate_resources_countries_candidate_resources_fk FOREIGN KEY (candidate_resource_id) REFERENCES health.candidate_resources(id);


--
-- Name: candidate_resources_countries candidate_resources_countries_countries_fk; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.candidate_resources_countries
    ADD CONSTRAINT candidate_resources_countries_countries_fk FOREIGN KEY (country_id) REFERENCES health.countries(id);


--
-- Name: candidate_resources candidate_resources_rejected_by_fk; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.candidate_resources
    ADD CONSTRAINT candidate_resources_rejected_by_fk FOREIGN KEY (rejected_by_id) REFERENCES health.users(id);


--
-- Name: plays_subplays child_play_fk; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.plays_subplays
    ADD CONSTRAINT child_play_fk FOREIGN KEY (child_play_id) REFERENCES health.plays(id);


--
-- Name: districts fk_rails_002fc30497; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.districts
    ADD CONSTRAINT fk_rails_002fc30497 FOREIGN KEY (province_id) REFERENCES health.provinces(id);


--
-- Name: offices fk_rails_0722c0e4f7; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.offices
    ADD CONSTRAINT fk_rails_0722c0e4f7 FOREIGN KEY (province_id) REFERENCES health.provinces(id);


--
-- Name: handbook_descriptions fk_rails_08320ee34e; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.handbook_descriptions
    ADD CONSTRAINT fk_rails_08320ee34e FOREIGN KEY (handbook_id) REFERENCES health.handbooks(id);


--
-- Name: playbook_descriptions fk_rails_08320ee34e; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.playbook_descriptions
    ADD CONSTRAINT fk_rails_08320ee34e FOREIGN KEY (playbook_id) REFERENCES health.playbooks(id);


--
-- Name: offices fk_rails_08e10b87a1; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.offices
    ADD CONSTRAINT fk_rails_08e10b87a1 FOREIGN KEY (organization_id) REFERENCES health.organizations(id);


--
-- Name: sectors fk_rails_0c5b9fc834; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.sectors
    ADD CONSTRAINT fk_rails_0c5b9fc834 FOREIGN KEY (origin_id) REFERENCES health.origins(id);


--
-- Name: handbook_pages fk_rails_0d854afcc1; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.handbook_pages
    ADD CONSTRAINT fk_rails_0d854afcc1 FOREIGN KEY (handbook_id) REFERENCES health.handbooks(id);


--
-- Name: datasets_origins fk_rails_1000d63cee; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.datasets_origins
    ADD CONSTRAINT fk_rails_1000d63cee FOREIGN KEY (origin_id) REFERENCES health.origins(id);


--
-- Name: product_categories fk_rails_156a781ad6; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.product_categories
    ADD CONSTRAINT fk_rails_156a781ad6 FOREIGN KEY (software_category_id) REFERENCES health.software_categories(id);


--
-- Name: product_classifications fk_rails_16035b6309; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.product_classifications
    ADD CONSTRAINT fk_rails_16035b6309 FOREIGN KEY (classification_id) REFERENCES health.classifications(id);


--
-- Name: chatbot_conversations fk_rails_17f52fc61f; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.chatbot_conversations
    ADD CONSTRAINT fk_rails_17f52fc61f FOREIGN KEY (user_id) REFERENCES health.users(id);


--
-- Name: use_case_steps fk_rails_1ab85a3bb6; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.use_case_steps
    ADD CONSTRAINT fk_rails_1ab85a3bb6 FOREIGN KEY (use_case_id) REFERENCES health.use_cases(id);


--
-- Name: software_features fk_rails_1aba49ed7b; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.software_features
    ADD CONSTRAINT fk_rails_1aba49ed7b FOREIGN KEY (software_category_id) REFERENCES health.software_categories(id);


--
-- Name: play_moves_resources fk_rails_1ba13f968c; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.play_moves_resources
    ADD CONSTRAINT fk_rails_1ba13f968c FOREIGN KEY (resource_id) REFERENCES health.resources(id);


--
-- Name: candidate_roles fk_rails_1c91ae1dbd; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.candidate_roles
    ADD CONSTRAINT fk_rails_1c91ae1dbd FOREIGN KEY (approved_by_id) REFERENCES health.users(id);


--
-- Name: opportunities_organizations fk_rails_1e1b217e25; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.opportunities_organizations
    ADD CONSTRAINT fk_rails_1e1b217e25 FOREIGN KEY (opportunity_id) REFERENCES health.opportunities(id);


--
-- Name: building_block_descriptions fk_rails_1e30d5f2cb; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.building_block_descriptions
    ADD CONSTRAINT fk_rails_1e30d5f2cb FOREIGN KEY (building_block_id) REFERENCES health.building_blocks(id);


--
-- Name: candidate_products fk_rails_1f7a4bef04; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.candidate_products
    ADD CONSTRAINT fk_rails_1f7a4bef04 FOREIGN KEY (approved_by_id) REFERENCES health.users(id);


--
-- Name: deploys fk_rails_1ffce4bab2; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.deploys
    ADD CONSTRAINT fk_rails_1ffce4bab2 FOREIGN KEY (product_id) REFERENCES health.products(id);


--
-- Name: opportunities_building_blocks fk_rails_215b65662e; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.opportunities_building_blocks
    ADD CONSTRAINT fk_rails_215b65662e FOREIGN KEY (opportunity_id) REFERENCES health.opportunities(id);


--
-- Name: candidate_organizations fk_rails_246998b230; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.candidate_organizations
    ADD CONSTRAINT fk_rails_246998b230 FOREIGN KEY (rejected_by_id) REFERENCES health.users(id);


--
-- Name: play_descriptions fk_rails_26dd7253a6; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.play_descriptions
    ADD CONSTRAINT fk_rails_26dd7253a6 FOREIGN KEY (play_id) REFERENCES health.plays(id);


--
-- Name: projects_digital_principles fk_rails_28bb8bf3f7; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.projects_digital_principles
    ADD CONSTRAINT fk_rails_28bb8bf3f7 FOREIGN KEY (project_id) REFERENCES health.projects(id);


--
-- Name: product_indicators fk_rails_2c154e19b9; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.product_indicators
    ADD CONSTRAINT fk_rails_2c154e19b9 FOREIGN KEY (category_indicator_id) REFERENCES health.category_indicators(id);


--
-- Name: sectors fk_rails_2fafddb8c8; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.sectors
    ADD CONSTRAINT fk_rails_2fafddb8c8 FOREIGN KEY (parent_sector_id) REFERENCES health.sectors(id);


--
-- Name: candidate_roles fk_rails_31a769978d; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.candidate_roles
    ADD CONSTRAINT fk_rails_31a769978d FOREIGN KEY (product_id) REFERENCES health.products(id);


--
-- Name: organization_datasets fk_rails_37920930c1; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.organization_datasets
    ADD CONSTRAINT fk_rails_37920930c1 FOREIGN KEY (dataset_id) REFERENCES health.datasets(id);


--
-- Name: candidate_datasets fk_rails_393a906ad8; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.candidate_datasets
    ADD CONSTRAINT fk_rails_393a906ad8 FOREIGN KEY (rejected_by_id) REFERENCES health.users(id);


--
-- Name: candidate_roles fk_rails_3a1d782b99; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.candidate_roles
    ADD CONSTRAINT fk_rails_3a1d782b99 FOREIGN KEY (dataset_id) REFERENCES health.datasets(id);


--
-- Name: organization_descriptions fk_rails_3a6b8edce9; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.organization_descriptions
    ADD CONSTRAINT fk_rails_3a6b8edce9 FOREIGN KEY (organization_id) REFERENCES health.organizations(id);


--
-- Name: projects_digital_principles fk_rails_3eb4109c7d; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.projects_digital_principles
    ADD CONSTRAINT fk_rails_3eb4109c7d FOREIGN KEY (digital_principle_id) REFERENCES health.digital_principles(id);


--
-- Name: resources fk_rails_41c2c1001c; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.resources
    ADD CONSTRAINT fk_rails_41c2c1001c FOREIGN KEY (submitted_by_id) REFERENCES health.users(id);


--
-- Name: projects fk_rails_45a5b9baa8; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.projects
    ADD CONSTRAINT fk_rails_45a5b9baa8 FOREIGN KEY (origin_id) REFERENCES health.origins(id);


--
-- Name: tag_descriptions fk_rails_46e6dc893e; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.tag_descriptions
    ADD CONSTRAINT fk_rails_46e6dc893e FOREIGN KEY (tag_id) REFERENCES health.tags(id);


--
-- Name: play_moves_resources fk_rails_48f1a17adf; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.play_moves_resources
    ADD CONSTRAINT fk_rails_48f1a17adf FOREIGN KEY (play_move_id) REFERENCES health.play_moves(id);


--
-- Name: opportunities_countries fk_rails_49a664b2f7; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.opportunities_countries
    ADD CONSTRAINT fk_rails_49a664b2f7 FOREIGN KEY (opportunity_id) REFERENCES health.opportunities(id);


--
-- Name: candidate_roles fk_rails_4aa113bd52; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.candidate_roles
    ADD CONSTRAINT fk_rails_4aa113bd52 FOREIGN KEY (organization_id) REFERENCES health.organizations(id);


--
-- Name: plays_building_blocks fk_rails_4d36dad6d0; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.plays_building_blocks
    ADD CONSTRAINT fk_rails_4d36dad6d0 FOREIGN KEY (building_block_id) REFERENCES health.building_blocks(id);


--
-- Name: dataset_sectors fk_rails_4d5afa2af0; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.dataset_sectors
    ADD CONSTRAINT fk_rails_4d5afa2af0 FOREIGN KEY (dataset_id) REFERENCES health.datasets(id);


--
-- Name: opportunities_sectors fk_rails_572c40b423; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.opportunities_sectors
    ADD CONSTRAINT fk_rails_572c40b423 FOREIGN KEY (opportunity_id) REFERENCES health.opportunities(id);


--
-- Name: operator_services fk_rails_5c31270ff7; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.operator_services
    ADD CONSTRAINT fk_rails_5c31270ff7 FOREIGN KEY (country_id) REFERENCES health.countries(id);


--
-- Name: opportunities fk_rails_5f8d9a4134; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.opportunities
    ADD CONSTRAINT fk_rails_5f8d9a4134 FOREIGN KEY (origin_id) REFERENCES health.origins(id);


--
-- Name: user_messages fk_rails_60e38b1531; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.user_messages
    ADD CONSTRAINT fk_rails_60e38b1531 FOREIGN KEY (received_by_id) REFERENCES health.users(id);


--
-- Name: organizations_countries fk_rails_61354fe2dd; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.organizations_countries
    ADD CONSTRAINT fk_rails_61354fe2dd FOREIGN KEY (country_id) REFERENCES health.countries(id);


--
-- Name: dataset_descriptions fk_rails_6233152996; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.dataset_descriptions
    ADD CONSTRAINT fk_rails_6233152996 FOREIGN KEY (dataset_id) REFERENCES health.datasets(id);


--
-- Name: offices fk_rails_63e101f453; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.offices
    ADD CONSTRAINT fk_rails_63e101f453 FOREIGN KEY (country_id) REFERENCES health.countries(id);


--
-- Name: handbook_pages fk_rails_6441d33616; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.handbook_pages
    ADD CONSTRAINT fk_rails_6441d33616 FOREIGN KEY (handbook_questions_id) REFERENCES health.handbook_questions(id);


--
-- Name: task_tracker_descriptions fk_rails_64d4c2c34c; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.task_tracker_descriptions
    ADD CONSTRAINT fk_rails_64d4c2c34c FOREIGN KEY (task_tracker_id) REFERENCES health.task_trackers(id);


--
-- Name: category_indicator_descriptions fk_rails_664858eff1; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.category_indicator_descriptions
    ADD CONSTRAINT fk_rails_664858eff1 FOREIGN KEY (category_indicator_id) REFERENCES health.category_indicators(id);


--
-- Name: workflow_descriptions fk_rails_69d7772842; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.workflow_descriptions
    ADD CONSTRAINT fk_rails_69d7772842 FOREIGN KEY (workflow_id) REFERENCES health.workflows(id);


--
-- Name: playbook_plays fk_rails_6b205fb457; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.playbook_plays
    ADD CONSTRAINT fk_rails_6b205fb457 FOREIGN KEY (playbook_id) REFERENCES health.playbooks(id);


--
-- Name: datasets_countries fk_rails_6c45cff588; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.datasets_countries
    ADD CONSTRAINT fk_rails_6c45cff588 FOREIGN KEY (dataset_id) REFERENCES health.datasets(id);


--
-- Name: product_indicators fk_rails_721e0e4ba1; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.product_indicators
    ADD CONSTRAINT fk_rails_721e0e4ba1 FOREIGN KEY (product_id) REFERENCES health.products(id);


--
-- Name: category_indicators fk_rails_72ff36837c; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.category_indicators
    ADD CONSTRAINT fk_rails_72ff36837c FOREIGN KEY (rubric_category_id) REFERENCES health.rubric_categories(id);


--
-- Name: opportunities_use_cases fk_rails_74085c04cd; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.opportunities_use_cases
    ADD CONSTRAINT fk_rails_74085c04cd FOREIGN KEY (opportunity_id) REFERENCES health.opportunities(id);


--
-- Name: product_repositories fk_rails_76210df50f; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.product_repositories
    ADD CONSTRAINT fk_rails_76210df50f FOREIGN KEY (product_id) REFERENCES health.products(id);


--
-- Name: projects_countries fk_rails_7940afe1fe; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.projects_countries
    ADD CONSTRAINT fk_rails_7940afe1fe FOREIGN KEY (project_id) REFERENCES health.projects(id);


--
-- Name: deploys fk_rails_7995634207; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.deploys
    ADD CONSTRAINT fk_rails_7995634207 FOREIGN KEY (user_id) REFERENCES health.users(id);


--
-- Name: use_case_step_descriptions fk_rails_7c6b0affba; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.use_case_step_descriptions
    ADD CONSTRAINT fk_rails_7c6b0affba FOREIGN KEY (use_case_step_id) REFERENCES health.use_case_steps(id);


--
-- Name: rubric_category_descriptions fk_rails_7f79ec6842; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.rubric_category_descriptions
    ADD CONSTRAINT fk_rails_7f79ec6842 FOREIGN KEY (rubric_category_id) REFERENCES health.rubric_categories(id);


--
-- Name: candidate_roles fk_rails_80a7b4e918; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.candidate_roles
    ADD CONSTRAINT fk_rails_80a7b4e918 FOREIGN KEY (rejected_by_id) REFERENCES health.users(id);


--
-- Name: opportunities_use_cases fk_rails_8350c2b67e; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.opportunities_use_cases
    ADD CONSTRAINT fk_rails_8350c2b67e FOREIGN KEY (use_case_id) REFERENCES health.use_cases(id);


--
-- Name: dataset_sectors fk_rails_8398ea4f75; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.dataset_sectors
    ADD CONSTRAINT fk_rails_8398ea4f75 FOREIGN KEY (sector_id) REFERENCES health.sectors(id);


--
-- Name: projects_countries fk_rails_8fcd9cd60b; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.projects_countries
    ADD CONSTRAINT fk_rails_8fcd9cd60b FOREIGN KEY (country_id) REFERENCES health.countries(id);


--
-- Name: product_features fk_rails_9019f50ede; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.product_features
    ADD CONSTRAINT fk_rails_9019f50ede FOREIGN KEY (product_id) REFERENCES health.products(id);


--
-- Name: project_descriptions fk_rails_94cabf0709; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.project_descriptions
    ADD CONSTRAINT fk_rails_94cabf0709 FOREIGN KEY (project_id) REFERENCES health.projects(id);


--
-- Name: use_case_descriptions fk_rails_94ea5f52ff; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.use_case_descriptions
    ADD CONSTRAINT fk_rails_94ea5f52ff FOREIGN KEY (use_case_id) REFERENCES health.use_cases(id);


--
-- Name: opportunities_sectors fk_rails_973eb5ee0a; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.opportunities_sectors
    ADD CONSTRAINT fk_rails_973eb5ee0a FOREIGN KEY (sector_id) REFERENCES health.sectors(id);


--
-- Name: product_categories fk_rails_98a9a32a41; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.product_categories
    ADD CONSTRAINT fk_rails_98a9a32a41 FOREIGN KEY (product_id) REFERENCES health.products(id);


--
-- Name: product_features fk_rails_9cbbc9970e; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.product_features
    ADD CONSTRAINT fk_rails_9cbbc9970e FOREIGN KEY (software_feature_id) REFERENCES health.software_features(id);


--
-- Name: playbook_plays fk_rails_9d1a7ebfec; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.playbook_plays
    ADD CONSTRAINT fk_rails_9d1a7ebfec FOREIGN KEY (play_id) REFERENCES health.plays(id);


--
-- Name: products_endorsers fk_rails_9ebc436657; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.products_endorsers
    ADD CONSTRAINT fk_rails_9ebc436657 FOREIGN KEY (product_id) REFERENCES health.products(id);


--
-- Name: play_move_descriptions fk_rails_9f26d2af9a; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.play_move_descriptions
    ADD CONSTRAINT fk_rails_9f26d2af9a FOREIGN KEY (play_move_id) REFERENCES health.play_moves(id);


--
-- Name: aggregator_capabilities fk_rails_9fcd7b6d41; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.aggregator_capabilities
    ADD CONSTRAINT fk_rails_9fcd7b6d41 FOREIGN KEY (aggregator_id) REFERENCES health.organizations(id);


--
-- Name: organizations_countries fk_rails_a044fbacef; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.organizations_countries
    ADD CONSTRAINT fk_rails_a044fbacef FOREIGN KEY (organization_id) REFERENCES health.organizations(id);


--
-- Name: plays_products fk_rails_a0c000bc7e; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.plays_products
    ADD CONSTRAINT fk_rails_a0c000bc7e FOREIGN KEY (play_id) REFERENCES health.plays(id);


--
-- Name: opportunities_organizations fk_rails_a699f03037; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.opportunities_organizations
    ADD CONSTRAINT fk_rails_a699f03037 FOREIGN KEY (organization_id) REFERENCES health.organizations(id);


--
-- Name: products_endorsers fk_rails_a70896ae9e; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.products_endorsers
    ADD CONSTRAINT fk_rails_a70896ae9e FOREIGN KEY (endorser_id) REFERENCES health.endorsers(id);


--
-- Name: plays_products fk_rails_a91dfa5414; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.plays_products
    ADD CONSTRAINT fk_rails_a91dfa5414 FOREIGN KEY (product_id) REFERENCES health.products(id);


--
-- Name: aggregator_capabilities fk_rails_aa5b2f5e59; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.aggregator_capabilities
    ADD CONSTRAINT fk_rails_aa5b2f5e59 FOREIGN KEY (operator_services_id) REFERENCES health.operator_services(id);


--
-- Name: resource_topic_descriptions fk_rails_ae0fcdfa4b; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.resource_topic_descriptions
    ADD CONSTRAINT fk_rails_ae0fcdfa4b FOREIGN KEY (resource_topic_id) REFERENCES health.resource_topics(id);


--
-- Name: resource_topics fk_rails_af05504d30; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.resource_topics
    ADD CONSTRAINT fk_rails_af05504d30 FOREIGN KEY (parent_topic_id) REFERENCES health.resource_topics(id) ON DELETE SET NULL;


--
-- Name: resources_use_cases fk_rails_b312c98a0b; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.resources_use_cases
    ADD CONSTRAINT fk_rails_b312c98a0b FOREIGN KEY (use_case_id) REFERENCES health.use_cases(id);


--
-- Name: resources fk_rails_b7c74d1aaf; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.resources
    ADD CONSTRAINT fk_rails_b7c74d1aaf FOREIGN KEY (organization_id) REFERENCES health.organizations(id) ON DELETE SET NULL;


--
-- Name: opportunities_building_blocks fk_rails_bd7e32857c; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.opportunities_building_blocks
    ADD CONSTRAINT fk_rails_bd7e32857c FOREIGN KEY (building_block_id) REFERENCES health.building_blocks(id);


--
-- Name: product_descriptions fk_rails_c0bc9f9c8a; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.product_descriptions
    ADD CONSTRAINT fk_rails_c0bc9f9c8a FOREIGN KEY (product_id) REFERENCES health.products(id);


--
-- Name: opportunities_countries fk_rails_c231d14160; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.opportunities_countries
    ADD CONSTRAINT fk_rails_c231d14160 FOREIGN KEY (country_id) REFERENCES health.countries(id);


--
-- Name: resources_use_cases fk_rails_c51465b571; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.resources_use_cases
    ADD CONSTRAINT fk_rails_c51465b571 FOREIGN KEY (resource_id) REFERENCES health.resources(id);


--
-- Name: resource_building_blocks fk_rails_c60c9cd0cf; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.resource_building_blocks
    ADD CONSTRAINT fk_rails_c60c9cd0cf FOREIGN KEY (building_block_id) REFERENCES health.building_blocks(id);


--
-- Name: organization_datasets fk_rails_c82c326076; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.organization_datasets
    ADD CONSTRAINT fk_rails_c82c326076 FOREIGN KEY (organization_id) REFERENCES health.organizations(id);


--
-- Name: datasets_countries fk_rails_c8d14ec1b4; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.datasets_countries
    ADD CONSTRAINT fk_rails_c8d14ec1b4 FOREIGN KEY (country_id) REFERENCES health.countries(id);


--
-- Name: messages fk_rails_cd133c6420; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.messages
    ADD CONSTRAINT fk_rails_cd133c6420 FOREIGN KEY (created_by_id) REFERENCES health.users(id);


--
-- Name: candidate_organizations fk_rails_d0cf117a92; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.candidate_organizations
    ADD CONSTRAINT fk_rails_d0cf117a92 FOREIGN KEY (approved_by_id) REFERENCES health.users(id);


--
-- Name: use_cases fk_rails_d2fed50240; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.use_cases
    ADD CONSTRAINT fk_rails_d2fed50240 FOREIGN KEY (sector_id) REFERENCES health.sectors(id);


--
-- Name: product_classifications fk_rails_d5306b6dc7; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.product_classifications
    ADD CONSTRAINT fk_rails_d5306b6dc7 FOREIGN KEY (product_id) REFERENCES health.products(id);


--
-- Name: resource_building_blocks fk_rails_d574f6d18b; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.resource_building_blocks
    ADD CONSTRAINT fk_rails_d574f6d18b FOREIGN KEY (resource_id) REFERENCES health.resources(id);


--
-- Name: datasets_origins fk_rails_d604ea34b3; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.datasets_origins
    ADD CONSTRAINT fk_rails_d604ea34b3 FOREIGN KEY (dataset_id) REFERENCES health.datasets(id);


--
-- Name: use_case_headers fk_rails_de4b7a8ac2; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.use_case_headers
    ADD CONSTRAINT fk_rails_de4b7a8ac2 FOREIGN KEY (use_case_id) REFERENCES health.use_cases(id);


--
-- Name: play_moves fk_rails_e067d6a17d; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.play_moves
    ADD CONSTRAINT fk_rails_e067d6a17d FOREIGN KEY (play_id) REFERENCES health.plays(id);


--
-- Name: cities fk_rails_e0ef2914ca; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.cities
    ADD CONSTRAINT fk_rails_e0ef2914ca FOREIGN KEY (province_id) REFERENCES health.provinces(id);


--
-- Name: user_messages fk_rails_e3535a825c; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.user_messages
    ADD CONSTRAINT fk_rails_e3535a825c FOREIGN KEY (message_id) REFERENCES health.messages(id);


--
-- Name: handbook_pages fk_rails_edc977f5e7; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.handbook_pages
    ADD CONSTRAINT fk_rails_edc977f5e7 FOREIGN KEY (parent_page_id) REFERENCES health.handbook_pages(id);


--
-- Name: aggregator_capabilities fk_rails_ee0ee7b8e7; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.aggregator_capabilities
    ADD CONSTRAINT fk_rails_ee0ee7b8e7 FOREIGN KEY (country_id) REFERENCES health.countries(id);


--
-- Name: candidate_products fk_rails_eed5af50b9; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.candidate_products
    ADD CONSTRAINT fk_rails_eed5af50b9 FOREIGN KEY (rejected_by_id) REFERENCES health.users(id);


--
-- Name: page_contents fk_rails_efc85b8fb4; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.page_contents
    ADD CONSTRAINT fk_rails_efc85b8fb4 FOREIGN KEY (handbook_page_id) REFERENCES health.handbook_pages(id);


--
-- Name: principle_descriptions fk_rails_f1497d5d96; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.principle_descriptions
    ADD CONSTRAINT fk_rails_f1497d5d96 FOREIGN KEY (digital_principle_id) REFERENCES health.digital_principles(id);


--
-- Name: starred_objects fk_rails_f18f95cc1b; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.starred_objects
    ADD CONSTRAINT fk_rails_f18f95cc1b FOREIGN KEY (starred_by_id) REFERENCES health.users(id);


--
-- Name: provinces fk_rails_f2ba72ccee; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.provinces
    ADD CONSTRAINT fk_rails_f2ba72ccee FOREIGN KEY (country_id) REFERENCES health.countries(id);


--
-- Name: candidate_datasets fk_rails_f460267737; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.candidate_datasets
    ADD CONSTRAINT fk_rails_f460267737 FOREIGN KEY (approved_by_id) REFERENCES health.users(id);


--
-- Name: plays_building_blocks fk_rails_f47938caa0; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.plays_building_blocks
    ADD CONSTRAINT fk_rails_f47938caa0 FOREIGN KEY (play_id) REFERENCES health.plays(id);


--
-- Name: product_product_relationships from_product_fk; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.product_product_relationships
    ADD CONSTRAINT from_product_fk FOREIGN KEY (from_product_id) REFERENCES health.products(id);


--
-- Name: organization_contacts organizations_contacts_contact_fk; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.organization_contacts
    ADD CONSTRAINT organizations_contacts_contact_fk FOREIGN KEY (contact_id) REFERENCES health.contacts(id);


--
-- Name: organization_contacts organizations_contacts_organization_fk; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.organization_contacts
    ADD CONSTRAINT organizations_contacts_organization_fk FOREIGN KEY (organization_id) REFERENCES health.organizations(id);


--
-- Name: organization_products organizations_products_organization_fk; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.organization_products
    ADD CONSTRAINT organizations_products_organization_fk FOREIGN KEY (organization_id) REFERENCES health.organizations(id);


--
-- Name: organization_products organizations_products_product_fk; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.organization_products
    ADD CONSTRAINT organizations_products_product_fk FOREIGN KEY (product_id) REFERENCES health.products(id);


--
-- Name: organizations_resources organizations_resources_organization_fk; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.organizations_resources
    ADD CONSTRAINT organizations_resources_organization_fk FOREIGN KEY (organization_id) REFERENCES health.organizations(id);


--
-- Name: organizations_resources organizations_resources_resource_fk; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.organizations_resources
    ADD CONSTRAINT organizations_resources_resource_fk FOREIGN KEY (resource_id) REFERENCES health.resources(id);


--
-- Name: organizations_sectors organizations_sectors_organization_fk; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.organizations_sectors
    ADD CONSTRAINT organizations_sectors_organization_fk FOREIGN KEY (organization_id) REFERENCES health.organizations(id);


--
-- Name: organizations_sectors organizations_sectors_sector_fk; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.organizations_sectors
    ADD CONSTRAINT organizations_sectors_sector_fk FOREIGN KEY (sector_id) REFERENCES health.sectors(id);


--
-- Name: plays_subplays parent_play_fk; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.plays_subplays
    ADD CONSTRAINT parent_play_fk FOREIGN KEY (parent_play_id) REFERENCES health.plays(id);


--
-- Name: playbooks_sectors playbooks_sectors_playbook_fk; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.playbooks_sectors
    ADD CONSTRAINT playbooks_sectors_playbook_fk FOREIGN KEY (playbook_id) REFERENCES health.playbooks(id);


--
-- Name: playbooks_sectors playbooks_sectors_sector_fk; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.playbooks_sectors
    ADD CONSTRAINT playbooks_sectors_sector_fk FOREIGN KEY (sector_id) REFERENCES health.sectors(id);


--
-- Name: product_classifications product_classifications_classification_fk; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.product_classifications
    ADD CONSTRAINT product_classifications_classification_fk FOREIGN KEY (classification_id) REFERENCES health.classifications(id);


--
-- Name: product_classifications product_classifications_product_fk; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.product_classifications
    ADD CONSTRAINT product_classifications_product_fk FOREIGN KEY (product_id) REFERENCES health.products(id);


--
-- Name: products_countries product_countries_country_fk; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.products_countries
    ADD CONSTRAINT product_countries_country_fk FOREIGN KEY (country_id) REFERENCES health.countries(id);


--
-- Name: products_countries product_countries_product_fk; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.products_countries
    ADD CONSTRAINT product_countries_product_fk FOREIGN KEY (product_id) REFERENCES health.products(id);


--
-- Name: product_building_blocks products_building_blocks_building_block_fk; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.product_building_blocks
    ADD CONSTRAINT products_building_blocks_building_block_fk FOREIGN KEY (building_block_id) REFERENCES health.building_blocks(id);


--
-- Name: product_building_blocks products_building_blocks_product_fk; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.product_building_blocks
    ADD CONSTRAINT products_building_blocks_product_fk FOREIGN KEY (product_id) REFERENCES health.products(id);


--
-- Name: products_origins products_origins_origin_fk; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.products_origins
    ADD CONSTRAINT products_origins_origin_fk FOREIGN KEY (origin_id) REFERENCES health.origins(id);


--
-- Name: products_origins products_origins_product_fk; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.products_origins
    ADD CONSTRAINT products_origins_product_fk FOREIGN KEY (product_id) REFERENCES health.products(id);


--
-- Name: plays_products products_plays_play_fk; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.plays_products
    ADD CONSTRAINT products_plays_play_fk FOREIGN KEY (play_id) REFERENCES health.plays(id);


--
-- Name: plays_products products_plays_product_fk; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.plays_products
    ADD CONSTRAINT products_plays_product_fk FOREIGN KEY (product_id) REFERENCES health.products(id);


--
-- Name: product_sustainable_development_goals products_sdgs_product_fk; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.product_sustainable_development_goals
    ADD CONSTRAINT products_sdgs_product_fk FOREIGN KEY (product_id) REFERENCES health.products(id);


--
-- Name: product_sustainable_development_goals products_sdgs_sdg_fk; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.product_sustainable_development_goals
    ADD CONSTRAINT products_sdgs_sdg_fk FOREIGN KEY (sustainable_development_goal_id) REFERENCES health.sustainable_development_goals(id);


--
-- Name: projects_organizations projects_organizations_organization_fk; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.projects_organizations
    ADD CONSTRAINT projects_organizations_organization_fk FOREIGN KEY (organization_id) REFERENCES health.organizations(id);


--
-- Name: projects_organizations projects_organizations_project_fk; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.projects_organizations
    ADD CONSTRAINT projects_organizations_project_fk FOREIGN KEY (project_id) REFERENCES health.projects(id);


--
-- Name: projects_products projects_products_product_fk; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.projects_products
    ADD CONSTRAINT projects_products_product_fk FOREIGN KEY (product_id) REFERENCES health.products(id);


--
-- Name: projects_products projects_products_project_fk; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.projects_products
    ADD CONSTRAINT projects_products_project_fk FOREIGN KEY (project_id) REFERENCES health.projects(id);


--
-- Name: projects_sdgs projects_sdgs_project_fk; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.projects_sdgs
    ADD CONSTRAINT projects_sdgs_project_fk FOREIGN KEY (project_id) REFERENCES health.projects(id);


--
-- Name: projects_sdgs projects_sdgs_sdg_fk; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.projects_sdgs
    ADD CONSTRAINT projects_sdgs_sdg_fk FOREIGN KEY (sdg_id) REFERENCES health.sustainable_development_goals(id);


--
-- Name: projects_sectors projects_sectors_project_fk; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.projects_sectors
    ADD CONSTRAINT projects_sectors_project_fk FOREIGN KEY (project_id) REFERENCES health.projects(id);


--
-- Name: projects_sectors projects_sectors_sector_fk; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.projects_sectors
    ADD CONSTRAINT projects_sectors_sector_fk FOREIGN KEY (sector_id) REFERENCES health.sectors(id);


--
-- Name: product_product_relationships to_product_fk; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.product_product_relationships
    ADD CONSTRAINT to_product_fk FOREIGN KEY (to_product_id) REFERENCES health.products(id);


--
-- Name: use_case_steps_building_blocks use_case_steps_building_blocks_block_fk; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.use_case_steps_building_blocks
    ADD CONSTRAINT use_case_steps_building_blocks_block_fk FOREIGN KEY (building_block_id) REFERENCES health.building_blocks(id);


--
-- Name: use_case_steps_building_blocks use_case_steps_building_blocks_step_fk; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.use_case_steps_building_blocks
    ADD CONSTRAINT use_case_steps_building_blocks_step_fk FOREIGN KEY (use_case_step_id) REFERENCES health.use_case_steps(id);


--
-- Name: use_case_steps_datasets use_case_steps_datasets_dataset_fk; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.use_case_steps_datasets
    ADD CONSTRAINT use_case_steps_datasets_dataset_fk FOREIGN KEY (dataset_id) REFERENCES health.datasets(id);


--
-- Name: use_case_steps_datasets use_case_steps_datasets_step_fk; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.use_case_steps_datasets
    ADD CONSTRAINT use_case_steps_datasets_step_fk FOREIGN KEY (use_case_step_id) REFERENCES health.use_case_steps(id);


--
-- Name: use_case_steps_products use_case_steps_products_product_fk; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.use_case_steps_products
    ADD CONSTRAINT use_case_steps_products_product_fk FOREIGN KEY (product_id) REFERENCES health.products(id);


--
-- Name: use_case_steps_products use_case_steps_products_step_fk; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.use_case_steps_products
    ADD CONSTRAINT use_case_steps_products_step_fk FOREIGN KEY (use_case_step_id) REFERENCES health.use_case_steps(id);


--
-- Name: use_case_steps_workflows use_case_steps_workflows_step_fk; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.use_case_steps_workflows
    ADD CONSTRAINT use_case_steps_workflows_step_fk FOREIGN KEY (use_case_step_id) REFERENCES health.use_case_steps(id);


--
-- Name: use_case_steps_workflows use_case_steps_workflows_workflow_fk; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.use_case_steps_workflows
    ADD CONSTRAINT use_case_steps_workflows_workflow_fk FOREIGN KEY (workflow_id) REFERENCES health.workflows(id);


--
-- Name: use_cases_sdg_targets usecases_sdgs_sdg_fk; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.use_cases_sdg_targets
    ADD CONSTRAINT usecases_sdgs_sdg_fk FOREIGN KEY (sdg_target_id) REFERENCES health.sdg_targets(id);


--
-- Name: use_cases_sdg_targets usecases_sdgs_usecase_fk; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.use_cases_sdg_targets
    ADD CONSTRAINT usecases_sdgs_usecase_fk FOREIGN KEY (use_case_id) REFERENCES health.use_cases(id);


--
-- Name: users user_organization_fk; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.users
    ADD CONSTRAINT user_organization_fk FOREIGN KEY (organization_id) REFERENCES health.organizations(id);


--
-- Name: workflows_building_blocks workflows_bbs_bb_fk; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.workflows_building_blocks
    ADD CONSTRAINT workflows_bbs_bb_fk FOREIGN KEY (building_block_id) REFERENCES health.building_blocks(id);


--
-- Name: workflows_building_blocks workflows_bbs_workflow_fk; Type: FK CONSTRAINT; Schema: health; Owner: -
--

ALTER TABLE ONLY health.workflows_building_blocks
    ADD CONSTRAINT workflows_bbs_workflow_fk FOREIGN KEY (workflow_id) REFERENCES health.workflows(id);


--
-- Name: plays_building_blocks bbs_plays_bb_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.plays_building_blocks
    ADD CONSTRAINT bbs_plays_bb_fk FOREIGN KEY (building_block_id) REFERENCES public.building_blocks(id);


--
-- Name: plays_building_blocks bbs_plays_play_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.plays_building_blocks
    ADD CONSTRAINT bbs_plays_play_fk FOREIGN KEY (play_id) REFERENCES public.plays(id);


--
-- Name: candidate_resources candidate_resources_approved_by_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.candidate_resources
    ADD CONSTRAINT candidate_resources_approved_by_fk FOREIGN KEY (approved_by_id) REFERENCES public.users(id);


--
-- Name: candidate_resources_countries candidate_resources_countries_candidate_resources_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.candidate_resources_countries
    ADD CONSTRAINT candidate_resources_countries_candidate_resources_fk FOREIGN KEY (candidate_resource_id) REFERENCES public.candidate_resources(id);


--
-- Name: candidate_resources_countries candidate_resources_countries_countries_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.candidate_resources_countries
    ADD CONSTRAINT candidate_resources_countries_countries_fk FOREIGN KEY (country_id) REFERENCES public.countries(id);


--
-- Name: candidate_resources candidate_resources_rejected_by_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.candidate_resources
    ADD CONSTRAINT candidate_resources_rejected_by_fk FOREIGN KEY (rejected_by_id) REFERENCES public.users(id);


--
-- Name: plays_subplays child_play_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.plays_subplays
    ADD CONSTRAINT child_play_fk FOREIGN KEY (child_play_id) REFERENCES public.plays(id);


--
-- Name: districts fk_rails_002fc30497; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.districts
    ADD CONSTRAINT fk_rails_002fc30497 FOREIGN KEY (province_id) REFERENCES public.provinces(id);


--
-- Name: offices fk_rails_0722c0e4f7; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.offices
    ADD CONSTRAINT fk_rails_0722c0e4f7 FOREIGN KEY (province_id) REFERENCES public.provinces(id);


--
-- Name: handbook_descriptions fk_rails_08320ee34e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.handbook_descriptions
    ADD CONSTRAINT fk_rails_08320ee34e FOREIGN KEY (handbook_id) REFERENCES public.handbooks(id);


--
-- Name: playbook_descriptions fk_rails_08320ee34e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.playbook_descriptions
    ADD CONSTRAINT fk_rails_08320ee34e FOREIGN KEY (playbook_id) REFERENCES public.playbooks(id);


--
-- Name: offices fk_rails_08e10b87a1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.offices
    ADD CONSTRAINT fk_rails_08e10b87a1 FOREIGN KEY (organization_id) REFERENCES public.organizations(id);


--
-- Name: sectors fk_rails_0c5b9fc834; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sectors
    ADD CONSTRAINT fk_rails_0c5b9fc834 FOREIGN KEY (origin_id) REFERENCES public.origins(id);


--
-- Name: handbook_pages fk_rails_0d854afcc1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.handbook_pages
    ADD CONSTRAINT fk_rails_0d854afcc1 FOREIGN KEY (handbook_id) REFERENCES public.handbooks(id);


--
-- Name: datasets_origins fk_rails_1000d63cee; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.datasets_origins
    ADD CONSTRAINT fk_rails_1000d63cee FOREIGN KEY (origin_id) REFERENCES public.origins(id);


--
-- Name: product_categories fk_rails_156a781ad6; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_categories
    ADD CONSTRAINT fk_rails_156a781ad6 FOREIGN KEY (software_category_id) REFERENCES public.software_categories(id);


--
-- Name: product_classifications fk_rails_16035b6309; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_classifications
    ADD CONSTRAINT fk_rails_16035b6309 FOREIGN KEY (classification_id) REFERENCES public.classifications(id);


--
-- Name: chatbot_conversations fk_rails_17f52fc61f; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chatbot_conversations
    ADD CONSTRAINT fk_rails_17f52fc61f FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: use_case_steps fk_rails_1ab85a3bb6; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.use_case_steps
    ADD CONSTRAINT fk_rails_1ab85a3bb6 FOREIGN KEY (use_case_id) REFERENCES public.use_cases(id);


--
-- Name: software_features fk_rails_1aba49ed7b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.software_features
    ADD CONSTRAINT fk_rails_1aba49ed7b FOREIGN KEY (software_category_id) REFERENCES public.software_categories(id);


--
-- Name: play_moves_resources fk_rails_1ba13f968c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.play_moves_resources
    ADD CONSTRAINT fk_rails_1ba13f968c FOREIGN KEY (resource_id) REFERENCES public.resources(id);


--
-- Name: candidate_roles fk_rails_1c91ae1dbd; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.candidate_roles
    ADD CONSTRAINT fk_rails_1c91ae1dbd FOREIGN KEY (approved_by_id) REFERENCES public.users(id);


--
-- Name: opportunities_organizations fk_rails_1e1b217e25; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.opportunities_organizations
    ADD CONSTRAINT fk_rails_1e1b217e25 FOREIGN KEY (opportunity_id) REFERENCES public.opportunities(id);


--
-- Name: building_block_descriptions fk_rails_1e30d5f2cb; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.building_block_descriptions
    ADD CONSTRAINT fk_rails_1e30d5f2cb FOREIGN KEY (building_block_id) REFERENCES public.building_blocks(id);


--
-- Name: candidate_products fk_rails_1f7a4bef04; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.candidate_products
    ADD CONSTRAINT fk_rails_1f7a4bef04 FOREIGN KEY (approved_by_id) REFERENCES public.users(id);


--
-- Name: deploys fk_rails_1ffce4bab2; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.deploys
    ADD CONSTRAINT fk_rails_1ffce4bab2 FOREIGN KEY (product_id) REFERENCES public.products(id);


--
-- Name: opportunities_building_blocks fk_rails_215b65662e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.opportunities_building_blocks
    ADD CONSTRAINT fk_rails_215b65662e FOREIGN KEY (opportunity_id) REFERENCES public.opportunities(id);


--
-- Name: candidate_organizations fk_rails_246998b230; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.candidate_organizations
    ADD CONSTRAINT fk_rails_246998b230 FOREIGN KEY (rejected_by_id) REFERENCES public.users(id);


--
-- Name: play_descriptions fk_rails_26dd7253a6; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.play_descriptions
    ADD CONSTRAINT fk_rails_26dd7253a6 FOREIGN KEY (play_id) REFERENCES public.plays(id);


--
-- Name: projects_digital_principles fk_rails_28bb8bf3f7; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.projects_digital_principles
    ADD CONSTRAINT fk_rails_28bb8bf3f7 FOREIGN KEY (project_id) REFERENCES public.projects(id);


--
-- Name: product_indicators fk_rails_2c154e19b9; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_indicators
    ADD CONSTRAINT fk_rails_2c154e19b9 FOREIGN KEY (category_indicator_id) REFERENCES public.category_indicators(id);


--
-- Name: sectors fk_rails_2fafddb8c8; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sectors
    ADD CONSTRAINT fk_rails_2fafddb8c8 FOREIGN KEY (parent_sector_id) REFERENCES public.sectors(id);


--
-- Name: candidate_roles fk_rails_31a769978d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.candidate_roles
    ADD CONSTRAINT fk_rails_31a769978d FOREIGN KEY (product_id) REFERENCES public.products(id);


--
-- Name: organization_datasets fk_rails_37920930c1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organization_datasets
    ADD CONSTRAINT fk_rails_37920930c1 FOREIGN KEY (dataset_id) REFERENCES public.datasets(id);


--
-- Name: candidate_datasets fk_rails_393a906ad8; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.candidate_datasets
    ADD CONSTRAINT fk_rails_393a906ad8 FOREIGN KEY (rejected_by_id) REFERENCES public.users(id);


--
-- Name: candidate_roles fk_rails_3a1d782b99; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.candidate_roles
    ADD CONSTRAINT fk_rails_3a1d782b99 FOREIGN KEY (dataset_id) REFERENCES public.datasets(id);


--
-- Name: organization_descriptions fk_rails_3a6b8edce9; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organization_descriptions
    ADD CONSTRAINT fk_rails_3a6b8edce9 FOREIGN KEY (organization_id) REFERENCES public.organizations(id);


--
-- Name: projects_digital_principles fk_rails_3eb4109c7d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.projects_digital_principles
    ADD CONSTRAINT fk_rails_3eb4109c7d FOREIGN KEY (digital_principle_id) REFERENCES public.digital_principles(id);


--
-- Name: resources fk_rails_41c2c1001c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.resources
    ADD CONSTRAINT fk_rails_41c2c1001c FOREIGN KEY (submitted_by_id) REFERENCES public.users(id);


--
-- Name: projects fk_rails_45a5b9baa8; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.projects
    ADD CONSTRAINT fk_rails_45a5b9baa8 FOREIGN KEY (origin_id) REFERENCES public.origins(id);


--
-- Name: tag_descriptions fk_rails_46e6dc893e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tag_descriptions
    ADD CONSTRAINT fk_rails_46e6dc893e FOREIGN KEY (tag_id) REFERENCES public.tags(id);


--
-- Name: play_moves_resources fk_rails_48f1a17adf; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.play_moves_resources
    ADD CONSTRAINT fk_rails_48f1a17adf FOREIGN KEY (play_move_id) REFERENCES public.play_moves(id);


--
-- Name: opportunities_countries fk_rails_49a664b2f7; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.opportunities_countries
    ADD CONSTRAINT fk_rails_49a664b2f7 FOREIGN KEY (opportunity_id) REFERENCES public.opportunities(id);


--
-- Name: candidate_roles fk_rails_4aa113bd52; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.candidate_roles
    ADD CONSTRAINT fk_rails_4aa113bd52 FOREIGN KEY (organization_id) REFERENCES public.organizations(id);


--
-- Name: plays_building_blocks fk_rails_4d36dad6d0; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.plays_building_blocks
    ADD CONSTRAINT fk_rails_4d36dad6d0 FOREIGN KEY (building_block_id) REFERENCES public.building_blocks(id);


--
-- Name: dataset_sectors fk_rails_4d5afa2af0; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dataset_sectors
    ADD CONSTRAINT fk_rails_4d5afa2af0 FOREIGN KEY (dataset_id) REFERENCES public.datasets(id);


--
-- Name: opportunities_sectors fk_rails_572c40b423; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.opportunities_sectors
    ADD CONSTRAINT fk_rails_572c40b423 FOREIGN KEY (opportunity_id) REFERENCES public.opportunities(id);


--
-- Name: operator_services fk_rails_5c31270ff7; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.operator_services
    ADD CONSTRAINT fk_rails_5c31270ff7 FOREIGN KEY (country_id) REFERENCES public.countries(id);


--
-- Name: opportunities fk_rails_5f8d9a4134; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.opportunities
    ADD CONSTRAINT fk_rails_5f8d9a4134 FOREIGN KEY (origin_id) REFERENCES public.origins(id);


--
-- Name: user_messages fk_rails_60e38b1531; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_messages
    ADD CONSTRAINT fk_rails_60e38b1531 FOREIGN KEY (received_by_id) REFERENCES public.users(id);


--
-- Name: organizations_countries fk_rails_61354fe2dd; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organizations_countries
    ADD CONSTRAINT fk_rails_61354fe2dd FOREIGN KEY (country_id) REFERENCES public.countries(id);


--
-- Name: dataset_descriptions fk_rails_6233152996; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dataset_descriptions
    ADD CONSTRAINT fk_rails_6233152996 FOREIGN KEY (dataset_id) REFERENCES public.datasets(id);


--
-- Name: offices fk_rails_63e101f453; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.offices
    ADD CONSTRAINT fk_rails_63e101f453 FOREIGN KEY (country_id) REFERENCES public.countries(id);


--
-- Name: handbook_pages fk_rails_6441d33616; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.handbook_pages
    ADD CONSTRAINT fk_rails_6441d33616 FOREIGN KEY (handbook_questions_id) REFERENCES public.handbook_questions(id);


--
-- Name: task_tracker_descriptions fk_rails_64d4c2c34c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.task_tracker_descriptions
    ADD CONSTRAINT fk_rails_64d4c2c34c FOREIGN KEY (task_tracker_id) REFERENCES public.task_trackers(id);


--
-- Name: category_indicator_descriptions fk_rails_664858eff1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.category_indicator_descriptions
    ADD CONSTRAINT fk_rails_664858eff1 FOREIGN KEY (category_indicator_id) REFERENCES public.category_indicators(id);


--
-- Name: workflow_descriptions fk_rails_69d7772842; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.workflow_descriptions
    ADD CONSTRAINT fk_rails_69d7772842 FOREIGN KEY (workflow_id) REFERENCES public.workflows(id);


--
-- Name: playbook_plays fk_rails_6b205fb457; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.playbook_plays
    ADD CONSTRAINT fk_rails_6b205fb457 FOREIGN KEY (playbook_id) REFERENCES public.playbooks(id);


--
-- Name: datasets_countries fk_rails_6c45cff588; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.datasets_countries
    ADD CONSTRAINT fk_rails_6c45cff588 FOREIGN KEY (dataset_id) REFERENCES public.datasets(id);


--
-- Name: product_indicators fk_rails_721e0e4ba1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_indicators
    ADD CONSTRAINT fk_rails_721e0e4ba1 FOREIGN KEY (product_id) REFERENCES public.products(id);


--
-- Name: category_indicators fk_rails_72ff36837c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.category_indicators
    ADD CONSTRAINT fk_rails_72ff36837c FOREIGN KEY (rubric_category_id) REFERENCES public.rubric_categories(id);


--
-- Name: opportunities_use_cases fk_rails_74085c04cd; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.opportunities_use_cases
    ADD CONSTRAINT fk_rails_74085c04cd FOREIGN KEY (opportunity_id) REFERENCES public.opportunities(id);


--
-- Name: product_repositories fk_rails_76210df50f; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_repositories
    ADD CONSTRAINT fk_rails_76210df50f FOREIGN KEY (product_id) REFERENCES public.products(id);


--
-- Name: projects_countries fk_rails_7940afe1fe; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.projects_countries
    ADD CONSTRAINT fk_rails_7940afe1fe FOREIGN KEY (project_id) REFERENCES public.projects(id);


--
-- Name: deploys fk_rails_7995634207; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.deploys
    ADD CONSTRAINT fk_rails_7995634207 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: use_case_step_descriptions fk_rails_7c6b0affba; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.use_case_step_descriptions
    ADD CONSTRAINT fk_rails_7c6b0affba FOREIGN KEY (use_case_step_id) REFERENCES public.use_case_steps(id);


--
-- Name: rubric_category_descriptions fk_rails_7f79ec6842; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rubric_category_descriptions
    ADD CONSTRAINT fk_rails_7f79ec6842 FOREIGN KEY (rubric_category_id) REFERENCES public.rubric_categories(id);


--
-- Name: candidate_roles fk_rails_80a7b4e918; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.candidate_roles
    ADD CONSTRAINT fk_rails_80a7b4e918 FOREIGN KEY (rejected_by_id) REFERENCES public.users(id);


--
-- Name: opportunities_use_cases fk_rails_8350c2b67e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.opportunities_use_cases
    ADD CONSTRAINT fk_rails_8350c2b67e FOREIGN KEY (use_case_id) REFERENCES public.use_cases(id);


--
-- Name: dataset_sectors fk_rails_8398ea4f75; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dataset_sectors
    ADD CONSTRAINT fk_rails_8398ea4f75 FOREIGN KEY (sector_id) REFERENCES public.sectors(id);


--
-- Name: projects_countries fk_rails_8fcd9cd60b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.projects_countries
    ADD CONSTRAINT fk_rails_8fcd9cd60b FOREIGN KEY (country_id) REFERENCES public.countries(id);


--
-- Name: product_features fk_rails_9019f50ede; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_features
    ADD CONSTRAINT fk_rails_9019f50ede FOREIGN KEY (product_id) REFERENCES public.products(id);


--
-- Name: project_descriptions fk_rails_94cabf0709; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.project_descriptions
    ADD CONSTRAINT fk_rails_94cabf0709 FOREIGN KEY (project_id) REFERENCES public.projects(id);


--
-- Name: use_case_descriptions fk_rails_94ea5f52ff; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.use_case_descriptions
    ADD CONSTRAINT fk_rails_94ea5f52ff FOREIGN KEY (use_case_id) REFERENCES public.use_cases(id);


--
-- Name: opportunities_sectors fk_rails_973eb5ee0a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.opportunities_sectors
    ADD CONSTRAINT fk_rails_973eb5ee0a FOREIGN KEY (sector_id) REFERENCES public.sectors(id);


--
-- Name: product_categories fk_rails_98a9a32a41; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_categories
    ADD CONSTRAINT fk_rails_98a9a32a41 FOREIGN KEY (product_id) REFERENCES public.products(id);


--
-- Name: product_features fk_rails_9cbbc9970e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_features
    ADD CONSTRAINT fk_rails_9cbbc9970e FOREIGN KEY (software_feature_id) REFERENCES public.software_features(id);


--
-- Name: playbook_plays fk_rails_9d1a7ebfec; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.playbook_plays
    ADD CONSTRAINT fk_rails_9d1a7ebfec FOREIGN KEY (play_id) REFERENCES public.plays(id);


--
-- Name: products_endorsers fk_rails_9ebc436657; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.products_endorsers
    ADD CONSTRAINT fk_rails_9ebc436657 FOREIGN KEY (product_id) REFERENCES public.products(id);


--
-- Name: play_move_descriptions fk_rails_9f26d2af9a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.play_move_descriptions
    ADD CONSTRAINT fk_rails_9f26d2af9a FOREIGN KEY (play_move_id) REFERENCES public.play_moves(id);


--
-- Name: aggregator_capabilities fk_rails_9fcd7b6d41; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.aggregator_capabilities
    ADD CONSTRAINT fk_rails_9fcd7b6d41 FOREIGN KEY (aggregator_id) REFERENCES public.organizations(id);


--
-- Name: organizations_countries fk_rails_a044fbacef; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organizations_countries
    ADD CONSTRAINT fk_rails_a044fbacef FOREIGN KEY (organization_id) REFERENCES public.organizations(id);


--
-- Name: plays_products fk_rails_a0c000bc7e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.plays_products
    ADD CONSTRAINT fk_rails_a0c000bc7e FOREIGN KEY (play_id) REFERENCES public.plays(id);


--
-- Name: opportunities_organizations fk_rails_a699f03037; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.opportunities_organizations
    ADD CONSTRAINT fk_rails_a699f03037 FOREIGN KEY (organization_id) REFERENCES public.organizations(id);


--
-- Name: products_endorsers fk_rails_a70896ae9e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.products_endorsers
    ADD CONSTRAINT fk_rails_a70896ae9e FOREIGN KEY (endorser_id) REFERENCES public.endorsers(id);


--
-- Name: plays_products fk_rails_a91dfa5414; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.plays_products
    ADD CONSTRAINT fk_rails_a91dfa5414 FOREIGN KEY (product_id) REFERENCES public.products(id);


--
-- Name: aggregator_capabilities fk_rails_aa5b2f5e59; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.aggregator_capabilities
    ADD CONSTRAINT fk_rails_aa5b2f5e59 FOREIGN KEY (operator_services_id) REFERENCES public.operator_services(id);


--
-- Name: resource_topic_descriptions fk_rails_ae0fcdfa4b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.resource_topic_descriptions
    ADD CONSTRAINT fk_rails_ae0fcdfa4b FOREIGN KEY (resource_topic_id) REFERENCES public.resource_topics(id);


--
-- Name: resource_topics fk_rails_af05504d30; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.resource_topics
    ADD CONSTRAINT fk_rails_af05504d30 FOREIGN KEY (parent_topic_id) REFERENCES public.resource_topics(id) ON DELETE SET NULL;


--
-- Name: resources_use_cases fk_rails_b312c98a0b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.resources_use_cases
    ADD CONSTRAINT fk_rails_b312c98a0b FOREIGN KEY (use_case_id) REFERENCES public.use_cases(id);


--
-- Name: resources fk_rails_b7c74d1aaf; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.resources
    ADD CONSTRAINT fk_rails_b7c74d1aaf FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE SET NULL;


--
-- Name: opportunities_building_blocks fk_rails_bd7e32857c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.opportunities_building_blocks
    ADD CONSTRAINT fk_rails_bd7e32857c FOREIGN KEY (building_block_id) REFERENCES public.building_blocks(id);


--
-- Name: product_descriptions fk_rails_c0bc9f9c8a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_descriptions
    ADD CONSTRAINT fk_rails_c0bc9f9c8a FOREIGN KEY (product_id) REFERENCES public.products(id);


--
-- Name: opportunities_countries fk_rails_c231d14160; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.opportunities_countries
    ADD CONSTRAINT fk_rails_c231d14160 FOREIGN KEY (country_id) REFERENCES public.countries(id);


--
-- Name: resources_use_cases fk_rails_c51465b571; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.resources_use_cases
    ADD CONSTRAINT fk_rails_c51465b571 FOREIGN KEY (resource_id) REFERENCES public.resources(id);


--
-- Name: resource_building_blocks fk_rails_c60c9cd0cf; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.resource_building_blocks
    ADD CONSTRAINT fk_rails_c60c9cd0cf FOREIGN KEY (building_block_id) REFERENCES public.building_blocks(id);


--
-- Name: organization_datasets fk_rails_c82c326076; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organization_datasets
    ADD CONSTRAINT fk_rails_c82c326076 FOREIGN KEY (organization_id) REFERENCES public.organizations(id);


--
-- Name: datasets_countries fk_rails_c8d14ec1b4; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.datasets_countries
    ADD CONSTRAINT fk_rails_c8d14ec1b4 FOREIGN KEY (country_id) REFERENCES public.countries(id);


--
-- Name: messages fk_rails_cd133c6420; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT fk_rails_cd133c6420 FOREIGN KEY (created_by_id) REFERENCES public.users(id);


--
-- Name: candidate_organizations fk_rails_d0cf117a92; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.candidate_organizations
    ADD CONSTRAINT fk_rails_d0cf117a92 FOREIGN KEY (approved_by_id) REFERENCES public.users(id);


--
-- Name: use_cases fk_rails_d2fed50240; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.use_cases
    ADD CONSTRAINT fk_rails_d2fed50240 FOREIGN KEY (sector_id) REFERENCES public.sectors(id);


--
-- Name: product_classifications fk_rails_d5306b6dc7; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_classifications
    ADD CONSTRAINT fk_rails_d5306b6dc7 FOREIGN KEY (product_id) REFERENCES public.products(id);


--
-- Name: resource_building_blocks fk_rails_d574f6d18b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.resource_building_blocks
    ADD CONSTRAINT fk_rails_d574f6d18b FOREIGN KEY (resource_id) REFERENCES public.resources(id);


--
-- Name: datasets_origins fk_rails_d604ea34b3; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.datasets_origins
    ADD CONSTRAINT fk_rails_d604ea34b3 FOREIGN KEY (dataset_id) REFERENCES public.datasets(id);


--
-- Name: use_case_headers fk_rails_de4b7a8ac2; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.use_case_headers
    ADD CONSTRAINT fk_rails_de4b7a8ac2 FOREIGN KEY (use_case_id) REFERENCES public.use_cases(id);


--
-- Name: play_moves fk_rails_e067d6a17d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.play_moves
    ADD CONSTRAINT fk_rails_e067d6a17d FOREIGN KEY (play_id) REFERENCES public.plays(id);


--
-- Name: cities fk_rails_e0ef2914ca; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cities
    ADD CONSTRAINT fk_rails_e0ef2914ca FOREIGN KEY (province_id) REFERENCES public.provinces(id);


--
-- Name: user_messages fk_rails_e3535a825c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_messages
    ADD CONSTRAINT fk_rails_e3535a825c FOREIGN KEY (message_id) REFERENCES public.messages(id);


--
-- Name: handbook_pages fk_rails_edc977f5e7; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.handbook_pages
    ADD CONSTRAINT fk_rails_edc977f5e7 FOREIGN KEY (parent_page_id) REFERENCES public.handbook_pages(id);


--
-- Name: aggregator_capabilities fk_rails_ee0ee7b8e7; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.aggregator_capabilities
    ADD CONSTRAINT fk_rails_ee0ee7b8e7 FOREIGN KEY (country_id) REFERENCES public.countries(id);


--
-- Name: candidate_products fk_rails_eed5af50b9; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.candidate_products
    ADD CONSTRAINT fk_rails_eed5af50b9 FOREIGN KEY (rejected_by_id) REFERENCES public.users(id);


--
-- Name: page_contents fk_rails_efc85b8fb4; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.page_contents
    ADD CONSTRAINT fk_rails_efc85b8fb4 FOREIGN KEY (handbook_page_id) REFERENCES public.handbook_pages(id);


--
-- Name: principle_descriptions fk_rails_f1497d5d96; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.principle_descriptions
    ADD CONSTRAINT fk_rails_f1497d5d96 FOREIGN KEY (digital_principle_id) REFERENCES public.digital_principles(id);


--
-- Name: starred_objects fk_rails_f18f95cc1b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.starred_objects
    ADD CONSTRAINT fk_rails_f18f95cc1b FOREIGN KEY (starred_by_id) REFERENCES public.users(id);


--
-- Name: provinces fk_rails_f2ba72ccee; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.provinces
    ADD CONSTRAINT fk_rails_f2ba72ccee FOREIGN KEY (country_id) REFERENCES public.countries(id);


--
-- Name: candidate_datasets fk_rails_f460267737; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.candidate_datasets
    ADD CONSTRAINT fk_rails_f460267737 FOREIGN KEY (approved_by_id) REFERENCES public.users(id);


--
-- Name: plays_building_blocks fk_rails_f47938caa0; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.plays_building_blocks
    ADD CONSTRAINT fk_rails_f47938caa0 FOREIGN KEY (play_id) REFERENCES public.plays(id);


--
-- Name: product_product_relationships from_product_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_product_relationships
    ADD CONSTRAINT from_product_fk FOREIGN KEY (from_product_id) REFERENCES public.products(id);


--
-- Name: organization_contacts organizations_contacts_contact_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organization_contacts
    ADD CONSTRAINT organizations_contacts_contact_fk FOREIGN KEY (contact_id) REFERENCES public.contacts(id);


--
-- Name: organization_contacts organizations_contacts_organization_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organization_contacts
    ADD CONSTRAINT organizations_contacts_organization_fk FOREIGN KEY (organization_id) REFERENCES public.organizations(id);


--
-- Name: organization_products organizations_products_organization_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organization_products
    ADD CONSTRAINT organizations_products_organization_fk FOREIGN KEY (organization_id) REFERENCES public.organizations(id);


--
-- Name: organization_products organizations_products_product_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organization_products
    ADD CONSTRAINT organizations_products_product_fk FOREIGN KEY (product_id) REFERENCES public.products(id);


--
-- Name: organizations_resources organizations_resources_organization_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organizations_resources
    ADD CONSTRAINT organizations_resources_organization_fk FOREIGN KEY (organization_id) REFERENCES public.organizations(id);


--
-- Name: organizations_resources organizations_resources_resource_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organizations_resources
    ADD CONSTRAINT organizations_resources_resource_fk FOREIGN KEY (resource_id) REFERENCES public.resources(id);


--
-- Name: organizations_sectors organizations_sectors_organization_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organizations_sectors
    ADD CONSTRAINT organizations_sectors_organization_fk FOREIGN KEY (organization_id) REFERENCES public.organizations(id);


--
-- Name: organizations_sectors organizations_sectors_sector_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organizations_sectors
    ADD CONSTRAINT organizations_sectors_sector_fk FOREIGN KEY (sector_id) REFERENCES public.sectors(id);


--
-- Name: plays_subplays parent_play_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.plays_subplays
    ADD CONSTRAINT parent_play_fk FOREIGN KEY (parent_play_id) REFERENCES public.plays(id);


--
-- Name: playbooks_sectors playbooks_sectors_playbook_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.playbooks_sectors
    ADD CONSTRAINT playbooks_sectors_playbook_fk FOREIGN KEY (playbook_id) REFERENCES public.playbooks(id);


--
-- Name: playbooks_sectors playbooks_sectors_sector_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.playbooks_sectors
    ADD CONSTRAINT playbooks_sectors_sector_fk FOREIGN KEY (sector_id) REFERENCES public.sectors(id);


--
-- Name: product_classifications product_classifications_classification_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_classifications
    ADD CONSTRAINT product_classifications_classification_fk FOREIGN KEY (classification_id) REFERENCES public.classifications(id);


--
-- Name: product_classifications product_classifications_product_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_classifications
    ADD CONSTRAINT product_classifications_product_fk FOREIGN KEY (product_id) REFERENCES public.products(id);


--
-- Name: products_countries product_countries_country_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.products_countries
    ADD CONSTRAINT product_countries_country_fk FOREIGN KEY (country_id) REFERENCES public.countries(id);


--
-- Name: products_countries product_countries_product_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.products_countries
    ADD CONSTRAINT product_countries_product_fk FOREIGN KEY (product_id) REFERENCES public.products(id);


--
-- Name: product_building_blocks products_building_blocks_building_block_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_building_blocks
    ADD CONSTRAINT products_building_blocks_building_block_fk FOREIGN KEY (building_block_id) REFERENCES public.building_blocks(id);


--
-- Name: product_building_blocks products_building_blocks_product_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_building_blocks
    ADD CONSTRAINT products_building_blocks_product_fk FOREIGN KEY (product_id) REFERENCES public.products(id);


--
-- Name: products_origins products_origins_origin_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.products_origins
    ADD CONSTRAINT products_origins_origin_fk FOREIGN KEY (origin_id) REFERENCES public.origins(id);


--
-- Name: products_origins products_origins_product_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.products_origins
    ADD CONSTRAINT products_origins_product_fk FOREIGN KEY (product_id) REFERENCES public.products(id);


--
-- Name: plays_products products_plays_play_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.plays_products
    ADD CONSTRAINT products_plays_play_fk FOREIGN KEY (play_id) REFERENCES public.plays(id);


--
-- Name: plays_products products_plays_product_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.plays_products
    ADD CONSTRAINT products_plays_product_fk FOREIGN KEY (product_id) REFERENCES public.products(id);


--
-- Name: product_sustainable_development_goals products_sdgs_product_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_sustainable_development_goals
    ADD CONSTRAINT products_sdgs_product_fk FOREIGN KEY (product_id) REFERENCES public.products(id);


--
-- Name: product_sustainable_development_goals products_sdgs_sdg_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_sustainable_development_goals
    ADD CONSTRAINT products_sdgs_sdg_fk FOREIGN KEY (sustainable_development_goal_id) REFERENCES public.sustainable_development_goals(id);


--
-- Name: projects_organizations projects_organizations_organization_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.projects_organizations
    ADD CONSTRAINT projects_organizations_organization_fk FOREIGN KEY (organization_id) REFERENCES public.organizations(id);


--
-- Name: projects_organizations projects_organizations_project_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.projects_organizations
    ADD CONSTRAINT projects_organizations_project_fk FOREIGN KEY (project_id) REFERENCES public.projects(id);


--
-- Name: projects_products projects_products_product_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.projects_products
    ADD CONSTRAINT projects_products_product_fk FOREIGN KEY (product_id) REFERENCES public.products(id);


--
-- Name: projects_products projects_products_project_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.projects_products
    ADD CONSTRAINT projects_products_project_fk FOREIGN KEY (project_id) REFERENCES public.projects(id);


--
-- Name: projects_sdgs projects_sdgs_project_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.projects_sdgs
    ADD CONSTRAINT projects_sdgs_project_fk FOREIGN KEY (project_id) REFERENCES public.projects(id);


--
-- Name: projects_sdgs projects_sdgs_sdg_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.projects_sdgs
    ADD CONSTRAINT projects_sdgs_sdg_fk FOREIGN KEY (sdg_id) REFERENCES public.sustainable_development_goals(id);


--
-- Name: projects_sectors projects_sectors_project_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.projects_sectors
    ADD CONSTRAINT projects_sectors_project_fk FOREIGN KEY (project_id) REFERENCES public.projects(id);


--
-- Name: projects_sectors projects_sectors_sector_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.projects_sectors
    ADD CONSTRAINT projects_sectors_sector_fk FOREIGN KEY (sector_id) REFERENCES public.sectors(id);


--
-- Name: product_product_relationships to_product_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_product_relationships
    ADD CONSTRAINT to_product_fk FOREIGN KEY (to_product_id) REFERENCES public.products(id);


--
-- Name: use_case_steps_building_blocks use_case_steps_building_blocks_block_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.use_case_steps_building_blocks
    ADD CONSTRAINT use_case_steps_building_blocks_block_fk FOREIGN KEY (building_block_id) REFERENCES public.building_blocks(id);


--
-- Name: use_case_steps_building_blocks use_case_steps_building_blocks_step_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.use_case_steps_building_blocks
    ADD CONSTRAINT use_case_steps_building_blocks_step_fk FOREIGN KEY (use_case_step_id) REFERENCES public.use_case_steps(id);


--
-- Name: use_case_steps_datasets use_case_steps_datasets_dataset_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.use_case_steps_datasets
    ADD CONSTRAINT use_case_steps_datasets_dataset_fk FOREIGN KEY (dataset_id) REFERENCES public.datasets(id);


--
-- Name: use_case_steps_datasets use_case_steps_datasets_step_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.use_case_steps_datasets
    ADD CONSTRAINT use_case_steps_datasets_step_fk FOREIGN KEY (use_case_step_id) REFERENCES public.use_case_steps(id);


--
-- Name: use_case_steps_products use_case_steps_products_product_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.use_case_steps_products
    ADD CONSTRAINT use_case_steps_products_product_fk FOREIGN KEY (product_id) REFERENCES public.products(id);


--
-- Name: use_case_steps_products use_case_steps_products_step_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.use_case_steps_products
    ADD CONSTRAINT use_case_steps_products_step_fk FOREIGN KEY (use_case_step_id) REFERENCES public.use_case_steps(id);


--
-- Name: use_case_steps_workflows use_case_steps_workflows_step_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.use_case_steps_workflows
    ADD CONSTRAINT use_case_steps_workflows_step_fk FOREIGN KEY (use_case_step_id) REFERENCES public.use_case_steps(id);


--
-- Name: use_case_steps_workflows use_case_steps_workflows_workflow_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.use_case_steps_workflows
    ADD CONSTRAINT use_case_steps_workflows_workflow_fk FOREIGN KEY (workflow_id) REFERENCES public.workflows(id);


--
-- Name: use_cases_sdg_targets usecases_sdgs_sdg_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.use_cases_sdg_targets
    ADD CONSTRAINT usecases_sdgs_sdg_fk FOREIGN KEY (sdg_target_id) REFERENCES public.sdg_targets(id);


--
-- Name: use_cases_sdg_targets usecases_sdgs_usecase_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.use_cases_sdg_targets
    ADD CONSTRAINT usecases_sdgs_usecase_fk FOREIGN KEY (use_case_id) REFERENCES public.use_cases(id);


--
-- Name: users user_organization_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT user_organization_fk FOREIGN KEY (organization_id) REFERENCES public.organizations(id);


--
-- Name: workflows_building_blocks workflows_bbs_bb_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.workflows_building_blocks
    ADD CONSTRAINT workflows_bbs_bb_fk FOREIGN KEY (building_block_id) REFERENCES public.building_blocks(id);


--
-- Name: workflows_building_blocks workflows_bbs_workflow_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.workflows_building_blocks
    ADD CONSTRAINT workflows_bbs_workflow_fk FOREIGN KEY (workflow_id) REFERENCES public.workflows(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20181113155844'),
('20181116184335'),
('20190122191834'),
('20190122193631'),
('20190128214040'),
('20190329164159'),
('20190405161615'),
('20190408152727'),
('20190410153048'),
('20190413143731'),
('20190413162159'),
('20190515140930'),
('20190521161155'),
('20190521173413'),
('20190531134352'),
('20190531152352'),
('20190531152718'),
('20190531152933'),
('20190619211133'),
('20190621203306'),
('20190628163911'),
('20190709135659'),
('20190717173408'),
('20190718180634'),
('20190723183059'),
('20190724230850'),
('20190725134908'),
('20190725134957'),
('20190729131806'),
('20190730143658'),
('20190730154937'),
('20190730155346'),
('20190731195112'),
('20190801194208'),
('20190801200432'),
('20190805145805'),
('20190805161659'),
('20190909152506'),
('20190909191546'),
('20190909195732'),
('20190911150425'),
('20190911194639'),
('20190913164128'),
('20190916175633'),
('20191022134914'),
('20191028211046'),
('20191030125538'),
('20191030153507'),
('20191104191625'),
('20191111123008'),
('20191114192918'),
('20191206145611'),
('20191206150613'),
('20191210210550'),
('20200105125805'),
('20200107135217'),
('20200110151548'),
('20200128154358'),
('20200128204056'),
('20200130220904'),
('20200130221126'),
('20200205210606'),
('20200218150006'),
('20200220202959'),
('20200220203026'),
('20200224225410'),
('20200224225415'),
('20200303191546'),
('20200318153113'),
('20200403183400'),
('20200408151430'),
('20200409175231'),
('20200410181908'),
('20200413175913'),
('20200413181640'),
('20200415182207'),
('20200415182431'),
('20200416142235'),
('20200428155300'),
('20200428234311'),
('20200429220626'),
('20200501143924'),
('20200503141314'),
('20200506174132'),
('20200506174133'),
('20200506175410'),
('20200506193433'),
('20200506193935'),
('20200506194951'),
('20200506195001'),
('20200515185037'),
('20200515191241'),
('20200515191251'),
('20200520192948'),
('20200521210943'),
('20200522192632'),
('20200522194438'),
('20200526195946'),
('20200526203504'),
('20200603140902'),
('20200608194733'),
('20200609130507'),
('20200617174313'),
('20200617174358'),
('20200617174412'),
('20200619171341'),
('20200619172658'),
('20200619172716'),
('20200623203503'),
('20200624170721'),
('20200624212546'),
('20200624212630'),
('20200707130426'),
('20200707130945'),
('20200708180807'),
('20200708181616'),
('20200710205315'),
('20200710205316'),
('20200710210144'),
('20200727155410'),
('20200729150759'),
('20200729202732'),
('20200730195836'),
('20200804184953'),
('20200811135839'),
('20200811142114'),
('20200811143421'),
('20200811150942'),
('20200811181245'),
('20200812012621'),
('20200812012757'),
('20200812014644'),
('20200812014739'),
('20200812015747'),
('20200812155025'),
('20200814184009'),
('20200818153517'),
('20200818202930'),
('20200818203509'),
('20200819002149'),
('20200819201841'),
('20200824180728'),
('20200824180910'),
('20200825202250'),
('20200825202909'),
('20200826134558'),
('20200826134741'),
('20200826134916'),
('20200826205015'),
('20200831211606'),
('20200904163226'),
('20200916213058'),
('20200922195357'),
('20200924233939'),
('20201006172734'),
('20201021202217'),
('20201103202113'),
('20201123194715'),
('20201125162851'),
('20201211182046'),
('20201214204504'),
('20201221140408'),
('20210119164809'),
('20210119164830'),
('20210212145950'),
('20210302210015'),
('20210303151833'),
('20210420200744'),
('20210520172450'),
('20210716133929'),
('20210716134544'),
('20210716203940'),
('20210719194336'),
('20210901203528'),
('20210915210109'),
('20211025214450'),
('20211112153426'),
('20211116173721'),
('20211130142532'),
('20211203023930'),
('20211203193339'),
('20220114212158'),
('20220309190707'),
('20220316170226'),
('20220404230635'),
('20220427215908'),
('20220428193227'),
('20220519205858'),
('20220624201750'),
('20220629054904'),
('20220712054023'),
('20220722063623'),
('20220803183512'),
('20220817061256'),
('20220817062227'),
('20220825102332'),
('20220902075138'),
('20220909073617'),
('20220909100954'),
('20220909101028'),
('20220916115012'),
('20220923161216'),
('20220930090351'),
('20221018015421'),
('20221018202451'),
('20221018203042'),
('20221102104046'),
('20221208074203'),
('20221216075319'),
('20221220085731'),
('20221227105319'),
('20221227105322'),
('20230123155236'),
('20230308023907'),
('20230308024946'),
('20230314191751'),
('20230321132329'),
('20230321142940'),
('20230322141250'),
('20230327224648'),
('20230403213850'),
('20230403213927'),
('20230420032636'),
('20230424122850'),
('20230508150944'),
('20230508150945'),
('20230508150946'),
('20230511202225'),
('20230530143937'),
('20230530144123'),
('20230605183013'),
('20230605202219'),
('20230605203819'),
('20230605203844'),
('20230612203109'),
('20230613201202'),
('20230710193223'),
('20230811182920'),
('20230814213722'),
('20230815093725'),
('20230816123325'),
('20230822215103'),
('20230912211315'),
('20230928214508'),
('20230928215346'),
('20230929140735'),
('20231004184941'),
('20231030214704'),
('20231103194201'),
('20231128225429'),
('20231201214658'),
('20231207212017'),
('20231209110335'),
('20231211144224'),
('20240104215749'),
('20240109024648'),
('20240118161746'),
('20240121042516'),
('20240123162741'),
('20240202213701'),
('20240203165039'),
('20240203165141'),
('20240203190751'),
('20240213054529'),
('20240306182144'),
('20240404132644'),
('20240509183558'),
('20240509191953'),
('20240524211025'),
('20240530150308'),
('20240530154604'),
('20240605130949'),
('20240605184914'),
('20240606205817'),
('20240609191249'),
('20240624192517'),
('20240624193953'),
('20240624203205'),
('20240625122716'),
('20240703124148'),
('20240712135449'),
('20240721194811'),
('20240806130712'),
('20240814120047'),
('20240827181759'),
('20240827184119'),
('20240830132609'),
('20240927093418'),
('20240927122349');


