do $$
declare
  v_ids uuid[];
begin
select array_agg(d.id order by u.ord)
  into v_ids
  from unnest(array['알파몬 왕룡검[극의]', '리리스몬X [각성]']) with ordinality as u(name, ord)
  join public.digimons d on d.name = u.name;
  if not exists (select 1 from public.decks where name = '매혹적인 날개와 정의의 날개') then
    insert into public.decks (name, tier, description, effect, member_ids)
    values ('매혹적인 날개와 정의의 날개', 'C', '', '', v_ids);
  end if;

select array_agg(d.id order by u.ord)
  into v_ids
  from unnest(array['메탈그레이몬', '워가루몬', '파워드라몬', '던데블몬']) with ordinality as u(name, ord)
  join public.digimons d on d.name = u.name;
  if not exists (select 1 from public.decks where name = '종극의 악마') then
    insert into public.decks (name, tier, description, effect, member_ids)
    values ('종극의 악마', 'C', '', '', v_ids);
  end if;

select array_agg(d.id order by u.ord)
  into v_ids
  from unnest(array['듀크몬 크림존모드*(각성)', '지드밀레니엄몬*(각성)', '루체몬 사탄모드[극의]', '리리스몬X [각성]', '던데블몬']) with ordinality as u(name, ord)
  join public.digimons d on d.name = u.name;
  if not exists (select 1 from public.decks where name = '이상 상태 발생 : 바이러스') then
    insert into public.decks (name, tier, description, effect, member_ids)
    values ('이상 상태 발생 : 바이러스', 'C', '', '', v_ids);
  end if;

select array_agg(d.id order by u.ord)
  into v_ids
  from unnest(array['오메가몬 머시풀모드', '블룸로드몬', '황제드라몬 팔라딘모드*(각성)', '알파몬 왕룡검[극의]', '갓드라몬']) with ordinality as u(name, ord)
  join public.digimons d on d.name = u.name;
  if not exists (select 1 from public.decks where name = '바이러스에 대항하라!') then
    insert into public.decks (name, tier, description, effect, member_ids)
    values ('바이러스에 대항하라!', 'C', '', '', v_ids);
  end if;

select array_agg(d.id order by u.ord)
  into v_ids
  from unnest(array['세라피몬', '바이킹몬', '헤라클레스캅테리몬', '페닉스몬', '로제몬', '워그레이몬*(각성)', '메탈가루몬*(각성)', '아바도몬', '오파니몬']) with ordinality as u(name, ord)
  join public.digimons d on d.name = u.name;
  if not exists (select 1 from public.decks where name = '거대한 파멸의 위기') then
    insert into public.decks (name, tier, description, effect, member_ids)
    values ('거대한 파멸의 위기', 'C', '', '', v_ids);
  end if;

select array_agg(d.id order by u.ord)
  into v_ids
  from unnest(array['아바도몬', '아바도몬 코어']) with ordinality as u(name, ord)
  join public.digimons d on d.name = u.name;
  if not exists (select 1 from public.decks where name = '심연의 공포') then
    insert into public.decks (name, tier, description, effect, member_ids)
    values ('심연의 공포', 'C', '', '', v_ids);
  end if;

select array_agg(d.id order by u.ord)
  into v_ids
  from unnest(array['아바도몬', '쿠즈하몬 무녀모드', '라스트 에볼루션 : 인연', '아바도몬 코어', '에오스몬(궁극체)', '샤우트몬X7 슈페리올모드']) with ordinality as u(name, ord)
  join public.digimons d on d.name = u.name;
  if not exists (select 1 from public.decks where name = '온전한 데이터, 그리고 정체 불명의 데이터') then
    insert into public.decks (name, tier, description, effect, member_ids)
    values ('온전한 데이터, 그리고 정체 불명의 데이터', 'C', '', '', v_ids);
  end if;

select array_agg(d.id order by u.ord)
  into v_ids
  from unnest(array['세라피몬', '바이킹몬', '헤라클레스캅테리몬', '페닉스몬', '로제몬', '워그레이몬*(각성)', '메탈가루몬*(각성)', '오파니몬', '오메가몬', '아바도몬 코어']) with ordinality as u(name, ord)
  join public.digimons d on d.name = u.name;
  if not exists (select 1 from public.decks where name = '진정한 모습의 파멸자') then
    insert into public.decks (name, tier, description, effect, member_ids)
    values ('진정한 모습의 파멸자', 'C', '', '', v_ids);
  end if;

select array_agg(d.id order by u.ord)
  into v_ids
  from unnest(array['알파몬 왕룡검*(각성)', '오메가몬X [극의]']) with ordinality as u(name, ord)
  join public.digimons d on d.name = u.name;
  if not exists (select 1 from public.decks where name = '정의를 지키는 날개') then
    insert into public.decks (name, tier, description, effect, member_ids)
    values ('정의를 지키는 날개', 'C', '', '', v_ids);
  end if;

select array_agg(d.id order by u.ord)
  into v_ids
  from unnest(array['오메가몬X [극의]', '리리스몬X [각성]']) with ordinality as u(name, ord)
  join public.digimons d on d.name = u.name;
  if not exists (select 1 from public.decks where name = '정의를 유혹하는 날개짓') then
    insert into public.decks (name, tier, description, effect, member_ids)
    values ('정의를 유혹하는 날개짓', 'C', '', '', v_ids);
  end if;

select array_agg(d.id order by u.ord)
  into v_ids
  from unnest(array['지드밀레니엄몬*(각성)', '알파몬 왕룡검[극의]', '루체몬 사탄모드[극의]', '오메가몬X [극의]', '홀리드라몬']) with ordinality as u(name, ord)
  join public.digimons d on d.name = u.name;
  if not exists (select 1 from public.decks where name = '무력화 시키는 자들') then
    insert into public.decks (name, tier, description, effect, member_ids)
    values ('무력화 시키는 자들', 'C', '', '', v_ids);
  end if;

select array_agg(d.id order by u.ord)
  into v_ids
  from unnest(array['퀀타몬']) with ordinality as u(name, ord)
  join public.digimons d on d.name = u.name;
  if not exists (select 1 from public.decks where name = '라크에 진좌하는 자') then
    insert into public.decks (name, tier, description, effect, member_ids)
    values ('라크에 진좌하는 자', 'C', '', '', v_ids);
  end if;

select array_agg(d.id order by u.ord)
  into v_ids
  from unnest(array['블룸로드몬', '퀀타몬']) with ordinality as u(name, ord)
  join public.digimons d on d.name = u.name;
  if not exists (select 1 from public.decks where name = '디지몬을 인간 세계로 보내는 존재') then
    insert into public.decks (name, tier, description, effect, member_ids)
    values ('디지몬을 인간 세계로 보내는 존재', 'C', '', '', v_ids);
  end if;
end $$;
