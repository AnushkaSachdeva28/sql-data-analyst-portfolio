-- RFM Customer Segmentation (Northwind)
-- Business problem: Which customers are most valuable, and which are at risk of leaving?

USE northwind;

-- =====================
-- RECENCY
-- =====================

-- Q1: When did each customer last order, and how many days ago was that?
SELECT 
    CustomerID,
    MAX(OrderDate) AS last_order,
    DATEDIFF(CURRENT_DATE(), MAX(OrderDate)) AS days_ago
FROM Orders
GROUP BY CustomerID;

-- Q2: How many customers are Hot, Warm, Cold or Frozen based on days since their last order?
WITH recency AS (
    SELECT 
        CustomerID,
        DATEDIFF(CURRENT_DATE(), MAX(OrderDate)) AS days_ago
    FROM Orders
    GROUP BY CustomerID
),
segmented AS (
    SELECT 
        CustomerID,
        CASE
            WHEN days_ago <= 7 THEN 'Hot'
            WHEN days_ago <= 21 THEN 'Warm'
            WHEN days_ago <= 60 THEN 'Cold'
            ELSE 'Frozen'
        END AS customer_status
    FROM recency
)
SELECT 
    customer_status,
    COUNT(*) AS num_customers
FROM segmented
GROUP BY customer_status;

-- Q3: Which customers have not ordered in more than 90 days (at risk of being lost)?
WITH recency AS (
    SELECT 
        CustomerID,
        DATEDIFF(CURRENT_DATE(), MAX(OrderDate)) AS days_ago
    FROM Orders
    GROUP BY CustomerID
)
SELECT 
    CustomerID,
    days_ago
FROM recency
WHERE days_ago > 90
ORDER BY days_ago DESC;

-- =====================
-- FREQUENCY
-- =====================

-- Q4: How many distinct orders has each customer placed?
SELECT 
    CustomerID,
    COUNT(DISTINCT OrderID) AS total_orders
FROM Orders
GROUP BY CustomerID;

-- Q5: Who are the one-time buyers, and who are the VIPs with 5 or more orders?
WITH frequency AS (
    SELECT 
        CustomerID,
        COUNT(DISTINCT OrderID) AS total_orders
    FROM Orders
    GROUP BY CustomerID
)
SELECT 
    CustomerID,
    total_orders,
    CASE 
        WHEN total_orders = 1 THEN 'One-time buyer'
        WHEN total_orders >= 5 THEN 'VIP customer'
        ELSE 'Regular'
    END AS customer_status
FROM frequency;

-- =====================
-- MONETARY
-- =====================

-- Q6: How much has each customer spent in total?
SELECT 
    o.CustomerID,
    SUM(od.Quantity * p.Price) AS total_spent
FROM Orders o
JOIN OrderDetails od ON o.OrderID = od.OrderID
JOIN Products p ON p.ProductID = od.ProductID
GROUP BY o.CustomerID;

-- Q7: Who are the top 10 customers by total spend?
SELECT 
    o.CustomerID,
    SUM(od.Quantity * p.Price) AS total_spent
FROM Orders o
JOIN OrderDetails od ON o.OrderID = od.OrderID
JOIN Products p ON p.ProductID = od.ProductID
GROUP BY o.CustomerID
ORDER BY total_spent DESC
LIMIT 10;

-- Q8: Who is the top-spending customer in each country?
WITH country_spend AS (
    SELECT 
        c.CustomerID,
        c.Country,
        SUM(od.Quantity * p.Price) AS total_spent
    FROM Customers c
    JOIN Orders o ON c.CustomerID = o.CustomerID
    JOIN OrderDetails od ON o.OrderID = od.OrderID
    JOIN Products p ON p.ProductID = od.ProductID
    GROUP BY c.CustomerID, c.Country
),
ranked AS (
    SELECT 
        CustomerID,
        Country,
        total_spent,
        RANK() OVER (PARTITION BY Country ORDER BY total_spent DESC) AS spend_rank
    FROM country_spend
)
SELECT 
    CustomerID,
    Country,
    total_spent
FROM ranked
WHERE spend_rank = 1;

-- =====================
-- COMBINED RFM
-- =====================

-- Q9: Using recency, frequency and spend together, which segment does each customer belong to?
WITH recency AS (
    SELECT 
        CustomerID,
        DATEDIFF(CURRENT_DATE(), MAX(OrderDate)) AS days_ago
    FROM Orders
    GROUP BY CustomerID
),
frequency AS (
    SELECT 
        CustomerID,
        COUNT(DISTINCT OrderID) AS total_orders
    FROM Orders
    GROUP BY CustomerID
),
monetary AS (
    SELECT 
        o.CustomerID,
        SUM(od.Quantity * p.Price) AS total_spend
    FROM Orders o
    JOIN OrderDetails od ON o.OrderID = od.OrderID
    JOIN Products p ON p.ProductID = od.ProductID
    GROUP BY o.CustomerID
)
SELECT 
    r.CustomerID,
    r.days_ago,
    f.total_orders,
    m.total_spend,
    CASE
        WHEN r.days_ago <= 90 AND f.total_orders >= 5 THEN 'High Value'
        WHEN r.days_ago > 180 THEN 'At Risk'
        WHEN f.total_orders = 1 THEN 'One-Time Buyer'
        ELSE 'Regular'
    END AS customer_segment
FROM recency r
JOIN frequency f ON r.CustomerID = f.CustomerID
JOIN monetary m ON r.CustomerID = m.CustomerID;

-- Q10: How many customers are in each segment, and how much revenue does each segment hold?
WITH recency AS (
    SELECT 
        CustomerID,
        DATEDIFF(CURRENT_DATE(), MAX(OrderDate)) AS days_ago
    FROM Orders
    GROUP BY CustomerID
),
frequency AS (
    SELECT 
        CustomerID,
        COUNT(DISTINCT OrderID) AS total_orders
    FROM Orders
    GROUP BY CustomerID
),
monetary AS (
    SELECT 
        o.CustomerID,
        SUM(od.Quantity * p.Price) AS total_spend
    FROM Orders o
    JOIN OrderDetails od ON o.OrderID = od.OrderID
    JOIN Products p ON p.ProductID = od.ProductID
    GROUP BY o.CustomerID
),
rfm AS (
    SELECT 
        r.CustomerID,
        r.days_ago,
        f.total_orders,
        m.total_spend,
        CASE
            WHEN r.days_ago <= 90 AND f.total_orders >= 5 THEN 'High Value'
            WHEN r.days_ago > 180 THEN 'At Risk'
            WHEN f.total_orders = 1 THEN 'One-Time Buyer'
            ELSE 'Regular'
        END AS customer_segment
    FROM recency r
    JOIN frequency f ON r.CustomerID = f.CustomerID
    JOIN monetary m ON r.CustomerID = m.CustomerID
)
SELECT 
    customer_segment,
    COUNT(*) AS num_customers,
    ROUND(SUM(total_spend), 2) AS total_revenue
FROM rfm
GROUP BY customer_segment
ORDER BY total_revenue DESC;
