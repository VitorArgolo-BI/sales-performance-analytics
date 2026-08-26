-- Sales Performance Analytics
-- Day 04 - Margin Investigation
--
-- Business Question:
-- Why does the South region have the lowest gross margin?
--
-- Topics:
-- AVG, ROUND, CASE WHEN,
-- discounts, product mix and gross margin


-- 1. Average discount by region

SELECT
    regiao,
    ROUND(
        AVG(desconto_pct) * 100,
        2
    ) AS desconto_medio_pct

FROM vendas

GROUP BY regiao

ORDER BY desconto_medio_pct DESC;


-- 2. Average discount by salesperson

SELECT
    vendedor,
    regiao,

    ROUND(
        AVG(desconto_pct) * 100,
        2
    ) AS desconto_medio_pct

FROM vendas

GROUP BY
    vendedor,
    regiao

ORDER BY desconto_medio_pct DESC;


-- 3. South region sales with discount above 10%

SELECT *
FROM vendas

WHERE regiao = 'Sul'
  AND desconto_pct > 0.10;


-- 4. Net revenue by category in the South region

SELECT
    categoria,

    SUM(
        quantidade
        * preco_unitario
        * (1 - desconto_pct)
    ) AS faturamento_liquido

FROM vendas

WHERE regiao = 'Sul'

GROUP BY categoria

ORDER BY faturamento_liquido DESC;


-- 5. Units sold by category in the South region

SELECT
    categoria,

    SUM(
        quantidade
    ) AS unidades_vendidas

FROM vendas

WHERE regiao = 'Sul'

GROUP BY categoria

ORDER BY unidades_vendidas DESC;


-- 6. Gross margin by category

SELECT
    categoria,

    SUM(
        quantidade
        * preco_unitario
        * (1 - desconto_pct)
    ) AS faturamento_liquido,

    SUM(
        quantidade
        * preco_unitario
        * (1 - desconto_pct)
        -
        quantidade
        * custo_unitario
    ) AS lucro_bruto,

    ROUND(
        (
            SUM(
                quantidade
                * preco_unitario
                * (1 - desconto_pct)
                -
                quantidade
                * custo_unitario
            )
            /
            SUM(
                quantidade
                * preco_unitario
                * (1 - desconto_pct)
            )
        ) * 100,
        2
    ) AS margem_bruta_pct

FROM vendas

GROUP BY categoria

ORDER BY margem_bruta_pct DESC;


-- 7. Discount classification using CASE WHEN

SELECT
    produto,
    desconto_pct,

    CASE
        WHEN desconto_pct <= 0.05 THEN 'Baixo'
        WHEN desconto_pct <= 0.10 THEN 'Medio'
        ELSE 'Alto'
    END AS faixa_desconto

FROM vendas;


-- 8. Number of sales by discount range

SELECT

    CASE
        WHEN desconto_pct <= 0.05 THEN 'Baixo'
        WHEN desconto_pct <= 0.10 THEN 'Medio'
        ELSE 'Alto'
    END AS faixa_desconto,

    COUNT(*) AS total_vendas

FROM vendas

GROUP BY faixa_desconto

ORDER BY total_vendas DESC;


-- BUSINESS INSIGHTS
--
-- 1. The South region does not have the highest average discount,
-- so discounts alone do not appear to explain its lower gross margin.
--
-- 2. The Information Technology category has one of the lowest
-- gross margins and represents a large share of South region revenue.
--
-- 3. The lower South region margin appears to be more strongly
-- associated with product mix than with discount levels alone.
