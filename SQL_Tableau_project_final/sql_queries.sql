-- Task 1: Користувачі з Бразилії за 2023 рік

SELECT 
    first_name, 
    last_name, 
    email
FROM 
    bigquery-public-data.thelook_ecommerce.users
WHERE 
    country = 'Brasil' 
    AND created_at BETWEEN '2023-01-01' AND '2023-12-31 23:59:59'
;

-- Task 2: Кількість товарів за категоріями

SELECT 
    category, 
    COUNT(*) AS product_count
FROM 
    bigquery-public-data.thelook_ecommerce.products
GROUP BY 
    category
ORDER BY 
    product_count DESC
;

-- Task 3: Аналіз замовлень (відправлені)

SELECT 
    o.order_id, 
    u.first_name, 
    u.last_name, 
    o.status
FROM 
    bigquery-public-data.thelook_ecommerce.orders AS o
JOIN 
    bigquery-public-data.thelook_ecommerce.users AS u 
    ON o.user_id = u.id
WHERE 
    o.status = 'Shipped'
;

-- Task 4: Фінанси — найдорожчі замовлення (10)

SELECT 
    order_id, 
    user_id,
    total_sum,
    rank 
FROM (
    SELECT 
    order_id, 
    user_id, 
    SUM(sale_price) AS total_sum, 
    RANK() OVER (ORDER BY SUM(sale_price) DESC) AS rank 
    FROM bigquery-public-data.thelook_ecommerce.order_items GROUP BY order_id, user_id
    ) AS virtual_table
WHERE rank <= 10
;

-- Task 5: Географія покупців

SELECT 
    country,
    COUNT(DISTINCT id) AS member_count
FROM 
    bigquery-public-data.thelook_ecommerce.users
GROUP BY country
HAVING member_count > 500
ORDER BY member_count DESC
;