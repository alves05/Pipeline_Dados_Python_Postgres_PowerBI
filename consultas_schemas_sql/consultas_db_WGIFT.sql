-- Consultas SQL

-- Tabela clientes
SELECT * FROM dimensional.dclientes;

-- Tabela produtos
SELECT * FROM dimensional.dprodutos;

-- Tabela vendas
SELECT * FROM dimensional.fvendas;

-- Tabela calendario
SELECT * FROM dimensional.dcalendario;

-- Quantidade de vendas canceladas
SELECT COUNT(invoice) AS Total_notas_canceladas 
FROM dimensional.fvendas
WHERE invoice LIKE 'C%';

-- O faturamento total
SELECT SUM(total_vendido) AS Faturamento_total
FROM dimensional.fvendas;

-- Total faturado nos anos 2009, 2010 e 2011
SELECT
    (SELECT SUM(total_vendido) 
     FROM dimensional.fvendas
     WHERE data >= '2009-01-01' AND data <= '2009-12-31') AS Faturamento_2009,
    (SELECT SUM(total_vendido) 
     FROM dimensional.fvendas
     WHERE data >= '2010-01-01' AND data <= '2010-12-31') AS Faturamento_2010,
    (SELECT SUM(total_vendido)
     FROM dimensional.fvendas
     WHERE data >= '2011-01-01' AND data <= '2011-12-31') AS Faturamento_2011;

-- Quantidade Total da variedade de produtos vendidos
SELECT SUM(quantidade) AS Quantidade_produtos_vendidos
FROM dimensional.fvendas;

-- Total de clientes por país
SELECT 
    l.localizacao,
    count(distinct id_cliente) as total
FROM dimensional.fvendas v
INNER JOIN dimensional.dlocalizacao l ON l.id_localizacao = v.id_localizacao
GROUP BY l.localizacao
ORDER BY total DESC;

-- Os 10 maiores clientes
SELECT
    c.cliente as Clientes,
    sum(total_vendido) as Total_vendas
FROM dimensional.fvendas v
INNER JOIN dimensional.dclientes c ON v.id_cliente = c.id_cliente
GROUP BY c.cliente
ORDER BY Total_vendas DESC
LIMIT 10;

-- Os 10 produtos mais vendidos
SELECT 
    p.produto AS Produtos,
    SUM(quantidade) AS Total
FROM dimensional.fvendas v
INNER JOIN dimensional.dprodutos p ON v.id_produto = p.id_produto
GROUP BY p.produto
ORDER BY Total DESC
LIMIT 10;

-- As 10 notas emitidas com maior faturamento
SELECT 
    data,
    invoice,
    SUM(total_vendido) AS total_nota
FROM dimensional.fvendas
GROUP BY invoice, data
ORDER BY total_nota DESC
LIMIT 10;

-- Os 10 paises com mais vendas
SELECT 
    c.localizacao,
    count(invoice) AS Quantidade_vendas
FROM dimensional.fvendas v
INNER JOIN dimensional.dclientes c ON v.id_cliente = c.id_cliente
GROUP BY localizacao
ORDER BY Quantidade_vendas DESC
LIMIT 10;



