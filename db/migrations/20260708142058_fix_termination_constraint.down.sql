ALTER TABLE game DROP CONSTRAINT game_chk_2;
ALTER TABLE game ADD CONSTRAINT game_chk_2 CHECK (termination IN (0, 1, 2, 3, 4, 5, 6, 7));