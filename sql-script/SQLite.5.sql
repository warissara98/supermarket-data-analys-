--Customer Segmentation--
WITH
  t2007 AS (
  SELECT
    SUM(spend)/COUNT(DISTINCT cust_code) AS avg_spending_per_customer,
    COUNT(DISTINCT basket_id)/COUNT(DISTINCT cust_code) AS avg_total_visits,
    SUM(spend)/COUNT(DISTINCT basket_id) AS avg_basket_size,
    SUM(quantity)/COUNT(DISTINCT basket_id) AS avg_unit_per_basket,
    CAST(SUBSTR(shop_date,1,4) AS numeric) AS shop_year,
    cust_price_sensitivity
  FROM dunnhumbyalldata
  WHERE
    SUBSTR(shop_date,1,7)= '2007-02'GROUP BY CAST(SUBSTR(shop_date,1,4) AS numeric),
    cust_price_sensitivity),
  t2008 AS (
  SELECT
    SUM(spend)/COUNT(DISTINCT cust_code) AS avg_spending_per_customer,
    COUNT(DISTINCT basket_id)/COUNT(DISTINCT cust_code) AS avg_total_visits,
    SUM(spend)/COUNT(DISTINCT basket_id) AS avg_basket_size,
    SUM(quantity)/COUNT(DISTINCT basket_id) AS avg_unit_per_basket,
    CAST(SUBSTR(shop_date,1,4) AS numeric) AS shop_year,
    cust_price_sensitivity
  FROM dunnhumbyalldata
  WHERE
    SUBSTR(shop_date,1,7)= '2008-02'
  GROUP BY CAST(SUBSTR(shop_date,1,4) AS numeric),cust_price_sensitivity
  )

SELECT
  t2008.cust_price_sensitivity,
  ROUND(t2008.avg_spending_per_customer,2) AS avg_spending_per_customer,
  ROUND(t2008.avg_total_visits,2) AS avg_total_visits,
  ROUND(t2008.avg_basket_size,2) AS avg_basket_size,
  ROUND(t2008.avg_unit_per_basket,2) AS avg_unit_per_basket,
  ROUND(t2007.avg_spending_per_customer,2) AS ly_avg_spending_per_customer,
  ROUND(t2007.avg_total_visits,2) AS ly_avg_total_visits,
  ROUND(t2007.avg_basket_size,2) AS ly_avg_basket_size,
  ROUND(t2007.avg_unit_per_basket,2) AS ly_avg_unit_per_basket,
  ROUND(t2008.avg_spending_per_customer/t2007.avg_spending_per_customer -1,2) AS yoy_avg_spending_per_customer,
  ROUND(t2008.avg_total_visits/t2007.avg_total_visits -1,2) AS yoy_avg_total_visits,
  ROUND(t2008.avg_basket_size/t2007.avg_basket_size -1,2) AS yoy_avg_basket_size,
  ROUND(t2008.avg_unit_per_basket/t2007.avg_unit_per_basket -1,2) AS yoy_unit_per_basket
FROM
  t2007
INNER JOIN
  t2008
ON
  t2007.shop_year+1 = t2008.shop_year
  AND t2007.cust_price_sensitivity = t2008.cust_price_sensitivity