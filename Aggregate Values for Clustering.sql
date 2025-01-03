WITH customer_transaction_summary AS (
    SELECT
        CustomerID,
        InvoiceNo,
        SUM(Quantity) AS total_quantity_per_invoice
    FROM [Cleaned Data Set]
    GROUP BY CustomerID, InvoiceNo
), 
customer_basket_size AS (
    SELECT 
        CustomerID,
        AVG(total_quantity_per_invoice) AS avg_basket_size
    FROM customer_transaction_summary
    GROUP BY CustomerID
),
max_date AS (
    SELECT 
        MAX(InvoiceDate) AS max_invoice_date
    FROM [Cleaned Data Set]
)

SELECT
    c.CustomerID,
    ROUND(SUM(c.UnitPrice * c.Quantity), 2) AS Price,
    COUNT(DISTINCT c.InvoiceNo) AS Frequency,
    cb.avg_basket_size AS Basket_Size,
    DATEDIFF(day, MAX(c.InvoiceDate), (SELECT max_invoice_date FROM max_date)) AS Recency,
    ROUND(SUM(c.UnitPrice * c.Quantity) / COUNT(DISTINCT c.InvoiceNo), 2) AS Amount_Spent_per_Visit
FROM [Cleaned Data Set] AS c
JOIN customer_basket_size AS cb ON c.CustomerID = cb.CustomerID
GROUP BY c.CustomerID, cb.avg_basket_size
ORDER BY c.CustomerID;