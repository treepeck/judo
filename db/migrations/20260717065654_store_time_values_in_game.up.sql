ALTER TABLE game ADD COLUMN time_control SMALLINT;
ALTER TABLE game ADD COLUMN time_bonus SMALLINT;
ALTER TABLE game ADD COLUMN time_differences BYTEA;

ALTER TABLE rated_game DROP COLUMN time_control;
ALTER TABLE rated_game DROP COLUMN time_bonus;
ALTER TABLE rated_game DROP COLUMN time_differences;