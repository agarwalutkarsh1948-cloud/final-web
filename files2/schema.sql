-- ============================================================
--  NoteShare v2 — MySQL Database Schema
--  Run once:  Get-Content schema.sql | mysql -u root -pDrop_717
-- ============================================================

CREATE DATABASE IF NOT EXISTS noteshare
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE noteshare;

-- ── Notes table (with approval status) ──────────────────────
CREATE TABLE IF NOT EXISTS notes (
  id            VARCHAR(32)   NOT NULL PRIMARY KEY,
  title         VARCHAR(255)  NOT NULL,
  subject       VARCHAR(100)  NOT NULL DEFAULT 'Other',
  description   TEXT,
  uploader      VARCHAR(100)  NOT NULL DEFAULT 'Anonymous',
  filename      VARCHAR(255)  NOT NULL,
  original_name VARCHAR(255)  NOT NULL,
  ext           VARCHAR(20)   NOT NULL,
  size          VARCHAR(30)   NOT NULL,
  downloads     INT           NOT NULL DEFAULT 0,
  status        ENUM('pending','approved','rejected') NOT NULL DEFAULT 'pending',
  uploaded_at   DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
  reviewed_at   DATETIME      NULL,
  reviewed_by   VARCHAR(100)  NULL,
  INDEX idx_subject  (subject),
  INDEX idx_status   (status),
  INDEX idx_uploaded (uploaded_at)
) ENGINE=InnoDB;

-- ── Admins table (multiple admins support) ───────────────────
CREATE TABLE IF NOT EXISTS admins (
  id         INT           NOT NULL AUTO_INCREMENT PRIMARY KEY,
  username   VARCHAR(50)   NOT NULL UNIQUE,
  password   VARCHAR(255)  NOT NULL,
  role       ENUM('superadmin','admin') NOT NULL DEFAULT 'admin',
  created_at DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
  last_login DATETIME      NULL
) ENGINE=InnoDB;

-- ── Settings table (key-value store) ────────────────────────
CREATE TABLE IF NOT EXISTS settings (
  `key`   VARCHAR(100) NOT NULL PRIMARY KEY,
  `value` TEXT
) ENGINE=InnoDB;

-- ── Seed default superadmin ───────────────────────────────────
-- Default password: admin123  (change immediately after login!)
INSERT INTO admins (username, password, role) VALUES
  ('admin', 'admin123', 'superadmin')
ON DUPLICATE KEY UPDATE username = username;

-- ── Seed default settings ────────────────────────────────────
INSERT INTO settings (`key`, `value`) VALUES
  ('site_title',      'NoteShare'),
  ('site_tagline',    'Collaborative Learning Platform'),
  ('hero_heading',    'Share notes. Learn faster. Together.'),
  ('hero_sub',        'Upload your study notes, discover what peers have shared, and build a richer academic experience.'),
  ('footer_text',     'Made with ♥ by Utkarsh, Sachin, Rohit & Naitik'),
  ('primary_color',   '#e0217a'),
  ('allow_uploads',   'true'),
  ('show_downloads',  'true'),
  ('admin_secret_key','noteshare_admin_2026'),
  ('contact_name',    'Utkarsh Agarwal'),
  ('contact_role',    'Creator & Developer — NoteShare'),
  ('contact_email',   'agarwalutkarsh1948@gmail.com'),
  ('contact_phone',   '+91 7818026130'),
  ('contact_linkedin','https://www.linkedin.com/in/utkarsh-agarwal-a436a2383/')
ON DUPLICATE KEY UPDATE `key` = `key`;

-- ── Views ─────────────────────────────────────────────────────
CREATE OR REPLACE VIEW subject_stats AS
  SELECT subject,
         COUNT(*) AS note_count,
         SUM(downloads) AS total_downloads
  FROM notes
  WHERE status = 'approved'
  GROUP BY subject
  ORDER BY note_count DESC;

CREATE OR REPLACE VIEW pending_count AS
  SELECT COUNT(*) AS cnt FROM notes WHERE status = 'pending';
