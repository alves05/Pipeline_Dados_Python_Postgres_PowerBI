# Análise de Vendas com Python + SQL + PostgreSQL + Power BI

### Objetivo: 
Realizar todo processo de ETL (Extract, Transform, Load) usando liguagem Python e SQL em dados reais de varejo on-line, para criação de um banco de dados relacional usando SGBD (Sitema de gerenciamento de banco de dados) PostegreSQL, e criação de um dashboard para monitoramento das metricas de vendas usando Power BI.

### Base de dados:
O conjunto de dados usado neste projeto foi o Online Retail II, que contém todas as transações ocorridas de um varejo on-line do Reino Unido, os dados são do periodo entre 12/01/2009 e 12/09/2011 no formato .xlsx.
A base de dados esta diponivel clicando **[AQUI](https://archive.ics.uci.edu/ml/datasets/Online+Retail+II)**.

Dicionário dos dados:

|Coluna|Descrição|
|---|---|
|Invoice|Número da fatura. Nominal. Um número integral de 6 dígitos atribuído exclusivamente a cada transação. Se este código começar com a letra 'c', indica um cancelamento.|
|StockCode|Código do produto (item). Nominal. Um número integral de 5 dígitos atribuído exclusivamente a cada produto distinto.|
|Description|Nome do produto (item). Nominal.|
|Quantity|As quantidades de cada produto (item) por transação. Numérico.|
|InvoiceDate|Data e hora da fatura. Numérico. O dia e a hora em que uma transação foi gerada.|
|Price|Numérico. Preço do produto por unidade em libras esterlinas (£).|
|Customer ID|Número do cliente. Nominal. Um número integral de 5 dígitos atribuído exclusivamente a cada cliente.|
|Country|Nome do país. Nominal. O nome do país onde um cliente reside.|

