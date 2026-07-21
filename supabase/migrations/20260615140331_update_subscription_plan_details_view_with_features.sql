drop view if exists public.subscription_plan_details;

create or replace view public.subscription_plan_details_view
with (security_invoker = true)
as
select
  sp.id as plan_id,
  sp.name,
  sp.subtitle,

  sp.feature_1,
  sp.feature_2,
  sp.feature_3,
  sp.feature_4,
  sp.feature_5,

  o1.id as option1_id,
  o1.name as option1_name,
  o1.price as option1_price,

  o2.id as option2_id,
  o2.name as option2_name,
  o2.price as option2_price

from public.subscription_plans sp

left join public.subscription_options o1
  on o1.plan_id = sp.id
 and o1.option_order = 1

left join public.subscription_options o2
  on o2.plan_id = sp.id
 and o2.option_order = 2;
