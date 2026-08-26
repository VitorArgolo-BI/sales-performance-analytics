-- Sales Performance Analytics
-- Day 05 - Relational Analysis and JOINs
--
-- Topics:
-- INNER JOIN, LEFT JOIN, Primary Key,
-- Foreign Key, Fact Tables, Dimension Tables,
-- NULL values and relational analysis


-- 1. Sales with product information

SELECT
    f.id_venda,
    f.data_venda,
    p.produto,
    p.categoria,
    f.quantidade

FROM fato_vendas AS f

INNER JOIN dim_produtos AS p
    ON f.id_produto = p.id_produto;


-- 2. Sales with customer and product information

SELECT
    c.cliente,
    c.cidade,
    c.estado,
    p.produto,
    f.quantidade

FROM fato_vendas AS f

INNER JOIN dim_clientes AS c
    ON c.id_cliente = f.id_cliente

INNER JOIN dim_produtos AS p
    ON p.id_produto = f.id_produto;


-- 3. Gross revenue by product category

SELECT
    p.categoria,

    SUM(
        f.quantidade
    ) AS unidades_vendidas,

    SUM(
        f.quantidade
        * p.preco_unitario
    ) AS faturamento_bruto

FROM fato_vendas AS f

INNER JOIN dim_produtos AS p
    ON p.id_produto = f.id_produto

GROUP BY p.categoria

ORDER BY faturamento_bruto DESC;


-- 4. Net revenue by salesperson

SELECT
    v.vendedor,

    SUM(
        f.quantidade
        * p.preco_unitario
        * (1 - f.desconto_pct)
    ) AS faturamento_liquido

FROM fato_vendas AS f

INNER JOIN dim_produtos AS p
    ON p.id_produto = f.id_produto

INNER JOIN dim_vendedores AS v
    ON v.id_vendedor = f.id_vendedor

GROUP BY v.vendedor

ORDER BY faturamento_liquido DESC;


-- Optional test customer for LEFT JOIN exercises
-- INSERT OR IGNORE prevents duplicate errors if the script is run again.

INSERT OR IGNORE INTO dim_clientes (
    id_cliente,
    cliente,
    segmento,
    cidade,
    estado,
    regiao
)

VALUES (
    'C999',
    'Nova Empresa Teste',
    'PME',
    'Goiânia',
    'GO',
    'Centro-Oeste'
);


-- 5. Total purchases by customer
-- LEFT JOIN keeps customers that have never purchased.

SELECT
    c.cliente,

    COUNT(
        f.id_venda
    ) AS total_compras

FROM dim_clientes AS c

LEFT JOIN fato_vendas AS f
    ON c.id_cliente = f.id_cliente

GROUP BY
    c.id_cliente,
    c.cliente

ORDER BY total_compras DESC;


-- 6. Customers without purchases

SELECT
    c.id_cliente,
    c.cliente

FROM dim_clientes AS c

LEFT JOIN fato_vendas AS f
    ON c.id_cliente = f.id_cliente

WHERE f.id_venda IS NULL;


-- 7. Units sold by product

SELECT
    p.produto,
    p.categoria,

    SUM(
        f.quantidade
    ) AS unidades_vendidas

FROM dim_produtos AS p

INNER JOIN fato_vendas AS f
    ON f.id_produto = p.id_produto

GROUP BY
    p.produto,
    p.categoria

ORDER BY unidades_vendidas DESC;


-- 8. Net revenue by customer

SELECT
    c.cliente,

    SUM(
        f.quantidade
        * p.preco_unitario
        * (1 - f.desconto_pct)
    ) AS faturamento_liquido

FROM dim_clientes AS c

INNER JOIN fato_vendas AS f
    ON c.id_cliente = f.id_cliente

INNER JOIN dim_produtos AS p
    ON p.id_produto = f.id_produto

GROUP BY
    c.id_cliente,
    c.cliente

ORDER BY faturamento_liquido DESC;


-- CONCEPTS
--
-- fato_vendas:
-- Stores measurable business events (sales transactions).
--
-- dim_clientes:
-- Stores descriptive customer information.
--
-- dim_produtos:
-- Stores descriptive product information.
--
-- dim_vendedores:
-- Stores descriptive salesperson information.
--
-- INNER JOIN:
-- Returns records that have matching keys in both tables.
--
-- LEFT JOIN:
-- Preserves every record from the left table,
-- even when there is no matching record on the right.
--
-- Primary Key:
-- Uniquely identifies a record in a table.
--
-- Foreign Key:
-- References the primary key of another table
-- and creates a relationship between the tables.
