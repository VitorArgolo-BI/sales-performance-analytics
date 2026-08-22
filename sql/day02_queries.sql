-- Sales Performance Analytics
-- Day 02 - SQL Fundamentals
-- Topics: SELECT, WHERE, AND, IN, BETWEEN,
-- COUNT, DISTINCT, SUM, AVG, GROUP BY, ORDER BY, LIMIT


-- 1. Mostrar todas as vendas da região Sudeste

SELECT *
FROM vendas
WHERE regiao = 'Sudeste';


-- 2. Mostrar colunas específicas

SELECT
    data_venda,
    cliente,
    produto,
    quantidade
FROM vendas;


-- 3. Mostrar vendas com quantidade maior que 10

SELECT *
FROM vendas
WHERE quantidade > 10;


-- 4. Mostrar vendas da região Sul com quantidade maior ou igual a 5

SELECT *
FROM vendas
WHERE regiao = 'Sul'
  AND quantidade >= 5;


-- 5. Mostrar vendas das categorias Informática ou Monitores

SELECT *
FROM vendas
WHERE categoria IN ('Informática', 'Monitores');


-- 6. Mostrar vendas do primeiro trimestre de 2025

SELECT *
FROM vendas
WHERE data_venda BETWEEN '2025-01-01' AND '2025-03-31';


-- 7. Contar clientes únicos

SELECT
    COUNT(DISTINCT id_cliente) AS total_clientes
FROM vendas;


-- 8. Calcular faturamento bruto total

SELECT
    SUM(preco_unitario * quantidade) AS faturamento_bruto
FROM vendas;


-- 9. Faturamento bruto por vendedor

SELECT
    vendedor,
    SUM(preco_unitario * quantidade) AS faturamento_bruto
FROM vendas
GROUP BY vendedor
ORDER BY faturamento_bruto DESC;


-- 10. Faturamento bruto por região

SELECT
    regiao,
    SUM(preco_unitario * quantidade) AS faturamento_bruto
FROM vendas
GROUP BY regiao
ORDER BY faturamento_bruto DESC;


-- 11. Top 5 produtos por faturamento bruto

SELECT
    produto,
    SUM(preco_unitario * quantidade) AS faturamento_bruto
FROM vendas
GROUP BY produto
ORDER BY faturamento_bruto DESC
LIMIT 5;


-- 12. Quantidade média vendida por transação

SELECT
    AVG(quantidade) AS media_quantidade_transacao
FROM vendas;
