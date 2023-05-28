-- Excluir banco de dados caso já exista
DROP DATABASE IF EXISTS uvv;

-- Excluir usuário caso já exista
DROP USER IF EXISTS eduardo;

-- Criação do usuário
CREATE USER eduardo WITH CREATEDB INHERIT login password 'cc1mb';

-- Criação do banco de dados
CREATE DATABASE uvv
OWNER eduardo
TEMPLATE template0
ENCODING 'UTF8'
LC_COLLATE 'pt_BR.UTF-8'
LC_CTYPE 'pt_BR.UTF-8'
CONNECTION LIMIT -1
ALLOW_CONNECTIONS TRUE;

-- Conexão com o banco de dados
\c 'dbname=uvv user=eduardo password=cc1mb';

-- Criação do schema
CREATE SCHEMA lojas AUTHORIZATION eduardo;
ALTER USER eduardo SET search_path TO lojas, eduardo, public;

--criação da tabela clientes 

CREATE TABLE lojas.clientes (
                cliente_id             NUMERIC(38) NOT NULL,
                email                  VARCHAR(255) NOT NULL,
                nome                   VARCHAR(255) NOT NULL,
                telefone1              VARCHAR(20),
                telefone2              VARCHAR(20),
                telefone3              VARCHAR(20),
                CONSTRAINT clientes_pk PRIMARY KEY (cliente_id)
);
COMMENT ON TABLE lojas.clientes IS 'Tabela com informacoes dos clientes.';
COMMENT ON COLUMN lojas.clientes.cliente_id IS 'identificacao do cliente.';
COMMENT ON COLUMN lojas.clientes.email IS 'endereco de email do cliente.';
COMMENT ON COLUMN lojas.clientes.nome IS 'nome do cliente.';
COMMENT ON COLUMN lojas.clientes.telefone1 IS 'numero de telefone do cliente.';
COMMENT ON COLUMN lojas.clientes.telefone2 IS 'numero de telefone do cliente.';
COMMENT ON COLUMN lojas.clientes.telefone3 IS 'numero de telefone do cliente.';

ALTER TABLE    lojas.clientes 
ADD CONSTRAINT cc_clientes_cliente_id
CHECK          (cliente_id > 0);

--criação da tabela produtos

CREATE TABLE lojas.produtos (
                produto_id                NUMERIC(38) NOT NULL,
                nome                      VARCHAR(255) NOT NULL,
                preco_unitario            NUMERIC(10,2),
                detalhes                  BYTEA,
                imagem                    BYTEA,
                imagem_mime_type          VARCHAR(512),
                imagem_arquivo            VARCHAR(512),
                imagem_charset            VARCHAR(512),
                imagem_ultima_atualizacao DATE,
                CONSTRAINT pk_produtos    PRIMARY KEY (produto_id)
);
COMMENT ON TABLE lojas.produtos IS 'Tabela com a lista dos produtos que sao vendidos.';
COMMENT ON COLUMN lojas.produtos.produto_id IS 'identificacao do produto.';
COMMENT ON COLUMN lojas.produtos.nome IS 'nome do produto.';
COMMENT ON COLUMN lojas.produtos.preco_unitario IS 'preco por unidade de cada produto';
COMMENT ON COLUMN lojas.produtos.detalhes IS 'descricao do produto';
COMMENT ON COLUMN lojas.produtos.imagem IS 'imagem do produto.';
COMMENT ON COLUMN lojas.produtos.imagem_mime_type IS 'especificam o tipo de midia e a subcategoria da imagem.';
COMMENT ON COLUMN lojas.produtos.imagem_arquivo IS 'arquivo de imagem do produto.';
COMMENT ON COLUMN lojas.produtos.imagem_charset IS 'caracteres associada ao texto contido nessa imagem.';
COMMENT ON COLUMN lojas.produtos.imagem_ultima_atualizacao IS 'ultima vez que a imagem foi atualizada.';

ALTER TABLE    lojas.produtos
ADD CONSTRAINT cc_produtos_preco_unitario 
CHECK          (preco_unitario > 0);

ALTER TABLE    lojas.produtos
ADD CONSTRAINT cc_produtos_produto_id
CHECK          (produto_id > 0);

ALTER TABLE    lojas.produtos
ADD CONSTRAINT cc_produtos_imagem
CHECK          ((imagem           is not null
AND            imagem_mime_type is not null
AND            imagem_arquivo    is not null 
AND            imagem_charset    is not null)
OR             (imagem           is null
AND            imagem_mime_type is null
AND            imagem_arquivo    is null 
AND            imagem_charset    is null));

--criação da tabela lojas

CREATE TABLE lojas.lojas (
                loja_id                 NUMERIC(38) NOT NULL,
                nome                    VARCHAR(255) NOT NULL,
                endereco_web            VARCHAR(100),
                endereco_fisico         VARCHAR(512),
                latitude                NUMERIC,
                longitude               NUMERIC,
                logo                    BYTEA,
                logo_mime_type          VARCHAR(512),
                logo_arquivo            VARCHAR(512),
                logo_charset            VARCHAR(512),
                logo_ultima_atualizacao DATE,
                CONSTRAINT pk_lojas     PRIMARY KEY (loja_id)
);
COMMENT ON TABLE lojas.lojas IS 'Tabela com as informacoes das lojas.';
COMMENT ON COLUMN lojas.lojas.loja_id IS 'Numero de identificacao da loja .Primary key da tabela lojas.';
COMMENT ON COLUMN lojas.lojas.nome IS 'nome da loja.';
COMMENT ON COLUMN lojas.lojas.endereco_web IS 'edereco da loja na internet.';
COMMENT ON COLUMN lojas.lojas.endereco_fisico IS 'endereco comercial da loja.';
COMMENT ON COLUMN lojas.lojas.latitude IS 'coordenada geografica';
COMMENT ON COLUMN lojas.lojas.longitude IS 'coordenada geografica';
COMMENT ON COLUMN lojas.lojas.logo IS 'logo da loja .';
COMMENT ON COLUMN lojas.lojas.logo_mime_type IS 'especificam o tipo de midia e a subcategoria da logo.';
COMMENT ON COLUMN lojas.lojas.logo_arquivo IS 'arquivo de imagem da logo.';
COMMENT ON COLUMN lojas.lojas.logo_charset IS 'caracteres associada ao texto contido nessa logo.';
COMMENT ON COLUMN lojas.lojas.logo_ultima_atualizacao IS 'data da ultima atualizacao da logo.';

ALTER TABLE    lojas.lojas
ADD CONSTRAINT cc_lojas_logo
CHECK          ((logo          is not null
AND            logo_mime_type  is not null
AND            logo_arquivo    is not null 
AND            logo_charset    is not null)
OR             (logo           is null
AND            logo_mime_type  is null
AND            logo_arquivo    is null 
AND            logo_charset    is null));

ALTER TABLE    lojas.lojas
ADD CONSTRAINT cc_lojas_endereco_web
CHECK          (endereco_web ~ '^(https?|ftp)://[^\s/$.?#].[^\s]*$');

ALTER TABLE    lojas.lojas 
ADD CONSTRAINT cc_lojas_endereco_fisico_web
CHECK          (endereco_fisico is not null
OR             endereco_web     is not null);

--criação da tabela pedidos

CREATE TABLE lojas.pedidos (
                pedido_id             NUMERIC(38) NOT NULL,
                data_hora             TIMESTAMP NOT NULL,
                cliente_id            NUMERIC(38) NOT NULL,
                status                VARCHAR(15) NOT NULL,
                loja_id               NUMERIC(38) NOT NULL,
                CONSTRAINT pedidos_pk PRIMARY KEY (pedido_id)
);
COMMENT ON TABLE lojas.pedidos IS 'Tabela com os pedidos realizados.';
COMMENT ON COLUMN lojas.pedidos.pedido_id IS 'identificacao do pedido.';
COMMENT ON COLUMN lojas.pedidos.data_hora IS 'dia e hora que o pedido foi realizado.';
COMMENT ON COLUMN lojas.pedidos.cliente_id IS 'identificacao do cliente.';
COMMENT ON COLUMN lojas.pedidos.status IS 'status do pedido.';
COMMENT ON COLUMN lojas.pedidos.loja_id IS 'identificacao da loja.';

ALTER TABLE    lojas.pedidos
ADD CONSTRAINT cc_pedidos_pedido_id
CHECK          (pedido_id > 0);

ALTER TABLE    lojas.pedidos
ADD CONSTRAINT cc_pedidos_cliente_id
CHECK          (cliente_id > 0);

ALTER TABLE    lojas.pedidos
ADD CONSTRAINT cc_pedidos_loja_id
CHECK          (loja_id > 0);

ALTER TABLE    lojas.pedidos
ADD CONSTRAINT cc_pedidos_status
CHECK          (status IN  ('CANCELADO', 'COMPLETO', 'ABERTO', 'PAGO', 'REEMBOLSADO', 'ENVIADO'));

--criação da tabela pedidos_itens

CREATE TABLE lojas.pedidos_itens (
                pedido_id                   NUMERIC(38) NOT NULL,
                produto_id                  NUMERIC(38) NOT NULL,
                numero_da_linha             NUMERIC(38) NOT NULL,
                preco_unitario              NUMERIC(10,2) NOT NULL,
                quantidade                  NUMERIC(38) NOT NULL,
                envio_id                    NUMERIC(38) NOT NULL,
                CONSTRAINT pk_pedidos_itens PRIMARY KEY (pedido_id, produto_id)
);
COMMENT ON TABLE lojas.pedidos_itens IS 'Tabela com a quantidade de itens que foram pedidos.';
COMMENT ON COLUMN lojas.pedidos_itens.pedido_id IS 'identificacao de um pedido.';
COMMENT ON COLUMN lojas.pedidos_itens.produto_id IS 'identificacao de um produto.';
COMMENT ON COLUMN lojas.pedidos_itens.preco_unitario IS 'valor de cada unidade.';
COMMENT ON COLUMN lojas.pedidos_itens.quantidade IS 'quantidade de um produto no pedido.';
COMMENT ON COLUMN lojas.pedidos_itens.envio_id IS 'identificacao do envio.';

ALTER TABLE     lojas.pedidos_itens
ADD CONSTRAINT  cc_pedidos_itens_pedido_id
CHECK           (pedido_id > 0);

ALTER TABLE     lojas.pedidos_itens
ADD CONSTRAINT  cc_pedidos_itens_produto_id
CHECK           (produto_id > 0);

ALTER TABLE     lojas.pedidos_itens
ADD CONSTRAINT  cc_pedidos_itens_preco_unitario
CHECK           (preco_unitario > 0);

ALTER TABLE     lojas.pedidos_itens
ADD CONSTRAINT  cc_pedidos_itens_quantidade
CHECK           (quantidade > 0);

ALTER TABLE     lojas.pedidos_itens
ADD CONSTRAINT  cc_pedidos_itens_envio_id
CHECK           (envio_id > 0);

--criação da tabela envios

CREATE TABLE lojas.envios (  
                envios_id            NUMERIC(38) NOT NULL,
                loja_id              NUMERIC(38) NOT NULL,
                cliente_id           NUMERIC(38) NOT NULL,
                endereco_entrega     VARCHAR(512) NOT NULL,
                status VARCHAR(15)   NOT NULL,
                CONSTRAINT envios_pk PRIMARY KEY (envios_id)
);
COMMENT ON TABLE lojas.envios IS 'Tabela com as informacoes de envio de um pedido.';
COMMENT ON COLUMN lojas.envios.envios_id IS 'identificacao de um envio';
COMMENT ON COLUMN lojas.envios.cliente_id IS 'identificacao de um cliente.';
COMMENT ON COLUMN lojas.envios.endereco_entrega IS 'endereco para realizar a entrega.';
COMMENT ON COLUMN lojas.envios.status IS 'status da entrega.';

ALTER TABLE    lojas.envios
ADD CONSTRAINT cc_envios_envios_id
CHECK          (envios_id > 0);

ALTER TABLE    lojas.envios
ADD CONSTRAINT cc_envios_loja_id
CHECK          (loja_id > 0);

ALTER TABLE    lojas.envios
ADD CONSTRAINT cc_envios_cliente_id
CHECK          (cliente_id > 0);

ALTER TABLE    lojas.envios
ADD CONSTRAINT cc_envios_status
CHECK          (status IN ('CRIADO', 'ENVIADO', 'TRANSITO', 'ENTREGUE'));

--criação da tabela estoques

CREATE TABLE lojas.estoques (
                estoque_id             NUMERIC(38) NOT NULL,
                loja_id                NUMERIC(38) NOT NULL,
                produto_id             NUMERIC(38) NOT NULL,
                quantidade             NUMERIC(38) NOT NULL,
                CONSTRAINT pk_estoques PRIMARY KEY (estoque_id)
);
COMMENT ON TABLE lojas.estoques IS 'Tabela com a quantidade de produtos no estoque.';
COMMENT ON COLUMN lojas.estoques.estoque_id IS 'identificacao do estoque.';
COMMENT ON COLUMN lojas.estoques.loja_id IS 'Numero de identificacao da loja .Primary key da tabela lojas.';
COMMENT ON COLUMN lojas.estoques.produto_id IS 'numero de identificacao do produto.';
COMMENT ON COLUMN lojas.estoques.quantidade IS 'quantidade de um produto no estoque.';

ALTER TABLE    lojas.estoques 
ADD CONSTRAINT cc_estoques_estoque_id
CHECK          (estoque_id > 0);

ALTER TABLE    lojas.estoques 
ADD CONSTRAINT cc_estoques_loja_id
CHECK          (loja_id > 0);

ALTER TABLE    lojas.estoques 
ADD CONSTRAINT cc_estoques_produto_id
CHECK          (produto_id > 0);

ALTER TABLE    lojas.estoques 
ADD CONSTRAINT cc_estoques_quantidade
CHECK          (quantidade > 0);

--criação do relacionamento entre as tabelas 

ALTER TABLE lojas.envios ADD CONSTRAINT clientes_envios_fk
FOREIGN KEY (cliente_id)
REFERENCES lojas.clientes (cliente_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE lojas.pedidos ADD CONSTRAINT clientes_pedidos_fk
FOREIGN KEY (cliente_id)
REFERENCES  lojas.clientes (cliente_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE lojas.estoques ADD CONSTRAINT produtos_estoques_fk
FOREIGN KEY (produto_id)
REFERENCES  lojas.produtos (produto_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE lojas.pedidos_itens ADD CONSTRAINT produtos_pedidos_itens_fk
FOREIGN KEY (produto_id)
REFERENCES  lojas.produtos (produto_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE lojas.estoques ADD CONSTRAINT lojas_estoques_fk
FOREIGN KEY (loja_id)
REFERENCES  lojas.lojas (loja_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE lojas.envios ADD CONSTRAINT lojas_envios_fk
FOREIGN KEY (loja_id)
REFERENCES  lojas.lojas (loja_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE lojas.pedidos ADD CONSTRAINT lojas_pedidos_fk
FOREIGN KEY (loja_id)
REFERENCES  lojas.lojas (loja_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE lojas.pedidos_itens ADD CONSTRAINT pedidos_pedidos_itens_fk
FOREIGN KEY (pedido_id)
REFERENCES  lojas.pedidos (pedido_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;