-- 1. Write a query to get the sum of impressions by day
SELECT date, SUM(impressions) AS total_impressions
FROM marketing_performance
GROUP BY date
ORDER BY date;

-- 2. Write a query to get the top three revenue-generating states in order of best to worst. 
SELECT state, SUM(revenue) AS total_revenue
FROM website_revenue
GROUP BY state
ORDER BY total_revenue DESC
LIMIT 3;
-- How much revenue did the third best state generate?
SELECT state, total_revenue
FROM (SELECT state, SUM(revenue) AS total_revenue
      FROM website_revenue
      GROUP BY state
      ORDER BY total_revenue DESC
      LIMIT 3) AS top3_states
ORDER BY total_revenue ASC
LIMIT 1; -- 37577

-- 3. Write a query that shows total cost, impressions, clicks, and revenue of each campaign. 
-- Make sure to include the campaign name in the output.
SELECT c.name AS campaign_name, c.id AS campaign_id,
       SUM(m.cost) AS total_cost, 
       SUM(m.impressions) AS total_impressions,
       SUM(m.clicks) AS total_clicks,
       SUM(w.revenue) AS total_revenue
FROM campaign_info c
LEFT JOIN marketing_performance m ON c.id = m.campaign_id
LEFT JOIN website_revenue w ON c.id = w.campaign_id
GROUP BY c.name
ORDER BY c.name;

-- 4. Write a query to get the number of conversions of Campaign5 by state. 
SELECT w.state, SUM(m.conversions) AS total_conversions
FROM marketing_performance m
LEFT JOIN website_revenue w ON m.campaign_id = w.campaign_id
WHERE m.campaign_id = (SELECT id FROM campaign_info WHERE name = "Campaign5")
GROUP BY w.state
ORDER BY total_conversions DESC;
-- Which state generated the most conversions for this campaign?
SELECT w.state, SUM(m.conversions) as total_conversions
FROM marketing_performance m
LEFT JOIN website_revenue w ON m.campaign_id = w.campaign_id
WHERE m.campaign_id = (SELECT id FROM campaign_info WHERE name = "Campaign5")
GROUP BY w.state
ORDER BY total_conversions DESC
LIMIT 1; -- GA

-- 5. In your opinion, which campaign was the most efficient, and why?

-- Return on Investment (ROI) = ((Total Revenue - Total Cost) / Total Cost) * 100
SELECT c.name AS campaign_name,
       SUM(w.revenue) AS total_revenue,
       SUM(m.cost) AS total_cost, 
       (CASE WHEN SUM(m.cost) > 0 THEN (SUM(w.revenue) - SUM(m.cost))/SUM(m.cost)*100 ELSE 0 END) AS ROI_percent
FROM campaign_info c
LEFT JOIN marketing_performance m ON c.id = m.campaign_id
LEFT JOIN website_revenue w ON c.id = w.campaign_id
GROUP BY c.name
ORDER BY ROI_percent DESC
LIMIT 1; -- Campaign4 was the most efficient based on ROI (having the most return on investment)

-- Cost per Conversion = Total Cost / Total Conversions
SELECT c.name AS campaign_name,
       SUM(m.cost) AS total_cost, 
       SUM(m.conversions) AS total_conversions,
       (CASE WHEN SUM(m.conversions) > 0 THEN SUM(m.cost)/SUM(m.conversions) ELSE 0 END) AS cost_per_conversion
FROM campaign_info c
LEFT JOIN marketing_performance m ON c.id = m.campaign_id
GROUP BY c.name
ORDER BY cost_per_conversion
LIMIT 1; -- Campaign4 was the most efficient based on cost per conversion (having the least cost per conversion)

-- Both metrics suggest that Campaign4 was the most efficient

-- 6. Write a query that showcases the best day of the week (e.g., Sunday, Monday, Tuesday, etc.) to run ads.
SELECT DAYNAME(date) AS day_of_week,
       AVG(impressions) AS avg_impressions
FROM marketing_performance
ORDER BY avg_impressions DESC
LIMIT 1;