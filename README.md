# ❄️ StyleHub: Snowflake Data Cloud Showcase

A comprehensive demonstration of modern data cloud capabilities, originally created for **Saveetha Engineering College**. This project showcases how Snowflake simplifies complex data engineering, security, and analytics tasks.

---

## 🚀 Key Features Demonstrated

### 🕒 Data Recovery (Time Travel)
*   **Scenario:** Simulated an accidental `DELETE FROM ORDERS`.
*   **Solution:** Used Snowflake **Time Travel** to query the state of the table 2 minutes prior and restored the data instantly without backups.

### 👯 Zero-Copy Cloning
*   Created an exact replica of the Production database for a **Development environment** in seconds.
*   Demonstrated how to test destructive changes in `DEV` without affecting `PROD` or incurring extra storage costs.

### 📈 Elastic Scaling
*   **Scale Up:** Resized the Virtual Warehouse from `X-SMALL` to `SMALL` to double compute power.
*   **Auto-Suspend:** Configured a 60-second auto-shutdown to optimize credit usage and costs.

### 🛡️ Data Governance
*   Implemented **Dynamic Data Masking** on PII (email addresses).
*   Sensitive data is visible only to `ACCOUNTADMIN`, while other roles see `*********`.

### 📦 Semi-Structured Data
*   Natively ingested and queried **JSON** product details using the `VARIANT` data type.
*   Performed a 3-way join between structured User/Order tables and semi-structured Product data.

---

## 🐍 Python & Snowpark Analytics
Using **Snowpark**, the project bridges the gap between data engineering and data science:

*   **Sentiment Analysis:** A Python function to classify product reviews as *Positive*, *Negative*, or *Neutral*.
*   **Keyword Extraction:** Visualizing the top "Buzzwords" from customer feedback using `matplotlib`.
*   **Sales Dashboard:** Dynamic revenue breakdowns by City and Category.

---

## 🛠️ Technical Stack
*   **Platform:** Snowflake Data Cloud
*   **Languages:** SQL, Python
*   **Libraries:** Snowpark, Pandas, Matplotlib

---

**Author:** Jai Pradhiksha D P  
**Date:** May 2026
