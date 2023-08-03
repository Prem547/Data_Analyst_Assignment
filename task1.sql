duckdb> WITH events(id, occur_time, close_time) AS (
   ...>     VALUES
   ...>     (1, '09:00:00', '10:00:00'),
   ...>     (1, '09:00:00', '09:20:00'),
   ...>     (1, '09:10:00', '09:50:00'),
   ...>     (1, '08:55:00', '09:50:00'),
   ...>     (1, '08:00:00', '08:51:00'),
   ...>     (1, '08:10:00', '08:50:00'),
   ...>     (1, '09:10:00', '10:50:00'),
   ...>     (2, '08:00:00', '08:55:00'),
   ...>     (2, '08:10:00', '08:50:00')
   ...> ),
   ...> tasks_with_task_id AS (
   ...>     SELECT
   ...>         id,
   ...>         occur_time,
   ...>         close_time,
   ...>         (
   ...>             SELECT COUNT(DISTINCT e2.occur_time)
   ...>             FROM events e2
   ...>             WHERE e2.id = e1.id AND e2.occur_time < e1.close_time
   ...>         ) AS task_id
   ...>     FROM events e1
   ...> )
   ...> SELECT
   ...>     id,
   ...>     task_id,
   ...>     MIN(occur_time) AS occur_time,
   ...>     MAX(close_time) AS close_time
   ...> FROM tasks_with_task_id
   ...> GROUP BY id, task_id
   ...> ORDER BY id, task_id;
