# 📚 NoteShare — Collaborative Learning Platform
Made with ❤️ by Utkarsh Agarwal & Atul Gangwar

---

## 🗄️ MySQL Setup (one-time)

### Step 1 — Open MySQL and run the schema
```bash
mysql -u root -p < schema.sql
```
This creates the `noteshare` database, all tables, and seeds default settings.

### Step 2 — Edit your DB credentials in app.py
Open `app.py` and update the `DB_CONFIG` block near the top:
```python
DB_CONFIG = {
    'host':     'localhost',
    'port':     3306,
    'user':     'root',       # ← your MySQL username
    'password': 'your_pw',   # ← your MySQL password
    'database': 'noteshare',
}
```

---

## 🚀 Run the App

### Step 1 — Install dependencies
```bash
pip install -r requirements.txt
```

### Step 2 — Start the server
```bash
python app.py
```

### Step 3 — Open in browser
| Page           | URL                               |
|----------------|-----------------------------------|
| 🌐 Homepage    | http://localhost:5000             |
| 🔐 Admin Login | http://localhost:5000/admin/login |
| 📊 Dashboard   | http://localhost:5000/admin       |

**Default admin password:** `admin`  
⚠️ Change it immediately from the Security tab in the admin panel!

---

## 📁 Project Structure
```
noteshare/
├── app.py               ← Flask backend (MySQL edition)
├── schema.sql           ← Run once to create the database
├── requirements.txt     ← Python packages
├── uploads/             ← Auto-created: stores uploaded files
└── templates/
    ├── index.html       ← Public homepage
    ├── admin_login.html ← Admin login page
    └── admin.html       ← Admin dashboard
```

---

## 🗃️ Database Tables

| Table      | Purpose                                      |
|------------|----------------------------------------------|
| `notes`    | All uploaded note metadata                   |
| `settings` | Key-value store for site config & admin pass |

### notes columns
| Column        | Type         | Notes                        |
|---------------|--------------|------------------------------|
| id            | VARCHAR(32)  | UUID hex, primary key        |
| title         | VARCHAR(255) |                              |
| subject       | VARCHAR(100) | Indexed                      |
| description   | TEXT         |                              |
| uploader      | VARCHAR(100) | Indexed                      |
| filename      | VARCHAR(255) | UUID filename stored on disk |
| original_name | VARCHAR(255) | Original upload filename     |
| ext           | VARCHAR(20)  | pdf, docx, etc.              |
| size          | VARCHAR(30)  | Human-readable e.g. "334 KB" |
| downloads     | INT          | Auto-increments on download  |
| uploaded_at   | DATETIME     | Auto-set by MySQL            |

---

## 🛠 Tech Stack
- **Frontend**: HTML5, CSS3, Vanilla JavaScript
- **Backend**: Python 3.8+ + Flask
- **Database**: MySQL 8+ via mysql-connector-python
- **Storage**: Local `uploads/` folder (filenames are UUIDs)
