# RFM Customer Segmentation

## Business Question
Which customers are the most valuable, and which are at risk of leaving?

## Dataset
Northwind database (Orders, OrderDetails, Products, Customers tables).

## What is RFM?
- **Recency:** how many days since the customer's last order
- **Frequency:** how many orders the customer has placed
- **Monetary:** how much the customer has spent in total

## SQL Concepts Used
Joins, GROUP BY, CASE WHEN, CTEs, window functions (RANK).

## Segments
| Segment | Rule |
|---|---|
| High Value | Ordered within 90 days and 5+ orders |
| At Risk | No order in over 180 days |
| One-Time Buyer | Only 1 order |
| Regular | Everyone else |

## Findings
| Segment | Customers | Total Revenue |
|---|---|---|
| (paste your Q10 rows here) | | |

## Conclusion
(2-3 sentences: which segment holds the most revenue, and how many customers are at risk)

## Recommendations
- (one action for At Risk customers)
- (one action for High Value customers)

## Files
- `business-questions-and-queries.sql`: all 10 questions and queries
