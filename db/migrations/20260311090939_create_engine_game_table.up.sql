CREATE TABLE IF NOT EXISTS engine_game (
	id CHAR(12) BINARY PRIMARY KEY,
	player_id CHAR(12) BINARY NOT NULL,
	player_color TINYINT NOT NULL,
	moves_length INT UNSIGNED NOT NULL DEFAULT 0,
	moves TINYBLOB,
	result TINYINT NOT NULL DEFAULT 0,
	termination TINYINT NOT NULL DEFAULT 0,
	created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	FOREIGN KEY (player_id) REFERENCES player(id),
	CHECK (result IN (0, 1, 2, 3)),
	-- TimeForfeit and Agreement values are forbitten.
	CHECK (termination IN (0, 1, 2, 3, 4, 5, 6, 7))
);