with
get_prior_shot_result as (
  select
    *,
    lag(is_shot_made) over (
      partition by
        game_id,
        player_id
      order by
        game_time_seconds
    ) as prior_shot_result
  from
    private.shots
),

compare_prior_vs_current as (
  select
    *,
    case 
      when is_shot_made != prior_shot_result 
        then 1 
      else 
        0 
    end as new_streak
  from
    get_prior_shot_result
),

get_streak_number as (
  select
    *,
    sum(new_streak) over(
      partition by
        game_id,
        player_id
      order by
        game_time_seconds
    ) as streak_number
  from
    compare_prior_vs_current
),

-- select game_time_seconds, player_name, play_type_name, is_shot_made, prior_shot_result, new_streak, streak_number
-- from get_streak_number
-- order by game_time_seconds

get_streak_length as (
  select
    *,
    row_number() over (
      partition by
        game_id,
        player_id,
        streak_number
      order by
        game_time_seconds
    ) as streak_length
  from
    get_streak_number
)

select 
  *,
  case
    when is_shot_made and streak_length = 2
      then 'Heating Up!'
    when is_shot_made and streak_length >= 3
      then 'On Fire 🔥'
    when not is_shot_made and streak_length = 2
      then 'Cooling down'
    when not is_shot_made and streak_length >= 3
      then 'Ice Cold 🥶'
  end as player_shooting_status
from 
  get_streak_length 
order by 
  game_time_seconds