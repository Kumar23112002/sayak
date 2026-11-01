# Sayak Groceries - Spring Boot Backend

Spring Boot REST API backend with **Real-time Mobile OTP Authentication** and **Supabase PostgreSQL** database support for Sayak Groceries.

---

## 🚀 Features
1. **Real-Time OTP Generation & Verification**:
   - Generates secure 6-digit numeric OTPs with 5-minute expiration.
   - Logs real-time OTP clearly in the backend console for immediate testing.
   - Supports pluggable SMS gateways (Fast2SMS / Twilio).
   - Protected against replay attacks, brute-force attempts, and expiration.
2. **Supabase PostgreSQL Integration**:
   - Native PostgreSQL driver configuration.
   - Pre-configured for Supabase direct connection or transaction pooler.
   - Full SQL schema included in `schema.sql`.
3. **Session & Security**:
   - Stateless JWT (JSON Web Tokens).
   - Clean logout handling.
   - CORS enabled for Flutter web, mobile emulators, and physical devices.

---

## 🗄️ Supabase PostgreSQL Setup

### Step 1: Run SQL Schema in Supabase
1. Go to your [Supabase Dashboard](https://supabase.com/dashboard).
2. Open **SQL Editor**.
3. Copy the contents of `backend/schema.sql` and click **Run**.
4. This creates the `users`, `otp_verifications`, and `user_sessions` tables.

### Step 2: Configure Database Credentials
Open `src/main/resources/application.properties` and update:
```properties
spring.datasource.url=jdbc:postgresql://db.<YOUR_PROJECT_REF>.supabase.co:5432/postgres?sslmode=require
spring.datasource.username=postgres
spring.datasource.password=<YOUR_SUPABASE_DATABASE_PASSWORD>
```
*(Or pass them as environment variables `DB_URL`, `DB_USERNAME`, `DB_PASSWORD`).*

---

## 🏃 Running the Backend

### Run with Maven:
```bash
cd backend
mvn spring-boot:run
```

### Run with Local In-Memory H2 DB (No Supabase required for testing):
```bash
mvn spring-boot:run -Dspring-boot.run.profiles=local
```

The backend starts at `http://localhost:8080`.

---

## 📡 API Endpoints

| Method | Endpoint | Description | Auth Required |
|---|---|---|---|
| `GET` | `/api/auth/health` | Health Check | No |
| `POST` | `/api/auth/send-otp` | Request 6-digit real-time OTP | No |
| `POST` | `/api/auth/verify-otp` | Verify OTP and receive JWT | No |
| `POST` | `/api/auth/register` | Register customer profile | No |
| `POST` | `/api/auth/logout` | Logout user session | No |
| `GET` | `/api/auth/me` | Fetch authenticated user | Yes (Bearer Token) |

### Sample Payloads:

#### 1. Send OTP:
`POST /api/auth/send-otp`
```json
{
  "phone": "9876543210",
  "purpose": "LOGIN"
}
```
**Response:**
```json
{
  "success": true,
  "message": "Real-time OTP sent successfully to +91 9876543210",
  "data": {
    "phone": "9876543210",
    "expiresInSeconds": 300,
    "devOtp": "648192"
  }
}
```

#### 2. Verify OTP:
`POST /api/auth/verify-otp`
```json
{
  "phone": "9876543210",
  "otp": "648192",
  "purpose": "LOGIN"
}
```
**Response:**
```json
{
  "success": true,
  "message": "Sign In successful! Welcome to Sayak Groceries.",
  "token": "eyJhbGciOiJIUzI1NiJ9...",
  "tokenType": "Bearer",
  "user": {
    "id": 1,
    "phoneNumber": "9876543210",
    "fullName": "Sayak Customer",
    "email": "customer@sayakgroceries.com",
    "role": "CUSTOMER"
  },
  "newUser": false
}
```
