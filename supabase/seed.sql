-- Seed data for private.stadiums
insert into private.stadiums (stadium_name, stadium_city, stadium_state, stadium_country, stadium_capacity)
values 
('Madison Square Garden', 'New York', 'NY', 'USA', 19812),
('Staples Center', 'Los Angeles', 'CA', 'USA', 19060),
('United Center', 'Chicago', 'IL', 'USA', 20917);

-- Seed data for private.leagues
insert into private.leagues (league_name, league_rank)
values 
('NBA', 1),
('G League', 2);

-- Seed data for private.conferences
insert into private.conferences (conference_name, league_id)
values 
('Eastern Conference', 1),
('Western Conference', 1),
('Eastern Conference', 2),
('Western Conference', 2);

-- Seed data for private.divisions
insert into private.divisions (division_name, conference_id)
values 
('Atlantic', 1),
('Central', 1),
('Southeast', 1),
('Northwest', 2),
('Pacific', 2);

-- Seed data for private.teams
insert into private.teams (team_name, stadium_id, league_id, division_id)
values 
('New York Knicks', 1, 1, 1),
('Los Angeles Lakers', 2, 1, 5),
('Chicago Bulls', 3, 1, 2);

-- Seed data for private.position_categories
insert into private.position_categories (position_category_name)
values 
('Guard'),
('Forward'),
('Center');

-- Seed data for private.positions
insert into private.positions (position_name, position_label, position_category_id)
values 
('Point Guard', 'PG', 1),
('Shooting Guard', 'SG', 1),
('Small Forward', 'SF', 2),
('Power Forward', 'PF', 2),
('Center', 'C', 3);

-- Seed data for private.person_statuses
insert into private.person_statuses (person_status_name)
values 
('Active'),
('Injured'),
('Retired');

-- Seed data for private.people
insert into private.people (person_first_name, person_last_name, person_birth_date, person_status_id, position_id, team_id)
values 
('LeBron', 'James', '1984-12-30', 1, 5, 2),
('Stephen', 'Curry', '1988-03-14', 1, 1, 2),
('Giannis', 'Antetokounmpo', '1994-12-06', 1, 5, 3);

-- Seed data for private.game_types
insert into private.game_types (game_type_name)
values 
('Regular Season'),
('Playoff'),
('Preseason');

-- Seed data for private.game_statuses
insert into private.game_statuses (game_status_name)
values 
('Scheduled'),
('Ongoing'),
('Completed');

-- Seed data for private.games
insert into private.games (game_type_id, game_status_id, home_team_id, away_team_id, stadium_id)
values 
(1, 1, 1, 2, 1);

-- Seed data for private.play_types
insert into private.play_types (play_type_name)
values 
('Shot Attempt'),
('Assist'),
('Free Throw Attempt'),
('Foul'),
('Turnover'),
('Block'),
('Steal');

-- Seed data for private.play_by_play
insert into private.play_by_play (game_time_seconds, play_timestamp, play_type_id, game_id, person_id, play_metadata)
values 
(100, '2024-08-01 12:10:00', 1, 1, 1, '{"shot_made": "true"}'),
(200, '2024-08-01 12:11:40', 1, 1, 1, '{"shot_made": "true"}'),
(300, '2024-08-01 12:15:00', 1, 1, 1, '{"shot_made": "false"}'),
(400, '2024-08-01 12:17:00', 1, 1, 1, '{"shot_made": "false"}'),
(500, '2024-08-01 12:20:00', 1, 1, 1, '{"shot_made": "false"}'),
(600, '2024-08-01 12:30:00', 1, 1, 1, '{"shot_made": "false"}'),
(700, '2024-08-01 12:35:00', 1, 1, 1, '{"shot_made": "true"}'),
(800, '2024-08-01 12:40:00', 1, 1, 1, '{"shot_made": "true"}'),
(900, '2024-08-01 12:42:00', 1, 1, 1, '{"shot_made": "true"}');

-- Seed data for private.employees
insert into private.employees (employee_first_name, employee_last_name)
values 
('Tyler', 'Hillery');

-- Seed data for private.employee_logins
insert into private.employee_logins (logged_in_at, logged_out_at, platform, employee_id)
values 
('2024-08-01 09:00:00', '2024-08-01 10:30:00', 'twitter', 1),
('2024-08-01 12:00:00', '2024-08-01 13:00:00', 'twitter', 1),
('2024-08-01 14:00:00', '2024-08-01 15:00:00', 'twitter', 1);

-- Seed data for private.employee_work_logs
insert into private.employee_work_logs (clocked_in_at, clocked_out_at, employee_id)
values 
('2024-08-01 08:00:00', '2024-08-01 10:00:00', 1),
('2024-08-01 10:30:00', '2024-08-01 12:00:00', 1),
('2024-08-01 13:00:00', '2024-08-01 17:00:00', 1);

-- Insert seed data with some null values
insert into private.iot_sensor_readings (sensor_id, reading_timestamp, sensor_value)
values
    (1, '2024-08-01 12:00:00', 23.5),
    (1, '2024-08-01 12:05:00', NULL),  -- Simulate a missing reading
    (1, '2024-08-01 12:10:00', 24.0),
    (1, '2024-08-01 12:15:00', NULL),  -- Simulate a missing reading
    (1, '2024-08-01 12:20:00', 25.0),
    (1, '2024-08-01 12:25:00', 25.5),
    (2, '2024-08-01 12:00:00', 30.1),
    (2, '2024-08-01 12:05:00', 30.2),
    (2, '2024-08-01 12:10:00', NULL),  -- Simulate a missing reading
    (2, '2024-08-01 12:15:00', 30.3),
    (2, '2024-08-01 12:20:00', NULL);  -- Simulate a missing reading