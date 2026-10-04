do $$
declare
  v_ids uuid[];
begin
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
end $$;
