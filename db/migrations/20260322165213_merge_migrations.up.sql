CREATE TABLE IF NOT EXISTS `signup_token` (
  `id` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `name` varchar(60) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password_hash` binary(60) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `player` (
  `id` char(12) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `name` varchar(60) NOT NULL,
  `rating` float NOT NULL DEFAULT '1500',
  `rating_deviation` float NOT NULL DEFAULT '350',
  `rating_volatility` float NOT NULL DEFAULT '0.06',
  `email` varchar(100) DEFAULT NULL,
  `password_hash` binary(60) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `is_guest` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `session` (
  `id` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `player_id` char(12) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `expires_at` datetime GENERATED ALWAYS AS ((`created_at` + interval 720 hour)) STORED,
  PRIMARY KEY (`id`),
  KEY `player_id` (`player_id`),
  CONSTRAINT `session_ibfk_1` FOREIGN KEY (`player_id`) REFERENCES `player` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `password_reset_token` (
  `id` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `player_id` char(12) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `new_password_hash` binary(60) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_player_id` (`player_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `rated_game` (
  `id` char(12) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `white_id` char(12) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `black_id` char(12) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `moves_length` int unsigned NOT NULL DEFAULT '0',
  `moves` tinyblob,
  `time_control` smallint DEFAULT NULL,
  `time_bonus` tinyint NOT NULL,
  `result` tinyint NOT NULL DEFAULT '0',
  `termination` tinyint NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `time_differences` tinyblob,
  PRIMARY KEY (`id`),
  KEY `white_id` (`white_id`),
  KEY `black_id` (`black_id`),
  KEY `idx_pagination` (`created_at` DESC,`id` DESC),
  CONSTRAINT `rated_game_ibfk_1` FOREIGN KEY (`white_id`) REFERENCES `player` (`id`) ON DELETE CASCADE,
  CONSTRAINT `rated_game_ibfk_2` FOREIGN KEY (`black_id`) REFERENCES `player` (`id`) ON DELETE CASCADE,
  CONSTRAINT `rated_game_chk_1` CHECK ((`result` in (0,1,2,3))),
  CONSTRAINT `rated_game_chk_2` CHECK ((`termination` in (0,1,2,3,4,5,6,7,8,9)))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `engine_game` (
  `id` char(12) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `player_id` char(12) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `player_color` tinyint NOT NULL,
  `moves_length` int unsigned NOT NULL DEFAULT '0',
  `moves` tinyblob,
  `result` tinyint NOT NULL DEFAULT '0',
  `termination` tinyint NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `player_id` (`player_id`),
  CONSTRAINT `engine_game_ibfk_1` FOREIGN KEY (`player_id`) REFERENCES `player` (`id`) ON DELETE CASCADE,
  CONSTRAINT `engine_game_chk_1` CHECK ((`result` in (0,1,2,3))),
  CONSTRAINT `engine_game_chk_2` CHECK ((`termination` in (0,1,2,3,4,5,6,7))),
  CONSTRAINT `engine_game_chk_3` CHECK ((`player_color` in (0,1)))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE EVENT IF NOT EXISTS cleanup_expired_session
ON SCHEDULE EVERY 6 HOUR
DO DELETE FROM session WHERE expires_at < NOW();

CREATE EVENT IF NOT EXISTS cleanup_guest_player
ON SCHEDULE EVERY 24 HOUR
DO DELETE FROM player WHERE is_guest = TRUE;