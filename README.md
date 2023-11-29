# Pipeline de Dados com Python, PostgreSQL e Power BI 

## Objetivo: 
O projeto tem o objetivo de demonstrar os passos de um pipeline de dados implementado em dados reais de um varejo on-line do Reino Unido, para tarefa aplicamos todo o processo de **ETL (Extract, Transform, Load)** com linguagem **Python e SQL**, com carga de dados para um banco relacional e modelagem dos dados para um data warehouse usando **PostgreSQL**, e finalizando com dashboard de monitoramento do setor de vendas da empresa com **Power BI**.

>*Disclaimer: a empresa mencionada na contextualização do problema de negócio é fictícia e os dados usados neste projeto são públicos*.

## Sobre a Base de dados:
O conjunto de dados usado neste projeto foi o *Online Retail II*, que contém todas as transações ocorridas de um varejo on-line do Reino Unido, os dados são do período entre **12/01/2009** e **12/09/2011** no formato *xlsx*. A base de dados está disponível na <strong>[UC Irvine Machine Learning Repository](https://archive.ics.uci.edu/ml/datasets/Online+Retail+II)</strong>.

<details>

<summary><b>Dicionário dos dados:</b></summary>

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

</details>

## Contextualização:

<p>A WGIFT E-commerce, é uma empresa de comércio eletrônico de artigos para presentes exclusivos para todas as ocasiões, seus clientes são atacadistas em todo mundo, nos últimos anos a empresa experimentou um rápido crescimento. Com o aumento significativo no número de clientes, transações e produtos, a empresa enfrenta desafios na gestão eficiente de seus dados de vendas. Atualmente, as informações estão dispersas em planilhas de excel, dificultando a análise holística do desempenho do negócio.</p>
<p>A empresa enfrenta dificuldades na obtenção de insights para o setor de vendas, devido à falta de uma infraestrutura de dados unificada. Os principais problemas incluem:</p>

- Desorganização de Dados.
- Desempenho Lento nas Consultas.
- Tomada de Decisão Ineficiente.

### Proposta de Solução:

- Criação de um Banco de Dados Relacional para armazenamento dos dados, e que possibilite integração com o sistema de gestão.
- Criação de um Data Warehouse, a partir dos dados armazenados no banco relacional.
- Criação de um Dashboard de Monitoramento, utilizando os dados modelados do Data Warehouse.


### Benefícios Esperados:

- Melhoria na Tomada de Decisão Estratégica.
- Eficiência Operacional no Setor de Vendas.
- Melhoria na Análise dos Cliente.
- Possibilitar Implementações de Análises Preditivas.

## Arquivos do Projeto:

||Arquivos|Links|
|---|---|---|
|1.|Base de Dados Original|[Link](/base_original/online_retail_II.xlsx)|
|2.|Notebook do Projeto|[Link](/Pipeline_Dados_Python_Postgres.ipynb)|
|3.|Schemas e Querys SQL|[Link](/consultas_schemas_sql/Schema-Relacional.png)|
|4.|Relatório Power BI|[Link](/relatorio_powerbi/Dashboard-Monitoramento-WGIFT.pbix)|
|5.|Imagens|[Link](/imagens/)|
|6.|License GNU|[Link](/LICENSE)|

## Data Pipeline:

Abaixo o esquema do pipeline de dados implementado neste projeto:

![Data Pipeline](/imagens/outros/datapipelinepng.png)

>Pipeline de dados, é um conjunto de processos e etapas que são usados para coletar, processar e mover dados de uma fonte para um destino. São usados em organizações para facilitar a ingestão, transformação e análise de dados de diferentes fontes, a fim de tomar decisões informadas, extrair insights e alimentar aplicativos com informações atualizadas.

## Dashboard de Monitoramento de Vendas Implementado:

>CLique na Imagem abaixo para abrir o Dashboard.

[![Dashboard](/imagens/template/dashboard.jpg)](https://app.powerbi.com/view?r=eyJrIjoiNjA2MmMwYzktNmJkZi00OGJiLWJjNmYtM2VmMGU5ZGY3MjE4IiwidCI6ImMxNDA5NGQwLTA0ZTMtNGM2YS1iMTM0LTg4ZTUxZDMwOWZmYyJ9)

## Ferramentas Usadas no Projeto:

Para implementação do projeto foram utilizadas as ferramentas, Anaconda com a linguagem Python na versão 3.11, linguagem SQL, Jupyter Notebook que é a IDE onde foi implementado o processo de carga, tratamento, transformação e modelagem dos dados para armazenamento em banco de dados, PostgreSQL que é o SGBD onde foram armazenados os dados modelados e o Power BI, uma ferramenta de BI usada para criação do dashboard de monitoramento de vendas.

As bibliotecas usadas no Python foram a Pandas, Faker, psycopg2, Seaborn, Matplotlib, Folium e geopy.

## Tratamento dos dados:

Os dados foram carregados e tratados usando funções implementadas para a situação especifica deste projeto. As funções implementadas foram:
<details>
<summary><b>Função ler_arquivo_excel()</b></summary>

> A função **`ler_arquivo_excel()`** cria um único objeto no formato ***DataFrame*** chamado **`planilha_unificada`**, o parâmetro **`arquivo=`** recebe o nome do arquivo da base de dados, já no parâmetro **`nome_tabela=`** recebe uma *tupla* contendo os nomes das tabelas internas do arquivo excel.

```
def ler_arquivo_excel(arquivo:'FilePath', nome_tabela:tuple) -> 'DataFrame':
    planilha_1 = pd.read_excel(arquivo, sheet_name=nome_tabela[0])
    planilha_2 = pd.read_excel(arquivo, sheet_name=nome_tabela[1])
    
    planilha_unificada = pd.concat([planilha_1, planilha_2])
    
    return planilha_unificada
```
</details>

<details>
<summary><b>Função transforma_dados()</b></summary>

> A função **`transforma_dados()`** rotorna o obejto ***DataFrame*** **`'dados'`**, após realizar as transformações de renomear as colunas, criar coluna Total_vendido e remover os valores NaN. O parâmetro **`dados_base=`** recebe o objeto ***DataFrame*** para realizar as transformações na base de dados.

```
def transforma_dados(dados_base:'DataFrame') -> 'DataFrame':
	# Renomear colunas.
	dados = dados_base.rename(columns={
    	'StockCode': 'Id_produto',
    	'Description': 'Produto',
    	'Quantity': 'Quantidade',
    	'InvoiceDate': 'Data',
    	'Price': 'Preço',
    	'Customer ID': 'Id_cliente',
    	'Country': 'Localização'
	})
    
	# Cria coluna Total Vendido.
	dados['Total_vendido'] = dados['Quantidade'] * dados['Preço']
    
	# Remove valores nulos.
	dados = dados.dropna()
    
	# Alterando os valores negativos das notas canceladas para 0
	dados.loc[dados['Invoice'].str.contains('C'), ['Quantidade', 'Preço', 'Total_vendido']] = 0
    
	# Alterando localização para o país
	dados.loc[dados['Localização'].str.contains('European Community'), ['Localização']] = 'Belgium'
    
	# Excluindo valores inconsistentes
	dados.drop(dados[dados['Id_produto'].str.contains('TEST')].index, inplace=True)
	dados.drop(dados[dados['Localização'].str.contains('Unspecified')].index, inplace=True)
    
	return dados
```

</details>

<h4>Inconsistências encontradas nos dados:</h4>

- Dados nulos nas colunas Description e Customer ID.
- Nomes de países não especificados na coluna Country.
- Códigos que não eram atribuídos a produtos na coluna StockCode.
- Invoices canceladas com dados de quantidade negativos.

<details>
<summary><b>1. Carregando os dados:<b></summary>

Os dados foram carregados a partir de um arquivo xlsx, dividido em duas planilhas Year 2009-2010 e Year 2010-2011, para carregar os dados foi implementado uma função que lê e uni as duas tabelas em um único Dataframe, a base de dados tem 8 colunas e 1.067.371 linhas.

![Base Original](/imagens/outros/image1.png)

</details>

<details>
<summary><b>2. Transformando e tratando os dados:</b></summary>

Após os tratamentos e transformações na base de dados original, agora temos uma base com 9 colunas e 823.349 linhas.

![Base Tratada](/imagens/outros/image2.png)

</details>

<h4>Checklist das ações feitas na base de dados:</h4>

- [x] Redefinição dos nomes das colunas.
- [x] Adição da coluna Total_vendido.
- [x] Remoção do dado país "Unspecified".
- [x] Redefinição da localização "European Community" para "Belgium".
- [x] Remoção dos produtos especificados como "TEST".
- [x] Remoção dos dados nulos.


**3. Modelando tabelas para carga no banco de dados relacional:**

<p><h4>Usando a base de dados já tratada, agora vamos criar tabelas para o banco de dados relacional, a partir da base tratada. Para o auxilio desta tarefa, foram implementadas funções para criação de cada tabela, como podemos ver abaixo:</h4></p>

<details>
<summary><b>Função cria_tabela_clientes()</b></summary>

>A função **`cria_tabela_clientes()`** retorna um novo objeto ***DataFrame*** **`clientes`**, após realizar seleção das colunas ***Id_cliente e Localização***, os dados recebem um complemento de informações usando a biblioteca ***Faker***, que será usado para gerar nomes e emails, para os clientes e complementar os dados na tabela, por fim, o ***DataFrame*** é estruturado e  suas colunas são ordenadas. O parâmetro **`dados_base=`** recebe o objeto ***DataFrame*** da base de dados já tratada.

```
def cria_tabela_clientes(dados_base:'DataFrame') -> 'DataFrame':
	# Criando cópia da base original.
	dados_copia = dados_base.copy()
	clientes_original = dados_copia[['Id_cliente', 'Localização']]
	clientes = clientes_original.copy()

	# Removendo Ids duplicados.
	clientes.drop_duplicates(
    	subset=['Id_cliente'],
    	keep='first',
    	inplace=True
	)
    
	# Convertendo Ids para inteiro.
	clientes['Id_cliente'] = clientes['Id_cliente'].astype(int)

	# Ordenando coluna ids.
	clientes = clientes.sort_values(
    	by='Id_cliente',
    	ascending=True
	)
    
	# Definindo uma semente para a função Faker.
	Faker.seed(10)
	faker = Faker()

	# Criando lista de nomes.
	nomes_clientes = []
	while len(nomes_clientes) < len(clientes):
    	nome_cliente = faker.company()
    	if nome_cliente not in nomes_clientes:
        	nomes_clientes.append(nome_cliente)

	# Criando emails.
	emails = []
	for name in nomes_clientes:
    	email = name.replace(",", "").lower() + "@email.com"
    	email = email.replace(" ", "")
    	emails.append(email)

	clientes['Cliente'] = nomes_clientes
	clientes['Email'] = emails
	ordem_colunas = ['Id_cliente', 'Cliente', 'Email', 'Localização']
	clientes = clientes.reindex(columns=ordem_colunas)    

	return clientes

```
</details>

<details>
<summary><b>Função cria_tabela_vendas()</b></summary>

> A função **`cria_tabela_vendas()`** retorna um novo objeto ***DataFrame*** **`vendas`**, realiza a seleção das colunas ***Invoice, Id_cliente, Data e Total_vendido***, a coluna ***Id_cliente*** é convertida para inteiro e a coluna ***Data*** para o formato datetime, por fim a tabela é agrupada pela coluna ***Total_vendido*** e ordenada pela coluna ***Invoice***. O parâmetro **`dados_base=`** recebe o objeto ***DataFrame*** da base de dados já tradata.

```
def cria_tabela_vendas(dados_base:'DataFrame') -> 'DataFrame':
	# Criando cópia da base original.
	dados_copia = dados.copy()
	vendas_original = dados_copia[['Invoice', 'Id_cliente', 'Data', 'Total_vendido']]
	vendas = vendas_original.copy()
    
	# Transformando coluna Id_cliente em inteiro.
	vendas['Id_cliente'] = vendas['Id_cliente'].astype(int)

	# Convertendo data
	vendas['Data'] = vendas['Data'].dt.date
	vendas['Data'] = pd.to_datetime(vendas['Data'])

	# Agrupando vendas pelo total das vendas.
	vendas = vendas.groupby(['Invoice', 'Id_cliente', 'Data'])['Total_vendido'].sum().reset_index()

	vendas = vendas.sort_values('Invoice', ascending=True)

	return vendas
```
</details>

<details>
<summary><b>Função cria_tabela_produto()</b></summary>

> A função **`cria_tabela_produto()`** retorna um novo objeto ***DataFrame*** **`produtos`**, realiza a seleção das colunas ***Id_produto, Produto e Preço***, remove as duplicidades a partir da coluna ***Id_produto*** e ordenada a tabela pela coluna ***Id_produto***. O parâmetro **`dados_base=`** recebe o objeto ***DataFrame*** da base de dados já tratada.

```
def cria_tabela_produto(dados_base:'DataFrame') -> 'DataFrame':
	# Criando cópia da base original.
	dados_copia = dados.copy()
	produtos_original = dados_copia[['Id_produto', 'Produto', 'Preço']]
	produtos = produtos_original.copy()

	# Removendo duplicidades.
	produtos.drop_duplicates(
    	subset=['Id_produto'],
    	keep='first',
    	inplace=True
	)

	produtos['Id_produto'] = produtos['Id_produto'].astype(str)
	produtos = produtos.sort_values('Id_produto', ascending=True)

	return produtos
```

</details>

<details>
<summary><b>Função cria_tabela_itens_venda()</b></summary>

> A função **`cria_tabela_itens_venda()`** retorna um novo objeto ***DataFrame*** **`itens_venda`**, realiza a seleção das colunas ***Invoice, Id_produto, Quantidade, Preço e Total_vendido***, remove os produtos duplicados apartir da coluna ***Id_produto*** e por fim ordenada a tabela. O parâmetro **`dados_base=`** recebe o objeto ***DataFrame*** da base de dados já tratada.

```
def cria_tabela_itens_venda(dados_base:'DataFrame') -> 'DataFrame':
	# Criando cópia da base original.
	dados_copia = dados.copy()
	itens_venda = dados_copia[['Invoice', 'Id_produto', 'Quantidade', 'Preço', 'Total_vendido']]

	# Removendo produtos duplicados.
	itens_venda = itens_venda.groupby(['Invoice','Id_produto']).agg({
    	'Quantidade':   'sum',
    	'Preço':  	'first',
    	'Total_vendido': 'sum'
	}).reset_index()
    
	ordem_coluna = ['Invoice', 'Id_produto', 'Quantidade', 'Preço', 'Total_vendido']
	itens_venda = itens_venda.reindex(columns=ordem_coluna)

	return itens_venda
```
</details>

<h3>Tabelas criadas:</h3>

<details>
<summary><b>1. Clientes:</b></summary>

![Base Clientes](/imagens/outros/image3.png)

> **NOTA**
>
> A base de dados original não contém os nomes dos clientes e nenhuma outra informação, além de ID e País,
> por esse motivo adicionamos, de maneira representativa, nomes e emails para os clientes, isso ajudará na análise
> e deixa as informações mais organizadas.


</details>

<details>
<summary><b>2. Vendas:</b></summary>

![Vendas](/imagens/outros/image4.png)

</details>

<details>
<summary><b>3. Produtos:</b></summary>

![Produtos](/imagens/outros/image5.png)

</details>

<details>
<summary><b>4. Itens Venda:</b></summary>

![Itens Venda](/imagens/outros/image6.png)

</details>

<h4>Checklist das tabelas criadas para o modelo relacional:</h4>

- [x] clientes.
- [x] vendas.
- [x] produtos.
- [x] itens venda.


## Modelagem do banco de dados
<p>A modelagem de banco de dados é o processo de criar uma representação estruturada dos dados que serão armazenados em um banco de dados. Essa representação é conhecida como modelo de dados e é crucial para garantir a eficiência, integridade e facilidade de manutenção do banco de dados.</p>
<p>Para o processo de modelagem do banco de dados, foram implementadas funções tanto para o banco de dados relacional quanto para o data warehouse, veja a seguir os detalhes de cada função.</p>

<details> 
<summary><b>Função conecta_db_postgres()</b></summary>

> A função **`conecta_db_postgres()`** recebe no parâmetro **`banco_dados=`** uma tupla com os dados de acesso ao banco de dados, e retorna uma tupla com o *conector* e *cursor* do banco de dados.

```
def conecta_db_postgres(acesso:tuple) -> tuple:
    # Conectando ao SGBD.
    conn = psycopg2.connect(host=acesso[0],
                            database=acesso[1],
                            user=acesso[2],
                            password=acesso[3])

    # Commit automático.
    conn.autocommit = True

    cursor = conn.cursor()

    return conn, cursor
```
</details>

<details> 
<summary><b>Função finaliza_conexao_postgres()</b></summary>

>  A função **`finaliza_conexao_postgres()`** recebe o *conector* no parâmetro **`conn=`** e o *cursor* no parâmetro **`cursor=`**, e assim realiza o fim da conexão com o banco de dados.

```
def finaliza_conexao_postgres(cursor:'cursor', conn:'connection') -> None:
    cursor.close()
    conn.close()

    return None
```
</details>
<details> 
<summary><b>Função cria_db()</b></summary>

> A função **`cria_db()`** recebe uma tupla com os dados de acesso no parâmetro **`banco_dados=`** e uma string no parâmetro **`novo_banco_dados=`**, a função realiza a criação de um novo banco de dados no PostgreSQL.

```
def cria_db(banco_dados:tuple, novo_banco_dados:str) -> None:
    conn, cursor = conecta_db_postgres(acesso=banco_dados)

    cursor.execute("SELECT datname FROM pg_database WHERE datname = %s", (novo_banco_dados,))
    row = cursor.fetchall()

    if row:
        print(f'ATENÇÃO: Banco de dados {novo_banco_dados} já existe!')
    else:
        cursor.execute("CREATE DATABASE %s;", (AsIs(novo_banco_dados),))
        print(f'Banco de dados {novo_banco_dados} criado!')

    finaliza_conexao_postgres(cursor=cursor, conn=conn)

    return None
```
</details>
<details> 
<summary><b>Função cria_schema_db()</b></summary>

> A função **`cria_schema_db()`**, no parâmetro **`banco_dados=`**, recebe uma tupla com dados de acesso do banco, e no parâmetro **`novo_schema=`**, recebe uma string com o nome do schema, o resultado é a criação de um novo schema no banco de dados.

```
def cria_schema_db(banco_dados:tuple, novo_schema:str) -> None:
    conn, cursor = conecta_db_postgres(acesso=banco_dados)

    cursor.execute("SELECT schema_name FROM information_schema.schemata WHERE schema_name = %s", (novo_schema,))
    row = cursor.fetchall()

    if row:
        print(f'ATENÇÃO: Schema {novo_schema} já existe!')
    else:
        cursor.execute("CREATE SCHEMA %s;", (AsIs(novo_schema),))
        print(f'SCHEMA {novo_schema} criado!')

    finaliza_conexao_postgres(cursor=cursor, conn=conn)

    return None
```
</details>
<details> 
<summary><b>Função cria_tabelas_banco_dados_relacional()</b></summary>

> A função **`cria_tabelas_banco_dados_relacional()`** recebe os parâmetros **`banco_dados=tuple, schema=str, nova_tabela=str, colunas_tabela=list, tabela_dados=DataFrame, query_cria_tabela=str, query_inseri_dados=str e numero_linhas=int`**, para criar uma nova tabela em um banco de dados e inserir dados na tabela, o retorno da função é uma tupla com a consulta de n linhas e suas dimensões.

```
def cria_tabelas_banco_dados_relacional(banco_dados:tuple, schema:str, nova_tabela:str, colunas_tabela:list,
                                        tabela_dados:'DataFrame', query_cria_tabela:str, query_inseri_dados:str,
                                        numero_linhas:int) -> tuple:
    
    conn, cursor = conecta_db_postgres(acesso=banco_dados)

    cursor.execute("""SELECT EXISTS (SELECT *
                      FROM information_schema.tables
                      WHERE table_schema = %s AND table_name = %s );""", (schema, nova_tabela,))
    tabela_existe = cursor.fetchone()[0]
    
    if tabela_existe:
        print(f'ATENÇÃO: A tabela {nova_tabela} já existe!')
        
        cursor.execute("""SELECT * FROM %s.%s;""", (AsIs(schema,), AsIs(nova_tabela,),))
        rows = cursor.fetchall()
        consulta_sql = pd.DataFrame(rows, columns=colunas_tabela)
        
    else:
        print(f"Tabela {nova_tabela} criada!")

        cursor.execute(query_cria_tabela)
        
        lista = tuple(tabela_dados.values)
        for linha in lista:
            cursor.execute(query_inseri_dados, linha)
        
        cursor.execute("""SELECT * FROM %s.%s;""",(AsIs(schema,), AsIs(nova_tabela,),))
        rows = cursor.fetchall()
        consulta_sql = pd.DataFrame(rows, columns=colunas_tabela)
        
    finaliza_conexao_postgres(cursor, conn)

    return consulta_sql.head(numero_linhas), consulta_sql.shape
```
</details>
<details>
<summary><b>Função cria_tabelas_banco_dados_dimensional()</b></summary>

> A função **`cria_tabelas_banco_dados_dimensional()`** recebe os parâmetros **`banco_dados=tuple, schema=str, nova_tabela=str, colunas_tabela=list, query_cria_tabela=str, query_inseri_dados=str e numero_linhas=int`**, para criar uma nova tabela em um banco de dados e inserir dados na tabela, o retorno da função é uma tupla com a consulta de n linhas e suas dimensões.

```
def cria_tabelas_banco_dados_dimensional(banco_dados:tuple, schema:str, nova_tabela:str, colunas_tabela:list,
                                         query_cria_tabela:str, query_inseri_dados:str, numero_linhas:int) -> tuple:

    conn, cursor = conecta_db_postgres(acesso=banco_dados)
    
    cursor.execute("""SELECT EXISTS (SELECT *
                      FROM information_schema.tables
                      WHERE table_schema = %s AND table_name = %s );""", (schema, nova_tabela,))
    tabela_existe = cursor.fetchone()[0]
    
    if tabela_existe:
        print(f'ATENÇÃO: A tabela {nova_tabela} já existe!')
        
        cursor.execute("""SELECT * FROM %s.%s;""", (AsIs(schema,), AsIs(nova_tabela,),))
        rows = cursor.fetchall()
        consulta_sql = pd.DataFrame(rows, columns=colunas_tabela)
        
    else:
        print(f"Tabela {nova_tabela} criada!")
        
        cursor.execute(query_cria_tabela)
        cursor.execute(query_inseri_dados)
        cursor.execute("""SELECT * FROM %s.%s;""",(AsIs(schema,), AsIs(nova_tabela,),))
        rows = cursor.fetchall()
        consulta_sql = pd.DataFrame(rows, columns=colunas_tabela)
        
    finaliza_conexao_postgres(cursor, conn)

    return consulta_sql.head(numero_linhas), consulta_sql.shape
```
</details>

## Criando DB Relacional - PostgreSQL:
> Um banco de dados relacional é um tipo de sistema de gerenciamento de banco de dados (DBMS) que organiza e armazena dados em tabelas com estruturas bem definidas. Ele é chamado de "relacional" porque estabelece relações entre os dados armazenados em diferentes tabelas. Essas relações são definidas por meio de chaves primárias e estrangeiras, que permitem que os dados sejam relacionados e consultados de maneira eficiente.

O Banco de dados Relacional aplicado para o setor de vendas da WGIFT será modelado conforme o diagrama.

![Relacional](/consultas_schemas_sql/Schema-Relacional.png)

### Criando banco de dados, schema relacional e tabelas:

<details>
<summary><b>Criando Banco de Dados e o Schema Relacional:</b></summary>

![Relacional](/imagens/outros/image7.png)

</details>

<details>
<summary><b>Criando Tabela Relacional Clientes:</b></summary>

![8](/imagens/outros/image8.png)
![9](/imagens/outros/image9.png)

</details>

<details>
<summary><b>Criando Tabela Relacional Vendas:</b></summary>

![11](/imagens/outros/image11.png)
![12](/imagens/outros/image12.png)

</details>

<details>
<summary><b>Criando Tabela Relacional Produtos:</b></summary>

![13](/imagens/outros/image13.png)
![14](/imagens/outros/image14.png)

</details>

<details>
<summary><b>Criando Tabela Relacional Itens Venda:</b></summary>

![15](/imagens/outros/image15.png)
![16](/imagens/outros/image16.png)

</details>

<h4>Checklist das ações realizadas:</h4>

- [x] Criação de um banco de dados.
- [x] Criação de um schema relacional.
- [x] Criação de tabelas relacionais com chaves primárias (PK) e chaves estrangeiras (FK).
- [x] Carga dos dados para as tabelas do banco relacional.

## Criando Data Wherehouse - PostgreSQL:

> Um banco de dados dimensional, é um tipo de sistema de gerenciamento de banco de dados projetado especificamente para suportar a análise e a geração de relatórios de dados de maneira eficiente. Esses bancos de dados são frequentemente usados em ambientes de data warehousing e business intelligence (BI) para atender às necessidades de tomada de decisões em organizações.

O Data Warehouse aplicado para o setor de vendas da WGIFT será modelado conforme o diagrama.

![Dimensional](/consultas_schemas_sql/Schema-Dimensional.png)

### Criando schema Dimensional e tabelas:

<details>
<summary><b>Criando Schema Dimensional:</b></summary>

![17](/imagens/outros/image17.png)

</details>

<details>
<summary><b>Criando Tabela Dimensional Clientes:</b></summary>

![18](/imagens/outros/image18.png)
![19](/imagens/outros/image19.png)

</details>

<details>
<summary><b>Criando Tabela Dimensional Produtos:</b></summary>

![20](/imagens/outros/image20.png)
![21](/imagens//outros/image21.png)

</details>
<details>
<summary><b>Criando Tabela Dimensional Calendario:</b></summary>

![22](/imagens/outros/image22.png)
![23](/imagens/outros/image23.png)

</details>
<details>
<summary><b>Criando Tabela Fato Vendas:</b></summary>

![24](/imagens/outros/image24.png)
![25](/imagens/outros/image25.png)

</details>

<h4>Checklist das ações realizadas:</h4>

- [x] Criação de um data warehouse.
- [x] Criação de tabelas relacionais com chaves primárias (PK) e chaves estrangeiras (FK).
- [x] Carga dos dados do banco relacional para o modelo dimensional do data warehouse.

### Funções para auxilio de análise:

<details>
<summary><b>Função consulta_sql():</b></summary>

>A função **consulta_sql()** recebe o acesso ao banco de dados em uma tupla no parâmetro **banco_dados=**, o parâmetro **query=** recebe uma query SQL no formato de string e o parâmetro **colunas=** recebe uma lista com o nome das colunas, que será usado no DataFrame que é o retorno da função.

```
def consulta_sql(banco_dados:tuple, query:str, colunas:list) -> 'DataFrame':
    conn, cursor = conecta_db_postgres(acesso=banco_dados)

    cursor.execute(query)
    rows = cursor.fetchall()
    consulta = pd.DataFrame(rows, columns=colunas)

    finaliza_conexao_postgres(cursor, conn)
    
    return consulta
```
</details>
<details>
<summary><b>Função grafico_pizza():</b></summary>

>A função **grafico_pizza()** recebe um DataFrame no parâmetro **dados=** e retorna um gráfico de pizza.

```
def grafico_pizza(dados:'DataFrame') -> None:
    # Criar rótulos personalizados com o ano e o valor do faturamento.
    labels = [f"{ano}: £ {faturamento:,.2f}" for ano,
              faturamento in zip(dados['Ano'], dados['Faturamento'])]

    f, ax = plt.subplots(figsize=(8, 8))
    ax.pie(dados['Faturamento'], autopct='%1.1f%%', pctdistance=1.1, labeldistance=1.5,
           wedgeprops=dict(width=0.30), colors=['#6E1423', '#A11D33', '#E01E37'])
    plt.legend(labels=labels, title='Ano e Faturamento',
               loc='center', prop={'size': 10})
    plt.title('Faturamento Anual')
    plt.show()

    return None
```
</details>
<details>
<summary><b>Função grafico_barras():</b></summary>

>A função **grafico_barras()** recebe no parâmetro **dados=** um DataFrame com os dados e no parâmetro **config_grafico=** recebe uma tupla com os dados de configuração do gráfico.

```
def grafico_barras(dados:'DataFrame', config_grafico:tuple) -> None:
    plt.figure(figsize=(12, 6))
    sns.barplot(x=dados[config_grafico[2]],
                y=dados[config_grafico[3]],
                orient=config_grafico[1],
                palette='flare')
    
    plt.ylabel(config_grafico[3])
    plt.xlabel(config_grafico[2])
    plt.title(config_grafico[0])
    plt.show()

    return None
```
</details>
<details>
<summary><b>Função grafico_mapa():</b></summary>

>A função **grafico_mapa()** recebe no parâmetro **dados=** um DataFrame com os dados e no parâmetro **zoom=** recebe um inteiro referente ao zoom do mapa.

```
def grafico_mapa(dados:'DataFrame', zoom:int) -> None: 
    # Coordenadas base para o centro do mapa.
    latitude_centro = 55.3781
    longitude_centro = 3.4360

    # Cria o mapa com base nas coordenadas do centro.
    mapa = folium.Map(location=[latitude_centro, longitude_centro],
                      zoom_start=zoom,
                      tiles='cartodbpositron',
                      prefer_canvas=True)

    # Função para obter as coordenadas geográficas dos países.
    def obter_coordenadas(pais):
        geolocator = Nominatim(user_agent="mapa_de_vendas")
        try:
            location = geolocator.geocode(pais)
            if location:
                return location.latitude, location.longitude
            else:
                return None
        except Exception as e:
            print(f"Erro ao obter coordenadas para {pais}: {e}")
            return None

    # Adiciona marcadores para cada país.
    for indice, linha in dados.iterrows():
        pais = linha['pais']
        vendas = linha['vendas']
        coordenadas = obter_coordenadas(pais)
        if coordenadas:
            popup_text = (f"País:{pais} Vendas:{vendas}")
            folium.Marker(coordenadas, popup=popup_text,
                          icon=folium.Icon(color='red',
                          icon='ok-sign'), tooltip=pais).add_to(mapa)

    # Exibe o mapa
    display(mapa)

    return None
```
</details>


## Hipóteses de análise levantadas:

<details>
<summary><b>1. Quantidades de Vendas Canceladas.</b></summary>

![Query 1](/imagens/graficos/canceladas.png)

</details>
<details>
<summary><b>2. O Faturamento Total.</b></summary>

![Faturamento](/imagens/graficos/faturamento.png)

</details>
<details>
<summary><b>3. Total Faturado nos Anos 2009, 2010 e 2011.</b></summary>

![qpie](/imagens/graficos/qpie.png)
![Pie](/imagens/graficos/pie.png)

</details>
<details>
<summary><b>4. Quantidade Total de Produtos Vendidos.</b></summary>

![Produtos](/imagens/graficos/produto.png)

</details>
<details>
<summary><b>5. Os 10 paises com mais clientes fora do Reino Unido.</b></summary>

![qcoluna](/imagens/graficos/qcoluna.png)
![Colunas](/imagens/graficos/colunas.png)

</details>
<details>
<summary><b>6. Os 10 maiores clientes.</b></summary>

![qbarra](/imagens/graficos/qbarra1.png)
![Barra 1](/imagens/graficos/barra1.png)

</details>
<details>
<summary><b>7. Os 10 produtos mais vendidos.</b></summary>

![qbarra2](/imagens/graficos/qbarra2.png)
![Barra 2](/imagens/graficos/barra2.png)

</details>
<details>
<summary><b>8. As 10 maiores notas emitidas.</b></summary>

![qbarra3](/imagens/graficos/qbarra3.png)
![Barra 3](/imagens/graficos/barra3.png)

</details>
<details>
<summary><b>9. Os 10 paises com mais vendas.</b></summary>

![qmapa](/imagens/graficos/qmapa.png)
![Mapa](/imagens/graficos/mapa.jpg)

</details>

## Construção do Dashboard de Monitoramento de Vendas:

O dashboard de monitoramento foi construido ouvindo quais eram as necessidades de informações que os gestores precisavam, desse modo, chegamos a lista de itens abaixo:

- Faturamento Total.
- Ticket Médio.
- Total de Invoices Emitidos.
- Total de Invoices Cancelados.
- Faturamento Mensal.
- Faturamento por Clientes.
- Faturamento por País.
- KPI de Faturamento vs Meta.
- Painel para Consultar Invoices.

## Conectando Power BI com PostgreSQL:
O primeiro passo para começarmos a desenvolver o dashboard de monitoramento de vendas, será conectar o Power BI Desktop com o PostgreSQL, conforme a imagem mostra abaixo:

![Conecta 1](/imagens/dashboard/conecta_bd_1.png)

Depois devemos informar o endereço do servidor e o banco de dados que desejamos conectar, como nos mostra a imagem abaixo:

![Conecta 2](/imagens/dashboard/conecta_db_2.png)

Agora devemos selecionar apenas as tabelas Dimensionais, pois essas correspondem ao nosso data warehouse, conforme a imagem:

![Conecta 3](/imagens/dashboard/conecta_db_3.png)

## Criando Medidas DAX e o Visual do Dashboard:
<p>Com a conexão já feita e as tabelas carregadas, podemos ir para o próximo passo que é a construção do nosso relatório.</p>
<p>Começando com os cartões, foram criadas medidas DAX (Data Analysis Expressions) para calcular e retornar os valores de forma precisa, as medidas criadas foram:</p>

![Cartoes](/imagens/dashboard/cartoes.png)

<details>
<summary><b>Função DAX Faturamento:</b></summary>

```
Faturamento = SUM(vendas[Total Vendido])
```
</details>

<details>
<summary><b>Função DAX Ticket Médio:</b></summary>

```
TicketMedio = IF(
    ISBLANK(
        DIVIDE([Faturamento], [Notas Emitidas] - [Notas Canceladas])),
        0,
        DIVIDE([Faturamento], [Notas Emitidas] - [Notas Canceladas]))
```
</details>

<details>
<summary><b>Função DAX Notas Emitidas:</b></summary>

```
Notas Emitidas = IF(
    ISBLANK(
        DISTINCTCOUNT(vendas[Invoice])),
        0,
        DISTINCTCOUNT(vendas[Invoice]))
```
</details>

<details>
<summary><b>Função DAX Notas Canceladas:</b></summary>

```
Notas Canceladas = IF(
        COUNTROWS(FILTER(vendas, LEFT(vendas[Invoice], 1) = "C")),
        COUNTROWS(FILTER(vendas, LEFT(vendas[Invoice], 1) = "C")),0)
```
</details>

<h4>Para facilitar a navegação do usuário, o acesso a página de consulta de invoices, será feita clicando no cartão "Notas Emitidas", ao clicar no cartão o usuário será encaminhado a página abaixo:</h4>

![Consulta](/imagens/dashboard/consulta.png)

<h4>Agora vamos para os gráficos de Clientes, Produtos e Paises:</h4>

![Graficos](/imagens/dashboard/graficosmenores.png)

Para esses visuais tivemos novas funções:

<details>
<summary><b>Função DAX Vendas Clientes:</b></summary>

```
Vendas Clientes = 
VAR vFiltro = CALCULATE([Faturamento],KEEPFILTERS(ALL(vendas[Clientes])))
RETURN
IF(
    vFiltro > 0,
    vFiltro,
    BLANK())
```
</details>
<details>
<summary><b>Função DAX Vendas Produtos:</b></summary>

```
Vendas Produtos = 
VAR vFiltro = CALCULATE([Faturamento],KEEPFILTERS(ALL(vendas[Produto])))
RETURN
IF(
    vFiltro > 0,
    vFiltro,
    BLANK())
```
</details>
<details>
<summary><b>Função DAX Total Vendido:</b></summary>

```
Total Vendido = SUM(vendas[Quantidade])
```
</details>
<details>
<summary><b>Função DAX Total Clientes:</b></summary>

```
Total Clientes = 
IF(
    ISBLANK(
        DISTINCTCOUNT(vendas[Clientes])),
        0,
        DISTINCTCOUNT(vendas[Clientes]))
```
</details>

<h4>Por fim, os gráficos de Faturamento Mensal e KPI:</h4>

![Faturamento Meta](/imagens/dashboard/fatmeta.png)

A função criada para o visual "Faturamento Mensal" foi a *Faturamento*, já para o KPI, vamo observar abaixo:

<details>
<summary><b>Função Meta Total:</b></summary>

```
Meta Total = IF(
    ISBLANK(
        SUM(Meta[Valor Meta])),
        0,
        SUM(Meta[Valor Meta]))
```

</details>

<h4>Essa função foi criada a partir da tabela "Meta", os valores de metas foram passados pela gestão, que correspondem a uma estimativa. Abaixo visualizamos a tabela:</h4>

![Tabela](/imagens/dashboard/tabelameta.png)

## Tooltips:

- Tooltip aplicado no gráfico de *Vendas Por Cliente*.

![tooltip1](/imagens/dashboard/tooltip1.png)

- Tooltip aplicado no gráfico de *Vendas por País*.

![tooltip2](/imagens/dashboard/tooltip2.png)

- Tooltip aplicado no gráfico de *Faturamento Mensal*.

![tooltip3](/imagens/dashboard/tooltip3.png)

Neste tooltip foram criadas funções para mostrar no gráfico *Faturamento Mensal*, abaixo estão os detalhes:

<details>
<summary><b>Função DAX Faturamento LM:</b></summary>

Essa função nos retorna o valor do faturamento do mês anterior.

```
Faturamento LM = 
IF(
    ISBLANK(
        CALCULATE(
            [Faturamento],
            PREVIOUSMONTH(Calendario[data])
        )
    ),
    0,
    CALCULATE(
        [Faturamento],
        PREVIOUSMONTH(Calendario[data])
    )
)
```
</details>
<details>
<summary><b>Função DAX % Variação:</b></summary>

Esta função trás a variação entre o valor do faturamento do mês anterior com o valor do faturamento do mês atual

```
% Variação = 
DIVIDE(
    [Faturamento] - [Faturamento LM], [Faturamento LM]
)
```
</details>
<details>
<summary><b>Função DAX Cor Tooltip:</b></summary>

Esta função é uma formatação condicional para a ser aplicada junto a função % Variação no visual.

```
Cor Tooltip = 
IF(
    [% Variação] >= 0,
    "Green",
    "Red"
)
```
</details>

## Conclusão:

Com a implementação deste projeto, a empresa WGIFT E-Commerce passa a ter controle sobre a integridade dos seus dados,  usá-los de maneira estratégica, obter insights para as equipes dos setores de vendas e marketing e planejar com mais segurança os objetivos da empresa.

## Referências

<details>
<summary>Expandir</summary>

- Anaconda: https://docs.anaconda.com/index.html
- Python: https://docs.python.org/pt-br/3/
- Pandas: https://pandas.pydata.org/docs/
- Faker: https://faker.readthedocs.io/en/master/
- psycopg2: https://www.psycopg.org/docs/
- Seaborn: https://seaborn.pydata.org/
- Matplotlib: https://matplotlib.org/
- Folium: https://python-visualization.github.io/folium/latest/
- geopy: https://geopy.readthedocs.io/en/stable/
- Power BI: https://learn.microsoft.com/pt-br/power-bi/
- UC Irvine Machine Learning Repository : Chen,Daqing. (2019). Online Retail II. UCI Machine Learning Repository. https://doi.org/10.24432/C5CG6D.
</details>


