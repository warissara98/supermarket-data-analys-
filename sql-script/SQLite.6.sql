-- Customer Targeting Report--
SELECT
  cust_code,
  basket_id,
  shop_date,
  SUM(quantity) AS units,
  SUM(spend) AS total_spend
FROM dunnhumbyalldata
WHERE
  cust_price_sensitivity = 'Mid Market'
  AND basket_id IN (
  SELECT
    FIRST_VALUE(basket_id) OVER(PARTITION BY cust_code ORDER BY shop_date DESC)
  FROM dunnhumbyalldata )
GROUP BY
  cust_code,
  basket_id,
  shop_date
ORDER BY
  total_spend DESC