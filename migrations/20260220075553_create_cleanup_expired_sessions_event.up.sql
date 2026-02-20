CREATE EVENT IF NOT EXISTS cleanup_expired_session
ON SCHEDULE EVERY 6 HOUR
DO DELETE FROM session WHERE expires_at < NOW();