-- =====================================
-- KPIs PRINCIPAUX

-- Chiffre d'affaires total
SELECT 
SUM(CAST(REPLACE(total_price, ',', '.') AS REAL)) AS chiffre_d_affaires
FROM pizza_sales_excel_file;

-- Nombre total de commandes
SELECT 
COUNT(DISTINCT order_id) AS nb_commandes
FROM pizza_sales_excel_file;

-- Volume de pizzas vendues
SELECT 
SUM(quantity) AS total_pizzas
FROM pizza_sales_excel_file;

-- Panier moyen
SELECT 
SUM(CAST(REPLACE(total_price, ',', '.') AS REAL))
/ COUNT(DISTINCT order_id) AS panier_moyen
FROM pizza_sales_excel_file;


-- =====================================
-- ANALYSE DES VENTES
-- =====================================

-- Répartition du CA par taille
WITH total_ca AS (
    SELECT 
        SUM(CAST(REPLACE(total_price, ',', '.') AS REAL)) AS ca_total
    FROM pizza_sales_excel_file
),
ca_par_taille AS (
    SELECT
        pizza_size,
        SUM(CAST(REPLACE(total_price, ',', '.') AS REAL)) AS ca_taille
    FROM pizza_sales_excel_file
    GROUP BY pizza_size
)
SELECT
    pizza_size,
    ROUND(ca_taille * 100.0 / ca_total, 2) AS percentage
FROM ca_par_taille, total_ca;


-- Répartition par catégorie
SELECT
    pizza_category,
    SUM(quantity) AS total_vendu
FROM pizza_sales_excel_file
GROUP BY pizza_category;


-- =====================================
-- ANALYSE TEMPORELLE
-- =====================================

-- Commandes par jour
SELECT 
    strftime('%w', order_date) AS jour,
    COUNT(DISTINCT order_id) AS nb_commandes
FROM pizza_sales_excel_file
GROUP BY jour;

-- Commandes par heure
SELECT 
    strftime('%H', order_time) AS heure,
    COUNT(DISTINCT order_id) AS nb_commandes
FROM pizza_sales_excel_file
GROUP BY heure;


-- =====================================
-- TOP & FLOP PRODUITS
-- =====================================

-- Top 5 pizzas
SELECT 
pizza_name,
SUM(quantity) AS total_vendu
FROM pizza_sales_excel_file
GROUP BY pizza_name
ORDER BY total_vendu DESC
LIMIT 5;

-- Flop 5 pizzas
SELECT 
pizza_name,
SUM(quantity) AS total_vendu
FROM pizza_sales_excel_file
GROUP BY pizza_name
ORDER BY total_vendu ASC
LIMIT 5;