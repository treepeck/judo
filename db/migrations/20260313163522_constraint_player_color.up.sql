ALTER TABLE engine_game ADD CONSTRAINT engine_game_chk_3
CHECK (player_color IN (0, 1));