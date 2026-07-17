-- ============================================================
-- TNA Survey — Supabase schema
-- Run this once in: Supabase Dashboard -> SQL Editor -> New query -> Run
-- ============================================================

create extension if not exists "pgcrypto";

create table if not exists tna_responses (
  id          uuid primary key default gen_random_uuid(),
  created_at  timestamptz not null default now(),
  lang        text not null,          -- 'vi' or 'en'
  fullname    text,
  role        text,
  staff_type  text,
  q1          text,
  q2          int,
  q3          jsonb,                  -- {"0":3,"1":4,...} knowledge score per topic index
  q4          text[],
  q4_other    text,
  q5          text,
  q6          text,
  q7          jsonb,                  -- {"0":5,"1":2,...} interest score per topic index
  q8          int,
  q9          text[],
  q9_other    text,
  q10         text[],
  q10_other   text,
  q11         text,
  q12         text,
  q13         text,
  q14         text[],
  q15         text,
  q16         text
);

alter table tna_responses enable row level security;

-- Allow the survey form (anon key) to insert new responses
drop policy if exists "tna_responses_insert_anon" on tna_responses;
create policy "tna_responses_insert_anon"
  on tna_responses for insert
  to anon
  with check (true);

-- Allow the live results page (anon key) to read responses
drop policy if exists "tna_responses_select_anon" on tna_responses;
create policy "tna_responses_select_anon"
  on tna_responses for select
  to anon
  using (true);

-- ============================================================
-- Privacy note: the anon key is public (it ships inside the
-- website's JavaScript), so anyone with the results/survey link
-- and a browser devtools can technically read this table,
-- including "fullname" and "role". Only share the results link
-- with the intended HRBP team, and treat it the same way you'd
-- treat the raw survey spreadsheet.
-- ============================================================
