-- ==========================
-- USERS
-- ==========================
CREATE TABLE "users" (
    "id_user" SERIAL PRIMARY KEY,
    "pin" VARCHAR(255) NOT NULL,
    "email" VARCHAR(100) UNIQUE NOT NULL,
    "hp_number" VARCHAR(20) UNIQUE NOT NULL,
    "balance" NUMERIC(18,2) DEFAULT 0,
    "status_account" VARCHAR(20) NOT NULL
        CHECK ("status_account" IN ('active','suspended','blocked')),
    "created_at" TIMESTAMP DEFAULT NOW(),
    "updated_at" TIMESTAMP DEFAULT NOW()
);

-- ==========================
-- PROFILES
-- ==========================
CREATE TABLE "profiles" (
    "id" SERIAL PRIMARY KEY,
    "id_user" INT REFERENCES "users"("id_user") NOT NULL UNIQUE,
    "name" VARCHAR(150) NOT NULL,
    "alamat" TEXT,
    "gender" VARCHAR(20),
    "place_birth" VARCHAR(100),
    "date_birth" DATE,
    "created_at" TIMESTAMP DEFAULT NOW(),
    "updated_at" TIMESTAMP DEFAULT NOW()
);

-- ==========================
-- ACTIVITY LOGS
-- ==========================
CREATE TABLE "activity_logs" (
    "id_log" SERIAL PRIMARY KEY,
    "id_user" INT REFERENCES "users"("id_user") NOT NULL,
    "activity_type" VARCHAR(50) NOT NULL
        CHECK ("activity_type" IN (
            'login',
            'logout',
            'change_pin',
            'edit_profile',
            'update_balance'
        )),
    "ip_address" VARCHAR(45),
    "created_at" TIMESTAMP DEFAULT NOW()
);

-- ==========================
-- TRANSACTION TYPES
-- ==========================
CREATE TABLE "transaction_types" (
    "id_type" SERIAL PRIMARY KEY,
    "name" VARCHAR(50) NOT NULL,
    "category" VARCHAR(10) NOT NULL
        CHECK ("category" IN ('DEBIT','CREDIT')),
    "fee_amount" NUMERIC(18,2) DEFAULT 0,
    "min_amount" NUMERIC(18,2) DEFAULT 0,
    "max_amount" NUMERIC(18,2),
    "created_at" TIMESTAMP DEFAULT NOW(),
    "updated_at" TIMESTAMP DEFAULT NOW()
);

-- ==========================
-- TRANSACTIONS
-- ==========================
CREATE TABLE "transactions" (
    "id_transaction" SERIAL PRIMARY KEY,
    "id_user" INT REFERENCES "users"("id_user") NOT NULL,
    "id_type" INT REFERENCES "transaction_types"("id_type") NOT NULL,
    "amount" NUMERIC(18,2) NOT NULL,
    status VARCHAR(20) NOT NULL
        CHECK (status IN (
            'pending',
            'success',
            'failed',
            'cancelled'
        )),
    "reference_id" VARCHAR(100),
    description TEXT,
    "created_at" TIMESTAMP DEFAULT NOW(),
    "updated_at" TIMESTAMP DEFAULT NOW()
);

-- ==========================
-- BALANCE HISTORY
-- ==========================
CREATE TABLE "balance_history" (
    "id_balance" SERIAL PRIMARY KEY,
    "id_user" INT REFERENCES "users"("id_user") NOT NULL,
    "id_transaction" INT REFERENCES "transactions"("id_transaction") NOT NULL,
    "previous_balance" NUMERIC(18,2) NOT NULL,
    "new_balance" NUMERIC(18,2) NOT NULL,
    "change_amount" NUMERIC(18,2) NOT NULL,
    "created_at" TIMESTAMP DEFAULT NOW()
);