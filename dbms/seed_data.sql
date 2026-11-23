--
-- PostgreSQL database dump
--

\restrict BDNkAUo6es8CMi8CJH1fPwcU7hcFQFMQ7hGPAxA2eUAU8Op4NPLENS6340BoqIE

-- Dumped from database version 18.6 (Postgres.app)
-- Dumped by pg_dump version 18.6 (Postgres.app)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Data for Name: amenities; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.amenities (id, name, icon, created_at) VALUES (1, 'Wi-Fi', 'wifi', '2026-11-19 14:02:42.09');
INSERT INTO public.amenities (id, name, icon, created_at) VALUES (2, 'Projector', 'projector', '2026-11-19 14:02:42.091');
INSERT INTO public.amenities (id, name, icon, created_at) VALUES (3, 'Whiteboard', 'whiteboard', '2026-11-19 14:02:42.091');
INSERT INTO public.amenities (id, name, icon, created_at) VALUES (4, 'Air conditioning', 'snowflake', '2026-11-19 14:02:42.092');
INSERT INTO public.amenities (id, name, icon, created_at) VALUES (5, 'Power backup', 'battery', '2026-11-19 14:02:42.092');
INSERT INTO public.amenities (id, name, icon, created_at) VALUES (6, 'Parking', 'car', '2026-11-19 14:02:42.093');
INSERT INTO public.amenities (id, name, icon, created_at) VALUES (7, 'Wheelchair access', 'accessibility', '2026-11-19 14:02:42.093');
INSERT INTO public.amenities (id, name, icon, created_at) VALUES (8, 'Pantry', 'coffee', '2026-11-19 14:02:42.094');
INSERT INTO public.amenities (id, name, icon, created_at) VALUES (9, 'Ring light', 'light', '2026-11-19 14:02:42.094');
INSERT INTO public.amenities (id, name, icon, created_at) VALUES (10, 'Sound system', 'speaker', '2026-11-19 14:02:42.094');
INSERT INTO public.amenities (id, name, icon, created_at) VALUES (11, 'CCTV', 'camera', '2026-11-19 14:02:42.094');
INSERT INTO public.amenities (id, name, icon, created_at) VALUES (12, 'EV charging', 'plug', '2026-11-19 14:02:42.095');


--
-- Data for Name: cities; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.cities (id, name, state, country, created_at, updated_at) VALUES (1, 'Bengaluru', 'Karnataka', 'India', '2026-11-19 14:02:42.08', '2026-11-19 14:02:42.08');
INSERT INTO public.cities (id, name, state, country, created_at, updated_at) VALUES (2, 'Mumbai', 'Maharashtra', 'India', '2026-11-19 14:02:42.087', '2026-11-19 14:02:42.087');
INSERT INTO public.cities (id, name, state, country, created_at, updated_at) VALUES (3, 'New Delhi', 'Delhi', 'India', '2026-11-19 14:02:42.088', '2026-11-19 14:02:42.088');
INSERT INTO public.cities (id, name, state, country, created_at, updated_at) VALUES (4, 'Pune', 'Maharashtra', 'India', '2026-11-19 14:02:42.088', '2026-11-19 14:02:42.088');
INSERT INTO public.cities (id, name, state, country, created_at, updated_at) VALUES (5, 'Hyderabad', 'Telangana', 'India', '2026-11-19 14:02:42.089', '2026-11-19 14:02:42.089');


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.users (id, email, phone, password_hash, full_name, avatar_url, role, is_active, created_at, updated_at) VALUES (1, 'admin@spacecare.in', NULL, 'scrypt$60e23e59ac5fe061879c7971c5a7b0d3$76a44ec8745796da3ad3fa2bf2d3173ed9993c0ffb8ff69347f7f45ebc08a71807270824085eb9e5ad1de973be9e608ed0cebd9391178572177586ab36ce5a22', 'SpaceCare Admin', NULL, 'ADMIN', true, '2026-11-19 14:02:42.096', '2026-11-19 14:02:42.096');
INSERT INTO public.users (id, email, phone, password_hash, full_name, avatar_url, role, is_active, created_at, updated_at) VALUES (2, 'rohan.mehta@example.com', '+919800000001', 'scrypt$60e23e59ac5fe061879c7971c5a7b0d3$76a44ec8745796da3ad3fa2bf2d3173ed9993c0ffb8ff69347f7f45ebc08a71807270824085eb9e5ad1de973be9e608ed0cebd9391178572177586ab36ce5a22', 'Rohan Mehta', NULL, 'OWNER', true, '2026-11-19 14:02:42.107', '2026-11-19 14:02:42.107');
INSERT INTO public.users (id, email, phone, password_hash, full_name, avatar_url, role, is_active, created_at, updated_at) VALUES (3, 'ananya.iyer@example.com', '+919800000002', 'scrypt$60e23e59ac5fe061879c7971c5a7b0d3$76a44ec8745796da3ad3fa2bf2d3173ed9993c0ffb8ff69347f7f45ebc08a71807270824085eb9e5ad1de973be9e608ed0cebd9391178572177586ab36ce5a22', 'Ananya Iyer', NULL, 'OWNER', true, '2026-11-19 14:02:42.112', '2026-11-19 14:02:42.112');
INSERT INTO public.users (id, email, phone, password_hash, full_name, avatar_url, role, is_active, created_at, updated_at) VALUES (4, 'vikram.singh@example.com', '+919800000003', 'scrypt$60e23e59ac5fe061879c7971c5a7b0d3$76a44ec8745796da3ad3fa2bf2d3173ed9993c0ffb8ff69347f7f45ebc08a71807270824085eb9e5ad1de973be9e608ed0cebd9391178572177586ab36ce5a22', 'Vikram Singh', NULL, 'OWNER', true, '2026-11-19 14:02:42.115', '2026-11-19 14:02:42.115');
INSERT INTO public.users (id, email, phone, password_hash, full_name, avatar_url, role, is_active, created_at, updated_at) VALUES (5, 'priya.sharma@example.com', '+919811111101', 'scrypt$60e23e59ac5fe061879c7971c5a7b0d3$76a44ec8745796da3ad3fa2bf2d3173ed9993c0ffb8ff69347f7f45ebc08a71807270824085eb9e5ad1de973be9e608ed0cebd9391178572177586ab36ce5a22', 'Priya Sharma', NULL, 'RENTER', true, '2026-11-19 14:02:42.116', '2026-11-19 14:02:42.116');
INSERT INTO public.users (id, email, phone, password_hash, full_name, avatar_url, role, is_active, created_at, updated_at) VALUES (6, 'arjun.nair@example.com', '+919811111102', 'scrypt$60e23e59ac5fe061879c7971c5a7b0d3$76a44ec8745796da3ad3fa2bf2d3173ed9993c0ffb8ff69347f7f45ebc08a71807270824085eb9e5ad1de973be9e608ed0cebd9391178572177586ab36ce5a22', 'Arjun Nair', NULL, 'RENTER', true, '2026-11-19 14:02:42.117', '2026-11-19 14:02:42.117');
INSERT INTO public.users (id, email, phone, password_hash, full_name, avatar_url, role, is_active, created_at, updated_at) VALUES (7, 'sneha.kulkarni@example.com', '+919811111103', 'scrypt$60e23e59ac5fe061879c7971c5a7b0d3$76a44ec8745796da3ad3fa2bf2d3173ed9993c0ffb8ff69347f7f45ebc08a71807270824085eb9e5ad1de973be9e608ed0cebd9391178572177586ab36ce5a22', 'Sneha Kulkarni', NULL, 'RENTER', true, '2026-11-19 14:02:42.118', '2026-11-19 14:02:42.118');
INSERT INTO public.users (id, email, phone, password_hash, full_name, avatar_url, role, is_active, created_at, updated_at) VALUES (8, 'kabir.khan@example.com', NULL, 'scrypt$60e23e59ac5fe061879c7971c5a7b0d3$76a44ec8745796da3ad3fa2bf2d3173ed9993c0ffb8ff69347f7f45ebc08a71807270824085eb9e5ad1de973be9e608ed0cebd9391178572177586ab36ce5a22', 'Kabir Khan', NULL, 'RENTER', true, '2026-11-19 14:02:42.119', '2026-11-19 14:02:42.119');


--
-- Data for Name: owner_profiles; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.owner_profiles (id, user_id, business_name, bio, gst_number, verification_status, verified_at, created_at, updated_at) VALUES (1, 2, 'Mehta Workspaces', 'Two floors of meeting rooms in Koramangala.', '29ABCDE1234F1Z5', 'VERIFIED', '2026-09-20 10:00:00', '2026-11-19 14:02:42.107', '2026-11-19 14:02:42.107');
INSERT INTO public.owner_profiles (id, user_id, business_name, bio, gst_number, verification_status, verified_at, created_at, updated_at) VALUES (2, 3, 'Frame & Light Studios', 'Photographer renting out my studio on weekdays.', NULL, 'VERIFIED', '2026-10-10 10:00:00', '2026-11-19 14:02:42.112', '2026-11-19 14:02:42.112');
INSERT INTO public.owner_profiles (id, user_id, business_name, bio, gst_number, verification_status, verified_at, created_at, updated_at) VALUES (3, 4, NULL, 'Spare shopfront and parking near Connaught Place.', NULL, 'PENDING', NULL, '2026-11-19 14:02:42.115', '2026-11-19 14:02:42.115');


--
-- Data for Name: spaces; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.spaces (id, owner_id, city_id, title, slug, description, type, status, address_line1, address_line2, postal_code, latitude, longitude, capacity, area_sqft, price_per_hour, price_per_day, cleaning_fee, currency, min_booking_hours, instant_book, created_at, updated_at) VALUES (1, 1, 1, '12-seat boardroom in Koramangala', 'koramangala-12-seat-boardroom', 'Glass-walled boardroom with a 75" screen, video-conferencing kit and filter coffee on tap.', 'MEETING_ROOM', 'ACTIVE', '4th Floor, 80 Feet Road, Koramangala 4th Block', NULL, '560034', 12.934533, 77.626579, 12, 450, 899.00, 6500.00, 300.00, 'INR', 2, true, '2026-11-19 14:02:42.126', '2026-11-19 14:02:42.126');
INSERT INTO public.spaces (id, owner_id, city_id, title, slug, description, type, status, address_line1, address_line2, postal_code, latitude, longitude, capacity, area_sqft, price_per_hour, price_per_day, cleaning_fee, currency, min_booking_hours, instant_book, created_at, updated_at) VALUES (2, 1, 1, 'Workshop hall for 40 in Indiranagar', 'indiranagar-workshop-hall-40', 'Flexible open hall with movable tables, ideal for workshops, bootcamps and offsites.', 'WORKSHOP', 'ACTIVE', '212, 100 Feet Road, Indiranagar', NULL, '560038', 12.971891, 77.641151, 40, 1400, 2200.00, 15000.00, 800.00, 'INR', 3, false, '2026-11-19 14:02:42.139', '2026-11-19 14:02:42.139');
INSERT INTO public.spaces (id, owner_id, city_id, title, slug, description, type, status, address_line1, address_line2, postal_code, latitude, longitude, capacity, area_sqft, price_per_hour, price_per_day, cleaning_fee, currency, min_booking_hours, instant_book, created_at, updated_at) VALUES (3, 2, 2, 'Natural-light photo & video studio, Bandra', 'bandra-natural-light-studio', 'Cyclorama wall, north-facing windows and a styling corner. Great for reels and product shoots.', 'STUDIO', 'ACTIVE', 'Unit 3, Pali Hill Road, Bandra West', NULL, '400050', 19.068134, 72.826797, 8, 700, 1500.00, 10000.00, 500.00, 'INR', 2, true, '2026-11-19 14:02:42.148', '2026-11-19 14:02:42.148');
INSERT INTO public.spaces (id, owner_id, city_id, title, slug, description, type, status, address_line1, address_line2, postal_code, latitude, longitude, capacity, area_sqft, price_per_hour, price_per_day, cleaning_fee, currency, min_booking_hours, instant_book, created_at, updated_at) VALUES (4, 3, 3, 'Street-facing pop-up shopfront, Connaught Place', 'cp-popup-shopfront', 'Ground-floor 300 sq ft unit with glass frontage and heavy weekend footfall.', 'POP_UP_STORE', 'ACTIVE', 'Shop 14, Block E, Inner Circle, Connaught Place', NULL, '110001', 28.632735, 77.219696, 15, 300, NULL, 7500.00, 1000.00, 'INR', 24, false, '2026-11-19 14:02:42.158', '2026-11-19 14:02:42.158');
INSERT INTO public.spaces (id, owner_id, city_id, title, slug, description, type, status, address_line1, address_line2, postal_code, latitude, longitude, capacity, area_sqft, price_per_hour, price_per_day, cleaning_fee, currency, min_booking_hours, instant_book, created_at, updated_at) VALUES (5, 3, 3, 'Covered parking bay with EV charger', 'cp-covered-parking-ev', 'Secure basement bay, 24x7 guard, 7 kW EV charger included.', 'PARKING', 'ACTIVE', 'Basement, Barakhamba Road', NULL, '110001', 28.629410, 77.224533, 1, NULL, 60.00, 400.00, 0.00, 'INR', 1, true, '2026-11-19 14:02:42.165', '2026-11-19 14:02:42.165');
INSERT INTO public.spaces (id, owner_id, city_id, title, slug, description, type, status, address_line1, address_line2, postal_code, latitude, longitude, capacity, area_sqft, price_per_hour, price_per_day, cleaning_fee, currency, min_booking_hours, instant_book, created_at, updated_at) VALUES (6, 2, 4, 'Quiet co-working desk pod, Koregaon Park', 'kp-coworking-pod', 'Six-desk pod with ergonomic chairs. Draft listing: photos coming soon.', 'COWORKING', 'DRAFT', 'Lane 6, Koregaon Park', NULL, '411001', 18.536209, 73.893975, 6, 350, 250.00, 1500.00, 0.00, 'INR', 1, false, '2026-11-19 14:02:42.171', '2026-11-19 14:02:42.171');


--
-- Data for Name: availability_rules; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.availability_rules (id, space_id, day_of_week, opens_at, closes_at, created_at, updated_at) VALUES (1, 1, 1, '08:00:00', '21:00:00', '2026-11-19 14:02:42.126', '2026-11-19 14:02:42.126');
INSERT INTO public.availability_rules (id, space_id, day_of_week, opens_at, closes_at, created_at, updated_at) VALUES (2, 1, 2, '08:00:00', '21:00:00', '2026-11-19 14:02:42.126', '2026-11-19 14:02:42.126');
INSERT INTO public.availability_rules (id, space_id, day_of_week, opens_at, closes_at, created_at, updated_at) VALUES (3, 1, 3, '08:00:00', '21:00:00', '2026-11-19 14:02:42.126', '2026-11-19 14:02:42.126');
INSERT INTO public.availability_rules (id, space_id, day_of_week, opens_at, closes_at, created_at, updated_at) VALUES (4, 1, 4, '08:00:00', '21:00:00', '2026-11-19 14:02:42.126', '2026-11-19 14:02:42.126');
INSERT INTO public.availability_rules (id, space_id, day_of_week, opens_at, closes_at, created_at, updated_at) VALUES (5, 1, 5, '08:00:00', '21:00:00', '2026-11-19 14:02:42.126', '2026-11-19 14:02:42.126');
INSERT INTO public.availability_rules (id, space_id, day_of_week, opens_at, closes_at, created_at, updated_at) VALUES (6, 2, 0, '09:00:00', '22:00:00', '2026-11-19 14:02:42.139', '2026-11-19 14:02:42.139');
INSERT INTO public.availability_rules (id, space_id, day_of_week, opens_at, closes_at, created_at, updated_at) VALUES (7, 2, 1, '09:00:00', '22:00:00', '2026-11-19 14:02:42.139', '2026-11-19 14:02:42.139');
INSERT INTO public.availability_rules (id, space_id, day_of_week, opens_at, closes_at, created_at, updated_at) VALUES (8, 2, 2, '09:00:00', '22:00:00', '2026-11-19 14:02:42.139', '2026-11-19 14:02:42.139');
INSERT INTO public.availability_rules (id, space_id, day_of_week, opens_at, closes_at, created_at, updated_at) VALUES (9, 2, 3, '09:00:00', '22:00:00', '2026-11-19 14:02:42.139', '2026-11-19 14:02:42.139');
INSERT INTO public.availability_rules (id, space_id, day_of_week, opens_at, closes_at, created_at, updated_at) VALUES (10, 2, 4, '09:00:00', '22:00:00', '2026-11-19 14:02:42.139', '2026-11-19 14:02:42.139');
INSERT INTO public.availability_rules (id, space_id, day_of_week, opens_at, closes_at, created_at, updated_at) VALUES (11, 2, 5, '09:00:00', '22:00:00', '2026-11-19 14:02:42.139', '2026-11-19 14:02:42.139');
INSERT INTO public.availability_rules (id, space_id, day_of_week, opens_at, closes_at, created_at, updated_at) VALUES (12, 2, 6, '09:00:00', '22:00:00', '2026-11-19 14:02:42.139', '2026-11-19 14:02:42.139');
INSERT INTO public.availability_rules (id, space_id, day_of_week, opens_at, closes_at, created_at, updated_at) VALUES (13, 3, 0, '07:00:00', '20:00:00', '2026-11-19 14:02:42.148', '2026-11-19 14:02:42.148');
INSERT INTO public.availability_rules (id, space_id, day_of_week, opens_at, closes_at, created_at, updated_at) VALUES (14, 3, 1, '07:00:00', '20:00:00', '2026-11-19 14:02:42.148', '2026-11-19 14:02:42.148');
INSERT INTO public.availability_rules (id, space_id, day_of_week, opens_at, closes_at, created_at, updated_at) VALUES (15, 3, 2, '07:00:00', '20:00:00', '2026-11-19 14:02:42.148', '2026-11-19 14:02:42.148');
INSERT INTO public.availability_rules (id, space_id, day_of_week, opens_at, closes_at, created_at, updated_at) VALUES (16, 3, 3, '07:00:00', '20:00:00', '2026-11-19 14:02:42.148', '2026-11-19 14:02:42.148');
INSERT INTO public.availability_rules (id, space_id, day_of_week, opens_at, closes_at, created_at, updated_at) VALUES (17, 3, 4, '07:00:00', '20:00:00', '2026-11-19 14:02:42.148', '2026-11-19 14:02:42.148');
INSERT INTO public.availability_rules (id, space_id, day_of_week, opens_at, closes_at, created_at, updated_at) VALUES (18, 3, 5, '07:00:00', '20:00:00', '2026-11-19 14:02:42.148', '2026-11-19 14:02:42.148');
INSERT INTO public.availability_rules (id, space_id, day_of_week, opens_at, closes_at, created_at, updated_at) VALUES (19, 3, 6, '07:00:00', '20:00:00', '2026-11-19 14:02:42.148', '2026-11-19 14:02:42.148');
INSERT INTO public.availability_rules (id, space_id, day_of_week, opens_at, closes_at, created_at, updated_at) VALUES (20, 4, 0, '10:00:00', '21:00:00', '2026-11-19 14:02:42.158', '2026-11-19 14:02:42.158');
INSERT INTO public.availability_rules (id, space_id, day_of_week, opens_at, closes_at, created_at, updated_at) VALUES (21, 4, 1, '10:00:00', '21:00:00', '2026-11-19 14:02:42.158', '2026-11-19 14:02:42.158');
INSERT INTO public.availability_rules (id, space_id, day_of_week, opens_at, closes_at, created_at, updated_at) VALUES (22, 4, 2, '10:00:00', '21:00:00', '2026-11-19 14:02:42.158', '2026-11-19 14:02:42.158');
INSERT INTO public.availability_rules (id, space_id, day_of_week, opens_at, closes_at, created_at, updated_at) VALUES (23, 4, 3, '10:00:00', '21:00:00', '2026-11-19 14:02:42.158', '2026-11-19 14:02:42.158');
INSERT INTO public.availability_rules (id, space_id, day_of_week, opens_at, closes_at, created_at, updated_at) VALUES (24, 4, 4, '10:00:00', '21:00:00', '2026-11-19 14:02:42.158', '2026-11-19 14:02:42.158');
INSERT INTO public.availability_rules (id, space_id, day_of_week, opens_at, closes_at, created_at, updated_at) VALUES (25, 4, 5, '10:00:00', '21:00:00', '2026-11-19 14:02:42.158', '2026-11-19 14:02:42.158');
INSERT INTO public.availability_rules (id, space_id, day_of_week, opens_at, closes_at, created_at, updated_at) VALUES (26, 4, 6, '10:00:00', '21:00:00', '2026-11-19 14:02:42.158', '2026-11-19 14:02:42.158');
INSERT INTO public.availability_rules (id, space_id, day_of_week, opens_at, closes_at, created_at, updated_at) VALUES (27, 5, 0, '00:00:00', '23:59:00', '2026-11-19 14:02:42.165', '2026-11-19 14:02:42.165');
INSERT INTO public.availability_rules (id, space_id, day_of_week, opens_at, closes_at, created_at, updated_at) VALUES (28, 5, 1, '00:00:00', '23:59:00', '2026-11-19 14:02:42.165', '2026-11-19 14:02:42.165');
INSERT INTO public.availability_rules (id, space_id, day_of_week, opens_at, closes_at, created_at, updated_at) VALUES (29, 5, 2, '00:00:00', '23:59:00', '2026-11-19 14:02:42.165', '2026-11-19 14:02:42.165');
INSERT INTO public.availability_rules (id, space_id, day_of_week, opens_at, closes_at, created_at, updated_at) VALUES (30, 5, 3, '00:00:00', '23:59:00', '2026-11-19 14:02:42.165', '2026-11-19 14:02:42.165');
INSERT INTO public.availability_rules (id, space_id, day_of_week, opens_at, closes_at, created_at, updated_at) VALUES (31, 5, 4, '00:00:00', '23:59:00', '2026-11-19 14:02:42.165', '2026-11-19 14:02:42.165');
INSERT INTO public.availability_rules (id, space_id, day_of_week, opens_at, closes_at, created_at, updated_at) VALUES (32, 5, 5, '00:00:00', '23:59:00', '2026-11-19 14:02:42.165', '2026-11-19 14:02:42.165');
INSERT INTO public.availability_rules (id, space_id, day_of_week, opens_at, closes_at, created_at, updated_at) VALUES (33, 5, 6, '00:00:00', '23:59:00', '2026-11-19 14:02:42.165', '2026-11-19 14:02:42.165');
INSERT INTO public.availability_rules (id, space_id, day_of_week, opens_at, closes_at, created_at, updated_at) VALUES (34, 6, 1, '09:00:00', '19:00:00', '2026-11-19 14:02:42.171', '2026-11-19 14:02:42.171');
INSERT INTO public.availability_rules (id, space_id, day_of_week, opens_at, closes_at, created_at, updated_at) VALUES (35, 6, 2, '09:00:00', '19:00:00', '2026-11-19 14:02:42.171', '2026-11-19 14:02:42.171');
INSERT INTO public.availability_rules (id, space_id, day_of_week, opens_at, closes_at, created_at, updated_at) VALUES (36, 6, 3, '09:00:00', '19:00:00', '2026-11-19 14:02:42.171', '2026-11-19 14:02:42.171');
INSERT INTO public.availability_rules (id, space_id, day_of_week, opens_at, closes_at, created_at, updated_at) VALUES (37, 6, 4, '09:00:00', '19:00:00', '2026-11-19 14:02:42.171', '2026-11-19 14:02:42.171');
INSERT INTO public.availability_rules (id, space_id, day_of_week, opens_at, closes_at, created_at, updated_at) VALUES (38, 6, 5, '09:00:00', '19:00:00', '2026-11-19 14:02:42.171', '2026-11-19 14:02:42.171');


--
-- Data for Name: blocked_slots; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.blocked_slots (id, space_id, starts_at, ends_at, reason, created_at, updated_at) VALUES (1, 1, '2026-11-29 03:00:00+05:30', '2026-11-30 03:00:00+05:30', 'AC servicing', '2026-11-19 14:02:42.175', '2026-11-19 14:02:42.175');
INSERT INTO public.blocked_slots (id, space_id, starts_at, ends_at, reason, created_at, updated_at) VALUES (2, 3, '2026-11-24 02:00:00+05:30', '2026-11-24 14:00:00+05:30', 'Owner''s own shoot', '2026-11-19 14:02:42.175', '2026-11-19 14:02:42.175');


--
-- Data for Name: bookings; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.bookings (id, booking_code, space_id, renter_id, starts_at, ends_at, guests, purpose, status, pricing_unit, unit_price, units, cleaning_fee, service_fee, tax_amount, discount_amount, currency, cancelled_at, cancellation_reason, created_at, updated_at) VALUES (1, 'SC-2026-00001', 1, 5, '2026-11-05 04:00:00+05:30', '2026-11-05 08:00:00+05:30', 9, 'Quarterly investor update', 'COMPLETED', 'HOUR', 899.00, 4, 300.00, 360.00, 712.80, 0.00, 'INR', NULL, NULL, '2026-11-19 14:02:42.178', '2026-11-19 14:02:42.178');
INSERT INTO public.bookings (id, booking_code, space_id, renter_id, starts_at, ends_at, guests, purpose, status, pricing_unit, unit_price, units, cleaning_fee, service_fee, tax_amount, discount_amount, currency, cancelled_at, cancellation_reason, created_at, updated_at) VALUES (2, 'SC-2026-00002', 3, 6, '2026-11-12 03:00:00+05:30', '2026-11-12 09:00:00+05:30', 4, 'Product shoot for a D2C brand', 'COMPLETED', 'HOUR', 1500.00, 6, 500.00, 450.00, 1791.00, 500.00, 'INR', NULL, NULL, '2026-11-19 14:02:42.181', '2026-11-19 14:02:42.181');
INSERT INTO public.bookings (id, booking_code, space_id, renter_id, starts_at, ends_at, guests, purpose, status, pricing_unit, unit_price, units, cleaning_fee, service_fee, tax_amount, discount_amount, currency, cancelled_at, cancellation_reason, created_at, updated_at) VALUES (3, 'SC-2026-00003', 4, 7, '2026-10-29 04:00:00+05:30', '2026-10-31 04:00:00+05:30', 3, 'Weekend handloom pop-up', 'COMPLETED', 'DAY', 7500.00, 2, 1000.00, 800.00, 2988.00, 0.00, 'INR', NULL, NULL, '2026-11-19 14:02:42.183', '2026-11-19 14:02:42.183');
INSERT INTO public.bookings (id, booking_code, space_id, renter_id, starts_at, ends_at, guests, purpose, status, pricing_unit, unit_price, units, cleaning_fee, service_fee, tax_amount, discount_amount, currency, cancelled_at, cancellation_reason, created_at, updated_at) VALUES (4, 'SC-2026-00004', 2, 5, '2026-11-26 04:00:00+05:30', '2026-11-26 12:00:00+05:30', 32, 'Design thinking workshop', 'CONFIRMED', 'HOUR', 2200.00, 8, 800.00, 1760.00, 3628.80, 0.00, 'INR', NULL, NULL, '2026-11-19 14:02:42.185', '2026-11-19 14:02:42.185');
INSERT INTO public.bookings (id, booking_code, space_id, renter_id, starts_at, ends_at, guests, purpose, status, pricing_unit, unit_price, units, cleaning_fee, service_fee, tax_amount, discount_amount, currency, cancelled_at, cancellation_reason, created_at, updated_at) VALUES (5, 'SC-2026-00005', 1, 8, '2026-11-22 05:00:00+05:30', '2026-11-22 07:00:00+05:30', 6, 'Client pitch', 'PENDING', 'HOUR', 899.00, 2, 300.00, 180.00, 410.40, 0.00, 'INR', NULL, NULL, '2026-11-19 14:02:42.187', '2026-11-19 14:02:42.187');
INSERT INTO public.bookings (id, booking_code, space_id, renter_id, starts_at, ends_at, guests, purpose, status, pricing_unit, unit_price, units, cleaning_fee, service_fee, tax_amount, discount_amount, currency, cancelled_at, cancellation_reason, created_at, updated_at) VALUES (6, 'SC-2026-00006', 5, 6, '2026-11-21 02:00:00+05:30', '2026-11-22 02:00:00+05:30', 1, 'Overnight parking', 'CANCELLED', 'DAY', 400.00, 1, 0.00, 40.00, 79.20, 0.00, 'INR', '2026-11-18 08:00:00', 'Plans changed', '2026-11-19 14:02:42.188', '2026-11-19 14:02:42.188');


--
-- Data for Name: conversations; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.conversations (id, space_id, renter_id, created_at, updated_at) VALUES (1, 1, 8, '2026-11-19 14:02:42.2', '2026-11-19 14:02:42.2');


--
-- Data for Name: favourites; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.favourites (user_id, space_id, created_at) VALUES (5, 3, '2026-11-19 14:02:42.197');
INSERT INTO public.favourites (user_id, space_id, created_at) VALUES (5, 2, '2026-11-19 14:02:42.197');
INSERT INTO public.favourites (user_id, space_id, created_at) VALUES (8, 1, '2026-11-19 14:02:42.197');
INSERT INTO public.favourites (user_id, space_id, created_at) VALUES (7, 4, '2026-11-19 14:02:42.197');


--
-- Data for Name: messages; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.messages (id, conversation_id, sender_id, body, read_at, created_at) VALUES (1, 1, 8, 'Hi! Can we bring our own projector adapter (USB-C)?', '2026-11-18 06:00:00', '2026-11-18 05:00:00');
INSERT INTO public.messages (id, conversation_id, sender_id, body, read_at, created_at) VALUES (2, 1, 2, 'Sure. We also keep USB-C and HDMI adapters in the room.', NULL, '2026-11-18 06:00:00');


--
-- Data for Name: payments; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.payments (id, booking_id, kind, method, status, amount, currency, provider_ref, processed_at, created_at, updated_at) VALUES (1, 1, 'CHARGE', 'UPI', 'SUCCEEDED', 4968.80, 'INR', 'pay_SC0001', '2026-11-04 06:00:00', '2026-11-19 14:02:42.189', '2026-11-19 14:02:42.189');
INSERT INTO public.payments (id, booking_id, kind, method, status, amount, currency, provider_ref, processed_at, created_at, updated_at) VALUES (2, 2, 'CHARGE', 'CARD', 'SUCCEEDED', 11241.00, 'INR', 'pay_SC0002', '2026-11-11 06:00:00', '2026-11-19 14:02:42.189', '2026-11-19 14:02:42.189');
INSERT INTO public.payments (id, booking_id, kind, method, status, amount, currency, provider_ref, processed_at, created_at, updated_at) VALUES (3, 3, 'CHARGE', 'NET_BANKING', 'SUCCEEDED', 19788.00, 'INR', 'pay_SC0003', '2026-10-28 06:00:00', '2026-11-19 14:02:42.189', '2026-11-19 14:02:42.189');
INSERT INTO public.payments (id, booking_id, kind, method, status, amount, currency, provider_ref, processed_at, created_at, updated_at) VALUES (4, 4, 'CHARGE', 'UPI', 'FAILED', 23788.80, 'INR', 'pay_SC0004', '2026-11-17 06:00:00', '2026-11-19 14:02:42.189', '2026-11-19 14:02:42.189');
INSERT INTO public.payments (id, booking_id, kind, method, status, amount, currency, provider_ref, processed_at, created_at, updated_at) VALUES (5, 4, 'CHARGE', 'CARD', 'SUCCEEDED', 23788.80, 'INR', 'pay_SC0005', '2026-11-17 07:00:00', '2026-11-19 14:02:42.189', '2026-11-19 14:02:42.189');
INSERT INTO public.payments (id, booking_id, kind, method, status, amount, currency, provider_ref, processed_at, created_at, updated_at) VALUES (6, 6, 'CHARGE', 'WALLET', 'SUCCEEDED', 519.20, 'INR', 'pay_SC0006', '2026-11-16 06:00:00', '2026-11-19 14:02:42.189', '2026-11-19 14:02:42.189');
INSERT INTO public.payments (id, booking_id, kind, method, status, amount, currency, provider_ref, processed_at, created_at, updated_at) VALUES (7, 6, 'REFUND', 'WALLET', 'SUCCEEDED', 519.20, 'INR', 'rfnd_SC0001', '2026-11-18 09:00:00', '2026-11-19 14:02:42.189', '2026-11-19 14:02:42.189');


--
-- Data for Name: reviews; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.reviews (id, booking_id, rating, comment, owner_reply, replied_at, created_at, updated_at) VALUES (1, 1, 5, 'Spotless room and the VC setup just worked.', 'Thanks Priya, see you next quarter!', '2026-11-07 06:00:00', '2026-11-19 14:02:42.193', '2026-11-19 14:02:42.193');
INSERT INTO public.reviews (id, booking_id, rating, comment, owner_reply, replied_at, created_at, updated_at) VALUES (2, 2, 4, 'Lovely light. Parking nearby was tricky.', NULL, NULL, '2026-11-19 14:02:42.193', '2026-11-19 14:02:42.193');
INSERT INTO public.reviews (id, booking_id, rating, comment, owner_reply, replied_at, created_at, updated_at) VALUES (3, 3, 5, 'Great footfall, sold out by Sunday evening.', NULL, NULL, '2026-11-19 14:02:42.193', '2026-11-19 14:02:42.193');


--
-- Data for Name: space_amenities; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.space_amenities (space_id, amenity_id, created_at) VALUES (1, 8, '2026-11-19 14:02:42.126');
INSERT INTO public.space_amenities (space_id, amenity_id, created_at) VALUES (1, 5, '2026-11-19 14:02:42.126');
INSERT INTO public.space_amenities (space_id, amenity_id, created_at) VALUES (1, 4, '2026-11-19 14:02:42.126');
INSERT INTO public.space_amenities (space_id, amenity_id, created_at) VALUES (1, 3, '2026-11-19 14:02:42.126');
INSERT INTO public.space_amenities (space_id, amenity_id, created_at) VALUES (1, 2, '2026-11-19 14:02:42.126');
INSERT INTO public.space_amenities (space_id, amenity_id, created_at) VALUES (1, 1, '2026-11-19 14:02:42.126');
INSERT INTO public.space_amenities (space_id, amenity_id, created_at) VALUES (2, 7, '2026-11-19 14:02:42.139');
INSERT INTO public.space_amenities (space_id, amenity_id, created_at) VALUES (2, 10, '2026-11-19 14:02:42.139');
INSERT INTO public.space_amenities (space_id, amenity_id, created_at) VALUES (2, 4, '2026-11-19 14:02:42.139');
INSERT INTO public.space_amenities (space_id, amenity_id, created_at) VALUES (2, 3, '2026-11-19 14:02:42.139');
INSERT INTO public.space_amenities (space_id, amenity_id, created_at) VALUES (2, 2, '2026-11-19 14:02:42.139');
INSERT INTO public.space_amenities (space_id, amenity_id, created_at) VALUES (2, 1, '2026-11-19 14:02:42.139');
INSERT INTO public.space_amenities (space_id, amenity_id, created_at) VALUES (3, 10, '2026-11-19 14:02:42.148');
INSERT INTO public.space_amenities (space_id, amenity_id, created_at) VALUES (3, 5, '2026-11-19 14:02:42.148');
INSERT INTO public.space_amenities (space_id, amenity_id, created_at) VALUES (3, 9, '2026-11-19 14:02:42.148');
INSERT INTO public.space_amenities (space_id, amenity_id, created_at) VALUES (3, 4, '2026-11-19 14:02:42.148');
INSERT INTO public.space_amenities (space_id, amenity_id, created_at) VALUES (3, 1, '2026-11-19 14:02:42.148');
INSERT INTO public.space_amenities (space_id, amenity_id, created_at) VALUES (4, 5, '2026-11-19 14:02:42.158');
INSERT INTO public.space_amenities (space_id, amenity_id, created_at) VALUES (4, 11, '2026-11-19 14:02:42.158');
INSERT INTO public.space_amenities (space_id, amenity_id, created_at) VALUES (4, 4, '2026-11-19 14:02:42.158');
INSERT INTO public.space_amenities (space_id, amenity_id, created_at) VALUES (4, 1, '2026-11-19 14:02:42.158');
INSERT INTO public.space_amenities (space_id, amenity_id, created_at) VALUES (5, 6, '2026-11-19 14:02:42.165');
INSERT INTO public.space_amenities (space_id, amenity_id, created_at) VALUES (5, 12, '2026-11-19 14:02:42.165');
INSERT INTO public.space_amenities (space_id, amenity_id, created_at) VALUES (5, 11, '2026-11-19 14:02:42.165');
INSERT INTO public.space_amenities (space_id, amenity_id, created_at) VALUES (6, 8, '2026-11-19 14:02:42.171');
INSERT INTO public.space_amenities (space_id, amenity_id, created_at) VALUES (6, 4, '2026-11-19 14:02:42.171');
INSERT INTO public.space_amenities (space_id, amenity_id, created_at) VALUES (6, 1, '2026-11-19 14:02:42.171');


--
-- Data for Name: space_images; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.space_images (id, space_id, url, alt_text, sort_order, is_cover, created_at) VALUES (1, 1, 'https://images.spacecare.example/koramangala-12-seat-boardroom/1.jpg', '12-seat boardroom in Koramangala: photo 1', 0, true, '2026-11-19 14:02:42.126');
INSERT INTO public.space_images (id, space_id, url, alt_text, sort_order, is_cover, created_at) VALUES (2, 1, 'https://images.spacecare.example/koramangala-12-seat-boardroom/2.jpg', '12-seat boardroom in Koramangala: photo 2', 1, false, '2026-11-19 14:02:42.126');
INSERT INTO public.space_images (id, space_id, url, alt_text, sort_order, is_cover, created_at) VALUES (3, 1, 'https://images.spacecare.example/koramangala-12-seat-boardroom/3.jpg', '12-seat boardroom in Koramangala: photo 3', 2, false, '2026-11-19 14:02:42.126');
INSERT INTO public.space_images (id, space_id, url, alt_text, sort_order, is_cover, created_at) VALUES (4, 2, 'https://images.spacecare.example/indiranagar-workshop-hall-40/1.jpg', 'Workshop hall for 40 in Indiranagar: photo 1', 0, true, '2026-11-19 14:02:42.139');
INSERT INTO public.space_images (id, space_id, url, alt_text, sort_order, is_cover, created_at) VALUES (5, 2, 'https://images.spacecare.example/indiranagar-workshop-hall-40/2.jpg', 'Workshop hall for 40 in Indiranagar: photo 2', 1, false, '2026-11-19 14:02:42.139');
INSERT INTO public.space_images (id, space_id, url, alt_text, sort_order, is_cover, created_at) VALUES (6, 2, 'https://images.spacecare.example/indiranagar-workshop-hall-40/3.jpg', 'Workshop hall for 40 in Indiranagar: photo 3', 2, false, '2026-11-19 14:02:42.139');
INSERT INTO public.space_images (id, space_id, url, alt_text, sort_order, is_cover, created_at) VALUES (7, 3, 'https://images.spacecare.example/bandra-natural-light-studio/1.jpg', 'Natural-light photo & video studio, Bandra: photo 1', 0, true, '2026-11-19 14:02:42.148');
INSERT INTO public.space_images (id, space_id, url, alt_text, sort_order, is_cover, created_at) VALUES (8, 3, 'https://images.spacecare.example/bandra-natural-light-studio/2.jpg', 'Natural-light photo & video studio, Bandra: photo 2', 1, false, '2026-11-19 14:02:42.148');
INSERT INTO public.space_images (id, space_id, url, alt_text, sort_order, is_cover, created_at) VALUES (9, 3, 'https://images.spacecare.example/bandra-natural-light-studio/3.jpg', 'Natural-light photo & video studio, Bandra: photo 3', 2, false, '2026-11-19 14:02:42.148');
INSERT INTO public.space_images (id, space_id, url, alt_text, sort_order, is_cover, created_at) VALUES (10, 4, 'https://images.spacecare.example/cp-popup-shopfront/1.jpg', 'Street-facing pop-up shopfront, Connaught Place: photo 1', 0, true, '2026-11-19 14:02:42.158');
INSERT INTO public.space_images (id, space_id, url, alt_text, sort_order, is_cover, created_at) VALUES (11, 4, 'https://images.spacecare.example/cp-popup-shopfront/2.jpg', 'Street-facing pop-up shopfront, Connaught Place: photo 2', 1, false, '2026-11-19 14:02:42.158');
INSERT INTO public.space_images (id, space_id, url, alt_text, sort_order, is_cover, created_at) VALUES (12, 4, 'https://images.spacecare.example/cp-popup-shopfront/3.jpg', 'Street-facing pop-up shopfront, Connaught Place: photo 3', 2, false, '2026-11-19 14:02:42.158');
INSERT INTO public.space_images (id, space_id, url, alt_text, sort_order, is_cover, created_at) VALUES (13, 5, 'https://images.spacecare.example/cp-covered-parking-ev/1.jpg', 'Covered parking bay with EV charger: photo 1', 0, true, '2026-11-19 14:02:42.165');
INSERT INTO public.space_images (id, space_id, url, alt_text, sort_order, is_cover, created_at) VALUES (14, 5, 'https://images.spacecare.example/cp-covered-parking-ev/2.jpg', 'Covered parking bay with EV charger: photo 2', 1, false, '2026-11-19 14:02:42.165');
INSERT INTO public.space_images (id, space_id, url, alt_text, sort_order, is_cover, created_at) VALUES (15, 5, 'https://images.spacecare.example/cp-covered-parking-ev/3.jpg', 'Covered parking bay with EV charger: photo 3', 2, false, '2026-11-19 14:02:42.165');
INSERT INTO public.space_images (id, space_id, url, alt_text, sort_order, is_cover, created_at) VALUES (16, 6, 'https://images.spacecare.example/kp-coworking-pod/1.jpg', 'Quiet co-working desk pod, Koregaon Park: photo 1', 0, true, '2026-11-19 14:02:42.171');
INSERT INTO public.space_images (id, space_id, url, alt_text, sort_order, is_cover, created_at) VALUES (17, 6, 'https://images.spacecare.example/kp-coworking-pod/2.jpg', 'Quiet co-working desk pod, Koregaon Park: photo 2', 1, false, '2026-11-19 14:02:42.171');
INSERT INTO public.space_images (id, space_id, url, alt_text, sort_order, is_cover, created_at) VALUES (18, 6, 'https://images.spacecare.example/kp-coworking-pod/3.jpg', 'Quiet co-working desk pod, Koregaon Park: photo 3', 2, false, '2026-11-19 14:02:42.171');


--
-- Name: amenities_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.amenities_id_seq', 12, true);


--
-- Name: availability_rules_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.availability_rules_id_seq', 38, true);


--
-- Name: blocked_slots_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.blocked_slots_id_seq', 2, true);


--
-- Name: bookings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.bookings_id_seq', 6, true);


--
-- Name: cities_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.cities_id_seq', 5, true);


--
-- Name: conversations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.conversations_id_seq', 1, true);


--
-- Name: messages_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.messages_id_seq', 2, true);


--
-- Name: owner_profiles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.owner_profiles_id_seq', 3, true);


--
-- Name: payments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.payments_id_seq', 7, true);


--
-- Name: reviews_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.reviews_id_seq', 3, true);


--
-- Name: space_images_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.space_images_id_seq', 18, true);


--
-- Name: spaces_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.spaces_id_seq', 6, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.users_id_seq', 8, true);


--
-- PostgreSQL database dump complete
--

\unrestrict BDNkAUo6es8CMi8CJH1fPwcU7hcFQFMQ7hGPAxA2eUAU8Op4NPLENS6340BoqIE

