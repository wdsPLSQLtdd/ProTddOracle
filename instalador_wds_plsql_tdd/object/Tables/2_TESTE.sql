

-- Tabela: TESTE
-- Descrição: Armazena todos os testes que serão realizados e todos os testes que são utilizados como auxiliares.
--            Todos os testes devem possuir um ALVO e um ALVO pode pertencer a vários Testes




--
-- Sequence para a definição do ID
CREATE SEQUENCE SEQ_TESTE START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;



CREATE TABLE TESTE 
(
  ID NUMBER DEFAULT SEQ_TESTE.NEXTVAL NOT NULL 
, FK_ALVO_ID NUMBER NOT NULL 
, NOME VARCHAR2(2000) NOT NULL 
, INFO VARCHAR2(4000) NOT NULL 
, DATA_REGISTRO DATE DEFAULT SYSDATE NOT NULL 
, DATA_ALTERADO_DDL VARCHAR2(19) NOT NULL 
, ASSERCAO VARCHAR2(500) NOT NULL
, QUERY_ARGUMENTO VARCHAR2(4000) NULL
, HASH_ARGUMENTO VARCHAR2(100) NULL
, VERSAO_TESTE NUMBER DEFAULT 1 NOT NULL
, AUXILIAR VARCHAR2(1) DEFAULT 'N' NOT NULL
, ATIVADO VARCHAR2(1) NOT NULL
, CONSTRAINT TESTE_PK PRIMARY KEY 
  (
    ID 
  )
  ENABLE 
);

ALTER TABLE TESTE ADD CONSTRAINT TESTE_NOME_UK UNIQUE ( NOME, ASSERCAO ) ENABLE;

ALTER TABLE TESTE ADD CONSTRAINT TESTE_ASSERCAO_UK UNIQUE ( ASSERCAO ) ENABLE;

ALTER TABLE TESTE ADD CONSTRAINT TESTE_FK_ALVO FOREIGN KEY ( FK_ALVO_ID ) REFERENCES ALVO ( ID ) ENABLE;

ALTER TABLE TESTE ADD CONSTRAINT TESTE_ATIVADO_CHK CHECK ( ATIVADO IN ( 'Y', 'N' ) ) ENABLE;




COMMENT ON TABLE TESTE IS '--

-- Armazena todos os testes que serão realizados e todos os testes que são utilizados como auxiliares.
-- Todos os testes devem possuir um ALVO e um ALVO pode pertencer a vários Testes
--
-- Autor: Wesley David Santos
-- Skype: wesleydavidsantos		
-- https://www.linkedin.com/in/wesleydavidsantos
--';

COMMENT ON COLUMN TESTE.ID IS 'Identificador único do TESTE';

COMMENT ON COLUMN TESTE.FK_ALVO_ID IS 'FK do ALVO';

COMMENT ON COLUMN TESTE.NOME IS 'Nome do teste. Deve ser único';

COMMENT ON COLUMN TESTE.INFO IS 'Descrição do objetivo do teste';

COMMENT ON COLUMN TESTE.DATA_REGISTRO IS 'Data em que o teste foi registrado';

COMMENT ON COLUMN TESTE.DATA_ALTERADO_DDL IS 'Data em que o código do teste foi alterado';

COMMENT ON COLUMN TESTE.ASSERCAO IS 'Nome da function responsável pelo teste';

COMMENT ON COLUMN TESTE.QUERY_ARGUMENTO IS 'Query que possui as informações de argumento a ser usado nos testes';

COMMENT ON COLUMN TESTE.HASH_ARGUMENTO IS 'Hash gerado sobre a query do argumento para facilitar a identificação da alteração do argumento';

COMMENT ON COLUMN TESTE.VERSAO_TESTE IS 'Versão do código de Teste. Aumenta a versão todas as vezes que o objeto do teste é compilado';

COMMENT ON COLUMN TESTE.AUXILIAR IS 'Informa se o teste é usado apenas como AUXILIAR de outro TESTE';

COMMENT ON COLUMN TESTE.ATIVADO IS 'Informa se o teste está ativado ou desativado';


