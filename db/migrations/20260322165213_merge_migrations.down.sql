DROP TABLE IF EXISTS `signup_token`;

DROP TABLE IF EXISTS `session`;

DROP TABLE IF EXISTS `password_reset_token`;

DROP TABLE IF EXISTS `rated_game`;

DROP TABLE IF EXISTS `engine_game`;

DROP TABLE IF EXISTS `player`;

DROP EVENT IF EXISTS cleanup_expired_session;

DROP EVENT IF EXISTS cleanup_guest_player;