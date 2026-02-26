-- Compound index is used to enable pagination without
-- using OFFSET statement that decreases the performance.

ALTER TABLE game ADD INDEX idx_pagination (created_at DESC, id DESC);

