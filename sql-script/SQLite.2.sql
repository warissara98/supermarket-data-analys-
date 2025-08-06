--Supermarket Performance--
WITH
  t2007 AS (
  SELECT
    SUM(spend) AS sales,
    COUNT(DISTINCT cust_code) AS num_cust,
    COUNT(DISTINCT basket_id) AS num_bask,
    CAST(SUBSTR(shop_date,1,4) AS numeric) AS shop_year
  FROM  dunnhumbyalldata
  WHERE
    SUBSTR(shop_date,1,7)='2007-02'
  GROUP BY
    CAST(SUBSTR(shop_date,1,4) AS numeric)),
  t2008 AS (
  SELECT
    SUM(spend) AS sales,
    COUNT(DISTINCT cust_code) AS num_cust,
    COUNT(DISTINCT basket_id) AS num_bask,
    CAST(SUBSTR(shop_date,1,4) AS numeric) AS shop_year
  FROM dunnhumbyalldata
  WHERE
    SUBSTR(shop_date,1,7)='2008-02'
  GROUP BY
    CAST(SUBSTR(shop_date,1,4) AS numeric)
    )

SELECT
  ROUND(t2008.sales,2) AS sales,
  t2008.num_cust,
  t2008.num_bask,
  ROUND(t2007.sales,2) AS ly_sales,
  t2007.num_cust AS ly_num_cust,
  t2007.num_bask AS ly_num_bask,
  ROUND(t2008.sales/t2007.sales -1,2) AS yoy_sales,
  ROUND(t2008.num_cust/t2007.num_cust -1,2) AS yoy_customers,
  ROUND(t2008.num_bask/t2007.num_bASk -1,2) AS yoy_baskets
FROM
  t2007
INNER JOIN
  t2008
ON
  t2007.shop_year+1 = t2008.shop_year