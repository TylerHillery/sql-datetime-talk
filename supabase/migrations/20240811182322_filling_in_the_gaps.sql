-- Create the IoT sensor readings table
create table private.iot_sensor_readings (
    reading_id          int         primary key generated always as identity,
    sensor_id           int         not null,
    reading_timestamp   timestamptz not null default current_timestamp,
    sensor_value        float,
    reading_inserted_at timestamptz not null default current_timestamp,
    reading_updated_at  timestamptz not null default current_timestamp,
    reading_deleted_at  timestamptz
);