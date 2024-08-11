with
overlapping_sessions as (
  select
    employee_work_logs.employee_id,
    employee_logins.platform,

    greatest(
      employee_work_logs.clocked_in_at,
      employee_logins.logged_in_at
    ) as overlapping_start_time,

    least(
      employee_work_logs.clocked_out_at,
      employee_logins.logged_out_at
    ) as overlapping_end_time

  from
    private.employee_work_logs
    inner join private.employee_logins
      on employee_work_logs.employee_id = employee_logins.employee_id
      and employee_work_logs.clocked_in_at < employee_logins.logged_out_at
      and employee_logins.logged_in_at < employee_work_logs.clocked_out_at
)

select 
  employee_first_name || ' ' || employee_last_name as employee_name,
  platform,
  overlapping_start_time,
  overlapping_end_time
from 
  overlapping_sessions 
  inner join private.employees using(employee_id)
order by overlapping_start_time;

with
overlapping_sessions as (
  select
    employee_work_logs.employee_id,
    employee_logins.platform,

    greatest(
      lower(employee_work_logs.work_log_range),
      lower(employee_logins.login_range)
    ) as overlapping_start_time,

    least(
      upper(employee_work_logs.work_log_range),
      upper(employee_logins.login_range)
    ) as overlapping_end_time
    
  from
    private.employee_work_logs
    inner join private.employee_logins
      on employee_work_logs.employee_id = employee_logins.employee_id
      and work_log_range && login_range
)

select 
  employee_first_name || ' ' || employee_last_name as employee_name,
  platform,
  overlapping_start_time,
  overlapping_end_time
from 
  overlapping_sessions 
  inner join private.employees using(employee_id)
order by overlapping_start_time
