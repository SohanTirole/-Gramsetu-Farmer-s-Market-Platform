-- ============================================================
-- GramSetu v2 - Cloud Database Schema
-- For Aiven / PlanetScale / Railway MySQL
-- The database is pre-created by your cloud provider.
-- Just run this file against your cloud DB:
--   mysql -h HOST -u USER -p DB_NAME < schema_cloud.sql
-- OR paste in your cloud provider's SQL console
-- ============================================================

-- ============================================================
-- GramSetu v2 - Complete Database Schema
-- Run: mysql -u root -p < schema.sql
-- ============================================================


-- 1. USERS
CREATE TABLE IF NOT EXISTS users (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    name        VARCHAR(100) NOT NULL,
    email       VARCHAR(100) NOT NULL UNIQUE,
    password    VARCHAR(255) NOT NULL,
    phone       VARCHAR(15),
    role        ENUM('ROLE_FARMER','ROLE_BUYER','ROLE_SVC','ROLE_AGRONOMIST','ROLE_NGO','ROLE_ADMIN') NOT NULL,
    village     VARCHAR(100),
    district    VARCHAR(100),
    state       VARCHAR(100),
    aadhaar     VARCHAR(20),
    is_active   TINYINT(1) DEFAULT 1,
    created_at  DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 2. SVC AGENTS
CREATE TABLE IF NOT EXISTS svc_agents (
    id                INT AUTO_INCREMENT PRIMARY KEY,
    user_id           INT NOT NULL,
    centre_name       VARCHAR(150),
    villages_covered  VARCHAR(500),
    commission_earned DECIMAL(10,2) DEFAULT 0.00,
    farmers_registered INT DEFAULT 0,
    created_at        DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- 3. CROPS
CREATE TABLE IF NOT EXISTS crops (
    id             INT AUTO_INCREMENT PRIMARY KEY,
    farmer_id      INT NOT NULL,
    svc_agent_id   INT,
    name           VARCHAR(100) NOT NULL,
    category       VARCHAR(50),
    quantity       DECIMAL(10,2) NOT NULL,
    unit           VARCHAR(20) DEFAULT 'kg',
    price_per_unit DECIMAL(10,2) NOT NULL,
    description    TEXT,
    photo_url      VARCHAR(255),
    state          VARCHAR(100),
    district       VARCHAR(100),
    is_available   TINYINT(1) DEFAULT 1,
    listed_at      DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (farmer_id)    REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (svc_agent_id) REFERENCES svc_agents(id) ON DELETE SET NULL
);

-- 4. ORDERS
CREATE TABLE IF NOT EXISTS orders (
    id               INT AUTO_INCREMENT PRIMARY KEY,
    buyer_id         INT NOT NULL,
    crop_id          INT NOT NULL,
    quantity         DECIMAL(10,2) NOT NULL,
    total_price      DECIMAL(10,2) NOT NULL,
    status           ENUM('PENDING','CONFIRMED','PACKED','DISPATCHED','DELIVERED','CANCELLED') DEFAULT 'PENDING',
    payment_status   ENUM('UNPAID','PAID','REFUNDED') DEFAULT 'UNPAID',
    payment_method   VARCHAR(50),
    delivery_address TEXT,
    ordered_at       DATETIME DEFAULT CURRENT_TIMESTAMP,
    delivered_at     DATETIME,
    FOREIGN KEY (buyer_id) REFERENCES users(id),
    FOREIGN KEY (crop_id)  REFERENCES crops(id)
);

-- 5. LOGISTICS
CREATE TABLE IF NOT EXISTS logistics (
    id                INT AUTO_INCREMENT PRIMARY KEY,
    order_id          INT NOT NULL,
    transporter_name  VARCHAR(100),
    vehicle_number    VARCHAR(30),
    pickup_date       DATE,
    expected_delivery DATE,
    current_status    VARCHAR(100) DEFAULT 'Booking confirmed',
    tracking_notes    TEXT,
    created_at        DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE
);

-- 6. PRICE HISTORY
CREATE TABLE IF NOT EXISTS price_history (
    id            INT AUTO_INCREMENT PRIMARY KEY,
    crop_name     VARCHAR(100) NOT NULL,
    msp_price     DECIMAL(10,2),
    market_price  DECIMAL(10,2),
    state         VARCHAR(100),
    recorded_date DATE NOT NULL,
    source        VARCHAR(100) DEFAULT 'Manual'
);

-- 7. SOIL ADVISORY
CREATE TABLE IF NOT EXISTS soil_advisory (
    id               INT AUTO_INCREMENT PRIMARY KEY,
    farmer_id        INT NOT NULL,
    svc_agent_id     INT,
    agronomist_id    INT,
    photo_url        VARCHAR(255),
    soil_description TEXT,
    recommendation   TEXT,
    status           ENUM('PENDING','IN_REVIEW','COMPLETED') DEFAULT 'PENDING',
    submitted_at     DATETIME DEFAULT CURRENT_TIMESTAMP,
    responded_at     DATETIME,
    FOREIGN KEY (farmer_id)     REFERENCES users(id),
    FOREIGN KEY (svc_agent_id)  REFERENCES svc_agents(id),
    FOREIGN KEY (agronomist_id) REFERENCES users(id)
);

-- 8. CONSULTATIONS
CREATE TABLE IF NOT EXISTS consultations (
    id            INT AUTO_INCREMENT PRIMARY KEY,
    farmer_id     INT NOT NULL,
    agronomist_id INT,
    topic         VARCHAR(200) NOT NULL,
    description   TEXT,
    photo_url     VARCHAR(255),
    response      TEXT,
    status        ENUM('OPEN','IN_PROGRESS','RESOLVED') DEFAULT 'OPEN',
    created_at    DATETIME DEFAULT CURRENT_TIMESTAMP,
    resolved_at   DATETIME,
    FOREIGN KEY (farmer_id)     REFERENCES users(id),
    FOREIGN KEY (agronomist_id) REFERENCES users(id)
);

-- 9. GOVT SCHEMES
CREATE TABLE IF NOT EXISTS govt_schemes (
    id                 INT AUTO_INCREMENT PRIMARY KEY,
    scheme_name        VARCHAR(200) NOT NULL,
    ministry           VARCHAR(150),
    description        TEXT,
    eligibility        TEXT,
    benefits           TEXT,
    apply_url          VARCHAR(255),
    applicable_states  VARCHAR(500) DEFAULT 'ALL',
    crop_types         VARCHAR(500) DEFAULT 'ALL',
    is_active          TINYINT(1) DEFAULT 1
);

-- 10. SCHEME APPLICATIONS
CREATE TABLE IF NOT EXISTS scheme_applications (
    id            INT AUTO_INCREMENT PRIMARY KEY,
    farmer_id     INT NOT NULL,
    svc_agent_id  INT,
    scheme_id     INT NOT NULL,
    documents_url VARCHAR(255),
    status        ENUM('SUBMITTED','UNDER_REVIEW','APPROVED','REJECTED') DEFAULT 'SUBMITTED',
    remarks       TEXT,
    applied_at    DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (farmer_id)    REFERENCES users(id),
    FOREIGN KEY (svc_agent_id) REFERENCES svc_agents(id),
    FOREIGN KEY (scheme_id)    REFERENCES govt_schemes(id)
);

-- 11. EQUIPMENT
CREATE TABLE IF NOT EXISTS equipment (
    id           INT AUTO_INCREMENT PRIMARY KEY,
    owner_id     INT NOT NULL,
    name         VARCHAR(100) NOT NULL,
    category     VARCHAR(50),
    description  TEXT,
    rate_per_hour DECIMAL(10,2),
    rate_per_day  DECIMAL(10,2),
    location     VARCHAR(150),
    is_available TINYINT(1) DEFAULT 1,
    photo_url    VARCHAR(255),
    created_at   DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (owner_id) REFERENCES users(id)
);

-- 12. EQUIPMENT BOOKINGS
CREATE TABLE IF NOT EXISTS equipment_bookings (
    id           INT AUTO_INCREMENT PRIMARY KEY,
    farmer_id    INT NOT NULL,
    svc_agent_id INT,
    equipment_id INT NOT NULL,
    booking_date DATE NOT NULL,
    return_date  DATE,
    total_cost   DECIMAL(10,2),
    status       ENUM('BOOKED','IN_USE','RETURNED','CANCELLED') DEFAULT 'BOOKED',
    created_at   DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (farmer_id)    REFERENCES users(id),
    FOREIGN KEY (svc_agent_id) REFERENCES svc_agents(id),
    FOREIGN KEY (equipment_id) REFERENCES equipment(id)
);

-- 13. FORUM POSTS
CREATE TABLE IF NOT EXISTS forum_posts (
    id         INT AUTO_INCREMENT PRIMARY KEY,
    user_id    INT NOT NULL,
    title      VARCHAR(200) NOT NULL,
    content    TEXT NOT NULL,
    category   ENUM('CROP_ADVICE','PEST_ALERT','MARKET_INFO','GENERAL') DEFAULT 'GENERAL',
    upvotes    INT DEFAULT 0,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- 14. FORUM REPLIES
CREATE TABLE IF NOT EXISTS forum_replies (
    id         INT AUTO_INCREMENT PRIMARY KEY,
    post_id    INT NOT NULL,
    user_id    INT NOT NULL,
    content    TEXT NOT NULL,
    is_expert  TINYINT(1) DEFAULT 0,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (post_id)  REFERENCES forum_posts(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id)  REFERENCES users(id)
);

-- 15. TRAINING EVENTS
CREATE TABLE IF NOT EXISTS training_events (
    id                    INT AUTO_INCREMENT PRIMARY KEY,
    title                 VARCHAR(200) NOT NULL,
    description           TEXT,
    trainer               VARCHAR(100),
    event_date            DATE NOT NULL,
    location              VARCHAR(200),
    is_online             TINYINT(1) DEFAULT 0,
    max_participants      INT DEFAULT 50,
    registration_deadline DATE,
    created_by            INT,
    FOREIGN KEY (created_by) REFERENCES users(id)
);

-- 16. NOTIFICATIONS
CREATE TABLE IF NOT EXISTS notifications (
    id         INT AUTO_INCREMENT PRIMARY KEY,
    user_id    INT NOT NULL,
    message    TEXT NOT NULL,
    type       VARCHAR(50),
    is_read    TINYINT(1) DEFAULT 0,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- ── SEED DATA ────────────────────────────────────────────────────

-- Default admin (password: Admin@123)
-- Hash below is BCrypt of 'Admin@123' — change immediately after first login!
INSERT IGNORE INTO users (name, email, password, phone, role, state, is_active)
VALUES ('Admin', 'admin@gramsetu.com',
'$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy',
'9000000000', 'ROLE_ADMIN', 'Maharashtra', 1);

-- Sample government schemes
INSERT IGNORE INTO govt_schemes (scheme_name, ministry, description, eligibility, benefits, apply_url) VALUES
('PM-KISAN', 'Ministry of Agriculture',
 'Direct income support of Rs 6000 per year to all farmer families.',
 'All land-holding farmer families across the country.',
 'Rs 6000 per year in 3 equal installments of Rs 2000 each.',
 'https://pmkisan.gov.in'),

('Pradhan Mantri Fasal Bima Yojana', 'Ministry of Agriculture',
 'Crop insurance scheme providing financial support for crop loss due to natural calamities.',
 'All farmers including sharecroppers and tenant farmers.',
 'Financial support for crop loss at subsidised premium rates.',
 'https://pmfby.gov.in'),

('Kisan Credit Card', 'Ministry of Finance',
 'Credit facility for agricultural needs at concessional interest rates.',
 'All farmers, sharecroppers, oral lessees and tenant farmers.',
 'Credit up to Rs 3 lakh at 4% interest per annum.',
 'https://www.nabard.org'),

('Soil Health Card Scheme', 'Ministry of Agriculture',
 'Free soil testing and crop-wise nutrient recommendations for all farmers.',
 'All farmers across India.',
 'Free soil health card with crop-wise fertiliser recommendations.',
 'https://soilhealth.dac.gov.in'),

('PM Krishi Sinchai Yojana', 'Ministry of Agriculture',
 'Irrigation scheme for every farm and more crop per drop.',
 'All farmers with agricultural land.',
 'Subsidy on micro-irrigation equipment, drip and sprinkler systems.',
 'https://pmksy.gov.in');

-- Sample price history
INSERT IGNORE INTO price_history (crop_name, msp_price, market_price, state, recorded_date) VALUES
('Wheat',    2275.00, 2400.00, 'Madhya Pradesh', CURDATE()),
('Rice',     2183.00, 2300.00, 'Uttar Pradesh',  CURDATE()),
('Soybean',  4600.00, 4900.00, 'Maharashtra',    CURDATE()),
('Maize',    2090.00, 2200.00, 'Karnataka',      CURDATE()),
('Cotton',   7020.00, 7400.00, 'Maharashtra',    CURDATE()),
('Onion',     800.00, 2200.00, 'Maharashtra',    CURDATE()),
('Tomato',    500.00, 1800.00, 'Karnataka',      CURDATE()),
('Potato',    600.00,  900.00, 'Uttar Pradesh',  CURDATE()),
('Sugarcane', 340.00,  360.00, 'Maharashtra',    CURDATE()),
('Groundnut',5850.00, 6200.00, 'Gujarat',        CURDATE());
