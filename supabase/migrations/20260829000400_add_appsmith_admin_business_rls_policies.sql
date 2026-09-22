drop policy if exists "Appsmith admin can insert forecast_cards"
on public.forecast_cards;

create policy "Appsmith admin can insert forecast_cards"
on public.forecast_cards
for insert
to appsmith_admin
with check (true);

drop policy if exists "Appsmith admin can update forecast_cards"
on public.forecast_cards;

create policy "Appsmith admin can update forecast_cards"
on public.forecast_cards
for update
to appsmith_admin
using (true)
with check (true);

drop policy if exists "Appsmith admin can insert subscription_plans"
on public.subscription_plans;

create policy "Appsmith admin can insert subscription_plans"
on public.subscription_plans
for insert
to appsmith_admin
with check (true);

drop policy if exists "Appsmith admin can update subscription_plans"
on public.subscription_plans;

create policy "Appsmith admin can update subscription_plans"
on public.subscription_plans
for update
to appsmith_admin
using (true)
with check (true);

drop policy if exists "Appsmith admin can insert subscription_options"
on public.subscription_options;

create policy "Appsmith admin can insert subscription_options"
on public.subscription_options
for insert
to appsmith_admin
with check (true);

drop policy if exists "Appsmith admin can update subscription_options"
on public.subscription_options;

create policy "Appsmith admin can update subscription_options"
on public.subscription_options
for update
to appsmith_admin
using (true)
with check (true);

drop policy if exists "Appsmith admin can insert forecast_events"
on public.forecast_events;

create policy "Appsmith admin can insert forecast_events"
on public.forecast_events
for insert
to appsmith_admin
with check (true);

drop policy if exists "Appsmith admin can update forecast_events"
on public.forecast_events;

create policy "Appsmith admin can update forecast_events"
on public.forecast_events
for update
to appsmith_admin
using (true)
with check (true);

drop policy if exists "Appsmith admin can delete forecast_events"
on public.forecast_events;

create policy "Appsmith admin can delete forecast_events"
on public.forecast_events
for delete
to appsmith_admin
using (true);

drop policy if exists "Appsmith admin can insert teams"
on public.teams;

create policy "Appsmith admin can insert teams"
on public.teams
for insert
to appsmith_admin
with check (true);

drop policy if exists "Appsmith admin can update teams"
on public.teams;

create policy "Appsmith admin can update teams"
on public.teams
for update
to appsmith_admin
using (true)
with check (true);

drop policy if exists "Appsmith admin can delete teams"
on public.teams;

create policy "Appsmith admin can delete teams"
on public.teams
for delete
to appsmith_admin
using (true);

drop policy if exists "Appsmith admin can insert learning_betting"
on public.learning_betting;

create policy "Appsmith admin can insert learning_betting"
on public.learning_betting
for insert
to appsmith_admin
with check (true);

drop policy if exists "Appsmith admin can update learning_betting"
on public.learning_betting;

create policy "Appsmith admin can update learning_betting"
on public.learning_betting
for update
to appsmith_admin
using (true)
with check (true);

drop policy if exists "Appsmith admin can delete learning_betting"
on public.learning_betting;

create policy "Appsmith admin can delete learning_betting"
on public.learning_betting
for delete
to appsmith_admin
using (true);

drop policy if exists "Appsmith admin can insert learning_basics"
on public.learning_basics;

create policy "Appsmith admin can insert learning_basics"
on public.learning_basics
for insert
to appsmith_admin
with check (true);

drop policy if exists "Appsmith admin can update learning_basics"
on public.learning_basics;

create policy "Appsmith admin can update learning_basics"
on public.learning_basics
for update
to appsmith_admin
using (true)
with check (true);

drop policy if exists "Appsmith admin can delete learning_basics"
on public.learning_basics;

create policy "Appsmith admin can delete learning_basics"
on public.learning_basics
for delete
to appsmith_admin
using (true);

drop policy if exists "Appsmith admin can insert learning_tips"
on public.learning_tips;

create policy "Appsmith admin can insert learning_tips"
on public.learning_tips
for insert
to appsmith_admin
with check (true);

drop policy if exists "Appsmith admin can update learning_tips"
on public.learning_tips;

create policy "Appsmith admin can update learning_tips"
on public.learning_tips
for update
to appsmith_admin
using (true)
with check (true);

drop policy if exists "Appsmith admin can delete learning_tips"
on public.learning_tips;

create policy "Appsmith admin can delete learning_tips"
on public.learning_tips
for delete
to appsmith_admin
using (true);

drop policy if exists "Appsmith admin can insert live_predictions"
on public.live_predictions;

create policy "Appsmith admin can insert live_predictions"
on public.live_predictions
for insert
to appsmith_admin
with check (true);

drop policy if exists "Appsmith admin can update live_predictions"
on public.live_predictions;

create policy "Appsmith admin can update live_predictions"
on public.live_predictions
for update
to appsmith_admin
using (true)
with check (true);

drop policy if exists "Appsmith admin can delete live_predictions"
on public.live_predictions;

create policy "Appsmith admin can delete live_predictions"
on public.live_predictions
for delete
to appsmith_admin
using (true);

drop policy if exists "Appsmith admin can insert notifications"
on public.notifications;

create policy "Appsmith admin can insert notifications"
on public.notifications
for insert
to appsmith_admin
with check (true);

drop policy if exists "Appsmith admin can update notifications"
on public.notifications;

create policy "Appsmith admin can update notifications"
on public.notifications
for update
to appsmith_admin
using (true)
with check (true);

drop policy if exists "Appsmith admin can delete notifications"
on public.notifications;

create policy "Appsmith admin can delete notifications"
on public.notifications
for delete
to appsmith_admin
using (true);

drop policy if exists "Appsmith admin can insert bookmaker_bonuses"
on public.bookmaker_bonuses;

create policy "Appsmith admin can insert bookmaker_bonuses"
on public.bookmaker_bonuses
for insert
to appsmith_admin
with check (true);

drop policy if exists "Appsmith admin can update bookmaker_bonuses"
on public.bookmaker_bonuses;

create policy "Appsmith admin can update bookmaker_bonuses"
on public.bookmaker_bonuses
for update
to appsmith_admin
using (true)
with check (true);

drop policy if exists "Appsmith admin can delete bookmaker_bonuses"
on public.bookmaker_bonuses;

create policy "Appsmith admin can delete bookmaker_bonuses"
on public.bookmaker_bonuses
for delete
to appsmith_admin
using (true);
