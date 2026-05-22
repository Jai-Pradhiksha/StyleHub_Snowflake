-- TIME-TRAVEL
-- Step 1: Delete all orders (The Mistake)
DELETE FROM ORDERS;

-- Step 2: Verify it's gone (Returns 0 rows)
SELECT * FROM ORDERS;

-- Step 3: Use Time Travel to see data from 2 minutes ago
-- Note: 'offset' is in seconds (e.g., -120 is 2 minutes ago)
SELECT * FROM ORDERS AT(OFFSET => -120);

-- Step 4: Restore the table instantly
INSERT INTO ORDERS SELECT * FROM ORDERS AT(OFFSET => -120);

--ZERO COPY CLONING
-- Clone the entire database for a 'Development' environment
CREATE OR REPLACE DATABASE STYLEHUB_DB_DEV CLONE STYLEHUB_DB;

-- Verify the new database exists
SHOW DATABASES LIKE 'STYLEHUB_DB_DEV';

-- You can now modify the DEV database without affecting PROD
USE DATABASE STYLEHUB_DB_DEV;
DELETE FROM USERS WHERE USERID = 1;

-- Check PROD - Aarav Sharma is still there!
SELECT * FROM STYLEHUB_DB.PUBLIC.USERS WHERE USERID = 1;

-- SCALING
-- Check your current warehouse size
SHOW WAREHOUSES LIKE 'COMPUTE_WH';

-- Scale UP: Change from X-Small to Small (Doubles the servers)
ALTER WAREHOUSE COMPUTE_WH SET WAREHOUSE_SIZE = 'SMALL';

-- Scale DOWN: Return to X-Small to save credits
ALTER WAREHOUSE COMPUTE_WH SET WAREHOUSE_SIZE = 'XSMALL';

-- Demonstrate 'Auto-Suspend' (The best way to save money)
-- This shuts the warehouse down after 1 minute of inactivity
ALTER WAREHOUSE COMPUTE_WH SET AUTO_SUSPEND = 60;

--DATA MASKING
-- Step 1: Create a masking policy
-- If the user is ACCOUNTADMIN, they see the email. Everyone else sees '*********'
CREATE OR REPLACE MASKING POLICY email_mask AS (val STRING) 
  RETURNS STRING ->
  CASE
    WHEN CURRENT_ROLE() IN ('ACCOUNTADMIN') THEN val
    ELSE '*********'
  END;

-- Step 2: Apply the policy to your USERS table
ALTER TABLE USERS MODIFY COLUMN EMAIL SET MASKING POLICY email_mask;

-- Step 3: Test it!
-- As ACCOUNTADMIN, you see the email:
SELECT EMAIL FROM USERS;

-- (Optional) If you have another role, switch to it to see the mask:
-- USE ROLE PUBLIC; 
-- SELECT EMAIL FROM USERS;
