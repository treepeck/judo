UPDATE game SET time_control = 0, time_bonus = 0
WHERE time_control IS NULL AND time_bonus IS NULL;

ALTER TABLE game ALTER COLUMN time_control TYPE INT;
ALTER TABLE game ALTER COLUMN time_control SET DEFAULT 0;
ALTER TABLE game ALTER COLUMN time_control SET NOT NULL;

ALTER TABLE game ALTER COLUMN time_bonus TYPE INT;
ALTER TABLE game ALTER COLUMN time_bonus SET DEFAULT 0;
ALTER TABLE game ALTER COLUMN time_bonus SET NOT NULL;