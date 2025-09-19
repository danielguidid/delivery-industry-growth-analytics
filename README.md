# delivery-industry-growth-analytics
End-to-end data analysis case study in the on-demand delivery industry. Using a fictitious company (OnTime), this project covers data cleaning, advanced SQL queries, Python prototyping, Tableau dashboard development, and stakeholder-ready presentations focused on marketing performance, attribution, retention, and ROI.

## 📌 Project Overview
This repository showcases an **end-to-end data analysis project** simulating a real-world marketing performance case in the **on-demand delivery industry**.  
The fictitious company, **OnTime**, operates across multiple markets and channels (paid search, social, display, etc.), and the goal is to evaluate marketing effectiveness, customer acquisition cost (CAC), lifetime value (LTV), and retention.  

The project demonstrates technical depth (Python, SQL, Tableau) combined with business acumen (stakeholder presentation, KPI design, strategic recommendations).

---

## 🎯 Objectives
1. Clean and prepare raw marketing & conversion data.  
2. Build advanced SQL queries to calculate marketing KPIs:
   - **Conversions**
   - **Customer Acquisition Cost (CAC)**
   - **Lifetime Value (LTV)**
   - **Month+1 Retention**
3. Prototype and validate queries in Python with SQLite.  
4. Design an interactive Tableau dashboard for senior stakeholders.  
5. Present findings and strategic recommendations to business leadership.  

---

## 🛠 Tools & Tech Stack
- **Python** (pandas, sqlite3) – data preparation, prototyping queries  
- **SQL (PostgreSQL dialect)** – advanced CTEs, attribution modeling  
- **Tableau** – interactive dashboard creation  
- **PowerPoint / PDF** – stakeholder presentation  

---

## 📂 Repository Structure
- `raw_business_data.csv` → Original dataset provided (simulated, anonymized).  
- `clean_business_data.csv` → Cleaned dataset ready for analysis.  
- `data_preparation.ipynb` → Python notebook for dummy data generation and SQLite setup.  
- `advanced_queries.sql` → SQL script with CTEs and calculations for KPIs.  
- `marketing_performance_dashboard.twbx` → Tableau dashboard file.  
- `stakeholder_presentation.pdf` → Business presentation summarizing findings and recommendations.  
- `project_requirements.pdf` → Brief outlining the case study requirements (anonymized).  

---

## 📊 Business Case: OnTime
**OnTime** is a fictional on-demand delivery company operating in multiple cities and regions.  
It invests across **several marketing channels** (Search, Social, Display, Affiliates, etc.) and aims to optimize:  

- **Efficiency** (lower CAC while scaling acquisition)  
- **Profitability** (maximize LTV vs. CAC ratio)  
- **Retention** (drive repeat orders beyond the first conversion)  
- **Channel Mix** (evaluate which channels drive sustainable growth)  

The analysis uses a **first-order, month-strict attribution model**, meaning:
- A user’s first conversion is attributed to the campaign that drove it, if it happened within the same month as campaign activity.  
- Subsequent conversions are not attributed.  

---

## 📈 End-to-End Strategy

1. **Data Understanding & Cleaning**  
   - Identify missing values, duplicates, formatting issues.  
   - Prepare a clean dataset suitable for SQL analysis and Tableau.  

2. **SQL Analysis**  
   - Create queries to calculate **conversions, CAC, LTV, retention**.  
   - Implement attribution logic (first-order, month-strict).  
   - Highlight limitations and propose alternatives (last-touch, multi-touch, time-decay).  

3. **Dashboard Development (Tableau)**  
   - Build an interactive marketing performance dashboard.  
   - Allow filtering by **channel**, **market**, **month**.  
   - Visualize KPIs and trends in an intuitive way for executives.  

4. **Business Presentation**  
   - Summarize findings in a concise, executive-friendly format.  
   - Explain trade-offs (e.g., efficiency vs. volume, CAC vs. retention).  
   - Propose strategic next steps based on data.  

---

## 📌 Key KPIs
- **Conversions**: Total first-time orders per campaign.  
- **CAC (Customer Acquisition Cost)**: Spend / new customers acquired.  
- **LTV (Customer Lifetime Value)**: Revenue per acquired customer.  
- **M+1 Retention**: Share of customers placing a second order the following month.  

---

## 👥 Stakeholders & Decisions
- **CMO / Marketing Leadership**: Channel budget allocation, campaign strategy.  
- **Growth & Performance Teams**: Optimize campaigns, adjust bidding strategies.  
- **Finance & Strategy Teams**: Validate ROI, assess long-term unit economics.  
- **Country Managers / Market Leads**: Compare performance across geographies.  

---

## ⚠️ Disclaimer
This project is entirely **fictional** and based on a **synthetic dataset**.  
The company **OnTime** does not exist, and all data, requirements, and deliverables are simulated for portfolio purposes only.  
No confidential or real company information is shared.  

---

## 📊 Dashboard Preview

[![OnTime Marketing Dashboard Overview](assets/dashboard_cover.png)](https://public.tableau.com/app/profile/daniel.guidi/viz/shared/724QMJ3ZJ)
