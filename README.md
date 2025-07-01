# dbt-snowflake-view-repointer

An automated dbt macro designed for Snowflake, enabling seamless adjustment of view pointers within cloned databases to prevent cross-database references.

---

## The Problem

In Snowflake, a common pattern involves using an **ETL_schema** for data processing, then cloning its contents into **production reporting schemas** (like SCHEMA_A or SCHEMA_B) for live reports. While Snowflake clones are remarkably fast, they perform a **shallow copy of views**.

This means that even after cloning, views in your new active production schema (e.g., SCHEMA_A) will still point to tables in the **original ETL schema**. This leads to several critical issues:

* **Incorrect Data:** Your production reports might inadvertently pull data from the ETL Schema (where ETL is potentially still ongoing or in a transient state) instead of the stable, cloned data in the active reporting schema.
* **Broken Reports:** If the ETL_Schema undergoes DDL changes or temporary states during its process, views pointing back to it can break, causing report failures.
* **Manual Overhead:** Manually inspecting and updating every view's definition after each database or schema clone is a tedious, time-consuming, and error-prone task.

---

## The Solution

This project provides a **dbt macro** that programmatically fetches the definition (DDL) of specified views within your cloned production reporting schemas. It then intelligently **replaces references** from the original ETL_Schema to the newly cloned data within the active production schema (SCHEMA_A/B), and finally re-creates these views using the modified DDL.

This automated process ensures your production reports always point to the correct, stable data in the active cloned schema, establishing true isolation and accurate data lineage.

---