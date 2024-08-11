-- Create the employees table
create table private.employees (
    employee_id             int         primary key generated always as identity,
    employee_first_name     text        not null,
    employee_last_name      text        not null,
    employee_inserted_at    timestamptz not null default current_timestamp,
    employee_updated_at     timestamptz not null default current_timestamp,
    employee_deleted_at     timestamptz
);

-- Create the employee_logins table to track login and logout timestamps
create table private.employee_logins (
    login_id            int         primary key generated always as identity,
    logged_in_at        timestamptz not null default current_timestamp,
    logged_out_at       timestamptz,
    login_range         tstzrange,
    platform            text, 
    login_inserted_at   timestamptz not null default current_timestamp,
    login_updated_at    timestamptz not null default current_timestamp,
    login_deleted_at    timestamptz,
    employee_id         int         not null references private.employees(employee_id)
);

-- Create the employee_work_logs table to track clock-in and clock-out times
create table private.employee_work_logs (
    work_log_id             int         primary key generated always as identity,
    clocked_in_at           timestamptz not null default current_timestamp,
    clocked_out_at          timestamptz,
    work_log_range          tstzrange, 
    work_log_inserted_at    timestamptz not null default current_timestamp,
    work_log_updated_at     timestamptz not null default current_timestamp,
    work_log_deleted_at     timestamptz,
    employee_id             int         not null references private.employees(employee_id)
);

-- Trigger function to populate login_range
create or replace function update_login_range() 
returns trigger as $$
begin
    new.login_range := tstzrange(new.logged_in_at, new.logged_out_at);
    return new;
end;
$$ language plpgsql;

-- Trigger function to populate work_log_range
create or replace function update_work_log_range() 
returns trigger as $$
begin
    new.work_log_range := tstzrange(new.clocked_in_at, new.clocked_out_at);
    return new;
end;
$$ language plpgsql;

-- Trigger for employee_logins to update login_range
create trigger trg_update_login_range
before insert or update on private.employee_logins
for each row
execute function update_login_range();

-- Trigger for employee_work_logs to update work_log_range
create trigger trg_update_work_log_range
before insert or update on private.employee_work_logs
for each row
execute function update_work_log_range();
