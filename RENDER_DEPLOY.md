# GramSetu — Deploying to Render

## Prerequisites
- A MySQL database (Render MySQL, PlanetScale, Railway, or Aiven)
- Java 17 build pack on Render

## Step 1: Create the MySQL Database
1. Use [Aiven](https://aiven.io), [PlanetScale](https://planetscale.com), or Render's managed MySQL.
2. Import `src/main/resources/schema.sql` to create all tables and seed data.

## Step 2: Deploy on Render

### Option A — Docker (Recommended)
1. Push this project to GitHub.
2. Create a new **Web Service** on Render → connect your GitHub repo.
3. Set **Build Command**: `mvn clean package -DskipTests`
4. Set **Start Command**:
   ```
   java -jar target/dependency/webapp-runner.jar --port $PORT target/GramSetu.war
   ```
5. Set **Runtime**: Java 17

### Option B — Use render.yaml
Render will detect `render.yaml` automatically and configure the service.

## Step 3: Set Environment Variables
In Render Dashboard → Your Service → Environment:

| Variable       | Value                                               |
|----------------|-----------------------------------------------------|
| `DB_URL`       | `jdbc:mysql://your-host:3306/gramsetu_db?useSSL=true&serverTimezone=UTC` |
| `DB_USERNAME`  | your DB username                                    |
| `DB_PASSWORD`  | your DB password                                    |
| `UPLOAD_DIR`   | `/tmp/gramsetu-uploads` (or a mounted disk path)    |
| `MAIL_HOST`    | `smtp.gmail.com`                                    |
| `MAIL_PORT`    | `587`                                               |
| `MAIL_USERNAME`| your Gmail address                                  |
| `MAIL_PASSWORD`| your Gmail App Password                             |

## Step 4: Admin Login
- Email: `admin@gramsetu.com`
- Password: `Admin@123` ← **Change this immediately!**

## Local Development
1. Start MySQL locally.
2. Import `schema.sql`.
3. Set environment variables or edit `src/main/resources/db.properties`.
4. Run: `mvn clean package && java -jar target/dependency/webapp-runner.jar target/GramSetu.war`
5. Open: http://localhost:8080

## File Uploads
- Uploaded files are stored at `UPLOAD_DIR` (env var).
- For Render free tier: set `UPLOAD_DIR=/tmp/gramsetu-uploads` (**note: /tmp is ephemeral — files reset on restart**).
- For persistent uploads: attach a Render Disk and set `UPLOAD_DIR=/mnt/uploads`.
