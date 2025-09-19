-- Author: Daniel Guidi
-- Project: Marketing Performance Case Study
-- Module: Campaign Attribution & Retention Analysis
-- Description: Aggregates campaign data to calculate conversions, CAC, LTV, and M+1 retention
-- SQL Dialect: PostgreSQL
-- Assumptions:
-- - Retention is defined as second conversion in the following calendar month
-- Attribution Model:
-- - Type: First-order, month-strict attribution
-- - Description: Each conversion is attributed to the campaign that drove the user’s first order, only if the order occurred in the same month as the campaign activity. Subsequent orders are not attributed.
-- - Limitations:
--     1. Misses influence of campaigns that contribute to later conversions (lagged effect).
--     2. Potentially underestimates campaigns near month-end.
--     3. Does not account for multi-touch or cross-channel effects.
-- - Alternatives:
--     1. Last-touch attribution (credits the campaign just before conversion)
--     2. Multi-touch / fractional attribution (splits credit among all campaigns influencing the user)
--     3. Time-decay attribution (gives more weight to recent campaigns before conversion)




WITH
-- 1 Prepare campaign activity data (monthly aggregated)
-- Normalises and aggregates campaign_performance to a monthly grain per campaign
campaign_base AS (
    SELECT
        DATE(strftime('%Y-%m-01', date)) AS month_start,
        strftime('%Y-%m', date) AS month,
        region,
        country,
        campaign_id,
        SUM(spend) AS spend,
        SUM(clicks) AS clicks,
        SUM(installs) AS installs
    FROM campaign_performance
    GROUP BY month_start, month, region, country, campaign_id
),

-- 2 Identify each user's FIRST conversion date
-- For each user, it finds the earliest recorded conversion date — we treat that as the user’s acquisition / first order.
first_orders AS (
    SELECT
        user_id,
        MIN(date) AS first_order_date
    FROM conversions
    GROUP BY user_id
),

-- 3 Link first conversions back to campaigns
-- Joins first_orders back to conversions on (user_id, first_order_date) to retrieve the campaign_id of the user's first order.
acquired_users AS (
    SELECT
        fo.user_id,
        fo.first_order_date,
        c.campaign_id
    FROM first_orders fo
    JOIN conversions c
      ON fo.user_id = c.user_id
     AND fo.first_order_date = c.date
),

-- 4 Tag first conversions with month, region, country, channel
-- Enriches acquired users with campaign month/region/country/channel
acquisition_details AS (
    SELECT
        strftime('%Y-%m', cb.month_start) AS month,
        cb.region,
        cb.country,
        cm.channel,
        au.user_id,
        au.first_order_date
    FROM acquired_users au
    JOIN campaign_base cb
      ON au.campaign_id = cb.campaign_id
     AND strftime('%Y-%m', au.first_order_date) = cb.month
    JOIN campaign_metadata cm
      ON au.campaign_id = cm.campaign_id
),

-- 5 Calculate m+1 retention
-- For users who were acquired in month M (from acquisition_details), it counts how many of those users had any order in month M+1
retention_m1 AS (
    SELECT
        ad.month,
        ad.region,
        ad.country,
        ad.channel,
        COUNT(DISTINCT r.user_id) AS m1_retained_users
    FROM acquisition_details ad
    JOIN conversions r
      ON ad.user_id = r.user_id
     AND strftime('%Y-%m', r.date) = strftime('%Y-%m', DATE(ad.first_order_date, '+1 month'))
    GROUP BY ad.month, ad.region, ad.country, ad.channel
),

-- 6 Aggregate conversions
-- Counts distinct acquired users per (month, region, country, channel) → the conversions column in final table.
agg_conversions AS (
    SELECT
        month,
        region,
        country,
        channel,
        COUNT(DISTINCT user_id) AS conversions
    FROM acquisition_details
    GROUP BY month, region, country, channel
),

-- 7 Aggregate campaign metrics
-- Aggregates the campaign_base spend/clicks/installs to (month, region, country, channel) by joining campaign metadata.
agg_campaigns AS (
    SELECT
        cb.month,
        cb.region,
        cb.country,
        cm.channel,
        SUM(cb.spend) AS spend,
        SUM(cb.clicks) AS clicks,
        SUM(cb.installs) AS installs
    FROM campaign_base cb
    JOIN campaign_metadata cm
      ON cb.campaign_id = cm.campaign_id
    GROUP BY cb.month, cb.region, cb.country, cm.channel
),

-- 8 Join LTV projections
-- Left-joins the LTV lookup using month (converted to integer) + country + channel; fills missing LTV with 0
ltv_joined AS (
    SELECT
        ac.month,
        ac.region,
        ac.country,
        ac.channel,
        ac.spend,
        ac.clicks,
        ac.installs,
        COALESCE(l.average_ltv_per_customer, 0) AS average_ltv_per_customer
    FROM agg_campaigns ac
    LEFT JOIN ltv_projections l
      ON l.month = CAST(substr(ac.month, 6, 2) AS INT)
     AND l.country = ac.country
     AND l.channel = ac.channel
)

-- 9 Final output
-- Computes cac = spend / conversions (NULL if conversions = 0), ltv_cac = average_ltv_per_customer / cac (NULL if cac is NULL), and m1_retention from retention_m1
SELECT
    l.month,
    l.region,
    l.country,
    l.channel,
    l.spend,
    l.clicks,
    l.installs,
    c.conversions,
    CASE WHEN c.conversions > 0 THEN ROUND(l.spend / c.conversions, 2) ELSE NULL END AS cac,
    l.average_ltv_per_customer,
    CASE WHEN c.conversions > 0 THEN ROUND(l.average_ltv_per_customer / (l.spend / c.conversions), 2) ELSE NULL END AS ltv_cac,
    COALESCE(r.m1_retained_users, 0) AS m1_retention
FROM ltv_joined l
LEFT JOIN agg_conversions c
  ON l.month = c.month
 AND l.region = c.region
 AND l.country = c.country
 AND l.channel = c.channel
LEFT JOIN retention_m1 r
  ON l.month = r.month
 AND l.region = r.region
 AND l.country = r.country
 AND l.channel = r.channel
ORDER BY l.month, l.region, l.country, l.channel;