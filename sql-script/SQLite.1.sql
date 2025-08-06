--Supermarket Performance--
SELECT
  shop_year,
  ROUND(sales,2) AS sales,
  ROUND(sales/LAG(sales,1) OVER(ORDER BY shop_year) -1,2) AS yoy_sales,
  num_cust,
  ROUND(num_cust/LAG(num_cust,1) OVER(ORDER BY shop_year) -1,2) AS yoy_customers,
  num_bask,
  ROUND(num_bask/LAG(num_bask,1) OVER(ORDER BY shop_year) -1,2) AS yoy_baskets
FROM (
  SELECT
    SUM(spend) AS sales,
    COUNT(DISTINCT cust_code) AS num_cust,
    COUNT(DISTINCT basket_id) AS num_bask,
    SUBSTR(shop_date,1,4) AS shop_year
  FROM dunnhumbyalldata
  WHERE
    SUBSTR(shop_date,1,7) IN ('2007-02', '2008-02')
  GROUP BY
    SUBSTR(shop_date,1,4))