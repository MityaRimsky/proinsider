create or replace view public.subscription_cards_view
with (security_invoker = true)
as
select
    sp.id as plan_id,
    sp.name,
    sp.subtitle,

    so.name as display_option_name,
    so.price as display_option_price

from public.subscription_plans sp

left join public.subscription_options so
    on so.plan_id = sp.id
   and so.display_on_card = true;
