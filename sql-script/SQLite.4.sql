--Customer Segmentation--
SELECT
  shop_year,
  cust_price_sensitivity,
  num_cust AS num_customer,
  ROUND(sales/num_cust,2) AS avg_spending_per_customer,
  ROUND((sales/num_cust)/LAG(sales/num_cust,1) OVER(PARTITION BY cust_price_sensitivity ORDER BY shop_year) -1,2) AS yoy_avg_spending_per_customer,
  ROUND(num_basket/num_cust,2) AS avg_total_visits,
  ROUND((num_basket/num_cust)/LAG(num_basket/num_cust,1) OVER(PARTITION BY cust_price_sensitivity ORDER BY shop_year)-1,2) AS yoy_avg_total_visits,
  ROUND(sales/num_basket,2) AS avg_basket_size,
  ROUND((sales/num_basket)/LAG(sales/num_basket,1) OVER(PARTITION BY cust_price_sensitivity ORDER BY shop_year)-1,2) AS yoy_avg_basket_size,
  ROUND(units/num_basket,2) AS avg_unit_per_basket,
  ROUND((units/num_basket)/LAG(units/num_basket,1) OVER(PARTITION BY cust_price_sensitivity ORDER BY shop_year)-1,2) AS yoy_unit_per_basket
FROM (
  SELECT
    SUBSTR(shop_date,1,4) AS shop_year,
    cust_price_sensitivity,
    SUM(spend) AS sales,
    SUM(quantity) AS units,
    COUNT(DISTINCT cust_code) AS num_cust,
    COUNT(DISTINCT basket_id) AS num_basket
  FROM dunnhumbyalldata
  WHERE
    SUBSTR(shop_date,1,7) IN ('2007-02','2008-02')
  GROUP BY
    SUBSTR(shop_date,1,4),
    cust_price_sensitivity)
ORDER BY
  shop_year DESC,
  cust_price_sensitivity