

-- Tabela: TESTE_EM_EXECUCAO
-- Descrição: Armazena de forma temporária os testes que estão em execução, desta forma evita que o mesmo Teste seja processado de forma paralela


CREATE TABLE TESTE_EM_EXECUCAO
(
  FK_TESTE_ID NUMBER NOT NULL
, DATA_INICIO DATE DEFAULT SYSDATE NOT NULL 
);


ALTER TABLE TESTE_EM_EXECUCAO ADD CONSTRAINT TESTE_EM_EXECUCAO_FK_TESTE_ID FOREIGN KEY ( FK_TESTE_ID ) REFERENCES TESTE ( ID ) ENABLE;

ALTER TABLE TESTE_EM_EXECUCAO ADD CONSTRAINT TESTE_EM_EXECUCAO_UK UNIQUE ( FK_TESTE_ID ) ENABLE;


COMMENT ON TABLE TESTE_EM_EXECUCAO IS '--

-- Armazena de forma temporária os testes que estão em execução, desta forma evita que o mesmo Teste seja processado de forma paralela
--
-- Autor: Wesley David Santos
-- Skype: wesleydavidsantos		
-- https://www.linkedin.com/in/wesleydavidsantos
--';


COMMENT ON COLUMN TESTE_EM_EXECUCAO.FK_TESTE_ID IS 'Identificação do teste';

COMMENT ON COLUMN TESTE_EM_EXECUCAO.DATA_INICIO IS 'Data de execução do teste';
