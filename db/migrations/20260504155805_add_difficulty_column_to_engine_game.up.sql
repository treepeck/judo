ALTER TABLE engine_game ADD difficulty TINYINT NOT NULL DEFAULT 5
CONSTRAINT `engine_game_chk_4` CHECK ((`difficulty` in (1,2,3,4,5)));