-- Sales Performance Analytics
-- Day 06 - Time Analysis and CTE
--
-- Topics:
-- STRFTIME, monthly analysis,
-- CTE, revenue and profitability over time


-- 1. Monthly transaction count

SELECT
    strftime('%Y-%m', data_venda) AS mes,
    COUNT(*) AS total_transacoes

FROM fato_vendas

GROUP BY mes

ORDER BY mes;


-- 2. Monthly net revenue

SELECT
    strftime('%Y-%m', f.data_venda) AS mes,

    SUM(
        f.quantidade
        * p.preco_unitario
        * (1 - f.desconto_pct)
    ) AS faturamento_liquido

FROM fato_vendas AS f

INNER JOIN dim_produtos AS p
    ON f.id_produto = p.id_produto

GROUP BY mes

ORDER BY mes;


-- 3. Monthly sales performance

SELECT
    strftime('%Y-%m', f.data_venda) AS mes,

    SUM(
        f.quantidade
    ) AS unidades_vendidas,

    SUM(
        f.quantidade
        * p.preco_unitario
    ) AS faturamento_bruto,

    SUM(
        f.quantidade
        * p.preco_unitario
        * (1 - f.desconto_pct)
    ) AS faturamento_liquido,

    SUM(
        f.quantidade
        * p.preco_unitario
        * (1 - f.desconto_pct)
        -
        f.quantidade
        * p.custo_unitario
    ) AS lucro_bruto

FROM fato_vendas AS f

INNER JOIN dim_produtos AS p
    ON f.id_produto = p.id_produto

GROUP BY mes

ORDER BY mes;


-- 4. Month with highest net revenue

SELECT
    strftime('%Y-%m', f.data_venda) AS mes,

    SUM(
        f.quantidade
        * p.preco_unitario
        * (1 - f.desconto_pct)
    ) AS faturamento_liquido

FROM fato_vendas AS f

INNER JOIN dim_produtos AS p
    ON f.id_produto = p.id_produto

GROUP BY mes

ORDER BY faturamento_liquido DESC

LIMIT 1;


-- 5. Analytical sales base using CTE

WITH base_vendas AS (

    SELECT
        f.data_venda,
        c.cliente,
        c.regiao,
        p.produto,
        p.categoria,
        v.vendedor,
        f.quantidade,

        f.quantidade
        * p.preco_unitario
            AS faturamento_bruto,

        f.quantidade
        * p.preco_unitario
        * (1 - f.desconto_pct)
            AS faturamento_liquido,

        f.quantidade
        * p.custo_unitario
            AS custo_total,

        f.quantidade
        * p.preco_unitario
        * (1 - f.desconto_pct)
        -
        f.quantidade
        * p.custo_unitario
            AS lucro_bruto

    FROM fato_vendas AS f

    INNER JOIN dim_clientes AS c
        ON f.id_cliente = c.id_cliente

    INNER JOIN dim_produtos AS p
        ON f.id_produto = p.id_produto

    INNER JOIN dim_vendedores AS v
        ON f.id_vendedor = v.id_vendedor
)

SELECT *
FROM base_vendas;


-- 6. Gross profit by region using CTE

WITH base_vendas AS (

    SELECT
        f.data_venda,
        c.cliente,
        c.regiao,
        p.produto,
        p.categoria,
        v.vendedor,
        f.quantidade,

        f.quantidade
        * p.preco_unitario
            AS faturamento_bruto,

        f.quantidade
        * p.preco_unitario
        * (1 - f.desconto_pct)
            AS faturamento_liquido,

        f.quantidade
        * p.custo_unitario
            AS custo_total,

        f.quantidade
        * p.preco_unitario
        * (1 - f.desconto_pct)
        -
        f.quantidade
        * p.custo_unitario
            AS lucro_bruto

    FROM fato_vendas AS f

    INNER JOIN dim_clientes AS c
        ON f.id_cliente = c.id_cliente

    INNER JOIN dim_produtos AS p
        ON f.id_produto = p.id_produto

    INNER JOIN dim_vendedores AS v
        ON f.id_vendedor = v.id_vendedor
)

SELECT
    regiao,

    SUM(
        lucro_bruto
    ) AS lucro_bruto

FROM base_vendas

GROUP BY regiao

ORDER BY lucro_bruto DESC;


-- BUSINESS INSIGHTS
--
-- 1. Monthly analysis helps identify revenue seasonality,
-- peaks and periods that deserve further investigation.
--
-- 2. The month with the highest net revenue should not
-- automatically be considered the best month.
--
-- 3. Profitability should also be analyzed using gross profit,
-- gross margin, transaction volume and product mix.
--
-- 4. November had the highest net revenue in the dataset,
-- while another month may generate higher gross profit.
--
-- 5. CTEs help separate data preparation from final analysis,
-- making complex SQL queries easier to read and maintain.
