create schema private;

create table private.stadiums (
    stadium_id          int         primary key generated always as identity,
    stadium_name        text        not null,
    stadium_city        text        not null,
    stadium_state       text,
    stadium_country     text        not null,
    stadium_capacity    int         not null,
    stadium_founded_at  timestamptz  not null default current_timestamp,
    stadium_inserted_at timestamptz  not null default current_timestamp,
    stadium_updated_at  timestamptz  not null default current_timestamp,
    stadium_deleted_at  timestamptz
);

-- e.g. NBA League, G League
create table private.leagues (
    league_id           int         primary key generated always as identity,
    league_name         text        not null unique, 
    league_rank         int         not null unique,  
    league_founded_at   timestamptz  not null default current_timestamp,
    league_inserted_at  timestamptz  not null default current_timestamp,
    league_updated_at   timestamptz  not null default current_timestamp,
    league_deleted_at   timestamptz
);

-- e.g. Eastern / Western Conference
create table private.conferences (
    conference_id           int         primary key generated always as identity,
    conference_name         text        not null,        
    conference_founded_at   timestamptz not null default current_timestamp,
    conference_inserted_at  timestamptz not null default current_timestamp,
    conference_updated_at   timestamptz not null default current_timestamp,
    conference_deleted_at   timestamptz, 
    league_id               int         not null references private.leagues(league_id) on delete cascade,
    unique(league_id, conference_name)
);

-- e.g. Central, Atlantic
create table private.divisions (
    division_id           int           primary key generated always as identity,
    division_name         text,        
    division_founded_at   timestamptz   not null default current_timestamp,
    division_inserted_at  timestamptz   default current_timestamp,
    division_updated_at   timestamptz   default current_timestamp,
    division_deleted_at   timestamptz, 
    conference_id         int           not null references private.conferences(conference_id) on delete cascade,
    unique(conference_id, division_name)
);

-- e.g. Milwaukee Bucks 
create table private.teams (
    team_id             int         primary key generated always as identity,
    team_name           text        not null,        
    team_founded_at     timestamptz not null default current_timestamp,
    team_inserted_at    timestamptz not null default current_timestamp,
    team_updated_at     timestamptz not null default current_timestamp,
    team_deleted_at     timestamptz,
    stadium_id          int         references private.stadiums(stadium_id)      on delete set null,
    league_id           int         references private.leagues(league_id)       on delete set null,
    division_id         int         references private.divisions(division_id)   on delete set null,
    unique(league_id, team_name)
);

create table private.position_categories (
    position_category_id            int         primary key generated always as identity,
    position_category_name          text        not null unique,
    position_category_inserted_at   timestamptz not null default current_timestamp,
    position_category_updated_at    timestamptz not null default current_timestamp,
    position_category_deleted_at    timestamptz
);

create table private.positions (
    position_id             int         primary key generated always as identity,
    position_name           text        not null unique,
    position_label          text        unique,
    position_inserted_at    timestamptz not null default current_timestamp,
    position_updated_at     timestamptz not null default current_timestamp,
    position_deleted_at     timestamptz,
    position_category_id    int         references private.position_categories(position_category_id) on delete set null 
);

create table private.person_statuses (
    person_status_id            int         primary key generated always as identity,
    person_status_name          text        not null unique,
    person_status_inserted_at   timestamptz not null default current_timestamp,
    person_status_updated_at    timestamptz not null default current_timestamp,
    person_status_deleted_at    timestamptz
);

create table private.people (
    person_id           int         primary key generated always as identity,
    person_first_name   text        not null,
    person_last_name    text        not null,
    person_birth_date   date,
    person_metadata     jsonb,
    person_inserted_at  timestamptz  not null default current_timestamp,
    person_updated_at   timestamptz  not null default current_timestamp,
    person_deleted_at   timestamptz, 
    person_status_id    int         not null references private.person_statuses(person_status_id),
    position_id         int         references private.positions(position_id) on delete set null,
    team_id             int         references private.teams(team_id) on delete set null
);

create table private.game_types (
    game_type_id            int         primary key generated always as identity,
    game_type_name          text        not null unique,
    game_type_inserted_at   timestamptz not null default current_timestamp,
    game_type_updated_at    timestamptz not null default current_timestamp,
    game_type_deleted_at    timestamptz
);

create table private.game_statuses (
    game_status_id            int         primary key generated always as identity,
    game_status_name          text        not null unique,
    game_status_inserted_at   timestamptz not null default current_timestamp,
    game_status_updated_at    timestamptz not null default current_timestamp,
    game_status_deleted_at    timestamptz
);

create table private.games ( 
    game_id             int         primary key generated always as identity,
    game_inserted_at    timestamptz not null default current_timestamp,
    game_updated_at     timestamptz not null default current_timestamp,
    game_deleted_at     timestamptz,
    game_type_id        int         not null references private.game_types(game_type_id),
    game_status_id      int         not null references private.game_statuses(game_status_id),
    home_team_id        int         not null references private.teams(team_id),
    away_team_id        int         not null references private.teams(team_id),
    stadium_id          int         not null references private.stadiums(stadium_id)
);

create table private.play_types (
    play_type_id            int         primary key generated always as identity,
    play_type_name          text        not null unique,
    -- shot attempt
    -- assist
    -- free throw attempt
    -- foul
        -- shooting foul
        -- reaching in foul
    -- violation
        -- traveling 
        -- 3 seconds
        -- shot clock
        -- half court 
    -- steal
    -- block
    -- turnover
    -- check_in 
    -- check_out
    play_type_inserted_at   timestamptz  not null default current_timestamp,
    play_type_updated_at    timestamptz  not null default current_timestamp,
    play_type_deleted_at    timestamptz
);

create table private.play_by_play ( 
    play_id             int         primary key generated always as identity,
    game_time_seconds   numeric     not null,
    play_timestamp      timestamptz not null default current_timestamp,
    play_metadata       jsonb,
    play_inserted_at    timestamptz not null default current_timestamp,
    play_updated_at     timestamptz not null default current_timestamp,
    play_deleted_at     timestamptz,
    play_type_id        int         not null references private.play_types(play_type_id),
    game_id             int         not null references private.game_types(game_type_id),
    person_id           int         not null references private.people(person_id)
    -- if shot
    -- points: 0
    -- type:
        -- dunk, layup, jumper, free throw, 
        -- shooting foul, reach in 
        -- shot clock 
    -- related_player_id
    -- related_play_id
);

create view private.shots as
    select
        play_by_play.game_id,
        play_by_play.game_time_seconds,
        play_by_play.person_id as player_id,
        person_first_name || ' ' || person_last_name as player_name,
        play_types.play_type_name,
        (play_by_play.play_metadata->>'shot_made')::bool as is_shot_made
    from
        private.play_by_play
        inner join private.people using(person_id)
        inner join private.play_types using(play_type_id)
    where
        play_types.play_type_name = 'Shot Attempt'
;