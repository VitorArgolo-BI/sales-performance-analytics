-- Sales Performance Analytics
-- Day 03 - Profitability Analysis
-- Topics: LIKE, NOT, HAVING, aliases,
-- gross revenue, net revenue, cost and gross profit


-- PARTE A - FILTROS


-- 1. Produtos contendo a palavra Notebook

SELECT *
FROM vendas
WHERE produto LIKE '%Notebook%';


-- 2. Vendas que não sejam da região Sudeste

SELECT *
FROM vendas
WHERE regiao <> 'Sudeste';


-- 3. Vendas das regiões Sul ou Centro-Oeste
-- com quantidade maior que 5

SELECT *
FROM vendas
WHERE regiao IN ('Sul', 'Centro-Oeste')
  AND quantidade > 5;


-- PARTE B - MÉTRICAS POR TRANSAÇÃO


-- 4, 5 e 6.
-- Faturamento bruto, faturamento líquido e custo total

SELECT
    produto,
    quantidade,
    preco_unitario,

    quantidade * preco_unitario
        AS faturamento_bruto,

    quantidade * preco_unitario * (1 - desconto_pct)
        AS faturamento_liquido,

    quantidade * custo_unitario
        AS custo_total

FROM vendas;


-- PARTE C - ANÁLISE DE NEGÓCIO


-- 7. Faturamento líquido por região

SELECT
    regiao,

    SUM(
        quantidade * preco_unitario * (1 - desconto_pct)
    ) AS faturamento_liquido

FROM vendas
GROUP BY regiao
ORDER BY faturamento_liquido DESC;


-- 8. Lucro bruto por região

SELECT
    regiao,

    SUM(
        quantidade * preco_unitario * (1 - desconto_pct)
    ) AS faturamento_liquido,

    SUM(
        quantidade * custo_unitario
    ) AS custo_total,

    SUM(
        quantidade * preco_unitario * (1 - desconto_pct)
        -
        quantidade * custo_unitario
    ) AS lucro_bruto

FROM vendas
GROUP BY regiao
ORDER BY lucro_bruto DESC;


-- 9. Lucro bruto por vendedor

SELECT
    vendedor,

    SUM(
        quantidade * preco_unitario
    ) AS faturamento_bruto,

    SUM(
        quantidade * preco_unitario * (1 - desconto_pct)
    ) AS faturamento_liquido,

    SUM(
        quantidade * custo_unitario
    ) AS custo_total,

    SUM(
        quantidade * preco_unitario * (1 - desconto_pct)
        -
        quantidade * custo_unitario
    ) AS lucro_bruto

FROM vendas
GROUP BY vendedor
ORDER BY lucro_bruto DESC;


-- 10. Vendedores com faturamento bruto
-- acima de R$ 150.000

SELECT
    vendedor,
    SUM(
        quantidade * preco_unitario
    ) AS faturamento_bruto

FROM vendas

GROUP BY vendedor

HAVING SUM(
    quantidade * preco_unitario
) > 150000

ORDER BY faturamento_bruto DESC;


-- PARTE D - MÚLTIPLAS MÉTRICAS POR REGIÃO


SELECT
    regiao,

    COUNT(*) AS total_transacoes,

    COUNT(DISTINCT id_cliente)
        AS clientes_unicos,

    SUM(quantidade)
        AS unidades_vendidas,

    SUM(
        quantidade * preco_unitario
    ) AS faturamento_bruto,

    SUM(
        quantidade * preco_unitario * (1 - desconto_pct)
    ) AS faturamento_liquido

FROM vendas

GROUP BY regiao

ORDER BY faturamento_liquido DESC;


-- EXTRA
-- Margem bruta por região

SELECT
    regiao,

    SUM(
        quantidade * preco_unitario * (1 - desconto_pct)
    ) AS faturamento_liquido,

    SUM(
        quantidade * preco_unitario * (1 - desconto_pct)
        -
        quantidade * custo_unitario
    ) AS lucro_bruto,

    (
        SUM(
            quantidade * preco_unitario * (1 - desconto_pct)
            -
            quantidade * custo_unitario
        )
        /
        SUM(
            quantidade * preco_unitario * (1 - desconto_pct)
        )
    ) * 100 AS margem_bruta_pct

FROM vendas

GROUP BY regiao

ORDER BY margem_bruta_pct DESC;


-- EXTRA
-- Faturamento líquido por categoria

SELECT
    categoria,

    SUM(
        quantidade * preco_unitario * (1 - desconto_pct)
    ) AS faturamento_liquido

FROM vendas

GROUP BY categoria

ORDER BY faturamento_liquido DESC;
