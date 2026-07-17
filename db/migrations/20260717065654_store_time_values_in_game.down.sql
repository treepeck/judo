ALTER TABLE rated_game ADD COLUMN time_control SMALLINT;
ALTER TABLE rated_game ADD COLUMN time_bonus SMALLINT;
ALTER TABLE rated_game ADD COLUMN time_differences BYTEA;

ALTER TABLE game DROP COLUMN time_control;
ALTER TABLE game DROP COLUMN time_bonus;
ALTER TABLE game DROP COLUMN time_differences;