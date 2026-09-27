-- NISA電卓（nisa.html）用の保存テーブル
-- Supabase ダッシュボード → SQL Editor に貼り付けて「Run」してください（1回だけ）
-- RLS により、各ユーザーは自分の行しか読み書きできません。

create table if not exists public.nisa_settings (
  user_key   uuid primary key references auth.users(id) on delete cascade,
  settings   jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);

alter table public.nisa_settings enable row level security;

drop policy if exists "nisa_select_own" on public.nisa_settings;
drop policy if exists "nisa_insert_own" on public.nisa_settings;
drop policy if exists "nisa_update_own" on public.nisa_settings;
drop policy if exists "nisa_delete_own" on public.nisa_settings;

create policy "nisa_select_own" on public.nisa_settings
  for select to authenticated using (auth.uid() = user_key);
create policy "nisa_insert_own" on public.nisa_settings
  for insert to authenticated with check (auth.uid() = user_key);
create policy "nisa_update_own" on public.nisa_settings
  for update to authenticated using (auth.uid() = user_key) with check (auth.uid() = user_key);
create policy "nisa_delete_own" on public.nisa_settings
  for delete to authenticated using (auth.uid() = user_key);
