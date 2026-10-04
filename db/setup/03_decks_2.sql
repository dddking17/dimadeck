do $$
declare
  v_ids uuid[];
begin
select array_agg(d.id order by u.ord)
  into v_ids
  from unnest(array['오메가몬', '황제드라몬 팔라딘모드*(각성)']) with ordinality as u(name, ord)
  join public.digimons d on d.name = u.name;
  if not exists (select 1 from public.decks where name = '강림! 고대의 용전사') then
    insert into public.decks (name, tier, description, effect, member_ids)
    values ('강림! 고대의 용전사', 'C', '', '', v_ids);
  end if;

select array_agg(d.id order by u.ord)
  into v_ids
  from unnest(array['디아블로몬', '아마게몬[합성체]', '황제드라몬 파이터모드*(각성)', '황제드라몬 팔라딘모드*(각성)']) with ordinality as u(name, ord)
  join public.digimons d on d.name = u.name;
  if not exists (select 1 from public.decks where name = '디아블로몬을 저지하라!') then
    insert into public.decks (name, tier, description, effect, member_ids)
    values ('디아블로몬을 저지하라!', 'C', '', '', v_ids);
  end if;

select array_agg(d.id order by u.ord)
  into v_ids
  from unnest(array['오메가몬 머시풀모드']) with ordinality as u(name, ord)
  join public.digimons d on d.name = u.name;
  if not exists (select 1 from public.decks where name = '하얀 날개 : 슬픔과 결의') then
    insert into public.decks (name, tier, description, effect, member_ids)
    values ('하얀 날개 : 슬픔과 결의', 'C', '', '', v_ids);
  end if;

select array_agg(d.id order by u.ord)
  into v_ids
  from unnest(array['쿠즈하몬 무녀모드', '블룸로드몬', '지드밀레니엄몬*(각성)', '에오스몬(궁극체)']) with ordinality as u(name, ord)
  join public.digimons d on d.name = u.name;
  if not exists (select 1 from public.decks where name = '어둠이 드리운 정의') then
    insert into public.decks (name, tier, description, effect, member_ids)
    values ('어둠이 드리운 정의', 'C', '', '', v_ids);
  end if;

select array_agg(d.id order by u.ord)
  into v_ids
  from unnest(array['듀크몬 크림존모드*(각성)', '오메가몬 머시풀모드', '황제드라몬 팔라딘모드*(각성)', '샤우트몬X7 슈페리올모드']) with ordinality as u(name, ord)
  join public.digimons d on d.name = u.name;
  if not exists (select 1 from public.decks where name = '평화를 수호하는 구원자(4U)') then
    insert into public.decks (name, tier, description, effect, member_ids)
    values ('평화를 수호하는 구원자(4U)', 'C', '', '', v_ids);
  end if;

select array_agg(d.id order by u.ord)
  into v_ids
  from unnest(array['시리우스몬', '쿠즈하몬', '쿠즈하몬 무녀모드']) with ordinality as u(name, ord)
  join public.digimons d on d.name = u.name;
  if not exists (select 1 from public.decks where name = '잘못된 정화의 의식') then
    insert into public.decks (name, tier, description, effect, member_ids)
    values ('잘못된 정화의 의식', 'C', '', '', v_ids);
  end if;

select array_agg(d.id order by u.ord)
  into v_ids
  from unnest(array['오메가몬', '알파몬 왕룡검[극의]']) with ordinality as u(name, ord)
  join public.digimons d on d.name = u.name;
  if not exists (select 1 from public.decks where name = '재회') then
    insert into public.decks (name, tier, description, effect, member_ids)
    values ('재회', 'C', '', '', v_ids);
  end if;

select array_agg(d.id order by u.ord)
  into v_ids
  from unnest(array['아그니몬', '페어리몬', '차크몬', '알볼몬', '그로트몬', '볼프몬', '브리츠몬', '라나몬', '레베몬', '머큐레몬', '루체몬 사탄모드[극의]']) with ordinality as u(name, ord)
  join public.digimons d on d.name = u.name;
  if not exists (select 1 from public.decks where name = '현실세계 침공!') then
    insert into public.decks (name, tier, description, effect, member_ids)
    values ('현실세계 침공!', 'C', '', '', v_ids);
  end if;

select array_agg(d.id order by u.ord)
  into v_ids
  from unnest(array['오메가몬', '라스트 에볼루션 : 인연', '에오스몬(궁극체)']) with ordinality as u(name, ord)
  join public.digimons d on d.name = u.name;
  if not exists (select 1 from public.decks where name = '라스트 에볼루션 : 인연') then
    insert into public.decks (name, tier, description, effect, member_ids)
    values ('라스트 에볼루션 : 인연', 'C', '', '', v_ids);
  end if;

select array_agg(d.id order by u.ord)
  into v_ids
  from unnest(array['워그레이몬*(각성)', '메탈가루몬*(각성)', '밀레니엄몬', '지드밀레니엄몬*(각성)', '갓드라몬', '홀리드라몬']) with ordinality as u(name, ord)
  join public.digimons d on d.name = u.name;
  if not exists (select 1 from public.decks where name = '우리들의 희망, 우리들의 빛') then
    insert into public.decks (name, tier, description, effect, member_ids)
    values ('우리들의 희망, 우리들의 빛', 'C', '', '', v_ids);
  end if;

select array_agg(d.id order by u.ord)
  into v_ids
  from unnest(array['브리트라몬', '슈트몬', '블리자몬', '페탈드라몬', '기가스몬', '가룸몬', '볼그몬', '칼마라몬', '카이저레오몬', '세피로트몬', '스사노오몬[극의]']) with ordinality as u(name, ord)
  join public.digimons d on d.name = u.name;
  if not exists (select 1 from public.decks where name = '시간을 뛰어 넘어, 전설의 시작!') then
    insert into public.decks (name, tier, description, effect, member_ids)
    values ('시간을 뛰어 넘어, 전설의 시작!', 'C', '', '', v_ids);
  end if;

select array_agg(d.id order by u.ord)
  into v_ids
  from unnest(array['듀크몬 크림존모드*(각성)', '오메가몬 머시풀모드', '쿠즈하몬 무녀모드', '스사노오몬[극의]', '샤우트몬X7 슈페리올모드']) with ordinality as u(name, ord)
  join public.digimons d on d.name = u.name;
  if not exists (select 1 from public.decks where name = '디지털 월드 수호자(5U)') then
    insert into public.decks (name, tier, description, effect, member_ids)
    values ('디지털 월드 수호자(5U)', 'C', '', '', v_ids);
  end if;

select array_agg(d.id order by u.ord)
  into v_ids
  from unnest(array['듀크몬 크림존모드*(각성)', '오메가몬 머시풀모드', '황제드라몬 팔라딘모드*(각성)', '스사노오몬[극의]', '샤우트몬X7 슈페리올모드']) with ordinality as u(name, ord)
  join public.digimons d on d.name = u.name;
  if not exists (select 1 from public.decks where name = '평화를 수호하는 구원자(5U)') then
    insert into public.decks (name, tier, description, effect, member_ids)
    values ('평화를 수호하는 구원자(5U)', 'C', '', '', v_ids);
  end if;
end $$;
