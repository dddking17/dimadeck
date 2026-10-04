do $$
declare
  v_ids uuid[];
begin
select array_agg(d.id order by u.ord)
  into v_ids
  from unnest(array['쿠즈하몬 무녀모드', '퀀타몬', '샤우트몬X7 슈페리올모드']) with ordinality as u(name, ord)
  join public.digimons d on d.name = u.name;
  if not exists (select 1 from public.decks where name = '중립 성향의 디지몬') then
    insert into public.decks (name, tier, description, effect, member_ids)
    values ('중립 성향의 디지몬', 'C', '', '', v_ids);
  end if;

select array_agg(d.id order by u.ord)
  into v_ids
  from unnest(array['아폴로몬']) with ordinality as u(name, ord)
  join public.digimons d on d.name = u.name;
  if not exists (select 1 from public.decks where name = '광채와 함께 내려온 자') then
    insert into public.decks (name, tier, description, effect, member_ids)
    values ('광채와 함께 내려온 자', 'C', '', '', v_ids);
  end if;

select array_agg(d.id order by u.ord)
  into v_ids
  from unnest(array['아바도몬', '오메가몬 머시풀모드', '다크네스바그라몬', '루체몬 사탄모드[극의]', '스사노오몬[극의]', '아바도몬 코어', '아폴로몬']) with ordinality as u(name, ord)
  join public.digimons d on d.name = u.name;
  if not exists (select 1 from public.decks where name = '절망에 맞서는 광채') then
    insert into public.decks (name, tier, description, effect, member_ids)
    values ('절망에 맞서는 광채', 'C', '', '', v_ids);
  end if;
end $$;
