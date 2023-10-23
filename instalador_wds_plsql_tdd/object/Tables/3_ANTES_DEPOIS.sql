

-- Tabela: ANTES_DEPOIS
-- Descrição: Armazena todos os testes que serão realizados, um mesmo ALVO pode possuir vários testes


CREATE TABLE ANTES_DEPOIS 
(
  POSICAO NUMBER NOT NULL 
, FK_TESTE_ID NUMBER NOT NULL 
, FK_TESTE_ACAO_ID NUMBER NOT NULL 
, ACAO VARCHAR2(6) NOT NULL
, DATA_REGISTRO DATE DEFAULT SYSDATE NOT NULL
);



ALTER TABLE ANTES_DEPOIS ADD CONSTRAINT ANTES_DEPOIS_FK_TESTE_ID FOREIGN KEY ( FK_TESTE_ID ) REFERENCES TESTE ( ID ) ENABLE;


ALTER TABLE ANTES_DEPOIS ADD CONSTRAINT ANTES_DEPOIS_FK_TESTE_ACAO_ID FOREIGN KEY ( FK_TESTE_ACAO_ID ) REFERENCES TESTE ( ID ) ENABLE;


ALTER TABLE ANTES_DEPOIS ADD CONSTRAINT ANTES_DEPOIS_ACAO_CHK CHECK ( ACAO IN ( 'ANTES', 'DEPOIS' ) ) ENABLE;


ALTER TABLE ANTES_DEPOIS ADD CONSTRAINT ANTES_DEPOIS_TESTE_UK UNIQUE ( FK_TESTE_ID, FK_TESTE_ACAO_ID, ACAO ) ENABLE;





COMMENT ON TABLE ANTES_DEPOIS IS '--

-- Armazena as ações que devem ser executadas ANTES ou DEPOIS do TESTE
--
-- Autor: Wesley David Santos
-- Skype: wesleydavidsantos		
-- https://www.linkedin.com/in/wesleydavidsantos
--';

COMMENT ON COLUMN ANTES_DEPOIS.POSICAO IS 'Identificador da ordem de execução entre os testes do mesmo tipo';

COMMENT ON COLUMN ANTES_DEPOIS.FK_TESTE_ID IS 'Identificador do teste Principal';

COMMENT ON COLUMN ANTES_DEPOIS.FK_TESTE_ACAO_ID IS 'Identificador do teste que deve ser executado Antes ou Depois';

COMMENT ON COLUMN ANTES_DEPOIS.ACAO IS 'Informa o momento de ação da execução, sendo Antes ou Depois';

COMMENT ON COLUMN ANTES_DEPOIS.DATA_REGISTRO IS 'Data de cadastro da ação';

COMMENT ON COLUMN TESTE.DATA_ALTERADO_DDL IS 'Data em que o código do teste foi alterado';