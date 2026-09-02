-- Sales Performance Analytics
-- Day 07 - Window Functions
--
-- Topics:
-- LAG, RANK, PARTITION BY,
-- Month-over-Month Growth,
-- temporal comparison and rankings


-- 1. Monthly net revenue with previous month comparison

WITH faturamento_mensal AS (

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
)

SELECT
    mes,
    faturamento_liquido,

    LAG(faturamento_liquido)
        OVER (
            ORDER BY mes
        ) AS faturamento_mes_anterior

FROM faturamento_mensal

ORDER BY mes;


-- 2. Month-over-Month growth percentage

WITH faturamento_mensal AS (

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
),

comparacao_mensal AS (

    SELECT
        mes,
        faturamento_liquido,

        LAG(faturamento_liquido)
            OVER (
                ORDER BY mes
            ) AS faturamento_mes_anterior

    FROM faturamento_mensal
)

SELECT
    mes,
    faturamento_liquido,
    faturamento_mes_anterior,

    ROUND(
        (
            faturamento_liquido
            - faturamento_mes_anterior
        )
        /
        NULLIF(faturamento_mes_anterior, 0)
        * 100,
        2
    ) AS crescimento_mom_pct

FROM comparacao_mensal

ORDER BY mes;


-- 3. Product ranking by total net revenue

WITH faturamento_produto AS (

    SELECT
        p.produto,

        SUM(
            f.quantidade
            * p.preco_unitario
            * (1 - f.desconto_pct)
        ) AS faturamento_liquido

    FROM fato_vendas AS f

    INNER JOIN dim_produtos AS p
        ON f.id_produto = p.id_produto

    GROUP BY p.produto
)

SELECT
    RANK()
        OVER (
            ORDER BY faturamento_liquido DESC
        ) AS ranking,

    produto,
    faturamento_liquido

FROM faturamento_produto

ORDER BY ranking;


-- 4. Product ranking within each region

WITH ranking_por_regiao AS (

    SELECT
        c.regiao,
        p.produto,

        SUM(
            f.quantidade
            * p.preco_unitario
            * (1 - f.desconto_pct)
        ) AS faturamento_liquido

    FROM fato_vendas AS f

    INNER JOIN dim_clientes AS c
        ON c.id_cliente = f.id_cliente

    INNER JOIN dim_produtos AS p
        ON p.id_produto = f.id_produto

    GROUP BY
        c.regiao,
        p.produto
)

SELECT
    regiao,
    produto,
    faturamento_liquido,

    RANK()
        OVER (
            PARTITION BY regiao
            ORDER BY faturamento_liquido DESC
        ) AS ranking_regiao

FROM ranking_por_regiao

ORDER BY
    regiao,
    ranking_regiao;


-- BUSINESS INSIGHTS
--
-- 1. November showed the highest Month-over-Month
-- growth in net revenue, with a strong increase
-- compared with October.
--
-- 2. A strong monthly increase should not be interpreted
-- automatically as sustainable growth. It is necessary
-- to investigate product mix, customers, regions,
-- transaction volume, discounts and profitability.
--
-- 3. December showed a significant decline compared
-- with November, but this should be interpreted carefully
-- because November was an unusually strong month.
-- This is an example of a possible base effect.
--
-- 4. Notebook products occupy the top revenue positions
-- across multiple regions, indicating strong commercial
-- concentration in the Information Technology category.
--
-- 5. Ranking by region helps identify which products
-- drive revenue locally, rather than only at company level.
