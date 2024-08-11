  -- last_value(sensor_value ignore nulls) over (
  --   partition by
  --     sensor_id
  --   order by
  --     reading_timestamp
  -- ),
with 
sensor_data as (
  select
    reading_id,
    sensor_id,
    reading_timestamp,
    sensor_value,
    array_agg(sensor_value) filter (where sensor_value is not null) over (
      partition by
        sensor_id
      order by
        reading_timestamp
      rows between unbounded preceding and current row
    ) as sensor_values_array
  from 
    private.iot_sensor_readings
)

select
  reading_id,
  sensor_id,
  reading_timestamp,
  sensor_value,
  (
    select v
    from unnest(sensor_values_array) with ordinality as t(v, o)
    order by o desc
    limit 1
  ) as last_non_null_sensor_value
from 
  sensor_data
order by
  sensor_id,
  reading_timestamp
