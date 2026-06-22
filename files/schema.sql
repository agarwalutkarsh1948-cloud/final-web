-- ============================================================
--  NoteShare — MySQL Database Schema
--  Run once:  mysql -u root -p < schema.sql
-- ============================================================

CREATE DATABASE IF NOT EXISTS noteshare
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE noteshare;

-- ── Notes table ─────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS notes (
  id           VARCHAR(32)   NOT NULL PRIMARY KEY,
  title        VARCHAR(255)  NOT NULL,
  subject      VARCHAR(100)  NOT NULL DEFAULT 'Other',
  description  TEXT,
  uploader     VARCHAR(100)  NOT NULL DEFAULT 'Anonymous',
  filename     VARCHAR(255)  NOT NULL,          -- stored UUID filename on disk
  original_name VARCHAR(255) NOT NULL,          -- original filename user uploaded
  ext          VARCHAR(20)   NOT NULL,
  size         VARCHAR(30)   NOT NULL,
  downloads    INT           NOT NULL DEFAULT 0,
  uploaded_at  DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_subject  (subject),
  INDEX idx_uploader (uploader),
  INDEX idx_uploaded (uploaded_at)
) ENGINE=InnoDB;

-- ── Settings table (key-value store) ────────────────────────
CREATE TABLE IF NOT EXISTS settings (
  `key`   VARCHAR(100) NOT NULL PRIMARY KEY,
  `value` TEXT
) ENGINE=InnoDB;

-- ── Seed default settings ────────────────────────────────────
INSERT INTO settings (`key`, `value`) VALUES
  ('site_title',      'NoteShare'),
  ('site_tagline',    'Collaborative Learning Platform'),
  ('hero_heading',    'Knowledge Grows When Shared'),
  ('hero_sub',        'Upload, discover, and download lecture notes effortlessly.'),
  ('footer_text',     'Made with ♥ by Utkarsh, Sachin, Rohit & Naitik'),
  ('primary_color',   '#e0217a'),
  ('allow_uploads',   'true'),
  ('show_downloads',  'true'),
  ('admin_password',  'admin'),
  ('contact_name',    'Utkarsh Agarwal'),
  ('contact_role',    'Creator & Developer — NoteShare'),
  ('contact_email',   'agarwalutkarsh1948@gmail.com'),
  ('contact_phone',   '+91 7818026130'),
  ('contact_linkedin','https://www.linkedin.com/in/utkarsh-agarwal-a436a2383/')
ON DUPLICATE KEY UPDATE `key` = `key`;   -- don't overwrite if already set

-- ── Useful views ─────────────────────────────────────────────
CREATE OR REPLACE VIEW subject_stats AS
  SELECT subject, COUNT(*) AS note_count, SUM(downloads) AS total_downloads
  FROM notes
  GROUP BY subject
  ORDER BY note_count DESC;
